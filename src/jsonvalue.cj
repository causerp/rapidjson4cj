package rapidjson4cj

public struct JsonValue <: Collection<JsonValue> & Resource & ToString {
    var handle: CPointer<Unit>
    var root: Document

    init(handle: CPointer<Unit>, root!: Document) {
        root.throwIfClosed()
        this.handle = handle
        this.root = root
    }

    /**
     * Loads json from string.
     *
     * @throws RapidJsonParseException If loading was unsuccessful.
     */
    public init(json: String) {
        root = Document(json)
        handle = root.handle
    }

    // Collection

    /**
     * Returns an iterator over the elements of this JSON array.
     *
     * This function is used to iterate over values in a JSON array.
     * It provides sequential access to each element.
     *
     * @return A `JsonValueIterator` to traverse the array elements.
     */
    public func iterator(): JsonValueIterator {
        root.throwIfClosed()
        unsafe {
            let ptrBegin = RJ4CJValue_arrayBegin(handle)
            let ptrEnd = RJ4CJValue_arrayEnd(handle)
            return JsonValueIterator(root, ptrBegin, ptrEnd)
        }
    }

    /**
     * Gets the size of the array.
     *
     * It returns the number of elements if this value is an array, or 0 otherwise.
     *
     * @return The number of elements in the array.
     */
    public prop size: Int64 {
        get() {
            root.throwIfClosed()
            Int64(unsafe { RJ4CJValue_arraySize(handle) })
        }
    }

    /**
     * Checks if the array is empty.
     *
     * @return `true` if this array contains no elements or it's not an array.
     */
    public func isEmpty(): Bool {
        size <= 0
    }

    public func toArray(): Array<JsonValue> {
        Array<JsonValue>(size, {index => this[index]})
    }

    // Resource

    /**
     * Checks if the root Document is closed.
     *
     * @return `true` if the root Document is closed; `false` otherwise.
     */
    public func isClosed(): Bool {
        root.isClosed()
    }

    /**
     * Closes the root Document.
     *
     * Note: Closing a child value will invalidate all values of the root Document.
     */
    public func close(): Unit {
        root.close()
    }

    // ToString

    /**
     * get JSON string.
     */
    public func toString(): String {
        root.throwIfClosed()
        try (writer = SimpleWriter()) {
            writer.writeValue(this)
            return writer.getString()
        }
        return String.empty
    }

    // JsonValue

    /**
     * get pretty printed JSON string with 2 space indentation and default format options.
     */
    public func toPrettyString(): String {
        root.throwIfClosed()
        toPrettyString(2, FormatOptions.Default)
    }

    /**
     * get pretty printed JSON string.
     */
    public func toPrettyString(indentCharCount: UInt32, formatOptions: FormatOptions): String {
        root.throwIfClosed()
        try (writer = PrettyWriter(indentCharCount, formatOptions)) {
            writer.writeValue(this)
            return writer.getString()
        }
        return String.empty
    }

    /**
     * Creates a deep clone of this JsonValue as a new, independent JsonValue.
     *
     * @return A new JsonValue containing the cloned data.
     */
    public func clone(): JsonValue {
        root.throwIfClosed()
        unsafe { Document(RJ4CJDocument_clone(handle)).getValue() }
    }

    /**
     * Checks if this value is the root Document.
     *
     * @return `true` if this value is the root Document; `false` otherwise.
     */
    public func isRoot(): Bool {
        root.throwIfClosed()
        handle.toUIntNative() == root.handle.toUIntNative()
    }

    /**
     * Checks if this value is null.
     *
     * @return `true` if this value is null; `false` otherwise.
     */
    public func isNull(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isNull(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is null.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is null; `false` otherwise.
     */
    public func isNull(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isNull()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is null.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is null; `false` otherwise.
     */
    public func isNull(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isNull()
            case None => false
        }
    }

    /**
     * Checks if this value is a Bool.
     *
     * @return `true` if this value is a Bool; `false` otherwise.
     */
    public func isBool(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isBool(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a Bool.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a Bool; `false` otherwise.
     */
    public func isBool(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isBool()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a Bool.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Bool; `false` otherwise.
     */
    public func isBool(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isBool()
            case None => false
        }
    }

    /**
     * Checks if this value is a Number.
     *
     * @return `true` if this value is a Number; `false` otherwise.
     */
    public func isNumber(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isNumber(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a Number.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a Number; `false` otherwise.
     */
    public func isNumber(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isNumber()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a Number.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Number; `false` otherwise.
     */
    public func isNumber(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isNumber()
            case None => false
        }
    }

    /**
     * Checks if this value is an Int32.
     *
     * @return `true` if this value is an Int32; `false` otherwise.
     */
    public func isInt32(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isInt32(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is an Int32.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is an Int32; `false` otherwise.
     */
    public func isInt32(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isInt32()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is an Int32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Int32; `false` otherwise.
     */
    public func isInt32(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isInt32()
            case None => false
        }
    }

    /**
     * Checks if this value is a UInt32.
     *
     * @return `true` if this value is a UInt32; `false` otherwise.
     */
    public func isUInt32(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isUInt32(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a UInt32.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a UInt32; `false` otherwise.
     */
    public func isUInt32(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isUInt32()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a UInt32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a UInt32; `false` otherwise.
     */
    public func isUInt32(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isUInt32()
            case None => false
        }
    }

    /**
     * Checks if this value is an Int64.
     *
     * @return `true` if this value is an Int64; `false` otherwise.
     */
    public func isInt64(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isInt64(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is an Int64.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is an Int64; `false` otherwise.
     */
    public func isInt64(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isInt64()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is an Int64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Int64; `false` otherwise.
     */
    public func isInt64(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isInt64()
            case None => false
        }
    }

    /**
     * Checks if this value is a UInt64.
     *
     * @return `true` if this value is a UInt64; `false` otherwise.
     */
    public func isUInt64(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isUInt64(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a UInt64.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a UInt64; `false` otherwise.
     */
    public func isUInt64(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isUInt64()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a UInt64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a UInt64; `false` otherwise.
     */
    public func isUInt64(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isUInt64()
            case None => false
        }
    }

    /**
     * Checks if this value is a Float32.
     *
     * @return `true` if this value is a Float32; `false` otherwise.
     */
    public func isFloat32(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isFloat32(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a Float32.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a Float32; `false` otherwise.
     */
    public func isFloat32(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isFloat32()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a Float32.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Float32; `false` otherwise.
     */
    public func isFloat32(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isFloat32()
            case None => false
        }
    }

    /**
     * Checks if this value is a Float64.
     *
     * @return `true` if this value is a Float64; `false` otherwise.
     */
    public func isFloat64(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isFloat64(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a Float64.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a Float64; `false` otherwise.
     */
    public func isFloat64(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isFloat64()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a Float64.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a Float64; `false` otherwise.
     */
    public func isFloat64(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isFloat64()
            case None => false
        }
    }

    /**
     * Checks if this value is a String.
     *
     * @return `true` if this value is a String; `false` otherwise.
     */
    public func isString(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isString(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is a String.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is a String; `false` otherwise.
     */
    public func isString(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isString()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is a String.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is a String; `false` otherwise.
     */
    public func isString(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isString()
            case None => false
        }
    }

    /**
     * Checks if this value is an Array.
     *
     * @return `true` if this value is an Array; `false` otherwise.
     */
    public func isArray(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isArray(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is an Array.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is an Array; `false` otherwise.
     */
    public func isArray(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isArray()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is an Array.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Array; `false` otherwise.
     */
    public func isArray(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isArray()
            case None => false
        }
    }

    /**
     * Checks if this value is an Object.
     *
     * @return `true` if this value is an Object; `false` otherwise.
     */
    public func isObject(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_isObject(handle) }
    }

    /**
     * Checks if an index exists in this JSON array and its value is an Object.
     *
     * @param index The array index.
     *
     * @return `true` if the index is valid and the value is an Object; `false` otherwise.
     */
    public func isObject(index: Int64): Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.isObject()
            case None => false
        }
    }

    /**
     * Checks if a key exists in this JSON object and its value is an Object.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists and the value is an Object; `false` otherwise.
     */
    public func isObject(key: String): Bool {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.isObject()
            case None => false
        }
    }

    /**
     * Retrieves the Bool value directly from this value.
     *
     * @return `Some(Bool)` if this value is a Bool;
     *         `None` if this value is not a Bool.
     */
    public func getBool(): ?Bool {
        root.throwIfClosed()
        unsafe {
            var value: Bool = false
            match (RJ4CJValue_getBool(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Bool value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(Bool)` if the index is valid and the value is a Bool;
     *         `None` if the index is out of range or the value is not a Bool.
     */
    public func getBool(index: Int64): ?Bool {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.getBool()
            case None => None
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
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.getBool()
            case None => None
        }
    }

    /**
     * Retrieves the Int32 value directly from this value.
     *
     * @return `Some(Int32)` if this value is an Int32;
     *         `None` if this value is not an Int32.
     */
    public func getInt32(): ?Int32 {
        root.throwIfClosed()
        unsafe {
            var value: Int32 = 0
            match (RJ4CJValue_getInt32(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Int32 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(Int32)` if the index is valid and the value is an Int32;
     *         `None` if the index is out of range or the value is not an Int32.
     */
    public func getInt32(index: Int64): ?Int32 {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.getInt32()
            case None => None
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
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.getInt32()
            case None => None
        }
    }

    /**
     * Retrieves the UInt32 value directly from this value.
     *
     * @return `Some(UInt32)` if this value is a UInt32;
     *         `None` if this value is not a UInt32.
     */
    public func getUInt32(): ?UInt32 {
        root.throwIfClosed()
        unsafe {
            var value: UInt32 = 0
            match (RJ4CJValue_getUInt32(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the UInt32 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(UInt32)` if the index is valid and the value is a UInt32;
     *         `None` if the index is out of range or the value is not a UInt32.
     */
    public func getUInt32(index: Int64): ?UInt32 {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.getUInt32()
            case None => None
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
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.getUInt32()
            case None => None
        }
    }

    /**
     * Retrieves the Int64 value directly from this value.
     *
     * @return `Some(Int64)` if this value is an Int64;
     *         `None` if this value is not an Int64.
     */
    public func getInt64(): ?Int64 {
        root.throwIfClosed()
        unsafe {
            var value: Int64 = 0
            match (RJ4CJValue_getInt64(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Int64 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(Int64)` if the index is valid and the value is an Int64;
     *         `None` if the index is out of range or the value is not an Int64.
     */
    public func getInt64(index: Int64): ?Int64 {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.getInt64()
            case None => None
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
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.getInt64()
            case None => None
        }
    }

    /**
     * Retrieves the UInt64 value directly from this value.
     *
     * @return `Some(UInt64)` if this value is a UInt64;
     *         `None` if this value is not a UInt64.
     */
    public func getUInt64(): ?UInt64 {
        root.throwIfClosed()
        unsafe {
            var value: UInt64 = 0
            match (RJ4CJValue_getUInt64(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the UInt64 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(UInt64)` if the index is valid and the value is a UInt64;
     *         `None` if the index is out of range or the value is not a UInt64.
     */
    public func getUInt64(index: Int64): ?UInt64 {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.getUInt64()
            case None => None
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
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.getUInt64()
            case None => None
        }
    }

    /**
     * Retrieves the Float32 value directly from this value.
     *
     * @return `Some(Float32)` if this value is a Float32;
     *         `None` if this value is not a Float32.
     */
    public func getFloat32(): ?Float32 {
        root.throwIfClosed()
        unsafe {
            var value: Float32 = 0.0
            match (RJ4CJValue_getFloat32(handle, inout value)) {
                case true => value
                case false => None
            }
        }
    }

    /**
     * Retrieves the Float32 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(Float32)` if the index is valid and the value is a Float32;
     *         `None` if the index is out of range or the value is not a Float32.
     */
    public func getFloat32(index: Int64): ?Float32 {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.getFloat32()
            case None => None
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
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.getFloat32()
            case None => None
        }
    }

    /**
     * Retrieves the Float64 value directly from this value.
     *
     * @return `Some(Float64)` if this value is a Float64;
     *         `None` if this value is not a Float64.
     */
    public func getFloat64(): ?Float64 {
        root.throwIfClosed()
        var value: Float64 = 0.0
        match (unsafe { RJ4CJValue_getFloat64(handle, inout value) }) {
            case true => value
            case false => None
        }
    }

    /**
     * Retrieves the Float64 value associated with the specified index.
     *
     * @param index The array index.
     *
     * @return `Some(Float64)` if the index is valid and the value is a Float64;
     *         `None` if the index is out of range or the value is not a Float64.
     */
    public func getFloat64(index: Int64): ?Float64 {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.getFloat64()
            case None => None
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
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.getFloat64()
            case None => None
        }
    }

    /**
     * Retrieves the string value directly from this value.
     *
     * @return `Some(String)` if this value is a valid String;
     *         `None` if this value is not a String.
     */
    public func getString(): ?String {
        root.throwIfClosed()
        unsafe {
            let stringView = RJ4CJValue_getString(handle)
            let strPtr = stringView.str
            if (strPtr.isNull()) {
                return None
            }
            let len = Int64(stringView.length)
            let strBytes = Array<UInt8>(len, repeat: 0)
            let rawData = acquireArrayRawData(strBytes)
            memcpy_s(rawData.pointer, UIntNative(len), strPtr, UIntNative(len))
            releaseArrayRawData(rawData)

            @When[cjc_version >= "1.1.0"]
            let str = String.withRawData(strBytes)

            @When[cjc_version < "1.1.0"]
            let str = String.fromUtf8Unchecked(strBytes)

            return str
        }
    }

    /**
     * Retrieves the string value associated with the specified index.
     *
     * This function performs a copy of the underlying UTF-8 data into a new String.
     *
     * @param index The array index.
     *
     * @return `Some(String)` if the index is valid and the value is a valid String;
     *         `None` if the index is out of range or the value is not a String.
     */
    public func getString(index: Int64): ?String {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.getString()
            case None => None
        }
    }

    /**
     * Retrieves the string value associated with the specified key.
     *
     * This function performs a copy of the underlying UTF-8 data into a new String.
     *
     * @param key The key to look up.
     *
     * @return `Some(String)` if the key exists and the value is a valid String;
     *         `None` if the key is missing or the value is not a String.
     */
    public func getString(key: String): ?String {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.getString()
            case None => None
        }
    }

    /**
     * Retrieves the string length directly from this value.
     *
     * @return The string length in bytes as a UInt32.
     */
    public func getStringLength(): UInt32 {
        root.throwIfClosed()
        unsafe { RJ4CJValue_getStringLength(handle) }
    }

    /**
     * Retrieves the string length associated with the specified index.
     *
     * @param index The array index.
     *
     * @return The string length in bytes as a UInt32, or 0 if the index is out of range or not a string.
     */
    public func getStringLength(index: Int64): UInt32 {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) => value.getStringLength()
            case None => 0
        }
    }

    /**
     * Retrieves the string length associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return The string length in bytes as a UInt32, or 0 if the key is missing or not a string.
     */
    public func getStringLength(key: String): UInt32 {
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) => value.getStringLength()
            case None => 0
        }
    }

    /**
     * Retrieves a sub-array (JsonValue) directly from this value.
     *
     * This function is used to access nested JSON arrays.
     *
     * @return `Some(JsonValue)` if this value is an array;
     *         `None` if this value is not an array.
     */
    public func getArray(): ?JsonValue {
        root.throwIfClosed()
        if (isArray()) {
            return this
        }
        return None
    }

    /**
     * Retrieves a sub-array (JsonValue) associated with the specified index.
     *
     * This function is used to access nested JSON arrays. If the index is valid and the
     * corresponding value is a JSON array, it returns a handle to that array.
     *
     * @param index The array index.
     *
     * @return `Some(JsonValue)` if the index is valid and the value is an array;
     *         `None` if the index is out of range or the value is not an array.
     */
    public func getArray(index: Int64): ?JsonValue {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) where value.isArray() => value
            case _ => None
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
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) where value.isArray() => value
            case _ => None
        }
    }

    /**
     * Retrieves a sub-object (JsonValue) directly from this value.
     *
     * This function is used to access nested JSON objects.
     *
     * @return `Some(JsonValue)` if this value is an object;
     *         `None` if this value is not an object.
     */
    public func getObject(): ?JsonValue {
        root.throwIfClosed()
        if (isObject()) {
            return this
        }
        return None
    }

    /**
     * Retrieves a sub-object (JsonValue) associated with the specified index.
     *
     * This function is used to access nested JSON objects. If the index is valid and the
     * corresponding value is a JSON object, it returns a handle to that object.
     *
     * @param index The array index.
     *
     * @return `Some(JsonValue)` if the index is valid and the value is an object;
     *         `None` if the index is out of range or the value is not an object.
     */
    public func getObject(index: Int64): ?JsonValue {
        root.throwIfClosed()
        match (get(index)) {
            case Some(value) where value.isObject() => value
            case _ => None
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
        root.throwIfClosed()
        match (get(key)) {
            case Some(value) where value.isObject() => value
            case _ => None
        }
    }

    /**
     * Sets the value to a value that implements JsonSerializable.
     *
     * @param value The value to set.
     */
    public func set<T>(value: T): Unit where T <: JsonSerializable {
        value.set(this)
    }

    /**
     * Sets the value to Null.
     */
    public func setNull(): Unit {
        root.throwIfClosed()
        unsafe { RJ4CJValue_setNull(handle) }
    }

    /**
     * Sets the value to a Bool.
     *
     * @param value The boolean value to set.
     */
    public func setBool(value: Bool): Unit {
        root.throwIfClosed()
        unsafe { RJ4CJValue_setBool(handle, value) }
    }

    /**
     * Sets the value to an Int32.
     *
     * @param value The Int32 value to set.
     */
    public func setInt32(value: Int32): Unit {
        root.throwIfClosed()
        unsafe { RJ4CJValue_setInt32(handle, value) }
    }

    /**
     * Sets the value to a UInt32.
     *
     * @param value The UInt32 value to set.
     */
    public func setUInt32(value: UInt32): Unit {
        root.throwIfClosed()
        unsafe { RJ4CJValue_setUInt32(handle, value) }
    }

    /**
     * Sets the value to an Int64.
     *
     * @param value The Int64 value to set.
     */
    public func setInt64(value: Int64): Unit {
        root.throwIfClosed()
        unsafe { RJ4CJValue_setInt64(handle, value) }
    }

    /**
     * Sets the value to a UInt64.
     *
     * @param value The UInt64 value to set.
     */
    public func setUInt64(value: UInt64): Unit {
        root.throwIfClosed()
        unsafe { RJ4CJValue_setUInt64(handle, value) }
    }

    /**
     * Sets the value to a Float32.
     *
     * @param value The Float32 value to set.
     */
    public func setFloat32(value: Float32): Unit {
        root.throwIfClosed()
        unsafe { RJ4CJValue_setFloat32(handle, value) }
    }

    /**
     * Sets the value to a Float64.
     *
     * @param value The Float64 value to set.
     */
    public func setFloat64(value: Float64): Unit {
        root.throwIfClosed()
        unsafe { RJ4CJValue_setFloat64(handle, value) }
    }

    /**
     * Sets the value to a String.
     *
     * @param value The String value to set.
     */
    public func setString(value: String): Unit {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(value.size)
            let rawData = acquireArrayRawData(value.rawData())
            RJ4CJValue_setString(root.handle, handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
        }
    }

    /**
     * Sets the value to an empty Array.
     */
    public func setArray(): Unit {
        root.throwIfClosed()
        unsafe { RJ4CJValue_setArray(handle) }
    }

    /**
     * Gets the value of an array by its index.
     *
     * @param index The array index.
     *
     * @return `Some(JsonValue)` if the index is valid; `None` if the index is out of range.
     */
    public func get(index: Int64): ?JsonValue {
        root.throwIfClosed()
        unsafe {
            let ptr = RJ4CJValue_arrayGet(handle, index)
            return match (ptr.isNull()) {
                case false => JsonValue(ptr, root: root)
                case true => None
            }
        }
    }

    /**
     * Gets the value of an array by its index.
     *
     * @param index The array index.
     *
     * @return `JsonValue` if the index is valid.
     *
     * @throws IndexOutOfBoundsException If index out of range.
     */
    public operator func [](index: Int64): JsonValue {
        match (get(index)) {
            case Some(value) => value
            case None => throw IndexOutOfBoundsException("Index out of range.")
        }
    }

    /**
     * Adds an element to this array whose value is determined by the provided JsonSerializable.
     *
     * @param value The JsonSerializable value to add.
     *
     * @return A JsonValue wrapping the newly added value for fluent chaining.
     */
    public func add<T>(value: T): JsonValue where T <: JsonSerializable {
        value.add(this)
    }

    /**
     * Pushes back a null value to the array.
     *
     * @return A JsonValue wrapping the newly added null for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addNull(): JsonValue {
        root.throwIfClosed()
        let ptr = unsafe { RJ4CJValue_arrayAddNull(root.handle, handle) }
        if (ptr.isNull()) {
            throw RapidJsonException("Failed to add value.")
        }
        return JsonValue(ptr, root: root)
    }

    /**
     * Pushes back a boolean value to the array.
     *
     * @param val The boolean value to push back.
     *
     * @return A JsonValue wrapping the newly added boolean for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addBool(val: Bool): JsonValue {
        root.throwIfClosed()
        let ptr = unsafe { RJ4CJValue_arrayAddBool(root.handle, handle, val) }
        if (ptr.isNull()) {
            throw RapidJsonException("Failed to add value.")
        }
        return JsonValue(ptr, root: root)
    }

    /**
     * Pushes back an Int32 value to the array.
     *
     * @param val The Int32 value to push back.
     *
     * @return A JsonValue wrapping the newly added Int32 for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addInt32(val: Int32): JsonValue {
        root.throwIfClosed()
        let ptr = unsafe { RJ4CJValue_arrayAddInt32(root.handle, handle, val) }
        if (ptr.isNull()) {
            throw RapidJsonException("Failed to add value.")
        }
        return JsonValue(ptr, root: root)
    }

    /**
     * Pushes back a UInt32 value to the array.
     *
     * @param val The UInt32 value to push back.
     *
     * @return A JsonValue wrapping the newly added UInt32 for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addUInt32(val: UInt32): JsonValue {
        root.throwIfClosed()
        let ptr = unsafe { RJ4CJValue_arrayAddUInt32(root.handle, handle, val) }
        if (ptr.isNull()) {
            throw RapidJsonException("Failed to add value.")
        }
        return JsonValue(ptr, root: root)
    }

    /**
     * Pushes back an Int64 value to the array.
     *
     * @param val The Int64 value to push back.
     *
     * @return A JsonValue wrapping the newly added Int64 for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addInt64(val: Int64): JsonValue {
        root.throwIfClosed()
        let ptr = unsafe { RJ4CJValue_arrayAddInt64(root.handle, handle, val) }
        if (ptr.isNull()) {
            throw RapidJsonException("Failed to add value.")
        }
        return JsonValue(ptr, root: root)
    }

    /**
     * Pushes back a UInt64 value to the array.
     *
     * @param val The UInt64 value to push back.
     *
     * @return A JsonValue wrapping the newly added UInt64 for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addUInt64(val: UInt64): JsonValue {
        root.throwIfClosed()
        let ptr = unsafe { RJ4CJValue_arrayAddUInt64(root.handle, handle, val) }
        if (ptr.isNull()) {
            throw RapidJsonException("Failed to add value.")
        }
        return JsonValue(ptr, root: root)
    }

    /**
     * Pushes back a Float32 value to the array.
     *
     * @param val The Float32 value to push back.
     *
     * @return A JsonValue wrapping the newly added Float32 for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addFloat32(val: Float32): JsonValue {
        root.throwIfClosed()
        let ptr = unsafe { RJ4CJValue_arrayAddFloat32(root.handle, handle, val) }
        if (ptr.isNull()) {
            throw RapidJsonException("Failed to add value.")
        }
        return JsonValue(ptr, root: root)
    }

    /**
     * Pushes back a Float64 value to the array.
     *
     * @param val The Float64 value to push back.
     *
     * @return A JsonValue wrapping the newly added Float64 for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addFloat64(val: Float64): JsonValue {
        root.throwIfClosed()
        let ptr = unsafe { RJ4CJValue_arrayAddFloat64(root.handle, handle, val) }
        if (ptr.isNull()) {
            throw RapidJsonException("Failed to add value.")
        }
        return JsonValue(ptr, root: root)
    }

    /**
     * Pushes back a String value to the array.
     *
     * @param val The String value to push back.
     *
     * @return A JsonValue wrapping the newly added String for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addString(val: String): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(val.size)
            let rawData = acquireArrayRawData(val.rawData())
            let ptr = RJ4CJValue_arrayAddString(root.handle, handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Pushes back an empty Array value to the array.
     *
     * @return A JsonValue wrapping the newly added array for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addArray(): JsonValue {
        root.throwIfClosed()
        let ptr = unsafe { RJ4CJValue_arrayAddArray(root.handle, handle) }
        if (ptr.isNull()) {
            throw RapidJsonException("Failed to add value.")
        }
        return JsonValue(ptr, root: root)
    }

    /**
     * Pushes back an empty Object value to the array.
     *
     * @return A JsonValue wrapping the newly added object for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addObject(): JsonValue {
        root.throwIfClosed()
        let ptr = unsafe { RJ4CJValue_arrayAddObject(root.handle, handle) }
        if (ptr.isNull()) {
            throw RapidJsonException("Failed to add value.")
        }
        return JsonValue(ptr, root: root)
    }

    /**
     * Removes the last element in the array.
     *
     * @return `true` if success; `false` if this value is not an array or is empty.
     */
    public func pop(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_arrayPop(handle) }
    }

    /**
     * Removes all elements in the array. Capacity remains unchanged.
     *
     * @return `true` if success; `false` if this value is not an array.
     */
    public func clearArray(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_arrayClear(handle) }
    }

    /**
     * Erases an element of array by index.
     * Note: Elements are shifted to fill the gap.
     *
     * @param index The index of the element to erase.
     *
     * @return `true` if success; `false` if this value is not an array or index is out of bounds.
     */
    public func eraseArrayItem(index: Int64): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_arrayErase(handle, UInt32(index)) }
    }

    /**
     * Requests the array to have enough capacity to store elements.
     * Prevents reallocation when using PushBack functions.
     *
     * @param newCapacity The desired capacity (number of elements).
     *
     * @return `true` if success; `false` if this value is not an array or out of memory.
     */
    public func reserveArray(newCapacity: UInt32): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_arrayReserve(root.handle, handle, newCapacity) }
    }

    /**
     * Gets the current capacity of the array.
     *
     * @return The capacity, or 0 if this value is not an array.
     */
    public func getArrayCapacity(): UInt32 {
        root.throwIfClosed()
        unsafe { RJ4CJValue_arrayCapacity(handle) }
    }

    /**
     * Sets the value to an empty Object.
     */
    public func setObject(): Unit {
        root.throwIfClosed()
        unsafe { RJ4CJValue_setObject(handle) }
    }

    /**
     * Checks if a key exists in this JSON object.
     *
     * @param key The key to look up in the JSON object.
     *
     * @return `true` if the key exists; `false` otherwise.
     */
    public func hasMember(key: String): Bool {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJValue_memberContains(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Retrieves a sub-value (JsonValue) associated with the specified key.
     *
     * This function is used to access nested JSON values. If the key exists,
     * it returns a handle to that value.
     *
     * @param key The key to look up.
     *
     * @return `Some(JsonValue)` if the key exists; `None` if the key is missing.
     */
    public func get(key: String): ?JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberGet(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return match (ptr.isNull()) {
                case false => JsonValue(ptr, root: root)
                case true => None
            }
        }
    }

    /**
     * Retrieves a sub-value (JsonValue) associated with the specified key.
     *
     * @param key The key to look up.
     *
     * @return `JsonValue` corresponding to the key.
     *
     * @throws NoneValueException If value does not exist.
     */
    public operator func [](key: String): JsonValue {
        match (get(key)) {
            case Some(value) => value
            case None => throw NoneValueException("Value does not exist.")
        }
    }

    /**
     * Gets the number of members in the object.
     *
     * It returns the count of key-value pairs if this value is an object, or 0 otherwise.
     *
     * @return The number of members in the object.
     */
    public prop memberSize: Int64 {
        get() {
            root.throwIfClosed()
            Int64(unsafe { RJ4CJValue_memberSize(handle) })
        }
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
        root.throwIfClosed()
        unsafe {
            let ptrBegin = RJ4CJValue_memberBegin(handle)
            let ptrEnd = RJ4CJValue_memberEnd(handle)
            return JsonMemberIterator(root, ptrBegin, ptrEnd)
        }
    }

    /**
     * Adds a member to this object whose value is determined by the provided JsonSerializable.
     *
     * @param key The key of the member to add.
     * @param value The JsonSerializable value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     */
    public func addMember<T>(key: String, value: T): JsonValue where T <: JsonSerializable {
        value.addMember(key, this)
    }

    /**
     * Adds a null member to the object.
     *
     * @param key The key to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberNull(key: String): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberAddNull(root.handle, handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Adds a boolean member to the object.
     *
     * @param key The key to add.
     * @param val The boolean value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberBool(key: String, val: Bool): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberAddBool(root.handle, handle, rawData.pointer, strSize, val)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Adds an Int32 member to the object.
     *
     * @param key The key to add.
     * @param val The Int32 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberInt32(key: String, val: Int32): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberAddInt32(root.handle, handle, rawData.pointer, strSize, val)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Adds a UInt32 member to the object.
     *
     * @param key The key to add.
     * @param val The UInt32 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberUInt32(key: String, val: UInt32): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberAddUInt32(root.handle, handle, rawData.pointer, strSize, val)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Adds an Int64 member to the object.
     *
     * @param key The key to add.
     * @param val The Int64 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberInt64(key: String, val: Int64): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberAddInt64(root.handle, handle, rawData.pointer, strSize, val)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Adds a UInt64 member to the object.
     *
     * @param key The key to add.
     * @param val The UInt64 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberUInt64(key: String, val: UInt64): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberAddUInt64(root.handle, handle, rawData.pointer, strSize, val)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Adds a Float32 member to the object.
     *
     * @param key The key to add.
     * @param val The Float32 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberFloat32(key: String, val: Float32): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberAddFloat32(root.handle, handle, rawData.pointer, strSize, val)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Adds a Float64 member to the object.
     *
     * @param key The key to add.
     * @param val The Float64 value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberFloat64(key: String, val: Float64): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberAddFloat64(root.handle, handle, rawData.pointer, strSize, val)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Adds a String member to the object.
     *
     * @param key The key to add.
     * @param val The String value to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberString(key: String, val: String): JsonValue {
        root.throwIfClosed()
        unsafe {
            let keySize = UInt32(key.size)
            let keyRawData = acquireArrayRawData(key.rawData())
            let valSize = UInt32(val.size)
            let valRawData = acquireArrayRawData(val.rawData())
            let ptr = RJ4CJValue_memberAddString(root.handle, handle, keyRawData.pointer, keySize, valRawData.pointer,
                valSize)
            releaseArrayRawData(keyRawData)
            releaseArrayRawData(valRawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Adds an empty Array member to the object.
     *
     * @param key The key to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberArray(key: String): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberAddArray(root.handle, handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Adds an empty Object member to the object.
     *
     * @param key The key to add.
     *
     * @return `JsonValue` wrapping the newly added member for fluent chaining.
     *
     * @throws RapidJsonException If the value could not be added.
     */
    public func addMemberObject(key: String): JsonValue {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ptr = RJ4CJValue_memberAddObject(root.handle, handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            if (ptr.isNull()) {
                throw RapidJsonException("Failed to add value.")
            }
            return JsonValue(ptr, root: root)
        }
    }

    /**
     * Removes all members in the object. Capacity remains unchanged.
     *
     * @return `true` if success; `false` if this value is not an object.
     */
    public func clearObject(): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_memberClear(handle) }
    }

    /**
     * Removes a member in object by its name.
     * Note: This function may reorder the object members.
     *
     * @param key The key to remove.
     *
     * @return `true` if the member existed and was removed; `false` otherwise.
     */
    public func removeMember(key: String): Bool {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJValue_memberRemove(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Erases a member in object by its name.
     * Note: This function preserves the relative order of the remaining members (slower than removeMember).
     *
     * @param key The key to erase.
     *
     * @return `true` if the member existed and was erased; `false` otherwise.
     */
    public func eraseMember(key: String): Bool {
        root.throwIfClosed()
        unsafe {
            let strSize = UInt32(key.size)
            let rawData = acquireArrayRawData(key.rawData())
            let ret = RJ4CJValue_memberErase(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Requests the object to have enough capacity to store members.
     * Prevents reallocation when using AddMember functions.
     *
     * @param newCapacity The desired capacity (number of members).
     *
     * @return `true` if success; `false` if this value is not an object or out of memory.
     */
    public func reserveObject(newCapacity: UInt32): Bool {
        root.throwIfClosed()
        unsafe { RJ4CJValue_memberReserve(root.handle, handle, newCapacity) }
    }

    /**
     * Gets the current capacity of the object.
     *
     * @return The capacity, or 0 if this value is not an object.
     */
    public func getMemberCapacity(): UInt32 {
        root.throwIfClosed()
        unsafe { RJ4CJValue_memberCapacity(handle) }
    }
}
