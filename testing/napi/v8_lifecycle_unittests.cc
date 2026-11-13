// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <gtest/gtest.h>

#include "napi/adapter/js_native_api_adapter.h"
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

class V8RuntimeWithoutOuterHandleScope : public test::NAPIRuntime {
 public:
  V8RuntimeWithoutOuterHandleScope() {
    // Reuse the harness's one-time platform initialization, then discard its
    // long-lived handle scope before constructing the production-like runtime.
    { test::NAPIRuntimeV8SingleMode initialize_platform; }
    allocator_.reset(v8::ArrayBuffer::Allocator::NewDefaultAllocator());
    v8::Isolate::CreateParams params;
    params.array_buffer_allocator = allocator_.get();
    isolate_ = v8::Isolate::New(params);
    isolate_scope_ = std::make_unique<test::IsolateScopeWrapper>(isolate_);
    v8::HandleScope scope(isolate_);
    auto context = v8::Context::New(isolate_);
    context->Enter();
    context_.Reset(isolate_, context);
    napi_attach_v8(_env, context);
  }

  ~V8RuntimeWithoutOuterHandleScope() override {
    Detach();
    {
      v8::HandleScope scope(isolate_);
      context_.Get(isolate_)->Exit();
      context_.Reset();
    }
    isolate_scope_.reset();
    isolate_->Dispose();
  }

  void Detach() {
    // Match the production order, with the setup scope already destroyed.
    napi_detach_runtime(_env);
    napi_detach_v8(_env);
  }

  v8::Isolate* isolate() { return isolate_; }

 private:
  std::unique_ptr<v8::ArrayBuffer::Allocator> allocator_;
  v8::Isolate* isolate_ = nullptr;
  std::unique_ptr<test::IsolateScopeWrapper> isolate_scope_;
  v8::Global<v8::Context> context_;
};

TEST(NAPIV8LifecycleTest, AdapterCleanupCreatesHandlesWithoutOuterScope) {
  struct State {
    napi_env env = nullptr;
    napi_ref reference = nullptr;
    int cleanup_calls = 0;
    int finalizers = 0;
    int legacy_calls = 0;
  } state;
  // Keep callback state alive if an assertion triggers early teardown.
  auto runtime = std::make_unique<V8RuntimeWithoutOuterHandleScope>();
  state.env = runtime->Env();
  {
    v8::HandleScope scope(runtime->isolate());
    napi_value object, number;
    ASSERT_EQ(napi_create_object_primjs(state.env, &object), napi_ok);
    ASSERT_EQ(napi_create_int32_primjs(state.env, 42, &number), napi_ok);
    ASSERT_EQ(
        napi_set_named_property_primjs(state.env, object, "answer", number),
        napi_ok);
    ASSERT_EQ(
        napi_create_reference_primjs(state.env, object, 1, &state.reference),
        napi_ok);
    ASSERT_EQ(napi_set_instance_data_primjs(
                  state.env, &state,
                  [](napi_env, void* data, void*) {
                    auto* state = static_cast<State*>(data);
                    EXPECT_EQ(state->cleanup_calls, 1);
                    ++state->finalizers;
                  },
                  nullptr),
              napi_ok);
    ASSERT_EQ(
        napi_add_env_cleanup_hook_primjs(
            state.env,
            [](void* data) {
              auto* state = static_cast<State*>(data);
              ++state->cleanup_calls;
              ASSERT_EQ(state->finalizers, 0);
              napi_value object, value, created;
              ASSERT_EQ(napi_get_reference_value_primjs(
                            state->env, state->reference, &object),
                        napi_ok);
              ASSERT_EQ(napi_create_object_primjs(state->env, &created),
                        napi_ok);
              ASSERT_EQ(napi_get_named_property_primjs(state->env, object,
                                                       "answer", &value),
                        napi_ok);
              int32_t answer = 0;
              ASSERT_EQ(napi_get_value_int32_primjs(state->env, value, &answer),
                        napi_ok);
              EXPECT_EQ(answer, 42);
              ASSERT_EQ(
                  napi_delete_reference_primjs(state->env, state->reference),
                  napi_ok);
              state->reference = nullptr;
            },
            &state),
        napi_ok);
    Napi::Env(state.env).AddCleanupHook(
        [](void* data) {
          auto* state = static_cast<State*>(data);
          EXPECT_EQ(state->env->ctx, nullptr);
          EXPECT_EQ(state->finalizers, 1);
          ++state->legacy_calls;
        },
        &state);
  }
  ASSERT_EQ(v8::HandleScope::NumberOfHandles(runtime->isolate()), 0);
  runtime->Detach();
  EXPECT_EQ(state.cleanup_calls, 1);
  EXPECT_EQ(state.finalizers, 1);
  EXPECT_EQ(state.reference, nullptr);
  EXPECT_EQ(state.legacy_calls, 0);
  EXPECT_EQ(v8::HandleScope::NumberOfHandles(runtime->isolate()), 0);
  runtime.reset();
  EXPECT_EQ(state.cleanup_calls, 1);
  EXPECT_EQ(state.legacy_calls, 1);
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
