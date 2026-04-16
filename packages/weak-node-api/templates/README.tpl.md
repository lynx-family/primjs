# __PROJECT_NAME__

- Platform: __PLATFORM__

## Usage

- Implement your N-API logic in src/addon.cc
- Run npm install to pull the header dependency
- Build with CMake
- See Agent.md for AI-oriented guidance when iterating with an AI assistant/agent
- Output naming:
  - Android/HarmonyOS: `lib<project>.so`
  - iOS/macOS (and other desktop targets): `<project>.node`

### Build with CMake

```bash
npm install
cmake -S . -B build
cmake --build build --config Release
```

### Cross-compilation toolchains

This project is built with CMake, so cross-compilation is controlled by the CMake toolchain and generator you choose when configuring the build directory. The scaffold CMakeLists only contains platform conditionals (Android/OHOS/Apple) and does not hardcode SDK/NDK paths.

Android/HarmonyOS dependency URLs

For Android and HarmonyOS builds, the scaffold downloads a platform library (`libnapi_adapter.so`) from package URLs defined in `scripts/artifact-sources.json` and extracts it into vendor/.

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

Note: For `.node` addons, code signing is typically not desired at build time. The scaffold disables Xcode code signing for iOS targets by default. If you need signing, remove the relevant Xcode attributes from CMakeLists.txt or override them in your build system.

macOS

```bash
cmake -S . -B build-macos \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_BUILD_TYPE=Release
cmake --build build-macos
```

### Platform Notes

- Android/Harmony: downloads and extracts libnapi_adapter.so into vendor/
- iOS/macOS: no dynamic library is linked; symbols are resolved dynamically
- Requires unzip for extracting AAR (Android) and tar for extracting HAR (HarmonyOS)

### Symbol Renaming

- Harmony enables USE_WEAK_SUFFIX_NAPI by default
- Other platforms can toggle USE_WEAK_SUFFIX_NAPI via a CMake option
