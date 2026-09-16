// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/js_env_qjs.h"

#include "common/js_type.h"
#include "common/wasm_utils.h"
#include "qjs/qjs_ext_api.h"
#include "qjs/qjs_wasm.h"
#include "qjs/qjs_wasm_function.h"
#include "qjs/qjs_wasm_memory.h"
#include "runtime/prism/wasm_function.h"
#include "runtime/prism/wasm_runtime.h"
#include "runtime/wasm3/wasm_function.h"
#include "runtime/wasm3/wasm_runtime.h"

namespace primjs::qjs {
QJSEnv::QJSEnv(LEPUSContext *ctx, std::atomic_bool *invalid)
    : js_rt_(ctx->rt), js_ctx_(ctx), ctx_invalid_(invalid) {
  QJSWasmFunction::CreatePrototype(ctx);
}

void QJSEnv::Finalize() {
  WLOGD("Running QJSEnv::Finalize");
  for (auto &mem : wasm_memory_cache_) FreeValue(mem.second);
  for (auto &tab : wasm_table_cache_) FreeValue(tab.second);
  for (auto &glob : wasm_global_cache_) FreeValue(glob.second);
  for (auto &func : wasm_func_cache_) FreeValue(func.second);
  for (auto &callback : wasm_import_callback_roots_) FreeValue(callback.value);
  wasm_import_callback_roots_.clear();
  if (has_pending_wasm_exception_) {
    if (!LEPUS_IsGCModeRT(js_rt_)) {
      LEPUS_FreeValueRT(js_rt_, pending_wasm_exception_);
    }
    has_pending_wasm_exception_ = false;
    pending_wasm_exception_ = LEPUS_UNDEFINED;
  }
}

QJSEnv::~QJSEnv() { WLOGD("Running QJSEnv::%s...", __func__); }

JSValue QJSEnv::MakeObject() {
  return FromQJS(LEPUS_NewObject(js_ctx_), js_rt_);
}

JSValue QJSEnv::MakeNumber(double num) {
  return FromQJS(LEPUS_NewFloat64(js_ctx_, num), js_rt_);
}

bool QJSEnv::MakeBigInt64(int64_t num, JSValue *result, JSValue *exception) {
  LEPUSValue value = LEPUS_NewBigInt64(js_ctx_, num);
  *result = FromQJS(value, js_rt_);
  if (exception != nullptr && LEPUS_IsException(value)) {
    *exception = FromQJS(LEPUS_EXCEPTION, js_rt_);
  }
  return !LEPUS_IsException(value);
}

JSValue QJSEnv::MakeUndefined() {
  static LEPUSValue undefined = LEPUS_UNDEFINED;
  return FromQJS(undefined, js_rt_);
}

JSValue QJSEnv::MakeNull() { return JS_NULL; }

JSValue QJSEnv::MakeString(const char *str) {
  return FromQJS(LEPUS_NewString(js_ctx_, str), js_rt_);
}

JSValue QJSEnv::MakeException(ErrorTypes err, const char *code, const char *msg,
                              JSValue *exception) {
  return FromQJS(ThrowIfException(js_ctx_, err, code, msg, exception->GetPtr()),
                 js_rt_);
}

JSValue QJSEnv::MakeWasmMemory(InteropRuntime *interop, WasmMemoryRef memory,
                               size_t pages) {
  LEPUSValue ret =
      QJSWasmMemory::CreateJSObject(js_ctx_, interop, memory, pages);
  if (LEPUS_IsException(ret)) return JS_NULL;
  return FromQJS(ret, js_rt_);
}

JSValue QJSEnv::MakeWasmGlobal(InteropRuntime *interop, WasmGlobalRef global) {
  LEPUSValue ret = QJSWasmGlobal::CreateJSObject(js_ctx_, interop, global);
  if (LEPUS_IsException(ret)) return JS_NULL;
  return FromQJS(ret, js_rt_);
}

JSValue QJSEnv::MakeWasmTable(InteropRuntime *interop, WasmTableRef table) {
  LEPUSValue ret = QJSWasmTable::CreateJSObject(js_ctx_, interop, table);
  if (LEPUS_IsException(ret)) return JS_NULL;
  return FromQJS(ret, js_rt_);
}

JSObject QJSEnv::MakeWasmFunction(InteropRuntime *interop, const char *name,
                                  WasmFunctionRef function) {
  LEPUSValue res = QJSWasmFunction::CreateJSObject(js_ctx_, interop, function);
  if (LEPUS_IsException(res)) return JS_NULL;
  return FromQJS(res, js_rt_);
}

WasmGlobalRef QJSEnv::GetWasmGlobal(JSObject value) {
  if (QJSWasmGlobal::class_id() == LEPUS_GetClassID(js_ctx_, value.Get())) {
    auto global = static_cast<QJSWasmGlobal *>(
        LEPUS_GetOpaque(value.Get(), QJSWasmGlobal::class_id()));
    return global->global();
  }
  return {};
}

WasmMemoryRef QJSEnv::GetWasmMemory(JSObject value) {
  if (QJSWasmMemory::class_id() == LEPUS_GetClassID(js_ctx_, value.Get())) {
    auto memory = static_cast<QJSWasmMemory *>(
        LEPUS_GetOpaque(value.Get(), QJSWasmMemory::class_id()));
    return memory->memory();
  }
  return {};
}

WasmTableRef QJSEnv::GetWasmTable(JSObject value) {
  if (QJSWasmTable::class_id() == LEPUS_GetClassID(js_ctx_, value.Get())) {
    auto table = static_cast<QJSWasmTable *>(
        LEPUS_GetOpaque(value.Get(), QJSWasmTable::class_id()));
    return table->table();
  }
  return {};
}

WasmFunctionRef QJSEnv::GetWasmFunction(JSObject value) {
  if (QJSWasmFunction::class_id() == LEPUS_GetClassID(js_ctx_, value.Get())) {
    auto function = static_cast<QJSWasmFunction *>(
        LEPUS_GetOpaque(value.Get(), QJSWasmFunction::class_id()));
    return function->function();
  }
  return {};
}

JSValue QJSEnv::GetProperty(JSObject target, const char *name,
                            JSValue *exception) {
  LEPUSValue res = LEPUS_GetPropertyStr(js_ctx_, target.Get(), name);
  if (exception != nullptr && LEPUS_IsException(res)) {
    *exception = FromQJS(LEPUS_EXCEPTION, js_rt_);
  }
  if (!LEPUS_IsGCMode(js_ctx_)) {
    LEPUS_FreeValue(js_ctx_, res);
  }
  return FromQJS(res, js_rt_);
}

JSValue QJSEnv::GetPropertyForPrism(JSObject target, const char *name,
                                    JSValue *exception) {
  LEPUSValue res = LEPUS_GetPropertyStr(js_ctx_, target.Get(), name);
  if (exception != nullptr && LEPUS_IsException(res)) {
    *exception = FromQJS(LEPUS_EXCEPTION, js_rt_);
  }
  return FromQJS(res, js_rt_);
}

// "SetProperty" will consume refcount, thus the caller need to dup value
bool QJSEnv::SetProperty(JSValue obj, const char *name, JSValue val) {
  int ret = LEPUS_DefinePropertyValueStr(js_ctx_, obj.Get(), name, val.Get(),
                                         LEPUS_PROP_C_W_E);
  return (ret != -1);
}

// "SetPropertyAtIndex" will consume refcount, thus the caller need to dup value
bool QJSEnv::SetPropertyAtIndex(JSValue obj, uint32_t index, JSValue val) {
  int ret =
      LEPUS_DefinePropertyValueUint32(js_ctx_, obj.Get(), index, val.Get(), 0);
  return (ret != -1);
}

JSValue QJSEnv::ValueToObject(JSValue val) {
  if (LEPUS_IsObject(val.Get())) return val;
  JSObject res = FromQJS(LEPUS_ToObject(js_ctx_, val.Get()), js_rt_);
  if (!LEPUS_IsGCMode(js_ctx_)) {
    LEPUS_FreeValue(js_ctx_, val.Get());
  }
  return res;
}

JSValue QJSEnv::ValueToFunction(JSValue val) {
  if (LEPUS_IsFunction(js_ctx_, val.Get())) return val;
  return JS_NULL;
}

// spec: https://tc39.es/ecma262/#sec-toint32
void QJSEnv::ValueToInt32(int32_t &i32, JSValue val, JSValue &exception) {
  exception = JS_NULL;
  if (LEPUS_ToInt32(js_ctx_, &i32, val.Get()))
    exception = FromQJS(LEPUS_EXCEPTION, js_rt_);
}

// spec: https://tc39.es/ecma262/#sec-tobigint64
void QJSEnv::ValueToBigInt64(int64_t &i64, JSValue val, JSValue &exception) {
  exception = JS_NULL;
  if (LEPUS_ToBigInt64(js_ctx_, &i64, val.Get())) exception = LEPUS_EXCEPTION;
  if (LEPUS_IsUndefined(val.Get()) || LEPUS_IsNull(val.Get()) ||
      LEPUS_IsNumber(val.Get())) {
    exception = FromQJS(
        LEPUS_ThrowTypeError(
            js_ctx_, "Undefined or Null or Number cannot convert to BigInt"),
        js_rt_);
  } else if (LEPUS_ToInt64(js_ctx_, &i64, val.Get())) {
    exception = FromQJS(LEPUS_EXCEPTION, js_rt_);
  }
}

void QJSEnv::ValueToBigInt64ForPrism(int64_t &i64, JSValue val,
                                     JSValue &exception) {
  exception = JS_NULL;
  if (LEPUS_IsUndefined(val.Get()) || LEPUS_IsNull(val.Get()) ||
      LEPUS_IsNumber(val.Get())) {
    exception = FromQJS(
        LEPUS_ThrowTypeError(
            js_ctx_, "Undefined or Null or Number cannot convert to BigInt"),
        js_rt_);
    return;
  }
  if (LEPUS_ToBigInt64(js_ctx_, &i64, val.Get())) {
    exception = FromQJS(LEPUS_EXCEPTION, js_rt_);
  }
}

// NOTE: The caller ensures this value is a number.
void QJSEnv::ValueToNumber(double &num, JSValue val, JSValue &exception) {
  exception = JS_NULL;
  if (LEPUS_ToFloat64(js_ctx_, &num, val.Get()))
    exception = FromQJS(LEPUS_EXCEPTION, js_rt_);
}

JSValue QJSEnv::CallAsFunction(JSValue function, JSValue thisObject,
                               size_t argc, JSValue args[],
                               JSValue *exception) {
  LEPUSValue *arr = new LEPUSValue[argc];
  for (size_t i = 0; i < argc; i++) arr[i] = args[i].Get();
  LEPUSValue res =
      LEPUS_Call(js_ctx_, function.Get(), thisObject.Get(), argc, arr);
  delete[] arr;
  return FromQJS(res, js_rt_);
}

JSValue QJSEnv::CallAsFunctionForPrism(JSValue function, JSValue thisObject,
                                       size_t argc, JSValue args[],
                                       JSValue *exception) {
  LEPUSValue *arr = new LEPUSValue[argc];
  for (size_t i = 0; i < argc; i++) arr[i] = args[i].Get();
  LEPUSValue result =
      LEPUS_Call(js_ctx_, function.Get(), thisObject.Get(), argc, arr);
  delete[] arr;
  if (LEPUS_IsException(result)) {
    // LEPUS_GetException transfers the pending value to us and clears QJS's
    // null-sentinel slot. Keep an explicit presence bit so literal null and
    // undefined remain distinguishable from "no imported exception".
    LEPUSValue thrown = LEPUS_GetException(js_ctx_);
    StashWasmException(thrown);
    if (exception != nullptr) {
      *exception = FromQJS(thrown, js_rt_);
    }
  }
  return FromQJS(result, js_rt_);
}

void QJSEnv::StashWasmException(LEPUSValue exception) {
  if (has_pending_wasm_exception_ && !LEPUS_IsGCModeRT(js_rt_)) {
    LEPUS_FreeValueRT(js_rt_, pending_wasm_exception_);
  }
  pending_wasm_exception_ = exception;
  has_pending_wasm_exception_ = true;
}

void QJSEnv::CapturePendingWasmException() {
  StashWasmException(LEPUS_GetException(js_ctx_));
}

bool QJSEnv::TakeWasmException(LEPUSValue *exception) {
  if (!has_pending_wasm_exception_ || exception == nullptr) return false;
  *exception = pending_wasm_exception_;
  pending_wasm_exception_ = LEPUS_UNDEFINED;
  has_pending_wasm_exception_ = false;
  return true;
}

JSValue QJSEnv::DupValue(JSValue value) {
  if (!LEPUS_IsGCModeRT(js_rt_)) {
    return FromQJS(LEPUS_DupValueRT(js_rt_, value.Get()), js_rt_);
  } else {
    return value;
  }
}

uint64_t QJSEnv::BeginWasmImportCallbackTransaction() {
  ++next_wasm_import_callback_transaction_;
  if (next_wasm_import_callback_transaction_ == 0) {
    ++next_wasm_import_callback_transaction_;
  }
  return next_wasm_import_callback_transaction_;
}

void QJSEnv::CacheWasmImportCallback(JSObject value, uint64_t transaction) {
  wasm_import_callback_roots_.push_back({DupValue(value), transaction});
}

size_t QJSEnv::RollbackWasmImportCallbackTransaction(uint64_t transaction) {
  size_t rolled_back = 0;
  for (auto it = wasm_import_callback_roots_.begin();
       it != wasm_import_callback_roots_.end();) {
    if (it->transaction != transaction) {
      ++it;
      continue;
    }
    FreeValue(it->value);
    it = wasm_import_callback_roots_.erase(it);
    ++rolled_back;
  }
  return rolled_back;
}

void QJSEnv::FreeValue(const JSValue &value) {
  if (!LEPUS_IsGCModeRT(js_rt_)) {
    LEPUS_FreeValueRT(js_rt_, value.Get());
  }
}

JSValue QJSEnv::ReserveValue(JSValue obj) {
  if (!LEPUS_IsGCModeRT(js_rt_)) {
    return FromQJS(LEPUS_DupValueRT(js_rt_, obj.Get()), js_rt_);
  } else {
    return obj;
  }
}

void QJSEnv::ReleaseValue(JSValue obj) {
  if (!LEPUS_IsGCModeRT(js_rt_)) {
    LEPUS_FreeValueRT(js_rt_, obj.Get());
  }
}

int QJSEnv::RefCount(JSValue value, const char *msg) {
  int ref_count = -1;
  if (LEPUS_VALUE_HAS_REF_COUNT(value.Get())) {
    auto p = (LEPUSRefCountHeader *)LEPUS_VALUE_GET_PTR(value.Get());
    WLOGI("QJS Refcount is %d; %s", p->ref_count, msg);
    ref_count = p->ref_count;
  } else {
    WLOGI("QJS Refcount is not available; %s", msg);
  }
  return ref_count;
}

void QJSEnv::PrintObjectProperties(LEPUSContext *ctx, LEPUSValueConst obj) {
  LEPUSPropertyEnum *props = nullptr;
  HandleScope func_scope(ctx, &props, HANDLE_TYPE_HEAP_OBJ);
  uint32_t prop_count = 0;

  LEPUS_GetOwnPropertyNames(
      ctx, &props, &prop_count, obj,
      LEPUS_GPN_STRING_MASK | LEPUS_GPN_SYMBOL_MASK | LEPUS_GPN_PRIVATE_MASK);

  for (uint32_t i = 0; i < prop_count; i++) {
    JSAtom prop_name_atom = props[i].atom;

    const char *prop_name_str = LEPUS_AtomToCString(ctx, prop_name_atom);

    LEPUSValue prop_value = LEPUS_GetProperty(ctx, obj, prop_name_atom);

    int ref_count = -1;
    if (LEPUS_VALUE_HAS_REF_COUNT(prop_value)) {
      auto p = (LEPUSRefCountHeader *)LEPUS_VALUE_GET_PTR(prop_value);
      ref_count = p->ref_count;
    }

    int64_t prop_tag = LEPUS_VALUE_GET_TAG(prop_value);

    printf("Property Name: \"%s\", RefCount: %d, ", prop_name_str, ref_count);

    if (prop_tag == LEPUS_TAG_STRING) {
      const char *prop_value_str = LEPUS_ToCString(ctx, prop_value);
      printf("(String): %s\n", prop_value_str);
      if (!LEPUS_IsGCMode(ctx)) {
        LEPUS_FreeCString(ctx, prop_value_str);
      }
    } else if (prop_tag == LEPUS_TAG_OBJECT) {
      printf("(Object)\n");
    } else {
      printf("(Unknown Type)\n");
    }

    if (!LEPUS_IsGCMode(ctx)) {
      LEPUS_FreeCString(ctx, prop_name_str);
      LEPUS_FreeValue(ctx, prop_value);
    }
  }
  printf("\n");

  if (!LEPUS_IsGCMode(ctx)) {
    lepus_free(ctx, props);
  }
}

void QJSEnv::Mark(LEPUS_MarkFunc *mark_func, LEPUSRuntime *rt,
                  uint64_t trace_tool = 0) {
  for (auto &mem : wasm_memory_cache_)
    LEPUS_MarkValue(rt, mem.second.Get(), mark_func, trace_tool);
  for (auto &tab : wasm_table_cache_)
    LEPUS_MarkValue(rt, tab.second.Get(), mark_func, trace_tool);
  for (auto &glob : wasm_global_cache_)
    LEPUS_MarkValue(rt, glob.second.Get(), mark_func, trace_tool);
  for (auto &func : wasm_func_cache_)
    LEPUS_MarkValue(rt, func.second.Get(), mark_func, trace_tool);
  for (auto &callback : wasm_import_callback_roots_)
    LEPUS_MarkValue(rt, callback.value.Get(), mark_func, trace_tool);
  if (has_pending_wasm_exception_) {
    LEPUS_MarkValue(rt, pending_wasm_exception_, mark_func, trace_tool);
  }
}

}  // namespace primjs::qjs
