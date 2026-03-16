package rapidjson4cj

public class RapidJsonException <: Exception {
    public let code: ParseErrorCode
    public let offset: Int64

    init(result: ParseResult) {
        super(unsafe { RJ4CJ_getParseError(result.error) }.toString())
        this.code = result.error
        this.offset = Int64(result.offset)
    }
}

public class JsonValueIterator <: Iterator<JsonValue> {
    private var itBegin: CPointer<Unit>
    private let itEnd: CPointer<Unit>

    init(itBegin: CPointer<Unit>, itEnd: CPointer<Unit>) {
        this.itBegin = itBegin
        this.itEnd = itEnd
    }

    public func next(): ?JsonValue {
        var currentIt = itBegin
        if (currentIt.toUIntNative() == itEnd.toUIntNative()) {
            return None
        }
        let value = unsafe { RJ4CJ_getArrayNext(inout currentIt) }
        itBegin = currentIt
        return value
    }
}

@C
public struct JsonValue {
    var handle: CPointer<Unit> = CPointer<Unit>()

    init(handle: CPointer<Unit>) {
        this.handle = handle
    }

    /**
     * Checks if the document root is null.
     *
     * @return `true` if the root is null; `false` otherwise.
     */
    public func isNull(): Bool {
        unsafe { RJ4CJ_isNull(handle) }
    }

    /**
     * Checks if the document root is an Array.
     *
     * @return `true` if the root is an Array; `false` otherwise.
     */
    public func isArray(): Bool {
        unsafe { RJ4CJ_isArray(handle) }
    }

    /**
     * Checks if the document root is an Object.
     *
     * @return `true` if the root is an Object; `false` otherwise.
     */
    public func isObject(): Bool {
        unsafe { RJ4CJ_isObject(handle) }
    }

    /**
     * Checks if the document root is a String.
     *
     * @return `true` if the root is a String; `false` otherwise.
     */
    public func isString(): Bool {
        unsafe { RJ4CJ_isString(handle) }
    }

    /**
     * Checks if the document root is a Bool.
     *
     * @return `true` if the root is a Bool; `false` otherwise.
     */
    public func isBool(): Bool {
        unsafe { RJ4CJ_isBool(handle) }
    }

    /**
     * Checks if the document root is a Number.
     *
     * @return `true` if the root is a Number; `false` otherwise.
     */
    public func isNumber(): Bool {
        unsafe { RJ4CJ_isNumber(handle) }
    }

    /**
     * Checks if the document root is an Int32.
     *
     * @return `true` if the root is an Int32; `false` otherwise.
     */
    public func isInt32(): Bool {
        unsafe { RJ4CJ_isInt32(handle) }
    }

    /**
     * Checks if the document root is a UInt32.
     *
     * @return `true` if the root is a UInt32; `false` otherwise.
     */
    public func isUInt32(): Bool {
        unsafe { RJ4CJ_isUInt32(handle) }
    }

    /**
     * Checks if the document root is an Int64.
     *
     * @return `true` if the root is an Int64; `false` otherwise.
     */
    public func isInt64(): Bool {
        unsafe { RJ4CJ_isInt64(handle) }
    }

    /**
     * Checks if the document root is a UInt64.
     *
     * @return `true` if the root is a UInt64; `false` otherwise.
     */
    public func isUInt64(): Bool {
        unsafe { RJ4CJ_isUInt64(handle) }
    }

    /**
     * Checks if the document root is a Float32.
     *
     * @return `true` if the root is a Float32; `false` otherwise.
     */
    public func isFloat32(): Bool {
        unsafe { RJ4CJ_isFloat32(handle) }
    }

    /**
     * Checks if the document root is a Float64.
     *
     * @return `true` if the root is a Float64; `false` otherwise.
     */
    public func isFloat64(): Bool {
        unsafe { RJ4CJ_isFloat64(handle) }
    }

    /**
     * Gets the size of the array at the document root.
     *
     * It returns the number of elements if the value is an array, or 0 otherwise.
     *
     * @return The number of elements in the array as a UInt32.
     */
    public func size(): UInt32 {
        unsafe { RJ4CJ_getArraySize(handle) }
    }

    /**
     * Returns an iterator over the elements of this JSON array.
     *
     * This function is used to iterate over values in a JSON array.
     * It provides sequential access to each element.
     *
     * @return A `JsonValueIterator` to traverse the array elements.
     */
    public func arrayIterator(): JsonValueIterator {
        unsafe {
            let ptrBegin = RJ4CJ_getArrayBegin(handle)
            let ptrEnd = RJ4CJ_getArrayEnd(handle)
            return JsonValueIterator(ptrBegin, ptrEnd)
        }
    }

    /**
     * Gets the number of members in the object at the document root.
     *
     * It returns the count of key-value pairs if the value is an object, or 0 otherwise.
     *
     * @return The number of members in the object as a UInt32.
     */
    public func memberCount(): UInt32 {
        unsafe { RJ4CJ_getMemberCount(handle) }
    }

    /**
     * Returns an iterator over the members of this JSON object.
     *
     * This function is used to iterate over key-value pairs in a JSON object.
     * It provides access to both the member name (key) and its associated value.
     *
     * @return A `JsonMemberIterator` to traverse the object members.
     */
    public func memberIterator(): JsonMemberIterator {
        unsafe {
            let ptrBegin = RJ4CJ_getMemberBegin(handle)
            let ptrEnd = RJ4CJ_getMemberEnd(handle)
            return JsonMemberIterator(ptrBegin, ptrEnd)
        }
    }

    /**
     * Retrieves the string value directly from the document root.
     *
     * @return `Some(String)` if the root is a valid String;
     *         `None` if the root is not a String.
     */
    public func getString(): ?String {
        unsafe {
            let stringView = RJ4CJ_getString(handle)
            let strPtr = stringView.str
            if (strPtr.isNull()) {
                return None
            }
            let len = Int64(stringView.length)
            let strBytes = Array<UInt8>(len, repeat: 0)
            let rawData = acquireArrayRawData(strBytes)
            memcpy_s(rawData.pointer, UIntNative(len), strPtr, UIntNative(len))
            releaseArrayRawData(rawData)
            return String.fromUtf8(strBytes)
        }
    }

    /**
     * Retrieves the Bool value directly from the document root.
     *
     * @return `Some(Bool)` if the root is a Bool;
     *         `None` if the root is not a Bool.
     */
    public func getBool(): ?Bool {
        unsafe {
            var value: Bool = false
            match (RJ4CJ_getBool(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Int32 value directly from the document root.
     *
     * @return `Some(Int32)` if the root is an Int32;
     *         `None` if the root is not an Int32.
     */
    public func getInt32(): ?Int32 {
        unsafe {
            var value: Int32 = 0
            match (RJ4CJ_getInt32(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the UInt32 value directly from the document root.
     *
     * @return `Some(UInt32)` if the root is a UInt32;
     *         `None` if the root is not a UInt32.
     */
    public func getUInt32(): ?UInt32 {
        unsafe {
            var value: UInt32 = 0
            match (RJ4CJ_getUInt32(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Int64 value directly from the document root.
     *
     * @return `Some(Int64)` if the root is an Int64;
     *         `None` if the root is not an Int64.
     */
    public func getInt64(): ?Int64 {
        unsafe {
            var value: Int64 = 0
            match (RJ4CJ_getInt64(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the UInt64 value directly from the document root.
     *
     * @return `Some(UInt64)` if the root is a UInt64;
     *         `None` if the root is not a UInt64.
     */
    public func getUInt64(): ?UInt64 {
        unsafe {
            var value: UInt64 = 0
            match (RJ4CJ_getUInt64(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Float32 value directly from the document root.
     *
     * @return `Some(Float32)` if the root is a Float32;
     *         `None` if the root is not a Float32.
     */
    public func getFloat32(): ?Float32 {
        unsafe {
            var value: Float32 = 0.0
            match (RJ4CJ_getFloat32(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Float64 value directly from the document root.
     *
     * @return `Some(Float64)` if the root is a Float64;
     *         `None` if the root is not a Float64.
     */
    public func getFloat64(): ?Float64 {
        var value: Float64 = 0.0
        match (unsafe { RJ4CJ_getFloat64(handle, inout value) }) {
            case true => value
            case false => None
        }
    }

    /**
     * Checks if a key exists in the document root and its value is null.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is null; `false` otherwise.
     */
    public func isNull(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberNull(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is an Array.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Array; `false` otherwise.
     */
    public func isArray(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberArray(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is an Object.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Object; `false` otherwise.
     */
    public func isObject(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberObject(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is a String.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a String; `false` otherwise.
     */
    public func isString(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberString(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is a Bool.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Bool; `false` otherwise.
     */
    public func isBool(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberBool(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is a Number.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Number; `false` otherwise.
     */
    public func isNumber(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberNumber(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is an Int32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Int32; `false` otherwise.
     */
    public func isInt32(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberInt32(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is a UInt32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a UInt32; `false` otherwise.
     */
    public func isUInt32(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberUInt32(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is an Int64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Int64; `false` otherwise.
     */
    public func isInt64(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberInt64(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is a UInt64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a UInt64; `false` otherwise.
     */
    public func isUInt64(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberUInt64(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is a Float32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Float32; `false` otherwise.
     */
    public func isFloat32(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberFloat32(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Checks if a key exists in the document root and its value is a Float64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Float64; `false` otherwise.
     */
    public func isFloat64(key: String): Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJ_isMemberFloat64(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Retrieves a sub-array (JsonValue) associated with the specified key.
     *
     * This function is used to access nested JSON arrays. If the key exists and the
     * corresponding value is a JSON array, it returns a handle to that array.
     *
     * @param key The key to look up.
     *
     * @return `Some(JsonValue)` if the key exists and the value is an array;
     *         `None` if the key is missing or the value is not an array.
     */
    public func getArray(key: String): ?JsonValue {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJ_getMemberArray(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return match (ptr.isNull()) {
                case false => JsonValue(ptr)
                case true => None
            }
        }
    }

    /**
     * Retrieves a sub-object (JsonValue) associated with the specified key.
     *
     * This function is used to access nested JSON objects. If the key exists and the
     * corresponding value is a JSON object, it returns a handle to that object.
     *
     * @param key The key to look up.
     *
     * @return `Some(JsonValue)` if the key exists and the value is an object;
     *         `None` if the key is missing or the value is not an object.
     */
    public func getObject(key: String): ?JsonValue {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJ_getMemberObject(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return match (ptr.isNull()) {
                case false => JsonValue(ptr)
                case true => None
            }
        }
    }

    /**
     * Retrieves the string value associated with the specified key.
     *
     * This function performs a copy of the underlying UTF-8 data into a new Cangjie String object.
     *
     * @param key The key to look up.
     *
     * @return `Some(String)` if the key exists and the value is a valid String;
     *         `None` if the key is missing or the value is not a String.
     */
    public func getString(key: String): ?String {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let stringView = RJ4CJ_getMemberString(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)

            let strPtr = stringView.str
            if (strPtr.isNull()) {
                return None
            }
            let len = Int64(stringView.length)
            let strBytes = Array<UInt8>(len, repeat: 0)
            let destRawData = acquireArrayRawData(strBytes)
            memcpy_s(destRawData.pointer, UIntNative(len), strPtr, UIntNative(len))
            releaseArrayRawData(destRawData)
            return String.fromUtf8(strBytes)
        }
    }

    /**
     * Retrieves the Bool value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(Bool)` if the key exists and the value is a Bool;
     *         `None` if the key is missing or the value is not a Bool.
     */
    public func getBool(key: String): ?Bool {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            var value: Bool = false
            let ret = RJ4CJ_getMemberBool(handle, rawData.pointer, strSize, inout value)
            releaseArrayRawData(rawData)
            return match (ret) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Int32 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(Int32)` if the key exists and the value is an Int32;
     *         `None` if the key is missing or the value is not an Int32.
     */
    public func getInt32(key: String): ?Int32 {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            var value: Int32 = 0
            let ret = RJ4CJ_getMemberInt32(handle, rawData.pointer, strSize, inout value)
            releaseArrayRawData(rawData)
            return match (ret) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the UInt32 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(UInt32)` if the key exists and the value is a UInt32;
     *         `None` if the key is missing or the value is not a UInt32.
     */
    public func getUInt32(key: String): ?UInt32 {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            var value: UInt32 = 0
            let ret = RJ4CJ_getMemberUInt32(handle, rawData.pointer, strSize, inout value)
            releaseArrayRawData(rawData)
            return match (ret) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Int64 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(Int64)` if the key exists and the value is an Int64;
     *         `None` if the key is missing or the value is not an Int64.
     */
    public func getInt64(key: String): ?Int64 {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            var value: Int64 = 0
            let ret = RJ4CJ_getMemberInt64(handle, rawData.pointer, strSize, inout value)
            releaseArrayRawData(rawData)
            return match (ret) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the UInt64 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(UInt64)` if the key exists and the value is a UInt64;
     *         `None` if the key is missing or the value is not a UInt64.
     */
    public func getUInt64(key: String): ?UInt64 {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            var value: UInt64 = 0
            let ret = RJ4CJ_getMemberUInt64(handle, rawData.pointer, strSize, inout value)
            releaseArrayRawData(rawData)
            return match (ret) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Float32 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(Float32)` if the key exists and the value is a Float32;
     *         `None` if the key is missing or the value is not a Float32.
     */
    public func getFloat32(key: String): ?Float32 {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            var value: Float32 = 0.0
            let ret = RJ4CJ_getMemberFloat32(handle, rawData.pointer, strSize, inout value)
            releaseArrayRawData(rawData)
            return match (ret) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Float64 value associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `Some(Float64)` if the key exists and the value is a Float64;
     *         `None` if the key is missing or the value is not a Float64.
     */
    public func getFloat64(key: String): ?Float64 {
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            var value: Float64 = 0.0
            let ret = RJ4CJ_getMemberFloat64(handle, rawData.pointer, strSize, inout value)
            releaseArrayRawData(rawData)
            return match (ret) {
                case true => value
                case false => None
            }
        }
    }
}
