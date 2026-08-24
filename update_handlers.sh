#! /bin/bash

# Copyright 2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

set -e

EMBEDDED_CONDITION="#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && !defined(ENABLE_QUICKJS_DEBUGGER)"
INSPECTOR_CONDITION="#if defined(__aarch64__) && defined(ENABLE_PRIMJS_SNAPSHOT) && defined(ENABLE_QUICKJS_DEBUGGER)"

wrap_generated_assembly() {
    local assembly_file="$1"
    local condition
    local tmp_file

    case "$(basename "$assembly_file")" in
        embedded.S)
            condition="$EMBEDDED_CONDITION"
            ;;
        embedded-inspector.S)
            condition="$INSPECTOR_CONDITION"
            ;;
        *)
            echo "Error: unsupported assembly file '$assembly_file'"
            return 1
            ;;
    esac

    tmp_file="$(mktemp "${assembly_file}.XXXXXX")"
    {
        echo "$condition"
        cat "$assembly_file"
        echo "#endif"
    } > "$tmp_file"
    mv "$tmp_file" "$assembly_file"
}

if [ "${UPDATE_HANDLERS_TESTING:-}" = "1" ]; then
    return 0 2>/dev/null || exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"

# Check whether the LLVM path argument is provided.
if [ $# -eq 0 ]; then
    echo "Usage: $0 <llvm_path>"
    echo "Example: $0 /Users/Documents/worktree/llvm-project/"
    echo "Default path example: $0 /Users/Documents/worktree/llvm-project/"
    exit 1
fi

LLVM_PATH="$1"

# Check whether the LLVM path exists.
if [ ! -d "$LLVM_PATH" ]; then
    echo "Error: LLVM path '$LLVM_PATH' does not exist"
    exit 1
fi

LLVM_PATH="$(cd "$LLVM_PATH" && pwd -P)"

# Check whether the llc tool exists.
if [ ! -f "$LLVM_PATH/build/bin/llc" ]; then
    echo "Error: llc tool not found at '$LLVM_PATH/build/bin/llc'"
    exit 1
fi

echo "Using LLVM path: $LLVM_PATH"

cd "$SCRIPT_DIR"

CC=clang CXX=clang++ cmake -S . -Bbuild -DENABLE_UNITTESTS=ON -DENABLE_LEPUSNG=ON -DENABLE_GEN_EMBEDDED=ON -DLLVM_PATH="$LLVM_PATH"
cmake --build ./build --target vm_codegen --parallel "${BUILD_JOBS:-8}"
./build/bin/vm_codegen -multi-table -virtual-sp primjs
"$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-apple-darwin -o ./src/interpreter/primjs/interp/mac/embedded.S primjs.ll
wrap_generated_assembly ./src/interpreter/primjs/interp/mac/embedded.S

./build/bin/vm_codegen -multi-table -debugger -virtual-sp primjs
"$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-apple-darwin -o ./src/interpreter/primjs/interp/mac/embedded-inspector.S primjs.ll
wrap_generated_assembly ./src/interpreter/primjs/interp/mac/embedded-inspector.S

./build/bin/vm_codegen -multi-table -virtual-sp primjs
"$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-apple-ios -o ./src/interpreter/primjs/interp/ios/embedded.S primjs.ll
wrap_generated_assembly ./src/interpreter/primjs/interp/ios/embedded.S

./build/bin/vm_codegen -multi-table -debugger -virtual-sp primjs
"$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-apple-ios -o ./src/interpreter/primjs/interp/ios/embedded-inspector.S primjs.ll
wrap_generated_assembly ./src/interpreter/primjs/interp/ios/embedded-inspector.S

./build/bin/vm_codegen -multi-table primjs
"$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-unknown-linux-gn -o ./src/interpreter/primjs/interp/android/embedded.S primjs.ll
wrap_generated_assembly ./src/interpreter/primjs/interp/android/embedded.S

./build/bin/vm_codegen -multi-table -debugger primjs
"$LLVM_PATH/build/bin/llc" -O3 -mtriple=aarch64-unknown-linux-gn -o ./src/interpreter/primjs/interp/android/embedded-inspector.S primjs.ll
wrap_generated_assembly ./src/interpreter/primjs/interp/android/embedded-inspector.S
