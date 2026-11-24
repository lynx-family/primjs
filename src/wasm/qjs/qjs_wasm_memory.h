// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_MEMORY_H_
#define SRC_WASM_QJS_QJS_WASM_MEMORY_H_

#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"
#include "qjs/qjs_ext_api.h"

namespace primjs::qjs {

class QJSEnv;

class QJSWasmMemory : public QJSWasmWrapperBase {
 public:
  QJSWasmMemory(LEPUSRuntime* rt, LEPUSValue wasm_root,
                wasm::WasmStoreOwner* store_owner, wasm_memory_t* memory,
                uint32_t maximum, LEPUSValue js_obj);
  ~QJSWasmMemory();

  static LEPUSClassID class_id() {
    return GetWasmClassId(WasmQJSClass::kMemory);
  }

  static QJSWasmMemory* Of(const wasm_memory_t* memory) {
    return memory
               ? static_cast<QJSWasmMemory*>(wasm_memory_get_host_info(memory))
               : nullptr;
  }

  static bool Register(LEPUSContext* ctx, LEPUSValue wasm_root);
  static LEPUSValue CallAsConstructor(LEPUSContext* ctx,
                                      LEPUSValueConst new_target, int argc,
                                      LEPUSValueConst* argv);

  static LEPUSValue GetOrWrapOwnedMemory(LEPUSContext* ctx, QJSEnv* env,
                                         wasm_memory_t* memory);

  wasm_memory_t* memory() const { return memory_; }
  uint32_t maximum() const { return maximum_; }
  size_t pages() const {
    return memory_ ? (wasm_memory_data_size(memory_) / kWasmPageSize) : 0;
  }
  LEPUSValue js_object() const { return js_obj_; }

  static void GCMark(LEPUSRuntime* rt, LEPUSValueConst obj,
                     LEPUS_MarkFunc* mark_func, uint64_t trace_tool);

 private:
  static LEPUSValue WrapOwnedMemory(LEPUSContext* ctx, QJSEnv* env,
                                    wasm_memory_t* memory, uint32_t maximum);
  static void DetachMemory(QJSWasmWrapperBase* base, LEPUSRuntime* rt);
  static LEPUSValue GetBufferCallback(LEPUSContext* ctx,
                                      LEPUSValueConst this_val);
  static LEPUSValue GrowCallback(LEPUSContext* ctx, LEPUSValueConst this_val,
                                 int argc, LEPUSValueConst* argv);

  wasm_memory_t* memory_ = nullptr;
  uint32_t maximum_ = wasm_limits_max_default;
  size_t pages_ = 0;
  pthread_mutex_t buffer_mutex_ = PTHREAD_MUTEX_INITIALIZER;
  LEPUSValue buffer_ = LEPUS_UNDEFINED;
  LEPUSValue js_obj_ = LEPUS_UNDEFINED;
};

}  // namespace primjs::qjs

#endif  // SRC_WASM_QJS_QJS_WASM_MEMORY_H_
