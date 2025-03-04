# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

cmake_minimum_required(VERSION 3.10.1)

project("primjs")

enable_language(C CXX ASM)
set(CMAKE_CXX_STANDARD 17)
set(REGEX_TRUE "True|true|TRUE|1")

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
endif()

message(STATUS "Building in ${CMAKE_BUILD_TYPE} mode")
message(("${CMAKE_CURRENT_SOURCE_DIR}"))

option(ENABLE_QUICKJS_DEBUGGER "Enable quickjs debugger" OFF)
option(ENABLE_LEPUSNG "Enable LepusNG" OFF)
option(ENABLE_LITE "Enable quickjs static library" OFF)
option(ENABLE_PRIMJS_SNAPSHOT "Enable primjs snapshot" OFF)
option(ENABLE_COMPATIBLE_MM "Enable compatible memory" OFF)
option(DISABLE_NANBOX "Disable nanbox" OFF)
option(ENABLE_CODECACHE "Enable code cache" OFF)
option(CACHE_PROFILE "Enable cache profile" OFF)
option(ENABLE_MEM "Enable memmor deteck" OFF)
option(FORCE_GC "Enable force gc" OFF)
option(ENABLE_ASAN "Enable address sanitizer" OFF)
option(ENABLE_BIGNUM "Enable bignum" OFF)
option(ENABLE_UNITTESTS "Enable build unittests" OFF)
option(ENABLE_BUILD_AAR "Enable build aar" OFF)

set(CMAKE_COMMON_FLAGS
    "${CMAKE_COMMON_FLAGS} -Os -fPIC -ffunction-sections -fdata-sections \
    -fno-short-enums -fno-strict-aliasing -Wall -Wextra -Wno-unused-parameter \
    -Wno-unused-function -faddrsig -Wno-c99-designator -Wno-unknown-warning-option \
    -Wno-sign-compare -Wno-unused-but-set-variable")

if(ENABLE_ASAN)
  set(CMAKE_COMMON_FLAGS
      "${CMAKE_COMMON_FLAGS} -fno-omit-frame-pointer -fsanitize=address")
else()
  set(CMAKE_COMMON_FLAGS
      "${CMAKE_COMMON_FLAGS} -fomit-frame-pointer -fno-sanitize=safe-stack")
endif()

set(CMAKE_C_FLAGS ${CMAKE_COMMON_FLAGS} ${CMAKE_C_FLAGS})
set(CMAKE_CXX_FLAGS "${CMAKE_COMMON_FLAGS} ${CMAKE_CXX_FLAGS} -std=c++17")

set(CMAKE_SHARED_LINKER_FLAGS
    "${CMAKE_SHARED_LINKER_FLAGS} -Wl,-Bsymbolic -Wl,--warn-shared-textrel \
    -Wl,--exclude-libs,ALL,--gc-sections -Wl,--build-id=sha1 -O2 -flto \
    -Wl,--icf=all -Wl,-Map=output.map")

add_definitions(-DEMSCRIPTEN)

if(${ENABLE_MEM})
  add_definitions(-DDEBUG_MEMORY)
  add_definitions(-DDUMP_QJS_VALUE)
  add_definitions(-DDUMP_LEAKS)
endif()

if(${FORCE_GC})
  add_definitions(-DFORCE_GC_AT_MALLOC)
endif()

if(${ENABLE_LEPUSNG})
  add_definitions(-DENABLE_LEPUSNG)
endif()

if(${DISABLE_NANBOX})
  add_definitions(-DDISABLE_NANBOX=1)
else()
  add_definitions(-DDISABLE_NANBOX=0)
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Android")
  add_definitions(-DOS_ANDROID=1)
endif()
# primjs snapshot version
if(${ENABLE_PRIMJS_SNAPSHOT} AND (${ANDROID_ABI} MATCHES "arm64"))
  add_definitions(-DENABLE_PRIMJS_SNAPSHOT)
  if(${ENABLE_COMPATIBLE_MM} AND (${ANDROID_ABI} MATCHES "arm64"))
    add_definitions(-DENABLE_COMPATIBLE_MM)
  endif()
  if(${ENABLE_QUICKJS_DEBUGGER})
    set(primjs_embedded_sources
        ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/primjs/android/embedded-inspector.S
    )
  else()
    set(primjs_embedded_sources
        ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/primjs/android/embedded.S)
  endif()
else()

endif()

# armeabi can't use fenv.h/fesetround()
if(${ANDROID_ABI} MATCHES " armeabi ")
  add_definitions(-DLYNX_ARMEABI=0)
endif()

if(ENABLE_UNITTESTS)
  add_definitions(-DQJS_UNITTEST)
  add_definitions(-DLYNX_SIMPLIFY)
  add_definitions(-DHEAPPROFILER_UNITTEST)
endif()

if(WIN32)
  add_definitions(-DOS_WIN)
  add_definitions(-DALLOCATE_WINDOWS)
endif()

set(quickjs_sources
    ${CMAKE_CURRENT_SOURCE_DIR}/src/basic/log/logging.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/gc/allocator.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/gc/collector.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/gc/global-handles.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/gc/qjsvaluevalue-space.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/gc/sweeper.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/gc/thread_pool.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/gc/collector.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/quickjs/source/cutils.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/quickjs/source/libregexp.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/quickjs/source/libunicode.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/quickjs/source/primjs_monitor.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/quickjs/source/quickjs_gc.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/quickjs/source/quickjs_queue.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/quickjs/source/quickjs_version.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/quickjs/source/quickjs-libc.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/quickjs/source/quickjs.cc)

if(ENABLE_BIGNUM)
  set(quickjs_sources
      ${quickjs_sources}
      ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter/quickjs/source/libbf.cc)
endif()

if(${ENABLE_QUICKJS_DEBUGGER})
  add_definitions(-DENABLE_QUICKJS_DEBUGGER)
  set(qucikjs_debugger_sources
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/cpuprofiler/cpu_profiler.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/cpuprofiler/profile_generator.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/cpuprofiler/profile_tree.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/cpuprofiler/profiler_sampling.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/cpuprofiler/tracing_cpu_profiler.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/debugger/debugger_breakpoint.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/debugger/debugger_callframe.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/debugger/debugger_properties.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/debugger/debugger_queue.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/debugger/debugger.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/heapprofiler/edge.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/heapprofiler/entry.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/heapprofiler/gen.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/heapprofiler/heapexplorer.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/heapprofiler/heapprofiler.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/heapprofiler/serialize.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/heapprofiler/snapshot.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/runtime/runtime.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/protocols.cc
      ${CMAKE_CURRENT_SOURCE_DIR}/src/inspector/string_tools.cc)
endif()

set(napi_sources
    ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/env/napi_env.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/env/napi_runtime.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/quickjs/js_native_api_QuickJS.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/napi_module.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/napi.cc)

if(${ENABLE_CODECACHE})
  add_definitions(-DENABLE_CODECACHE)

  if(${CACHE_PROFILE})
    add_definitions(-DCACHE_PROFILE)
  endif()

  set(napi_sources ${napi_sources}
                   ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/common/code_cache.cc)
endif()

set(napi_v8_sources ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/v8/js_native_api_v8.cc)

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/src
  ${CMAKE_CURRENT_SOURCE_DIR}/src/interpreter
  ${CMAKE_CURRENT_SOURCE_DIR}/src/napi
  ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/common
  ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/env
  ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/internal
  ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/quickjs
  ${CMAKE_CURRENT_SOURCE_DIR}/src/napi/v8)

set(JS_V8_HEADERS ${CMAKE_SOURCE_DIR}/../../third_party/v8/include)

set(quickjs_sources ${quickjs_sources} ${qucikjs_debugger_sources}
                    ${primjs_embedded_sources})

if(NOT (${CMAKE_CURRENT_SOURCE_DIR} STREQUAL ${CMAKE_SOURCE_DIR}))
  set(napi_sources
      ${napi_sources}
      PARENT_SCOPE)
  set(quickjs_sources
      ${quickjs_sources}
      PARENT_SCOPE)
  set(napi_v8_sources
      ${napi_v8_sources}
      PARENT_SCOPE)
endif()

set_source_files_properties(
  ${napi_sources} ${napi_v8_sources}
  PROPERTIES
    COMPILE_FLAGS
    "${CMAKE_CXX_FLAGS} -fvisibility=hidden -fvisibility-inlines-hidden")
add_library(quickjs STATIC ${quickjs_sources})
add_library(napi_static STATIC ${napi_sources})

set_target_properties(
  quickjs PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR} OUTPUT_NAME
                                                                  "quick")
set_target_properties(
  napi_static PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
                         OUTPUT_NAME "napi")

if(ENABLE_BUILD_AAR)
  set(quickjs_sources
      ${quickjs_sources}
      "${CMAKE_CURRENT_SOURCE_DIR}/src/basic/log/primjs_logging.cc")

  add_library(quick SHARED ${quickjs_sources})
  add_library(napi SHARED ${napi_sources})
  add_library(napi_v8 SHARED ${napi_v8_sources})
  find_library(log_lib log)
  target_link_libraries(quick ${log_lib})
  target_link_libraries(napi quick)
  target_link_libraries(napi ${log_lib})
  target_include_directories(napi_v8 PRIVATE ${JS_V8_HEADERS})
  target_link_libraries(
    napi_v8 PUBLIC ${JS_V8_LIBRARY}/${ANDROID_ABI}/libv8_libfull.cr.so)
endif()

if(WIN32)
  if(${LINK_RUNTIME_TYPE} STREQUAL "MT")
    message("MT")
    add_compile_options($<$<OR:$<CONFIG:Release>,$<CONFIG:Relwithdebinfo>>:/MT>
                        $<$<CONFIG:Debug>:/MTd>)
    add_compile_definitions($<$<CONFIG:Debug>:_ITERATOR_DEBUG_LEVEL=2>)
  else()
    message("MD")
    add_compile_options($<$<OR:$<CONFIG:Release>,$<CONFIG:Relwithdebinfo>>:/MD>
                        $<$<CONFIG:Debug>:/MDd>)
  endif()

  target_compile_options(
    quickjs
    PUBLIC /utf-8
           /Gy # separate functions for linker
           /FC # use full pathnames in diagnostics
           /MP # Build with Multiple Processes
           /EHsc
           -Wno-unused-command-line-argument
           -Wno-c99-designator
           -Wno-implicit-function-declaration
           -Wno-unknown-argument
    PRIVATE)

  target_compile_definitions(
    quickjs
    PUBLIC UNICODE
           _UNICODE
           OS_WIN
           WIN32_LEAN_AND_MEAN
           _CRT_SECURE_NO_WARNINGS
           NOMINMAX
           _WINSOCK_DEPRECATED_NO_WARNINGS
           CONFIG_VERSION="2019-09-10")

  target_link_options(
    quickjs
    PRIVATE
    $<$<OR:$<CONFIG:Release>,$<CONFIG:Relwithdebinfo>>:/OPT:REF>
    $<$<OR:$<CONFIG:Release>,$<CONFIG:Relwithdebinfo>>:/OPT:ICF>
    $<$<OR:$<CONFIG:Release>,$<CONFIG:Relwithdebinfo>>:/INCREMENTAL:NO>
    /DEBUG)

  target_compile_options(
    napi_static
    PUBLIC /utf-8
           /Gy # separate functions for linker
           /FC # use full pathnames in diagnostics
           /MP # Build with Multiple Processes
           /EHsc
           -Wno-unused-command-line-argument
           -Wno-c99-designator
           -Wno-implicit-function-declaration
           -Wno-unknown-argument
    PRIVATE)

  target_compile_definitions(
    napi_static
    PUBLIC UNICODE
           _UNICODE
           OS_WIN
           WIN32_LEAN_AND_MEAN
           _CRT_SECURE_NO_WARNINGS
           NOMINMAX
           _WINSOCK_DEPRECATED_NO_WARNINGS
           CONFIG_VERSION="2019-09-10")

  target_link_options(
    napi_static
    PRIVATE
    $<$<OR:$<CONFIG:Release>,$<CONFIG:Relwithdebinfo>>:/OPT:REF>
    $<$<OR:$<CONFIG:Release>,$<CONFIG:Relwithdebinfo>>:/OPT:ICF>
    $<$<OR:$<CONFIG:Release>,$<CONFIG:Relwithdebinfo>>:/INCREMENTAL:NO>
    /DEBUG)
endif()

if(ENABLE_UNITTESTS)
  set(qjs_sources ${CMAKE_CURRENT_SOURCE_DIR}/testing/quickjs/compiler/qjs.cc)
  set(test262_sources
      ${CMAKE_CURRENT_SOURCE_DIR}/testing/quickjs/run-test262.cc)
  add_executable(run-test262 ${test262_sources} ${quickjs_sources})
  add_executable(qjs ${qjs_sources} ${quickjs_sources})
  set_target_properties(qjs run-test262 PROPERTIES RUNTIME_OUTPUT_DIRECTORY
                                                   ${CMAKE_BINARY_DIR})
endif()
