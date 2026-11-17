# Manual async_work regression

This standalone target exercises both the C adapter and legacy entry points.
It is intentionally not wired into CI, CQ, or the default test targets.

From the repository root, using Clang:

```sh
cmake -S oss/testing/napi_regressions/async_work -B out/napi_async_work_regression -G Ninja \
  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DENABLE_ASAN=ON
cmake --build out/napi_async_work_regression --target napi_async_work_regression
ASAN_OPTIONS=detect_container_overflow=0:detect_leaks=0 out/napi_async_work_regression/napi_async_work_regression
```

The GN target is `//oss/testing/napi_regressions/async_work:napi_async_work_regression`.
Disable ASan or enable leak detection separately when auditing native ownership;
the default invocation above disables known unrelated interpreter leak reports.
