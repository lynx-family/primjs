# @lynx-js/weak-node-api

## Overview

- Lynx-friendly weak Node-API headers plus a scaffolding CLI for building N-API addons with CMake
- Targets Android, iOS, HarmonyOS, and macOS. Windows support is coming soon.
- User-facing package consumption requires Node.js 18+
- iOS is also published as an independent CocoaPods package named `LynxWeakNodeAPI`, which ships the generated weak-node-api sources separately from PrimJS
- See Agent.md for AI-oriented guidance and conventions

## User Guide

### Create a project

```bash
# Use npm to fetch the package on-the-fly and run its bin
npm exec -y --package=@lynx-js/weak-node-api -- create-weak-node-api
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

Follow the prompt for the project name. A cross-platform CMake project will be created with:
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

The generic CMake command above builds the current host platform only. For example, running it on macOS produces the macOS static library. To build Android, iOS, or HarmonyOS, configure a separate build directory with the platform-specific CMake toolchain/generator shown below.

### Typical workflow

1) Scaffold a project

```bash
npm exec -y --package=@lynx-js/weak-node-api -- create-weak-node-api
```

2) Generate the cross-platform project

You will get a project with:
- CMakeLists.txt
- src/addon.cc (your N-API business logic)
- scripts/fetch-libs.mjs (downloads platform libraries for Android/HarmonyOS)
- scripts/package-apple.mjs (packages Apple outputs into an xcframework and podspec)
- a unified `dist/` output layout configured by the scaffold CMake template:
  - Android: `dist/android/<abi>/lib<project>.so`
  - HarmonyOS: `dist/harmony/<abi>/lib<project>.so`
  - iOS: `dist/ios/iphoneos/lib<project>.a` or `dist/ios/iphonesimulator/lib<project>.a`
  - macOS: `dist/macos/macosx/lib<project>.a`
  - Apple packaging: `dist/apple/<project>.xcframework` and `dist/apple/<project>.podspec` after `npm run package:apple`

3) Implement your addon logic

Edit src/addon.cc. If you enable USE_WEAK_SUFFIX_NAPI, follow the per-translation-unit include convention:
- Include weak_napi_defines.h after the last include
- Include weak_napi_undefs.h at the end of the file

The scaffolded sample is written against the `node-addon-api` C++ wrapper and uses a unified registration model: once the addon binary is loaded it auto-registers itself, and it also exports the standard Node-API C entry points (`napi_register_module_v1` / `node_api_module_get_api_version_v1`) so a host may still locate it with `dlsym`/`GetProcAddress`.

4) Build with CMake

```bash
npm install
cmake -S . -B build
cmake --build build --config Release
```

The command above builds the current host platform only. Use a separate build directory and the corresponding CMake toolchain/generator for each target platform you want to build.

Android (NDK):

```bash
cmake -S . -B build-android-arm64 \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-21 \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build-android-arm64
```

HarmonyOS (OHOS SDK/NDK):

```bash
cmake -S . -B build-ohos-arm64 \
  -DCMAKE_TOOLCHAIN_FILE=$OHOS_NDK/build/cmake/ohos.toolchain.cmake \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build-ohos-arm64
```

iOS device (Xcode):

```bash
cmake -S . -B build-ios-device \
  -G Xcode \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_SYSROOT=iphoneos \
  -DCMAKE_OSX_ARCHITECTURES=arm64
cmake --build build-ios-device --config Release
```

iOS simulator (Xcode):

```bash
cmake -S . -B build-ios-sim \
  -G Xcode \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_SYSROOT=iphonesimulator \
  -DCMAKE_OSX_ARCHITECTURES=arm64
cmake --build build-ios-sim --config Release
```

macOS:

```bash
cmake -S . -B build-macos \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build-macos --config Release
```

The scaffold is configured to emit platform-appropriate addon artifacts into `dist/`.
On Android/HarmonyOS the artifact is `lib<project>.so`; on iOS/macOS it is `lib<project>.a`. Windows support is coming soon.

Registration is unified across static and dynamic loading styles. "Static" means the addon is linked into the host process, usually as an Apple static library, and auto-registers when the image is loaded. "Dynamic" means the host loads a shared addon and may find the exported Node-API entry point with `dlsym`/`GetProcAddress`. The scaffold emits both paths from the same registration block, so platform code does not need separate registration macros.

5) Platform specifics

- Android: CMake triggers scripts/fetch-libs.mjs to download the AAR and extract vendor/android/libnapi_adapter.so, then links it.
- HarmonyOS: CMake triggers scripts/fetch-libs.mjs to download the HAR and extract vendor/harmony/libnapi_adapter.so, then links it. USE_WEAK_SUFFIX_NAPI is enabled by default.
- Windows: coming soon.
- iOS/macOS: Apple platforms emit static libraries; dynamic platforms emit loadable libraries. The addon registration code is unified across platforms: it auto-registers when loaded and also exports the standard dynamic C entry points. For Apple static integration, include `addon_use.h` from exactly one host `.cc`/`.mm` file so `NAPI_USE` retains the auto-registration symbol before `requireNodeAddon` is called. macOS enables USE_WEAK_SUFFIX_NAPI by default.

6) Package Apple artifacts for direct integration

```bash
npm run package:apple
```

This command consumes the already-built Apple static libraries under `dist/ios/...` and `dist/macos/...`, then writes:
- `dist/apple/<project>.xcframework`
- `dist/apple/<project>.podspec`
- `dist/apple/include/addon_use.h`

The generated podspec is ready for local CocoaPods integration:

```ruby
pod 'your-project', :path => '../path/to/dist/apple'
```

If you later publish the Apple package remotely, replace the generated podspec's `s.source = { :path => "." }` with your hosted zip URL and checksum.

For Apple static integration, link the generated static-library xcframework into the host app and include the generated use header from exactly one host `.cc`/`.mm` file. The header expands to `NAPI_USE(<addon_symbol>)`, creating an explicit `used` reference to the addon's auto-registration symbol so Xcode's release/dead-strip link does not remove it. Keep the generated registration block in `src/addon.cc` and the generated `addon_use.h` intact; do not use `-force_load` for this path.

```cpp
#include "addon_use.h"

requireNodeAddon("your-project");
```

### Platform linking strategy

- Android: downloads the AAR and extracts jni/arm64-v8a/libnapi_adapter.so, then links it
- HarmonyOS: downloads the HAR and extracts libs/arm64-v8a/libnapi_adapter.so, then links it; USE_WEAK_SUFFIX_NAPI is enabled by default
- Windows: coming soon.
- iOS/macOS: emits a static library and `addon_use.h`; include the use header from exactly one host `.cc`/`.mm` file so `NAPI_USE` retains the addon's auto-registration symbol

### Symbol renaming (avoid conflicts with other N-API providers)

- Controlled by the compile-time macro USE_WEAK_SUFFIX_NAPI
- Enabled by default on HarmonyOS and macOS; optional on other platforms
- In your translation units:
  - include weak_napi_defines.h after the last include
  - include weak_napi_undefs.h at the end of the file

### Packaging handoff

The scaffold does not publish platform packages for you. Instead, it writes organized build artifacts to `dist/` so you can package them using your own release flow:
- Android: turn `dist/android/.../*.so` into an AAR
- HarmonyOS: turn `dist/harmony/.../*.so` into a HAR
- Windows: support is coming soon; no Windows artifact is generated by the current scaffold.
- iOS/macOS: run `npm run package:apple` to produce a static-library xcframework plus podspec for direct integration or later publishing

## Maintainer Guide

### Local development

- Node.js requirement: 22+ (see .nvmrc)
- headers/ and generated/ are produced by npm run prepare:headers and are not committed to the repository
- Scaffolding entry: scripts/create.mjs
- Templates: templates/

### Refresh headers / generated code

```bash
npm install
npm run prepare:headers
```

### Release checklist

- Update the version in package.json
- The publish flow updates templates/skeleton/package.json automatically so scaffolded projects depend on the package name and version being released
- Run npm run bootstrap locally to validate generated outputs and scaffolding behavior
- The GitHub release workflows for Android/HarmonyOS/iOS run npm install and npm run prepare:headers before packaging/publishing

### Validate the scaffolder

```bash
node scripts/create.mjs
```

### Publishing and npm create

If you want an `npm create` initializer UX, you can publish an optional initializer package:
- @lynx-js/weak-node-api: headers + templates + create script
- @lynx-js/create-weak-node-api (optional): npm create initializer that depends on and forwards to @lynx-js/weak-node-api

This repository does not ship an initializer package by default, so the recommended entry points are:
- npm exec -y --package=@lynx-js/weak-node-api -- create-weak-node-api
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
