# __PROJECT_NAME__ (AI Guide)

## What this project is

This repository is a CMake-based N-API addon project scaffolded by `@lynx-js/weak-node-api`.
The scaffold keeps one cross-platform CMakeLists.txt with branches for Android, iOS, HarmonyOS, and macOS. Configure a separate build directory with the appropriate CMake toolchain/generator for the platform you want to build.

## Quick start

```bash
npm install
cmake -S . -B build
cmake --build build --config Release
```

The generic command above builds the current host platform. On macOS it produces the macOS static library only; use README.md for Android/iOS/HarmonyOS cross-compilation commands.

## Output naming

- Android: `dist/android/<abi>/lib<project>.so`
- HarmonyOS: `dist/harmony/<abi>/lib<project>.so`
- iOS: `dist/ios/iphoneos/lib<project>.a` or `dist/ios/iphonesimulator/lib<project>.a`
- macOS: `dist/macos/macosx/lib<project>.a`
- Apple packaging: `dist/apple/<project>.xcframework`, `dist/apple/<project>.podspec`, and `dist/apple/include/addon_use.h` after `npm run package:apple`

## Editing addon code

- Implement your N-API logic in `src/addon.cc`; keep the generated unified registration block (`LYNX_NAPI_AUTO_REGISTER_MODULE` plus the exported Node-API C entry points) and `src/addon_use.h` intact.
- If you enable `USE_WEAK_SUFFIX_NAPI`, follow the per-translation-unit include convention:
  - include `weak_napi_defines.h` after the last include
  - include `weak_napi_undefs.h` at the end of the file

## Platform linking strategy

- Android: the build downloads the AAR and extracts `vendor/android/libnapi_adapter.so`, then links it.
- HarmonyOS: the build downloads the HAR and extracts `vendor/harmony/libnapi_adapter.so`, then links it.
- Windows: coming soon.
- iOS/macOS: Apple platforms emit static libraries plus a generated `addon_use.h` header. The registration code is shared across platforms: it auto-registers when loaded and also exports the standard dynamic Node-API C entry points. The host app must include `addon_use.h` from exactly one `.cc`/`.mm` translation unit to retain the addon's auto-registration symbol before `requireNodeAddon`.

## Apple packaging

- Build the required Apple static library slices first, then run `npm run package:apple`.
- The packaging script creates a local-consumable podspec that points to the generated static-library xcframework via `:path => "."` and copies `addon_use.h` into `dist/apple/include`.
- For remote publishing, replace the generated podspec source stanza with your hosted zip URL and checksum.

## Toolchains (cross compilation)

Cross-compilation is controlled by the CMake toolchain/generator you choose when configuring the build directory.
See README.md for command examples.
