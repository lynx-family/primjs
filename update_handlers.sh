# Copyright 2025 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

#! /bin/bash
LLVM_PATH="$1"

if [ ! -d "$LLVM_PATH" ]; then
    echo "Error: llvm Path '$LLVM_PATH' is not exist."
    exit 1
fi

if [ ! -f "$LLVM_PATH/build/bin/llc" ]; then
    echo "Error: '$LLVM_PATH/build/bin/llc' is not found."
    exit 1
fi

cmake -S . -Bbuild -DENABLE_UNITTESTS=ON -DENABLE_LEPUSNG=ON -DENABLE_VIRTUAL_SP=ON -DENABLE_PRIMJS_SNAPSHOT=ON -DLLVM_PATH=$LLVM_PATH
cmake --build ./build -t vm_codegen
./build/bin/vm_codegen -multi-table -virtual-sp primjs
"$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-apple-darwin -o ./src/interpreter/primjs/interp/mac/embedded.S primjs.ll

{
    echo "#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && !defined(ENABLE_QUICKJS_DEBUGGER)"
    "$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-apple-ios -o -  primjs.ll
    echo "#endif"
} > ./src/interpreter/primjs/interp/ios/embedded.S

# debugger
cmake -S . -Bbuild -DENABLE_UNITTESTS=ON -DENABLE_LEPUSNG=ON -DENABLE_VIRTUAL_SP=ON -DENABLE_PRIMJS_SNAPSHOT=ON -DENABLE_QUICKJS_DEBUGGER=ON -DLLVM_PATH=$LLVM_PATH
cmake --build ./build -t vm_codegen

./build/bin/vm_codegen -multi-table -debugger -virtual-sp primjs
"$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-apple-darwin -o ./src/interpreter/primjs/interp/mac/embedded-inspector.S primjs.ll

{
    echo "#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && defined(ENABLE_QUICKJS_DEBUGGER)"
    "$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-apple-ios -o -  primjs.ll
    echo "#endif"
} > ./src/interpreter/primjs/interp/ios/embedded-inspector.S

cmake -S . -Bbuild -DENABLE_UNITTESTS=ON -DENABLE_LEPUSNG=ON -DENABLE_VIRTUAL_SP=OFF -DENABLE_PRIMJS_SNAPSHOT=ON -DLLVM_PATH=$LLVM_PATH
cmake --build ./build -t vm_codegen

./build/bin/vm_codegen -multi-table primjs
"$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-unknown-linux-gn -o ./src/interpreter/primjs/interp/android/embedded.S primjs.ll

cmake -S . -Bbuild -DENABLE_UNITTESTS=ON-DENABLE_LEPUSNG=ON -DENABLE_VIRTUAL_SP=OFF -DENABLE_QUICKJS_DEBUGGER=ON -DENABLE_PRIMJS_SNAPSHOT=ON -DLLVM_PATH=$LLVM_PATH
cmake --build ./build -t vm_codegen
./build/bin/vm_codegen -multi-table -debugger primjs

"$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-unknown-linux-gn -o ./src/interpreter/primjs/interp/android/embedded-inspector.S primjs.ll