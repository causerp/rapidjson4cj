package rapidjson4cj

public class Document <: Resource {
    private var m_value: JsonValue

    /**
     * Loads json from string.
     *
     * @throws RapidJsonException If loading was unsuccessful.
     */
    public init(json: String) {
        unsafe {
            let rawData = json.rawData()
            let rawArr = acquireArrayRawData(rawData)
            let parseResult = RJ4CJ_parse(rawArr.pointer, UIntNative(json.size))
            releaseArrayRawData(rawArr)
            if (parseResult.error == ParseErrorCode.None) {
                m_value = JsonValue(parseResult.doc)
            } else {
                throw RapidJsonException(parseResult)
            }
        }
    }

    ~init() {
        if (m_value.handle.isNotNull()) {
            unsafe { RJ4CJ_free(m_value.handle) }
            m_value.handle = CPointer()
        }
    }

    /**
     * Checks if the resource handle is closed.
     *
     * @return `true` if the handle is null (closed); `false` otherwise.
     */
    public func isClosed(): Bool {
        m_value.handle.isNull()
    }

    /**
     * Closes the resource and releases the internal document object.
     */
    public func close(): Unit {
        if (m_value.handle.isNull()) {
            return
        }
        unsafe { RJ4CJ_free(m_value.handle) }
        m_value.handle = CPointer()
    }

    /**
     * Checks if the document root is null.
     *
     * @return `true` if the root is null; `false` otherwise.
     */
    public func isNull(): Bool {
        m_value.isNull()
    }

    /**
     * Checks if the document root is an Array.
     *
     * @return `true` if the root is an Array; `false` otherwise.
     */
    public func isArray(): Bool {
        m_value.isArray()
    }

    /**
     * Checks if the document root is an Object.
     *
     * @return `true` if the root is an Object; `false` otherwise.
     */
    public func isObject(): Bool {
        m_value.isObject()
    }

    /**
     * Checks if the document root is a String.
     *
     * @return `true` if the root is a String; `false` otherwise.
     */
    public func isString(): Bool {
        m_value.isString()
    }

    /**
     * Checks if the document root is a Bool.
     *
     * @return `true` if the root is a Bool; `false` otherwise.
     */
    public func isBool(): Bool {
        m_value.isBool()
    }

    /**
     * Checks if the document root is a Number.
     *
     * @return `true` if the root is a Number; `false` otherwise.
     */
    public func isNumber(): Bool {
        m_value.isNumber()
    }

    /**
     * Checks if the document root is an Int32.
     *
     * @return `true` if the root is an Int32; `false` otherwise.
     */
    public func isInt32(): Bool {
        m_value.isInt32()
    }

    /**
     * Checks if the document root is a UInt32.
     *
     * @return `true` if the root is a UInt32; `false` otherwise.
     */
    public func isUInt32(): Bool {
        m_value.isUInt32()
    }

    /**
     * Checks if the document root is an Int64.
     *
     * @return `true` if the root is an Int64; `false` otherwise.
     */
    public func isInt64(): Bool {
        m_value.isInt64()
    }

    /**
     * Checks if the document root is a UInt64.
     *
     * @return `true` if the root is a UInt64; `false` otherwise.
     */
    public func isUInt64(): Bool {
        m_value.isUInt64()
    }

    /**
     * Checks if the document root is a Float32.
     *
     * @return `true` if the root is a Float32; `false` otherwise.
     */
    public func isFloat32(): Bool {
        m_value.isFloat32()
    }

    /**
     * Checks if the document root is a Float64.
     *
     * @return `true` if the root is a Float64; `false` otherwise.
     */
    public func isFloat64(): Bool {
        m_value.isFloat64()
    }

    /**
     * Gets the size of the array at the document root.
     *
     * It returns the number of elements if the value is an array, or 0 otherwise.
     *
     * @return The number of elements in the array as a UInt32.
     */
    public func size(): UInt32 {
        m_value.size()
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
        m_value.arrayIterator()
    }

    /**
     * Gets the number of members in the object at the document root.
     *
     * It returns the count of key-value pairs if the value is an object, or 0 otherwise.
     *
     * @return The number of members in the object as a UInt32.
     */
    public func memberCount(): UInt32 {
        m_value.memberCount()
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
        m_value.memberIterator()
    }

    /**
     * Retrieves the string value directly from the document root.
     *
     * @return `Some(String)` if the root is a valid String;
     *         `None` if the root is not a String.
     */
    public func getString(): ?String {
        m_value.getString()
    }

    /**
     * Retrieves the Bool value directly from the document root.
     *
     * @return `Some(Bool)` if the root is a Bool;
     *         `None` if the root is not a Bool.
     */
    public func getBool(): ?Bool {
        m_value.getBool()
    }

    /**
     * Retrieves the Int32 value directly from the document root.
     *
     * @return `Some(Int32)` if the root is an Int32;
     *         `None` if the root is not an Int32.
     */
    public func getInt32(): ?Int32 {
        m_value.getInt32()
    }

    /**
     * Retrieves the UInt32 value directly from the document root.
     *
     * @return `Some(UInt32)` if the root is a UInt32;
     *         `None` if the root is not a UInt32.
     */
    public func getUInt32(): ?UInt32 {
        m_value.getUInt32()
    }

    /**
     * Retrieves the Int64 value directly from the document root.
     *
     * @return `Some(Int64)` if the root is an Int64;
     *         `None` if the root is not an Int64.
     */
    public func getInt64(): ?Int64 {
        m_value.getInt64()
    }

    /**
     * Retrieves the UInt64 value directly from the document root.
     *
     * @return `Some(UInt64)` if the root is a UInt64;
     *         `None` if the root is not a UInt64.
     */
    public func getUInt64(): ?UInt64 {
        m_value.getUInt64()
    }

    /**
     * Retrieves the Float32 value directly from the document root.
     *
     * @return `Some(Float32)` if the root is a Float32;
     *         `None` if the root is not a Float32.
     */
    public func getFloat32(): ?Float32 {
        m_value.getFloat32()
    }

    /**
     * Retrieves the Float64 value directly from the document root.
     *
     * @return `Some(Float64)` if the root is a Float64;
     *         `None` if the root is not a Float64.
     */
    public func getFloat64(): ?Float64 {
        m_value.getFloat64()
    }

    /**
     * Checks if a key exists in the document root and its value is null.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is null; `false` otherwise.
     */
    public func isNull(key: String): Bool {
        m_value.isNull(key)
    }

    /**
     * Checks if a key exists in the document root and its value is an Array.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Array; `false` otherwise.
     */
    public func isArray(key: String): Bool {
        m_value.isArray(key)
    }

    /**
     * Checks if a key exists in the document root and its value is an Object.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Object; `false` otherwise.
     */
    public func isObject(key: String): Bool {
        m_value.isObject(key)
    }

    /**
     * Checks if a key exists in the document root and its value is a String.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a String; `false` otherwise.
     */
    public func isString(key: String): Bool {
        m_value.isString(key)
    }

    /**
     * Checks if a key exists in the document root and its value is a Bool.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Bool; `false` otherwise.
     */
    public func isBool(key: String): Bool {
        m_value.isBool(key)
    }

    /**
     * Checks if a key exists in the document root and its value is a Number.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Number; `false` otherwise.
     */
    public func isNumber(key: String): Bool {
        m_value.isNumber(key)
    }

    /**
     * Checks if a key exists in the document root and its value is an Int32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Int32; `false` otherwise.
     */
    public func isInt32(key: String): Bool {
        m_value.isInt32(key)
    }

    /**
     * Checks if a key exists in the document root and its value is a UInt32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a UInt32; `false` otherwise.
     */
    public func isUInt32(key: String): Bool {
        m_value.isUInt32(key)
    }

    /**
     * Checks if a key exists in the document root and its value is an Int64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Int64; `false` otherwise.
     */
    public func isInt64(key: String): Bool {
        m_value.isInt64(key)
    }

    /**
     * Checks if a key exists in the document root and its value is a UInt64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a UInt64; `false` otherwise.
     */
    public func isUInt64(key: String): Bool {
        m_value.isUInt64(key)
    }

    /**
     * Checks if a key exists in the document root and its value is a Float32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Float32; `false` otherwise.
     */
    public func isFloat32(key: String): Bool {
        m_value.isFloat32(key)
    }

    /**
     * Checks if a key exists in the document root and its value is a Float64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Float64; `false` otherwise.
     */
    public func isFloat64(key: String): Bool {
        m_value.isFloat64(key)
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
        m_value.getArray(key)
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
        m_value.getObject(key)
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
        m_value.getString(key)
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
        m_value.getBool(key)
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
        m_value.getInt32(key)
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
        m_value.getUInt32(key)
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
        m_value.getInt64(key)
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
        m_value.getUInt64(key)
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
        m_value.getFloat32(key)
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
        m_value.getFloat64(key)
    }
}
