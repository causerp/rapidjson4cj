package rapidjson4cj

public class PrettyWriter <: Resource & JsonWriter {
    var handle: CPointer<Unit>

    /**
     * Creates a new pretty JSON writer instance with default formatting.
     *
     * Defaults to 2 spaces per indent level and {@link FormatOptions.Default}.
     */
    public init() {
        unsafe { handle = RJ4CJPrettyWriter_create(2, FormatOptions.Default) }
    }

    /**
     * Creates a new pretty JSON writer instance with custom formatting options.
     *
     * @param indentCharCount The number of spaces to indent per level.
     *                        Pass 0 for minified JSON.
     * @param formatOptions Formatting options controlling array and object layout
     *                      (e.g., {@link FormatOptions.Default} for pretty printing,
     *                      or {@link FormatOptions.SingleLineArray} for compact arrays).
     */
    public init(indentCharCount: UInt32, formatOptions: FormatOptions) {
        unsafe { handle = RJ4CJPrettyWriter_create(indentCharCount, formatOptions) }
    }

    ~init() {
        if (handle.isNotNull()) {
            unsafe { RJ4CJPrettyWriter_destroy(handle) }
            handle = CPointer()
        }
    }

    /**
     * Checks if the resource handle is closed.
     *
     * @return `true` if the handle is null (closed); `false` otherwise.
     */
    public func isClosed(): Bool {
        handle.isNull()
    }

    /**
     * Closes the resource and destroys the internal writer object.
     */
    public func close(): Unit {
        if (handle.isNull()) {
            return
        }
        unsafe { RJ4CJPrettyWriter_destroy(handle) }
        handle = CPointer()
    }

    /**
     * Throws an exception if the writer handle has been closed.
     *
     * @throws RapidJsonException If the writer is closed.
     */
    func throwIfClosed(): Unit {
        if (handle.isNull()) {
            throw RapidJsonException("Writer is closed.")
        }
    }

    /**
     * Checks whether the output buffered so far is a complete JSON.
     *
     * @return `true` if a complete root object or array has been closed; `false` otherwise.
     */
    public func isComplete(): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_isComplete(handle) }
    }

    /**
     * Gets the current maximum number of decimal places for double output.
     *
     * @return The current maximum decimal places setting.
     */
    public func getMaxDecimalPlaces(): Int32 {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_getMaxDecimalPlaces(handle) }
    }

    /**
     * Sets the custom indentation for the writer.
     *
     * @param indentCharCount The number of spaces to indent per level. Pass 0 for minified output.
     */
    public func setIndent(indentCharCount: UInt32): Unit {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_setIndent(handle, indentCharCount) }
    }

    /**
     * Sets the formatting options for the writer.
     *
     * @param formatOptions Formatting options (e.g., Default or SingleLineArray).
     */
    public func setFormatOptions(formatOptions: FormatOptions): Unit {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_setFormatOptions(handle, formatOptions) }
    }

    /**
     * Sets the maximum number of decimal places for double output.
     *
     * @param maxDecimalPlaces The maximum number of decimal places.
     *                          Pass 324 to restore default truncation behavior.
     */
    public func setMaxDecimalPlaces(maxDecimalPlaces: Int32): Unit {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_setMaxDecimalPlaces(handle, maxDecimalPlaces) }
    }

    /**
     * Gets the resulting JSON string from the buffer.
     *
     * @return The generated JSON string.
     */
    public func getString(): String {
        throwIfClosed()
        unsafe {
            let stringView = RJ4CJPrettyWriter_getString(handle)
            let strPtr = stringView.str
            if (strPtr.isNull()) {
                return ""
            }
            let len = Int64(stringView.length)
            if (len == 0) {
                return ""
            }
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
     * Writes a null value.
     *
     * @return `true` if successful; `false` otherwise.
     */
    public func writeNullValue(): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_writeNull(handle) }
    }

    /**
     * Writes a boolean value.
     *
     * @param b The boolean value to write.
     * @return `true` if successful; `false` otherwise.
     */
    public func writeBool(b: Bool): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_writeBool(handle, b) }
    }

    /**
     * Writes an Int32 value.
     *
     * @param i The Int32 value to write.
     * @return `true` if successful; `false` otherwise.
     */
    public func writeInt32(i: Int32): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_writeInt32(handle, i) }
    }

    /**
     * Writes a UInt32 value.
     *
     * @param u The UInt32 value to write.
     * @return `true` if successful; `false` otherwise.
     */
    public func writeUInt32(u: UInt32): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_writeUInt32(handle, u) }
    }

    /**
     * Writes an Int64 value.
     *
     * @param i64 The Int64 value to write.
     * @return `true` if successful; `false` otherwise.
     */
    public func writeInt64(i64: Int64): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_writeInt64(handle, i64) }
    }

    /**
     * Writes a UInt64 value.
     *
     * @param u64 The UInt64 value to write.
     * @return `true` if successful; `false` otherwise.
     */
    public func writeUInt64(u64: UInt64): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_writeUInt64(handle, u64) }
    }

    /**
     * Writes a Float32 value.
     *
     * @param f The Float32 value to write.
     * @return `true` if successful; `false` otherwise.
     */
    public func writeFloat32(f: Float32): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_writeFloat32(handle, f) }
    }

    /**
     * Writes a Float64 value.
     *
     * @param d The Float64 value to write.
     * @return `true` if successful; `false` otherwise.
     */
    public func writeFloat64(d: Float64): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_writeFloat64(handle, d) }
    }

    /**
     * Writes a string value.
     *
     * @param str The string to write.
     * @return `true` if successful; `false` otherwise.
     */
    public func writeString(str: String): Bool {
        throwIfClosed()
        unsafe {
            let strSize = UInt32(str.size)
            let rawData = acquireArrayRawData(str.rawData())
            let ret = RJ4CJPrettyWriter_writeString(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Writes a JsonValue.
     *
     * @param value The JsonValue to write.
     * @return `true` if successful; `false` otherwise.
     */
    public func writeValue(value: JsonValue): Bool {
        throwIfClosed()
        value.root.throwIfClosed()
        unsafe { RJ4CJPrettyWriter_writeValue(handle, value.handle) }
    }

    /**
     * Writes an object key.
     *
     * @param key The key string to write.
     * @return `true` if successful; `false` otherwise.
     */
    public func writeName(name: String): Bool {
        throwIfClosed()
        unsafe {
            let strSize = UInt32(name.size)
            let rawData = acquireArrayRawData(name.rawData())
            let ret = RJ4CJPrettyWriter_writeName(handle, rawData.pointer, strSize)
            releaseArrayRawData(rawData)
            return ret
        }
    }

    /**
     * Starts writing a JSON Array (i.e., writes '[').
     *
     * @return `true` if successful; `false` otherwise.
     */
    public func startArray(): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_startArray(handle) }
    }

    /**
     * Ends writing a JSON Array (i.e., writes ']').
     *
     * @return `true` if successful; `false` otherwise.
     */
    public func endArray(): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_endArray(handle) }
    }

    /**
     * Starts writing a JSON Object (i.e., writes '{').
     *
     * @return `true` if successful; `false` otherwise.
     */
    public func startObject(): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_startObject(handle) }
    }

    /**
     * Ends writing a JSON Object (i.e., writes '}').
     *
     * @return `true` if successful; `false` otherwise.
     */
    public func endObject(): Bool {
        throwIfClosed()
        unsafe { RJ4CJPrettyWriter_endObject(handle) }
    }
}
