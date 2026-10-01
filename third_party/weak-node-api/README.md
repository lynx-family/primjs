# @lynx-js/weak-node-api

A distribution package that provides a "weak-linked" Node-API implementation with symbol renaming, headers, and pre-built binaries. It is designed to be safely integrated into complex applications where multiple Node-API providers might coexist (e.g., in a host that also embeds Node.js).

This package is derived from the upstream `weak-node-api` project by Callstack, which itself is part of the `react-native-node-api` effort.

## Overview & Working Principle

On certain platforms like Android, the dynamic linker enforces strict symbol resolution. A native module must have its dependencies explicitly declared to access their symbols at runtime. This poses a challenge for Node-API addons that need to link against a host-provided implementation (like Hermes or a custom runtime) without creating a hard compile-time dependency.

`weak-node-api` solves this by providing:

1.  **A Weak-linked Interface**: It exposes the full Node-API function set but without any implementation. Instead, each function call is routed through a global function table (a `struct` of function pointers).
2.  **Runtime Injection**: The application host, which holds the *actual* Node-API implementation, is responsible for "injecting" its function table into this package at runtime. This populates the function pointers.
3.  **Symbol Renaming**: All `napi_*` functions and types are renamed with a `_weak` suffix (e.g., `napi_create_object` becomes `napi_create_object_weak`). This prevents symbol collisions if another standard Node-API implementation (like Node.js) is also present in the same process space.

This design allows native addons to link against a stable, intermediary interface without needing to know the details of the host's runtime environment.

## Installation and Usage

### Installation

```bash
npm i @lynx-js/weak-node-api
```

### Basic Usage

Your native addon can include the headers from this package and call the `_weak` suffixed functions.

```cpp
#include <node_api.h> // From this package, with weak symbols

// Example native addon function
napi_value MyNativeFunction(napi_env env, napi_callback_info info) {
  napi_value world;
  napi_status status = napi_create_string_utf8(env, "world", NAPI_AUTO_LENGTH, &world);
  // Note: napi_create_string_utf8 is a macro that resolves to napi_create_string_utf8_weak
  return world;
}
```

At runtime, the host application must call `inject_weak_node_api_host()` to provide the real implementation before any addons are loaded.

### Coexistence with other N-API Implementations

Because all symbols are renamed, your addon can be safely loaded into environments that have another Node-API provider. The weak symbols from this package will not conflict with the standard symbols. This is the primary motivation for this package.

## Directory Structure

After installation via npm, the package contains the following key directories and files:

-   `include/`: Public C/C++ headers for consumption. This includes the renamed `node_api.h` and the C++ wrapper `node-addon-api`.
-   `generated/`: Upstream-generated source files (`weak_node_api.cpp`, `NodeApiHost.hpp`).
-   `prebuilds/`: Pre-compiled binaries for various platforms and architectures.
    -   `prebuilds/<platform-arch>/`: Platform-specific binaries (e.g., `.node`, `.so`, `.dll`).
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
