# WebAssembly Support

PrimJS provides WebAssembly support through an interoperability layer that bridges JavaScript engines with WASM runtimes.

## Architecture

The WASM implementation follows a layered architecture:

```
┌─────────────────────────────────────────────────────────┐
│                    WebAssembly API                       │
│  (Module, Instance, Memory, Table, Global, Function)    │
└─────────────────────────────────────────────────────────┘
                           │
┌─────────────────────────────────────────────────────────┐
│                    InteropRuntime                        │
│           (Manages JS Env + WASM Runtime)               │
└─────────────────────────────────────────────────────────┘
          │                              │
┌─────────────────────┐      ┌──────────────────────────┐
│    JS Environment   │      │      WASM Runtime        │
│  ┌───────┐ ┌───────┐│      │  ┌───────┐ ┌───────────┐│
│  │ QJSEnv│ │JSCEnv ││      │  │Wasm3  │ │  Prism    ││
│  └───────┘ └───────┘│      │  │Runtime│ │  Runtime  ││
└─────────────────────┘      │  └───────┘ └───────────┘│
                             └──────────────────────────┘
```

### Key Components

| Component | Location | Description |
|-----------|----------|-------------|
| `InteropRuntime` | `common/interop_runtime.h` | Bridges JS environment and WASM runtime |
| `QJSWasm*` | `qjs/` | QuickJS bindings for WASM objects |
| `JSCWasm*` | `jsc/` | JavaScriptCore bindings (iOS/macOS) |
| `Wasm3Runtime` | `runtime/wasm3/` | wasm3-based WASM runtime |
| `PrismRuntime` | `runtime/prism/` | Prism runtime integration code |

### WASM Runtimes

- **WASM3**: Lightweight interpreter using wasm3 library. Fully supported.
- **Prism**: Custom WASM runtime with additional optimizations. **Note**: Prism is not open-sourced; only a stub implementation (`prism_dummy.cc`) is provided for build compatibility and cannot execute WASM.

## Supported Features

### WebAssembly Objects

| Object | Support | Notes |
|--------|---------|-------|
| **WebAssembly.Module** | ✅ Full | Compiled WASM module |
| **WebAssembly.Instance** | ✅ Full | Instantiated module with exports |
| **WebAssembly.Memory** | ✅ Full | Linear memory buffer |
| **WebAssembly.Table** | ✅ Full | Function reference table |
| **WebAssembly.Global** | ✅ Full | Global variables |
| **WebAssembly.Function** | ⚠️ Partial | Can call exported functions, but cannot create new ones via constructor |


## Building and Running

### Build qjs-cli

```bash
sh tools/qjs-cli/build.sh
```

The executable will be at `out/default/qjs-cli`.

### Usage Example

Create a JavaScript file `test_wasm.js`:

```javascript
// Simple WASM module that exports an add function
// Equivalent WAT:
// (module
//   (func $add (param i32 i32) (result i32)
//     local.get 0
//     local.get 1
//     i32.add)
//   (export "add" (func $add)))

const wasmBytes = new Uint8Array([
  0x00, 0x61, 0x73, 0x6d,  // magic number
  0x01, 0x00, 0x00, 0x00,  // version
  0x01, 0x07, 0x01, 0x60, 0x02, 0x7f, 0x7f, 0x01, 0x7f,  // type section
  0x03, 0x02, 0x01, 0x00,  // function section
  0x07, 0x07, 0x01, 0x03, 0x61, 0x64, 0x64, 0x00, 0x00,  // export section
  0x0a, 0x09, 0x01, 0x07, 0x00, 0x20, 0x00, 0x20, 0x01, 0x6a, 0x0b  // code section
]);

const module = new WebAssembly.Module(wasmBytes);
const instance = new WebAssembly.Instance(module);

// Call exported function
console.log(instance.exports.add(1, 2));  // Returns 3
```

Run with qjs-cli:

```bash
./out/default/qjs-cli test_wasm.js
```

## Testing

Use the dedicated test script:

```bash
sh testing/wasm/wasm_run.sh
```

Test categories:
- `basic-tests/` - Core functionality tests
- `js-api/` - JavaScript API conformance tests
