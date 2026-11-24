// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_memory.h"

#include <cmath>
#include <limits>

#include "common/messages.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/js_env_qjs.h"
#include "qjs/qjs_wasm.h"

namespace primjs::qjs {

namespace {
struct QJSBufferKeep {
  wasm::WasmBufferKeep base;
  LEPUSValue buffer = LEPUS_UNDEFINED;

  static QJSBufferKeep* Create(wasm::WasmStoreOwner* owner,
                               wasm_memory_t* memory) {
    if (!owner || !memory) return nullptr;
    wasm_memory_t* copy = wasm_memory_copy(memory);
    if (!copy) return nullptr;
    wasm::WasmStoreOwner::Retain(owner);
    auto* keep = new QJSBufferKeep();
    keep->base.owner = owner;
    keep->base.memory = copy;
    return keep;
  }

  static void DetachOnExit(wasm::WasmTrackedHandle* h, void* exit_ctx) {
    auto* self = static_cast<QJSBufferKeep*>(h->owner_object);
    self->base.in_exit_detach = true;
    if (exit_ctx && !LEPUS_IsUndefined(self->buffer)) {
      LEPUS_DetachArrayBuffer(static_cast<LEPUSContext*>(exit_ctx),
                              self->buffer);
    }
    self->base.DropOnce();
    delete self;
  }
};

void ReleaseQJSBufferMemory(LEPUSRuntime* rt, void* opaque, void* ptr) {
  (void)rt;
  if (ptr == nullptr || opaque == nullptr) return;
  auto* keep = static_cast<QJSBufferKeep*>(opaque);
  keep->buffer = LEPUS_UNDEFINED;
  keep->base.DropOnce();
  if (!keep->base.in_exit_detach) {
    delete keep;
  }
}
}  // namespace

QJSWasmMemory::QJSWasmMemory(LEPUSRuntime* rt, LEPUSValue wasm_root,
                             wasm::WasmStoreOwner* store_owner,
                             wasm_memory_t* memory, uint32_t maximum,
                             LEPUSValue js_obj)
    : QJSWasmWrapperBase(rt, wasm_root, store_owner, DetachMemory),
      memory_(memory),
      maximum_(maximum),
      pages_(memory ? (wasm_memory_data_size(memory) / kWasmPageSize) : 0),
      js_obj_(js_obj) {
  wasm_memory_set_host_info(memory_, this);
}

QJSWasmMemory::~QJSWasmMemory() {
  UnlinkAndDetach();
  pthread_mutex_destroy(&buffer_mutex_);
}

void QJSWasmMemory::DetachMemory(QJSWasmWrapperBase* base, LEPUSRuntime* rt) {
  auto* self = static_cast<QJSWasmMemory*>(base);
  if (self->memory_) {
    if (Of(self->memory_) == self) {
      wasm_memory_set_host_info(self->memory_, nullptr);
    }
    wasm_memory_delete(self->memory_);
    self->memory_ = nullptr;
  }
  pthread_mutex_lock(&self->buffer_mutex_);
  LEPUSValue buf = self->buffer_;
  self->buffer_ = LEPUS_UNDEFINED;
  pthread_mutex_unlock(&self->buffer_mutex_);
  if (rt && !LEPUS_IsGCModeRT(rt) && !LEPUS_IsUndefined(buf)) {
    LEPUS_FreeValueRT(rt, buf);
  }
}

void QJSWasmMemory::GCMark(LEPUSRuntime* rt, LEPUSValueConst obj,
                           LEPUS_MarkFunc* mark_func, uint64_t trace_tool) {
  auto* mem = static_cast<QJSWasmMemory*>(LEPUS_GetOpaque(obj, class_id()));
  if (mem) {
    mem->MarkRoot(rt, mark_func, trace_tool);
    pthread_mutex_lock(&mem->buffer_mutex_);
    if (!LEPUS_IsUndefined(mem->buffer_)) {
      LEPUS_MarkValue(rt, mem->buffer_, mark_func, trace_tool);
    }
    pthread_mutex_unlock(&mem->buffer_mutex_);
  }
}

bool QJSWasmMemory::Register(LEPUSContext* ctx, LEPUSValue wasm_root) {
  static const LEPUSCFunctionListEntry proto_funcs[] = {
      LEPUS_CFUNC_DEF("grow", 1, GrowCallback),
      LEPUS_CGETSET_DEF("buffer", GetBufferCallback, nullptr),
  };
  return RegisterWasmClass(
      ctx, wasm_root, WasmQJSClass::kMemory, "WebAssembly.Memory", "Memory",
      CallAsConstructor, proto_funcs, countof(proto_funcs), nullptr, 0, GCMark);
}

LEPUSValue QJSWasmMemory::WrapOwnedMemory(LEPUSContext* ctx, QJSEnv* env,
                                          wasm_memory_t* memory,
                                          uint32_t maximum) {
  LEPUSValue obj = NewWasmWrapperObject(ctx, env, WasmQJSClass::kMemory,
                                        "WebAssembly.Memory()");
  if (LEPUS_IsException(obj)) {
    wasm_memory_delete(memory);
    return LEPUS_EXCEPTION;
  }
  HandleScope func_scope(ctx, &obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetOpaque(obj,
                  new QJSWasmMemory(LEPUS_GetRuntime(ctx), env->wasm_root(),
                                    env->store_owner(), memory, maximum, obj));
  env->ReportOuterSize(wasm_memory_data_size(memory));
  return obj;
}

LEPUSValue QJSWasmMemory::GetOrWrapOwnedMemory(LEPUSContext* ctx, QJSEnv* env,
                                               wasm_memory_t* memory) {
  if (!memory) return LEPUS_EXCEPTION;
  if (QJSWasmMemory* existing = Of(memory)) {
    wasm_memory_delete(memory);
    return DupValueIfRC(ctx, existing->js_object());
  }
  uint32_t maximum = wasm_limits_max_default;
  if (wasm_memorytype_t* mtype = wasm_memory_type(memory)) {
    if (const wasm_limits_t* limits = wasm_memorytype_limits(mtype)) {
      maximum = limits->max;
    }
    wasm_memorytype_delete(mtype);
  }
  return WrapOwnedMemory(ctx, env, memory, maximum);
}

LEPUSValue QJSWasmMemory::CallAsConstructor(LEPUSContext* ctx,
                                            LEPUSValueConst new_target,
                                            int argc, LEPUSValueConst* argv) {
  constexpr const char* code = "WebAssembly.Memory()";

  QJSEnv* env = RequireConstructorEnv(ctx, new_target, code);
  if (!env) return LEPUS_EXCEPTION;

  if (argc < 1 || !LEPUS_IsObject(argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "new Memory without MemoryDescriptor!");
  }

  LEPUSValue desc = argv[0];
  LEPUSValue initial_val = LEPUS_GetPropertyStr(ctx, desc, "initial");
  if (LEPUS_IsException(initial_val)) return LEPUS_EXCEPTION;
  if (LEPUS_IsUndefined(initial_val)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Property initial is required.");
  }
  uint32_t init_pages = 0;
  {
    HandleScope s(ctx, &initial_val, HANDLE_TYPE_LEPUS_VALUE);
    const int rc = LEPUS_ToUint32(ctx, &init_pages, initial_val);
    FreeValueIfRC(ctx, initial_val);
    if (rc < 0) return LEPUS_EXCEPTION;
  }

  uint32_t max_pages = kMaxPagesNum;
  LEPUSValue max_val = LEPUS_GetPropertyStr(ctx, desc, "maximum");
  if (LEPUS_IsException(max_val)) return LEPUS_EXCEPTION;
  if (!LEPUS_IsUndefined(max_val)) {
    HandleScope s(ctx, &max_val, HANDLE_TYPE_LEPUS_VALUE);
    const int rc = LEPUS_ToUint32(ctx, &max_pages, max_val);
    FreeValueIfRC(ctx, max_val);
    if (rc < 0) return LEPUS_EXCEPTION;
    if (max_pages < init_pages) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              "maximum must not be smaller than initial");
    }
  }
  if (init_pages > kMaxPagesNum || max_pages > kMaxPagesNum) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            ErrorMessages::kMemoryAllocFailed_1001);
  }

  wasm_limits_t limits = {init_pages, max_pages};
  wasm_memorytype_t* mtype = wasm_memorytype_new(&limits);
  wasm_memory_t* memory =
      mtype ? wasm_memory_new(env->wasm_store(), mtype) : nullptr;
  if (mtype) wasm_memorytype_delete(mtype);
  if (wasm_unlikely(!memory)) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            ErrorMessages::kMemoryAllocFailed_1001);
  }
  return WrapOwnedMemory(ctx, env, memory, max_pages);
}

LEPUSValue QJSWasmMemory::GetBufferCallback(LEPUSContext* ctx,
                                            LEPUSValueConst this_val) {
  auto* mem =
      static_cast<QJSWasmMemory*>(LEPUS_GetOpaque2(ctx, this_val, class_id()));
  if (!mem) return LEPUS_EXCEPTION;
  if (!mem->memory_ || !mem->store_owner()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError,
                            "WebAssembly.Memory.buffer",
                            "WebAssembly context is not active");
  }
  LEPUSValue rooted_this = this_val;
  HandleScope func_scope(ctx, &rooted_this, HANDLE_TYPE_LEPUS_VALUE);

  const size_t current_pages = mem->pages();
  if (LEPUS_IsUndefined(mem->buffer_) || mem->pages_ != current_pages) {
    pthread_mutex_lock(&mem->buffer_mutex_);
    LEPUSValue old_buf = mem->buffer_;
    mem->buffer_ = LEPUS_UNDEFINED;
    pthread_mutex_unlock(&mem->buffer_mutex_);
    if (!LEPUS_IsUndefined(old_buf)) {
      LEPUS_DetachArrayBuffer(ctx, old_buf);
      FreeValueIfRC(ctx, old_buf);
    }

    auto* raw_data = reinterpret_cast<uint8_t*>(wasm_memory_data(mem->memory_));
    mem->pages_ = current_pages;
    const size_t buffer_size = current_pages * kWasmPageSize;

    QJSBufferKeep* keep = nullptr;
    if (buffer_size != 0 && raw_data != nullptr && mem->memory_ != nullptr) {
      keep = QJSBufferKeep::Create(mem->store_owner(), mem->memory_);
      if (wasm_unlikely(!keep)) {
        return ThrowIfException(ctx, ErrorTypes::kError,
                                "WebAssembly.Memory.buffer",
                                "Unable to retain WebAssembly.Memory buffer");
      }
    }
    LEPUSValue new_buf = LEPUS_NewArrayBuffer(
        ctx, raw_data, buffer_size, keep ? ReleaseQJSBufferMemory : nullptr,
        keep, false);
    if (LEPUS_IsException(new_buf)) {
      if (keep != nullptr) {
        ReleaseQJSBufferMemory(LEPUS_GetRuntime(ctx), keep, raw_data);
      }
      return LEPUS_EXCEPTION;
    }
    if (LEPUS_IsGCMode(ctx)) {
      LEPUS_WriteBarrierNoStore(ctx, new_buf);
    }
    pthread_mutex_lock(&mem->buffer_mutex_);
    mem->buffer_ = new_buf;
    pthread_mutex_unlock(&mem->buffer_mutex_);
    if (keep != nullptr) {
      keep->buffer = new_buf;
      mem->store_owner()->LinkHandle(&keep->base.tracked, keep,
                                     QJSBufferKeep::DetachOnExit, true);
    }
  }

  return DupValueIfRC(ctx, mem->buffer_);
}

LEPUSValue QJSWasmMemory::GrowCallback(LEPUSContext* ctx,
                                       LEPUSValueConst this_val, int argc,
                                       LEPUSValueConst* argv) {
  constexpr const char* code = "WebAssembly.Memory::grow()";

  auto* mem =
      static_cast<QJSWasmMemory*>(LEPUS_GetOpaque2(ctx, this_val, class_id()));
  if (!mem) return LEPUS_EXCEPTION;
  if (!mem->memory_) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "WebAssembly context is not active");
  }
  if (argc < 1) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1007);
  }

  double requested_pages = 0;
  if (!LEPUS_IsNumber(argv[0]) ||
      LEPUS_ToFloat64(ctx, &requested_pages, argv[0]) < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1008);
  }
  requested_pages = std::trunc(requested_pages);
  if (!std::isfinite(requested_pages) || requested_pages < 0 ||
      requested_pages > std::numeric_limits<uint32_t>::max()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1008);
  }
  const uint32_t grow_pages = static_cast<uint32_t>(requested_pages);
  const size_t old_pages = mem->pages();
  if (grow_pages != 0) {
    if (!wasm_memory_grow(mem->memory_, grow_pages)) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kGrowFailed_1004);
    }
    LEPUSValue rooted_this = this_val;
    HandleScope func_scope(ctx, &rooted_this, HANDLE_TYPE_LEPUS_VALUE);
    if (QJSEnv* env = QJSWebAssembly::GetEnvFromRoot(mem->wasm_root())) {
      env->ReportOuterSize(static_cast<size_t>(grow_pages) * kWasmPageSize);
    }
  }
  return LEPUS_NewInt32(ctx, static_cast<int32_t>(old_pages));
}

}  // namespace primjs::qjs
