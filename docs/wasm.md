# WebAssembly Support

PrimJS provides WebAssembly support by binding JavaScript engines directly to
the standard WebAssembly C API (`wasm.h`).

The implementation focuses on a lean, production-focused JS-to-Wasm binding
covering module loading, instantiation, function/memory/table interop, and
deterministic resource reclamation when a JavaScript context exits.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    WebAssembly API                       │
│         (Module, Instance, Memory, Table, ...)          │
└─────────────────────────────────────────────────────────┘
                           │
┌──────────────────────────┴──────────────────────────────┐
│                 Direct wasm.h Bindings                   │
│            (qjs/ for QuickJS, jsc/ for JSC)             │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────┴──────────────────────────────┐
│             WasmStoreOwner + C API Dispatch             │
│   (wasm_store_owner.h, wasm_c_api_dispatch.{h,cc})      │
└──────────────────────────┬──────────────────────────────┘
                           │
┌──────────────────────────┴──────────────────────────────┐
│                Prism / wasm.h Runtime                   │
└─────────────────────────────────────────────────────────┘
```

### Key Components

| Component | Location | Description |
|-----------|----------|-------------|
| `WasmStoreOwner` | `common/wasm_store_owner.h` | Owns the `wasm_engine_t` / `wasm_store_t` and tracks live handles for unified context-exit cleanup |
| `wasm_c_api_dispatch` | `common/wasm_c_api_dispatch.{h,cc}` | Direct or dynamically bound `wasm.h` C API table |
| `QJSWasm*` | `qjs/` | QuickJS WebAssembly bindings (RC and Tracing GC) |
| `JSCWasm*` | `jsc/` | JavaScriptCore WebAssembly bindings (iOS/macOS) |
| `prism_dummy.cc` | `prism/prism_dummy.cc` | Linkable `wasm_c_api.h` stub when Prism is not linked |

## Supported Features

### Available Today

- Binary and base64 module construction via `WebAssembly.Module` (`{encode: "base64"}` and `WebAssembly.Module.supportBase64`)
- Module instantiation via `WebAssembly.Instance`
- Calling exported Wasm functions from JavaScript (including `i64` BigInt and multi-value returns)
- Interoperability with `WebAssembly.Memory` and `WebAssembly.Table` (`funcref`/`anyfunc`)
- Function, memory, table, and immutable numeric (`i32`, `i64`, `f32`, `f64`) global imports during instantiation, plus `{value}` snapshots for exported globals
- Deterministic reclamation of Wasm stores, instances, modules, and linear memory buffers on context exit

> Note: Promise-based static helpers (`WebAssembly.compile`, `WebAssembly.instantiate`, and `WebAssembly.validate`), `WebAssembly.Global` / `WebAssembly.Function` constructors, and `WebAssembly.Module.{imports,exports,customSections}` are intentionally omitted to keep the built-in JS binding minimal.

### API Coverage

| API | Coverage | Notes |
|-----|----------|-------|
| **WebAssembly.Module** | Basic support | Supports constructor-based creation from binary or base64 inputs (`supportBase64`) |
| **WebAssembly.Instance** | Basic support | Supports instantiation with function, memory, table, and immutable numeric global imports; exported globals expose `{value}` |
| **WebAssembly.Memory** | Basic support | Supports `buffer` and `grow()` |
| **WebAssembly.Table** | Partial support | Supports `funcref`/`anyfunc` table `get`, `set`, `grow`, and `length`. When a long-lived `Table` is imported across multiple instantiations, each instance's JS import closures remain retained until that `Table` (or the context) is released |
| **Exported Functions** | Basic support | Exported Wasm functions are callable from JS with `i32`, `i64` (`BigInt`), `f32`, `f64`, and multi-value returns |

## Building and Running

### Build qjs-cli

```bash
sh tools/qjs-cli/build.sh
```

The executable will be at `out/default/qjs-cli`.

### Usage Example

Create a JavaScript file `test_wasm.js`:

```javascript
const wasmBytes = new Uint8Array([
  0x00, 0x61, 0x73, 0x6d,
  0x01, 0x00, 0x00, 0x00,
  0x01, 0x07, 0x01, 0x60, 0x02, 0x7f, 0x7f, 0x01, 0x7f,
  0x03, 0x02, 0x01, 0x00,
  0x07, 0x07, 0x01, 0x03, 0x61, 0x64, 0x64, 0x00, 0x00,
  0x0a, 0x09, 0x01, 0x07, 0x00, 0x20, 0x00, 0x20, 0x01, 0x6a, 0x0b
]);

const module = new WebAssembly.Module(wasmBytes);
const instance = new WebAssembly.Instance(module);

console.log(instance.exports.add(1, 2));  // Returns 3
```

Run with `qjs-cli` (when linked with a `wasm.h` engine):

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
