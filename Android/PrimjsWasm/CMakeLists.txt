# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

cmake_minimum_required(VERSION 3.10.2)

project(PrimjsWasm)

set(CMAKE_CXX_STANDARD 17)

set(REGEX_TRUE "True|true|TRUE")

add_definitions(-DOS_ANDROID=1)
add_definitions(-DANDROID=1)

# primjs snapshot version
if(ENABLE_PRIMJS_SNAPSHOT MATCHES ${REGEX_TRUE} AND ${ANDROID_ABI} MATCHES
                                                    "arm64")
  add_definitions(-DENABLE_PRIMJS_SNAPSHOT)
  add_definitions(-DENABLE_COMPATIBLE_MM) # require gc when enable primjs
                                          # snapshot
endif()

set(WASM_ANDROID_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(WASM_ANDROID_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${WASM_ANDROID_SOURCE_DIR}/cmake)
message(STATUS "wasm sources : ${WASM_ANDROID_SOURCE_DIR}")

set(WASM_ANDROID_NATIVE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src/native)
message(STATUS "PrimjsWasm sources : ${WASM_ANDROID_NATIVE_DIR}")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -fno-rtti -fvisibility=hidden -fvisibility-inlines-hidden -Os -fno-exceptions -fno-asynchronous-unwind-tables -fno-unwind-tables -fno-stack-protector -ffunction-sections -fdata-sections -fno-math-errno -fomit-frame-pointer")

if(NOT DEFINED CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
message(STATUS "build type : ${CMAKE_BUILD_TYPE}")

# Linker flags
if(${ANDROID_ABI} MATCHES "arm64-v8a" OR ${ANDROID_ABI} MATCHES "x86_64")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} \
      -Wl,--exclude-libs,ALL,--gc-sections -Wl,--icf=all -Wl,-z,max-page-size=16384 -Wl,-Map=output.map")
else()
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} \
      -Wl,--exclude-libs,ALL,--gc-sections -Wl,--icf=all -Wl,-Map=output.map")
endif()

set(CMAKE_COMMON_FLAGS "-ffunction-sections -fdata-sections \
  -flto -faddrsig -fno-short-enums -fno-strict-aliasing")

set(CMAKE_COMMON_FLAGS "${CMAKE_COMMON_FLAGS} -fvisibility=hidden \
  -fvisibility-inlines-hidden")

if(CMAKE_BUILD_TYPE MATCHES "Debug")
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -O0")
  set(CMAKE_COMMON_FLAGS "${CMAKE_COMMON_FLAGS} -O0")
  add_definitions(-DLOG_LEVEL=LOG_LEVEL_VERBOSE -DWASM_DEBUG)
else() # Release
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -flto -O3")
  set(CMAKE_COMMON_FLAGS "${CMAKE_COMMON_FLAGS} -flto -O3")
  add_definitions(-DLOG_LEVEL=LOG_LEVEL_ERROR)
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_COMMON_FLAGS} ${CMAKE_CXX_FLAGS}")

if(NOT DEFINED WASM_ENGINE)
  # set default wasm engine
  set(WASM_ENGINE "wasm3")
endif()

message(STATUS "wasm engine : ${WASM_ENGINE}")

include(Wasm3)

if(NOT DEFINED JS_ENGINE)
  set(JS_ENGINE "quickjs")
endif()

message(STATUS "js engine : ${JS_ENGINE}")

set(WASM_UTIL_SRC
  ${CMAKE_CURRENT_SOURCE_DIR}/../../src/basic/modp_b64/modp_b64.cc)

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/../../src/basic/modp_b64
)

# Add oss subdirectory to build quickjs
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/../../ ${CMAKE_CURRENT_BINARY_DIR}/oss_build)

# js engine binding must define after the wasm engine, because the js engine
# binding depends on
if(JS_ENGINE STREQUAL "quickjs")
  include(QJSWasm)
  add_definitions(-DJS_ENGINE_QJS=1)
  add_definitions(-DJS_ENGINE_TYPE=JS_ENGINE_QJS)
  if(NOT QJSWasm_FOUND)
    message(FATAL_ERROR "can not find module quickjs wasm binding!")
  endif()
  set(WASM_REGISTER_SRC ${WASM_ANDROID_NATIVE_DIR}/qjs_wasm/wasm_register.cpp)
else()
  message(FATAL_ERROR "no valid js engine is specified.")
endif()

target_link_libraries(js_wasm_binding wasm3_engine_lib)

find_library(log-lib log)

target_include_directories(js_wasm_binding PUBLIC ${wasm3_include})

add_library(wasm SHARED ${WASM_REGISTER_SRC} ${WASM_UTIL_SRC})
target_link_libraries(wasm js_wasm_binding ${log-lib})
