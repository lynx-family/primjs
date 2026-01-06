// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_function.h"

#include "common/wasm_log.h"
#if defined(__APPLE__)
#include "jsc/js_env_jsc.h"
#endif
#include "qjs/js_env_qjs.h"
#include "runtime/prism/wasm_instance.h"
#include "runtime/prism/wasm_runtime.h"

namespace primjs::wasm {

PrismFunction::PrismFunction(JSValueRefs js_function, PrismRuntime* rt)
    : runtime_(rt),
      function_(nullptr),
      js_function_(std::move(js_function)),
      instance_(nullptr) {
  WLOGD("Running PrismFunction::%s...", __func__);
}

PrismFunction::PrismFunction(wasm_func_t* w_func, PrismRuntime* rt,
                             PrismInstance* instance)
    : runtime_(rt), function_(w_func), instance_(instance) {
  WLOGD("Running PrismFunction::%s...", __func__);
  PrismInstance::IncreaseRefCount(instance);
}

PrismFunction::~PrismFunction() {
  // TOOD function_ pointer may need to be deleted using `wasm_func_delete`
  WLOGD("Running PrismFunction::%s...", __func__);
  PrismInstance::DecreaseRefCount(instance_);
}

// pc structure when using native callback to adapt to native call from prism
// handler pc : prism_func* pc + 1 : 0 pc + 2 : 1
// ...
// pc + args_size : arg_size - 1

uint64_t PrismFunction::QJSPrismCallback(prism_mcp_slot* pc, prism_st* st,
                                         prism_mem* mem) {
  prism_func* func = *((prism_func**)(pc++));
  PrismFunction* pack =
      reinterpret_cast<PrismFunction*>(prism_get_prism_func_userdata(func));
  PrismRuntime* prism_runtime = pack->runtime_;
  auto js_env = prism_runtime->js_env().get<qjs::QJSEnv*>();

  // No pointer here in arguments.
  uint32_t retc = func->info.ret_nb;
  uint32_t argc = func->info.arg_nb;
  QJSEnv::JSValue js_args[argc];
  prism_value_type* arg_types = func->info.type + retc;
  for (uint32_t i = 0; i < argc; ++i) {
    // when QJSPrismCallback is called through wasm function call , `st` was
    // re-assgined, so we need to use `*((uint64_t*)(pc++))` to get stack args
    prism_runtime->ToJSValue(js_env, &js_args[i], arg_types[i],
                             st + *((uint64_t*)(pc++)));
  }

  QJSEnv::JSValue exception = js_env->MakeUndefined();
  QJSEnv::JSValue ret_val = js_env->CallAsFunction(
      pack->js_function_.get<QJSEnv::JSValue>(), js_env->MakeUndefined(), argc,
      js_args, &exception);

  // Only support one return value.
  WLOGI("WasmCallback ret count: %d\n", retc);
  uint64_t ret = 0;
  if (retc > 0) {
    prism_runtime->ToWebAssemblyValue(js_env, ret_val, *(func->info.type),
                                      &ret);
  }
  return ret;
}

double PrismFunction::QJSPrismCallback_f(prism_mcp_slot* pc, prism_st* st,
                                         prism_mem* mem) {
  prism_func* func = *((prism_func**)(pc++));
  PrismFunction* pack =
      reinterpret_cast<PrismFunction*>(prism_get_prism_func_userdata(func));
  PrismRuntime* prism_runtime = pack->runtime_;
  auto js_env = prism_runtime->js_env().get<qjs::QJSEnv*>();

  // No pointer here in arguments.
  uint32_t retc = func->info.ret_nb;
  uint32_t argc = func->info.arg_nb;
  QJSEnv::JSValue js_args[argc];
  prism_value_type* arg_types = func->info.type + retc;
  for (uint32_t i = 0; i < argc; ++i) {
    prism_runtime->ToJSValue(js_env, &js_args[i], arg_types[i],
                             st + *((uint64_t*)(pc++)));
  }

  QJSEnv::JSValue exception = js_env->MakeUndefined();
  QJSEnv::JSValue ret_val = js_env->CallAsFunction(
      pack->js_function_.get<QJSEnv::JSValue>(), js_env->MakeUndefined(), argc,
      js_args, &exception);

  // Only support one return value.
  WLOGI("WasmCallback ret count: %d\n", retc);
  double ret = 0;
  if (retc > 0) {
    prism_runtime->ToWebAssemblyValue(js_env, ret_val, *(func->info.type),
                                      (uint64_t*)&ret);
  }
  return ret;
}

#if defined(__APPLE__)

uint64_t PrismFunction::JSCPrismCallback(prism_mcp_slot* pc, prism_st* st,
                                         prism_mem* mem) {
  prism_func* func = *((prism_func**)(pc++));
  PrismFunction* pack =
      reinterpret_cast<PrismFunction*>(prism_get_prism_func_userdata(func));
  PrismRuntime* prism_runtime = pack->runtime_;
  auto js_env = prism_runtime->js_env().get<jsc::JSCEnv*>();

  // No pointer here in arguments.
  uint32_t retc = func->info.ret_nb;
  uint32_t argc = func->info.arg_nb;
  JSValueRef js_args[argc];
  prism_value_type* arg_types = func->info.type + retc;
  for (uint32_t i = 0; i < argc; ++i) {
    prism_runtime->ToJSValue(js_env, &js_args[i], arg_types[i],
                             st + *((uint64_t*)(pc++)));
  }

  JSValueRef exception = js_env->MakeUndefined();
  JSObjectRef undef = js_env->ValueToObject(exception);
  JSValueRef ret_val = js_env->CallAsFunction(
      pack->js_function_.get<JSObjectRef>(), undef, argc, js_args, &exception);

  // Only support one return value.
  WLOGI("WasmCallback ret count: %d\n", retc);
  uint64_t ret = 0;
  if (retc > 0) {
    prism_runtime->ToWebAssemblyValue(js_env, ret_val, *(func->info.type),
                                      &ret);
  }
  return ret;
}

double PrismFunction::JSCPrismCallback_f(prism_mcp_slot* pc, prism_st* st,
                                         prism_mem* mem) {
  prism_func* func = *((prism_func**)(pc++));
  PrismFunction* pack =
      reinterpret_cast<PrismFunction*>(prism_get_prism_func_userdata(func));
  PrismRuntime* prism_runtime = pack->runtime_;
  auto js_env = prism_runtime->js_env().get<jsc::JSCEnv*>();

  // No pointer here in arguments.
  uint32_t retc = func->info.ret_nb;
  uint32_t argc = func->info.arg_nb;
  JSValueRef js_args[argc];
  prism_value_type* arg_types = func->info.type + retc;
  for (uint32_t i = 0; i < argc; ++i) {
    prism_runtime->ToJSValue(js_env, &js_args[i], arg_types[i],
                             st + *((uint64_t*)(pc++)));
  }

  JSValueRef exception = js_env->MakeUndefined();
  JSObjectRef undef = js_env->ValueToObject(exception);
  JSValueRef ret_val = js_env->CallAsFunction(
      pack->js_function_.get<JSObjectRef>(), undef, argc, js_args, &exception);

  // Only support one return value.
  WLOGI("WasmCallback ret count: %d\n", retc);
  double ret = 0;
  if (retc > 0) {
    prism_runtime->ToWebAssemblyValue(js_env, ret_val, *(func->info.type),
                                      (uint64_t*)&ret);
  }
  return ret;
}

#endif
}  // namespace primjs::wasm
