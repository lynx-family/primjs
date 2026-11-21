# Copyright 2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

cmake_minimum_required(VERSION 3.16)
project(napi_async_work_regression LANGUAGES C CXX)
set(CMAKE_CXX_STANDARD 17)
get_filename_component(PRIMJS_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../.." ABSOLUTE)
option(ENABLE_ASAN "Build the manual regression with AddressSanitizer" OFF)
set(ENABLE_LEPUSNG ON CACHE BOOL "" FORCE)
set(ENABLE_UNITTESTS OFF CACHE BOOL "" FORCE)
set(ENABLE_NAPI_ADAPTER_TESTS OFF CACHE BOOL "" FORCE)
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
add_executable(napi_async_work_regression
  regression.cc
  "${PRIMJS_SOURCE_DIR}/src/napi/adapter/js_native_api_adapter.cc"
  "${PRIMJS_SOURCE_DIR}/src/basic/log/primjs_logging.cc")
target_link_libraries(napi_async_work_regression PRIVATE napi_static quickjs Threads::Threads ${CMAKE_DL_LIBS})
if(ENABLE_ASAN)
  target_compile_options(napi_async_work_regression PRIVATE -fsanitize=address -fno-omit-frame-pointer)
  target_link_options(napi_async_work_regression PRIVATE -fsanitize=address)
endif()
