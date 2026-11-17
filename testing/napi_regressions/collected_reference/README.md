# Manual collected_reference regression

This standalone target exercises both the C adapter and legacy entry points.
It is intentionally not wired into CI, CQ, or the default test targets.

From the repository root, using Clang:

```sh
cmake -S oss/testing/napi_regressions/collected_reference -B out/napi_collected_reference_regression -G Ninja \
  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DENABLE_ASAN=ON
cmake --build out/napi_collected_reference_regression --target napi_collected_reference_regression
ASAN_OPTIONS=detect_container_overflow=0:detect_leaks=0 out/napi_collected_reference_regression/napi_collected_reference_regression
```

The GN target is `//oss/testing/napi_regressions/collected_reference:napi_collected_reference_regression`.
Disable ASan or enable leak detection separately when auditing native ownership;
the default invocation above disables known unrelated interpreter leak reports.

To exercise the tracing GC path on an arm64 standalone interpreter, configure a
separate output directory with `-DNAPI_REGRESSION_TRACING_GC=ON`. The test
selects tracing GC through its own monitor stub and asserts the runtime mode.
This does not replace validation of platform-specific snapshot builds.
