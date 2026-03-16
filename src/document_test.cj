package rapidjson4cj

import std.collection.enumerate

// cjlint-ignore -start !G.FUN.01 function should be less than 50 lines of code
// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestRapidJsonDocument {
    @TestCase
    func test_comprehensive_document_features() {
        let json = #"
        {
            "id": 9007199254740993,
            "source": "RapidJSON",
            "active": true,
            "price": 19.95,
            "tags": ["native", "fast", "safe"],
            "profile": {
                "username": "cj_user",
                "verified": false,
                "score": 100,
                "permissions": []
            },
            "nullable": null,
            "emptyString": "",
            "emptyArray": [],
            "emptyObject": {},
            "mixedNumbers": [
                -1,
                -2147483648,
                42,
                2147483648,
                9223372036854775807,
                18446744073709551615,
                3.14,
                "not_a_number",
                true
            ]
        }
        "#

        let doc = Document(json)

        // Lifecycle & Root Checks

        @Expect(!doc.isClosed())
        @Expect(doc.isObject())
        @Expect(!doc.isArray())
        @Expect(!doc.isNull())
        @Expect(!doc.isString())
        @Expect(!doc.isBool())
        @Expect(!doc.isNumber())

        // Root Key Access: Type Checks (is...)

        // Positive checks

        @Expect(doc.isInt64("id"))
        @Expect(doc.isString("source"))
        @Expect(doc.isBool("active"))
        @Expect(doc.isFloat64("price"))
        @Expect(doc.isArray("tags"))
        @Expect(doc.isObject("profile"))
        @Expect(doc.isNull("nullable"))

        // Corner Case: Empty Strings and Containers

        @Expect(doc.isString("emptyString"))
        @Expect(doc.isArray("emptyArray"))
        @Expect(doc.isObject("emptyObject"))

        // Negative checks (Type Mismatch)

        @Expect(!doc.isString("id")) // Number is not String
        @Expect(!doc.isInt32("id")) // Int64 is not Int32
        @Expect(!doc.isArray("source")) // String is not Array
        @Expect(!doc.isObject("active")) // Bool is not Object
        @Expect(!doc.isNull("price")) // Number is not Null
        @Expect(!doc.isBool("emptyArray")) // Array is not Bool

        // Negative checks (Missing Keys)
        @Expect(!doc.isString("missing_key"))
        @Expect(!doc.isInt64("missing_key"))

        // Root Key Access: Retrieval (get...)

        // Get Success

        @Expect(doc.getInt64("id"), Some(9007199254740993))
        @Expect(doc.getString("source"), Some("RapidJSON"))
        @Expect(doc.getBool("active"), Some(true))
        @Expect(doc.getFloat64("price"), Some(19.95))

        // Corner Case: Retrieving Empty Values

        match (doc.getString("emptyString")) {
            case Some(s) =>
                @Expect(s.size, 0)
                @Expect(s, "")
            case None => @Fail("Expected empty string to return Some(\"\")")
        }

        // Corner Case: Empty Array Retrieval

        match (doc.getArray("emptyArray")) {
            case Some(arr) =>
                @Expect(arr.isArray())
                @Expect(arr.size(), 0)
                // Verify iterator yields nothing
                var count = 0
                for (_ in arr.arrayIterator()) {
                    count++
                }
                @Expect(count, 0)
            case None => @Fail("Expected empty array to return Some([])")
        }

        // Corner Case: Empty Object Retrieval

        match (doc.getObject("emptyObject")) {
            case Some(obj) =>
                @Expect(obj.isObject())
                @Expect(obj.memberCount(), 0)
                // Verify iterator yields nothing
                var count = 0
                for (_ in obj.memberIterator()) {
                    count++
                }
                @Expect(count, 0)
            case None => @Fail("Expected empty object to return Some({})")
        }

        // Get Mismatch (Returns None)

        @Expect(doc.getString("id").isNone()) // Number is not String
        @Expect(doc.getInt32("id").isNone()) // Int64 is not Int32

        // Get Missing (Returns None)
        @Expect(doc.getString("missing_key").isNone())

        // Nested Object Traversal

        match (doc.getObject("profile")) {
            case Some(profile) =>
                @Expect(profile.isObject())

                for ((index, member) in profile.memberIterator() |> enumerate) {
                    match (index) {
                        case 0 =>
                            // "username": "cj_user"
                            @Expect(member.name.getString(), Some("username"))
                            @Expect(member.value.isString())
                            @Expect(member.value.getString(), Some("cj_user"))
                        case 1 =>
                            // "verified": false
                            @Expect(member.name.getString(), Some("verified"))
                            @Expect(member.value.isBool())
                            @Expect(member.value.getBool(), Some(false))
                        case 2 =>
                            // "score": 100
                            @Expect(member.name.getString(), Some("score"))
                            @Expect(member.value.isInt32())
                            @Expect(member.value.getInt32(), Some(100i32))
                            // Also check it is Int64 compatible
                            @Expect(member.value.isInt64())
                            @Expect(member.value.getInt64(), Some(100i64))
                        case 3 =>
                            // "permissions": []
                            @Expect(member.name.getString(), Some("permissions"))
                            @Expect(member.value.isArray())
                            @Expect(member.value.size(), 0)
                        case _ => @Fail("Unexpected member found in profile")
                    }
                }
            case None => @Fail("Failed to get profile object")
        }

        // Deep Number Logic & Type Validation (w/ Enumeration)

        match (doc.getArray("mixedNumbers")) {
            case Some(arr) =>
                @Expect(arr.isArray())
                @Expect(arr.size(), 9)

                for ((index, item) in arr.arrayIterator() |> enumerate) {
                    match (index) {
                        case 0 =>
                            // -1: Negative Int
                            @Expect(item.isNumber())
                            @Expect(item.isInt64())
                            @Expect(item.isInt32())
                            @Expect(!item.isUInt32())
                            @Expect(item.getInt64(), Some(-1))
                            @Expect(item.size(), 0) // 0 when not array
                            @Expect(item.memberCount(), 0) // 0 when not object
                        case 1 =>
                            // -2147483648: Int32 Min
                            @Expect(item.isInt32())
                            @Expect(item.getInt32(), Some(-2147483648i32))
                        case 2 =>
                            // 42: Small Positive
                            @Expect(item.isInt32())
                            @Expect(item.isUInt32())
                            @Expect(item.getInt32(), Some(42i32))
                        case 3 =>
                            // 2147483648: Exceeds Int32, fits UInt32/Int64
                            @Expect(!item.isInt32())
                            @Expect(item.isUInt32())
                            @Expect(item.getUInt32(), Some(2147483648u32))
                        case 4 =>
                            // 9223372036854775807: Int64 Max
                            @Expect(item.isInt64())
                            @Expect(item.getInt64(), Some(9223372036854775807))
                        case 5 =>
                            // 18446744073709551615: UInt64 Max
                            @Expect(item.isUInt64())
                            @Expect(!item.isInt64())
                            @Expect(item.getUInt64(), Some(18446744073709551615u64))
                        case 6 =>
                            // 3.14: Float
                            @Expect(item.isFloat64())
                            @Expect(!item.isInt64())
                            @Expect(item.getFloat64(), Some(3.14))
                        case 7 =>
                            // "not_a_number"
                            @Expect(!item.isNumber())
                            @Expect(item.isString())
                        case 8 =>
                            // true
                            @Expect(!item.isNumber())
                            @Expect(item.isBool())
                        case _ => @Fail("Unexpected item found")
                    }
                }
            case None => @Fail("Failed to get mixedNumbers array")
        }

        // Member Iteration

        var memberCount = 0
        for (m in doc.memberIterator()) {
            memberCount++
            @Expect(m.name.isString())
            @Expect(m.value.handle.isNotNull())
        }
        @Expect(memberCount, 11)
        @Expect(doc.memberCount(), 11)

        // Cleanup

        doc.close()
        @Expect(doc.isClosed())
    }

    @TestCase
    func test_parse_invalid_json_missing_brace() {
        let json = #"{"key": "value""#
        @ExpectThrows[RapidJsonException](Document(json))
    }

    @TestCase
    func test_parse_invalid_json_syntax() {
        let json = #"this is not json"#
        @ExpectThrows[RapidJsonException](Document(json))
    }

    @TestCase
    func test_parse_document_empty() {
        let json = #""#
        try {
            let doc = Document(json)
            doc.close()
        } catch (ex: RapidJsonException) {
            @Expect(ex.code == ParseErrorCode.DocumentEmpty)
        }
    }

    @TestCase
    func test_parse_document_root_not_singular() {
        let json = #"{} {}"#
        try {
            let doc = Document(json)
            doc.close()
        } catch (ex: RapidJsonException) {
            @Expect(ex.code == ParseErrorCode.DocumentRootNotSingular)
        }
    }

    @TestCase
    func test_parse_number_too_big() {
        let json = #"{"num": 1e309}"#
        try {
            let doc = Document(json)
            doc.close()
        } catch (ex: RapidJsonException) {
            @Expect(ex.code == ParseErrorCode.NumberTooBig)
        }
    }

    @TestCase
    func test_exception_properties() {
        let json = #"{"a": }"# // Invalid value
        try {
            let doc = Document(json)
            doc.close()
        } catch (ex: RapidJsonException) {
            @Expect(ex.code == ParseErrorCode.ValueInvalid)
            @Expect(ex.offset >= 0)
            @Expect(ex.message.size > 0)
        }
    }

    @TestCase
    func test_close_idempotent() {
        let json = #"{"test": true}"#
        let doc = Document(json)
        @Expect(!doc.isClosed())
        doc.close()
        @Expect(doc.isClosed())
        doc.close() // Should not crash
        @Expect(doc.isClosed())
    }
}

// cjlint-ignore -end function names should be lower camel case
// cjlint-ignore -end function should be less than 50 lines of code
