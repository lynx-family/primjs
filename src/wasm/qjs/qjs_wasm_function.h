// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_FUNCTION_H_
#define SRC_WASM_QJS_QJS_WASM_FUNCTION_H_

#include "common/one_of.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Function;
class PrismFunction;
}  // namespace wasm

using WasmFunctionRef = OneOf<wasm::Wasm3Function *, wasm::PrismFunction *>;

namespace qjs {
class QJSWasmFunction {
 public:
  QJSWasmFunction(WasmFunctionRef function, InteropRuntime *interop);
  ~QJSWasmFunction();

  static LEPUSValue CreateJSObject(LEPUSContext *ctx, InteropRuntime *interop,
                                   WasmFunctionRef function);

  static LEPUSValue CreatePrototype(LEPUSContext *ctx);

  static LEPUSValue CreateConstructor(LEPUSContext *ctx, LEPUSValue wasm_root);

  static LEPUSValue CallAsConstructor(LEPUSContext *ctx,
                                      LEPUSValueConst constructor, int argc,
                                      LEPUSValueConst *argv);

  static inline LEPUSClassID class_id() {
    static LEPUSClassID class_id = LEPUS_NewClassID(&class_id);
    return class_id;
  }

  WasmFunctionRef &function() { return function_; }

 protected:
  static void Finalize(LEPUSRuntime *rt, LEPUSValue obj);

  static LEPUSValue CallWasmFunction(LEPUSContext *ctx,
                                     LEPUSValueConst func_obj,
                                     LEPUSValueConst this_val, int argc,
                                     LEPUSValueConst *argv, int flags);

 private:
  // Weak ref here
  OWNER WasmFunctionRef function_;

  BORROWER InteropRuntime *interop_runtime_;
};

}  // namespace qjs
}  // namespace primjs

#endif  // SRC_WASM_QJS_QJS_WASM_FUNCTION_H_
