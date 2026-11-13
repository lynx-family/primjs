# N-API adapter tests

These tests were ported from Node.js v14.11.0 (`test/js-native-api` and
`test/node-api`) to validate the Node-API 6 surface of the PrimJS C adapter.
Browserify bundles the JavaScript assertions; the native fixtures use the
existing `packages/weak-node-api` bridge. No Node.js runtime is required to
execute the bundles. See UPSTREAM.md and THIRD-PARTY-NOTICES.md for provenance.

## GN builds

These tests are run manually. They are not included in the default test group,
CI or CQ test scripts. The production adapter implementation is unchanged.

Prepare the repository's GN dependencies and put Node.js (18.12 or newer), npm
and pnpm 9.12.0 on PATH. The bundler installs dependencies with the pnpm version
pinned in `package.json`.
From this directory:

```sh
pnpm install --frozen-lockfile
pnpm test
# Select PrimJS and V8 on macOS while investigating the JSC failures below:
pnpm test -- --gtest-filter='*/QJS:*/V8'
# Snapshot/tracing GC on macOS arm64:
pnpm run test:gc
```

The runner finds either an internal checkout or a standalone PrimJS checkout,
uses the host OS and CPU, prepares the existing weak-node-api package, bundles
all 31 feature suites, generates a dedicated GN build with `--root-target`,
builds `napi_adapter_unittest`, and runs it. GN runs
PrimJS and V8; macOS also runs JavaScriptCore. Output defaults to
`out/napi_adapter`; `python3 run_tests.py --out out/custom` selects another
directory.

For a build prepared by this runner, run from the repository root:

```sh
ninja -C out/napi_adapter napi_adapter_unittest
ASAN_OPTIONS=detect_container_overflow=0 out/napi_adapter/napi_adapter_unittest
```

On Linux, append `:detect_leaks=0` to ASAN_OPTIONS as for `napi_unittest`.
`NAPI_ADAPTER_TEST_ROOT` can point to the absolute `js_native_api` directory
when running from a different working directory. Missing suites or bundles
fail the test instead of being silently skipped. To select an engine when
running the binary directly, pass `--gtest_filter='*/QJS'`, `*/V8` or `*/JSC`.

## Standalone CMake build

CMake validates the PrimJS backend. Prepare the JavaScript and bridge inputs
with `pnpm install --frozen-lockfile`, `pnpm run bootstrap-deps`, and
`pnpm run build:js` in this directory, then build from the PrimJS source root:

```sh
cmake -S . -B out/napi_adapter_cmake -G Ninja \
  -DENABLE_LEPUSNG=ON -DENABLE_ASAN=ON -DENABLE_NAPI_ADAPTER_TESTS=ON
cmake --build out/napi_adapter_cmake --target napi_adapter_unittest
ASAN_OPTIONS=detect_container_overflow=0 out/napi_adapter_cmake/napi_adapter_unittest
```

In an internal checkout, use `cmake -S oss` instead. Set
`NAPI_ADAPTER_GTEST_SOURCE_DIR` if GoogleTest lives outside the normal
`third_party/googletest` directory. Use Clang, as required by the engine's
CMake configuration.

## Adding cases

1. Copy the upstream C/C++ bindings and JavaScript tests into a feature
   directory under `js_native_api`, preserving the upstream license.
2. Include `../common.h`, `../entry_point.h`, and `headers/node_api.h`.
   Include `headers/weak_napi_defines.h` after all other headers and undo the
   remapping with `headers/weak_napi_undefs.h` at the end.
3. Replace the addon require path with `./build/export`. Add any portable
   helper needed by the test to `common/index.js`.
4. Add the native source to the feature's `BUILD.gn`, the main GN dependency
   list, `kTestSuites` in the harness, and `CMakeLists.txt`. Give it a unique `NAPI_MODULE_NAME`.
5. Verify all supported engines. Document any unsupported API explicitly;
   do not suppress a failing supported assertion merely to make the suite pass.

The harness triggers collection on each backend and checks callback counts
before destroying its runtime. Receiver mutation, integer conversion boundaries
and JSC reference/finalizer ordering assertions remain in the suite.

Native `AdapterCleanup*` cases additionally destroy the environment and check
that C adapter hooks can unref/delete owned references before InstanceData
finalization, legacy hooks remain later, and reverse registration order survives
hook removal. These lifecycle assertions run after teardown because JavaScript
cannot inspect a destroyed environment.

## Known JSC failures

The existing JSC adapter does not pass the full imported suite. These findings
are retained as failing tests for investigation; this import does not modify
the production adapter or exclude these assertions:

- Strict JavaScript callbacks receive the global object for an `undefined`
  receiver instead of preserving the primitive receiver (`3_callbacks`).
- A native finalizer that calls JavaScript during JSC collection can crash
  the process (`test_function`). Run JSC separately so a crash does not
  interrupt validation of the other engines.
- On JavaScriptCoreGTK, conversion of NaN and infinities to 32-bit integers
  can return a CPU-dependent result (`test_conversions`).
- Deletion from finalizers is covered by `test_reference`, including 1000
  collection cycles on JSC, and needs further investigation once the earlier
  failures are resolved.

An additional diagnostic calls `napi_reference_ref` after its weak target has
been collected. This operation is outside the original migrated test sequence;
a separate PrimJS + ASan probe crashes, while V8 returns a count of 1 with the
reference value still unavailable. Node.js v14.11.0 also increments the count in
this path, so this import does not assert that the result must be 0. The common
reference tests and the JSC-specific ordering stress do not establish that this
additional boundary is supported by every backend.

## Known exclusions

This is a port of the selected Node-API 6 tests, with inherited exclusions;
it is not a claim of complete Node-API conformance. APIs newer than version 6,
such as ArrayBuffer detachment and object type tags, remain outside this suite.

Two assertions that the original port commented out are enabled on V8:

- Escaping the same escapable scope twice should return
  `napi_escape_called_twice`. PrimJS and JavaScriptCore do not currently
  report that status. The native test closes its scope before asserting, so
  a mismatch is reported as a test failure instead of leaking an open scope.
- Deleting a non-configurable own property should return `napi_ok` and set
  the result to `false`. PrimJS currently throws a TypeError instead.

Local probes reproduce both differences on PrimJS while V8 passes these
assertions. Aligning them through the adapter/spec-compliant path would
preserve the behavior of the legacy interfaces. This test import retains
those backend exclusions and makes them explicit.

## License

The harness is licensed under Apache-2.0. Node.js-derived tests retain their
MIT license; see LICENSE, THIRD-PARTY-NOTICES.md and `licenses/nodejs.MIT`.
