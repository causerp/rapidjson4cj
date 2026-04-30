#pragma once

#include <cstddef>
#include <cstdlib>
#include <cstring>

// RapidJSON configuration

#define RAPIDJSON_NOMEMBERITERATORCLASS

#include "rapidjson/document.h"
#include "rapidjson/error/en.h"
#include "rapidjson/prettywriter.h"
#include "rapidjson/stringbuffer.h"

#if defined(_WIN32)
#define RJ4CJ_API __declspec(dllexport)
#else
#define RJ4CJ_API __attribute__((visibility("default")))
#endif

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
