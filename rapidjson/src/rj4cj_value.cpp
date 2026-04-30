#include "rj4cj_common.h"

extern "C" {
    /**
     * Checks if the value holds null value.
     */
    RJ4CJ_API bool RJ4CJValue_isNull(rapidjson::Value* value) {
        return value && value->IsNull();
    }

    /**
     * Checks if the value holds a Bool value.
     */
    RJ4CJ_API bool RJ4CJValue_isBool(rapidjson::Value* value) {
        return value && value->IsBool();
    }

    /**
     * Checks if the value holds a Number value.
     */
    RJ4CJ_API bool RJ4CJValue_isNumber(rapidjson::Value* value) {
        return value && value->IsNumber();
    }

    /**
     * Checks if the value holds an Int32 value.
     */
    RJ4CJ_API bool RJ4CJValue_isInt32(rapidjson::Value* value) {
        return value && value->IsInt();
    }

    /**
     * Checks if the value holds a UInt32 value.
     */
    RJ4CJ_API bool RJ4CJValue_isUInt32(rapidjson::Value* value) {
        return value && value->IsUint();
    }

    /**
     * Checks if the value holds an Int64 value.
     */
    RJ4CJ_API bool RJ4CJValue_isInt64(rapidjson::Value* value) {
        return value && value->IsInt64();
    }

    /**
     * Checks if the value holds a UInt64 value.
     */
    RJ4CJ_API bool RJ4CJValue_isUInt64(rapidjson::Value* value) {
        return value && value->IsUint64();
    }

    /**
     * Checks if the value holds a Float32 value.
     */
    RJ4CJ_API bool RJ4CJValue_isFloat32(rapidjson::Value* value) {
        return value && value->IsFloat();
    }

    /**
     * Checks if the value holds a Float64 value.
     */
    RJ4CJ_API bool RJ4CJValue_isFloat64(rapidjson::Value* value) {
        return value && value->IsDouble();
    }

    /**
     * Checks if the value holds a String value.
     */
    RJ4CJ_API bool RJ4CJValue_isString(rapidjson::Value* value) {
        return value && value->IsString();
    }

    /**
     * Checks if the value holds an Array value.
     */
    RJ4CJ_API bool RJ4CJValue_isArray(rapidjson::Value* value) {
        return value && value->IsArray();
    }

    /**
     * Checks if the value holds an Object value.
     */
    RJ4CJ_API bool RJ4CJValue_isObject(rapidjson::Value* value) {
        return value && value->IsObject();
    }

    /**
     * Gets the string value directly from the value.
     *
     * @param value The value handle.
     *
     * @return A StringView struct containing the pointer and length.
     *         If the root is not a string, str will be nullptr and length 0.
     */
    RJ4CJ_API RJ4CJ_StringView RJ4CJValue_getString(rapidjson::Value* value) {
        RJ4CJ_StringView result = {nullptr, 0};
        if (value && value->IsString()) {
            result.str = value->GetString();
            result.length = value->GetStringLength();
            return result;
        }
        return result;
    }

    /**
     * Get string length.
     *
     * @return string length or 0 if not a string.
     */
    RJ4CJ_API rapidjson::SizeType RJ4CJValue_getStringLength(rapidjson::Value* value) {
        if (value && value->IsString())
            return value->GetStringLength();
        return 0;
    }

    /**
     * Gets a Bool value directly from the value.
     *
     * @param value The value handle.
     * @param outValue Output: The Bool value.
     *
     * @return true if success, false if type mismatch or null value.
     */
    RJ4CJ_API bool RJ4CJValue_getBool(rapidjson::Value* value, bool* outValue) {
        if (value && value->IsBool()) {
            *outValue = value->GetBool();
            return true;
        }
        return false;
    }

    /**
     * Gets an Int32 value directly from the value.
     *
     * @param value The value handle.
     * @param outValue Output: The Int32 value.
     *
     * @return true if success, false if type mismatch or null value.
     */
    RJ4CJ_API bool RJ4CJValue_getInt32(rapidjson::Value* value, int32_t* outValue) {
        if (value && value->IsInt()) {
            *outValue = value->GetInt();
            return true;
        }
        return false;
    }

    /**
     * Gets a UInt32 value directly from the value.
     *
     * @param value The value handle.
     * @param outValue Output: The UInt32 value.
     *
     * @return true if success, false if type mismatch or null value.
     */
    RJ4CJ_API bool RJ4CJValue_getUInt32(rapidjson::Value* value, uint32_t* outValue) {
        if (value && value->IsUint()) {
            *outValue = value->GetUint();
            return true;
        }
        return false;
    }

    /**
     * Gets an Int64 value directly from the value.
     *
     * @param value The value handle.
     * @param outValue Output: The Int64 value.
     *
     * @return true if success, false if type mismatch or null value.
     */
    RJ4CJ_API bool RJ4CJValue_getInt64(rapidjson::Value* value, int64_t* outValue) {
        if (value && value->IsInt64()) {
            *outValue = value->GetInt64();
            return true;
        }
        return false;
    }

    /**
     * Gets a UInt64 value directly from the value.
     *
     * @param value The value handle.
     * @param outValue Output: The UInt64 value.
     *
     * @return true if success, false if type mismatch or null value.
     */
    RJ4CJ_API bool RJ4CJValue_getUInt64(rapidjson::Value* value, uint64_t* outValue) {
        if (value && value->IsUint64()) {
            *outValue = value->GetUint64();
            return true;
        }
        return false;
    }

    /**
     * Gets a Float32 value directly from the value.
     *
     * @param value The value handle.
     * @param outValue Output: The Float32 value.
     *
     * @return true if success, false if type mismatch or null value.
     */
    RJ4CJ_API bool RJ4CJValue_getFloat32(rapidjson::Value* value, float* outValue) {
        if (value && value->IsFloat()) {
            *outValue = value->GetFloat();
            return true;
        }
        return false;
    }

    /**
     * Gets a Float64 value directly from the value.
     *
     * @param value The value handle.
     * @param outValue Output: The Float64 value.
     *
     * @return true if success, false if type mismatch or null value.
     */
    RJ4CJ_API bool RJ4CJValue_getFloat64(rapidjson::Value* value, double* outValue) {
        if (value && value->IsDouble()) {
            *outValue = value->GetDouble();
            return true;
        }
        return false;
    }

    /**
     * Sets the value to a Null value.
     *
     * @param value Handle to the RapidJSON value.
     */
    RJ4CJ_API void RJ4CJValue_setNull(rapidjson::Value* value) {
        if (value) {
            value->SetNull();
        }
    }

    /**
     * Sets the value to a Bool value.
     *
     * @param value Handle to the RapidJSON value.
     * @param val The boolean value to set.
     */
    RJ4CJ_API void RJ4CJValue_setBool(rapidjson::Value* value, bool val) {
        if (value) {
            value->SetBool(val);
        }
    }

    /**
     * Sets the value to an Int32 value.
     *
     * @param value Handle to the RapidJSON value.
     * @param val The Int32 value to set.
     */
    RJ4CJ_API void RJ4CJValue_setInt32(rapidjson::Value* value, int32_t val) {
        if (value) {
            value->SetInt(val);
        }
    }

    /**
     * Sets the value to a UInt32 value.
     *
     * @param value Handle to the RapidJSON value.
     * @param val The UInt32 value to set.
     */
    RJ4CJ_API void RJ4CJValue_setUInt32(rapidjson::Value* value, uint32_t val) {
        if (value) {
            value->SetUint(val);
        }
    }

    /**
     * Sets the value to an Int64 value.
     *
     * @param value Handle to the RapidJSON value.
     * @param val The Int64 value to set.
     */
    RJ4CJ_API void RJ4CJValue_setInt64(rapidjson::Value* value, int64_t val) {
        if (value) {
            value->SetInt64(val);
        }
    }

    /**
     * Sets the value to a UInt64 value.
     *
     * @param value Handle to the RapidJSON value.
     * @param val The UInt64 value to set.
     */
    RJ4CJ_API void RJ4CJValue_setUInt64(rapidjson::Value* value, uint64_t val) {
        if (value) {
            value->SetUint64(val);
        }
    }

    /**
     * Sets the value to a Float32 value.
     *
     * @param value Handle to the RapidJSON value.
     * @param val The Float32 value to set.
     */
    RJ4CJ_API void RJ4CJValue_setFloat32(rapidjson::Value* value, float val) {
        if (value) {
            value->SetFloat(val);
        }
    }

    /**
     * Sets the value to a Float64 value.
     *
     * @param value Handle to the RapidJSON value.
     * @param val The Float64 value to set.
     */
    RJ4CJ_API void RJ4CJValue_setFloat64(rapidjson::Value* value, double val) {
        if (value) {
            value->SetDouble(val);
        }
    }

    /**
     * Sets the value to a String value, copying the string into the
     * document's internal memory pool.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param str The string to set.
     * @param length The length of the string.
     */
    RJ4CJ_API void RJ4CJValue_setString(rapidjson::Document* root, rapidjson::Value* value, const char* str,
                                        rapidjson::SizeType length) {
        if (root && value && str) {
            value->SetString(str, length, root->GetAllocator());
        }
    }

    /**
     * Sets the value to an Array value.
     *
     * @param value Handle to the RapidJSON value.
     */
    RJ4CJ_API void RJ4CJValue_setArray(rapidjson::Value* value) {
        if (value) {
            value->SetArray();
        }
    }

    /**
     * Gets a Value from the array.
     *
     * @param value The value handle.
     * @param index The index.
     *
     * @return A pointer to the rapidjson::Value if the index exists.
     *         Returns nullptr if the value is not an array or the index is out of range.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayGet(rapidjson::Value* value, int64_t index) {
        if (value && value->IsArray() && index >= 0 && index < value->Size()) {
            return &(*value)[index];
        }
        return nullptr;
    }

    /**
     * Gets array size or 0 if not an array.
     */
    RJ4CJ_API rapidjson::SizeType RJ4CJValue_arraySize(rapidjson::Value* value) {
        if (value && value->IsArray())
            return value->Size();
        return 0;
    }

    /**
     * Gets an iterator pointing to the first element of the value array.
     *
     * @param value Handle to the RapidJSON value.
     *
     * @return A ValueIterator pointing to the first element.
     *         Returns `nullptr` if the value is null or the root is not an Array.
     */
    RJ4CJ_API rapidjson::Value::ValueIterator RJ4CJValue_arrayBegin(rapidjson::Value* value) {
        if (value && value->IsArray()) {
            return value->Begin();
        }
        return nullptr;
    }

    /**
     * Gets an iterator pointing to the past-the-end element of the value array.
     *
     * @param value Handle to the RapidJSON value.
     *
     * @return A ValueIterator pointing to the end.
     *         Returns `nullptr` if the value is null or the root is not an Array.
     */
    RJ4CJ_API rapidjson::Value::ValueIterator RJ4CJValue_arrayEnd(rapidjson::Value* value) {
        if (value && value->IsArray()) {
            return value->End();
        }
        return nullptr;
    }

    /**
     * Pushes back a null value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     *
     * @return Pointer to the newly pushed value, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddNull(rapidjson::Document* root, rapidjson::Value* value) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(rapidjson::kNullType);
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Pushes back a boolean value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param val The boolean value to push back.
     *
     * @return Pointer to the newly pushed value, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddBool(rapidjson::Document* root, rapidjson::Value* value, bool val) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(val);
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Pushes back an Int32 value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param val The Int32 value to push back.
     *
     * @return Pointer to the newly pushed value, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddInt32(rapidjson::Document* root, rapidjson::Value* value,
                                                         int32_t val) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(val);
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Pushes back a UInt32 value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param val The UInt32 value to push back.
     *
     * @return Pointer to the newly pushed value, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddUInt32(rapidjson::Document* root, rapidjson::Value* value,
                                                          uint32_t val) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(val);
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Pushes back an Int64 value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param val The Int64 value to push back.
     *
     * @return Pointer to the newly pushed value, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddInt64(rapidjson::Document* root, rapidjson::Value* value,
                                                         int64_t val) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(val);
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Pushes back a UInt64 value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param val The UInt64 value to push back.
     *
     * @return Pointer to the newly pushed value, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddUInt64(rapidjson::Document* root, rapidjson::Value* value,
                                                          uint64_t val) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(val);
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Pushes back a Float32 value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param val The Float32 value to push back.
     *
     * @return Pointer to the newly pushed value, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddFloat32(rapidjson::Document* root, rapidjson::Value* value,
                                                           float val) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(val);
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Pushes back a Float64 value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param val The Float64 value to push back.
     *
     * @return Pointer to the newly pushed value, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddFloat64(rapidjson::Document* root, rapidjson::Value* value,
                                                           double val) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(val);
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Pushes back a String value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param str The string to push back.
     * @param length The length of the string.
     *
     * @return Pointer to the newly pushed value, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddString(rapidjson::Document* root, rapidjson::Value* value,
                                                          const char* str, rapidjson::SizeType length) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(str, length, root->GetAllocator());
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Pushes back an Array value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     *
     * @return Pointer to the newly pushed array, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddArray(rapidjson::Document* root, rapidjson::Value* value) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(rapidjson::kArrayType);
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Pushes back an Object value to the array.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     *
     * @return Pointer to the newly pushed object, or nullptr if value is not an array.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_arrayAddObject(rapidjson::Document* root, rapidjson::Value* value) {
        if (root && value && value->IsArray()) {
            rapidjson::Value v(rapidjson::kObjectType);
            value->PushBack(v, root->GetAllocator());
            auto size = value->Size();
            if (size > 0) {
                return &(*value)[size - 1];
            }
        }
        return nullptr;
    }

    /**
     * Removes the last element in the array.
     *
     * @param value Handle to the RapidJSON value.
     *
     * @return true if success, false if value is not an array or is empty.
     */
    RJ4CJ_API bool RJ4CJValue_arrayPop(rapidjson::Value* value) {
        if (value && value->IsArray() && !value->Empty()) {
            value->PopBack();
            return true;
        }
        return false;
    }

    /**
     * Removes all elements in the array. Capacity remains unchanged.
     *
     * @param value Handle to the RapidJSON value.
     *
     * @return true if success, false if value is not an array.
     */
    RJ4CJ_API bool RJ4CJValue_arrayClear(rapidjson::Value* value) {
        if (value && value->IsArray()) {
            value->Clear();
            return true;
        }
        return false;
    }

    /**
     * Erases an element of array by index.
     * Note: Elements are shifted to fill the gap.
     *
     * @param value Handle to the RapidJSON value.
     * @param index The index of the element to erase.
     *
     * @return true if success, false if value is not an array or index is out of bounds.
     */
    RJ4CJ_API bool RJ4CJValue_arrayErase(rapidjson::Value* value, rapidjson::SizeType index) {
        if (value && value->IsArray() && index < value->Size()) {
            value->Erase(value->Begin() + index);
            return true;
        }
        return false;
    }

    /**
     * Requests the array to have enough capacity to store elements.
     * Prevents reallocation when using PushBack functions.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param newCapacity The desired capacity (number of elements).
     *
     * @return true if success, false if value is not an array or out of memory.
     */
    RJ4CJ_API bool RJ4CJValue_arrayReserve(rapidjson::Document* root, rapidjson::Value* value,
                                           rapidjson::SizeType newCapacity) {
        if (root && value && value->IsArray()) {
            value->Reserve(newCapacity, root->GetAllocator());
            return true;
        }
        return false;
    }

    /**
     * Gets the current capacity of the array.
     *
     * @param value Handle to the RapidJSON value.
     *
     * @return The capacity, or 0 if the value is not an array.
     */
    RJ4CJ_API rapidjson::SizeType RJ4CJValue_arrayCapacity(rapidjson::Value* value) {
        if (value && value->IsArray()) {
            return value->Capacity();
        }
        return 0;
    }

    /**
     * Sets the value to an Object value.
     *
     * @param value Handle to the RapidJSON value.
     */
    RJ4CJ_API void RJ4CJValue_setObject(rapidjson::Value* value) {
        if (value) {
            value->SetObject();
        }
    }

    /**
     * Checks if a key exists in the object.
     *
     * @param value The value handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return true if the key exists, false if not or if value is not an object.
     */
    RJ4CJ_API bool RJ4CJValue_memberContains(rapidjson::Value* value, const char* key, rapidjson::SizeType length) {
        if (value && value->IsObject()) {
            return value->HasMember(rapidjson::Value(key, length));
        }
        return false;
    }

    /**
     * Gets a Value from the value associated with the key.
     *
     * @param value The value handle.
     * @param key The key to look up.
     * @param length The length of the key.
     *
     * @return A pointer to the rapidjson::Value if the key exists.
     *         Returns nullptr if the key is missing.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberGet(rapidjson::Value* value, const char* key,
                                                     rapidjson::SizeType length) {
        if (value && value->IsObject()) {
            auto it = value->FindMember(rapidjson::Value(key, length));
            if (it != value->MemberEnd()) {
                return &it->value;
            }
        }
        return nullptr;
    }

    /**
     * Gets object size or 0 if not an object.
     */
    RJ4CJ_API rapidjson::SizeType RJ4CJValue_memberSize(rapidjson::Value* value) {
        if (value && value->IsObject())
            return value->MemberCount();
        return 0;
    }

    /**
     * Gets an iterator pointing to the first member of the value object.
     *
     * @param value Handle to the RapidJSON value.
     *
     * @return A MemberIterator pointing to the first member.
     *         Returns `nullptr` if the value is null or the root is not an Object.
     */
    RJ4CJ_API rapidjson::Value::MemberIterator RJ4CJValue_memberBegin(rapidjson::Value* value) {
        if (value && value->IsObject()) {
            return value->MemberBegin();
        }
        return nullptr;
    }

    /**
     * Gets an iterator pointing to the past-the-end member of the value object.
     *
     * @param value Handle to the RapidJSON value.
     *
     * @return A MemberIterator pointing to the end.
     *         Returns `nullptr` if the value is null or the root is not an Object.
     */
    RJ4CJ_API rapidjson::Value::MemberIterator RJ4CJValue_memberEnd(rapidjson::Value* value) {
        if (value && value->IsObject()) {
            return value->MemberEnd();
        }
        return nullptr;
    }

    /**
     * Adds a null member to the object.
     *
     * @param root Handle to the RapidJSON root document (for memory allocation).
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     *
     * @return A pointer to the newly added Value if success, false if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddNull(rapidjson::Document* root, rapidjson::Value* value,
                                                         const char* key, rapidjson::SizeType keyLength) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(rapidjson::kNullType);
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Adds a boolean member to the object.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     * @param val The boolean value to add.
     *
     * @return A pointer to the newly added Value if success, nullptr if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddBool(rapidjson::Document* root, rapidjson::Value* value,
                                                         const char* key, rapidjson::SizeType keyLength, bool val) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(val);
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Adds an Int32 member to the object.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     * @param val The Int32 value to add.
     *
     * @return A pointer to the newly added Value if success, nullptr if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddInt32(rapidjson::Document* root, rapidjson::Value* value,
                                                          const char* key, rapidjson::SizeType keyLength, int32_t val) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(val);
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Adds a UInt32 member to the object.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     * @param val The UInt32 value to add.
     *
     * @return A pointer to the newly added Value if success, nullptr if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddUInt32(rapidjson::Document* root, rapidjson::Value* value,
                                                           const char* key, rapidjson::SizeType keyLength,
                                                           uint32_t val) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(val);
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Adds an Int64 member to the object.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     * @param val The Int64 value to add.
     *
     * @return A pointer to the newly added Value if success, nullptr if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddInt64(rapidjson::Document* root, rapidjson::Value* value,
                                                          const char* key, rapidjson::SizeType keyLength, int64_t val) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(val);
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Adds a UInt64 member to the object.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     * @param val The UInt64 value to add.
     *
     * @return A pointer to the newly added Value if success, nullptr if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddUInt64(rapidjson::Document* root, rapidjson::Value* value,
                                                           const char* key, rapidjson::SizeType keyLength,
                                                           uint64_t val) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(val);
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Adds a Float32 member to the object.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     * @param val The Float32 value to add.
     *
     * @return A pointer to the newly added Value if success, nullptr if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddFloat32(rapidjson::Document* root, rapidjson::Value* value,
                                                            const char* key, rapidjson::SizeType keyLength, float val) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(val);
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Adds a Float64 member to the object.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     * @param val The Float64 value to add.
     *
     * @return A pointer to the newly added Value if success, nullptr if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddFloat64(rapidjson::Document* root, rapidjson::Value* value,
                                                            const char* key, rapidjson::SizeType keyLength,
                                                            double val) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(val);
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Adds a String member to the object.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     * @param str The string value to add.
     * @param strLength The length of the string value.
     *
     * @return A pointer to the newly added Value if success, nullptr if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddString(rapidjson::Document* root, rapidjson::Value* value,
                                                           const char* key, rapidjson::SizeType keyLength,
                                                           const char* str, rapidjson::SizeType strLength) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(str, strLength, root->GetAllocator());
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Adds an Array member to the object.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     *
     * @return A pointer to the newly added Value if success, nullptr if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddArray(rapidjson::Document* root, rapidjson::Value* value,
                                                          const char* key, rapidjson::SizeType keyLength) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(rapidjson::kArrayType);
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Adds an Object member to the object.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param key The key to add.
     * @param keyLength The length of the key.
     *
     * @return A pointer to the newly added Value if success, nullptr if value is not an object.
     */
    RJ4CJ_API rapidjson::Value* RJ4CJValue_memberAddObject(rapidjson::Document* root, rapidjson::Value* value,
                                                           const char* key, rapidjson::SizeType keyLength) {
        if (root && value && value->IsObject()) {
            rapidjson::Value k(key, keyLength, root->GetAllocator());
            rapidjson::Value v(rapidjson::kObjectType);
            value->AddMember(k, v, root->GetAllocator());
            auto size = value->MemberCount();
            if (size > 0) {
                return &(value->MemberBegin()[size - 1]).value;
            }
        }
        return nullptr;
    }

    /**
     * Removes all members in the object. Capacity remains unchanged.
     *
     * @param value Handle to the RapidJSON value.
     *
     * @return true if success, false if value is not an object.
     */
    RJ4CJ_API bool RJ4CJValue_memberClear(rapidjson::Value* value) {
        if (value && value->IsObject()) {
            value->RemoveAllMembers();
            return true;
        }
        return false;
    }

    /**
     * Removes a member in object by its name.
     * Note: This function may reorder the object members.
     *
     * @param value Handle to the RapidJSON value.
     * @param key The key to remove.
     * @param length The length of the key.
     *
     * @return true if the member existed and was removed, false otherwise.
     */
    RJ4CJ_API bool RJ4CJValue_memberRemove(rapidjson::Value* value, const char* key, rapidjson::SizeType length) {
        if (value && value->IsObject()) {
            return value->RemoveMember(rapidjson::Value(key, length));
        }
        return false;
    }

    /**
     * Erases a member in object by its name.
     * Note: This function preserves the relative order of the remaining members (slower than RemoveMember).
     *
     * @param value Handle to the RapidJSON value.
     * @param key The key to erase.
     * @param length The length of the key.
     *
     * @return true if the member existed and was erased, false otherwise.
     */
    RJ4CJ_API bool RJ4CJValue_memberErase(rapidjson::Value* value, const char* key, rapidjson::SizeType length) {
        if (value && value->IsObject()) {
            return value->EraseMember(rapidjson::Value(key, length));
        }
        return false;
    }

    /**
     * Requests the object to have enough capacity to store members.
     * Prevents reallocation when using AddMember functions.
     *
     * @param root Handle to the RapidJSON root document.
     * @param value Handle to the RapidJSON value.
     * @param newCapacity The desired capacity (number of members).
     *
     * @return true if success, false if value is not an object or out of memory.
     */
    RJ4CJ_API bool RJ4CJValue_memberReserve(rapidjson::Document* root, rapidjson::Value* value,
                                            rapidjson::SizeType newCapacity) {
        if (root && value && value->IsObject()) {
            value->MemberReserve(newCapacity, root->GetAllocator());
            return true;
        }
        return false;
    }

    /**
     * Gets the current capacity of the object.
     *
     * @param value Handle to the RapidJSON value.
     *
     * @return The capacity, or 0 if the value is not an object.
     */
    RJ4CJ_API rapidjson::SizeType RJ4CJValue_memberCapacity(rapidjson::Value* value) {
        if (value && value->IsObject()) {
            return value->MemberCapacity();
        }
        return 0;
    }
}
