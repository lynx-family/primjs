// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_ext_api.h"

#include <cmath>
#include <cstdlib>
#include <cstring>
#include <limits>

#include "gc/trace-gc.h"
#include "qjs/js_env_qjs.h"
#include "qjs/qjs_wasm.h"

namespace primjs::qjs {

namespace {
pthread_once_t g_class_ids_once = PTHREAD_ONCE_INIT;
LEPUSClassID g_class_ids[static_cast<size_t>(WasmQJSClass::kCount)] = {};

void InitAllWasmClassIds() {
  for (LEPUSClassID& id : g_class_ids) {
    LEPUS_NewClassID(&id);
  }
}

size_t AppendBounded(char* dst, size_t pos, size_t cap, const char* src) {
  if (!src || pos + 1 >= cap) return pos;
  const size_t n = strnlen(src, cap - 1 - pos);
  std::memcpy(dst + pos, src, n);
  return pos + n;
}

#if defined(__GNUC__) || defined(__clang__)
__attribute__((cold, noinline))
#endif
LEPUSValue
ThrowFormattedError(LEPUSContext* ctx, ErrorTypes err, const char* code,
                    const char* msg) {
  char buf[256];
  size_t pos = 0;
  if (code && code[0] != '\0') {
    pos = AppendBounded(buf, pos, sizeof(buf), code);
    pos = AppendBounded(buf, pos, sizeof(buf), ": ");
  }
  pos = AppendBounded(buf, pos, sizeof(buf), msg);
  buf[pos] = '\0';

  if (err == ErrorTypes::kTypeError) {
    return LEPUS_ThrowTypeError(ctx, "%s", buf);
  }
  if (err == ErrorTypes::kRangeError) {
    return LEPUS_ThrowRangeError(ctx, "%s", buf);
  }
  LEPUSValue error = LEPUS_NewError(ctx);
  if (LEPUS_IsException(error)) return LEPUS_EXCEPTION;
  HandleScope scope(ctx, &error, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_DefinePropertyValueStr(ctx, error, "message", LEPUS_NewString(ctx, buf),
                               LEPUS_PROP_WRITABLE | LEPUS_PROP_CONFIGURABLE);
  return LEPUS_Throw(ctx, error);
}
}  // namespace

LEPUSClassID GetWasmClassId(WasmQJSClass kind) {
  pthread_once(&g_class_ids_once, InitAllWasmClassIds);
  return g_class_ids[static_cast<size_t>(kind)];
}

void WasmWrapperFinalizer(LEPUSRuntime* rt, LEPUSValue obj) {
  for (uint8_t i = static_cast<uint8_t>(WasmQJSClass::kModule);
       i < static_cast<uint8_t>(WasmQJSClass::kCount); ++i) {
    if (auto* opaque = static_cast<QJSWasmWrapperBase*>(
            LEPUS_GetOpaque(obj, g_class_ids[i]))) {
      LEPUS_SetOpaque(obj, nullptr);
      opaque->UnlinkAndDetach(rt);
      opaque->ReleaseRoot(rt);
      delete opaque;
      return;
    }
  }
}

void WasmWrapperGCMark(LEPUSRuntime* rt, LEPUSValueConst obj,
                       LEPUS_MarkFunc* mark_func, uint64_t trace_tool) {
  for (uint8_t i = static_cast<uint8_t>(WasmQJSClass::kModule);
       i < static_cast<uint8_t>(WasmQJSClass::kCount); ++i) {
    if (auto* opaque = static_cast<QJSWasmWrapperBase*>(
            LEPUS_GetOpaque(obj, g_class_ids[i]))) {
      opaque->MarkRoot(rt, mark_func, trace_tool);
      return;
    }
  }
}

QJSWasmWrapperBase::QJSWasmWrapperBase(LEPUSRuntime* rt, LEPUSValue wasm_root,
                                       wasm::WasmStoreOwner* store_owner,
                                       DetachNativeFn detach_native)
    : store_owner_(store_owner),
      detach_native_(detach_native),
      wasm_root_(LEPUS_IsGCModeRT(rt) ? wasm_root
                                      : LEPUS_DupValueRT(rt, wasm_root)) {
  if (store_owner_) {
    wasm::WasmStoreOwner::Retain(store_owner_);
    store_owner_->LinkHandle(&tracked_, this, SharedDetachOnExit);
  }
}

QJSWasmWrapperBase::~QJSWasmWrapperBase() {
  UnlinkAndDetach();
  std::free(keep_set_);
  pthread_mutex_destroy(&keep_mutex_);
}

void QJSWasmWrapperBase::UnlinkAndDetach(LEPUSRuntime* rt) {
  if (store_owner_) {
    store_owner_->UnlinkHandle(&tracked_);
  }
  DetachNative(rt);
}

void QJSWasmWrapperBase::DetachNative(LEPUSRuntime* rt) {
  if (DetachNativeFn fn = detach_native_) {
    detach_native_ = nullptr;
    fn(this, rt);
  }
  wasm::WasmStoreOwner::Release(store_owner_);
}

void QJSWasmWrapperBase::SharedDetachOnExit(wasm::WasmTrackedHandle* handle,
                                            void* exit_ctx) {
  auto* self = static_cast<QJSWasmWrapperBase*>(handle->owner_object);
  LEPUSRuntime* rt =
      exit_ctx ? LEPUS_GetRuntime(static_cast<LEPUSContext*>(exit_ctx))
               : nullptr;
  self->DetachNative(rt);
  if (rt) {
    self->ReleaseRoot(rt);
  }
}

void QJSWasmWrapperBase::ReleaseRoot(LEPUSRuntime* rt) {
  pthread_mutex_lock(&keep_mutex_);
  LEPUSValue root = wasm_root_;
  wasm_root_ = LEPUS_UNDEFINED;
  LEPUSValue* keeps = keep_set_;
  const uint32_t count = keep_count_;
  keep_set_ = nullptr;
  keep_count_ = 0;
  keep_cap_ = 0;
  pthread_mutex_unlock(&keep_mutex_);

  if (rt && !LEPUS_IsGCModeRT(rt)) {
    if (!LEPUS_IsUndefined(root)) {
      LEPUS_FreeValueRT(rt, root);
    }
    for (uint32_t i = 0; i < count; ++i) {
      LEPUS_FreeValueRT(rt, keeps[i]);
    }
  }
  std::free(keeps);
}

void QJSWasmWrapperBase::MarkRoot(LEPUSRuntime* rt, LEPUS_MarkFunc* mark_func,
                                  uint64_t trace_tool) const {
  pthread_mutex_lock(&keep_mutex_);
  if (!LEPUS_IsUndefined(wasm_root_)) {
    LEPUS_MarkValue(rt, wasm_root_, mark_func, trace_tool);
  }
  for (uint32_t i = 0; i < keep_count_; ++i) {
    LEPUS_MarkValue(rt, keep_set_[i], mark_func, trace_tool);
  }
  pthread_mutex_unlock(&keep_mutex_);
}

void QJSWasmWrapperBase::AddKeepToken(LEPUSContext* ctx, LEPUSValueConst val) {
  if (!LEPUS_IsObject(val)) return;
  void* ptr = LEPUS_VALUE_GET_PTR(val);
  LEPUSRuntime* rt = LEPUS_GetRuntime(ctx);
  const bool gc = LEPUS_IsGCModeRT(rt);
  if (gc) {
    LEPUS_WriteBarrierNoStore(ctx, val);
  }
  pthread_mutex_lock(&keep_mutex_);
  for (uint32_t i = 0; i < keep_count_; ++i) {
    if (LEPUS_VALUE_GET_PTR(keep_set_[i]) == ptr) {
      pthread_mutex_unlock(&keep_mutex_);
      return;
    }
  }
  if (keep_count_ == keep_cap_) {
    const uint32_t new_cap = keep_cap_ ? keep_cap_ * 2 : 4;
    auto* grown = static_cast<LEPUSValue*>(
        std::realloc(keep_set_, new_cap * sizeof(LEPUSValue)));
    if (!grown) {
      pthread_mutex_unlock(&keep_mutex_);
      return;
    }
    keep_set_ = grown;
    keep_cap_ = new_cap;
  }
  keep_set_[keep_count_++] = gc ? val : LEPUS_DupValueRT(rt, val);
  pthread_mutex_unlock(&keep_mutex_);
}

void QJSWasmWrapperBase::MergeKeepSet(LEPUSContext* ctx,
                                      const QJSWasmWrapperBase& other) {
  if (&other == this) return;
  pthread_mutex_lock(&other.keep_mutex_);
  const uint32_t n = other.keep_count_;
  LEPUSValue* snapshot =
      n ? static_cast<LEPUSValue*>(std::malloc(n * sizeof(LEPUSValue)))
        : nullptr;
  if (snapshot) {
    std::memcpy(snapshot, other.keep_set_, n * sizeof(LEPUSValue));
  }
  pthread_mutex_unlock(&other.keep_mutex_);
  if (!snapshot) return;
  for (uint32_t i = 0; i < n; ++i) {
    AddKeepToken(ctx, snapshot[i]);
  }
  std::free(snapshot);
}

bool QJSWasmWrapperBase::HasKeepTokens() const {
  pthread_mutex_lock(&keep_mutex_);
  const bool has = keep_count_ != 0;
  pthread_mutex_unlock(&keep_mutex_);
  return has;
}

bool JSSafeNewClass(LEPUSContext* ctx, LEPUSClassID class_id,
                    const LEPUSClassDef* class_def) {
  LEPUSRuntime* rt = LEPUS_GetRuntime(ctx);
  return !LEPUS_IsRegisteredClass(rt, class_id) &&
         LEPUS_NewClass(rt, class_id, class_def) != 0;
}

bool RegisterWasmClass(LEPUSContext* ctx, LEPUSValueConst wasm_root,
                       WasmQJSClass kind, const char* class_name,
                       const char* ctor_name, LEPUSCFunction* ctor_fn,
                       const LEPUSCFunctionListEntry* proto_funcs,
                       size_t proto_func_count,
                       const LEPUSCFunctionListEntry* static_funcs,
                       size_t static_func_count,
                       LEPUSClassGCMark* custom_mark) {
  const LEPUSClassID cid = GetWasmClassId(kind);
  LEPUSClassDef def = {
      .class_name = class_name,
      .finalizer = WasmWrapperFinalizer,
      .gc_mark = custom_mark ? custom_mark : WasmWrapperGCMark};
  if (JSSafeNewClass(ctx, cid, &def)) return false;

  LEPUSValue proto = LEPUS_NewObject(ctx);
  if (LEPUS_IsException(proto)) return false;
  HandleScope scope(ctx, &proto, HANDLE_TYPE_LEPUS_VALUE);
  if (proto_funcs && proto_func_count > 0) {
    LEPUS_SetPropertyFunctionList(ctx, proto, proto_funcs,
                                  static_cast<int>(proto_func_count));
  }
  LEPUS_SetClassProto(ctx, cid, proto);

  LEPUSValue ctor = LEPUS_NewCFunction2(ctx, ctor_fn, ctor_name, 1,
                                        LEPUS_CFUNC_constructor, 0);
  if (LEPUS_IsException(ctor)) return false;
  scope.PushHandle(&ctor, HANDLE_TYPE_LEPUS_VALUE);

  const int rw_cfg = LEPUS_PROP_WRITABLE | LEPUS_PROP_CONFIGURABLE;
  LEPUS_DefinePropertyValueStr(ctx, ctor, "prototype", DupValueIfRC(ctx, proto),
                               rw_cfg);
  LEPUS_DefinePropertyValueStr(ctx, proto, "constructor",
                               DupValueIfRC(ctx, ctor), rw_cfg);
  LEPUS_DefinePropertyValueStr(ctx, ctor, kPrivateWasmRootProp,
                               DupValueIfRC(ctx, wasm_root), 0);
  if (static_funcs && static_func_count > 0) {
    LEPUS_SetPropertyFunctionList(ctx, ctor, static_funcs,
                                  static_cast<int>(static_func_count));
  }
  return LEPUS_DefinePropertyValueStr(ctx, wasm_root, ctor_name, ctor, rw_cfg) >
         0;
}

QJSEnv* RequireConstructorEnv(LEPUSContext* ctx, LEPUSValueConst new_target,
                              const char* code) {
  if (!LEPUS_IsObject(new_target)) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     "Constructor requires 'new'");
    return nullptr;
  }
  LEPUSValue root_val =
      LEPUS_GetPropertyStr(ctx, new_target, kPrivateWasmRootProp);
  if (LEPUS_IsException(root_val)) return nullptr;
  QJSEnv* env = QJSWebAssembly::GetEnvFromRoot(root_val);
  FreeValueIfRC(ctx, root_val);
  if (!env) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     "Constructor requires 'new'");
    return nullptr;
  }
  if (wasm_unlikely(!LEPUS_IsObject(env->wasm_root()))) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     "WebAssembly context is not active");
    return nullptr;
  }
  return env;
}

LEPUSValue NewWasmWrapperObject(LEPUSContext* ctx, QJSEnv* env,
                                WasmQJSClass kind, const char* code) {
  if (wasm_unlikely(!env || !LEPUS_IsObject(env->wasm_root()))) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "WebAssembly context is not active");
  }
  return LEPUS_NewObjectClass(ctx, GetWasmClassId(kind));
}

bool JSValueGetInt32(LEPUSContext* ctx, LEPUSValue js_val, int32_t* res) {
  if (LEPUS_VALUE_IS_INT(js_val)) {
    *res = LEPUS_VALUE_GET_INT(js_val);
    return true;
  }
  double num = 0;
  if (LEPUS_ToFloat64(ctx, &num, js_val) < 0) return false;
  if (!std::isfinite(num) || num > std::numeric_limits<int32_t>::max() ||
      num < std::numeric_limits<int32_t>::min()) {
    return false;
  }
  *res = static_cast<int32_t>(num);
  return true;
}

LEPUSValue ThrowIfException(LEPUSContext* ctx, ErrorTypes err, const char* code,
                            const char* msg, LEPUSValue* exception) {
  LEPUSValue thrown = ThrowFormattedError(ctx, err, code, msg);
  if (exception) *exception = thrown;
  return thrown;
}

}  // namespace primjs::qjs
