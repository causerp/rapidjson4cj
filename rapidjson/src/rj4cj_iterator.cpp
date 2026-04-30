#include "rj4cj_common.h"

extern "C" {
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
    RJ4CJ_API rapidjson::Value* RJ4CJValueIterator_next(rapidjson::Value::ValueIterator* it) {
        auto current = *it;
        ++(*it);
        return current;
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
    RJ4CJ_API RJ4CJ_Member RJ4CJMemberIterator_next(rapidjson::Value::MemberIterator* it) {
        auto member = RJ4CJ_Member{&(*it)->name, &(*it)->value};
        ++(*it);
        return member;
    }
}
