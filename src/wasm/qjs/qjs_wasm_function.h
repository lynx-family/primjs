// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_FUNCTION_H_
#define SRC_WASM_QJS_QJS_WASM_FUNCTION_H_

#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"
#include "qjs/qjs_ext_api.h"

namespace primjs::qjs {

class QJSEnv;

class QJSWasmFunction : public QJSWasmWrapperBase {
 public:
  QJSWasmFunction(LEPUSRuntime* rt, LEPUSValue wasm_root, QJSEnv* env,
                  wasm_func_t* func, LEPUSValue js_obj);
  ~QJSWasmFunction();

  static LEPUSClassID class_id() {
    return GetWasmClassId(WasmQJSClass::kFunction);
  }

  static QJSWasmFunction* Of(const wasm_func_t* func) {
    return func ? static_cast<QJSWasmFunction*>(wasm_func_get_host_info(func))
                : nullptr;
  }

  static LEPUSValue CreatePrototype(LEPUSContext* ctx);

  static LEPUSValue WrapOwnedFunc(LEPUSContext* ctx, QJSEnv* env,
                                  wasm_func_t* func);

  static LEPUSValue GetOrWrapOwnedFunc(LEPUSContext* ctx, QJSEnv* env,
                                       wasm_func_t* func);

  static wasm_func_t* CreateImportBridge(QJSEnv* env, LEPUSValue js_fn,
                                         const wasm_functype_t* expected_type,
                                         uint64_t transaction);

  wasm_func_t* function() const { return func_; }
  LEPUSValue js_object() const { return js_obj_; }
  bool EnsureSignature() { return sig_.Ensure(func_); }
  const WasmSignature& signature() const { return sig_; }

  static LEPUSValue CallWasmFunction(LEPUSContext* ctx,
                                     LEPUSValueConst func_obj,
                                     LEPUSValueConst this_val, int argc,
                                     LEPUSValueConst* argv, int flags);

 private:
  static void DetachFunc(QJSWasmWrapperBase* base, LEPUSRuntime* rt);
  LEPUSValue CallWith(LEPUSContext* ctx, int argc, LEPUSValueConst* argv,
                      wasm_val_t* values);

  wasm_func_t* func_ = nullptr;
  LEPUSValue js_obj_ = LEPUS_UNDEFINED;
  WasmSignature sig_;
};

}  // namespace primjs::qjs

#endif  // SRC_WASM_QJS_QJS_WASM_FUNCTION_H_
