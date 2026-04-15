# __PROJECT_NAME__ (AI Guide)

## What this project is

This repository is a CMake-based N-API addon project scaffolded by `@lynx-js/weak-node-api`.

## Quick start

```bash
npm install
cmake -S . -B build
cmake --build build --config Release
```

## Output naming

- Android/HarmonyOS: `lib<project>.so`
- iOS/macOS: `<project>.node`

## Editing addon code

- Implement your N-API logic in `src/addon.cc`.
- If you enable `USE_WEAK_SUFFIX_NAPI`, follow the per-translation-unit include convention:
  - include `weak_napi_defines.h` after the last include
  - include `weak_napi_undefs.h` at the end of the file

## Platform linking strategy

- Android: the build downloads the AAR and extracts `vendor/android/libnapi_adapter.so`, then links it.
- HarmonyOS: the build downloads the HAR and extracts `vendor/harmony/libnapi_adapter.so`, then links it.
- iOS/macOS: no dynamic library is linked; symbols are resolved dynamically by the host (e.g. `-Wl,-undefined,dynamic_lookup`).

## Toolchains (cross compilation)

Cross-compilation is controlled by the CMake toolchain/generator you choose when configuring the build directory.
See README.md for command examples.
