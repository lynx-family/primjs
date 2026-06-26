# UPSTREAM

This package is closely related to the open-source project "React Native Node API" published by Callstack Incubator.

- Upstream project: https://github.com/callstackincubator/react-native-node-api
- Upstream npm package: `weak-node-api` (https://www.npmjs.com/package/weak-node-api)
- License: MIT
- Upstream version used for derivations: weak-node-api@0.1.1 (tracked via devDependency in package.json)

## Motivation

Lynx integrates Node-API based native add-ons into runtimes. To reduce friction and avoid symbol collisions when embedding Node-API headers into larger native projects, we provide:

- A ready-to-publish set of derived headers and sources (from upstream generator outputs),
- A symbol renaming scheme via weak macro wrappers,
- CMake integration for downstream consumption (header-only config and addon scaffolding templates).
- The weak symbol renaming scheme is gated by the `USE_WEAK_SUFFIX_NAPI` macro so that consumers can opt into it per translation unit.

## Usage Overview

- Source-based integration:
  - Use `weak-node-api-config.cmake` to get include paths (header-only interface target).
  - Use the provided scaffolding templates to generate an addon project that links the platform library from cloud artifacts when needed (Android/HarmonyOS). Windows support is coming soon.

## Attribution & License

- This package is licensed under the Apache License 2.0. See LICENSE.
- Upstream components are licensed under MIT. See THIRD-PARTY-NOTICES.md and upstream LICENSE files.
- The macro headers under `defs_header/` carry Apache-2.0 license notices retained as-is.

## Links

- Upstream repository: https://github.com/callstackincubator/react-native-node-api
- Node-Addon-API: https://github.com/node-addon-api/node-addon-api
- Node-API C headers (node-api-headers): https://github.com/nodejs/node-api-headers
- Node-API (N-API): https://nodejs.org/api/n-api.html
