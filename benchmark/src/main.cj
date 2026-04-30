package benchmark

import rapidjson4cj.{JsonValue as RJsonValue, PrettyWriter}
import std.fs.File
import std.io.ByteBuffer
import std.runtime.gc
import std.sort.sort
import std.time.MonoTime
import stdx.encoding.json.{JsonValue, JsonKind}
import stdx.encoding.json.stream.{JsonWriter, WriteConfig}

const JSON_FILE = "large-file.json"
const WARMUP_ROUNDS = 5
const BENCHMARK_ROUNDS = 1000

func countLeavesStdxJson(value: JsonValue): Int64 {
    var count = 0
    match (value.kind()) {
        case JsArray => for (item in value.asArray().getItems()) {
            count += countLeavesStdxJson(item)
        }
        case JsObject => for ((_, memberValue) in value.asObject().getFields()) {
            count += countLeavesStdxJson(memberValue)
        }
        case _ => count++
    }
    return count
}

func countLeavesRapidJson(value: RJsonValue): Int64 {
    var count = 0
    match {
        case value.isArray() => for (item in value) {
            count += countLeavesRapidJson(item)
        }
        case value.isObject() => for (member in value.memberIterator()) {
            count += countLeavesRapidJson(member.value)
        }
        case _ => count++
    }
    return count
}

func countStringLengthStdxJson(value: JsonValue): Int64 {
    var strLen = 0
    match (value.kind()) {
        case JsArray => for (item in value.asArray().getItems()) {
            strLen += countStringLengthStdxJson(item)
        }
        case JsObject => for ((memberName, memberValue) in value.asObject().getFields()) {
            strLen += memberName.size
            strLen += countStringLengthStdxJson(memberValue)
        }
        case JsString => strLen += value.asString().getValue().size
        case _ => ()
    }
    return strLen
}

func countStringLengthRapidJson(value: RJsonValue): Int64 {
    var strLen = 0
    match {
        case value.isArray() => for (item in value) {
            strLen += countStringLengthRapidJson(item)
        }
        case value.isObject() => for (member in value.memberIterator()) {
            strLen += member.getName().size
            strLen += countStringLengthRapidJson(member.value)
        }
        case value.isString() => strLen += value.getString()?.size ?? 0
        case _ => ()
    }
    return strLen
}

func writeDocumentStdxJson(writer: JsonWriter, value: RJsonValue): Unit {
    match {
        case value.isArray() =>
            writer.startArray()
            for (item in value) {
                writeDocumentStdxJson(writer, item)
            }
            writer.endArray()
        case value.isObject() =>
            writer.startObject()
            for (member in value.memberIterator()) {
                writer.writeName(member.getName())
                writeDocumentStdxJson(writer, member.value)
            }
            writer.endObject()
        case value.isBool() => writer.writeValue(value.getBool() ?? false)
        case value.isInt64() => writer.writeValue(value.getInt64() ?? 0)
        case value.isFloat64() => writer.writeValue(value.getFloat64() ?? 0.0)
        case value.isString() => writer.writeValue(value.getString() ?? "")
        case _ => writer.writeNullValue()
    }
}

func writeDocumentRapidJson(writer: PrettyWriter, value: RJsonValue): Unit {
    match {
        case value.isArray() =>
            writer.startArray()
            for (item in value) {
                writeDocumentRapidJson(writer, item)
            }
            writer.endArray()
        case value.isObject() =>
            writer.startObject()
            for (member in value.memberIterator()) {
                writer.writeName(member.getName())
                writeDocumentRapidJson(writer, member.value)
            }
            writer.endObject()
        case value.isBool() => writer.writeValue(value.getBool() ?? false)
        case value.isInt64() => writer.writeValue(value.getInt64() ?? 0)
        case value.isFloat64() => writer.writeValue(value.getFloat64() ?? 0.0)
        case value.isString() => writer.writeValue(value.getString() ?? "")
        case _ => writer.writeNullValue()
    }
}

func runBenchmark(name: String, benchFunc: () -> String) {
    gc(heavy: true)

    println("\nWarming up ${name} (${WARMUP_ROUNDS} rounds)...")
    for (_ in 0..WARMUP_ROUNDS) {
        benchFunc()
    }

    println("Running ${name} (${BENCHMARK_ROUNDS} rounds)...")
    var durations = Array<Duration>(BENCHMARK_ROUNDS, repeat: Duration.Zero)
    var returnDescription = ""

    for (i in 0..BENCHMARK_ROUNDS) {
        let start = MonoTime.now()
        returnDescription = benchFunc()
        let end = MonoTime.now()
        durations[i] = end - start
    }

    durations |> sort

    // Calculate average of the fastest 95% of runs
    let p95Index = Int64(Float64(BENCHMARK_ROUNDS) * 0.95)

    var totalNs = 0
    for (i in 0..p95Index) {
        totalNs += durations[i].toNanoseconds()
    }
    if (totalNs == 0) {
        throw ArithmeticException()
    }

    let avgDurationNs = totalNs / p95Index
    let opsPerSec = 1_000_000_000 / avgDurationNs

    println("----------------------------------------")
    println("Results for: ${name}")
    println("    Return value:         ${returnDescription}")
    println("    Avg duration (P95):   ${avgDurationNs / 1_000_000} ms (${avgDurationNs} ns)")
    println("    Throughput:           ${opsPerSec} ops/sec")
    println("    Min time:             ${durations[0].toMilliseconds()} ms")
    println("    Max time (excluded):  ${durations[BENCHMARK_ROUNDS - 1].toMilliseconds()} ms")
}

main() {
    let json = String.fromUtf8(File.readFrom(JSON_FILE))
    println("Loaded JSON file (${json.size} chars)")

    let doc = RJsonValue(json)

    let rapidJsonLeafCountFunc = {
        =>
            try (localDoc = RJsonValue(json)) {
                let count = countLeavesRapidJson(localDoc)
                return "${count} leaf nodes"
            } catch (e: Exception) {
                return "Exception: ${e.message}"
            }
            return "?"
    }

    let stdxJsonLeafCountFunc = {
        => try {
            let localDoc = JsonValue.fromStr(json)
            let count = countLeavesStdxJson(localDoc)
            return "${count} leaf nodes"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let rapidJsonStrLenFunc = {
        =>
            try (localDoc = RJsonValue(json)) {
                let totalStrLen = countStringLengthRapidJson(localDoc)
                return "${totalStrLen} total string length"
            } catch (e: Exception) {
                return "Exception: ${e.message}"
            }
            return "?"
    }

    let stdxJsonStrLenFunc = {
        => try {
            let localDoc = JsonValue.fromStr(json)
            let totalStrLen = countStringLengthStdxJson(localDoc)
            return "${totalStrLen} total string length"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let rapidJsonWriterFunc = {
        => try {
            let writer = PrettyWriter()
            writeDocumentRapidJson(writer, doc)
            return "${writer.getString().size} string length"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let stdxJsonWriterFunc = {
        => try {
            let stream = ByteBuffer()
            let writer = JsonWriter(stream)
            writer.writeConfig = WriteConfig.pretty
            writer.writeConfig.indent = "  "
            writeDocumentStdxJson(writer, doc)
            writer.flush()
            return "${String.fromUtf8(stream.bytes()).size} string length"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    runBenchmark("stdx.encoding.json (Parse + Count Leaves)", stdxJsonLeafCountFunc)
    runBenchmark("rapidjson4cj (Parse + Count Leaves)", rapidJsonLeafCountFunc)
    runBenchmark("stdx.encoding.json (Parse + Count String Length)", stdxJsonStrLenFunc)
    runBenchmark("rapidjson4cj (Parse + Count String Length)", rapidJsonStrLenFunc)
    runBenchmark("stdx.encoding.stream (Writer Only)", stdxJsonWriterFunc)
    runBenchmark("rapidjson4cj (PrettyWriter Only)", rapidJsonWriterFunc)

    println("\nBenchmarking complete.")
}
