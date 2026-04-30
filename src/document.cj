package rapidjson4cj

class Document {
    var handle: CPointer<Unit>

    init(handle: CPointer<Unit>) {
        this.handle = handle
    }

    /**
     * Loads json from string.
     *
     * @throws RapidJsonParseException If loading was unsuccessful.
     */
    init(json: String) {
        unsafe {
            let rawData = json.rawData()
            let rawArr = acquireArrayRawData(rawData)
            let parseResult = RJ4CJDocument_parse(rawArr.pointer, UIntNative(json.size))
            releaseArrayRawData(rawArr)
            if (parseResult.error == ParseErrorCode.None) {
                handle = parseResult.doc
            } else {
                throw RapidJsonParseException(parseResult.error, parseResult.offset)
            }
        }
    }

    ~init() {
        if (handle.isNotNull()) {
            unsafe { RJ4CJDocument_free(handle) }
            handle = CPointer()
        }
    }

    /**
     * Checks if the resource handle is closed.
     *
     * @return `true` if the handle is null (closed); `false` otherwise.
     */
    func isClosed(): Bool {
        handle.isNull()
    }

    /**
     * Closes the resource and releases the internal document object.
     */
    func close(): Unit {
        if (handle.isNull()) {
            return
        }
        unsafe { RJ4CJDocument_free(handle) }
        handle = CPointer()
    }

    /**
     * Throws an exception if the document handle has been closed.
     *
     * @throws RapidJsonException If the document is closed.
     */
    func throwIfClosed(): Unit {
        if (handle.isNull()) {
            throw RapidJsonException("Document is closed.")
        }
    }

    func getValue(): JsonValue {
        throwIfClosed()
        JsonValue(handle, root: this)
    }
}
