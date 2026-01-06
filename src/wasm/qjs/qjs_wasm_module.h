// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_MODULE_H_
#define SRC_WASM_QJS_QJS_WASM_MODULE_H_

#include "common/one_of.h"
#include "common/wasm_type.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Module;
class PrismModule;
}  // namespace wasm

using WasmModuleRef = OneOf<wasm::Wasm3Module *, wasm::PrismModule *>;

namespace qjs {
class QJSWasmModule {
 public:
  QJSWasmModule(InteropRuntime *interop, WasmModuleRef module_inst);
  ~QJSWasmModule();

  static LEPUSValue CreateConstructor(LEPUSContext *ctx, LEPUSValue wasm_root);

  static LEPUSClassID class_id() {
    static LEPUSClassID class_id = LEPUS_NewClassID(&class_id);
    return class_id;
  }

  static void Finalize(LEPUSRuntime *rt, LEPUSValue obj);

  static void GCMark(LEPUSRuntime *rt, LEPUSValueConst obj,
                     LEPUS_MarkFunc *mark_func, uint64_t trace_tool);

  static LEPUSValue CallAsConstructor(LEPUSContext *ctx,
                                      LEPUSValueConst new_target, int argc,
                                      LEPUSValueConst *argv);

  static LEPUSValue CustomSections(LEPUSContext *ctx, LEPUSValueConst this_val,
                                   int argc, LEPUSValueConst *argv);

  static LEPUSValue Exports(LEPUSContext *ctx, LEPUSValueConst this_val,
                            int argc, LEPUSValueConst *argv);

  static LEPUSValue Imports(LEPUSContext *ctx, LEPUSValueConst this_val,
                            int argc, LEPUSValueConst *argv);

  static LEPUSValue SupportBase64(LEPUSContext *ctx, LEPUSValueConst this_val);

  static uint8_t *GetBufferFromBytes(LEPUSContext *ctx, LEPUSValueConst target,
                                     size_t &len, WasmResult &result);

  void set_bytes(LEPUSContext *ctx, LEPUSValue bytes) {
    if (!LEPUS_IsGCMode(ctx)) {
      LEPUS_FreeValue(ctx, bytes_);
    }
    bytes_ = bytes;
  }

  WasmModuleRef &module() { return module_; }

 private:
  OWNER LEPUSValue bytes_ = LEPUS_UNDEFINED;

  OWNER WasmModuleRef module_;

  BORROWER InteropRuntime *interop_runtime_;
};

}  // namespace qjs
}  // namespace primjs

#endif  // SRC_WASM_QJS_QJS_WASM_MODULE_H_
