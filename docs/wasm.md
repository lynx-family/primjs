# WebAssembly Support

PrimJS provides initial WebAssembly support through an interoperability layer
that bridges JavaScript engines with WASM runtimes.

The current implementation focuses on practical module loading, instantiation,
and JavaScript-to-WASM interoperability. It is not a complete implementation
of the WebAssembly JavaScript API.

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

- **WASM3**: Based on the open-source wasm3 engine.
- **Prism**: Custom WASM runtime with additional optimizations. **Note**: Prism is not open-sourced; only a stub implementation (`prism_dummy.cc`) is provided for build compatibility and cannot execute WASM.

## Supported Features

### Available Today

PrimJS currently supports the following core flows:

- Binary module construction via `WebAssembly.Module`
- Module instantiation via `WebAssembly.Instance`
- Calling exported WASM functions from JavaScript
- Basic interop with `WebAssembly.Memory`, `WebAssembly.Table`, and
  `WebAssembly.Global`
- Support function, memory, table, and global imports during instantiation

### API Coverage

| API | Coverage | Notes |
|-----|----------|-------|
| **WebAssembly.Module** | ✅ Basic support | Supports constructor-based creation from binary inputs |
| **WebAssembly.Instance** | ✅ Basic support | Supports instantiation with imports |
| **WebAssembly.Memory** | ✅ Basic support | Supports `buffer` and `grow()` |
| **WebAssembly.Table** | ⚠️ Partial support | Supports core table operations, with some advanced behaviors still evolving |
| **WebAssembly.Global** | ✅ Basic support | Supports basic creation and value access |
| **WebAssembly.Function** | ⚠️ Partial support | Exported WASM functions are callable from JS, but full constructor-style support is not available |

### Support Scope

The current implementation is mainly centered around:

- `new WebAssembly.Module(...)`
- `new WebAssembly.Instance(...)`

At this stage, PrimJS provides usable support for common module loading,
instantiation, and basic interoperability scenarios. However, it does not yet
cover the complete WebAssembly JavaScript API surface.

In particular:

- Some static APIs on `WebAssembly`, such as `compile`, `instantiate`,
  `validate`, and streaming variants, are not currently exposed in the
  open-source implementation
- Some reflection and advanced API behaviors are still partial; for example,
  APIs such as `WebAssembly.Module.imports(...)` and
  `WebAssembly.Module.customSections(...)` are not fully available


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
