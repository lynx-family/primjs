# THIRD-PARTY-NOTICES

This package bundles or derives from third-party software components. Their licenses are summarized below. Full license texts are stored under `licenses/`.

## 1. React Native Node API / weak-node-api (MIT)

- Project: callstackincubator/react-native-node-api
- Repository: https://github.com/callstackincubator/react-native-node-api
- Published npm package: `weak-node-api` (https://www.npmjs.com/package/weak-node-api)
- License: MIT (see `licenses/weak-node-api.MIT`)
- Copyright: 2025-present, Callstack and React Native Node API contributors

The upstream project provides the original `weak-node-api` implementation and generator. This package vendors selected headers and generated sources derived from that project.

## 2. node-addon-api (MIT)

- Project: node-addon-api
- Repository: https://github.com/nodejs/node-addon-api
- License: MIT (see `licenses/node-addon-api.MIT`)
- Copyright: 2017, Node.js API collaborators

This package embeds a subset of Node-Addon-API C++ headers in its `headers/` tree for downstream consumption.

## 3. Node-API C headers (MIT)

- Project: node-api-headers (Node-API C headers for Node.js)
- Repository: https://github.com/nodejs/node-api-headers
- License: MIT (see `licenses/node-api-headers.MIT`)
- Copyright: 2021, Node.js

This package indirectly consumes the Node-API C header definitions (for example `js_native_api.h`, `js_native_api_types.h`, `node_api.h`, `node_api_types.h`) via the upstream `weak-node-api` and `node-api-headers` npm packages. When the `prepare:headers` pipeline is run, these headers may be copied into this package's `headers/` directory.

## 4. Binary redistribution

Even if you only redistribute prebuilt binaries from this package (for example, artifacts under `prebuilt/**`) and not the original source files, you **must still** keep the following with your distribution:

- This `THIRD-PARTY-NOTICES.md` file, and
- The full MIT license texts from:
  - `licenses/weak-node-api.MIT`
  - `licenses/node-addon-api.MIT`
  - `licenses/node-api-headers.MIT`

This satisfies the requirement in the MIT License that copyright notices and permission notices be included with all copies or substantial portions of the software, including binary-only distributions.

## 5. Relationship to the main license

The overall package `@lynx-js/weak-node-api` is licensed under the Apache License, Version 2.0 (Apache-2.0). The third-party components listed above remain under their original MIT licenses. In case of conflict, file-level license headers and the texts in `licenses/*.MIT` govern those specific components.
