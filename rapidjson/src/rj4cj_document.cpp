#include "rj4cj_common.h"

/**
 * Represents the result of a JSON parse operation.
 *
 * This struct encapsulates the outcome of `RJ4CJDocument_parse`. It follows a "Result" pattern
 * containing either the successfully parsed document or the error details.
 */
typedef struct {
    rapidjson::Document* doc;        //!< Handle to the parsed document. `nullptr` if parsing failed.
    rapidjson::ParseErrorCode error; //!< The error code. `kParseErrorNone` (0) indicates success.
    size_t offset;                   //!< The byte offset in the input JSON where the error occurred. 0 if no error.
} RJ4CJ_DocumentParseResult;

extern "C" {
    /**
     * Parses a JSON string into a new Document.
     *
     * @param str Pointer to the JSON char array.
     * @param length The length of the JSON data.
     *
     * @return A struct containing the document pointer, error code, and error offset.
     *         If parsing fails, doc will be nullptr and error will contain the specific code.
     */
    RJ4CJ_API RJ4CJ_DocumentParseResult RJ4CJDocument_parse(const char* str, size_t length) {
        RJ4CJ_DocumentParseResult result = {nullptr, rapidjson::ParseErrorCode::kParseErrorDocumentEmpty, 0};

        if (!str) {
            return result;
        }

        auto doc = new rapidjson::Document();
        if (!doc) {
            return result;
        }

        doc->Parse<rapidjson::ParseFlag::kParseValidateEncodingFlag>(str, length);

        if (doc->HasParseError()) {
            result.error = doc->GetParseError();
            result.offset = doc->GetErrorOffset();
            delete doc;
            return result;
        }

        result.doc = doc;
        result.error = rapidjson::ParseErrorCode::kParseErrorNone;
        return result;
    }

    /**
     * Frees a previously parsed JSON document.
     *
     * @param doc Handle to the document to free.
     */
    RJ4CJ_API void RJ4CJDocument_free(rapidjson::Document* doc) {
        if (doc) {
            delete doc;
        }
    }

    /**
     * Clone a JSON value into a new, independent Document.
     *
     * @param doc Handle to the Value to clone.
     *
     * @return A pointer to the new cloned Document.
     *         Returns nullptr if the input doc is null.
     *         IMPORTANT: The caller is responsible for freeing this using RJ4CJReader_free().
     */
    RJ4CJ_API rapidjson::Document* RJ4CJDocument_clone(rapidjson::Value* value) {
        if (!value) {
            return nullptr;
        }

        // Create a new document which has its own independent memory allocator
        auto* cloned_doc = new rapidjson::Document();
        if (!cloned_doc) {
            return nullptr;
        }

        // Copy the contents of the old document into the new one.
        // This deeply copies all strings, arrays, and objects into cloned_doc's allocator.
        cloned_doc->CopyFrom(*value, cloned_doc->GetAllocator());

        return cloned_doc;
    }
}
