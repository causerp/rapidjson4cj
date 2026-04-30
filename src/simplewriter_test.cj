package rapidjson4cj

// cjlint-ignore -start !G.FUN.01 function should be less than 50 lines of code
// cjlint-ignore -start !G.NAM.04 function names should be lower camel case

@Test
class TestRapidJsonSimpleWriter {
    @TestCase
    func test_minified_writer_default_constructor() {
        try (writer = SimpleWriter()) {
            @Expect(!writer.isClosed())
            @Expect(!writer.isComplete())

            writer.startObject()
            writer.writeName("key")
            writer.writeString("value")
            writer.endObject()

            @Expect(writer.isComplete())
            @Expect(writer.getString(), #"{"key":"value"}"#)

            writer.close()
            @Expect(writer.isClosed())
        }
    }

    @TestCase
    func test_all_primitive_types() {
        try (writer = SimpleWriter()) {
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
            let expected = #"[null,true,false,-2147483648,4294967295,-9223372036854775808,18446744073709551615,3.140000104904175,2.71828]"#
            @Expect(writer.getString(), expected)
        }
    }

    @TestCase
    func test_empty_containers_and_strings() {
        try (writer = SimpleWriter()) {
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
            @Expect(writer.getString(), #"{"emptyString":"","emptyArray":[],"emptyObject":{}}"#)
        }
    }

    @TestCase
    func test_decimal_places_configuration() {
        try (writer = SimpleWriter()) {
            writer.startArray()
            writer.writeFloat64(3.14159265358979323846)
            writer.endArray()
            let defaultStr = writer.getString()
            @Expect(defaultStr.startsWith("[3."))
        }

        try (writer = SimpleWriter()) {
            writer.setMaxDecimalPlaces(2)
            writer.startArray()
            writer.writeFloat64(3.14159265358979323846)
            writer.endArray()
            @Expect(writer.getString(), "[3.14]")
        }
    }

    @TestCase
    func test_incomplete_json_states() {
        try (writer = SimpleWriter()) {
            @Expect(!writer.isComplete())

            writer.startObject()
            @Expect(!writer.isComplete())

            writer.writeName("key")
            @Expect(!writer.isComplete())

            @Expect(writer.getString(), #"{"key""#)
        }
    }

    @TestCase
    func test_close_idempotent() {
        let writer = SimpleWriter()
        @Expect(!writer.isClosed())

        writer.close()
        @Expect(writer.isClosed())

        writer.close()
        @Expect(writer.isClosed())
    }
}

// cjlint-ignore -end function names should be lower camel case
// cjlint-ignore -end function should be less than 50 lines of code
