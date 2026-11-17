# Copyright 2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

cmake_minimum_required(VERSION 3.16)
project(napi_collected_reference_regression LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 17)
get_filename_component(PRIMJS_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../.." ABSOLUTE)
option(ENABLE_ASAN "Build the manual regression with AddressSanitizer" OFF)
set(ENABLE_LEPUSNG ON CACHE BOOL "" FORCE)
set(ENABLE_UNITTESTS OFF CACHE BOOL "" FORCE)
set(ENABLE_NAPI_ADAPTER_TESTS OFF CACHE BOOL "" FORCE)
option(NAPI_REGRESSION_TRACING_GC "Exercise the tracing GC reference path" OFF)
if(NAPI_REGRESSION_TRACING_GC)
  if(NOT CMAKE_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64)$")
    message(FATAL_ERROR "Tracing GC requires an arm64 build; this engine disables it on other CPUs")
  endif()
  add_compile_definitions(ENABLE_COMPATIBLE_MM REGRESSION_TRACING_GC)
endif()
add_compile_definitions(QJS_UNITTEST HEAPPROFILER_UNITTEST LYNX_SIMPLIFY)
include_directories(
  "${PRIMJS_SOURCE_DIR}/src"
  "${PRIMJS_SOURCE_DIR}/src/interpreter"
  "${PRIMJS_SOURCE_DIR}/src/napi"
  "${PRIMJS_SOURCE_DIR}/src/napi/common"
  "${PRIMJS_SOURCE_DIR}/src/napi/env"
  "${PRIMJS_SOURCE_DIR}/src/napi/internal"
  "${PRIMJS_SOURCE_DIR}/src/napi/quickjs"
  "${PRIMJS_SOURCE_DIR}/src/napi/jsc"
  "${PRIMJS_SOURCE_DIR}/src/napi/adapter")
add_subdirectory("${PRIMJS_SOURCE_DIR}" engine)
find_package(Threads REQUIRED)
add_executable(napi_collected_reference_regression
  regression.cc
  "${PRIMJS_SOURCE_DIR}/src/napi/adapter/js_native_api_adapter.cc"
  "${PRIMJS_SOURCE_DIR}/src/basic/log/primjs_logging.cc")
target_link_libraries(napi_collected_reference_regression PRIVATE napi_static quickjs Threads::Threads ${CMAKE_DL_LIBS})
if(ENABLE_ASAN)
  target_compile_options(napi_collected_reference_regression PRIVATE -fsanitize=address -fno-omit-frame-pointer)
  target_link_options(napi_collected_reference_regression PRIVATE -fsanitize=address)
endif()
