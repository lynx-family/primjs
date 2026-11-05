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

struct WeakFinalizerState {
  int calls = 0;
  napi_status reentry_status = napi_generic_failure;
  napi_ref reference = nullptr;
  bool delete_reference = false;
};

void FinalizeWeakReference(napi_env env, void* data, void* hint) {
  auto* state = static_cast<WeakFinalizerState*>(data);
  EXPECT_EQ(hint, state);
  ++state->calls;

  // Allocating is permitted in the second pass, after V8 has reset the weak
  // handle. This also checks that the callback retains its original state.
  napi_value value;
  state->reentry_status = env->napi_create_object(env, &value);
  if (state->delete_reference) {
    EXPECT_EQ(env->napi_delete_reference(env, state->reference), napi_ok);
    state->reference = nullptr;
  }
}

TEST(NAPIV8LifecycleTest, WeakFinalizerReentersAndDeletesItsReferenceOnce) {
  WeakFinalizerState state;
  test::NAPIRuntimeV8SingleMode runtime;
  napi_env env = runtime.Env();
  state.delete_reference = true;
  {
    Napi::HandleScope scope(runtime.Env());
    napi_value object;
    ASSERT_EQ(env->napi_create_object(env, &object), napi_ok);
    ASSERT_EQ(
        env->napi_add_finalizer(env, object, &state, FinalizeWeakReference,
                                &state, &state.reference),
        napi_ok);
  }

  v8::Isolate* isolate = v8::Isolate::GetCurrent();
  isolate->LowMemoryNotification();
  EXPECT_EQ(state.calls, 1);
  EXPECT_EQ(state.reentry_status, napi_ok);
  EXPECT_EQ(state.reference, nullptr);

  isolate->LowMemoryNotification();
  EXPECT_EQ(state.calls, 1);
}

TEST(NAPIV8LifecycleTest, StrongReferenceBecomesWeakAndReleasesItsValue) {
  WeakFinalizerState state;
  test::NAPIRuntimeV8SingleMode runtime;
  napi_env env = runtime.Env();
  {
    Napi::HandleScope scope(runtime.Env());
    napi_value object;
    ASSERT_EQ(env->napi_create_object(env, &object), napi_ok);
    ASSERT_EQ(
        env->napi_add_finalizer(env, object, &state, FinalizeWeakReference,
                                &state, &state.reference),
        napi_ok);
    uint32_t count = 0;
    ASSERT_EQ(env->napi_reference_ref(env, state.reference, &count), napi_ok);
    ASSERT_EQ(count, 1u);
  }

  v8::Isolate* isolate = v8::Isolate::GetCurrent();
  isolate->LowMemoryNotification();
  EXPECT_EQ(state.calls, 0);

  uint32_t count = 1;
  ASSERT_EQ(env->napi_reference_unref(env, state.reference, &count), napi_ok);
  ASSERT_EQ(count, 0u);
  isolate->LowMemoryNotification();
  EXPECT_EQ(state.calls, 1);
  EXPECT_EQ(state.reentry_status, napi_ok);
  napi_value value = nullptr;
  EXPECT_EQ(env->napi_get_reference_value(env, state.reference, &value),
            napi_ok);
  EXPECT_EQ(value, nullptr);
  EXPECT_EQ(env->napi_delete_reference(env, state.reference), napi_ok);
  state.reference = nullptr;

  isolate->LowMemoryNotification();
  EXPECT_EQ(state.calls, 1);
}

TEST(NAPIV8LifecycleTest, DeletingWeakReferenceDefersUntilFinalization) {
  WeakFinalizerState state;
  {
    test::NAPIRuntimeV8SingleMode runtime;
    napi_env env = runtime.Env();
    {
      Napi::HandleScope scope(runtime.Env());
      napi_value object;
      ASSERT_EQ(env->napi_create_object(env, &object), napi_ok);
      ASSERT_EQ(
          env->napi_add_finalizer(env, object, &state, FinalizeWeakReference,
                                  &state, &state.reference),
          napi_ok);
      ASSERT_EQ(env->napi_delete_reference(env, state.reference), napi_ok);
      state.reference = nullptr;
      EXPECT_EQ(state.calls, 0);
    }

    v8::Isolate::GetCurrent()->LowMemoryNotification();
    EXPECT_EQ(state.calls, 1);
    EXPECT_EQ(state.reentry_status, napi_ok);
  }
  EXPECT_EQ(state.calls, 1);
}

TEST(NAPIV8LifecycleTest, DeletingStrongReferenceCancelsItsCallback) {
  WeakFinalizerState state;
  {
    test::NAPIRuntimeV8SingleMode runtime;
    napi_env env = runtime.Env();
    {
      Napi::HandleScope scope(runtime.Env());
      napi_value object;
      ASSERT_EQ(env->napi_create_object(env, &object), napi_ok);
      ASSERT_EQ(
          env->napi_add_finalizer(env, object, &state, FinalizeWeakReference,
                                  &state, &state.reference),
          napi_ok);
      uint32_t count = 0;
      ASSERT_EQ(env->napi_reference_ref(env, state.reference, &count), napi_ok);
      ASSERT_EQ(count, 1u);
      ASSERT_EQ(env->napi_delete_reference(env, state.reference), napi_ok);
      state.reference = nullptr;
    }

    v8::Isolate::GetCurrent()->LowMemoryNotification();
    EXPECT_EQ(state.calls, 0);
  }
  EXPECT_EQ(state.calls, 0);
}

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
