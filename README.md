<div align="center">

<p>
  <a href="https://lynxjs.org/guide/scripting-runtime/main-thread-runtime.html#primjs">
    <img width="500" alt="PrimJS logo" src=".github/splash.png" />
  </a>
</p>

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0.txt)

PrimJS is a lightweight, high-performance JavaScript engine designed specifically for the [Lynx](https://github.com/lynx-family/lynx) cross-platform framework. Fully supporting ES2019, PrimJS is built on top of [QuickJS](https://bellard.org/quickjs/) and delivers superior performance and a better development experience compared to QuickJS. 

</div>

## Key features include:
- **[Optimized Interpreter](./docs/template_interpreter.md):** PrimJS introduces a template interpreter leveraging stack caching and register optimizations, significantly enhancing performance.
- **Seamless Object Model Integration:** The engine's object model integrates efficiently with the Lynx object model, reducing data communication overhead and improving rendering performance.
- **[Advanced Memory Management](./docs/gc.md):** Utilizing a Garbage Collector (GC) instead of QuickJS's Reference Counting, PrimJS offers better performance, improved memory analyzability, and reduced risk of memory leaks.
- **[Comprehensive Debugging Support](./docs/debugger.md):** Full implementation of the [Chrome DevTools Protocol (CDP)](https://chromedevtools.github.io/devtools-protocol/) enables seamless integration with Chrome Debugger for enhanced debugging capabilities.

## Performance
For detailed performance benchmarks, please refer to [performance comparison document](./docs/benchmark.md). The benchmark results show that PrimJS outperforms QuickJS by approximately 28% in overall score (3735 vs 2904) on the Octane Benchmark suite.
We are continuously working on performance optimizations.

## Quick Start

### Dependencies
1. **Clone the repository:**
   ```bash
   git clone git@github.com:lynx-family/primjs.git
   ```

2. **Install dependencies:**
   ```bash
   cd primjs
   source tools/envsetup.sh
   hab sync .
   ```

### Building on Linux and macOS
PrimJS uses `gn` and `ninja` for building. Follow these steps to generate the `qjs` binary:

```bash
gn gen out/Default
ninja -C out/Default qjs_exe
```

To enable the template interpreter and garbage collector, use the following `gn` arguments (for example, on the arm64 platform, these arguments configure the build system to target ARM64 architecture while enabling the bytecode-based template interpreter and automatic memory management):

```bash
gn gen out/Default --args= '
    target_cpu="arm64" 
    enable_primjs_snapshot = true
    enable_compatible_mm = true
    enable_tracing_gc = true'
ninja -C out/Default -j32 qjs_exe
```

### Release Build
For a release build, set the `is_debug = false` argument during configuration.

### Running PrimJS
The primary binary is `qjs`, located at `out/Default/qjs`. Use it to run JavaScript files:

```bash
./out/Default/qjs test.js
```

### Running Tests
Run the following steps from the root directory to build and execute unit tests:

#### Build Unit Tests
```bash
python3 tools/ci/check_test_build.py
```

#### Run Unit Tests
```bash
python3 tools/ci/check_test_run.py
```

## How to Contribute
### [Code of Conduct][coc]
We are devoted to ensuring a positive, inclusive, and safe environment for all contributors. Please find our [Code of Conduct][coc] for detailed information.

[coc]: CODE_OF_CONDUCT.md

### Open Source Roadmap

## Discussions
Large discussions and proposals are discussed in [Github Discussions](https://github.com/lynx-family/primjs/discussions)

## [License][license]
PrimJS is Apache licensed, as found in the [LICENSE][license] file.

[license]: LICENSE
