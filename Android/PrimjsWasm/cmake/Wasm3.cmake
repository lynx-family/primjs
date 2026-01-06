# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

set(Wasm3_FOUND false)

option(BUILD_LOCAL "set the source code to build" ON)

set(WASM_ANDROID_ROOT ${CMAKE_CURRENT_LIST_DIR}/..)
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DWASM_DEBUG=1")

get_filename_component(WASM3_ROOT "${WASM_ANDROID_ROOT}/../../third_party/wasm3" ABSOLUTE)
message(STATUS "Using local wasm3 at ${WASM3_ROOT}")

#########################################################################
# buildconfig from ${M3_HOME}/platforms/android/app/src/main/cpp
set(WASM3_ANDROID_SRC_DIR ${WASM3_ROOT}/source)

# Handle wasm3/wasm3.h include issue
set(WASM3_HEADER_ALIAS_DIR ${CMAKE_CURRENT_BINARY_DIR}/wasm3_headers)
file(MAKE_DIRECTORY ${WASM3_HEADER_ALIAS_DIR})
# Create symlink: ${WASM3_HEADER_ALIAS_DIR}/wasm3 -> ${WASM3_ANDROID_SRC_DIR}
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${WASM3_ANDROID_SRC_DIR} ${WASM3_HEADER_ALIAS_DIR}/wasm3)
set(WASM3_HEADER_DIR ${WASM3_HEADER_ALIAS_DIR})

add_definitions(-DANDROID -Wno-format-security)
if (CMAKE_BUILD_TYPE MATCHES "Debug")
  add_definitions(-O0)
else () # Release
  add_definitions(-O3 -flto -fomit-frame-pointer -fno-stack-check -fno-stack-protector)
  #-fno-optimize-sibling-calls)
endif ()

# file(GLOB M3_SRC FOLLOW_SYMLINKS "${WASM3_ANDROID_SRC_DIR}/*.c" "*.c")
set(M3_SRC
    "${WASM3_ANDROID_SRC_DIR}/extensions/m3_extensions.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_api_libc.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_api_meta_wasi.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_api_tracer.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_api_uvwasi.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_api_wasi.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_bind.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_code.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_compile.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_core.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_env.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_exec.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_function.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_info.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_module.c"
    "${WASM3_ANDROID_SRC_DIR}/m3_parse.c"
    )
message("WASM3_ANDROID_SRC_DIR ${M3_SRC}")
add_library(wasm3_engine_lib STATIC ${M3_SRC})

# set_target_properties(wasm3_engine_lib PROPERTIES LINK_FLAGS "-flto -O3")
target_include_directories(wasm3_engine_lib PUBLIC ${WASM3_HEADER_DIR} ${WASM3_ANDROID_SRC_DIR})
set_target_properties(wasm3_engine_lib PROPERTIES LINKER_LANGUAGE CXX)
set_target_properties(wasm3_engine_lib PROPERTIES OUTPUT_NAME wasm3)
set(wasm3_include ${WASM3_HEADER_DIR})

set(Wasm3_FOUND true)
