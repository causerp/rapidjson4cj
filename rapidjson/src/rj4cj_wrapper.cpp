#include <cstddef>
#include <cstdlib>
#include <cstring>

// Custom memory allocators

void* operator new(size_t size) {
    return malloc(size);
}

void* operator new[](size_t size) {
    return malloc(size);
}

void operator delete(void* ptr) noexcept {
    free(ptr);
}

void operator delete[](void* ptr) noexcept {
    free(ptr);
}

// C++14/17 sized deallocation overloads (optional but recommended)

void operator delete(void* ptr, size_t) noexcept {
    free(ptr);
}

void operator delete[](void* ptr, size_t) noexcept {
    free(ptr);
}

// Implementation

#define RAPIDJSON_NOMEMBERITERATORCLASS

#include "rapidjson/document.h"
#include "rapidjson/error/en.h"
#include "rapidjson/stringbuffer.h"
#include "rapidjson/writer.h"

/**
 * Represents a member of a JSON object (a key-value pair).
 *
 * This struct is used to bridge RapidJSON object members to Cangjie.
 * Both `name` and `value` are pointers to the underlying RapidJSON Value
 * objects stored in the DOM tree.
 */
typedef struct {
    rapidjson::Value*
        name; //!< Pointer to the name (key) of the member. In RapidJSON, this is stored as a Value (string type).
    rapidjson::Value* value; //!< Pointer to the value associated with the key.
} RJ4CJ_Member;

/**
 * Represents the result of a JSON parse operation.
 *
 * This struct encapsulates the outcome of `RJ4CJ_parse`. It follows a "Result" pattern
 * containing either the successfully parsed document or the error details.
 */
typedef struct {
    rapidjson::Document* doc;        //!< Handle to the parsed document. `nullptr` if parsing failed.
    rapidjson::ParseErrorCode error; //!< The error code. `kParseErrorNone` (0) indicates success.
    size_t offset;                   //!< The byte offset in the input JSON where the error occurred. 0 if no error.
} RJ4CJ_ParseResult;

/**
 * A non-owning view of a UTF-8 string.
 *
 * This struct is used to return string data from RapidJSON to Cangjie without
 * allocating new memory. It provides a pointer to the internal character buffer
 * and the length of the string.
 *
 * Note: RapidJSON strings are not guaranteed to be null-terminated.
 */
typedef struct {
    const char* str; //!< Pointer to the read-only character data (may not be null-terminated).
    uint32_t length; //!< The length of the string in bytes.
} RJ4CJ_StringView;

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
    RJ4CJ_ParseResult RJ4CJ_parse(const char* str, size_t length) {
        RJ4CJ_ParseResult result = {nullptr, rapidjson::ParseErrorCode::kParseErrorDocumentEmpty, 0};

        if (!str) {
            return result;
        }

        auto doc = new rapidjson::Document();
        if (!doc) {
            return result;
        }

        doc->Parse(str, length);

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
    void RJ4CJ_free(rapidjson::Document* doc) {
        if (doc) {
            delete doc;
        }
    }

    /**
     * Gets the error message for a given parse error code.
     *
     * @param error The parse error code.
     *
     * @return A pointer to the error message string.
     */
    const char* RJ4CJ_getParseError(rapidjson::ParseErrorCode error) {
        return rapidjson::GetParseError_En(error);
    }

    /**
     * Checks if the document root holds null value.
     */
    bool RJ4CJ_isNull(rapidjson::Document* doc) {
        return doc && doc->IsNull();
    }

    /**
     * Checks if the document root holds an Array value.
     */
    bool RJ4CJ_isArray(rapidjson::Document* doc) {
        return doc && doc->IsArray();
    }

    /**
     * Checks if the document root holds an Object value.
     */
    bool RJ4CJ_isObject(rapidjson::Document* doc) {
        return doc && doc->IsObject();
    }

    /**
     * Checks if the document root holds a String value.
     */
    bool RJ4CJ_isString(rapidjson::Document* doc) {
        return doc && doc->IsString();
    }

    /**
     * Checks if the document root holds a Bool value.
     */
    bool RJ4CJ_isBool(rapidjson::Document* doc) {
        return doc && doc->IsBool();
    }

    /**
     * Checks if the document root holds a Number value.
     */
    bool RJ4CJ_isNumber(rapidjson::Document* doc) {
        return doc && doc->IsNumber();
    }

    /**
     * Checks if the document root holds an Int32 value.
     */
    bool RJ4CJ_isInt32(rapidjson::Document* doc) {
        return doc && doc->IsInt();
    }

    /**
     * Checks if the document root holds a UInt32 value.
     */
    bool RJ4CJ_isUInt32(rapidjson::Document* doc) {
        return doc && doc->IsUint();
    }

    /**
     * Checks if the document root holds an Int64 value.
     */
    bool RJ4CJ_isInt64(rapidjson::Document* doc) {
        return doc && doc->IsInt64();
    }

    /**
     * Checks if the document root holds a UInt64 value.
     */
    bool RJ4CJ_isUInt64(rapidjson::Document* doc) {
        return doc && doc->IsUint64();
    }

    /**
     * Checks if the document root holds a Float32 value.
     */
    bool RJ4CJ_isFloat32(rapidjson::Document* doc) {
        return doc && doc->IsFloat();
    }

    /**
     * Checks if the document root holds a Float64 value.
     */
    bool RJ4CJ_isFloat64(rapidjson::Document* doc) {
        return doc && doc->IsDouble();
    }

    /**
     * Gets array size or 0 if not an array.
     */
    rapidjson::SizeType RJ4CJ_getArraySize(rapidjson::Document* doc) {
        if (doc && doc->IsArray())
            return doc->Size();
        return 0;
    }

    /**
     * Gets an iterator pointing to the first element of the document root array.
     *
     * @param doc Handle to the RapidJSON document.
     *
     * @return A ValueIterator pointing to the first element.
     *         Returns `nullptr` if the document is null or the root is not an Array.
     */
    rapidjson::Value::ValueIterator RJ4CJ_getArrayBegin(rapidjson::Document* doc) {
        if (doc && doc->IsArray()) {
            return doc->Begin();
        }
        return nullptr;
    }

    /**
     * Gets an iterator pointing to the past-the-end element of the document root array.
     *
     * @param doc Handle to the RapidJSON document.
     *
     * @return A ValueIterator pointing to the end.
     *         Returns `nullptr` if the document is null or the root is not an Array.
     */
    rapidjson::Value::ValueIterator RJ4CJ_getArrayEnd(rapidjson::Document* doc) {
        if (doc && doc->IsArray()) {
            return doc->End();
        }
        return nullptr;
    }

    /**
     * Retrieves the current element and advances the iterator.
     *
     * This function handles the pointer arithmetic required to step through
     * the internal memory layout of a RapidJSON Array.
     *
     * @param it Pointer to the ValueIterator (pointer to pointer to Value).
     *           The iterator is advanced by `sizeof(Value)` (e.g., 16 bytes) after reading.
     *
     * @return A pointer to the RapidJSON Value object representing the current element.
     */
    rapidjson::Value* RJ4CJ_getArrayNext(rapidjson::Value::ValueIterator* it) {
        auto current = *it;
        ++(*it);
        return current;
    }

    /**
     * Gets object size or 0 if not an object.
     */
    rapidjson::SizeType RJ4CJ_getMemberCount(rapidjson::Document* doc) {
        if (doc && doc->IsObject())
            return doc->MemberCount();
        return 0;
    }

    /**
     * Gets an iterator pointing to the first member of the document root object.
     *
     * @param doc Handle to the RapidJSON document.
     *
     * @return A MemberIterator pointing to the first member.
     *         Returns `nullptr` if the document is null or the root is not an Object.
     */
    rapidjson::Value::MemberIterator RJ4CJ_getMemberBegin(rapidjson::Document* doc) {
        if (doc && doc->IsObject()) {
            return doc->MemberBegin();
        }
        return nullptr;
    }

    /**
     * Gets an iterator pointing to the past-the-end member of the document root object.
     *
     * @param doc Handle to the RapidJSON document.
     *
     * @return A MemberIterator pointing to the end.
     *         Returns `nullptr` if the document is null or the root is not an Object.
     */
    rapidjson::Value::MemberIterator RJ4CJ_getMemberEnd(rapidjson::Document* doc) {
        if (doc && doc->IsObject()) {
            return doc->MemberEnd();
        }
        return nullptr;
    }

    /**
     * Retrieves the current member (key-value pair) and advances the iterator.
     *
     * This function handles the pointer arithmetic required to step through
     * the internal memory layout of a RapidJSON Object.
     *
     * @param it Pointer to the MemberIterator (pointer to pointer to Member).
     *           The iterator is advanced by `sizeof(Member)` (e.g., 32 bytes) after reading.
     *
     * @return An RJ4CJ_Member struct containing pointers to the `name` and `value` Value objects.
     */
    RJ4CJ_Member RJ4CJ_getMemberNext(rapidjson::Value::MemberIterator* it) {
        auto member = RJ4CJ_Member{&(*it)->name, &(*it)->value};
        ++(*it);
        return member;
    }

    /**
     * Gets the string value directly from the document root.
     *
     * @param doc The document handle.
     *
     * @return A StringView struct containing the pointer and length.
     *         If the root is not a string, str will be nullptr and length 0.
     */
    RJ4CJ_StringView RJ4CJ_getString(rapidjson::Document* doc) {
        RJ4CJ_StringView result = {nullptr, 0};
        if (doc && doc->IsString()) {
            result.str = doc->GetString();
            result.length = doc->GetStringLength();
            return result;
        }
        return result;
    }

    /**
     * Get string length.
     *
     * @return string length or 0 if not a string.
     */
    rapidjson::SizeType RJ4CJ_getStringLength(rapidjson::Document* doc) {
        if (doc && doc->IsString())
            return doc->GetStringLength();
        return 0;
    }

    /**
     * Gets a Bool value directly from the document root.
     *
     * @param doc The document handle.
     * @param outValue Output: The Bool value.
     *
     * @return true if success, false if type mismatch or null doc.
     */
    bool RJ4CJ_getBool(rapidjson::Document* doc, bool* outValue) {
        if (doc && doc->IsBool()) {
            *outValue = doc->GetBool();
            return true;
        }
        return false;
    }

    /**
     * Gets an Int32 value directly from the document root.
     *
     * @param doc The document handle.
     * @param outValue Output: The Int32 value.
     *
     * @return true if success, false if type mismatch or null doc.
     */
    bool RJ4CJ_getInt32(rapidjson::Document* doc, int32_t* outValue) {
        if (doc && doc->IsInt()) {
            *outValue = doc->GetInt();
            return true;
        }
        return false;
    }

    /**
     * Gets a UInt32 value directly from the document root.
     *
     * @param doc The document handle.
     * @param outValue Output: The UInt32 value.
     *
     * @return true if success, false if type mismatch or null doc.
     */
    bool RJ4CJ_getUInt32(rapidjson::Document* doc, uint32_t* outValue) {
        if (doc && doc->IsUint()) {
            *outValue = doc->GetUint();
            return true;
        }
        return false;
    }

    /**
     * Gets an Int64 value directly from the document root.
     *
     * @param doc The document handle.
     * @param outValue Output: The Int64 value.
     *
     * @return true if success, false if type mismatch or null doc.
     */
    bool RJ4CJ_getInt64(rapidjson::Document* doc, int64_t* outValue) {
        if (doc && doc->IsInt64()) {
            *outValue = doc->GetInt64();
            return true;
        }
        return false;
    }

    /**
     * Gets a UInt64 value directly from the document root.
     *
     * @param doc The document handle.
     * @param outValue Output: The UInt64 value.
     *
     * @return true if success, false if type mismatch or null doc.
     */
    bool RJ4CJ_getUInt64(rapidjson::Document* doc, uint64_t* outValue) {
        if (doc && doc->IsUint64()) {
            *outValue = doc->GetUint64();
            return true;
        }
        return false;
    }

    /**
     * Gets a Float32 value directly from the document root.
     *
     * @param doc The document handle.
     * @param outValue Output: The Float32 value.
     *
     * @return true if success, false if type mismatch or null doc.
     */
    bool RJ4CJ_getFloat32(rapidjson::Document* doc, float* outValue) {
        if (doc && doc->IsFloat()) {
            *outValue = doc->GetFloat();
            return true;
        }
        return false;
    }

    /**
     * Gets a Float64 value directly from the document root.
     *
     * @param doc The document handle.
     * @param outValue Output: The Float64 value.
     *
     * @return true if success, false if type mismatch or null doc.
     */
    bool RJ4CJ_getFloat64(rapidjson::Document* doc, double* outValue) {
        if (doc && doc->IsDouble()) {
            *outValue = doc->GetDouble();
            return true;
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds null value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is null, false otherwise.
     */
    bool RJ4CJ_isMemberNull(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsNull();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds an Array value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is an Array, false otherwise.
     */
    bool RJ4CJ_isMemberArray(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsArray();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds an Object value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is an Object, false otherwise.
     */
    bool RJ4CJ_isMemberObject(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsObject();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds a String value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is a String, false otherwise.
     */
    bool RJ4CJ_isMemberString(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsString();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds a Bool value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is a Bool, false otherwise.
     */
    bool RJ4CJ_isMemberBool(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsBool();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds a Number value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is a Number, false otherwise.
     */
    bool RJ4CJ_isMemberNumber(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsNumber();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds an Int32 value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is an Int32, false otherwise.
     */
    bool RJ4CJ_isMemberInt32(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsInt();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds a UInt32 value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is a UInt32, false otherwise.
     */
    bool RJ4CJ_isMemberUInt32(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsUint();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds an Int64 value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is an Int64, false otherwise.
     */
    bool RJ4CJ_isMemberInt64(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsInt64();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds a UInt64 value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is a UInt64, false otherwise.
     */
    bool RJ4CJ_isMemberUInt64(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsUint64();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds a Float32 value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is a Float32, false otherwise.
     */
    bool RJ4CJ_isMemberFloat32(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsFloat();
            }
        }
        return false;
    }

    /**
     * Checks if a key exists in the document root and holds a Float64 value.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists and value is a Float64, false otherwise.
     */
    bool RJ4CJ_isMemberFloat64(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd()) {
                return it->value.IsDouble();
            }
        }
        return false;
    }

    /**
     * Gets a Value (Array) from the document root associated with the key.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return A pointer to the rapidjson::Value if the key exists.
     *         Returns nullptr if the document is not an array or the key is missing.
     */
    rapidjson::Value* RJ4CJ_getMemberArray(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsArray()) {
                return &it->value;
            }
        }
        return nullptr;
    }

    /**
     * Gets a Value (Object) from the document root associated with the key.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return A pointer to the rapidjson::Value if the key exists.
     *         Returns nullptr if the document is not an object or the key is missing.
     */
    rapidjson::Value* RJ4CJ_getMemberObject(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsObject()) {
                return &it->value;
            }
        }
        return nullptr;
    }

    /**
     * Gets a string value from the document root.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return A StringView struct containing the pointer and length.
     *         If the key is missing or not a string, str will be nullptr and length 0.
     */
    RJ4CJ_StringView RJ4CJ_getMemberString(rapidjson::Document* doc, const char* key, rapidjson::SizeType length) {
        RJ4CJ_StringView result = {nullptr, 0};
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsString()) {
                result.str = it->value.GetString();
                result.length = it->value.GetStringLength();
                return result;
            }
        }
        return result;
    }

    /**
     * Gets a string length from the document root.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return string length or 0 if not a string.
     */
    rapidjson::SizeType RJ4CJ_getMemberStringLength(rapidjson::Document* doc, const char* key,
                                                    rapidjson::SizeType length) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsString()) {
                return it->value.GetStringLength();
            }
        }
        return 0;
    }

    /**
     * Gets a Bool value from the document root.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     * @param outValue Output: The Bool value.
     *
     * @return true if success, false if type mismatch or missing key.
     */
    bool RJ4CJ_getMemberBool(rapidjson::Document* doc, const char* key, rapidjson::SizeType length, bool* outValue) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsBool()) {
                *outValue = it->value.GetBool();
                return true;
            }
        }
        return false;
    }

    /**
     * Gets an Int32 value from the document root.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     * @param outValue Output: The Int32 value.
     *
     * @return true if success, false if type mismatch or missing key.
     */
    bool RJ4CJ_getMemberInt32(rapidjson::Document* doc, const char* key, rapidjson::SizeType length,
                              int32_t* outValue) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsInt()) {
                *outValue = it->value.GetInt();
                return true;
            }
        }
        return false;
    }

    /**
     * Gets a UInt32 value from the document root.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     * @param outValue Output: The UInt32 value.
     *
     * @return true if success, false if type mismatch or missing key.
     */
    bool RJ4CJ_getMemberUInt32(rapidjson::Document* doc, const char* key, rapidjson::SizeType length,
                               uint32_t* outValue) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsUint()) {
                *outValue = it->value.GetUint();
                return true;
            }
        }
        return false;
    }

    /**
     * Gets an Int64 value from the document root.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     * @param outValue Output: The Int64 value.
     *
     * @return true if success, false if type mismatch or missing key.
     */
    bool RJ4CJ_getMemberInt64(rapidjson::Document* doc, const char* key, rapidjson::SizeType length,
                              int64_t* outValue) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsInt64()) {
                *outValue = it->value.GetInt64();
                return true;
            }
        }
        return false;
    }

    /**
     * Gets a UInt64 value from the document root.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     * @param outValue Output: The UInt64 value.
     *
     * @return true if success, false if type mismatch or missing key.
     */
    bool RJ4CJ_getMemberUInt64(rapidjson::Document* doc, const char* key, rapidjson::SizeType length,
                               uint64_t* outValue) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsUint64()) {
                *outValue = it->value.GetUint64();
                return true;
            }
        }
        return false;
    }

    /**
     * Gets a Float32 value from the document root.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     * @param outValue Output: The Float32 value.
     *
     * @return true if success, false if type mismatch or missing key.
     */
    bool RJ4CJ_getMemberFloat32(rapidjson::Document* doc, const char* key, rapidjson::SizeType length,
                                float* outValue) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsFloat()) {
                *outValue = it->value.GetFloat();
                return true;
            }
        }
        return false;
    }

    /**
     * Gets a Float64 value from the document root.
     *
     * @param doc The document handle.
     * @param key The key to look up.
     * @param length The length of the key.
     * @param outValue Output: The Float64 value.
     *
     * @return true if success, false if type mismatch or missing key.
     */
    bool RJ4CJ_getMemberFloat64(rapidjson::Document* doc, const char* key, rapidjson::SizeType length,
                                double* outValue) {
        if (doc && doc->IsObject()) {
            auto it = doc->FindMember(rapidjson::Value(key, length));
            if (it != doc->MemberEnd() && it->value.IsDouble()) {
                *outValue = it->value.GetDouble();
                return true;
            }
        }
        return false;
    }
}
