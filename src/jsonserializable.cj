package rapidjson4cj

import std.collection.{ArrayDeque, ArrayList, ArrayQueue, ArrayStack, HashMap, HashSet, LinkedList, TreeMap, TreeSet}
import std.collection.concurrent.ConcurrentHashMap

// cjlint-ignore -start !G.ITF.02 implement interface at type definition
// cjlint-ignore -start !G.ITF.04 avoid using interface as type parameter

public interface JsonSerializable {
    func add(value: JsonValue): JsonValue

    func addMember(key: String, value: JsonValue): JsonValue

    func set(value: JsonValue): Unit

    func write(writer: JsonWriter): Unit
}

extend Int8 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addInt32(Int32(this))
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberInt32(key, Int32(this))
    }

    public func set(value: JsonValue): Unit {
        value.setInt32(Int32(this))
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeInt32(Int32(this))
    }
}

extend Int16 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addInt32(Int32(this))
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberInt32(key, Int32(this))
    }

    public func set(value: JsonValue): Unit {
        value.setInt32(Int32(this))
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeInt32(Int32(this))
    }
}

extend Int32 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addInt32(this)
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberInt32(key, this)
    }

    public func set(value: JsonValue): Unit {
        value.setInt32(this)
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeInt32(this)
    }
}

extend Int64 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addInt64(this)
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberInt64(key, this)
    }

    public func set(value: JsonValue): Unit {
        value.setInt64(this)
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeInt64(this)
    }
}

extend IntNative <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addInt64(Int64(this))
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberInt64(key, Int64(this))
    }

    public func set(value: JsonValue): Unit {
        value.setInt64(Int64(this))
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeInt64(Int64(this))
    }
}

extend UInt8 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addUInt32(UInt32(this))
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberUInt32(key, UInt32(this))
    }

    public func set(value: JsonValue): Unit {
        value.setUInt32(UInt32(this))
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeUInt32(UInt32(this))
    }
}

extend UInt16 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addUInt32(UInt32(this))
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberUInt32(key, UInt32(this))
    }

    public func set(value: JsonValue): Unit {
        value.setUInt32(UInt32(this))
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeUInt32(UInt32(this))
    }
}

extend UInt32 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addUInt32(this)
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberUInt32(key, this)
    }

    public func set(value: JsonValue): Unit {
        value.setUInt32(this)
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeUInt32(this)
    }
}

extend UInt64 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addUInt64(this)
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberUInt64(key, this)
    }

    public func set(value: JsonValue): Unit {
        value.setUInt64(this)
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeUInt64(this)
    }
}

extend UIntNative <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addUInt64(UInt64(this))
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberUInt64(key, UInt64(this))
    }

    public func set(value: JsonValue): Unit {
        value.setUInt64(UInt64(this))
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeUInt64(UInt64(this))
    }
}

extend Float16 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addFloat32(Float32(this))
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberFloat32(key, Float32(this))
    }

    public func set(value: JsonValue): Unit {
        value.setFloat32(Float32(this))
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeFloat32(Float32(this))
    }
}

extend Float32 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addFloat32(this)
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberFloat32(key, this)
    }

    public func set(value: JsonValue): Unit {
        value.setFloat32(this)
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeFloat32(this)
    }
}

extend Float64 <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addFloat64(this)
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberFloat64(key, this)
    }

    public func set(value: JsonValue): Unit {
        value.setFloat64(this)
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeFloat64(this)
    }
}

extend Bool <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addBool(this)
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberBool(key, this)
    }

    public func set(value: JsonValue): Unit {
        value.setBool(this)
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeBool(this)
    }
}

extend String <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        value.addString(this)
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        value.addMemberString(key, this)
    }

    public func set(value: JsonValue): Unit {
        value.setString(this)
    }

    public func write(writer: JsonWriter): Unit {
        writer.writeString(this)
    }
}

extend<T> Array<T> <: JsonSerializable where T <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addArray()
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberArray(key)
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setArray()
        for (item in this) {
            item.add(value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startArray()
        for (item in this) {
            writer.writeValue<T>(item)
        }
        writer.endArray()
    }
}

extend<T> ArrayList<T> <: JsonSerializable where T <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addArray()
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberArray(key)
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setArray()
        for (item in this) {
            item.add(value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startArray()
        for (item in this) {
            writer.writeValue<T>(item)
        }
        writer.endArray()
    }
}

extend<V> HashMap<String, V> <: JsonSerializable where V <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addObject()
        for ((k, v) in this) {
            v.addMember(k, newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberObject(key)
        for ((k, v) in this) {
            v.addMember(k, newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setObject()
        for ((k, v) in this) {
            v.addMember(k, value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startObject()
        for ((k, v) in this) {
            writer.writeName(k)
            writer.writeValue(v)
        }
        writer.endObject()
    }
}

extend<T> Option<T> <: JsonSerializable where T <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        if (let Some(v) <- this) {
            return v.add(value)
        } else {
            return value.addNull()
        }
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        if (let Some(v) <- this) {
            return v.addMember(key, value)
        } else {
            return value.addMemberNull(key)
        }
    }

    public func set(value: JsonValue): Unit {
        if (let Some(v) <- this) {
            v.set(value)
        } else {
            value.setNull()
        }
    }

    public func write(writer: JsonWriter): Unit {
        if (let Some(v) <- this) {
            writer.writeValue<T>(v)
        } else {
            writer.writeNullValue()
        }
    }
}

extend<T> HashSet<T> <: JsonSerializable where T <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addArray()
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberArray(key)
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setArray()
        for (item in this) {
            item.add(value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startArray()
        for (item in this) {
            writer.writeValue<T>(item)
        }
        writer.endArray()
    }
}

extend<T> LinkedList<T> <: JsonSerializable where T <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addArray()
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberArray(key)
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setArray()
        for (item in this) {
            item.add(value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startArray()
        for (item in this) {
            writer.writeValue<T>(item)
        }
        writer.endArray()
    }
}

extend<T> ArrayQueue<T> <: JsonSerializable where T <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addArray()
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberArray(key)
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setArray()
        for (item in this) {
            item.add(value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startArray()
        for (item in this) {
            writer.writeValue<T>(item)
        }
        writer.endArray()
    }
}

extend<T> ArrayDeque<T> <: JsonSerializable where T <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addArray()
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberArray(key)
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setArray()
        for (item in this) {
            item.add(value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startArray()
        for (item in this) {
            writer.writeValue<T>(item)
        }
        writer.endArray()
    }
}

extend<T> ArrayStack<T> <: JsonSerializable where T <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addArray()
        let list = this.toArray()
        list.reverse()
        for (item in list) {
            item.add(newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberArray(key)
        let list = this.toArray()
        list.reverse()
        for (item in list) {
            item.add(newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setArray()
        let list = this.toArray()
        list.reverse()
        for (item in list) {
            item.add(value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startArray()
        let list = this.toArray()
        list.reverse()
        for (item in list) {
            writer.writeValue<T>(item)
        }
        writer.endArray()
    }
}

extend<T> TreeSet<T> <: JsonSerializable where T <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addArray()
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberArray(key)
        for (item in this) {
            item.add(newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setArray()
        for (item in this) {
            item.add(value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startArray()
        for (item in this) {
            writer.writeValue<T>(item)
        }
        writer.endArray()
    }
}

extend<V> TreeMap<String, V> <: JsonSerializable where V <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addObject()
        for ((k, v) in this) {
            v.addMember(k, newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberObject(key)
        for ((k, v) in this) {
            v.addMember(k, newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setObject()
        for ((k, v) in this) {
            v.addMember(k, value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startObject()
        for ((k, v) in this) {
            writer.writeName(k)
            writer.writeValue(v)
        }
        writer.endObject()
    }
}

extend<V> ConcurrentHashMap<String, V> <: JsonSerializable where V <: JsonSerializable {
    public func add(value: JsonValue): JsonValue {
        let newValue = value.addObject()
        for ((k, v) in this) {
            v.addMember(k, newValue)
        }
        return newValue
    }

    public func addMember(key: String, value: JsonValue): JsonValue {
        let newValue = value.addMemberObject(key)
        for ((k, v) in this) {
            v.addMember(k, newValue)
        }
        return newValue
    }

    public func set(value: JsonValue): Unit {
        value.setObject()
        for ((k, v) in this) {
            v.addMember(k, value)
        }
    }

    public func write(writer: JsonWriter): Unit {
        writer.startObject()
        for ((k, v) in this) {
            writer.writeName(k)
            writer.writeValue(v)
        }
        writer.endObject()
    }
}

// cjlint-ignore -end implement interface at type definition
// cjlint-ignore -end avoid using interface as type parameter
