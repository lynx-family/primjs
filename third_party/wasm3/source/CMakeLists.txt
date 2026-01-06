# Copyright © 2019 Volodymyr Shymanskyy. All rights reserved.
#
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

cmake_minimum_required(VERSION 3.1)
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(sources
    "m3_api_libc.c"
    "m3_api_wasi.c"
    "m3_api_uvwasi.c"
    "m3_api_meta_wasi.c"
    "m3_api_tracer.c"
    "m3_bind.c"
    "m3_code.c"
    "m3_compile.c"
    "m3_core.c"
    "m3_env.c"
    "m3_exec.c"
    "m3_function.c"
    "m3_info.c"
    "m3_module.c"
    "m3_parse.c"
)

add_library(m3 STATIC ${sources})

target_include_directories(m3 PUBLIC .)

set(extension_src
    "extensions/m3_extensions.c")
add_library(m3_ext STATIC ${extension_src})
target_include_directories(m3_ext PUBLIC . ./extensions)

if (CMAKE_C_COMPILER_ID MATCHES "MSVC")
    # add MSVC specific flags here
else()
    # Flags common for GCC and Clang


    # FIXME: comparison of integers of different signs: 'u32' and 'i32'
    set_source_files_properties(m3_env.c PROPERTIES COMPILE_FLAGS -Wno-sign-compare)

    if (WASIENV)
        # FIXME: declaration of 'struct sigaction' will not be visible outside of this function
        target_compile_options(m3 PUBLIC -Wno-visibility)
        # FIXME incompatible pointer types passing 'u32 *' to parameter of type 'char **'
        set_source_files_properties(m3_api_meta_wasi.c PROPERTIES COMPILE_FLAGS -Wno-incompatible-pointer-types)
    endif()

    if (CMAKE_C_COMPILER_ID MATCHES "Clang")
        # Clang specific flags here
    else()
        # GCC specific flags here
    endif()
endif()

if(BUILD_WASI MATCHES "simple")
    target_compile_definitions(m3 PUBLIC d_m3HasWASI)
elseif(BUILD_WASI MATCHES "metawasi")
    target_compile_definitions(m3 PUBLIC d_m3HasMetaWASI)
elseif(BUILD_WASI MATCHES "uvwasi")
    target_compile_definitions(m3 PUBLIC d_m3HasUVWASI)
    include_directories("${libuv_SOURCE_DIR}/include")
endif()

# <Primjs begin>
# install the static library and header files
set_target_properties (m3 PROPERTIES OUTPUT_NAME wasm3)
install (TARGETS m3 ARCHIVE DESTINATION lib)
install (FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_api_libc.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_api_tracer.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_api_wasi.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_bind.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_code.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_compile.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_config.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_config_platforms.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_core.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_env.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_exception.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_exec.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_exec_defs.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_function.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_info.h
    ${CMAKE_CURRENT_SOURCE_DIR}/m3_math_utils.h
    ${CMAKE_CURRENT_SOURCE_DIR}/wasm3.h
    ${CMAKE_CURRENT_SOURCE_DIR}/wasm3_defs.h
    DESTINATION include/wasm3)
# <Primjs end>