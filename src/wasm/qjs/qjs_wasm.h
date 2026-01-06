// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_H_
#define SRC_WASM_QJS_QJS_WASM_H_

#include <atomic>

#include "../common/wasm_type.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif

namespace primjs::qjs {
class QJSWebAssembly {
 public:
  static void RegisterWebAssembly(
      LEPUSContext *ctx, std::atomic_bool *ctx_invalid,
      WasmRuntimeType runtime_type = WasmRuntimeType::WASM3);
  static LEPUSClassID class_id() {
    static LEPUSClassID class_id = LEPUS_NewClassID(&class_id);
    return class_id;
  }

  static void GCMark(LEPUSRuntime *rt, LEPUSValueConst obj,
                     LEPUS_MarkFunc *mark_func, uint64_t trace_tool);

 private:
  static LEPUSValue CreateWasmObject(LEPUSContext *ctx);
  static void Finalize(LEPUSRuntime *rt, LEPUSValue obj);
};

}  // namespace primjs::qjs

#endif  // SRC_WASM_QJS_QJS_WASM_H_
