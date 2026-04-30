package rapidjson4cj

import std.collection.{enumerate, HashMap}

// cjlint-ignore -start !G.FUN.01 function should be less than 50 lines of code
// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestRapidJsonValue {
    let mainJson = #"
    {
        "id": 9007199254740993,
        "source": "RapidJSON & test",
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

    @TestCase
    func test_comprehensive_document_features() {
        let value = JsonValue(mainJson)

        // Lifecycle & Root Checks

        @Expect(!value.isClosed())
        @Expect(value.isRoot())
        @Expect(value.isObject())
        @Expect(!value.isArray())
        @Expect(!value.isNull())
        @Expect(!value.isString())
        @Expect(!value.isBool())
        @Expect(!value.isNumber())

        // Root Key Access: Type Checks (is...)

        // Positive checks

        @Expect(value.isInt64("id"))
        @Expect(value.isString("source"))
        @Expect(value.isBool("active"))
        @Expect(value.isFloat64("price"))
        @Expect(value.isArray("tags"))
        @Expect(value.isObject("profile"))
        @Expect(value.isNull("nullable"))

        // Corner Case: Empty Strings and Containers

        @Expect(value.isString("emptyString"))
        @Expect(value.isArray("emptyArray"))
        @Expect(value.isObject("emptyObject"))

        // Negative checks (Type Mismatch)

        @Expect(!value.isString("id")) // Number is not String
        @Expect(!value.isInt32("id")) // Int64 is not Int32
        @Expect(!value.isArray("source")) // String is not Array
        @Expect(!value.isObject("active")) // Bool is not Object
        @Expect(!value.isNull("price")) // Number is not Null
        @Expect(!value.isBool("emptyArray")) // Array is not Bool

        // Negative checks (Missing Keys)
        @Expect(!value.isString("missing_key"))
        @Expect(!value.isInt64("missing_key"))

        // Root Key Access: Retrieval (get...)

        // Get Success

        @Expect(value.get("id").isSome())
        @Expect(value.getInt64("id"), Some(9007199254740993))
        @Expect(value.getString("source"), Some("RapidJSON & test"))
        @Expect(value.getBool("active"), Some(true))
        @Expect(value.getFloat64("price"), Some(19.95))
        @Expect(value.get("price")?.getFloat64() ?? 0.0, Some(19.95))

        // Corner Case: Retrieving Empty Values

        match (value.getString("emptyString")) {
            case Some(s) =>
                @Expect(s.size, 0)
                @Expect(s, "")
            case None => @Fail("Expected empty string to return Some(\"\")")
        }

        // Corner Case: Empty Array Retrieval

        match (value.getArray("emptyArray")) {
            case Some(arr) =>
                @Expect(arr.isArray())
                @Expect(arr.size, 0)
                // Verify iterator yields nothing
                var count = 0
                for (_ in arr) {
                    count++
                }
                @Expect(count, 0)
            case None => @Fail("Expected empty array to return Some([])")
        }

        // Corner Case: Empty Object Retrieval

        match (value.getObject("emptyObject")) {
            case Some(obj) =>
                @Expect(obj.isObject())
                @Expect(obj.memberSize, 0)
                // Verify iterator yields nothing
                var count = 0
                for (_ in obj.memberIterator()) {
                    count++
                }
                @Expect(count, 0)
            case None => @Fail("Expected empty object to return Some({})")
        }

        // Get Mismatch (Returns None)

        @Expect(value.getString("id").isNone()) // Number is not String
        @Expect(value.getInt32("id").isNone()) // Int64 is not Int32

        // Get Missing (Returns None)
        @Expect(value.getString("missing_key").isNone())

        // Nested Object Traversal

        match (value.getObject("profile")) {
            case Some(profile) =>
                @Expect(profile.isObject())
                @Expect(!profile.isRoot())

                for ((index, member) in profile.memberIterator() |> enumerate) {
                    match (index) {
                        case 0 =>
                            // "username": "cj_user"
                            @Expect(member.getName(), "username")
                            @Expect(member.value.isString())
                            @Expect(member.value.getString(), Some("cj_user"))
                        case 1 =>
                            // "verified": false
                            @Expect(member.getName(), "verified")
                            @Expect(member.value.isBool())
                            @Expect(member.value.getBool(), Some(false))
                        case 2 =>
                            // "score": 100
                            @Expect(member.getName(), "score")
                            @Expect(member.value.isInt32())
                            @Expect(member.value.getInt32(), Some(100i32))
                            // Also check it is Int64 compatible
                            @Expect(member.value.isInt64())
                            @Expect(member.value.getInt64(), Some(100i64))
                        case 3 =>
                            // "permissions": []
                            @Expect(member.getName(), "permissions")
                            @Expect(member.value.isArray())
                            @Expect(member.value.size, 0)
                        case _ => @Fail("Unexpected member found in profile")
                    }
                }
            case None => @Fail("Failed to get profile object")
        }

        // Deep Number Logic & Type Validation (w/ Enumeration)

        match (value.getArray("mixedNumbers")) {
            case Some(arr) =>
                @Expect(arr.isArray())
                @Expect(arr.size, 9)

                for ((index, item) in arr |> enumerate) {
                    match (index) {
                        case 0 =>
                            // -1: Negative Int
                            @Expect(item.isNumber())
                            @Expect(item.isInt64())
                            @Expect(item.isInt32())
                            @Expect(!item.isUInt32())
                            @Expect(item.getInt64(), Some(-1))
                            @Expect(item.size, 0) // 0 when not array
                            @Expect(item.memberSize, 0) // 0 when not object
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

        var memberSize = 0
        for (m in value.memberIterator()) {
            memberSize++
            @Expect(m.name.isString())
            @Expect(m.value.handle.isNotNull())
        }
        @Expect(memberSize, 11)
        @Expect(value.memberSize, 11)

        // clone

        if (let Some(clone) <- value.getObject("profile")?.clone()) {
            @Expect(clone.isRoot())
            @Expect(clone.getString("username"), Some("cj_user"))
            @Expect(clone.getBool("verified"), Some(false))
            @Expect(clone.getInt64("score"), Some(100))
            clone.close()
            @Expect(clone.isClosed())
            @Expect(!value.isClosed())
        }

        // toString

        @Expect(value.getObject("profile")?.toString(), Some(#"{"username":"cj_user","verified":false,"score":100,"permissions":[]}"#))
        @Expect(value.getObject("profile")?.toPrettyString(), Some(#"{
  "username": "cj_user",
  "verified": false,
  "score": 100,
  "permissions": []
}"#))

        // Cleanup

        value.close()
        @Expect(value.isClosed())
    }

    @TestCase
    func test_parse_invalid_json_missing_brace() {
        let json = #"{"key": "value""#
        @ExpectThrows[RapidJsonParseException](JsonValue(json))
    }

    @TestCase
    func test_parse_invalid_json_syntax() {
        let json = #"this is not json"#
        @ExpectThrows[RapidJsonParseException](JsonValue(json))
    }

    @TestCase
    func test_parse_document_empty() {
        let json = #""#
        try (value = JsonValue(json)) {
        } catch (ex: RapidJsonParseException) {
            @Expect(ex.code == ParseErrorCode.DocumentEmpty)
        }
    }

    @TestCase
    func test_parse_document_root_not_singular() {
        let json = #"{} {}"#
        try (value = JsonValue(json)) {
            value.close()
        } catch (ex: RapidJsonParseException) {
            @Expect(ex.code == ParseErrorCode.DocumentRootNotSingular)
        }
    }

    @TestCase
    func test_parse_number_too_big() {
        let json = #"{"num": 1e309}"#
        try (value = JsonValue(json)) {
        } catch (ex: RapidJsonParseException) {
            @Expect(ex.code == ParseErrorCode.NumberTooBig)
        }
    }

    @TestCase
    func test_exception_properties() {
        let json = #"{"a": }"# // Invalid value
        try (value = JsonValue(json)) {
        } catch (ex: RapidJsonParseException) {
            @Expect(ex.code == ParseErrorCode.ValueInvalid)
            @Expect(ex.offset >= 0)
            @Expect(ex.message.size > 0)
        }
    }

    @TestCase
    func test_close_idempotent() {
        let json = #"{"test": true}"#
        let value = JsonValue(json)
        @Expect(!value.isClosed())
        value.close()
        @Expect(value.isClosed())
        value.close() // Should not crash
        @Expect(value.isClosed())
    }

    @TestCase
    func test_document_setters() {
        let value = JsonValue("{}")
        @Expect(value.isObject())

        value.setNull()
        @Expect(value.isNull())
        @Expect(!value.isObject())

        value.setBool(true)
        @Expect(value.isBool())
        @Expect(value.getBool(), Some(true))

        value.set(false)
        @Expect(value.getBool(), Some(false))

        value.setInt32(-42)
        @Expect(value.isInt32())
        @Expect(value.getInt32(), Some(-42i32))

        value.setUInt32(42u32)
        @Expect(value.isUInt32())
        @Expect(value.getUInt32(), Some(42u32))

        value.setInt64(-9223372036854775807)
        @Expect(value.isInt64())
        @Expect(!value.isInt32())
        @Expect(value.getInt64(), Some(-9223372036854775807))

        value.setUInt64(18446744073709551615u64)
        @Expect(value.isUInt64())
        @Expect(!value.isInt64())
        @Expect(value.getUInt64(), Some(18446744073709551615u64))

        value.setFloat32(3.14f32)
        @Expect(value.isFloat32())
        @Expect(value.isNumber())
        @Expect(value.getFloat32(), Some(3.14f32))

        value.setFloat64(19.95)
        @Expect(value.isFloat64())
        @Expect(value.getFloat64(), Some(19.95))

        value.setString("RapidJSON")
        @Expect(value.isString())
        @Expect(!value.isNumber())
        @Expect(value.getString(), Some("RapidJSON"))

        value.set("")
        @Expect(value.getString(), Some(""))
        @Expect(value.getString()?.size, 0)

        value.close()
    }

    @TestCase
    func test_array_modifications() {
        try (value = JsonValue(mainJson)) {
            match (value.getArray("tags")) {
                case Some(arr) =>
                    // Add elements
                    arr.addString("updated")
                    arr.addBool(true)
                    arr.addInt64(999)
                    @Expect(arr.size, 6)
                    @Expect(arr.getString(3), Some("updated"))
                    @Expect(arr.getBool(4), Some(true))
                    @Expect(arr.getInt64(5), Some(999))

                    // Pop
                    @Expect(arr.pop())
                    @Expect(arr.size, 5)

                    // Erase by index
                    @Expect(arr.eraseArrayItem(0)) // "native"
                    @Expect(arr.getString(0), Some("fast"))

                    // Clear
                    @Expect(arr.clearArray())
                    @Expect(arr.size, 0)

                    // Reserve and Capacity
                    @Expect(arr.reserveArray(100))
                    @Expect(arr.getArrayCapacity() >= 100)

                case None => @Fail("tags array not found")
            }
        }
    }

    @TestCase
    func test_object_modifications() {
        try (value = JsonValue(mainJson)) {
            match (value.getObject("profile")) {
                case Some(obj) =>
                    // Add members
                    obj.addMemberString("location", "Earth")
                    obj.addMemberFloat64("latitude", 40.7128)
                    @Expect(obj.memberSize, 6)
                    @Expect(obj.getString("location"), Some("Earth"))
                    @Expect(obj.getFloat64("latitude"), Some(40.7128))

                    // Remove member (unordered)
                    @Expect(obj.hasMember("location"))
                    @Expect(obj.removeMember("location"))
                    @Expect(!obj.hasMember("location"))
                    @Expect(obj.memberSize, 5)

                    // Erase member (ordered)
                    obj.addMemberString("temp", "delete_me")
                    obj.addMemberString("keep", "keep_me")
                    @Expect(obj.eraseMember("temp"))
                    @Expect(!obj.hasMember("temp"))
                    @Expect(obj.getString("keep"), Some("keep_me"))

                    // Clear
                    @Expect(obj.clearObject())
                    @Expect(obj.memberSize, 0)

                    // Reserve and Capacity
                    @Expect(obj.reserveObject(50))
                    @Expect(obj.getMemberCapacity() >= 50)

                    // Add complex types
                    let newArr = obj.addMemberArray("newArr")
                    @Expect(newArr.isArray())
                    newArr.addString("inner")

                    let newObj = obj.addMemberObject("newObj")
                    @Expect(newObj.isObject())

                case None => @Fail("profile object not found")
            }
        }
    }

    @TestCase
    func test_array_add_complex_types_and_setters() {
        try (value = JsonValue(mainJson)) {
            match (value.getArray("tags")) {
                case Some(arr) =>
                    arr.clearArray()

                    // Add Array to Array
                    let nestedArr = arr.addArray()
                    @Expect(nestedArr.isArray())
                    nestedArr.addInt32(1)
                    @Expect(arr[0].getArray()?.getInt32(0), Some(1i32))

                    // Add Object to Array
                    let nestedObj = arr.addObject()
                    @Expect(nestedObj.isObject())
                    nestedObj.addMemberBool("active", true)
                    @Expect(arr[1].getObject()?.getBool("active"), Some(true))

                    // Set array item (Get + Set pattern)
                    arr.addString("mutable")
                    @Expect(arr.getString(2), Some("mutable"))
                    arr[2].setInt64(12345)
                    @Expect(arr.getInt64(2), Some(12345))

                case None => @Fail("tags array not found")
            }
        }
    }

    @TestCase
    func test_object_add_complex_types_and_setters() {
        try (value = JsonValue(mainJson)) {
            match (value.getObject("profile")) {
                case Some(obj) =>
                    // Add Array to Object
                    let objArr = obj.addMemberArray("history")
                    @Expect(objArr.isArray())
                    objArr.addString("login")
                    @Expect(obj.getArray("history")?.getString(0), Some("login"))

                    // Add Object to Object
                    let objObj = obj.addMemberObject("settings")
                    @Expect(objObj.isObject())
                    objObj.addMemberString("theme", "dark")
                    @Expect(obj.getObject("settings")?.getString("theme"), Some("dark"))

                    // Set member item (Get + Set pattern)
                    obj.addMemberString("status", "pending")
                    @Expect(obj.getString("status"), Some("pending"))
                    obj["status"].setString("active")
                    @Expect(obj.getString("status"), Some("active"))

                case None => @Fail("profile object not found")
            }
        }
    }

    @TestCase
    func test_array_and_object_set_initializers() {
        try (value = JsonValue("{}")) {
            // Initialize Array
            value.setArray()
            @Expect(value.isArray())
            @Expect(value.size, 0)
            value.addBool(true)
            @Expect(value.getBool(0), Some(true))

            // Initialize Object
            value.setObject()
            @Expect(value.isObject())
            @Expect(value.memberSize, 0)
            value.addMemberString("key", "val")
            @Expect(value.getString("key"), Some("val"))
        }
    }
}

// cjlint-ignore -end function names should be lower camel case
// cjlint-ignore -end function should be less than 50 lines of code
