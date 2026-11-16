
// Copyright 2024-2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "napi_adapter_unittests.h"

#include <gtest/gtest.h>

#include <chrono>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <thread>
#include <unordered_map>
#include <unordered_set>

#if defined(__SANITIZE_ADDRESS__)
#define NAPI_ADAPTER_TEST_ASAN
#elif defined(__has_feature)
#if __has_feature(address_sanitizer)
#define NAPI_ADAPTER_TEST_ASAN
#endif
#endif
#ifdef NAPI_ADAPTER_TEST_ASAN
#include <sanitizer/asan_interface.h>
#endif

#include "napi/napi.h"

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

class NAPITest : public test::NAPITestBase {
 public:
  static std::string GetNapiExceptionMessage(napi_env env) {
    napi_value exception{nullptr}, err_msg_key{nullptr}, err_msg{nullptr};
    CHECK_NAPI(napi_get_and_clear_last_exception_primjs(env, &exception));
    napi_valuetype exception_type = napi_undefined;
    CHECK_NAPI(napi_typeof_primjs(env, exception, &exception_type));
    if (exception == nullptr || exception_type != napi_object) {
      return "empty exception message.";
    }
    CHECK_NAPI(napi_create_string_utf8_primjs(env, "name", NAPI_AUTO_LENGTH,
                                              &err_msg_key));
    CHECK_NAPI(napi_get_property_primjs(env, exception, err_msg_key, &err_msg));
    size_t length = 0;
    CHECK_NAPI(
        napi_get_value_string_utf8_primjs(env, err_msg, nullptr, 0, &length));
    std::string name(length, 0);
    CHECK_NAPI(napi_get_value_string_utf8_primjs(env, err_msg, name.data(),
                                                 length + 1, &length));

    CHECK_NAPI(napi_create_string_utf8_primjs(env, "message", NAPI_AUTO_LENGTH,
                                              &err_msg_key));
    CHECK_NAPI(napi_get_property_primjs(env, exception, err_msg_key, &err_msg));

    napi_valuetype type;
    napi_typeof_primjs(env, err_msg, &type);

    CHECK_NAPI(
        napi_get_value_string_utf8_primjs(env, err_msg, nullptr, 0, &length));
    std::string error_message(length, 0);
    CHECK_NAPI(napi_get_value_string_utf8_primjs(
        env, err_msg, error_message.data(), length + 1, &length));

    CHECK_NAPI(napi_create_string_utf8_primjs(env, "stack", NAPI_AUTO_LENGTH,
                                              &err_msg_key));
    CHECK_NAPI(napi_get_property_primjs(env, exception, err_msg_key, &err_msg));
    CHECK_NAPI(
        napi_get_value_string_utf8_primjs(env, err_msg, nullptr, 0, &length));
    std::string stack(length, 0);
    napi_get_value_string_utf8_primjs(env, err_msg, stack.data(), length + 1,
                                      &length);

    return name + ", " + error_message + ", stack:" + stack;
  }

  void EvalJsFile(const std::string& file_path, napi_env env_) {
    std::ifstream file(file_path);
    if (!file.is_open()) {
      ADD_FAILURE() << "Failed to open file: " << file_path;
      return;
    }

    std::string content((std::istreambuf_iterator<char>(file)),
                        std::istreambuf_iterator<char>());
    napi_value ret;
    napi_status status = eval(content, &ret);

    if (status != napi_ok) {
      const napi_extended_error_info* info;
      CHECK_NAPI(napi_get_last_error_info_primjs(env_, &info));
      std::stringstream ss;
      ss << file_path.c_str()
         << " eval failed, status: " << info->error_message;
      ss << ", exception message: " << NAPITest::GetNapiExceptionMessage(env_);
      ADD_FAILURE() << ss.str();
    }
    file.close();
  }
};

namespace test {
#ifdef JS_ENGINE_QJS
std::string GetExceptionMessage(LEPUSContext* ctx,
                                LEPUSValueConst exception_val) {
  LEPUSValue val;
  const char* stack;
  const char* message = LEPUS_ToCString(ctx, exception_val);
  std::string ret = "quickjs: ";
  if (message) {
    ret += message;
    ret += "\n";
    if (!LEPUS_IsGCMode(ctx)) {
      LEPUS_FreeCString(ctx, message);
    }
  }

  bool is_error = LEPUS_IsError(ctx, exception_val);
  if (is_error) {
    val = LEPUS_GetPropertyStr(ctx, exception_val, "stack");
    if (!LEPUS_IsUndefined(val)) {
      stack = LEPUS_ToCString(ctx, val);
      ret += stack;
      if (!LEPUS_IsGCMode(ctx)) {
        LEPUS_FreeCString(ctx, stack);
      }
    }
    if (!LEPUS_IsGCMode(ctx)) {
      LEPUS_FreeValue(ctx, val);
    }
  }
  return ret;
}
void NAPIRuntimeQJS::ProcessTasks(const std::string& path) {
  NAPIRuntime::ProcessTasks(path);
  LEPUSContext* ctx = nullptr;
  int result = 0;
  while ((result = LEPUS_ExecutePendingJob(_rt, &ctx))) {
    if (result < 0) {
      ADD_FAILURE() << "PrimJS Execute Pending Job exception: "
                    << GetExceptionMessage(ctx, LEPUS_GetException(ctx))
                    << " at:" << path;
    }
  }
  while (LEPUS_MoveUnhandledRejectionToException(_ctx)) {
    ADD_FAILURE() << "PrimJS has unhandled rejection: "
                  << GetExceptionMessage(_ctx, LEPUS_GetException(_ctx))
                  << " at:" << path;
  }
}
#endif  // JS_ENGINE_QJS

void NAPIRuntime::RunCallChecks(const std::string& name) {
  napi_value global;
  CHECK_NAPI(napi_get_global_primjs(env_, &global));
  napi_value run_call_checks;
  CHECK_NAPI(napi_get_named_property_primjs(env_, global, "runCallChecks",
                                            &run_call_checks));
  napi_valuetype type;
  napi_typeof_primjs(env_, run_call_checks, &type);
  if (type != napi_function) {
    return;
  }
  napi_status status = napi_call_function_primjs(env_, global, run_call_checks,
                                                 0, nullptr, nullptr);
  if (status != napi_ok) {
    const napi_extended_error_info* info;
    CHECK_NAPI(napi_get_last_error_info_primjs(env_, &info));
    std::stringstream ss;
    ss << name << " runCallChecks failed, status: " << info->error_message;
    ss << ", exception message: " << NAPITest::GetNapiExceptionMessage(env_);
    ADD_FAILURE() << ss.str();
    LOGE("Napi Adapter Test RunCallChecks Failed:" << ss.str());
  }
}

napi_value NAPIRuntime::SetTimeout(napi_env env, napi_callback_info info) {
  NAPIRuntime* rt;
  size_t argc = 2;
  napi_value argv[2];
  CHECK_NAPI(napi_get_cb_info_primjs(env, info, &argc, argv, nullptr,
                                     reinterpret_cast<void**>(&rt)));
  napi_ref func_ref;
  CHECK_NAPI(napi_create_reference_primjs(env, argv[0], 1, &func_ref));
  rt->delegate_->PostJSTask([rt, func_ref]() {
    napi_value func;
    CHECK_NAPI(napi_get_reference_value_primjs(rt->env_, func_ref, &func));
    Napi::HandleScope scope{Napi::Env(rt->env_)};
    napi_value global;
    CHECK_NAPI(napi_get_global_primjs(rt->env_, &global));
    napi_status status =
        napi_call_function_primjs(rt->env_, global, func, 0, nullptr, nullptr);
    CHECK_NAPI(napi_delete_reference_primjs(rt->env_, func_ref));
    if (status == napi_pending_exception) {
      std::string exception = NAPITest::GetNapiExceptionMessage(rt->env_);
      ADD_FAILURE() << "SetTimeout exception: " << exception;
      LOGE("Napi Adapter Test SetTimeout exception:" << exception);
    }
  });
  return nullptr;
}

}  // namespace test

INSTANTIATE_TEST_SUITE_P(
    EngineTest, NAPITest, ::testing::ValuesIn(test::runtimeFactory),
    [](const testing::TestParamInfo<NAPITest::ParamType>& info) {
      return std::get<0>(info.param);
    });

#ifndef JS_ENGINE_HARMONY

namespace {
struct AdapterTSFNLifecycleState {
  napi_threadsafe_function function = nullptr;
  int delivered = 0;
  int discarded = 0;
  int finalizers = 0;
  napi_status cleanup_release = napi_generic_failure;

  napi_status Create(napi_env env, size_t holders) {
    napi_value name;
    napi_status status = napi_create_string_utf8_primjs(
        env, "adapter lifecycle", NAPI_AUTO_LENGTH, &name);
    if (status != napi_ok) return status;
    return napi_create_threadsafe_function_primjs(
        env, nullptr, nullptr, name, 0, holders, this,
        [](napi_env, void* data, void* context) {
          auto* state = static_cast<AdapterTSFNLifecycleState*>(data);
          EXPECT_EQ(context, state);
          ++state->finalizers;
        },
        this,
        [](napi_env env, napi_value callback, void* context, void*) {
          auto* state = static_cast<AdapterTSFNLifecycleState*>(context);
          if (env) {
            ++state->delivered;
          } else {
            EXPECT_EQ(callback, nullptr);
            ++state->discarded;
          }
        },
        &function);
  }
};

void ExpectAdapterTSFNFreed(napi_threadsafe_function function) {
  (void)function;
#ifdef NAPI_ADAPTER_TEST_ASAN
  // Inspect allocation state without dereferencing the released handle.
  EXPECT_NE(__asan_address_is_poisoned(function), 0);
#endif
}
}  // namespace

TEST_P(NAPITest, AdapterTsfnReleaseAfterEnvFree) {
  AdapterTSFNLifecycleState state;
  // Local ownership tears down before callback state on an early return too.
  auto runtime = std::move(runtime_);
  ASSERT_EQ(state.Create(env_, 1), napi_ok);
  runtime.reset();
  env_ = nullptr;
  EXPECT_EQ(state.finalizers, 1);
  napi_status holder_release = napi_generic_failure;
  std::thread holder([&] {
    holder_release = napi_release_threadsafe_function_primjs(state.function,
                                                             napi_tsfn_release);
  });
  holder.join();
  EXPECT_EQ(holder_release, napi_ok);
  ExpectAdapterTSFNFreed(state.function);
  EXPECT_EQ(state.finalizers, 1);
}

TEST_P(NAPITest, AdapterTsfnClosingCallConsumesOnlyCallingHolder) {
  AdapterTSFNLifecycleState state;
  int payloads[] = {1, 2};
  auto runtime = std::move(runtime_);
  ASSERT_EQ(state.Create(env_, 2), napi_ok);
  for (auto& payload : payloads) {
    ASSERT_EQ(napi_call_threadsafe_function_primjs(state.function, &payload,
                                                   napi_tsfn_nonblocking),
              napi_ok);
  }
  runtime.reset();
  env_ = nullptr;
  EXPECT_EQ(state.delivered, 0);
  EXPECT_EQ(state.discarded, 2);
  EXPECT_EQ(state.finalizers, 1);
  EXPECT_EQ(napi_call_threadsafe_function_primjs(state.function, nullptr,
                                                 napi_tsfn_nonblocking),
            napi_closing);
  EXPECT_EQ(napi_release_threadsafe_function_primjs(state.function,
                                                    napi_tsfn_release),
            napi_ok);
  ExpectAdapterTSFNFreed(state.function);
  EXPECT_EQ(state.discarded, 2);
  EXPECT_EQ(state.finalizers, 1);
}

TEST_P(NAPITest, AdapterTsfnReleaseInEnvCleanupHook) {
  AdapterTSFNLifecycleState state;
  auto runtime = std::move(runtime_);
  ASSERT_EQ(state.Create(env_, 1), napi_ok);
  ASSERT_EQ(napi_add_env_cleanup_hook_primjs(
                env_,
                [](void* data) {
                  auto* state = static_cast<AdapterTSFNLifecycleState*>(data);
                  state->cleanup_release =
                      napi_release_threadsafe_function_primjs(
                          state->function, napi_tsfn_release);
                },
                &state),
            napi_ok);
  runtime.reset();
  env_ = nullptr;
  EXPECT_EQ(state.cleanup_release, napi_ok);
  EXPECT_EQ(state.finalizers, 1);
  ExpectAdapterTSFNFreed(state.function);
}

#ifndef NAPI_ADAPTER_TEST_ROOT
#define NAPI_ADAPTER_TEST_ROOT "oss/testing/napi_adapter/js_native_api"
#endif
const char* kTargetPath = std::getenv("NAPI_ADAPTER_TEST_ROOT")
                              ? std::getenv("NAPI_ADAPTER_TEST_ROOT")
                              : NAPI_ADAPTER_TEST_ROOT;

// Keep this list in sync with the feature targets in BUILD.gn and
// CMakeLists.txt.
constexpr const char* kTestSuites[] = {
    "2_function_arguments",
    "3_callbacks",
    "3_callbacks_primjs_extra_tests",
    "4_object_factory",
    "5_function_factory",
    "6_object_wrap",
    "7_factory_wrap",
    "8_passing_wrapped",
    "test_array",
    "test_bigint",
    "test_class_inheritance",
    "test_constructor",
    "test_conversions",
    "test_dataview",
    "test_date",
    "test_error",
    "test_exception",
    "test_function",
    "test_general",
    "test_handle_scope",
    "test_instance_data",
    "test_new_target",
    "test_number",
    "test_object",
    "test_promise",
    "test_properties",
    "test_reference",
    "test_string",
    "test_symbol",
    "test_threadsafe_function",
    "test_typedarray",
};

TEST_P(NAPITest, NapiJS) {
  for (const char* suite : kTestSuites) {
    std::string suite_path = std::string(kTargetPath) + "/" + suite;
    std::string bundle_path = suite_path + "/build/test_bundler.js";
    ASSERT_TRUE(std::ifstream(bundle_path).is_open()) << bundle_path;
    SCOPED_TRACE(suite);
    std::cout << "[ Node-API suite ] " << suite << std::endl;
    env_ = runtime_->Env();
    {
      Napi::HandleScope scope{Napi::Env(env_)};
      runtime_->SetupTestEnv(suite_path);
      napi_value global, engine;
      CHECK_NAPI(napi_get_global_primjs(env_, &global));
      CHECK_NAPI(napi_create_string_utf8_primjs(env_, GetParam().first.c_str(),
                                                NAPI_AUTO_LENGTH, &engine));
      CHECK_NAPI(napi_set_named_property_primjs(env_, global,
                                                "__napi_test_engine", engine));
      EvalJsFile(bundle_path, env_);
      runtime_->ProcessTasks(bundle_path);
      runtime_->RunCallChecks(bundle_path);
    }
    runtime_->DestructEnv();
    runtime_->ConstructEnv();
  }
}

#else

static std::string sJsContent;
static std::string sTestName;

TEST_P(NAPITest, NapiJS) {
  LOGI("Napi Adapter Test Running: " << sTestName);
  env_ = runtime_->Env();
  {
    Napi::HandleScope scope{Napi::Env(env_)};
    runtime_->SetupTestEnv(sTestName);

    napi_value ret;
    napi_status status = eval(sJsContent, &ret);

    if (status != napi_ok) {
      const napi_extended_error_info* info;
      CHECK_NAPI(napi_get_last_error_info_primjs(env_, &info));
      LOGE("Napi Adapter Test fail! "
           << "Napi Adapter Test Failed! : " << sTestName
           << " eval failed, status: " << info->error_message
           << " exception message: "
           << NAPITest::GetNapiExceptionMessage(env_));
    } else {
      LOGI("Napi Adapter Test Successfully: " << sTestName);
    }
  }
  runtime_->ProcessTasks(sTestName);
  runtime_->DestructEnv();
}

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif
#include "napi/native_api.h"

EXTERN_C_START
static napi_value RunHarmonyAdapterTest(napi_env env, napi_callback_info info) {
  size_t argc = 2;
  napi_value argv[2];
  CHECK_NAPI(napi_get_cb_info_primjs(env, info, &argc, argv, nullptr, nullptr));
  size_t len = 0;
  CHECK_NAPI(napi_get_value_string_utf8_primjs(env, argv[0], nullptr, 0, &len));
  sTestName = std::string(len, 0);
  CHECK_NAPI(napi_get_value_string_utf8_primjs(env, argv[0], sTestName.data(),
                                               len + 1, &len));
  CHECK_NAPI(napi_get_value_string_utf8_primjs(env, argv[1], nullptr, 0, &len));
  sJsContent = std::string(len, 0);
  CHECK_NAPI(napi_get_value_string_utf8_primjs(env, argv[1], sJsContent.data(),
                                               len + 1, &len));

  ::testing::InitGoogleTest();
  (void)RUN_ALL_TESTS();
  return nullptr;
}

static napi_value Init(napi_env env, napi_value exports) {
  static napi_property_descriptor descs[] = {
      {"RunHarmonyNapiAdapterTest", nullptr, RunHarmonyAdapterTest, nullptr,
       nullptr, nullptr, napi_default, nullptr},
  };
  napi_define_properties_primjs(env, exports, sizeof(descs) / sizeof(descs[0]),
                                descs);
  return exports;
}

__attribute__((constructor)) void RegisterNapiHarmonyAdapterTestModule() {
  static napi_module HarmonyAdapterTestModule = {
      .nm_version = 1,
      .nm_flags = 0,
      .nm_filename = nullptr,
      .nm_register_func = Init,
      .nm_modname = "napi_adapter_test",
      .nm_priv = nullptr,
      .reserved = {0},
  };
  napi_module_register_primjs(&HarmonyAdapterTestModule);
}

EXTERN_C_END
#endif  // JS_ENGINE_HARMONY

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif

#include "primjs_weak_node_api_installer.h"
#include "primjs_weak_node_api_provider.h"

namespace {
class WeakNodeApiSetup {
 public:
  WeakNodeApiSetup() {
#if defined(__APPLE__)
    PrimJSInstallWeakNodeApiRawPtrHostProvider(PrimJSGetWeakNodeApiRawPtrHost);
#endif
    SetupWeakNodeApiEnv();
  }
};
WeakNodeApiSetup weak_node_api_setup;
}  // namespace
