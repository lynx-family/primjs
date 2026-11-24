# Regenerating PrimJS Bytecode Handlers

Pre-generated AArch64 interpreter assembly files (`src/interpreter/primjs/interp/{android,ios,mac}/embedded*.S`) are committed directly to the repository, so normal PrimJS builds do **not** require building LLVM.

You only need to regenerate these files when modifying:
- Bytecode definitions or handler logic under `src/interpreter/primjs/codegen/` or `src/interpreter/primjs/son/`
- Runtime struct layouts or bitfields verified by `src/interpreter/primjs/codegen/accessBuilder.h` and `src/interpreter/primjs/codegen/setup.cc`

## 1. Fetch and Patch LLVM

Handler generation (`vm_codegen` and `llc`) depends on a pinned upstream LLVM revision with a small patch (`src/interpreter/primjs/interp/llvm.diff`) that adds the custom AArch64 calling conventions (`primjs_to_interpreter` and `primjs_code_stub`).

- **Repository**: `https://github.com/llvm/llvm-project.git`
- **Commit**: `953302eb98569c7c107d1c8b820948466a404cbe`
- **Patch**: `src/interpreter/primjs/interp/llvm.diff`

Fetch the pinned commit and apply the patch:

```bash
git init llvm-project
cd llvm-project
git remote add origin https://github.com/llvm/llvm-project.git
git fetch --depth 1 origin 953302eb98569c7c107d1c8b820948466a404cbe
git checkout FETCH_HEAD

# Apply the PrimJS calling convention patch
git apply /path/to/primjs/src/interpreter/primjs/interp/llvm.diff
```

## 2. Build LLVM

`update_handlers.sh` expects the LLVM build output in `<llvm_path>/build` (specifically `build/bin/llc`, `build/bin/llvm-config`, and the static LLVM component libraries). Only the `AArch64` target needs to be enabled, and optional compression/terminal dependencies can be disabled:

```bash
cmake -S llvm -B build \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_TARGETS_TO_BUILD="AArch64" \
  -DLLVM_ENABLE_PROJECTS="" \
  -DLLVM_BUILD_TOOLS=OFF \
  -DLLVM_INCLUDE_BENCHMARKS=OFF \
  -DLLVM_INCLUDE_EXAMPLES=OFF \
  -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_INCLUDE_DOCS=OFF \
  -DLLVM_ENABLE_ZSTD=OFF \
  -DLLVM_ENABLE_ZLIB=OFF \
  -DLLVM_ENABLE_TERMINFO=OFF

cmake --build build --target all llc llvm-config --parallel 8
```

*(Tip: Add `-G Ninja` to the first `cmake` command if `ninja` is installed for faster builds.)*

## 3. Run `update_handlers.sh`

From the root of the PrimJS repository, pass the path to `llvm-project`:

```bash
cd /path/to/primjs
./update_handlers.sh /path/to/llvm-project
```

This builds `vm_codegen` (both normal and debugger-enabled variants) and invokes `llc` to update all six assembly files:
- `src/interpreter/primjs/interp/mac/embedded.S`
- `src/interpreter/primjs/interp/mac/embedded-inspector.S`
- `src/interpreter/primjs/interp/ios/embedded.S`
- `src/interpreter/primjs/interp/ios/embedded-inspector.S`
- `src/interpreter/primjs/interp/android/embedded.S`
- `src/interpreter/primjs/interp/android/embedded-inspector.S`
