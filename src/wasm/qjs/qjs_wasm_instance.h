// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_INSTANCE_H_
#define SRC_WASM_QJS_QJS_WASM_INSTANCE_H_

#include "common/wasm_store_owner.h"
#include "qjs/qjs_ext_api.h"

namespace primjs::qjs {

class QJSWasmInstance : public QJSWasmWrapperBase {
 public:
  QJSWasmInstance(LEPUSRuntime* rt, LEPUSValue wasm_root,
                  wasm::WasmStoreOwner* store_owner, wasm_instance_t* instance);
  ~QJSWasmInstance();

  static LEPUSClassID class_id() {
    return GetWasmClassId(WasmQJSClass::kInstance);
  }

  static bool Register(LEPUSContext* ctx, LEPUSValue wasm_root);
  static LEPUSValue CallAsConstructor(LEPUSContext* ctx,
                                      LEPUSValueConst new_target, int argc,
                                      LEPUSValueConst* argv);

 private:
  static void DetachInstance(QJSWasmWrapperBase* base, LEPUSRuntime* rt);

  wasm_instance_t* instance_ = nullptr;
};

}  // namespace primjs::qjs

#endif  // SRC_WASM_QJS_QJS_WASM_INSTANCE_H_
