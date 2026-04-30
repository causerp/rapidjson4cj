package rapidjson4cj

// cjlint-ignore -start !G.FUN.01 function should be less than 50 lines of code
// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestRapidJsonPrettyWriter {
    @TestCase
    func test_minified_writer_default_constructor() {
        try (writer = PrettyWriter()) {
            @Expect(!writer.isClosed())
            @Expect(!writer.isComplete())

            writer.startObject()
            writer.writeName("key")
            writer.writeString("value")
            writer.endObject()

            @Expect(writer.isComplete())
            @Expect(writer.getString(), #"{
  "key": "value"
}"#)

            writer.close()
            @Expect(writer.isClosed())
        }
    }

    @TestCase
    func test_pretty_writer_explicit_options() {
        try (writer = PrettyWriter(4, FormatOptions.Default)) {
            writer.startObject()
            writer.writeName("array")
            writer.startArray()
            writer.writeInt64(1)
            writer.writeString("two")
            writer.endArray()
            writer.endObject()

            @Expect(writer.isComplete())
            let expected = #"{
    "array": [
        1,
        "two"
    ]
}"#
            @Expect(writer.getString(), expected)
        }
    }

    @TestCase
    func test_single_line_array_formatting() {
        try (writer = PrettyWriter(2, FormatOptions.SingleLineArray)) {
            writer.startObject()
            writer.writeName("id")
            writer.writeInt64(9007199254740993)
            writer.writeName("tags")
            writer.startArray()
            writer.writeString("native")
            writer.writeString("fast")
            writer.endArray()
            writer.writeName("nested")
            writer.startObject()
            writer.writeName("active")
            writer.writeBool(true)
            writer.endObject()
            writer.endObject()

            @Expect(writer.isComplete())
            let expected = #"{
  "id": 9007199254740993,
  "tags": ["native", "fast"],
  "nested": {
    "active": true
  }
}"#
            @Expect(writer.getString(), expected)
        }
    }

    @TestCase
    func test_all_primitive_types() {
        try (writer = PrettyWriter()) {
            writer.startArray()
            writer.writeNullValue()
            writer.writeBool(true)
            writer.writeBool(false)
            writer.writeInt64(-2147483648)
            writer.writeInt64(4294967295)
            writer.writeInt64(-9223372036854775808)
            writer.writeUInt64(18446744073709551615)
            writer.writeFloat32(3.14f32)
            writer.writeFloat64(2.71828)
            writer.endArray()

            @Expect(writer.isComplete())
            let expected = #"[
  null,
  true,
  false,
  -2147483648,
  4294967295,
  -9223372036854775808,
  18446744073709551615,
  3.140000104904175,
  2.71828
]"#
            @Expect(writer.getString(), expected)
        }
    }

    @TestCase
    func test_empty_containers_and_strings() {
        try (writer = PrettyWriter()) {
            writer.startObject()
            writer.writeName("emptyString")
            writer.writeString("")
            writer.writeName("emptyArray")
            writer.startArray()
            writer.endArray()
            writer.writeName("emptyObject")
            writer.startObject()
            writer.endObject()
            writer.endObject()

            @Expect(writer.isComplete())
            @Expect(writer.getString(), #"{
  "emptyString": "",
  "emptyArray": [],
  "emptyObject": {}
}"#)
        }
    }

    @TestCase
    func test_decimal_places_configuration() {
        try (writer = PrettyWriter()) {
            writer.startArray()
            writer.writeFloat64(3.14159265358979323846)
            writer.endArray()
            let defaultStr = writer.getString()
            @Expect(defaultStr.startsWith("[\n  3."))
        }

        try (writer = PrettyWriter()) {
            writer.setMaxDecimalPlaces(2)
            writer.startArray()
            writer.writeFloat64(3.14159265358979323846)
            writer.endArray()
            @Expect(writer.getString(), "[\n  3.14\n]")
        }
    }

    @TestCase
    func test_indent_configuration_mid_stream() {
        try (writer = PrettyWriter(0, FormatOptions.SingleLineArray)) {
            writer.startObject()
            writer.writeName("minified")
            writer.writeBool(true)

            writer.writeName("singleLineArray")
            writer.startArray()
            writer.writeInt64(1)
            writer.writeInt64(2)
            writer.endArray()

            writer.setFormatOptions(FormatOptions.Default)
            writer.setIndent(4)

            writer.writeName("pretty")
            writer.startObject()
            writer.writeName("nestedArray")
            writer.startArray()
            writer.writeInt64(1)
            writer.writeInt64(2)
            writer.endArray()
            writer.endObject()

            writer.endObject()

            @Expect(writer.isComplete())
            let expected = #"{
"minified": true,
"singleLineArray": [1, 2],
    "pretty": {
        "nestedArray": [
            1,
            2
        ]
    }
}"#
            @Expect(writer.getString(), expected)
        }
    }

    @TestCase
    func test_incomplete_json_states() {
        try (writer = PrettyWriter()) {
            @Expect(!writer.isComplete())

            writer.startObject()
            @Expect(!writer.isComplete())

            writer.writeName("key")
            @Expect(!writer.isComplete())

            @Expect(writer.getString(), "{\n  \"key\"")
        }
    }

    @TestCase
    func test_close_idempotent() {
        let writer = PrettyWriter()
        @Expect(!writer.isClosed())

        writer.close()
        @Expect(writer.isClosed())

        writer.close()
        @Expect(writer.isClosed())
    }
}

// cjlint-ignore -end function names should be lower camel case
// cjlint-ignore -end function should be less than 50 lines of code
