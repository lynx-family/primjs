// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_GLOBAL_H_
#define SRC_WASM_QJS_QJS_WASM_GLOBAL_H_

#include "common/one_of.h"
#include "common/wasm_type.h"
#include "common/wasm_utils.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Global;
class PrismGlobal;
}  // namespace wasm

using WasmGlobalRef = OneOf<wasm::Wasm3Global *, wasm::PrismGlobal *>;

namespace qjs {
class QJSWasmGlobal {
 public:
  QJSWasmGlobal(WasmGlobalRef global, InteropRuntime *interop);
  ~QJSWasmGlobal();

  static LEPUSValue CreateConstructor(LEPUSContext *ctx, LEPUSValue wasm_root);

  static LEPUSValue CreateJSObject(LEPUSContext *ctx, InteropRuntime *interop,
                                   WasmGlobalRef global);

  static inline LEPUSClassID class_id() {
    static LEPUSClassID class_id = LEPUS_NewClassID(&class_id);
    return class_id;
  }

  WasmGlobalRef &global() { return global_; }

 protected:
  static void Finalize(LEPUSRuntime *rt, LEPUSValue obj);

  static LEPUSValue CreatePrototype(LEPUSContext *ctx, LEPUSClassID class_id_);

  static LEPUSValue CallAsConstructor(LEPUSContext *ctx,
                                      LEPUSValueConst new_target, int argc,
                                      LEPUSValueConst *argv);

  static LEPUSValue GetValueCallback(LEPUSContext *ctx,
                                     LEPUSValueConst this_val);

  static LEPUSValue SetValueCallback(LEPUSContext *ctx,
                                     LEPUSValueConst this_val,
                                     LEPUSValueConst val);

  static LEPUSValue ValueOfCallback(LEPUSContext *ctx, LEPUSValueConst this_val,
                                    int argc, LEPUSValueConst *argv);

  static LEPUSValue JsToValue(LEPUSContext *ctx, double *val,
                              LEPUSValueConst js_val, ValueType type);

 private:
  OWNER WasmGlobalRef global_;

  BORROWER InteropRuntime *interop_runtime_;
};

}  // namespace qjs
}  // namespace primjs

#endif  // SRC_WASM_QJS_QJS_WASM_GLOBAL_H_
