// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_MODULE_H_
#define SRC_WASM_QJS_QJS_WASM_MODULE_H_

#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"
#include "qjs/qjs_ext_api.h"

namespace primjs::qjs {

class QJSEnv;

class QJSWasmModule : public QJSWasmWrapperBase {
 public:
  QJSWasmModule(LEPUSRuntime* rt, LEPUSValue wasm_root,
                wasm::WasmStoreOwner* store_owner, wasm_module_t* module);
  ~QJSWasmModule();

  static LEPUSClassID class_id() {
    return GetWasmClassId(WasmQJSClass::kModule);
  }

  static bool Register(LEPUSContext* ctx, LEPUSValue wasm_root);
  static LEPUSValue CallAsConstructor(LEPUSContext* ctx,
                                      LEPUSValueConst new_target, int argc,
                                      LEPUSValueConst* argv);

  wasm_module_t* module() const { return module_; }
  const wasm_importtype_vec_t* ImportTypes();

 private:
  static void DetachModule(QJSWasmWrapperBase* base, LEPUSRuntime* rt);
  static LEPUSValue SupportBase64(LEPUSContext* ctx, LEPUSValueConst this_val);
  static uint8_t* GetBufferFromBytes(LEPUSContext* ctx,
                                     LEPUSValueConst buffer_source,
                                     size_t& byte_length, WasmResult& result);

  wasm_module_t* module_ = nullptr;
  wasm_importtype_vec_t import_types_ = {0, nullptr};
  bool imports_loaded_ = false;
};

}  // namespace primjs::qjs

#endif  // SRC_WASM_QJS_QJS_WASM_MODULE_H_
