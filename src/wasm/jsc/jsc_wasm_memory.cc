// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_memory.h"

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/interop_runtime.h"
#include "common/js_type.h"
#include "common/messages.h"
#include "common/wasm_type.h"
#include "common/wasm_utils.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"

namespace primjs::jsc {

JSClassRef JSCWasmMemory::class_ref() {
  static JSClassRef class_ref = JSCWasmMemory::InitClassRef();
  return class_ref;
}
JSClassRef JSCWasmMemory::prototype_class_ref() {
  static JSClassRef prototype_class_ref = JSCWasmMemory::InitProtoClassRef();
  return prototype_class_ref;
}
JSClassRef JSCWasmMemory::constructor_class_ref() {
  static JSClassRef constructor_class_ref = JSCWasmMemory::InitCtorClassRef();
  return constructor_class_ref;
}

JSClassRef JSCWasmMemory::InitClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Memory", Finalize);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmMemory::InitProtoClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Memory.Prototype", NULL);

  JSPropertyAttributes default_attr = JSClassCreator::DefaultAttr();

  JSStaticFunction static_funcs[] = {{"grow", GrowCallback, default_attr},
                                     {0, 0, 0}};
  def.staticFunctions = static_funcs;
  return JSClassCreate(&def);
}

JSClassRef JSCWasmMemory::InitCtorClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition(
      "WebAssembly.Memory", NULL, CallAsConstructor);
  return JSClassCreate(&def);
}

void JSCWasmMemory::ReleaseClassRef() {
  JSClassRelease(prototype_class_ref());
  JSClassRelease(constructor_class_ref());
  JSClassRelease(class_ref());
}

JSCWasmMemory::JSCWasmMemory(WasmMemoryRef memory, size_t pages,
                             InteropRuntime* interop)
    : memory_(std::move(memory)), pages_(pages), buffer_(nullptr) {
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
}

JSCWasmMemory::~JSCWasmMemory() {
  WLOGD("Running JSCWasmMemory::%s...", __func__);
  if (memory_.is<Wasm3Memory*>()) {
    delete memory_.get<Wasm3Memory*>();
  } else {
    delete memory_.get<PrismMemory*>();
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

// static
void JSCWasmMemory::Finalize(JSObjectRef object) {
  WLOGD("Running JSCWasmMemory::%s...", __func__);
  auto memory = static_cast<JSCWasmMemory*>(JSObjectGetPrivate(object));
  delete memory;
}

// static
JSObjectRef JSCWasmMemory::CreatePrototype(JSContextRef ctx,
                                           JSValueRef* exception) {
  JSObjectRef prototype = JSObjectMake(ctx, prototype_class_ref(), NULL);

  PropertyDescriptor instance_values[] = {
      {"buffer", GetBufferCallback, 0, PropertyAttributes::None},
      {0, 0, 0, PropertyAttributes::None}};
  DefineProperties(ctx, prototype, instance_values, exception);

  return prototype;
}

// static
JSObjectRef JSCWasmMemory::CreateConstructor(JSContextRef ctx,
                                             InteropRuntime* interop,
                                             JSValueRef* exception) {
  JSObjectRef ctor = JSObjectMake(ctx, constructor_class_ref(), interop);

  JSObjectRef prototype = CreatePrototype(ctx, exception);
  InitConstructor(ctx, ctor, "Memory", prototype, exception);

  auto js_env = interop->js_env<JSCEnv*>();
  js_env->SetMemoryConstructor(ctor);

  return ctor;
}

// static
JSObjectRef JSCWasmMemory::CreateJSObject(JSContextRef ctx,
                                          JSObjectRef constructor,
                                          WasmMemoryRef memory, size_t pages,
                                          JSValueRef* exception) {
  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  WASM_DCHECK(interop != nullptr);
  auto memory_data = new JSCWasmMemory(memory, pages, interop);

  JSObjectRef obj = JSObjectMake(ctx, class_ref(), memory_data);

  JSValueRef maybe_prototype = JSObjectGetProperty(
      ctx, constructor, JSCBuiltinObjects::PrototypeStr(), exception);
  JSObjectRef prototype = JSValueToObject(ctx, maybe_prototype, exception);

  JSObjectSetPrototype(ctx, obj, prototype);

  return obj;
}

// static
JSObjectRef JSCWasmMemory::CallAsConstructor(JSContextRef ctx,
                                             JSObjectRef constructor,
                                             size_t argc,
                                             const JSValueRef argv[],
                                             JSValueRef* exception) {
  WLOGD("Running JSCWasmMemory::%s...", __func__);
  constexpr const char* code = "WebAssembly.Memory()";

  if (argc == 0 || !JSValueIsObject(ctx, argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kDescriptorNeeded_1002, exception);
  }

  JSObjectRef memory_descriptor = JSValueToObject(ctx, argv[0], exception);

  uint32_t initial_page_count = 0;
  {
    JSValueRef initial = JSObjectGetProperty(ctx, memory_descriptor,
                                             JSString("initial"), exception);
    if (exception && *exception) return nullptr;
    initial_page_count =
        static_cast<uint32_t>(JSValueToNumber(ctx, initial, exception));
    if (exception && *exception) return nullptr;
  }

  uint32_t maximum_page_count = kMaxPagesNum;
  {
    JSValueRef maximum = JSObjectGetProperty(ctx, memory_descriptor,
                                             JSString("maximum"), exception);

    if (!JSValueIsUndefined(ctx, maximum)) {
      maximum_page_count =
          static_cast<uint32_t>(JSValueToNumber(ctx, maximum, exception));

      if (initial_page_count > maximum_page_count) {
        return ThrowIfException(
            ctx, ErrorTypes::kRangeError, code,
            "Property 'maximum': value is below the lower bound 'initial'",
            exception);
      }
    }
  }

  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  WasmResult result = WasmSucceed;
  WasmMemoryRef memory =
      interop->CreateWasmMemory(initial_page_count, maximum_page_count, result);
  if (result) {
    return ThrowIfException(ctx, ErrorTypes::kError, code, result, exception);
  }

  return CreateJSObject(ctx, constructor, memory, initial_page_count,
                        exception);
}

// static
JSValueRef JSCWasmMemory::GetBufferCallback(JSContextRef ctx,
                                            JSObjectRef function,
                                            JSObjectRef thisObject, size_t argc,
                                            const JSValueRef argv[],
                                            JSValueRef* exception) {
  WLOGD("Running JSCWasmMemory::%s...", __func__);
  constexpr const char* code = "WebAssembly.Memory.buffer";

  auto jsc_memory = static_cast<JSCWasmMemory*>(JSObjectGetPrivate(thisObject));
  if (!jsc_memory) {
    return ThrowIfException(ctx, ErrorTypes::kError, code,
                            "No private data found in WebAssembly.Memory!",
                            exception);
  }

  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    WasmMemoryRef wasm_memory = jsc_memory->memory_;

    uint32_t pages = 0;
    void* buffer = nullptr;
    // Get Pages and Buffer from Wasm3Memory
    if (wasm_memory.is<Wasm3Memory*>()) {
      auto wasm3_memory = wasm_memory.get<Wasm3Memory*>();
      pages = wasm3_memory->pages();
      buffer = wasm3_memory->buffer();
    } else {
      auto prism_memory = wasm_memory.get<PrismMemory*>();
      pages = prism_memory->pages();
      buffer = prism_memory->buffer();
    }

    // When pages_ != memory->memory_->pages(), it backing wasm memory is
    // updated actually, we must provide a new buffer and detach the old one.
    if (!jsc_memory->buffer_ || jsc_memory->pages_ != pages) {
      // Reasonably speaking, the old buffer must be make detached here,
      // but actually no operation will be taken given that no such
      // interface is provided by JavaScriptCore,
      JSValueUnprotect(ctx, jsc_memory->buffer_);

      if (buffer == nullptr) {
        // This is a trick to persuade JSC to create an ArrayBuffer
        // with zero length and no valid backing store.
        // Otherwise JSC always create a detached ArrayBuffer
        // as the pointer of its backing store is nullptr.
        buffer = static_cast<void*>(&(jsc_memory->pages_));
      }

      jsc_memory->pages_ = pages;
      size_t buffer_size = jsc_memory->pages_ * kWasmPageSize;

      jsc_memory->buffer_ = JSObjectMakeArrayBufferWithBytesNoCopy(
          ctx, buffer, buffer_size, nullptr, nullptr, exception);

      JSValueProtect(ctx, jsc_memory->buffer_);
    }

    return jsc_memory->buffer_;
  }

  return ThrowIfException(ctx, ErrorTypes::kError, code,
                          ErrorMessages::kOSVersionUnsupported_1001, exception);
}

// static
JSValueRef JSCWasmMemory::GrowCallback(JSContextRef ctx, JSObjectRef function,
                                       JSObjectRef thisObject, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception) {
  WLOGD("Running JSCWasmMemory::%s...", __func__);
  constexpr const char* code = "WebAssembly.Memory.grow()";

  auto memory = static_cast<JSCWasmMemory*>(JSObjectGetPrivate(thisObject));
  if (!memory || argc < 1) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1001, exception);
  }
  size_t grow_pages = 0;
  JSValueRef num_obj = argv[0];
  if (JSValueIsNumber(ctx, num_obj)) {
    grow_pages = JSValueToNumber(ctx, num_obj, exception);
  } else {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1002, exception);
  }

  // grow the memory size
  uint32_t pages = 0;
  if (memory->memory_.is<Wasm3Memory*>()) {
    auto wasm3_memory = memory->memory_.get<Wasm3Memory*>();
    pages = wasm3_memory->pages();
    if (grow_pages == 0 || wasm3_memory->grow(grow_pages)) {
      return JSValueMakeNumber(ctx, pages);
    }
  } else {
    auto prism_memory = memory->memory_.get<PrismMemory*>();
    pages = prism_memory->pages();
    if (grow_pages == 0 || prism_memory->grow(grow_pages)) {
      return JSValueMakeNumber(ctx, pages);
    }
  }

  return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                          ErrorMessages::kGrowFailed_1001, exception);
}

}  // namespace primjs::jsc
