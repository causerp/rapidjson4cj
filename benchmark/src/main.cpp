#include <iostream>
#include <string>
#include <chrono>
#include <vector>
#include <algorithm>
#include <fstream>
#include <functional>
#include <sstream>
#include <string>

#include "rapidjson/document.h"
#include "rapidjson/prettywriter.h"
#include "rapidjson/stringbuffer.h"

const char* JSON_FILE = "large-file.json";
const int WARMUP_ROUNDS = 5;
const int BENCHMARK_ROUNDS = 20;

std::string strLengthString; // make sure compiler doesn't remove string by storing the last value globally

auto countLeavesRapidJson(const rapidjson::Value* value) -> long long {
    auto count = 0LL;
    if (value->IsArray()) {
        for (const auto& item : value->GetArray()) {
            count += countLeavesRapidJson(&item);
        }
    }
    else if (value->IsObject()) {
        for (const auto& member : value->GetObject()) {
            count += countLeavesRapidJson(&member.value);
        }
    }
    else {
        count++;
    }
    return count;
}

auto countStringLengthRapidJson(const rapidjson::Value* value) -> long long {
    auto strLen = 0LL;
    if (value->IsArray()) {
        for (const auto& item : value->GetArray()) {
            strLen += countStringLengthRapidJson(&item);
        }
    }
    else if (value->IsObject()) {
        for (const auto& member : value->GetObject()) {
            strLen += countStringLengthRapidJson(&member.value);
        }
    }
    else if (value->IsString()) {
        strLengthString = std::string(value->GetString(), value->GetStringLength());
        strLen += strLengthString.length();
    }
    return strLen;
}

auto writeDocumentRapidJson(rapidjson::PrettyWriter<rapidjson::StringBuffer>& writer, const rapidjson::Value* value) -> void {
    if (value->IsArray()) {
        writer.StartArray();
        for (const auto& item : value->GetArray()) {
            writeDocumentRapidJson(writer, &item);
        }
        writer.EndArray();
    }
    else if (value->IsObject()) {
        writer.StartObject();
        for (const auto& member : value->GetObject()) {
            writer.Key(member.name.GetString(), member.name.GetStringLength());
            writeDocumentRapidJson(writer, &member.value);
        }
        writer.EndObject();
    }
    else if (value->IsBool()) {
        writer.Bool(value->GetBool());
    }
    else if (value->IsInt64()) {
        writer.Int64(value->GetInt64());
    }
    else if (value->IsDouble()) {
        writer.Double(value->GetDouble());
    }
    else if (value->IsString()) {
        writer.String(value->GetString(), value->GetStringLength());
    }
    else if (value->IsNull()) {
        writer.Null();
    }
}

auto runBenchmark(const std::string& name, std::function<std::string()> benchFunc) -> void {
    std::cout << "\nWarming up " << name << " (" << WARMUP_ROUNDS << " rounds)...\n";
    for (auto i = 0; i < WARMUP_ROUNDS; ++i) {
        benchFunc();
    }

    std::cout << "Running " << name << " (" << BENCHMARK_ROUNDS << " rounds)...\n";
    std::vector<long long> durations(BENCHMARK_ROUNDS);
    std::string returnDescription;

    for (auto i = 0; i < BENCHMARK_ROUNDS; ++i) {
        auto start = std::chrono::high_resolution_clock::now();
        returnDescription = benchFunc();
        auto end = std::chrono::high_resolution_clock::now();
        durations[i] = std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
    }

    std::sort(durations.begin(), durations.end());

    auto p95Index = static_cast<int>(static_cast<double>(BENCHMARK_ROUNDS) * 0.95);

    auto totalNs = 0LL;
    for (auto i = 0; i < p95Index; ++i) {
        totalNs += durations[i];
    }

    auto avgDurationNs = totalNs / p95Index;
    auto opsPerSec = 1000000000LL / avgDurationNs;

    std::cout << "----------------------------------------\n";
    std::cout << "Results for: " << name << "\n";
    std::cout << "    Return value:         " << returnDescription << "\n";
    std::cout << "    Avg duration (P95):   " << avgDurationNs / 1000000 << " ms (" << avgDurationNs << " ns)\n";
    std::cout << "    Throughput:           " << opsPerSec << " ops/sec\n";
    std::cout << "    Min time:             " << durations[0] / 1000000 << " ms\n";
    std::cout << "    Max time (excluded):  " << durations[BENCHMARK_ROUNDS - 1] / 1000000 << " ms\n";
}

auto main() -> int {
    std::ifstream file(JSON_FILE);
    std::stringstream buffer;
    buffer << file.rdbuf();
    auto json = buffer.str();
    std::cout << "Loaded JSON file (" << json.size() << " chars)\n";

    rapidjson::Document doc;
    doc.Parse<rapidjson::ParseFlag::kParseValidateEncodingFlag>(json.c_str(), json.size());

    if (doc.HasParseError()) {
        std::cerr << "JSON Parse error!\n";
        return 1;
    }

    auto rapidJsonLeafCountFunc = [&json]() -> std::string {
        try {
            rapidjson::Document localDoc;
            localDoc.Parse<rapidjson::ParseFlag::kParseValidateEncodingFlag>(json.c_str(), json.size());
            if (localDoc.HasParseError()) {
                return "Exception: Parse failed";
            }
            auto count = countLeavesRapidJson(&localDoc);
            return std::to_string(count) + " leaf nodes";
        }
        catch (...) {
            return "Exception: Unknown";
        }
    };

    auto rapidJsonStrLenFunc = [&json]() -> std::string {
        try {
            rapidjson::Document localDoc;
            localDoc.Parse<rapidjson::ParseFlag::kParseValidateEncodingFlag>(json.c_str(), json.size());
            if (localDoc.HasParseError()) {
                return "Exception: Parse failed";
            }
            auto totalStrLen = countStringLengthRapidJson(&localDoc);
            return std::to_string(totalStrLen) + " total string length. Last string: " + strLengthString;
        }
        catch (...) {
            return "Exception: Unknown";
        }
    };

    auto rapidJsonWriterFunc = [&doc]() -> std::string {
        try {
            rapidjson::StringBuffer sb;
            rapidjson::PrettyWriter<rapidjson::StringBuffer> writer(sb);
            writer.SetIndent(' ', 2);
            writeDocumentRapidJson(writer, &doc);
            auto resultSize = sb.GetLength();
            return std::to_string(resultSize) + " string length";
        }
        catch (...) {
            return "Exception: Unknown";
        }
    };

    runBenchmark("RapidJson Native C++ (Parse + Count Leaves)", rapidJsonLeafCountFunc);
    runBenchmark("RapidJson Native C++ (Parse + Count String Length)", rapidJsonStrLenFunc);
    runBenchmark("RapidJson Native C++ (PrettyWriter Only)", rapidJsonWriterFunc);

    std::cout << "\nBenchmarking complete.\n";

    return 0;
}
