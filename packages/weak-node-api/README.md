# @lynx-js/weak-node-api

## Overview

- Lynx-friendly weak Node-API headers plus a scaffolding CLI for building N-API addons with CMake
- Targets Android, iOS, HarmonyOS, and macOS
- User-facing package consumption requires Node.js 18+
- See Agent.md for AI-oriented guidance and conventions

## User Guide

### Create a project

```bash
# Use npm to fetch the package on-the-fly and run its bin
npm exec -y -p @lynx-js/weak-node-api create-weak-node-api
# Or with npx
npx -y -p @lynx-js/weak-node-api create-weak-node-api
```

Alternative: local project flow (no initializer)

```bash
mkdir my-addon && cd my-addon
npm init -y
npm i -D @lynx-js/weak-node-api@^0.1.0
# Now the local bin is available via node_modules/.bin
npm exec create-weak-node-api
# Or add a script and run it:
npm pkg set scripts.scaffold=\"create-weak-node-api\"
npm run scaffold
```

Follow the prompts to choose a target platform. A project will be created with:
- CMakeLists.txt
- a sample addon source file
- dependency fetch scripts (Android/HarmonyOS)

### Develop and build

```bash
cd your-project
npm install
cmake -S . -B build
cmake --build build --config Release
```

### Typical workflow

1) Scaffold a project

```bash
npm exec -y -p @lynx-js/weak-node-api create-weak-node-api
```

2) Select your target platform and generate the project

You will get a project with:
- CMakeLists.txt
- src/addon.cc (your N-API business logic)
- scripts/fetch-libs.mjs (downloads platform libraries for Android/HarmonyOS)
- addon output naming configured by the scaffold CMake template:
  - Android/HarmonyOS: `lib<project>.so`
  - iOS/macOS (desktop targets): `<project>.node`

3) Implement your addon logic

Edit src/addon.cc. If you enable USE_WEAK_SUFFIX_NAPI, follow the per-translation-unit include convention:
- Include weak_napi_defines.h after the last include
- Include weak_napi_undefs.h at the end of the file

4) Build with CMake

```bash
npm install
cmake -S . -B build
cmake --build build --config Release
```

The scaffold is configured to emit a `.node` addon binary on all supported platforms.
On Android/HarmonyOS the output name is `lib<project>.so`; on iOS/macOS it is `<project>.node`.

5) Platform specifics

- Android: CMake triggers scripts/fetch-libs.mjs to download the AAR and extract vendor/android/libnapi_adapter.so, then links it.
- HarmonyOS: CMake triggers scripts/fetch-libs.mjs to download the HAR and extract vendor/harmony/libnapi_adapter.so, then links it. USE_WEAK_SUFFIX_NAPI is enabled by default.
- iOS/macOS: no dynamic library is linked. The addon is built with dynamic symbol lookup (e.g. -Wl,-undefined,dynamic_lookup) and resolved by the host at runtime.

### Platform linking strategy

- Android: downloads the AAR and extracts jni/arm64-v8a/libnapi_adapter.so, then links it
- HarmonyOS: downloads the HAR and extracts libs/arm64-v8a/libnapi_adapter.so, then links it; USE_WEAK_SUFFIX_NAPI is enabled by default
- iOS/macOS: uses dynamic symbol lookup; no dynamic library is linked

### Symbol renaming (avoid conflicts with other N-API providers)

- Controlled by the compile-time macro USE_WEAK_SUFFIX_NAPI
- Enabled by default on HarmonyOS; optional on other platforms
- In your translation units:
  - include weak_napi_defines.h after the last include
  - include weak_napi_undefs.h at the end of the file

## Maintainer Guide

### Local development

- Node.js requirement: 22+ (see .nvmrc)
- Headers and generated sources live in headers/ and generated/
- Scaffolding entry: scripts/create.mjs
- Templates: templates/

### Refresh headers / generated code

```bash
npm install
npm run prepare:headers
```

### Release checklist

- Update the version in package.json
- Update the dependency version in templates/skeleton/package.json so scaffolded projects depend on the intended package release
- Run npm run bootstrap locally before submitting the release commit
- Commit the refreshed generated files and templates so the publish workflow only needs to run npm publish

### Validate the scaffolder

```bash
node scripts/create.mjs
```

### Publishing and npm create

If you want an `npm create` initializer UX, you can publish an optional initializer package:
- @lynx-js/weak-node-api: headers + templates + create script
- @lynx-js/create-weak-node-api (optional): npm create initializer that depends on and forwards to @lynx-js/weak-node-api

This repository does not ship an initializer package by default, so the recommended entry points are:
- npm exec -y -p @lynx-js/weak-node-api create-weak-node-api
- npx -y -p @lynx-js/weak-node-api create-weak-node-api

## Directory layout

- headers/: Node-API C/C++ headers for consumers
- generated/: generated weak bridge sources/headers
- shim/: helper headers
- scripts/: package scripts (prepare-headers, scaffolder)
- templates/: scaffolding templates
- Agent.md: AI-friendly guide and conventions

## Compliance

- Licensed under Apache-2.0
- Third-party licenses are documented in THIRD-PARTY-NOTICES.md and licenses/
