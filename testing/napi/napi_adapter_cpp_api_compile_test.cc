// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#define NAPI_CPP_CUSTOM_NAMESPACE PrimJSAdapter
#include "napi_adapter.h"

namespace AdapterNapi = Napi::PrimJSAdapter;

namespace {

AdapterNapi::Value Echo(const AdapterNapi::CallbackInfo& info) {
  return info.Length() == 0 ? info.Env().Undefined() : info[0];
}

class WrappedValue : public AdapterNapi::ObjectWrap<WrappedValue> {
 public:
  explicit WrappedValue(const AdapterNapi::CallbackInfo& info)
      : AdapterNapi::ObjectWrap<WrappedValue>(info) {}

  static AdapterNapi::Function CreateClass(AdapterNapi::Env env) {
    return DefineClass(env, "WrappedValue", {});
  }
};

#if NAPI_HAS_THREADS
class CompileOnlyAsyncWorker : public AdapterNapi::AsyncWorker {
 public:
  explicit CompileOnlyAsyncWorker(AdapterNapi::Env env)
      : AdapterNapi::AsyncWorker(env) {}

 private:
  void Execute() override {}
};

void InstantiateAsyncApi(AdapterNapi::Env env,
                         const AdapterNapi::Function& callback) {
  auto* worker = new CompileOnlyAsyncWorker(env);
  worker->Queue();
  worker->Cancel();
  worker->SuppressDestruct();

  AdapterNapi::ThreadSafeFunction tsfn = AdapterNapi::ThreadSafeFunction::New(
      env, callback, "adapter-cpp-api-test", 1, 1);
  tsfn.NonBlockingCall();
  tsfn.BlockingCall();
  tsfn.Ref(env);
  tsfn.Unref(env);
  tsfn.Acquire();
  tsfn.Release();
}
#endif  // NAPI_HAS_THREADS

AdapterNapi::Object InitAdapterCppApi(AdapterNapi::Env env,
                                      AdapterNapi::Object exports) {
  AdapterNapi::HandleScope scope(env);

  exports.Set("boolean", AdapterNapi::Boolean::New(env, true));
  exports.Set("number", AdapterNapi::Number::New(env, 42));
  exports.Set("bigint", AdapterNapi::BigInt::New(env, int64_t{42}));
  exports.Set("date", AdapterNapi::Date::New(env, 0));
  exports.Set("string", AdapterNapi::String::New(env, "adapter"));
  exports.Set("symbol", AdapterNapi::Symbol::New(env, "adapter"));

  AdapterNapi::Array array = AdapterNapi::Array::New(env, 1);
  array.Set(uint32_t{0}, exports.Get("number"));
  exports.Set("array", array);

  AdapterNapi::ArrayBuffer array_buffer = AdapterNapi::ArrayBuffer::New(env, 8);
  AdapterNapi::Uint8Array typed_array =
      AdapterNapi::Uint8Array::New(env, 8, array_buffer, 0);
  exports.Set("typedArray", typed_array);
  exports.Set("dataView", AdapterNapi::DataView::New(env, array_buffer));

  static int external_value = 42;
  exports.Set("external",
              AdapterNapi::External<int>::New(env, &external_value));
  AdapterNapi::Function function = AdapterNapi::Function::New(env, Echo);
  exports.Set("function", function);
  exports.Set("wrappedValue", WrappedValue::CreateClass(env));

  AdapterNapi::Promise::Deferred deferred =
      AdapterNapi::Promise::Deferred::New(env);
  deferred.Resolve(env.Undefined());
  exports.Set("promise", deferred.Promise());

  AdapterNapi::ObjectReference reference =
      AdapterNapi::Persistent(AdapterNapi::Object::New(env));
  reference.SuppressDestruct();

#if NAPI_HAS_THREADS
  // Compile the async wrappers without changing this registration function's
  // runtime behavior.
  if (static_cast<napi_adapter_cpp_detail::Env>(env) == nullptr) {
    InstantiateAsyncApi(env, function);
  }
#endif  // NAPI_HAS_THREADS

  return exports;
}

}  // namespace

NODE_API_MODULE_PRIMJS(napi_adapter_cpp_api_test, InitAdapterCppApi)
