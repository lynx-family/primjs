// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_WASM_H_
#define SRC_WASM_JSC_WASM_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include <atomic>

namespace primjs::jsc {

class JSCEnv;

class JSCWasmExt {
 public:
  static constexpr const char* kWasmName = "WebAssembly";
  static constexpr const char* kModuleName = "Module";
  static constexpr const char* kInstanceName = "Instance";
  static constexpr const char* kMemoryName = "Memory";
  static constexpr const char* kTableName = "Table";

  static void RegisterWebAssembly(JSContextRef ctx,
                                  std::atomic_bool* ctx_invalid = nullptr);
  static void PrepareForContextRelease(JSContextRef ctx);

#if defined(QJS_UNITTEST)
  static bool SetCurrentPrismReleaseCountForTesting(
      JSContextRef ctx, std::atomic_int* release_count);
#endif

  static JSClassRef wasm_class_ref();

 private:
  static JSClassRef InitWasmClassRef();
  static void Finalize(JSObjectRef obj);
};

}  // namespace primjs::jsc

#endif  // SRC_WASM_JSC_WASM_H_
