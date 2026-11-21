// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <JavaScriptCore/JavaScript.h>

#include <cstdio>
#include <cstdlib>
#include <initializer_list>

#include "js_native_api_adapter.h"
#include "napi_env.h"
#include "napi_env_jsc.h"

extern "C" void JSSynchronousGarbageCollectForDebugging(JSContextRef);

namespace {
void Require(bool condition) {
  if (!condition) std::abort();
}
void Check(napi_status status) { Require(status == napi_ok); }
bool inside_gc = false;
void Collect(JSGlobalContextRef context) {
  inside_gc = true;
  JSSynchronousGarbageCollectForDebugging(context);
  inside_gc = false;
}
struct Data {
  bool adapter = false;
  bool throw_once = false;
  bool collect_in_callback = false;
  bool delete_own_reference = false;
  int finalized = 0;
  int js_calls = 0;
  napi_ref function = nullptr;
  napi_ref own_reference = nullptr;
  JSGlobalContextRef context = nullptr;
};
napi_value CalledFromFinalizer(napi_env env, napi_callback_info info) {
  void* pointer;
  Check(env->napi_get_cb_info(env, info, nullptr, nullptr, nullptr, &pointer));
  ++static_cast<Data*>(pointer)->js_calls;
  napi_value value;
  Check(env->napi_get_undefined(env, &value));
  return value;
}
void Finalize(napi_env env, void* pointer, void*) {
  auto* data = static_cast<Data*>(pointer);
  Require(!inside_gc);
  ++data->finalized;
  napi_value object, function, result;
  Check(data->adapter ? napi_create_object_primjs(env, &object)
                      : env->napi_create_object(env, &object));
  Check(env->napi_get_reference_value(env, data->function, &function));
  Check(data->adapter ? napi_call_function_primjs(env, object, function, 0,
                                                  nullptr, &result)
                      : env->napi_call_function(env, object, function, 0,
                                                nullptr, &result));
  if (data->delete_own_reference) {
    uint32_t count;
    Check(env->napi_reference_ref(env, data->own_reference, &count));
    Require(count == 1);
    Check(env->napi_delete_reference(env, data->own_reference));
    data->own_reference = nullptr;
  }
  if (data->collect_in_callback) Collect(data->context);
  if (data->throw_once) {
    data->throw_once = false;
    napi_value error;
    Check(env->napi_create_int32(env, 42, &error));
    Check(env->napi_throw_(env, error));
  }
}
class Environment {
 public:
  explicit Environment(Data& data) : data(data) {
    env = napi_new_env();
    context = JSGlobalContextCreate(nullptr);
    data.context = context;
    napi_attach_jsc(env, context);
    napi_value function;
    Check(env->napi_create_function(env, "calledFromFinalizer",
                                    NAPI_AUTO_LENGTH, CalledFromFinalizer,
                                    &data, &function));
    Check(env->napi_create_reference(env, function, 1, &data.function));
  }
  ~Environment() { Close(); }
  void Close() {
    if (!env) return;
    napi_detach_jsc(env);
    napi_free_env(env);
    JSGlobalContextRelease(context);
    env = nullptr;
  }
  napi_status Boundary(napi_value* result) {
    return data.adapter ? napi_create_object_primjs(env, result)
                        : env->napi_create_object(env, result);
  }
  napi_env env;
  JSGlobalContextRef context;
  Data& data;
};

// Keep dead JS values out of the collector caller's stack frame.
__attribute__((noinline)) void CreateDeadExternals(Environment& test,
                                                   int count) {
  for (int i = 0; i < count; ++i) {
    napi_value value;
    Check(test.data.adapter
              ? napi_create_external_primjs(test.env, &test.data, Finalize,
                                            nullptr, &value)
              : test.env->napi_create_external(test.env, &test.data, Finalize,
                                               nullptr, &value));
  }
}

void GCAndTeardown(bool adapter, bool throw_once, bool nested_gc) {
  Data data;
  data.adapter = adapter;
  data.throw_once = throw_once;
  data.collect_in_callback = nested_gc;
  Environment test(data);
  CreateDeadExternals(test, 128);
  Collect(test.context);
  Require(data.finalized == 0);
  napi_value value;
  napi_status status = test.Boundary(&value);
  Require(status == (throw_once ? napi_pending_exception : napi_ok));
  Require(data.finalized > 0);
  if (throw_once) {
    bool pending;
    Check(test.env->napi_is_exception_pending(test.env, &pending));
    Require(pending);
    napi_value error;
    Check(test.env->napi_get_and_clear_last_exception(test.env, &error));
    int32_t code;
    Check(test.env->napi_get_value_int32(test.env, error, &code));
    Require(code == 42);
  }
  // The boundary's result remains valid while finalizers allocate/collect.
  napi_valuetype type;
  Check(test.env->napi_typeof(test.env, value, &type));
  Require(type == napi_object);
  test.Close();
  Require(data.finalized == 128 && data.js_calls == 128);
}

__attribute__((noinline)) void AddDeadFinalizer(Environment& test) {
  napi_value value;
  Check(test.Boundary(&value));
  Check(test.data.adapter
            ? napi_add_finalizer_primjs(test.env, value, &test.data, Finalize,
                                        nullptr, &test.data.own_reference)
            : test.env->napi_add_finalizer(test.env, value, &test.data,
                                           Finalize, nullptr,
                                           &test.data.own_reference));
}
void DeleteInCallback(bool adapter) {
  Data data;
  data.adapter = adapter;
  data.delete_own_reference = true;
  Environment test(data);
  AddDeadFinalizer(test);
  for (int i = 0; i < 8 && !data.finalized; ++i) {
    Collect(test.context);
    napi_value value;
    Check(test.Boundary(&value));
  }
  Require(data.finalized == 1 && !data.own_reference);
  test.Close();
  Require(data.finalized == 1);
}

napi_value LimitedArguments(napi_env env, napi_callback_info info) {
  size_t argc = 1;
  napi_value argv[1];
  Check(env->napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr));
  Require(argc == 3);
  int32_t first;
  Check(env->napi_get_value_int32(env, argv[0], &first));
  Require(first == 1);
  return argv[0];
}
void CallbackArgumentCapacity(bool adapter) {
  Data data;
  data.adapter = adapter;
  Environment test(data);
  napi_value function;
  Check(test.env->napi_create_function(test.env, "limitedArgs",
                                       NAPI_AUTO_LENGTH, LimitedArguments,
                                       nullptr, &function));
  JSStringRef name = JSStringCreateWithUTF8CString("limitedArgs");
  JSObjectSetProperty(test.context, JSContextGetGlobalObject(test.context),
                      name, napi_js_value_to_jsc_value(test.env, function), 0,
                      nullptr);
  JSStringRelease(name);
  CreateDeadExternals(test, 128);
  Collect(test.context);
  // Enter the callback directly through JSC, without an outer NAPI frame.
  JSStringRef script = JSStringCreateWithUTF8CString("limitedArgs(1,2,3)");
  JSValueRef exception = nullptr;
  JSValueRef result =
      JSEvaluateScript(test.context, script, nullptr, nullptr, 0, &exception);
  JSStringRelease(script);
  Require(!exception && JSValueToNumber(test.context, result, nullptr) == 1);
  Require(data.finalized > 0);
  test.Close();
  Require(data.finalized == 128 && data.js_calls == 128);
}

void InstanceDataCompatibility(bool adapter) {
  Data data;
  Environment test(data);
  int old_finalized = 0, new_finalized = 0;
  auto callback = [](napi_env, void* pointer, void*) {
    ++*static_cast<int*>(pointer);
  };
  if (adapter) {
    Check(napi_set_instance_data_primjs(test.env, &old_finalized, callback,
                                        nullptr));
    Check(napi_set_instance_data_primjs(test.env, &new_finalized, callback,
                                        nullptr));
    Require(old_finalized == 1 && new_finalized == 0);
  } else {
    Require(test.env->napi_set_instance_data(test.env, 42, &old_finalized,
                                             callback,
                                             nullptr) == napi_ok_legacy);
    Require(test.env->napi_set_instance_data(test.env, 42, &new_finalized,
                                             callback, nullptr) ==
            napi_conflict_instance_data_legacy);
    Require(old_finalized == 0 && new_finalized == 0);
  }
  test.Close();
  Require(old_finalized == 1 && new_finalized == (adapter ? 1 : 0));
}
}  // namespace

int main() {
  for (bool adapter : {false, true}) {
    GCAndTeardown(adapter, false, false);
    GCAndTeardown(adapter, true, false);
    GCAndTeardown(adapter, false, true);
    DeleteInCallback(adapter);
    CallbackArgumentCapacity(adapter);
    InstanceDataCompatibility(adapter);
    std::fprintf(stdout,
                 "%s JSC GC callbacks, reentry, deletion, exceptions and "
                 "instance data: passed\n",
                 adapter ? "adapter" : "legacy");
  }
}
