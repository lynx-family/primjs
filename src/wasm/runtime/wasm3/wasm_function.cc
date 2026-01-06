// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/wasm3/wasm_function.h"

#include <cstddef>

#include "common/js_type.h"
#include "common/wasm_utils.h"
#include "qjs/js_env_qjs.h"
#if defined(__APPLE__)
#include "jsc/jsc_wasm_function.h"
#endif
#include "qjs/qjs_wasm_function.h"
#include "runtime/wasm3/wasm_instance.h"
#include "runtime/wasm3/wasm_runtime.h"

namespace primjs::wasm {
Wasm3Function::Wasm3Function(IM3Function m3_function, Wasm3Runtime* runtime,
                             Wasm3Instance* instance)
    : runtime_(runtime), instance_(instance), m3_function_(m3_function) {
  WLOGD("Running Wasm3Function::%s...", __func__);
  Wasm3Instance::IncreaseRefCount(instance);
}

Wasm3Function::Wasm3Function(JSValueRefs js_function, Wasm3Runtime* rt,
                             Wasm3Instance* instance, IM3Function m3_func)
    : runtime_(rt),
      instance_(instance),
      m3_function_(m3_func),
      js_function_(std::move(js_function)) {
  WLOGD("Running Wasm3Function::%s...", __func__);
  Wasm3Instance::IncreaseRefCount(instance);
}

Wasm3Function::~Wasm3Function() {
  // // TODO when wasm_func_cache's js object is packed up using external js
  // function(imported js function)
  // // the external js function needs to be freed
  // auto js_env = runtime_->js_env();
  // if (js_function_.is<WASMGCPersistent>() && js_env.is<QJSEnv*>() &&
  // m3_function_ == nullptr) {
  //   js_env.get<QJSEnv*>()->FreeValue(js_function_.get<WASMGCPersistent>());
  // } else if (js_function_.is<JSObjectRef>()) {
  //   js_env.get<JSCEnv*>()->FreeValue(js_function_.get<JSObjectRef>());
  // }
  WLOGD("Running Wasm3Function::%s...", __func__);
  Wasm3Instance::DecreaseRefCount(instance_);
}

// Stack structure from wasm.
// [Stack Bottom]
//                 |<--------------      4 Bytes     --------------->|
// +---------------+-------------------------------------------------+
// |               |   Part 1 [f32/i32, f64/i64-low bits]            |
// + _ Return Val_ +-------------------------------------------------+
// |               |   Part 2 [f64/i64-high bits]                    |
// +---------------+-------------------------------------------------+
// |               |   Part 1 [f32/i32, f64/i64-low bits]            |
// + _ Arg 2     _ +-------------------------------------------------+
// |               |   Part 2 [f64/i64-high bits]                    |
// +---------------+-------------------------------------------------+
// |               |   Part 1 [f32/i32, f64/i64-low bits]            |
// + _ Arg 1     _ +-------------------------------------------------+
// |               |   Part 2 [f64/i64-high bits]                    |
// +---------------+-------------------------------------------------+
// |               |   Part 1 [f32/i32, f64/i64-low bits]            |
// + _  ... ...  _ +-------------------------------------------------+
// |               |   Part 2 [f64/i64-high bits]                    |
// +---------------+-------------------------------------------------+
// [Stack Top]
const void* Wasm3Function::QJSWasmCallback(IM3Runtime runtime,
                                           IM3ImportContext _ctx, u64* _sp,
                                           void* _mem) {
  IM3Function m3_function = _ctx->function;
  auto wasm3_function = reinterpret_cast<Wasm3Function*>(_ctx->userdata);
  Wasm3Runtime* wasm3_runtime = wasm3_function->runtime_;

  WLOGD("Wasm3Function ret count: %d", m3_GetRetCount(m3_function));
  u32 ret_count = m3_GetRetCount(m3_function);
  u64* raw_return = nullptr;
  if (ret_count > 0) {
    // Only support one return value.
    raw_return = ((u64*)(_sp++));
  }

  auto js_env = wasm3_runtime->js_env().get<QJSEnv*>();

  // No pointer here in argv.
  u32 argc = m3_GetArgCount(m3_function);
  QJSEnv::JSValue js_args[argc];
  for (u32 i = 0; i < argc; ++i) {
    m3ApiGetArg(u64, arg);
    M3TaggedValue tagged_value;
    tagged_value.type = m3_GetArgType(m3_function, i);
    tagged_value.value.i64 = arg;
    wasm3_runtime->ToJSValue(js_env, js_args + i, &tagged_value);
  }

  QJSEnv::JSValue exception = LEPUS_UNDEFINED;
  WASM_CHECK(wasm3_function->js_function_.is<WASMGCPersistent>());
  LEPUSValue ret_val =
      js_env
          ->CallAsFunction(wasm3_function->js_function_.get<WASMGCPersistent>(),
                           js_env->MakeUndefined(), argc, js_args, &exception)
          .Get();

  if (!js_env->IsUndefined(exception)) {
    m3ApiTrap("JS Function calls failed.");
  }

  // Only support one return value.
  if (ret_count > 0) {
    M3TaggedValue tagged_value;
    tagged_value.type = m3_GetRetType(m3_function, 0);
    if (!wasm3_runtime->ToWebAssemblyValue(js_env, ret_val, &tagged_value)) {
      m3ApiTrap("Failed to convert JS return value to WebAssembly value.");
    }
    *raw_return = tagged_value.value.i64;
    return m3Err_none;
  }

  m3ApiSuccess();
}

#if defined(__APPLE__)
const void* Wasm3Function::JSCWasmCallback(IM3Runtime runtime,
                                           IM3ImportContext _ctx, u64* _sp,
                                           void* _mem) {
  IM3Function m3_function = _ctx->function;

  auto wasm3_function = reinterpret_cast<Wasm3Function*>(_ctx->userdata);
  WASM_DCHECK(wasm3_function != nullptr);

  Wasm3Runtime* wasm3_runtime = wasm3_function->runtime_;
  WASM_DCHECK(wasm3_runtime != nullptr);

  WLOGD("Wasm3Function ret count: %d", m3_GetRetCount(m3_function));
  u32 ret_count = m3_GetRetCount(m3_function);
  u64* raw_return = nullptr;
  if (ret_count > 0) {
    // Only support one return value.
    raw_return = ((u64*)(_sp++));
  }

  JSCEnv* js_env = nullptr;
  if (wasm3_runtime->js_env().is<JSCEnv*>()) {
    js_env = wasm3_runtime->js_env().get<JSCEnv*>();
  }
  WASM_DCHECK(js_env != nullptr);

  // No pointer here in argv.
  u32 argc = m3_GetArgCount(m3_function);
  JSValueRef js_args[argc];
  for (u32 i = 0; i < argc; ++i) {
    m3ApiGetArg(u64, arg);
    M3TaggedValue tagged_value;
    tagged_value.type = m3_GetArgType(m3_function, i);
    tagged_value.value.i64 = arg;
    wasm3_runtime->ToJSValue(js_env, js_args + i, &tagged_value);
  }

  JSValueRef exception{};
  JSValueRef undef = js_env->MakeUndefined();
  WASM_CHECK(wasm3_function->js_function_.is<JSObjectRef>());
  JSValueRef ret_val = js_env->CallAsFunction(
      wasm3_function->js_function_.get<JSObjectRef>(),
      js_env->ValueToObject(undef), argc, js_args, &exception);
  if (exception) {
    JSStringRef exceptionStr =
        JSValueToStringCopy(js_env->js_ctx(), exception, nullptr);
    size_t exceptionUTF8Size = JSStringGetMaximumUTF8CStringSize(exceptionStr);
    char* exceptionUTF8 = new char[exceptionUTF8Size];
    JSStringGetUTF8CString(exceptionStr, exceptionUTF8, exceptionUTF8Size);
    LOGE("JS Function calls failed " << exceptionUTF8);
    JSStringRelease(exceptionStr);
    delete[] exceptionUTF8;
    m3ApiTrap("JS Function calls failed.");
  }

  // Only support one return value.
  if (ret_count > 0) {
    M3TaggedValue tagged_value;
    tagged_value.type = m3_GetRetType(m3_function, 0);
    if (!wasm3_runtime->ToWebAssemblyValue(js_env, ret_val, &tagged_value)) {
      m3ApiTrap("Failed to convert JS return value to WebAssembly value.");
    }
    *raw_return = tagged_value.value.i64;
    return m3Err_none;
  }

  m3ApiSuccess();
}
#endif

}  // namespace primjs::wasm
