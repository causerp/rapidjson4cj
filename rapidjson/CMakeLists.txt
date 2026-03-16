cmake_minimum_required(VERSION 3.20)
project(RapidJsonWrapper VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(RapidJsonWrapper
    src/JsonWrapper.cpp
)

set_target_properties(RapidJsonWrapper PROPERTIES POSITION_INDEPENDENT_CODE ON)

if (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(RapidJsonWrapper PRIVATE -fno-exceptions -fno-rtti)
    target_link_options(RapidJsonWrapper PRIVATE -nostdlib++)
elseif (MSVC)
    target_compile_options(RapidJsonWrapper PRIVATE /EHs-c-)
    target_compile_definitions(RapidJsonWrapper PRIVATE _HAS_EXCEPTIONS=0)
endif()
