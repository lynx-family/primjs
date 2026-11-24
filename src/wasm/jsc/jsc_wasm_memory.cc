// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_memory.h"

#include <cmath>
#include <limits>

#include "common/messages.h"
#include "common/wasm_utils.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"

namespace primjs::jsc {

namespace {
void ReleaseJSCBufferMemory(void* bytes, void* context) {
  (void)bytes;
  if (!context) return;
  auto* keep = static_cast<wasm::WasmBufferKeep*>(context);
  keep->DropOnce();
  delete keep;
}
}  // namespace

JSClassRef JSCWasmMemory::class_ref() {
  static JSClassRef ref = InitClassRef();
  return ref;
}

JSClassRef JSCWasmMemory::prototype_class_ref() {
  static JSClassRef ref = InitProtoClassRef();
  return ref;
}

JSClassRef JSCWasmMemory::constructor_class_ref() {
  static JSClassRef ref = InitCtorClassRef();
  return ref;
}

JSClassRef JSCWasmMemory::InitClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Memory", Finalize);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmMemory::InitProtoClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Memory.Prototype", nullptr);
  const JSPropertyAttributes default_attr = JSClassCreator::DefaultAttr();
  static const JSStaticFunction static_funcs[] = {
      {"grow", GrowCallback, default_attr}, {nullptr, nullptr, 0}};
  def.staticFunctions = static_funcs;
  return JSClassCreate(&def);
}

JSClassRef JSCWasmMemory::InitCtorClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition(
      "WebAssembly.Memory", nullptr, CallAsConstructor);
  return JSClassCreate(&def);
}

void JSCWasmMemory::ReleaseClassRef() {
  JSClassRelease(prototype_class_ref());
  JSClassRelease(constructor_class_ref());
  JSClassRelease(class_ref());
}

JSCWasmMemory::JSCWasmMemory(JSCEnv* env, wasm_memory_t* memory,
                             uint32_t maximum, JSObjectRef js_obj)
    : store_owner_(env->store_owner()),
      memory_(memory),
      maximum_(maximum),
      pages_(memory ? (wasm_memory_data_size(memory) / kWasmPageSize) : 0),
      js_obj_(js_obj) {
  wasm::WasmStoreOwner::Retain(store_owner_);
  store_owner_->LinkHandle(&tracked_, this, DetachOnExit);
  wasm_memory_set_host_info(memory_, this);
}

JSCWasmMemory::~JSCWasmMemory() {
  if (buffer_ && store_owner_) {
    if (JSCEnv* env = store_owner_->active_jsc_env()) {
      env->UnprotectWasmMemoryBufferLater(buffer_);
    }
  }
  if (store_owner_) {
    store_owner_->UnlinkHandle(&tracked_);
  }
  DetachWasmMemory();
}

void JSCWasmMemory::DetachWasmMemory() {
  if (memory_) {
    if (Of(memory_) == this) {
      wasm_memory_set_host_info(memory_, nullptr);
    }
    wasm_memory_delete(memory_);
    memory_ = nullptr;
  }
  wasm::WasmStoreOwner::Release(store_owner_);
}

void JSCWasmMemory::DetachOnExit(wasm::WasmTrackedHandle* handle,
                                 void* exit_ctx) {
  (void)exit_ctx;
  auto* self = static_cast<JSCWasmMemory*>(handle->owner_object);
  self->buffer_ = nullptr;
  self->DetachWasmMemory();
}

void JSCWasmMemory::Finalize(JSObjectRef object) {
  auto* mem = static_cast<JSCWasmMemory*>(JSObjectGetPrivate(object));
  delete mem;
}

JSObjectRef JSCWasmMemory::CreatePrototype(JSContextRef ctx,
                                           JSValueRef* exception) {
  JSObjectRef prototype = JSObjectMake(ctx, prototype_class_ref(), nullptr);
  PropertyDescriptor instance_values[] = {
      {"buffer", GetBufferCallback, nullptr, PropertyAttributes::None},
      {nullptr, nullptr, nullptr, PropertyAttributes::None}};
  DefineProperties(ctx, prototype, instance_values, exception);
  return prototype;
}

JSObjectRef JSCWasmMemory::CreateConstructor(JSContextRef ctx, JSCEnv* env,
                                             JSValueRef* exception) {
  JSObjectRef ctor = JSObjectMake(ctx, constructor_class_ref(), env);
  JSObjectRef prototype = CreatePrototype(ctx, exception);
  InitConstructor(ctx, ctor, "Memory", prototype, exception);
  env->SetMemoryConstructor(ctor);
  return ctor;
}

bool JSCWasmMemory::IsJSCWasmMemory(JSContextRef ctx, JSValueRef target) {
  if (!target || !JSValueIsObjectOfClass(ctx, target, class_ref())) {
    return false;
  }
  auto* mem = static_cast<JSCWasmMemory*>(
      JSObjectGetPrivate(JSValueToObject(ctx, target, nullptr)));
  return mem != nullptr && mem->memory_ != nullptr;
}

JSObjectRef JSCWasmMemory::WrapOwnedMemory(JSContextRef ctx, JSCEnv* env,
                                           wasm_memory_t* memory,
                                           uint32_t maximum,
                                           JSValueRef* exception) {
  JSObjectRef ctor = env->js_memory_constructor();
  if (wasm_unlikely(!ctor)) return nullptr;
  JSValueRef maybe_proto = JSObjectGetProperty(
      ctx, ctor, JSCBuiltinObjects::PrototypeStr(), exception);
  if (exception && *exception) return nullptr;
  JSObjectRef prototype = JSValueToObject(ctx, maybe_proto, exception);
  if ((exception && *exception) || !prototype) return nullptr;

  JSObjectRef obj = JSObjectMake(ctx, class_ref(), nullptr);
  if (!RetainWasmRootOnJSCObject(ctx, obj, env->wasm_root(), exception)) {
    return nullptr;
  }
  JSObjectSetPrototype(ctx, obj, prototype);
  auto* memory_data = new JSCWasmMemory(env, memory, maximum, obj);
  WASM_CHECK(JSObjectSetPrivate(obj, memory_data));
  return obj;
}

JSObjectRef JSCWasmMemory::GetOrWrapOwnedMemory(JSContextRef ctx, JSCEnv* env,
                                                wasm_memory_t* memory,
                                                JSValueRef* exception) {
  if (!memory) return nullptr;
  if (JSCWasmMemory* existing = Of(memory)) {
    JSObjectRef obj = existing->js_object();
    wasm_memory_delete(memory);
    return obj;
  }
  uint32_t maximum = wasm_limits_max_default;
  if (wasm_memorytype_t* mtype = wasm_memory_type(memory)) {
    if (const wasm_limits_t* limits = wasm_memorytype_limits(mtype)) {
      maximum = limits->max;
    }
    wasm_memorytype_delete(mtype);
  }
  JSObjectRef wrapped = WrapOwnedMemory(ctx, env, memory, maximum, exception);
  if (!wrapped) {
    wasm_memory_delete(memory);
  }
  return wrapped;
}

JSObjectRef JSCWasmMemory::CallAsConstructor(JSContextRef ctx,
                                             JSObjectRef constructor,
                                             size_t argc,
                                             const JSValueRef argv[],
                                             JSValueRef* exception) {
  constexpr const char* code = "WebAssembly.Memory()";

  auto* env = static_cast<JSCEnv*>(JSObjectGetPrivate(constructor));
  if (!env || !env->wasm_store()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "WebAssembly context is not active", exception);
  }
  if (argc == 0 || !JSValueIsObject(ctx, argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kDescriptorNeeded_1002, exception);
  }

  JSObjectRef desc = JSValueToObject(ctx, argv[0], exception);
  if ((exception && *exception) || !desc) return nullptr;

  auto read_pages = [&](JSValueRef val, uint32_t* out) {
    double n = JSValueToNumber(ctx, val, exception);
    if (exception && *exception) return false;
    if (!std::isfinite(n) || n < 0 ||
        n > static_cast<double>(std::numeric_limits<uint32_t>::max())) {
      ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                       ErrorMessages::kNoConvertibleNum_1002, exception);
      return false;
    }
    *out = static_cast<uint32_t>(std::trunc(n));
    return true;
  };

  JSValueRef initial =
      JSObjectGetProperty(ctx, desc, JSString("initial"), exception);
  if (exception && *exception) return nullptr;
  if (JSValueIsUndefined(ctx, initial)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Property 'initial' is required", exception);
  }
  uint32_t init_pages = 0;
  if (!read_pages(initial, &init_pages)) return nullptr;

  uint32_t max_pages = kMaxPagesNum;
  JSValueRef maximum =
      JSObjectGetProperty(ctx, desc, JSString("maximum"), exception);
  if (exception && *exception) return nullptr;
  if (!JSValueIsUndefined(ctx, maximum)) {
    if (!read_pages(maximum, &max_pages)) return nullptr;
    if (init_pages > max_pages) {
      return ThrowIfException(
          ctx, ErrorTypes::kRangeError, code,
          "Property 'maximum': value is below the lower bound 'initial'",
          exception);
    }
  }
  if (init_pages > kMaxPagesNum || max_pages > kMaxPagesNum) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            ErrorMessages::kMemoryAllocFailed_1001, exception);
  }

  wasm_limits_t limits = {init_pages, max_pages};
  wasm_memorytype_t* mtype = wasm_memorytype_new(&limits);
  wasm_memory_t* memory =
      mtype ? wasm_memory_new(env->wasm_store(), mtype) : nullptr;
  if (mtype) wasm_memorytype_delete(mtype);
  if (wasm_unlikely(!memory)) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            ErrorMessages::kMemoryAllocFailed_1001, exception);
  }

  JSObjectRef wrapped = WrapOwnedMemory(ctx, env, memory, max_pages, exception);
  if (!wrapped) {
    wasm_memory_delete(memory);
  }
  return wrapped;
}

JSValueRef JSCWasmMemory::GetBufferCallback(JSContextRef ctx,
                                            JSObjectRef function,
                                            JSObjectRef thisObject, size_t argc,
                                            const JSValueRef argv[],
                                            JSValueRef* exception) {
  (void)function;
  (void)argc;
  (void)argv;
  constexpr const char* code = "WebAssembly.Memory.buffer";

  if (!JSValueIsObjectOfClass(ctx, thisObject, class_ref())) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kIllegalInvocation_1001, exception);
    return JSValueMakeUndefined(ctx);
  }
  auto* jsc_memory =
      static_cast<JSCWasmMemory*>(JSObjectGetPrivate(thisObject));
  JSCEnv* env = jsc_memory && jsc_memory->store_owner_
                    ? jsc_memory->store_owner_->active_jsc_env()
                    : nullptr;
  if (!jsc_memory || !jsc_memory->memory_ || !env) {
    ThrowIfException(ctx, ErrorTypes::kError, code,
                     "No private data found in WebAssembly.Memory!", exception);
    return JSValueMakeUndefined(ctx);
  }

  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    const size_t current_pages = jsc_memory->pages();
    void* raw_data = wasm_memory_data(jsc_memory->memory_);

    if (!jsc_memory->buffer_ || jsc_memory->pages_ != current_pages) {
      if (raw_data == nullptr) {
        raw_data = static_cast<void*>(&jsc_memory->pages_);
      }
      const size_t buffer_size = current_pages * kWasmPageSize;

      wasm::WasmBufferKeep* keep = nullptr;
      if (buffer_size != 0) {
        keep = wasm::WasmBufferKeep::Create(jsc_memory->store_owner_,
                                            jsc_memory->memory_);
        if (wasm_unlikely(!keep)) {
          ThrowIfException(ctx, ErrorTypes::kError, code,
                           "Unable to retain WebAssembly.Memory buffer",
                           exception);
          return JSValueMakeUndefined(ctx);
        }
      }
      // Note: per JSC's API contract, JSObjectMakeArrayBufferWithBytesNoCopy
      // always invokes `ReleaseJSCBufferMemory` even when throwing/failing.
      JSObjectRef new_buffer = JSObjectMakeArrayBufferWithBytesNoCopy(
          ctx, raw_data, buffer_size, keep ? ReleaseJSCBufferMemory : nullptr,
          keep, exception);
      if (!new_buffer) {
        return JSValueMakeUndefined(ctx);
      }
      env->UnprotectWasmMemoryBuffer(jsc_memory->buffer_);
      jsc_memory->buffer_ = new_buffer;
      jsc_memory->pages_ = current_pages;
      env->ProtectWasmMemoryBuffer(new_buffer);
    }
    return jsc_memory->buffer_ ? jsc_memory->buffer_
                               : JSValueMakeUndefined(ctx);
  }

  ThrowIfException(ctx, ErrorTypes::kError, code,
                   ErrorMessages::kOSVersionUnsupported_1001, exception);
  return JSValueMakeUndefined(ctx);
}

JSValueRef JSCWasmMemory::GrowCallback(JSContextRef ctx, JSObjectRef function,
                                       JSObjectRef thisObject, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception) {
  (void)function;
  constexpr const char* code = "WebAssembly.Memory.grow()";

  if (!JSValueIsObjectOfClass(ctx, thisObject, class_ref())) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kIllegalInvocation_1001, exception);
    return JSValueMakeUndefined(ctx);
  }
  auto* memory = static_cast<JSCWasmMemory*>(JSObjectGetPrivate(thisObject));
  if (!memory || !memory->memory_ || argc < 1) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kNoConvertibleNum_1001, exception);
    return JSValueMakeUndefined(ctx);
  }

  if (!JSValueIsNumber(ctx, argv[0])) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kNoConvertibleNum_1002, exception);
    return JSValueMakeUndefined(ctx);
  }
  double requested_pages = JSValueToNumber(ctx, argv[0], exception);
  if (exception && *exception) return JSValueMakeUndefined(ctx);
  requested_pages = std::trunc(requested_pages);
  if (!std::isfinite(requested_pages) || requested_pages < 0 ||
      requested_pages > std::numeric_limits<uint32_t>::max()) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kNoConvertibleNum_1002, exception);
    return JSValueMakeUndefined(ctx);
  }

  const uint32_t grow_pages = static_cast<uint32_t>(requested_pages);
  const size_t old_pages = memory->pages();
  if (grow_pages == 0 || wasm_memory_grow(memory->memory_, grow_pages)) {
    return JSValueMakeNumber(ctx, static_cast<double>(old_pages));
  }

  ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                   ErrorMessages::kGrowFailed_1001, exception);
  return JSValueMakeUndefined(ctx);
}

}  // namespace primjs::jsc
