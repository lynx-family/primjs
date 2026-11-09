# THIRD-PARTY-NOTICES

This directory bundles or derives from third-party software components. Their licenses are summarized below. Full license texts are stored under `licenses/`.

## 1. Node.js Test Suites (MIT)

- Project: Node.js (specifically `test/js-native-api` and `test/node-api` directories)
- Repository: https://github.com/nodejs/node
- License: MIT (see `licenses/nodejs.MIT`)
- Copyright: Node.js contributors

This directory vendors and adapts parts of the N-API tests from the Node.js repository to exercise the PrimJS N-API adapter. Most C/C++ and JavaScript files under `js_native_api/` and parts of `common/` are based on upstream tests with local modifications (porting to PrimJS, additional coverage, harness integration, and symbol renaming).

## 2. Relationship to the main license

The overall test harness under `oss/testing/napi_adapter` is licensed under the Apache License, Version 2.0. The third-party components listed above remain under the MIT License. In case of conflict, file-level license headers and the text in `licenses/nodejs.MIT` govern those specific components.
