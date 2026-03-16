# rapidjson4cj

rapidjson4cj is a Cangjie package that implements JSON encoding/decoding using rapidjson.

## Build Requirements

To build this package, you must have the following tools installed and available in your system's PATH:

*   **C Compiler**: Clang or GCC
*   **CMake**

## How it Works

This library bundles a compiled static version of **rapidjson** directly within the package. 

*   **No External Dependencies**: You do not need to ship a separate `rapidjson.dll`, `librapidjson.so`,
      or `rapidjson.dylib` with your application. The library self-contains the native code.

## Examples

This example demonstrates how to parse a JSON string into a document, access various
value types including nested objects and arrays.

```
import rapidjson4cj.Document

main() {
    let json = #"
    {
        "project": "rapidjson4cj",
        "version": 1.0,
        "active": true,
        "tags": ["native", "fast"],
        "details": {
            "author": "developer"
        }
    }
    "#

    try(doc = Document(json)) {
        // 1. Check root type
        if (doc.isObject()) {
            println("Document is a valid JSON Object.")
        }

        // 2. Access simple values
        let project = doc.getString("project")
        println("Project: ${project ?? "Unknown"}")

        let active = doc.getBool("active")
        println("Active: ${active ?? false}")

        // 3. Access nested objects
        match (doc.getObject("details")) {
            case Some(details) =>
                let author = details.getString("author")
                println("Author: ${author ?? "Unknown"}")
            case None => println("Details not found.")
        }

        // 4. Access arrays
        match (doc.getArray("tags")) {
            case Some(arr) => for (item in arr.arrayIterator()) {
                // Items in the array are values, check type before getting
                if (item.isString()) {
                    println("Tag: ${item.getString() ?? ""}")
                }
            }
            case None => println("Tags not found.")
        }
    } catch (e: Exception) {
        println("JSON Error: ${e}")
    }
}
```

## License

MIT License
