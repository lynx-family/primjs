# UPSTREAM

This package is closely related to the open-source project "React Native Node API" published by Callstack Incubator.

- Upstream project: https://github.com/callstackincubator/react-native-node-api
- Upstream npm package: `weak-node-api` (https://www.npmjs.com/package/weak-node-api)
- License: MIT
- Upstream version used for derivations: weak-node-api@0.0.3 (tracked via devDependency in package.json)

## Motivation

Lynx integrates Node-API based native add-ons into runtimes. To reduce friction and avoid symbol collisions when embedding Node-API headers into larger native projects, we provide:

- A ready-to-publish set of derived headers and sources (from upstream generator outputs),
- A symbol renaming scheme via weak macro wrappers,
- GN and CMake build integration for downstream consumption,
- Optional prebuilt binaries for macOS (framework) and Windows (dynamic library).

## Key Changes vs Upstream

- Symbol renaming:
  - Introduced `weak_napi_defines.h` and `weak_napi_undefs.h` macro wrappers to minimize symbol collisions in complex native build graphs.

- Build system integration:
  - Added `BUILD.gn` and `tools/gn` scripts to support GN consumers.
  - Shipped `CMakeLists.txt` and `tools/cmake` scripts to build a macOS framework target easily.

- Binary publishing:
  - macOS: debug and release frameworks packaged under `prebuilt/`.
  - Windows: intended dynamic libraries and headers for debug/release distribution.

- Header consolidation:
  - Merged selected Node-Addon-API headers into `include/` for downstream consumers.
  - Adjusted include paths and appended weak macro wrappers across relevant files.

## Usage Overview

- Source-based integration:
  - Use `BUILD.gn` or `CMakeLists.txt` to reference `generated/*` sources and `include/*` headers in your native project.

- Prebuilt consumption:
  - On macOS, consume the published framework and headers to avoid local compilation.
  - On Windows, link against the published dynamic library and use the provided headers.

## Attribution & License

- This package is licensed under the Apache License 2.0. See LICENSE.
- Upstream components are licensed under MIT. See THIRD-PARTY-NOTICES.md and upstream LICENSE files.
- The macro headers under `defs_header/` carry Apache-2.0 license notices retained as-is.

## Links

- Upstream repository: https://github.com/callstackincubator/react-native-node-api
- Node-Addon-API: https://github.com/node-addon-api/node-addon-api
- Node-API C headers (node-api-headers): https://github.com/nodejs/node-api-headers
- Node-API (N-API): https://nodejs.org/api/n-api.html
