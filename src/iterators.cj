package rapidjson4cj

public struct JsonMember {
    JsonMember(
        public let name: JsonValue,
        public let value: JsonValue
    ) {}

    public func getName(): String {
        name.getString() ?? String.empty
    }
}

public class JsonMemberIterator <: Iterator<JsonMember> {
    private var root: Document
    private var itBegin: CPointer<Unit>
    private let itEnd: CPointer<Unit>

    init(root: Document, itBegin: CPointer<Unit>, itEnd: CPointer<Unit>) {
        this.root = root
        this.itBegin = itBegin
        this.itEnd = itEnd
    }

    public func next(): ?JsonMember {
        var currentIt = itBegin
        if (currentIt.toUIntNative() == itEnd.toUIntNative()) {
            return None
        }
        let member = unsafe { RJ4CJMemberIterator_next(inout currentIt) }
        itBegin = currentIt
        return JsonMember(
            JsonValue(member.name, root: root),
            JsonValue(member.value, root: root)
        )
    }
}

public class JsonValueIterator <: Iterator<JsonValue> {
    private var root: Document
    private var itBegin: CPointer<Unit>
    private let itEnd: CPointer<Unit>

    init(root: Document, itBegin: CPointer<Unit>, itEnd: CPointer<Unit>) {
        this.root = root
        this.itBegin = itBegin
        this.itEnd = itEnd
    }

    public func next(): ?JsonValue {
        var currentIt = itBegin
        if (currentIt.toUIntNative() == itEnd.toUIntNative()) {
            return None
        }
        let handle = unsafe { RJ4CJValueIterator_next(inout currentIt) }
        itBegin = currentIt
        return match (handle.isNull()) {
            case false => JsonValue(handle, root: root)
            case true => None
        }
    }
}
