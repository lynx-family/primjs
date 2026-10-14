// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <gtest/gtest.h>

#include "testlib.h"

#ifdef JS_ENGINE_V8

namespace {

class ScopedDetachedV8Context {
 public:
  explicit ScopedDetachedV8Context(napi_env env)
      : env_(env), context_(env->ctx) {
    env_->ctx = nullptr;
  }

  ~ScopedDetachedV8Context() { env_->ctx = context_; }

 private:
  napi_env env_;
  napi_context context_;
};

TEST(NAPIV8LifecycleTest, NativeCallbackIsIgnoredAfterContextDetach) {
  test::NAPIRuntimeV8SingleMode runtime;
  Napi::Env env = runtime.Env();
  int callback_count = 0;

  Napi::Function callback = Napi::Function::New(
      env,
      [](const Napi::CallbackInfo& info) -> Napi::Value {
        ++*static_cast<int*>(info.Data());
        return info.Env().Undefined();
      },
      "nativeCallback", &callback_count);
  env.Global().Set("nativeCallback", callback);

  v8::Isolate* isolate = v8::Isolate::GetCurrent();
  v8::Local<v8::Context> context = isolate->GetCurrentContext();
  v8::Local<v8::Value> value =
      context->Global()
          ->Get(context,
                v8::String::NewFromUtf8Literal(isolate, "nativeCallback"))
          .ToLocalChecked();
  ASSERT_TRUE(value->IsFunction());

  v8::MaybeLocal<v8::Value> result;
  {
    ScopedDetachedV8Context detached_context(env);
    result =
        value.As<v8::Function>()->Call(context, context->Global(), 0, nullptr);
  }

  ASSERT_FALSE(result.IsEmpty());
  EXPECT_TRUE(result.ToLocalChecked()->IsUndefined());
  EXPECT_EQ(callback_count, 0);
}

}  // namespace

#endif  // JS_ENGINE_V8
