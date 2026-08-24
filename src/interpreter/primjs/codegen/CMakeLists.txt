# Copyright 2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

# cd llvm-project cmake -S llvm -B build -DCMAKE_BUILD_TYPE=Release cmake
# --build build -j8
set(LLVM_PATH_BUILD ${LLVM_PATH}/build)
set(LLVM_CONFIG ${LLVM_PATH_BUILD}/bin/llvm-config)

if(NOT EXISTS "${LLVM_CONFIG}")
  message(FATAL_ERROR "llvm-config not found at ${LLVM_CONFIG}")
endif()

function(run_llvm_config output_variable)
  execute_process(
    COMMAND "${LLVM_CONFIG}" ${ARGN}
    OUTPUT_VARIABLE ${output_variable}
    RESULT_VARIABLE LLVM_CONFIG_RESULT
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  if(NOT LLVM_CONFIG_RESULT EQUAL 0)
    message(FATAL_ERROR "llvm-config ${ARGN} failed with ${LLVM_CONFIG_RESULT}")
  endif()

  set(${output_variable}
      "${${output_variable}}"
      PARENT_SCOPE)
endfunction()

run_llvm_config(LLVM_INCLUDE_DIR --includedir)
run_llvm_config(LLVM_LIB_DIR --libdir)

run_llvm_config(
  LLVM_LIBS
  --libs
  core
  passes
  aggressiveinstcombine
  analysis
  binaryformat
  support
  demangle
  remarks
  bitstreamreader
  object
  bitreader
  mc
  debuginfocodeview
  debuginfomsf
  mcparser
  textapi
  profiledata
  transformutils
  coroutines
  ipo
  bitwriter
  frontendopenmp
  instcombine
  irreader
  asmparser
  linker
  scalaropts
  vectorize
  instrumentation
  objcarcopts
  target
  targetparser)

run_llvm_config(LLVM_SYSTEM_LIBS --system-libs)

separate_arguments(LLVM_LIBS UNIX_COMMAND "${LLVM_LIBS}")
separate_arguments(LLVM_SYSTEM_LIBS UNIX_COMMAND "${LLVM_SYSTEM_LIBS}")

set(RESOLVED_LLVM_SYSTEM_LIBS)
foreach(LLVM_SYSTEM_LIB IN LISTS LLVM_SYSTEM_LIBS)
  if(LLVM_SYSTEM_LIB STREQUAL "-lzstd")
    find_library(
      LLVM_ZSTD_LIBRARY
      NAMES zstd
      HINTS ENV ZSTD_ROOT ENV HOMEBREW_PREFIX
      PATH_SUFFIXES lib
      PATHS /opt/homebrew /usr/local /opt/homebrew/opt/zstd /usr/local/opt/zstd)

    if(NOT LLVM_ZSTD_LIBRARY)
      message(
        FATAL_ERROR
          "llvm-config requires zstd (-lzstd), but libzstd was not found. "
          "Install zstd or set ZSTD_ROOT/CMAKE_PREFIX_PATH.")
    endif()

    list(APPEND RESOLVED_LLVM_SYSTEM_LIBS "${LLVM_ZSTD_LIBRARY}")
  else()
    list(APPEND RESOLVED_LLVM_SYSTEM_LIBS "${LLVM_SYSTEM_LIB}")
  endif()
endforeach()
set(LLVM_SYSTEM_LIBS "${RESOLVED_LLVM_SYSTEM_LIBS}")

set(PRIMJS_ROOT_DIR ${VM_ROOT_DIR}/src/interpreter/primjs)

include_directories(${VM_ROOT_DIR}/src ${VM_ROOT_DIR}/src/interpreter
                    ${LLVM_INCLUDE_DIR} ${LLVM_PATH_BUILD}/include)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

file(GLOB PRIMJS_SRC "${PRIMJS_ROOT_DIR}/base/*.cc"
     "${PRIMJS_ROOT_DIR}/codegen/*.cc" "${PRIMJS_ROOT_DIR}/son/*.cc")

add_executable(vm_codegen ${PRIMJS_SRC})

# vm_codegen always emits AArch64 handlers, even when built on an x86_64 host.
target_compile_definitions(vm_codegen PRIVATE __aarch64__)

target_compile_options(
  vm_codegen
  PRIVATE -Wall
          -Werror
          -Wno-unused-parameter
          -Wno-unused-function
          -Wno-unused-variable
          -Wno-invalid-constexpr
          -O0
          -g)

target_link_directories(vm_codegen PRIVATE ${LLVM_LIB_DIR})

target_link_libraries(vm_codegen PRIVATE ${LLVM_LIBS} ${LLVM_SYSTEM_LIBS})

install(TARGETS vm_codegen RUNTIME DESTINATION bin)
