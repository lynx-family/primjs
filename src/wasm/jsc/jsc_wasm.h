// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_WASM_EXT_H_
#define SRC_WASM_JSC_WASM_EXT_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include <atomic>

#include "../common/wasm_type.h"

namespace primjs {
class InteropRuntime;

namespace jsc {
class JSCWasmExt {
 public:
  static void RegisterWebAssembly(JSContextRef ctx,
                                  std::atomic_bool* ctx_invalid,
                                  WasmRuntimeType runtime_type);
  static void RegisterWebAssembly(JSContextRef ctx,
                                  std::atomic_bool* ctx_invalid);

  static constexpr const char* kWasmName = "WebAssembly";
  static constexpr const char* kModuleName = "Module";
  static constexpr const char* kGlobalName = "Global";
  static constexpr const char* kInstanceName = "Instance";
  static constexpr const char* kMemoryName = "Memory";
  static constexpr const char* kTableName = "Table";

 protected:
  static JSObjectRef CreateWasmObject(JSContextRef ctx, InteropRuntime* interop,
                                      std::atomic_bool* ctx_invalid);
  static void Finalize(JSObjectRef obj);

 private:
  static JSClassRef InitWasmClassRef();
  static JSClassRef wasm_class_ref();
};

}  // namespace jsc
}  // namespace primjs

#endif  // SRC_WASM_JSC_WASM_EXT_H_
