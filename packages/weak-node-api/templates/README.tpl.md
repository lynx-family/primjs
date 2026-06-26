# __PROJECT_NAME__

- Supported platforms: Android, iOS, HarmonyOS, and macOS. The scaffold generates one cross-platform CMake project; choose the platform at build time by configuring CMake with the corresponding toolchain/generator.

## Usage

- Implement your N-API logic in src/addon.cc
- The generated sample uses the `node-addon-api` C++ wrapper and a unified registration model: once the addon binary is loaded it auto-registers itself, and it also exports the standard Node-API C entry points (`napi_register_module_v1` / `node_api_module_get_api_version_v1`) so a host may still locate it with `dlsym`/`GetProcAddress`.
- Run npm install to pull the header dependency
- Build with CMake. The generic `cmake -S . -B build` command builds the current host platform only. For example, running it on macOS produces the macOS artifact; use the platform-specific commands below for Android, iOS, and HarmonyOS.
- See Agent.md for AI-oriented guidance when iterating with an AI assistant/agent
- Output layout after each platform build:
  - Android: `dist/android/<abi>/lib<project>.so`
  - HarmonyOS: `dist/harmony/<abi>/lib<project>.so`
  - iOS: `dist/ios/iphoneos/lib<project>.a` or `dist/ios/iphonesimulator/lib<project>.a`
  - macOS: `dist/macos/macosx/lib<project>.a`
- Apple packaging output after `npm run package:apple`:
  - `dist/apple/<project>.xcframework`
  - `dist/apple/<project>.podspec`
  - `dist/apple/include/addon_use.h`

### Build with CMake

```bash
npm install
cmake -S . -B build
cmake --build build --config Release
```

The command above is for the current host platform. Use a separate build directory for each target platform you want to build.

### Cross-compilation toolchains

This project is built with CMake, so cross-compilation is controlled by the CMake toolchain and generator you choose when configuring the build directory. The scaffold CMakeLists contains platform conditionals for Android/OHOS/Apple and does not hardcode SDK/NDK paths.

Android/HarmonyOS dependency URLs

For Android and HarmonyOS builds, the scaffold downloads platform libraries from package URLs defined in `scripts/artifact-sources.json` and extracts them into vendor/. Windows support is coming soon.

Android (NDK)

```bash
cmake -S . -B build-android-arm64 \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-21 \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build-android-arm64
```

HarmonyOS (OHOS SDK/NDK)

```bash
cmake -S . -B build-ohos-arm64 \
  -DCMAKE_TOOLCHAIN_FILE=$OHOS_NDK/build/cmake/ohos.toolchain.cmake \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build-ohos-arm64
```

iOS (Xcode)

```bash
cmake -S . -B build-ios-arm64 \
  -G Xcode \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_SYSROOT=iphoneos \
  -DCMAKE_OSX_ARCHITECTURES=arm64
cmake --build build-ios-arm64 --config Release
```

Note: Apple platforms emit static libraries while Android/HarmonyOS emit loadable libraries. The scaffolded registration code is shared across platforms: it auto-registers when the addon is loaded and also exports the standard dynamic Node-API C entry points. For Apple static integration, link the library into the host app and include `addon_use.h` from exactly one host `.cc`/`.mm` translation unit so the addon's auto-registration symbol is retained before `requireNodeAddon` is called.

Apple packaging

```bash
# Build the Apple slices you need first
cmake -S . -B build-ios-device -G Xcode \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_SYSROOT=iphoneos \
  -DCMAKE_OSX_ARCHITECTURES=arm64
cmake --build build-ios-device --config Release

cmake -S . -B build-ios-sim -G Xcode \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_SYSROOT=iphonesimulator \
  -DCMAKE_OSX_ARCHITECTURES=arm64
cmake --build build-ios-sim --config Release

cmake -S . -B build-macos -DCMAKE_BUILD_TYPE=Release
cmake --build build-macos --config Release

# Then package them into an xcframework and a local podspec
npm run package:apple
```

macOS

```bash
cmake -S . -B build-macos \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build-macos
```

### Platform Notes

- Registration is unified across static and dynamic loading styles. "Static" means the addon is linked into the host process, usually as an Apple static library, and auto-registers when the image is loaded. "Dynamic" means the host loads a shared addon and may find the exported Node-API entry point with `dlsym`/`GetProcAddress`. The scaffold emits both paths from the same registration block, so platform code does not need separate registration macros.
- Android/Harmony: downloads and extracts libnapi_adapter.so into vendor/
- Windows: coming soon.
- iOS/macOS: emits a static library plus `addon_use.h`; the host must include `addon_use.h` from exactly one `.cc`/`.mm` translation unit to retain the addon's auto-registration entry
- Requires unzip for extracting AAR (Android) and tar for extracting HAR (HarmonyOS)

### Symbol Renaming

- HarmonyOS and macOS enable USE_WEAK_SUFFIX_NAPI by default
- Other platforms can toggle USE_WEAK_SUFFIX_NAPI via a CMake option

### Packaging handoff

This scaffold only produces organized platform artifacts under `dist/`. You can package them however your host app expects:
- Android: package `dist/android/.../*.so` into an AAR
- HarmonyOS: package `dist/harmony/.../*.so` into a HAR
- Windows: support is coming soon; no Windows artifact is generated by the current scaffold.
- iOS/macOS: run `npm run package:apple` to produce a static-library xcframework at `dist/apple/<project>.xcframework`, `dist/apple/<project>.podspec`, and `dist/apple/include/addon_use.h`

### Apple direct integration

For local integration, the generated podspec is immediately usable with CocoaPods:

```ruby
pod '__PROJECT_NAME__', :path => '../path/to/dist/apple'
```

For remote publishing, upload the xcframework separately and then replace the generated podspec's `s.source = { :path => "." }` with your real zip URL and checksum.

For Apple static integration, link the generated static-library xcframework into the host app and include the generated use header from exactly one host `.cc`/`.mm` file. The header expands to `NAPI_USE(__PROJECT_SYMBOL__)`, creating an explicit `used` reference to the addon's auto-registration symbol so Xcode's release/dead-strip link does not remove it. Keep the generated registration block in `src/addon.cc` and the generated `addon_use.h` intact; do not use `-force_load` for this path.

```cpp
#include "addon_use.h"

requireNodeAddon("__PROJECT_NAME__");
```
