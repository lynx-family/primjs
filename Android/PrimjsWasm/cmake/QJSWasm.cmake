# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

set(QJSWasm_FOUND false)

option(BUILD_LOCAL "set the source code to build" ON)

set(WASM_ANDROID_ROOT ${CMAKE_CURRENT_LIST_DIR}/..)
set(PRIMJS_ROOT ${WASM_ANDROID_ROOT}/../../)

# import libquick.so
include(Quickjs)
if(NOT Quickjs_FOUND)
  message(FATAL_ERROR "can not find module Quickjs!")
endif()

include(${PRIMJS_ROOT}/src/wasm/JSBWasm.cmake)

add_library(js_wasm_binding STATIC ${QJS_WASM3_SOURCES} ${QJS_PRISM_SOURCES}
            ${PRIMJS_ROOT}/src/wasm/prism/prism_dummy.cc)

target_include_directories(
  js_wasm_binding
  PUBLIC ${PRIMJS_ROOT}/src/wasm ${PRIMJS_ROOT}
         ${PRIMJS_ROOT}/src/ ${PRIMJS_ROOT}/src/interpreter
         ${PRIMJS_ROOT}/src/wasm/include)
target_link_libraries(js_wasm_binding quickjs-lib)

set(QJSWasm_FOUND true)
