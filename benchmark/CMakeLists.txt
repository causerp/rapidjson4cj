cmake_minimum_required(VERSION 3.20)
project(benchmark LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)


add_executable(${PROJECT_NAME} src/main.cpp)

target_include_directories(${PROJECT_NAME} PRIVATE ../rapidjson/src)

if (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(${PROJECT_NAME} PRIVATE
        -Wall                   # Enables standard compiler warnings for code quality
        -Wdate-time             # Warns if macros like __DATE__ are used, prevents non-reproducible builds
        -fsigned-char           # Forces char to be signed, avoids ABI inconsistencies across platforms
        -pipe                   # Uses OS pipes instead of temporary files, speeds up compilation
        -fno-common             # Places uninitialized globals in BSS, improves compile times and symbol resolution
        -fno-strict-aliasing    # Prevents aggressive optimizations that break type-punning (e.g., JSON unions/void*)
        -fno-omit-frame-pointer # Keeps the frame pointer, aids profiling/debugging deep call stacks (minor perf cost)
        -fstack-protector-all   # Adds stack canaries to all functions for security (slight runtime overhead)
    )

    if (MINGW)
        target_compile_options(${PROJECT_NAME} PRIVATE
            -m64          # Forces 64-bit x86_64 target, overrides defaults for cross-compile safety
            -msse4.2      # Enables SSE4.2 instructions
            -Wa,-mbig-obj # Required for large object files on Windows
        )
        target_link_options(${PROJECT_NAME} PRIVATE
            -Wl,--no-insert-timestamp # Improves build cache hits by removing timestamp from PE headers
        )

        find_program(LLD_PATH lld${CMAKE_EXECUTABLE_SUFFIX})
        if(LLD_PATH)
            message(STATUS "Found lld: ${LLD_PATH}. Using lld.")
            file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/toolchain/)
            file(CREATE_LINK ${LLD_PATH} ${CMAKE_BINARY_DIR}/toolchain/ld.lld${CMAKE_EXECUTABLE_SUFFIX} SYMBOLIC)
            target_link_options(${PROJECT_NAME} PRIVATE -B${CMAKE_BINARY_DIR}/toolchain/ -fuse-ld=lld)
        endif()
    elseif(NOT APPLE)
        if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
            if(CMAKE_BUILD_TYPE MATCHES "Release")
                target_compile_options(${PROJECT_NAME} PRIVATE
                    -D_FORTIFY_SOURCE=2 # Replaces libc calls with secure, faster bounds-checking variants
                    -O2                 # Standard optimizations
                    -msse4.2            # Enables SSE4.2 (fixes RapidJSON __builtin_ia32_pcmpistri128)
                    -march=x86-64-v2    # Sets baseline to SSE4.2 + POPCNT
                )
            endif()
        elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "armv7|armv7l")
            if(CMAKE_BUILD_TYPE MATCHES "Release")
                target_compile_options(${PROJECT_NAME} PRIVATE
                    -D_FORTIFY_SOURCE=2
                    -O2
                    -march=armv7-a
                    -mfpu=neon          # Explicitly enable NEON for 32-bit ARM
                    -mfloat-abi=hard    # Use hardware floating point (standard for modern armv7)
                )
            endif()
        elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64")
            if(CMAKE_BUILD_TYPE MATCHES "Release")
                target_compile_options(${PROJECT_NAME} PRIVATE
                    -D_FORTIFY_SOURCE=2
                    -O2
                    -march=armv8-a      # Baseline ARMv8
                )
            endif()
        endif()

        target_link_options(${PROJECT_NAME} PRIVATE
            -Wl,-z,relro       # Hardens ELF binaries against memory corruption attacks
            -Wl,-z,now         # Disables lazy binding, resolving all symbols at startup
            -Wl,-z,noexecstack # Marks the stack as non-executable to prevent stack-based shellcode exploits
        )
    endif()

elseif (MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE
        /O2    # Maximizes speed
    )
endif()
