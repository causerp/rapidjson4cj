package rapidjson4cj

import cenum.CEnum

foreign {
    @FastNative
    func memcpy_s(dest: CPointer<UInt8>, destMax: UIntNative, src: CPointer<UInt8>, count: UIntNative): Int32

    func RJ4CJ_parse(str: CPointer<UInt8>, length: UIntNative): ParseResult

    func RJ4CJ_free(doc: CPointer<Unit>): Unit

    @FastNative
    func RJ4CJ_getParseError(error: ParseErrorCode): CString

    @FastNative
    func RJ4CJ_isNull(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isArray(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isObject(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isString(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isBool(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isNumber(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isInt32(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isUInt32(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isInt64(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isUInt64(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isFloat32(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_isFloat64(doc: CPointer<Unit>): Bool

    @FastNative
    func RJ4CJ_getArraySize(doc: CPointer<Unit>): UInt32

    @FastNative
    func RJ4CJ_getArrayBegin(doc: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJ_getArrayEnd(doc: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJ_getArrayNext(it: CPointer<CPointer<Unit>>): JsonValue

    @FastNative
    func RJ4CJ_getMemberBegin(doc: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJ_getMemberEnd(doc: CPointer<Unit>): CPointer<Unit>

    @FastNative
    func RJ4CJ_getMemberNext(itPtr: CPointer<CPointer<Unit>>): JsonMember

    @FastNative
    func RJ4CJ_getMemberCount(doc: CPointer<Unit>): UInt32

    @FastNative
    func RJ4CJ_getString(doc: CPointer<Unit>): StringView

    @FastNative
    func RJ4CJ_getBool(doc: CPointer<Unit>, outValue: CPointer<Bool>): Bool

    @FastNative
    func RJ4CJ_getInt32(doc: CPointer<Unit>, outValue: CPointer<Int32>): Bool

    @FastNative
    func RJ4CJ_getUInt32(doc: CPointer<Unit>, outValue: CPointer<UInt32>): Bool

    @FastNative
    func RJ4CJ_getInt64(doc: CPointer<Unit>, outValue: CPointer<Int64>): Bool

    @FastNative
    func RJ4CJ_getUInt64(doc: CPointer<Unit>, outValue: CPointer<UInt64>): Bool

    @FastNative
    func RJ4CJ_getFloat32(doc: CPointer<Unit>, outValue: CPointer<Float32>): Bool

    @FastNative
    func RJ4CJ_getFloat64(doc: CPointer<Unit>, outValue: CPointer<Float64>): Bool

    @FastNative
    func RJ4CJ_isMemberNull(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberArray(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberObject(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberString(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberBool(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberNumber(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberInt32(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberUInt32(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberInt64(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberUInt64(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberFloat32(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_isMemberFloat64(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): Bool

    @FastNative
    func RJ4CJ_getMemberArray(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): CPointer<Unit>

    @FastNative
    func RJ4CJ_getMemberObject(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): CPointer<Unit>

    @FastNative
    func RJ4CJ_getMemberString(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32): StringView

    @FastNative
    func RJ4CJ_getMemberBool(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32, outValue: CPointer<Bool>): Bool

    @FastNative
    func RJ4CJ_getMemberInt32(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32, outValue: CPointer<Int32>): Bool

    @FastNative
    func RJ4CJ_getMemberUInt32(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32, outValue: CPointer<UInt32>): Bool

    @FastNative
    func RJ4CJ_getMemberInt64(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32, outValue: CPointer<Int64>): Bool

    @FastNative
    func RJ4CJ_getMemberUInt64(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32, outValue: CPointer<UInt64>): Bool

    @FastNative
    func RJ4CJ_getMemberFloat32(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32, outValue: CPointer<Float32>): Bool

    @FastNative
    func RJ4CJ_getMemberFloat64(doc: CPointer<Unit>, key: CPointer<UInt8>, length: UInt32, outValue: CPointer<Float64>): Bool
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

@C
struct ParseResult {
    let doc: CPointer<Unit> = CPointer<Unit>()
    let error: ParseErrorCode = ParseErrorCode.None
    let offset: UIntNative = 0
}

@C
struct StringView {
    let str: CPointer<UInt8> = CPointer<UInt8>()
    let length: UInt32 = 0
}
