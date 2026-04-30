package rapidjson4cj

import cenum.CEnum

foreign {
    @FastNative
    func memcpy_s(dest: CPointer<UInt8>, destMax: UIntNative, src: CPointer<UInt8>, count: UIntNative): Int32

    // Document

    func RJ4CJDocument_parse(str: CPointer<UInt8>, length: UIntNative): DocumentParseResult

    func RJ4CJDocument_free(doc: CPointer<Unit>): Unit

    func RJ4CJDocument_clone(doc: CPointer<Unit>): CPointer<Unit>

    // General

    @FastNative
    func RJ4CJ_getParseError(error: ParseErrorCode): CString

    // Iterator

    @FastNative
    func RJ4CJValueIterator_next(it: CPointer<CPointer<Unit>>): CPointer<Unit>

    @FastNative
    func RJ4CJMemberIterator_next(it: CPointer<CPointer<Unit>>): JsonMemberInternal

    // Value

    @FastNative
    func RJ4CJValue_isNull(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isBool(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isNumber(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isInt32(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isUInt32(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isInt64(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isUInt64(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isFloat32(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isFloat64(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isString(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isArray(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_isObject(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_getBool(value: CPointer<Unit>, outValue: CPointer<Bool>): Bool

    @FastNative
    func RJ4CJValue_getInt32(value: CPointer<Unit>, outValue: CPointer<Int32>): Bool

    @FastNative
    func RJ4CJValue_getUInt32(value: CPointer<Unit>, outValue: CPointer<UInt32>): Bool

    @FastNative
    func RJ4CJValue_getInt64(value: CPointer<Unit>, outValue: CPointer<Int64>): Bool

    @FastNative
    func RJ4CJValue_getUInt64(value: CPointer<Unit>, outValue: CPointer<UInt64>): Bool

    @FastNative
    func RJ4CJValue_getFloat32(value: CPointer<Unit>, outValue: CPointer<Float32>): Bool

    @FastNative
    func RJ4CJValue_getFloat64(value: CPointer<Unit>, outValue: CPointer<Float64>): Bool

    @FastNative
    func RJ4CJValue_getString(value: CPointer<Unit>): StringView

    @FastNative
    func RJ4CJValue_getStringLength(value: CPointer<Unit>): UInt32

    @FastNative
    func RJ4CJValue_setNull(value: CPointer<Unit>): Unit

    @FastNative
    func RJ4CJValue_setBool(value: CPointer<Unit>, newValue: Bool): Unit

    @FastNative
    func RJ4CJValue_setInt32(value: CPointer<Unit>, newValue: Int32): Unit

    @FastNative
    func RJ4CJValue_setUInt32(value: CPointer<Unit>, newValue: UInt32): Unit

    @FastNative
    func RJ4CJValue_setInt64(value: CPointer<Unit>, newValue: Int64): Unit

    @FastNative
    func RJ4CJValue_setUInt64(value: CPointer<Unit>, newValue: UInt64): Unit

    @FastNative
    func RJ4CJValue_setFloat32(value: CPointer<Unit>, newValue: Float32): Unit

    @FastNative
    func RJ4CJValue_setFloat64(value: CPointer<Unit>, newValue: Float64): Unit

    @FastNative
    func RJ4CJValue_setString(rootDoc: CPointer<Unit>, value: CPointer<Unit>, newValue: CPointer<UInt8>, length: UInt32): Unit

    @FastNative
    func RJ4CJValue_setArray(value: CPointer<Unit>): Unit

    @FastNative
    func RJ4CJValue_arrayGet(value: CPointer<Unit>, index: Int64): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arraySize(value: CPointer<Unit>): UInt32

    @FastNative
    func RJ4CJValue_arrayBegin(value: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayEnd(value: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddNull(root: CPointer<Unit>, value: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddBool(root: CPointer<Unit>, value: CPointer<Unit>, val: Bool): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddInt32(root: CPointer<Unit>, value: CPointer<Unit>, val: Int32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddUInt32(root: CPointer<Unit>, value: CPointer<Unit>, val: UInt32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddInt64(root: CPointer<Unit>, value: CPointer<Unit>, val: Int64): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddUInt64(root: CPointer<Unit>, value: CPointer<Unit>, val: UInt64): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddFloat32(root: CPointer<Unit>, value: CPointer<Unit>, val: Float32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddFloat64(root: CPointer<Unit>, value: CPointer<Unit>, val: Float64): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddString(root: CPointer<Unit>, value: CPointer<Unit>, str: CPointer<UInt8>, length: UInt32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddArray(root: CPointer<Unit>, value: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayAddObject(root: CPointer<Unit>, value: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJValue_arrayPop(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_arrayClear(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_arrayErase(value: CPointer<Unit>, index: UInt32): Bool

    @FastNative
    func RJ4CJValue_arrayReserve(root: CPointer<Unit>, value: CPointer<Unit>, newCapacity: UInt32): Bool

    @FastNative
    func RJ4CJValue_arrayCapacity(value: CPointer<Unit>): UInt32

    @FastNative
    func RJ4CJValue_setObject(value: CPointer<Unit>): Unit

    @FastNative
    func RJ4CJValue_memberContains(value: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJValue_memberGet(value: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberSize(value: CPointer<Unit>): UInt32

    @FastNative
    func RJ4CJValue_memberBegin(value: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberEnd(value: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddNull(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>, keyLength: UInt32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddBool(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>, keyLength: UInt32,
        val: Bool): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddInt32(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>, keyLength: UInt32,
        val: Int32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddUInt32(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>,
        keyLength: UInt32, val: UInt32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddInt64(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>, keyLength: UInt32,
        val: Int64): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddUInt64(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>,
        keyLength: UInt32, val: UInt64): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddFloat32(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>,
        keyLength: UInt32, val: Float32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddFloat64(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>,
        keyLength: UInt32, val: Float64): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddString(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>,
        keyLength: UInt32, str: CPointer<UInt8>, strLength: UInt32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddArray(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>, keyLength: UInt32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberAddObject(root: CPointer<Unit>, value: CPointer<Unit>, key: CPointer<UInt8>, keyLength: UInt32): CPointer<Unit>

    @FastNative
    func RJ4CJValue_memberClear(value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJValue_memberRemove(value: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJValue_memberErase(value: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJValue_memberReserve(root: CPointer<Unit>, value: CPointer<Unit>, newCapacity: UInt32): Bool

    @FastNative
    func RJ4CJValue_memberCapacity(value: CPointer<Unit>): UInt32

    // PrettyWriter

    func RJ4CJPrettyWriter_create(indentCharCount: UInt32, formatOptions: FormatOptions): CPointer<Unit>

    func RJ4CJPrettyWriter_destroy(writer: CPointer<Unit>): Unit

    @FastNative
    func RJ4CJPrettyWriter_isComplete(writer: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJPrettyWriter_getMaxDecimalPlaces(writer: CPointer<Unit>): Int32

    @FastNative
    func RJ4CJPrettyWriter_setIndent(writer: CPointer<Unit>, indentCharCount: UInt32): Unit

    @FastNative
    func RJ4CJPrettyWriter_setFormatOptions(writer: CPointer<Unit>, formatOptions: FormatOptions): Unit

    @FastNative
    func RJ4CJPrettyWriter_setMaxDecimalPlaces(writer: CPointer<Unit>, maxDecimalPlaces: Int32): Unit

    @FastNative
    func RJ4CJPrettyWriter_getString(writer: CPointer<Unit>): StringView

    @FastNative
    func RJ4CJPrettyWriter_writeNull(writer: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJPrettyWriter_writeBool(writer: CPointer<Unit>, b: Bool): Bool

    @FastNative
    func RJ4CJPrettyWriter_writeInt32(writer: CPointer<Unit>, i: Int32): Bool

    @FastNative
    func RJ4CJPrettyWriter_writeUInt32(writer: CPointer<Unit>, u: UInt32): Bool

    @FastNative
    func RJ4CJPrettyWriter_writeInt64(writer: CPointer<Unit>, i64: Int64): Bool

    @FastNative
    func RJ4CJPrettyWriter_writeUInt64(writer: CPointer<Unit>, u64: UInt64): Bool

    @FastNative
    func RJ4CJPrettyWriter_writeFloat32(writer: CPointer<Unit>, f: Float32): Bool

    @FastNative
    func RJ4CJPrettyWriter_writeFloat64(writer: CPointer<Unit>, d: Float64): Bool

    @FastNative
    func RJ4CJPrettyWriter_writeName(writer: CPointer<Unit>, str: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJPrettyWriter_writeString(writer: CPointer<Unit>, str: CPointer<UInt8>, length: UInt32): Bool

    func RJ4CJPrettyWriter_writeValue(writer: CPointer<Unit>, value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJPrettyWriter_startArray(writer: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJPrettyWriter_endArray(writer: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJPrettyWriter_startObject(writer: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJPrettyWriter_endObject(writer: CPointer<Unit>): Bool

    // Writer

    func RJ4CJWriter_create(): CPointer<Unit>

    func RJ4CJWriter_destroy(writer: CPointer<Unit>): Unit

    @FastNative
    func RJ4CJWriter_isComplete(writer: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJWriter_getMaxDecimalPlaces(writer: CPointer<Unit>): Int32

    @FastNative
    func RJ4CJWriter_setMaxDecimalPlaces(writer: CPointer<Unit>, maxDecimalPlaces: Int32): Unit

    @FastNative
    func RJ4CJWriter_getString(writer: CPointer<Unit>): StringView

    @FastNative
    func RJ4CJWriter_writeNull(writer: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJWriter_writeBool(writer: CPointer<Unit>, b: Bool): Bool

    @FastNative
    func RJ4CJWriter_writeInt32(writer: CPointer<Unit>, i: Int32): Bool

    @FastNative
    func RJ4CJWriter_writeUInt32(writer: CPointer<Unit>, u: UInt32): Bool

    @FastNative
    func RJ4CJWriter_writeInt64(writer: CPointer<Unit>, i64: Int64): Bool

    @FastNative
    func RJ4CJWriter_writeUInt64(writer: CPointer<Unit>, u64: UInt64): Bool

    @FastNative
    func RJ4CJWriter_writeFloat32(writer: CPointer<Unit>, f: Float32): Bool

    @FastNative
    func RJ4CJWriter_writeFloat64(writer: CPointer<Unit>, d: Float64): Bool

    @FastNative
    func RJ4CJWriter_writeName(writer: CPointer<Unit>, str: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJWriter_writeString(writer: CPointer<Unit>, str: CPointer<UInt8>, length: UInt32): Bool

    func RJ4CJWriter_writeValue(writer: CPointer<Unit>, value: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJWriter_startArray(writer: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJWriter_endArray(writer: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJWriter_startObject(writer: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJWriter_endObject(writer: CPointer<Unit>): Bool
}

@CEnum[public ParseErrorCode](
    None = 0 // No error.
    DocumentEmpty // The document is empty.
    DocumentRootNotSingular // The document root must not follow by other values.
    ValueInvalid // Invalid value.
    ObjectMissName // Missing a name for object member.
    ObjectMissColon // Missing a colon after a name of object member.
    ObjectMissCommaOrCurlyBracket // Missing a comma or '}' after an object member.
    ArrayMissCommaOrSquareBracket // Missing a comma or ']' after an array element.
    StringUnicodeEscapeInvalidHex // Incorrect hex digit after \\u escape in string.
    StringUnicodeSurrogateInvalid // The surrogate pair in string is invalid.
    StringEscapeInvalid // Invalid escape character in string.
    StringMissQuotationMark // Missing a closing quotation mark in string.
    StringInvalidEncoding // Invalid encoding in string.
    NumberTooBig // Number too big to be stored in double.
    NumberMissFraction // Miss fraction part in number.
    NumberMissExponent // Miss exponent in number.
    Termination // Parsing was terminated.
    UnspecificSyntaxError // Unspecific syntax error.
)

@CEnum[public FormatOptions](
    Default = 0
    SingleLineArray = 1
)

@C
struct JsonMemberInternal {
    let name: CPointer<Unit> = CPointer<Unit>()
    let value: CPointer<Unit> = CPointer<Unit>()
}

@C
struct DocumentParseResult {
    let doc: CPointer<Unit> = CPointer<Unit>()
    let error: ParseErrorCode = ParseErrorCode.None
    let offset: UIntNative = 0
}

@C
struct StringView {
    let str: CPointer<UInt8> = CPointer<UInt8>()
    let length: UInt32 = 0
}
