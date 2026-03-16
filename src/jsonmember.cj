package rapidjson4cj

@C
public struct JsonMember {
    let name: JsonValue = JsonValue(CPointer())
    let value: JsonValue = JsonValue(CPointer())
}

public class JsonMemberIterator <: Iterator<JsonMember> {
    private var itBegin: CPointer<Unit>
    private let itEnd: CPointer<Unit>

    init(itBegin: CPointer<Unit>, itEnd: CPointer<Unit>) {
        this.itBegin = itBegin
        this.itEnd = itEnd
    }

    public func next(): ?JsonMember {
        var currentIt = itBegin
        if (currentIt.toUIntNative() == itEnd.toUIntNative()) {
            return None
        }
        let member = unsafe { RJ4CJ_getMemberNext(inout currentIt) }
        itBegin = currentIt
        return member
    }
}
