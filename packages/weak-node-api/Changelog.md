## 0.0.5 - 2026-04-16
- **Compatibility**: Relax consumer Node.js requirement to >= 18 (publish-time `engines.node`).
- **Dev Dependency**: Track the upstream `weak-node-api@0.1.1` as a devDependency to avoid imposing its Node.js requirements on consumers.
- **Docs**: Clarify consumer vs maintainer Node.js version requirements.

## 0.1.0 - 2026-04-07
- **Breaking Change**: Update module lookup APIs to use caller-provided output storage to avoid cross-DLL allocation/free issues on Windows.
  - `napi_find_module_primjs`: changed from returning a heap-allocated `napi_module_spec_compl*` to `bool napi_find_module_primjs(const char* name, napi_module* out)`.
  - `napi_find_module_weak`: changed to `bool napi_find_module_weak(const char* name, napi_module* out)` and forwards to the injected host implementation.

## 0.0.3 - 2026-03-11
- **Optimization**: Set minimum OSX_DEPLOYMENT_TARGET to 10.13 for weak-node-api on macOS. Original value was 10.0, which was too old and caused x64 dynamic library linking failures with newer linkers.

## 0.0.2 - 2026-02-26
- **Unified N-API Integration**: Merges source files from upstream `weak-node-api@0.1.1` and `node-addon-api@7.1.0` packages. This integration provides symbol suffix renaming capabilities (appending `_weak` suffix) and includes a comprehensive set of source files in the `headers/` and `generated/` directories for seamless downstream usage.
- **Prebuilt Binaries**: Provides prebuilt binary libraries for macOS (x86 & arm64) and Windows (x64) platforms.

## 0.0.1 - 2026-02-06

- Initial release.
