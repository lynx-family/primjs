# @lynx-js/weak-node-api

A distribution package that provides a "weak-linked" Node-API implementation with symbol renaming, headers, and pre-built binaries. It is designed to be safely integrated into complex applications where multiple Node-API providers might coexist (e.g., in a host that also embeds Node.js).

This package is derived from the upstream `weak-node-api` project by Callstack, which itself is part of the `react-native-node-api` effort.

## Overview & Working Principle

On certain platforms like Android, the dynamic linker enforces strict symbol resolution. A native module must have its dependencies explicitly declared to access their symbols at runtime. This poses a challenge for Node-API addons that need to link against a host-provided implementation (like Hermes or a custom runtime) without creating a hard compile-time dependency.

`weak-node-api` solves this by providing:

1.  **A Weak-linked Interface**: It exposes the full Node-API function set but without any implementation. Instead, each function call is routed through a global function table (a `struct` of function pointers).
2.  **Runtime Injection**: The application host, which holds the *actual* Node-API implementation, is responsible for "injecting" its function table into this package at runtime. This populates the function pointers.
3.  **Symbol Renaming**: All `napi_*` functions and types are renamed with a `_weak` suffix (e.g., `napi_create_object` becomes `napi_create_object_weak`). This prevents symbol collisions if another standard Node-API implementation (like Node.js) is also present in the same process space. This is the primary modification introduced by this project compared to the upstream `weak-node-api` project.

This design allows native addons to link against a stable, intermediary interface without needing to know the details of the host's runtime environment.

## Installation and Usage

### Installation

```bash
npm install @lynx-js/weak-node-api
```

The package is available on NPM: [https://www.npmjs.com/package/@lynx-js/weak-node-api](https://www.npmjs.com/package/@lynx-js/weak-node-api)

### Node.js version

- **Consumers**: No `engines.node` restriction is published. Install/use the package with the Node.js version required by your own environment and tooling.
- **Maintainers**: Node.js >= 22 is required if you need to run the helper scripts that regenerate headers/sources (they rely on the upstream `weak-node-api` devDependency).

### Basic Usage

Your native addon can include the headers from this package and call the `_weak` suffixed functions.

```cpp
#include "node_api.h" // From this package, with weak symbols
#if defined(USE_WEAK_SUFFIX_NAPI)
#include "weak_napi_defines.h" // This header file defines macros for all weak symbols and must be included before using weak symbols/definitions
#endif

// Example native addon function
napi_value MyNativeFunction(napi_env env, napi_callback_info info) {
  napi_value world;
  napi_status status = napi_create_string_utf8(env, "world", NAPI_AUTO_LENGTH, &world);
  // Note: napi_create_string_utf8 is a macro that resolves to napi_create_string_utf8_weak
  return world;
}

#if defined(USE_WEAK_SUFFIX_NAPI)
#include "weak_napi_undefs.h" // This header file undefines all weak symbols and must be included at the end of the file
#endif
```

At runtime, the host application must call `inject_weak_node_api_host()` to provide the real implementation before any addons are loaded.

## Compile-time macro control

- By default, if `USE_WEAK_SUFFIX_NAPI` is **not** defined, the headers provided by this package do not rename any Node-API symbols and all `napi_*` APIs keep their original symbol names.
- When the `USE_WEAK_SUFFIX_NAPI` macro is defined at compile time, the renaming macros in `weak_napi_defines.h` / `weak_napi_undefs.h` become active and map all `napi_*` symbols to implementations with the `_weak` suffix (weak suffix symbol remapping).
- `USE_WEAK_SUFFIX_NAPI` acts as a compile-time gate: only when this macro is defined will the weak suffix symbol remapping scheme be applied.

### How to enable (examples)

- When invoking the compiler directly, add `-DUSE_WEAK_SUFFIX_NAPI` to your compile flags.
- In CMake, you can enable it via `add_compile_definitions(USE_WEAK_SUFFIX_NAPI)` or `target_compile_definitions(my_target PRIVATE USE_WEAK_SUFFIX_NAPI)`.

### Scope and recommendations

- Files under the `headers/` and `generated/` directories that are produced by `prepare-headers` and shipped with this package already contain conditional includes of `weak_napi_defines.h` / `weak_napi_undefs.h` guarded by `USE_WEAK_SUFFIX_NAPI`. As long as this macro is defined in your compile command, weak suffix symbol remapping will be enabled for those headers/sources.
- For translation units you author yourself (for example additional `.c` / `.cc` / `.cpp` files) that directly include this package's `node_api.h`, it is recommended to use the same `#if defined(USE_WEAK_SUFFIX_NAPI)` wrapping pattern as in the example above so that their behavior matches.

### Coexistence with other N-API Implementations

Because all symbols are renamed, your addon can be safely loaded into environments that have another Node-API provider. The weak symbols from this package will not conflict with the standard symbols. This is the primary motivation for this package.

## Directory Structure

After installation via npm, the package contains the following key directories and files:

-   `headers/`: Public C/C++ headers for consumption. This includes the renamed `node_api.h` and the C++ wrapper `node-addon-api`.
-   `generated/`: Upstream-generated source files (`weak_node_api.cpp`, `NodeApiHost.hpp`).
-   `prebuilt/`: Pre-compiled binaries for supported platforms and architectures.
-   `prebuilt/macos/debug/libweak-node-api.dylib` and `prebuilt/macos/release/libweak-node-api.dylib`: macOS universal shared libraries (arm64 + x86_64).
-   `licenses/`: Directory containing the full license texts of all third-party dependencies.
    -   `licenses/weak-node-api.MIT`
    -   `licenses/node-addon-api.MIT`
    -   `licenses/node-api-headers.MIT`
-   `weak-node-api-config.cmake`: A CMake configuration file to help downstream projects find and link against this package.
-   `LICENSE`: The main license for this package (Apache-2.0).
-   `NOTICE`: Copyright and attribution notice for The Lynx Authors.
-   `THIRD-PARTY-NOTICES.md`: Detailed notices for all bundled third-party software.

## License and Compliance

This package is licensed under the **Apache License 2.0**.

It incorporates code from the following upstream projects, which are licensed under the **MIT License**:

1.  **weak-node-api**: From `callstackincubator/react-native-node-api`.
2.  **node-addon-api**: From `nodejs/node-addon-api`.
3.  **Node-API C headers (node-api-headers)**: From `nodejs/node-api-headers`.

We adhere to the following compliance standards:
-   The full text of the Apache-2.0 license is in the `LICENSE` file.
-   A `NOTICE` file is included with the copyright statement for The Lynx Authors.
-   `THIRD-PARTY-NOTICES.md` provides detailed attribution for all included third-party software.
-   The `licenses/` directory contains the full license texts for all MIT-licensed components.

Even when distributing only the binary artifacts, you must retain and distribute the `LICENSE`, `NOTICE`, and `THIRD-PARTY-NOTICES.md` files, along with the `licenses/` directory.


## Windows Build

On Windows you can use Visual Studio 2022 (MSVC) and CMake to build the `WeakNodeAPI.dll` dynamic library and its import library `WeakNodeAPI.lib`.

### Toolchain Requirements

- **Visual Studio 2022**: Install the "Desktop development with C++" workload.
- **CMake**: Version >= 3.24, and make sure `cmake.exe` is available on the `PATH`.
- **Node.js**: Version >= 22, required to run the helper scripts used during development/build.
- **Architecture**: Only x64 is supported.

### Local Build

From the `oss/` directory you can trigger the Windows build via npm scripts. The script will build both Debug and Release configurations and package the results into the `prebuilt/` layout.

```bash
# From the oss/ directory
# This calls tools/cmake/build_windows_msvc.ps1 via the npm script
npm run build:release:win
```

### Artifacts and Paths

After a successful build, you should find the following artifacts under `prebuilt/`. In addition to the DLL, prebuilt packaging always includes `WeakNodeAPI.exp` for both Debug and Release, and includes `WeakNodeAPI.pdb` for Debug builds. The import library `WeakNodeAPI.lib` is packaged when available but is not required.

-   **Default layout**:
    -   `prebuilt/win/x64/Debug/WeakNodeAPI.dll`
    -   `prebuilt/win/x64/Debug/WeakNodeAPI.exp`
    -   `prebuilt/win/x64/Debug/WeakNodeAPI.pdb`
    -   `prebuilt/win/x64/Debug/WeakNodeAPI.lib` (optional)
    -   `prebuilt/win/x64/Release/WeakNodeAPI.dll`
    -   `prebuilt/win/x64/Release/WeakNodeAPI.exp`
    -   `prebuilt/win/x64/Release/WeakNodeAPI.lib` (optional)
-   **`weak_suffix` layout**:
    -   `prebuilt/win/weak_suffix/x64/Debug/WeakNodeAPI.dll`
    -   `prebuilt/win/weak_suffix/x64/Debug/WeakNodeAPI.exp`
    -   `prebuilt/win/weak_suffix/x64/Debug/WeakNodeAPI.pdb`
    -   `prebuilt/win/weak_suffix/x64/Debug/WeakNodeAPI.lib` (optional)
    -   `prebuilt/win/weak_suffix/x64/Release/WeakNodeAPI.dll`
    -   `prebuilt/win/weak_suffix/x64/Release/WeakNodeAPI.exp`
    -   `prebuilt/win/weak_suffix/x64/Release/WeakNodeAPI.lib` (optional)

### Troubleshooting

- **CMake configuration fails**:
  - Ensure Visual Studio 2022 with the C++ desktop workload is fully installed.
  - Verify that `cmake.exe` is on the `PATH` and that the version meets the minimum requirement.
- **"npm" or "node" command not found**:
  - Ensure Node.js is installed and its installation directory is added to the `PATH`.
- **Build errors**:
  - First verify that `npm run prepare:headers` completes successfully.
  - Check that the C++ toolchain is intact and not blocked by antivirus or security software.
