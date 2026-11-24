// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/js_env_qjs.h"

#include <climits>
#include <cstdlib>
#include <cstring>

#include "qjs/qjs_ext_api.h"
#include "qjs/qjs_wasm_function.h"

namespace primjs::qjs {

namespace {
bool QJSToDouble(LEPUSContext* ctx, LEPUSValueConst value, double* out) {
  if (LEPUS_VALUE_IS_FLOAT64(value)) {
    *out = LEPUS_VALUE_GET_FLOAT64(value);
    return true;
  }
  if (LEPUS_VALUE_IS_INT(value)) {
    *out = LEPUS_VALUE_GET_INT(value);
    return true;
  }
  return LEPUS_ToFloat64(ctx, out, value) == 0;
}
}  // namespace

WASM_MINSIZE QJSEnv::QJSEnv(LEPUSContext* ctx, std::atomic_bool* invalid,
                            wasm::WasmStoreOwner* store_owner)
    : js_rt_(LEPUS_GetRuntime(ctx)),
      js_ctx_(ctx),
      ctx_invalid_(invalid),
      store_owner_(store_owner) {
  QJSWasmFunction::CreatePrototype(ctx);
}

QJSEnv::~QJSEnv() {
  Finalize();
  pthread_mutex_destroy(&gc_mark_mutex_);
}

WASM_MINSIZE void QJSEnv::Finalize() {
  pthread_mutex_lock(&gc_mark_mutex_);
  if (finalized_) {
    pthread_mutex_unlock(&gc_mark_mutex_);
    return;
  }
  finalized_ = true;
  ImportCallbackRoot* callbacks = import_callbacks_;
  const size_t count = callback_count_;
  import_callbacks_ = nullptr;
  callback_count_ = 0;
  callback_cap_ = 0;
  LEPUSValue pending = LEPUS_UNDEFINED;
  bool had_pending = false;
  if (has_pending_wasm_exception_) {
    pending = pending_wasm_exception_;
    pending_wasm_exception_ = LEPUS_UNDEFINED;
    has_pending_wasm_exception_ = false;
    had_pending = true;
  }
  pthread_mutex_unlock(&gc_mark_mutex_);

  if (!LEPUS_IsGCModeRT(js_rt_)) {
    for (size_t i = 0; i < count; ++i) {
      LEPUS_FreeValueRT(js_rt_, callbacks[i].value);
    }
    if (had_pending) {
      LEPUS_FreeValueRT(js_rt_, pending);
    }
  }
  std::free(callbacks);
}

WASM_MINSIZE void QJSEnv::StashWasmException(LEPUSValue exception) {
  LEPUSValue previous = LEPUS_UNDEFINED;
  bool had_previous = false;
  const bool gc_mode = LEPUS_IsGCModeRT(js_rt_);
  if (gc_mode && js_ctx_) {
    LEPUS_WriteBarrierNoStore(js_ctx_, exception);
  }
  pthread_mutex_lock(&gc_mark_mutex_);
  if (has_pending_wasm_exception_ && !gc_mode) {
    previous = pending_wasm_exception_;
    had_previous = true;
  }
  pending_wasm_exception_ = exception;
  has_pending_wasm_exception_ = true;
  pthread_mutex_unlock(&gc_mark_mutex_);
  if (had_previous) {
    LEPUS_FreeValueRT(js_rt_, previous);
  }
}

bool QJSEnv::TakeWasmException(LEPUSValue* exception) {
  if (!exception) return false;
  pthread_mutex_lock(&gc_mark_mutex_);
  if (!has_pending_wasm_exception_) {
    pthread_mutex_unlock(&gc_mark_mutex_);
    return false;
  }
  *exception = pending_wasm_exception_;
  pending_wasm_exception_ = LEPUS_UNDEFINED;
  has_pending_wasm_exception_ = false;
  pthread_mutex_unlock(&gc_mark_mutex_);
  return true;
}

uint64_t QJSEnv::BeginImportTransaction() {
  ++next_import_transaction_;
  if (next_import_transaction_ == 0) ++next_import_transaction_;
  return next_import_transaction_;
}

WASM_MINSIZE void QJSEnv::RetainImportCallback(LEPUSValue fn,
                                               uint64_t transaction,
                                               const void* bridge_key) {
  const bool gc_mode = LEPUS_IsGCModeRT(js_rt_);
  if (gc_mode && js_ctx_) {
    LEPUS_WriteBarrierNoStore(js_ctx_, fn);
  }
  LEPUSValue kept = gc_mode ? fn : LEPUS_DupValueRT(js_rt_, fn);
  pthread_mutex_lock(&gc_mark_mutex_);
  if (callback_count_ == callback_cap_) {
    const size_t new_cap = callback_cap_ ? callback_cap_ * 2 : 8;
    auto* grown = static_cast<ImportCallbackRoot*>(
        std::realloc(import_callbacks_, new_cap * sizeof(ImportCallbackRoot)));
    if (!grown) {
      pthread_mutex_unlock(&gc_mark_mutex_);
      if (!gc_mode) LEPUS_FreeValueRT(js_rt_, kept);
      return;
    }
    import_callbacks_ = grown;
    callback_cap_ = new_cap;
  }
  import_callbacks_[callback_count_++] = {kept, transaction, bridge_key};
  pthread_mutex_unlock(&gc_mark_mutex_);
}

WASM_MINSIZE void QJSEnv::ReleaseImportCallback(const void* bridge_key) {
  if (!bridge_key) return;
  LEPUSValue to_free = LEPUS_UNDEFINED;
  bool should_free = false;
  const bool gc_mode = LEPUS_IsGCModeRT(js_rt_);
  pthread_mutex_lock(&gc_mark_mutex_);
  if (!finalized_) {
    for (size_t i = 0; i < callback_count_; ++i) {
      if (import_callbacks_[i].bridge_key == bridge_key) {
        if (!gc_mode) {
          to_free = import_callbacks_[i].value;
          should_free = true;
        }
        import_callbacks_[i] = import_callbacks_[--callback_count_];
        break;
      }
    }
  }
  pthread_mutex_unlock(&gc_mark_mutex_);
  if (should_free) {
    LEPUS_FreeValueRT(js_rt_, to_free);
  }
}

#if defined(QJS_UNITTEST)
size_t QJSEnv::ActiveImportCallbackCountForTesting() {
  pthread_mutex_lock(&gc_mark_mutex_);
  const size_t n = callback_count_;
  pthread_mutex_unlock(&gc_mark_mutex_);
  return n;
}
#endif

WASM_MINSIZE size_t QJSEnv::RollbackImportTransaction(uint64_t transaction) {
  const bool gc_mode = LEPUS_IsGCModeRT(js_rt_);
  pthread_mutex_lock(&gc_mark_mutex_);
  LEPUSValue* to_free = nullptr;
  if (!gc_mode && callback_count_ > 0) {
    to_free = static_cast<LEPUSValue*>(
        std::malloc(callback_count_ * sizeof(LEPUSValue)));
  }
  size_t rolled_back = 0;
  size_t free_count = 0;
  size_t dst = 0;
  for (size_t i = 0; i < callback_count_; ++i) {
    if (import_callbacks_[i].transaction != transaction) {
      import_callbacks_[dst++] = import_callbacks_[i];
      continue;
    }
    if (!gc_mode && to_free) {
      to_free[free_count++] = import_callbacks_[i].value;
    }
    ++rolled_back;
  }
  callback_count_ = dst;
  pthread_mutex_unlock(&gc_mark_mutex_);
  for (size_t i = 0; i < free_count; ++i) {
    LEPUS_FreeValueRT(js_rt_, to_free[i]);
  }
  std::free(to_free);
  return rolled_back;
}

void QJSEnv::ReportOuterSize(size_t bytes) {
  constexpr size_t kMax = static_cast<size_t>(INT32_MAX);
  if (js_rt_ != nullptr && bytes != 0) {
    UpdateOuterObjSize(js_rt_, static_cast<int>(bytes < kMax ? bytes : kMax));
  }
}

void QJSEnv::Mark(LEPUS_MarkFunc* mark_func, LEPUSRuntime* rt,
                  uint64_t trace_tool) {
  pthread_mutex_lock(&gc_mark_mutex_);
  if (!finalized_) {
    for (size_t i = 0; i < callback_count_; ++i) {
      LEPUS_MarkValue(rt, import_callbacks_[i].value, mark_func, trace_tool);
    }
    if (has_pending_wasm_exception_) {
      LEPUS_MarkValue(rt, pending_wasm_exception_, mark_func, trace_tool);
    }
  }
  pthread_mutex_unlock(&gc_mark_mutex_);
}

bool QJSEnv::ToWasmValueSlow(LEPUSContext* ctx, LEPUSValueConst value,
                             wasm_valkind_t kind, wasm_val_t* out) {
  out->kind = kind;
  switch (kind) {
    case WASM_I32:
      return LEPUS_ToInt32(ctx, &out->of.i32, value) == 0;
    case WASM_F32: {
      double d = 0;
      if (!QJSToDouble(ctx, value, &d)) return false;
      out->of.f32 = static_cast<float>(d);
      return true;
    }
    case WASM_F64:
      return QJSToDouble(ctx, value, &out->of.f64);
    case WASM_I64:
      if (LEPUS_IsUndefined(value) || LEPUS_IsNull(value) ||
          LEPUS_IsNumber(value)) {
        LEPUS_ThrowTypeError(
            ctx, "Undefined or Null or Number cannot convert to BigInt");
        return false;
      }
      return LEPUS_ToBigInt64(ctx, &out->of.i64, value) == 0;
    default:
      ThrowIfException(ctx, ErrorTypes::kTypeError, "WebAssembly value",
                       "Unsupported WebAssembly value type");
      return false;
  }
}

LEPUSValue QJSEnv::FromWasmValueSlow(LEPUSContext* ctx,
                                     const wasm_val_t& value) {
  switch (value.kind) {
    case WASM_I32:
      return LEPUS_NewInt32(ctx, value.of.i32);
    case WASM_F64:
      return LEPUS_NewFloat64(ctx, value.of.f64);
    case WASM_F32:
      return LEPUS_NewFloat64(ctx, static_cast<double>(value.of.f32));
    case WASM_I64:
      return LEPUS_NewBigInt64(ctx, value.of.i64);
    default:
      return ThrowIfException(ctx, ErrorTypes::kTypeError, "WebAssembly value",
                              "Unable to convert wasm result");
  }
}

WASM_MINSIZE LEPUSValue QJSEnv::ThrowTrap(wasm_trap_t* trap, const char* code) {
  LEPUSValue pending;
  if (TakeWasmException(&pending)) {
    wasm_trap_delete(trap);
    return LEPUS_Throw(js_ctx_, pending);
  }
  wasm_message_t message = {0, nullptr};
  wasm_trap_message(trap, &message);
  constexpr char kPrefix[] = "WebAssembly Trap: ";
  char text[256];
  std::memcpy(text, kPrefix, sizeof(kPrefix) - 1);
  size_t n = 0;
  if (message.data && message.size) {
    n = strnlen(message.data, message.size);
    const size_t cap = sizeof(text) - sizeof(kPrefix);
    if (n > cap) n = cap;
    std::memcpy(text + sizeof(kPrefix) - 1, message.data, n);
  }
  text[sizeof(kPrefix) - 1 + n] = '\0';
  wasm_byte_vec_delete(&message);
  wasm_trap_delete(trap);
  return ThrowIfException(js_ctx_, ErrorTypes::kError, code, text);
}

}  // namespace primjs::qjs
