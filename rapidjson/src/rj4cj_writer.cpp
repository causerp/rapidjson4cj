#include "rj4cj_common.h"

struct RJ4CJ_Writer {
    rapidjson::StringBuffer buffer;
    rapidjson::Writer<rapidjson::StringBuffer> doc;

    RJ4CJ_Writer() : buffer(), doc(buffer) {}
};

extern "C" {
    /**
     * Creates a new JSON writer instance.
     *
     * @return A pointer to the newly created writer. Must be freed with RJ4CJWriter_destroy.
     */
    RJ4CJ_API RJ4CJ_Writer* RJ4CJWriter_create() {
        return new RJ4CJ_Writer();
    }

    /**
     * Destroys the writer and frees its memory.
     *
     * @param writer The writer to destroy.
     */
    RJ4CJ_API void RJ4CJWriter_destroy(RJ4CJ_Writer* writer) {
        if (writer) {
            delete writer;
        }
    }

    /**
     * Checks whether the output buffered so far is a complete JSON.
     *
     * @param writer The writer handle.
     * @return true if a complete root object or array has been closed, false otherwise.
     */
    RJ4CJ_API bool RJ4CJWriter_isComplete(RJ4CJ_Writer* writer) {
        return writer ? writer->doc.IsComplete() : false;
    }

    /**
     * Gets the current maximum number of decimal places for double output.
     *
     * @param writer The writer handle.
     * @return The current maximum decimal places setting, or 0 if the writer is null.
     */
    RJ4CJ_API int RJ4CJWriter_getMaxDecimalPlaces(RJ4CJ_Writer* writer) {
        return writer ? writer->doc.GetMaxDecimalPlaces() : 0;
    }

    /**
     * Sets the maximum number of decimal places for double output.
     *
     * @param writer The writer handle.
     * @param maxDecimalPlaces The maximum number of decimal places.
     *                          Pass 324 (kDefaultMaxDecimalPlaces) to restore default truncation behavior.
     */
    RJ4CJ_API void RJ4CJWriter_setMaxDecimalPlaces(RJ4CJ_Writer* writer, int maxDecimalPlaces) {
        if (writer) {
            writer->doc.SetMaxDecimalPlaces(maxDecimalPlaces);
        }
    }

    /**
     * Gets the resulting JSON string from the buffer.
     *
     * @param writer The writer handle.
     * @return A StringView containing the pointer to the string data and its length.
     *         Returns {nullptr, 0} if the writer is null.
     */
    RJ4CJ_API RJ4CJ_StringView RJ4CJWriter_getString(RJ4CJ_Writer* writer) {
        RJ4CJ_StringView result = {nullptr, 0};
        if (writer) {
            result.str = writer->buffer.GetString();
            result.length = writer->buffer.GetLength();
        }
        return result;
    }

    RJ4CJ_API bool RJ4CJWriter_writeNull(RJ4CJ_Writer* writer) {
        return writer ? writer->doc.Null() : false;
    }

    RJ4CJ_API bool RJ4CJWriter_writeBool(RJ4CJ_Writer* writer, bool b) {
        return writer ? writer->doc.Bool(b) : false;
    }

    RJ4CJ_API bool RJ4CJWriter_writeInt32(RJ4CJ_Writer* writer, int32_t i) {
        return writer ? writer->doc.Int(i) : false;
    }

    RJ4CJ_API bool RJ4CJWriter_writeUInt32(RJ4CJ_Writer* writer, uint32_t u) {
        return writer ? writer->doc.Uint(u) : false;
    }

    RJ4CJ_API bool RJ4CJWriter_writeInt64(RJ4CJ_Writer* writer, int64_t i64) {
        return writer ? writer->doc.Int64(i64) : false;
    }

    RJ4CJ_API bool RJ4CJWriter_writeUInt64(RJ4CJ_Writer* writer, uint64_t u64) {
        return writer ? writer->doc.Uint64(u64) : false;
    }

    RJ4CJ_API bool RJ4CJWriter_writeFloat32(RJ4CJ_Writer* writer, float f) {
        return writer ? writer->doc.Double(static_cast<double>(f)) : false;
    }

    RJ4CJ_API bool RJ4CJWriter_writeFloat64(RJ4CJ_Writer* writer, double d) {
        return writer ? writer->doc.Double(d) : false;
    }

    /**
     * Writes an object key.
     * Note: In JSON, keys are always strings. This is functionally identical to RJ4CJWriter_writeString
     * but named RJ4CJWriter_writeName for semantic clarity in the C API.
     */
    RJ4CJ_API bool RJ4CJWriter_writeName(RJ4CJ_Writer* writer, const char* str, rapidjson::SizeType length) {
        if (writer && str) {
            return writer->doc.Key(str, length, true);
        }
        return false;
    }

    RJ4CJ_API bool RJ4CJWriter_writeString(RJ4CJ_Writer* writer, const char* str, rapidjson::SizeType length) {
        if (writer && str) {
            return writer->doc.String(str, length, true);
        }
        return false;
    }

    RJ4CJ_API bool RJ4CJWriter_writeValue(RJ4CJ_Writer* writer, rapidjson::Value* value) {
        if (writer && value) {
            value->Accept(writer->doc);
            return true;
        }
        return false;
    }

    RJ4CJ_API bool RJ4CJWriter_startArray(RJ4CJ_Writer* writer) {
        return writer ? writer->doc.StartArray() : false;
    }

    RJ4CJ_API bool RJ4CJWriter_endArray(RJ4CJ_Writer* writer) {
        return writer ? writer->doc.EndArray() : false;
    }

    RJ4CJ_API bool RJ4CJWriter_startObject(RJ4CJ_Writer* writer) {
        return writer ? writer->doc.StartObject() : false;
    }

    RJ4CJ_API bool RJ4CJWriter_endObject(RJ4CJ_Writer* writer) {
        return writer ? writer->doc.EndObject() : false;
    }
}
