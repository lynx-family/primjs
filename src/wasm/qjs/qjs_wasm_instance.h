// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_INSTANCE_H_
#define SRC_WASM_QJS_QJS_WASM_INSTANCE_H_

#include "common/one_of.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Instance;
class PrismInstance;
}  // namespace wasm

using WasmInstanceRef = OneOf<wasm::Wasm3Instance*, wasm::PrismInstance*>;

namespace qjs {
class QJSWasmInstance {
 public:
  QJSWasmInstance(WasmInstanceRef instance, InteropRuntime* interop);
  ~QJSWasmInstance();

  static LEPUSValue CreateConstructor(LEPUSContext* ctx, LEPUSValue wasm_root);

  static LEPUSValue CallAsConstructor(LEPUSContext* ctx,
                                      LEPUSValueConst new_target, int argc,
                                      LEPUSValueConst* argv);

  static void Finalize(LEPUSRuntime* rt, LEPUSValue obj);
  static LEPUSClassID class_id() {
    static LEPUSClassID class_id = LEPUS_NewClassID(&class_id);
    return class_id;
  }

 private:
  // instance may always exists because of exported values
  BORROWER WasmInstanceRef instance_;

  BORROWER InteropRuntime* interop_runtime_;
};

}  // namespace qjs
}  // namespace primjs

#endif  // SRC_WASM_QJS_QJS_WASM_INSTANCE_H_
