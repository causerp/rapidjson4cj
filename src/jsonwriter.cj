package rapidjson4cj

public interface JsonWriter {
    func isComplete(): Bool
    func getMaxDecimalPlaces(): Int32
    func setMaxDecimalPlaces(maxDecimalPlaces: Int32): Unit
    func getString(): String
    func writeNullValue(): Bool
    func writeBool(b: Bool): Bool
    func writeInt32(i: Int32): Bool
    func writeUInt32(u: UInt32): Bool
    func writeInt64(i64: Int64): Bool
    func writeUInt64(u64: UInt64): Bool
    func writeFloat32(f: Float32): Bool
    func writeFloat64(d: Float64): Bool
    func writeString(str: String): Bool
    func writeValue(value: JsonValue): Bool
    func writeName(name: String): Bool
    func startObject(): Bool
    func endObject(): Bool
    func startArray(): Bool
    func endArray(): Bool

    /**
     * Writes a value that implements JsonSerializable.
     *
     * @param value The value to write.
     */
    func writeValue<T>(value: T): Unit where T <: JsonSerializable {
        value.write(this)
    }
}
