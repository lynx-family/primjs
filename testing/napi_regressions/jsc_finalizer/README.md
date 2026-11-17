# Manual jsc_finalizer regression

This standalone target exercises both the C adapter and legacy entry points.
It is intentionally not wired into CI, CQ, or the default test targets.

From the repository root, using Clang:

```sh
cmake -S oss/testing/napi_regressions/jsc_finalizer -B out/napi_jsc_finalizer_regression -G Ninja \
  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DENABLE_ASAN=ON
cmake --build out/napi_jsc_finalizer_regression --target napi_jsc_finalizer_regression
ASAN_OPTIONS=detect_container_overflow=0:detect_leaks=0 out/napi_jsc_finalizer_regression/napi_jsc_finalizer_regression
```

The GN target is `//oss/testing/napi_regressions/jsc_finalizer:napi_jsc_finalizer_regression`.
Disable ASan or enable leak detection separately when auditing native ownership;
the default invocation above disables known unrelated interpreter leak reports.

On macOS the target uses the system JavaScriptCore framework. On Linux, install
JavaScriptCoreGTK development files or pass `-DJSC_INCLUDE_DIR=<header-directory>`
and `-DJSC_LIBRARY=<library-path>` when configuring.
