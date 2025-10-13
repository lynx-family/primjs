# Copyright 2025 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

# cd llvm-project
# cmake -S llvm -B build -DCMAKE_BUILD_TYPE=Release
# cmake --build build -j8
set (LLVM_PATH_BUILD ${LLVM_PATH}/build)

set (PRIMJS_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/..)

include_directories(
  ${PRIMJS_ROOT_DIR}/src
  ${PRIMJS_ROOT_DIR}/src/interpreter
  ${PRIMJS_ROOT_DIR}/
  ${PRIMJS_ROOT_DIR}/src/interpreter
  ${LLVM_PATH}/llvm/include
  ${LLVM_PATH_BUILD}/include)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

file(GLOB PRIMJS_SRC
  "${PRIMJS_ROOT_DIR}/base/*.cc"
  "${PRIMJS_ROOT_DIR}/codegen/*.cc"
  "${PRIMJS_ROOT_DIR}/son/*.cc"
)

add_executable(vm_codegen
  ${PRIMJS_SRC}
)

target_compile_options(vm_codegen
  PRIVATE
  -Wall
  -Werror
  -Wno-unused-parameter
  -Wno-unused-function
  -Wno-unused-variable
  -Wno-invalid-constexpr
  -O0
  -g
)

target_link_directories(vm_codegen PRIVATE ${LLVM_PATH_BUILD}/lib)

target_link_libraries(vm_codegen PRIVATE

  LLVMDebugInfoDWARF
  LLVMPasses
  LLVMAggressiveInstCombine
  LLVMAnalysis
  LLVMBinaryFormat
  LLVMSupport
  LLVMDemangle
  LLVMCore
  LLVMRemarks
  LLVMBitstreamReader
  LLVMObject
  LLVMBitReader
  LLVMMC
  LLVMDebugInfoCodeView
  LLVMDebugInfoMSF
  LLVMMCParser
  LLVMTextAPI
  LLVMProfileData
  LLVMTransformUtils
  LLVMCoroutines
  LLVMipo
  LLVMBitWriter
  LLVMFrontendOpenMP
  LLVMInstCombine
  LLVMIRReader
  LLVMAsmParser
  LLVMLinker
  LLVMScalarOpts
  LLVMVectorize
  LLVMInstrumentation
  LLVMObjCARCOpts
  LLVMTarget
  LLVMTargetParser
)

install(TARGETS vm_codegen
  RUNTIME DESTINATION bin
)

# add_custom_command(
#   OUTPUT ${RTSVM_SRC_DIR}/vm/interpreter/bsd_aarch64/handler.S
#   COMMAND ${CMAKE_BINARY_DIR}/bin/vm_codegen primjs
#   COMMAND ${LLVM_PATH_BUILD}/bin/llc -O3 -mtriple=aarch64-apple-darwin
#     -o ${RTSVM_SRC_DIR}/vm/interpreter/bsd_aarch64/handler.S
#     ${CMAKE_BINARY_DIR}/src/primjs/codegen/primjs.ll
#   COMMAND ${LLVM_PATH_BUILD}/bin/llc -O3 -mtriple=aarch64-unknown-linux-gnu
#     -o ${RTSVM_SRC_DIR}/vm/interpreter/linux_aarch64/handler.S
#     ${CMAKE_BINARY_DIR}/src/primjs/codegen/primjs.ll
#   COMMAND ${LLVM_PATH_BUILD}/bin/llc -O3 -mtriple=arm-unknown-linux-gnu
#     -o ${RTSVM_SRC_DIR}/vm/interpreter/linux_arm32/handler.S
#     ${CMAKE_BINARY_DIR}/src/primjs/codegen/primjs.ll
#   COMMENT "gen-primjs-ll"
#     DEPENDS
#       ${CMAKE_BINARY_DIR}/bin/vm_codegen
# )

# add_custom_target(gen_vm_code ALL DEPENDS ${CMAKE_BINARY_DIR}/bin/vm_codegen)