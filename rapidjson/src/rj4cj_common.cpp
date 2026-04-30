#include "rj4cj_common.h"

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

extern "C" {
    /**
     * Gets the error message for a given parse error code.
     *
     * @param error The parse error code.
     *
     * @return A pointer to the error message string.
     */
    RJ4CJ_API const char* RJ4CJ_getParseError(rapidjson::ParseErrorCode error) {
        return rapidjson::GetParseError_En(error);
    }
}
