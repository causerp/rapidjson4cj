#include "rj4cj_common.h"

struct RJ4CJ_PrettyWriter {
    rapidjson::StringBuffer buffer;
    rapidjson::PrettyWriter<rapidjson::StringBuffer> doc;

    RJ4CJ_PrettyWriter(unsigned indentCharCount, rapidjson::PrettyFormatOptions formatOptions) : buffer(), doc(buffer) {
        doc.SetIndent(' ', indentCharCount);
        doc.SetFormatOptions(formatOptions);
    }
};

extern "C" {
    /**
     * Creates a new JSON writer instance.
     *
     * @param indentCharCount The number of indent characters per level.
     *                        Pass 0 for minified JSON.
     * @param formatOptions Formatting options (e.g., kFormatDefault or kFormatSingleLineArray).
     *
     * @return A pointer to the newly created writer. Must be freed with RJ4CJWriter_destroy.
     */
    RJ4CJ_API RJ4CJ_PrettyWriter* RJ4CJPrettyWriter_create(unsigned indentCharCount,
                                                           rapidjson::PrettyFormatOptions formatOptions) {
        return new RJ4CJ_PrettyWriter(indentCharCount, formatOptions);
    }

    /**
     * Destroys the writer and frees its memory.
     *
     * @param writer The writer to destroy.
     */
    RJ4CJ_API void RJ4CJPrettyWriter_destroy(RJ4CJ_PrettyWriter* writer) {
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
    RJ4CJ_API bool RJ4CJPrettyWriter_isComplete(RJ4CJ_PrettyWriter* writer) {
        return writer ? writer->doc.IsComplete() : false;
    }

    /**
     * Gets the current maximum number of decimal places for double output.
     *
     * @param writer The writer handle.
     * @return The current maximum decimal places setting, or 0 if the writer is null.
     */
    RJ4CJ_API int RJ4CJPrettyWriter_getMaxDecimalPlaces(RJ4CJ_PrettyWriter* writer) {
        return writer ? writer->doc.GetMaxDecimalPlaces() : 0;
    }

    /**
     * Sets the custom indentation for the writer.
     *
     * @param writer The writer handle.
     * @param indentCharCount The number of spaces to indent per level. Pass 0 for minified output.
     */
    RJ4CJ_API void RJ4CJPrettyWriter_setIndent(RJ4CJ_PrettyWriter* writer, unsigned indentCharCount) {
        if (writer) {
            writer->doc.SetIndent(' ', indentCharCount);
        }
    }

    /**
     * Sets the formatting options for the writer.
     *
     * @param writer The writer handle.
     * @param formatOptions Formatting options (e.g., kFormatDefault or kFormatSingleLineArray).
     */
    RJ4CJ_API void RJ4CJPrettyWriter_setFormatOptions(RJ4CJ_PrettyWriter* writer,
                                                      rapidjson::PrettyFormatOptions formatOptions) {
        if (writer) {
            writer->doc.SetFormatOptions(formatOptions);
        }
    }

    /**
     * Sets the maximum number of decimal places for double output.
     *
     * @param writer The writer handle.
     * @param maxDecimalPlaces The maximum number of decimal places.
     *                          Pass 324 (kDefaultMaxDecimalPlaces) to restore default truncation behavior.
     */
    RJ4CJ_API void RJ4CJPrettyWriter_setMaxDecimalPlaces(RJ4CJ_PrettyWriter* writer, int maxDecimalPlaces) {
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
    RJ4CJ_API RJ4CJ_StringView RJ4CJPrettyWriter_getString(RJ4CJ_PrettyWriter* writer) {
        RJ4CJ_StringView result = {nullptr, 0};
        if (writer) {
            result.str = writer->buffer.GetString();
            result.length = writer->buffer.GetLength();
        }
        return result;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_writeNull(RJ4CJ_PrettyWriter* writer) {
        return writer ? writer->doc.Null() : false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_writeBool(RJ4CJ_PrettyWriter* writer, bool b) {
        return writer ? writer->doc.Bool(b) : false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_writeInt32(RJ4CJ_PrettyWriter* writer, int32_t i) {
        return writer ? writer->doc.Int(i) : false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_writeUInt32(RJ4CJ_PrettyWriter* writer, uint32_t u) {
        return writer ? writer->doc.Uint(u) : false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_writeInt64(RJ4CJ_PrettyWriter* writer, int64_t i64) {
        return writer ? writer->doc.Int64(i64) : false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_writeUInt64(RJ4CJ_PrettyWriter* writer, uint64_t u64) {
        return writer ? writer->doc.Uint64(u64) : false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_writeFloat32(RJ4CJ_PrettyWriter* writer, float f) {
        return writer ? writer->doc.Double(static_cast<double>(f)) : false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_writeFloat64(RJ4CJ_PrettyWriter* writer, double d) {
        return writer ? writer->doc.Double(d) : false;
    }

    /**
     * Writes an object key.
     * Note: In JSON, keys are always strings. This is functionally identical to RJ4CJWriter_writeString
     * but named RJ4CJWriter_writeName for semantic clarity in the C API.
     */
    RJ4CJ_API bool RJ4CJPrettyWriter_writeName(RJ4CJ_PrettyWriter* writer, const char* str, rapidjson::SizeType length) {
        if (writer && str) {
            return writer->doc.Key(str, length, true);
        }
        return false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_writeString(RJ4CJ_PrettyWriter* writer, const char* str,
                                                 rapidjson::SizeType length) {
        if (writer && str) {
            return writer->doc.String(str, length, true);
        }
        return false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_writeValue(RJ4CJ_PrettyWriter* writer, rapidjson::Value* value) {
        if (writer && value) {
            value->Accept(writer->doc);
            return true;
        }
        return false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_startArray(RJ4CJ_PrettyWriter* writer) {
        return writer ? writer->doc.StartArray() : false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_endArray(RJ4CJ_PrettyWriter* writer) {
        return writer ? writer->doc.EndArray() : false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_startObject(RJ4CJ_PrettyWriter* writer) {
        return writer ? writer->doc.StartObject() : false;
    }

    RJ4CJ_API bool RJ4CJPrettyWriter_endObject(RJ4CJ_PrettyWriter* writer) {
        return writer ? writer->doc.EndObject() : false;
    }
}
