package rapidjson4cj

public open class RapidJsonException <: Exception {
    init(message: String) {
        super(message)
    }
}

public class RapidJsonParseException <: RapidJsonException {
    public let code: ParseErrorCode
    public let offset: Int64

    init(code: ParseErrorCode, offset: UIntNative) {
        super(unsafe { RJ4CJ_getParseError(code) }.toString())
        this.code = code
        this.offset = Int64(offset)
    }
}
