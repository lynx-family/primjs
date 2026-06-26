# NOTICE

This package, @lynx-js/weak-node-api, is distributed by The Lynx Authors under the Apache License, Version 2.0 (Apache-2.0). See LICENSE for the full text.

It incorporates and derives from upstream open-source projects as noted below. Where applicable, we retain upstream copyright notices and licenses in the original files. Additional attribution and licensing context is provided here for transparency and compliance.

## Upstream Sources

- React Native Node API / weak-node-api (callstackincubator/react-native-node-api)
  - Repository: https://github.com/callstackincubator/react-native-node-api
  - Published npm package: weak-node-api (https://www.npmjs.com/package/weak-node-api)
  - License: MIT (see https://github.com/callstackincubator/react-native-node-api/blob/main/LICENSE.md)
  - Upstream npm version in this package: weak-node-api@0.1.1 (tracked via devDependency in package.json)
  - Usage: We copy selected headers and generated sources from the `weak-node-api` npm package. Our package publishes the derived headers/sources and additional scaffolding/build integration.

- Node-Addon-API (node-addon-api)
  - Repository: https://github.com/node-addon-api/node-addon-api
  - License: MIT (see https://github.com/node-addon-api/node-addon-api/blob/main/LICENSE)
  - Usage: We merge a subset of Node-Addon-API header files (e.g., `napi.h`, `napi-inl.h`, `napi-inl.deprecated.h`) into this package's `headers/` directory for downstream consumption.

- Node-API C headers (node-api-headers / Node.js)
  - Repository: https://github.com/nodejs/node-api-headers
  - License: MIT (see https://github.com/nodejs/node-api-headers/blob/main/LICENSE)
  - Usage: Node-API C header definitions (for example `js_native_api.h`, `js_native_api_types.h`, `node_api.h`, `node_api_types.h`) are provided by Node.js through the `node-api-headers` npm package and consumed transitively via `weak-node-api`. These headers may be copied into this package's `headers/` directory as part of the `prepare:headers` pipeline.

## Derived and Generated Content

- Generated headers and sources
  - The `generated/` directory may contain files derived from the upstream React Native Node API generator as packaged in the `weak-node-api` npm release noted above. Top-of-file comments in those files indicate the upstream origin and direct readers to this NOTICE.
  - We perform limited post-processing to insert weak symbol macro includes (`weak_napi_defines.h` / `weak_napi_undefs.h`) and adjust include paths.
  - As of this branch, these weak symbol macro includes are only effective when the `USE_WEAK_SUFFIX_NAPI` compile-time macro is defined.

- Symbol renaming (weak macros)
  - To avoid linkage and symbol conflicts, we introduce symbol renaming via macro wrappers. The files `defs_header/weak_napi_defines.h` and `defs_header/weak_napi_undefs.h` implement the weak symbol macro scheme used across the merged headers and generated sources.
  - Note: these macro headers are copied into `headers/` during the `prepare:headers` pipeline so that consumers only need to include from `headers/`.

## Build System Additions and Packaging
- Binary distribution and layout
  - This package does not ship prebuilt binaries. Android/HarmonyOS consumers fetch `libnapi_adapter.so` from remote artifacts when needed; iOS/macOS use static integration. Windows support is coming soon.
  - A header-only CMake config (`weak-node-api-config.cmake`) is provided for include path propagation, and scaffolding templates are provided for generating addon projects.

## License Note on Macro Headers

- The macro headers under `defs_header/` and the copied versions under `headers/` carry Apache-2.0 license headers and are retained as-is. Redistribution must retain the original file headers and this NOTICE.

## Additional Notes

- "Derived work includes upstream generated headers/content" annotations appear in build scripts and configuration files to indicate that certain produced outputs originate from upstream sources at the npm version noted above.
- This NOTICE does not replace upstream licenses. It consolidates attribution and clarifies Lynx-authored modifications and packaging decisions.
