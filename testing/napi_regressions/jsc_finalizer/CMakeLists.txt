# Copyright 2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

cmake_minimum_required(VERSION 3.16)
project(napi_jsc_finalizer_regression LANGUAGES C CXX)
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
add_executable(napi_jsc_finalizer_regression
  regression.cc
  "${PRIMJS_SOURCE_DIR}/src/napi/adapter/js_native_api_adapter.cc"
  "${PRIMJS_SOURCE_DIR}/src/basic/log/primjs_logging.cc")
target_link_libraries(napi_jsc_finalizer_regression PRIVATE napi_static quickjs Threads::Threads ${CMAKE_DL_LIBS})
if(ENABLE_ASAN)
  target_compile_options(napi_jsc_finalizer_regression PRIVATE -fsanitize=address -fno-omit-frame-pointer)
  target_link_options(napi_jsc_finalizer_regression PRIVATE -fsanitize=address)
endif()
target_sources(napi_jsc_finalizer_regression PRIVATE "${PRIMJS_SOURCE_DIR}/src/napi/jsc/js_native_api_JavaScriptCore.cc")
if(APPLE)
  target_link_libraries(napi_jsc_finalizer_regression PRIVATE "-framework JavaScriptCore")
else()
  find_path(JSC_INCLUDE_DIR JavaScriptCore/JavaScript.h
            PATH_SUFFIXES webkitgtk-4.1 webkitgtk-4.0)
  find_library(JSC_LIBRARY NAMES javascriptcoregtk-4.1 javascriptcoregtk-4.0)
  if(NOT JSC_INCLUDE_DIR OR NOT JSC_LIBRARY)
    message(FATAL_ERROR "Provide JavaScriptCoreGTK headers and JSC_LIBRARY")
  endif()
  target_include_directories(napi_jsc_finalizer_regression PRIVATE "${JSC_INCLUDE_DIR}")
  target_link_libraries(napi_jsc_finalizer_regression PRIVATE "${JSC_LIBRARY}")
endif()
