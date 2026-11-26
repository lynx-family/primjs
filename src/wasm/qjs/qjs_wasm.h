// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_H_
#define SRC_WASM_QJS_QJS_WASM_H_

#include <atomic>
#include <cstddef>

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif

namespace primjs::qjs {

class QJSEnv;

class QJSWebAssembly {
 public:
  static void RegisterWebAssembly(LEPUSContext* ctx,
                                  std::atomic_bool* ctx_invalid = nullptr);

#if defined(QJS_UNITTEST)
  static int LivePrismInstancesForTesting();
  static int LivePrismModulesForTesting();
  static void FailPrismExportAfterForTesting(int exports);
  static void InvalidateWasmRootForTesting(LEPUSContext* ctx);
  static int GetCurrentPrismRefCountForTesting(LEPUSContext* ctx);
  static bool SetCurrentPrismReleaseCountForTesting(
      LEPUSContext* ctx, std::atomic_int* release_count);
  static void ResetPrismImportBindingCountersForTesting();
  static size_t PrismImportDescriptorEnumerationsForTesting();
  static size_t PrismRolledBackImportFunctionsForTesting();
  static size_t PrismRolledBackImportCallbackRootsForTesting();
  static size_t ActivePrismImportCallbackRootsForTesting(LEPUSContext* ctx);
#endif

  static LEPUSClassID class_id();

  static QJSEnv* GetEnvFromRoot(LEPUSValueConst wasm_root);

  static void GCMark(LEPUSRuntime* rt, LEPUSValueConst obj,
                     LEPUS_MarkFunc* mark_func, uint64_t trace_tool);

 private:
  static LEPUSValue CreateWasmObject(LEPUSContext* ctx);
  static void Finalize(LEPUSRuntime* rt, LEPUSValue obj);
};

}  // namespace primjs::qjs

#endif  // SRC_WASM_QJS_QJS_WASM_H_
