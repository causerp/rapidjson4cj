cmake_minimum_required(VERSION 3.20)
project(RapidJson4cjWrapper VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_library(RapidJson4cjWrapper
    src/rj4cj_wrapper.cpp
)

set_target_properties(RapidJson4cjWrapper PROPERTIES POSITION_INDEPENDENT_CODE ON)

if (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(RapidJson4cjWrapper PRIVATE -fno-exceptions -fno-rtti)
    target_link_options(RapidJson4cjWrapper PRIVATE -nostdlib++)
elseif (MSVC)
    target_compile_options(RapidJson4cjWrapper PRIVATE /EHs-c-)
    target_compile_definitions(RapidJson4cjWrapper PRIVATE _HAS_EXCEPTIONS=0)
endif()
