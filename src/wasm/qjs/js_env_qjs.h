// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_JS_ENV_QJS_H_
#define SRC_WASM_QJS_JS_ENV_QJS_H_

#include <pthread.h>

#include <atomic>
#include <cstddef>
#include <cstdint>

#include "common/js_type.h"
#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"
#include "gc/trace-gc.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif

namespace primjs::qjs {

class QJSEnv {
 public:
  QJSEnv(LEPUSContext* ctx, std::atomic_bool* invalid,
         wasm::WasmStoreOwner* store_owner);
  ~QJSEnv();

  void Finalize();

  LEPUSContext* js_ctx() const { return js_ctx_; }
  LEPUSRuntime* js_rt() const { return js_rt_; }
  wasm::WasmStoreOwner* store_owner() const { return store_owner_; }
  wasm_store_t* wasm_store() const {
    return store_owner_ ? store_owner_->store() : nullptr;
  }

  bool IsInvalid() const {
    return !store_owner_ ||
           (ctx_invalid_ && ctx_invalid_->load(std::memory_order_acquire));
  }

  void SetWasmRoot(LEPUSValue wasm_root) { wasm_root_ = wasm_root; }
  LEPUSValue wasm_root() const {
    return root_invalidated_ ? LEPUS_UNDEFINED : wasm_root_;
  }
  LEPUSValue raw_wasm_root_object() const { return wasm_root_; }
  void InvalidateWasmRoot() { root_invalidated_ = true; }

  void StashWasmException(LEPUSValue exception);
  bool TakeWasmException(LEPUSValue* exception);

  uint64_t BeginImportTransaction();
  void RetainImportCallback(LEPUSValue fn, uint64_t transaction,
                            const void* bridge_key = nullptr);
  void ReleaseImportCallback(const void* bridge_key);
  size_t RollbackImportTransaction(uint64_t transaction);
  void FinishImportTransaction(uint64_t transaction) {
    (void)RollbackImportTransaction(transaction);
  }
#if defined(QJS_UNITTEST)
  size_t ActiveImportCallbackCountForTesting();
#endif

  void ReportOuterSize(size_t bytes);
  void Mark(LEPUS_MarkFunc* mark_func, LEPUSRuntime* rt,
            uint64_t trace_tool = 0);

  static inline bool ToWasmValue(LEPUSContext* ctx, LEPUSValueConst value,
                                 wasm_valkind_t kind, wasm_val_t* out) {
    out->kind = kind;
    if (kind == WASM_I32 && LEPUS_VALUE_IS_INT(value)) {
      out->of.i32 = LEPUS_VALUE_GET_INT(value);
      return true;
    }
    if (kind == WASM_F64) {
      if (LEPUS_VALUE_IS_FLOAT64(value)) {
        out->of.f64 = LEPUS_VALUE_GET_FLOAT64(value);
        return true;
      }
      if (LEPUS_VALUE_IS_INT(value)) {
        out->of.f64 = LEPUS_VALUE_GET_INT(value);
        return true;
      }
    }
    if (kind == WASM_F32) {
      if (LEPUS_VALUE_IS_FLOAT64(value)) {
        out->of.f32 = static_cast<float>(LEPUS_VALUE_GET_FLOAT64(value));
        return true;
      }
      if (LEPUS_VALUE_IS_INT(value)) {
        out->of.f32 = static_cast<float>(LEPUS_VALUE_GET_INT(value));
        return true;
      }
    }
    return ToWasmValueSlow(ctx, value, kind, out);
  }

  static inline LEPUSValue FromWasmValue(LEPUSContext* ctx,
                                         const wasm_val_t& value) {
    switch (value.kind) {
      case WASM_I32:
        return LEPUS_NewInt32(ctx, value.of.i32);
      case WASM_F64:
        return LEPUS_NewFloat64(ctx, value.of.f64);
      case WASM_F32:
        return LEPUS_NewFloat64(ctx, static_cast<double>(value.of.f32));
      default:
        return FromWasmValueSlow(ctx, value);
    }
  }

  static bool ToWasmValueSlow(LEPUSContext* ctx, LEPUSValueConst value,
                              wasm_valkind_t kind, wasm_val_t* out);
  static LEPUSValue FromWasmValueSlow(LEPUSContext* ctx,
                                      const wasm_val_t& value);
  LEPUSValue ThrowTrap(wasm_trap_t* trap, const char* code);

 private:
  struct ImportCallbackRoot {
    LEPUSValue value;
    uint64_t transaction;
    const void* bridge_key;
  };

  LEPUSRuntime* js_rt_ = nullptr;
  LEPUSContext* js_ctx_ = nullptr;
  std::atomic_bool* ctx_invalid_ = nullptr;
  wasm::WasmStoreOwner* store_owner_ = nullptr;
  LEPUSValue wasm_root_ = LEPUS_UNDEFINED;
  pthread_mutex_t gc_mark_mutex_ = PTHREAD_MUTEX_INITIALIZER;
  ImportCallbackRoot* import_callbacks_ = nullptr;
  size_t callback_count_ = 0;
  size_t callback_cap_ = 0;
  uint64_t next_import_transaction_ = 0;
  LEPUSValue pending_wasm_exception_ = LEPUS_UNDEFINED;
  bool has_pending_wasm_exception_ = false;
  bool finalized_ = false;
  bool root_invalidated_ = false;
};

}  // namespace primjs::qjs

#endif  // SRC_WASM_QJS_JS_ENV_QJS_H_
