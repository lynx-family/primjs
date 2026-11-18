
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

#include "weak_node_api.hpp"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

class FatalExceptionTest : public test::NAPITestBase {
 public:
  void SetUp() override { ConfigureHandler(); }

  void TearDown() override {
    bool pending = false;
    CHECK_NAPI(napi_is_exception_pending_primjs(env_, &pending));
    EXPECT_FALSE(pending);
    if (pending) {
      napi_value error;
      CHECK_NAPI(napi_get_and_clear_last_exception_primjs(env_, &error));
    }
    // Destroy the runtime while its callback data is still alive.
    runtime_.reset();
  }

  void ConfigureHandler(bool enabled = true) {
    napi_detach_runtime(env_);
    auto conf = napi_create_runtime_configuration();
    napi_runtime_config_foreground_handler(conf, test::PostNAPIJSTask,
                                           &delegate_);
    if (enabled) {
      napi_runtime_config_uncaught_handler(
          conf,
          [](napi_env env, napi_value error, void* data) {
            auto* self = static_cast<FatalExceptionTest*>(data);
            ++self->reports_;
            bool pending = true;
            CHECK_NAPI(napi_is_exception_pending_primjs(env, &pending));
            EXPECT_FALSE(pending);
            if (self->handler_) self->handler_(error);
          },
          this);
    }
    napi_attach_runtime_with_configuration(env_, conf);
    napi_delete_runtime_configuration(conf);
  }

  napi_value Value(const char* source) {
    napi_value result = nullptr;
    // Match the newline-terminated input used by the bundled adapter suites.
    CHECK_NAPI(eval(std::string(source) + "\n", &result));
    return result;
  }

  void ExpectSame(napi_value expected, napi_value actual) {
    bool same = false;
    CHECK_NAPI(napi_strict_equals_primjs(env_, expected, actual, &same));
    EXPECT_TRUE(same);
  }

  void ExpectStatus(napi_status expected, napi_status actual) {
    EXPECT_EQ(expected, actual);
    const napi_extended_error_info* info;
    CHECK_NAPI(napi_get_last_error_info_primjs(env_, &info));
    EXPECT_EQ(expected, info->error_code);
  }

  static void Complete(napi_env env, napi_status status, void* data) {
    auto* self = static_cast<FatalExceptionTest*>(data);
    ++self->completions_;
    self->completion_status_ = status;
    self->dispatch_status_ = napi_fatal_exception_primjs(env, self->error_);
  }

  std::shared_ptr<test::TaskDelegate> delegate_ = test::TaskDelegate::Create();
  std::function<void(napi_value)> handler_;
  napi_value error_ = nullptr;
  napi_status dispatch_status_ = napi_generic_failure;
  napi_status completion_status_ = napi_generic_failure;
  napi_async_work closing_work_ = nullptr;
  int reports_ = 0;
  int completions_ = 0;
};

INSTANTIATE_TEST_SUITE_P(
    EngineTest, FatalExceptionTest, ::testing::ValuesIn(test::runtimeFactory),
    [](const testing::TestParamInfo<FatalExceptionTest::ParamType>& info) {
      return std::get<0>(info.param);
    });

TEST_P(FatalExceptionTest, SynchronousValuesSurviveGC) {
  for (const char* source : {"new Error('fatal')", "undefined", "null", "true",
                             "42", "'fatal string'", "Symbol('fatal')"}) {
    napi_value error = Value(source);
    bool returned = false;
    handler_ = [&](napi_value actual) {
      EXPECT_FALSE(returned);
      Value("Array.from({length: 1000}, () => ({value: 'allocation'}))");
      runtime_->TriggerGC();
      ExpectSame(error, actual);
    };
    int before = reports_;
    ExpectStatus(napi_ok, napi_fatal_exception_primjs(env_, error));
    returned = true;
    EXPECT_EQ(before + 1, reports_);
  }
}

TEST_P(FatalExceptionTest, PendingAndInvalidArguments) {
  EXPECT_EQ(napi_invalid_arg, napi_fatal_exception_primjs(nullptr, nullptr));
  napi_env unattached = napi_new_env();
  EXPECT_EQ(napi_generic_failure,
            napi_fatal_exception_primjs(unattached, nullptr));
  napi_free_env(unattached);
  ExpectStatus(napi_invalid_arg, napi_fatal_exception_primjs(env_, nullptr));
  napi_value first = Value("new Error('pending')");
  napi_value second = Value("new Error('fatal')");
  CHECK_NAPI(napi_throw_primjs(env_, first));
  ExpectStatus(napi_pending_exception,
               napi_fatal_exception_primjs(env_, second));
  ExpectStatus(napi_pending_exception,
               napi_fatal_exception_primjs(env_, nullptr));
  EXPECT_EQ(0, reports_);
  napi_value pending;
  CHECK_NAPI(napi_get_and_clear_last_exception_primjs(env_, &pending));
  ExpectSame(first, pending);
  ExpectStatus(napi_ok, napi_fatal_exception_primjs(env_, second));
  EXPECT_EQ(1, reports_);
}

TEST_P(FatalExceptionTest, MissingHandlerOrRuntimeFails) {
  napi_value error = Value("new Error('fatal')");
  ConfigureHandler(false);
  ExpectStatus(napi_generic_failure, napi_fatal_exception_primjs(env_, error));
  napi_detach_runtime(env_);
  ExpectStatus(napi_generic_failure, napi_fatal_exception_primjs(env_, error));
  ConfigureHandler();
  ExpectStatus(napi_ok, napi_fatal_exception_primjs(env_, error));
  EXPECT_EQ(1, reports_);
}

TEST_P(FatalExceptionTest, HandlerExceptionIsPreserved) {
  napi_value primary = Value("new Error('primary')");
  napi_value secondary = Value("new Error('secondary')");
  handler_ = [&](napi_value error) {
    if (reports_ == 1) {
      ExpectSame(primary, error);
      CHECK_NAPI(napi_throw_primjs(env_, secondary));
    } else {
      ExpectSame(secondary, error);
    }
  };
  {
    Napi::ErrorScope scope(env_);
    ExpectStatus(napi_pending_exception,
                 napi_fatal_exception_primjs(env_, primary));
    EXPECT_EQ(1, reports_);
    napi_value pending;
    CHECK_NAPI(napi_get_and_clear_last_exception_primjs(env_, &pending));
    ExpectSame(secondary, pending);
    CHECK_NAPI(napi_throw_primjs(env_, pending));
  }
  // The legacy outer scope reports the secondary error, never the primary
  // twice.
  EXPECT_EQ(2, reports_);
}

TEST_P(FatalExceptionTest, HandlerJavaScriptExceptionIsPreserved) {
  napi_value primary = Value("new Error('primary')");
  napi_value secondary = Value("'secondary JavaScript error'");
  handler_ = [&](napi_value error) {
    ExpectSame(primary, error);
    napi_value ignored;
    EXPECT_NE(napi_ok, eval("throw 'secondary JavaScript error';\n", &ignored));
    bool pending = false;
    CHECK_NAPI(napi_is_exception_pending_primjs(env_, &pending));
    EXPECT_TRUE(pending);
  };
  ExpectStatus(napi_pending_exception,
               napi_fatal_exception_primjs(env_, primary));
  EXPECT_EQ(1, reports_);
  napi_value pending;
  CHECK_NAPI(napi_get_and_clear_last_exception_primjs(env_, &pending));
  ExpectSame(secondary, pending);
}

TEST_P(FatalExceptionTest, RecursiveDispatchIsRejectedAndGuardResets) {
  napi_value error = Value("new Error('fatal')");
  handler_ = [&](napi_value actual) {
    ExpectSame(error, actual);
    ExpectStatus(napi_generic_failure,
                 napi_fatal_exception_primjs(env_, actual));
  };
  ExpectStatus(napi_ok, napi_fatal_exception_primjs(env_, error));
  ExpectStatus(napi_ok, napi_fatal_exception_primjs(env_, error));
  EXPECT_EQ(2, reports_);
}

TEST_P(FatalExceptionTest, LegacyErrorScopeTimingIsUnchanged) {
  napi_value error = Value("new Error('legacy')");
  handler_ = [&](napi_value actual) { ExpectSame(error, actual); };
  {
    Napi::ErrorScope outer(env_);
    {
      Napi::ErrorScope inner(env_);
      CHECK_NAPI(env_->napi_throw_(env_, error));
      EXPECT_EQ(0, reports_);
    }
    EXPECT_EQ(1, reports_);
  }
  EXPECT_EQ(1, reports_);
  ConfigureHandler(false);
  {
    Napi::ErrorScope scope(env_);
    CHECK_NAPI(env_->napi_throw_(env_, error));
  }
  EXPECT_EQ(1, reports_);
}

TEST_P(FatalExceptionTest, NativeCallbackReportsBeforeReturn) {
  error_ = Value("new Error('callback')");
  napi_value callback;
  CHECK_NAPI(napi_create_function_primjs(
      env_, "reportFatal", NAPI_AUTO_LENGTH,
      [](napi_env env, napi_callback_info info) -> napi_value {
        FatalExceptionTest* self;
        CHECK_NAPI(napi_get_cb_info_primjs(env, info, nullptr, nullptr, nullptr,
                                           reinterpret_cast<void**>(&self)));
        self->dispatch_status_ = napi_fatal_exception_primjs(env, self->error_);
        EXPECT_EQ(1, self->reports_);
        return nullptr;
      },
      this, &callback));
  napi_value global;
  CHECK_NAPI(napi_get_global_primjs(env_, &global));
  CHECK_NAPI(
      napi_set_named_property_primjs(env_, global, "reportFatal", callback));
  {
    Napi::ErrorScope scope(env_);
    napi_value caught = Value(
        "(() => { let caught = false; try { reportFatal(); } "
        "catch (e) { caught = true; } return caught; })()");
    bool result = true;
    CHECK_NAPI(napi_get_value_bool_primjs(env_, caught, &result));
    EXPECT_FALSE(result);
    EXPECT_EQ(napi_ok, dispatch_status_);
  }
  EXPECT_EQ(1, reports_);
}

TEST_P(FatalExceptionTest, AsyncWorkAndThreadsafeFunctionReportOnce) {
  error_ = Value("new Error('async')");
  napi_value name = Value("'fatal dispatch'");
  napi_async_work work;
  CHECK_NAPI(napi_create_async_work_primjs(
      env_, nullptr, name, [](napi_env, void*) {}, Complete, this, &work));
  CHECK_NAPI(napi_queue_async_work_primjs(env_, work));
  EXPECT_EQ(0, reports_);
  // Pump completion work on the JavaScript thread with a bounded wait.
  for (int attempt = 0; attempt < 100 && completions_ == 0; ++attempt) {
    delegate_->ProcessTasks();
    if (completions_ == 0)
      std::this_thread::sleep_for(std::chrono::milliseconds(10));
  }
  ASSERT_EQ(1, completions_);
  EXPECT_EQ(napi_ok, completion_status_);
  EXPECT_EQ(napi_ok, dispatch_status_);
  EXPECT_EQ(1, reports_);
  CHECK_NAPI(napi_delete_async_work_primjs(env_, work));

  napi_threadsafe_function tsfn;
  CHECK_NAPI(napi_create_threadsafe_function_primjs(
      env_, nullptr, nullptr, name, 0, 1, nullptr, nullptr, this,
      [](napi_env env, napi_value, void* context, void*) {
        ASSERT_NE(nullptr, env);
        auto* self = static_cast<FatalExceptionTest*>(context);
        self->dispatch_status_ = napi_fatal_exception_primjs(env, self->error_);
      },
      &tsfn));
  CHECK_NAPI(napi_call_threadsafe_function_primjs(tsfn, nullptr,
                                                  napi_tsfn_nonblocking));
  CHECK_NAPI(napi_release_threadsafe_function_primjs(tsfn, napi_tsfn_release));
  delegate_->ProcessTasks();
  EXPECT_EQ(napi_ok, dispatch_status_);
  EXPECT_EQ(2, reports_);
}

TEST_P(FatalExceptionTest, TeardownRejectsExplicitDispatch) {
  error_ = Value("new Error('teardown')");
  napi_async_work work;
  CHECK_NAPI(napi_create_async_work_primjs(
      env_, nullptr, Value("'cancelled work'"), [](napi_env, void*) {},
      [](napi_env env, napi_status status, void* data) {
        auto* self = static_cast<FatalExceptionTest*>(data);
        Complete(env, status, self);
        CHECK_NAPI(napi_delete_async_work_primjs(env, self->closing_work_));
      },
      this, &work));
  closing_work_ = work;
  napi_detach_runtime(env_);
  EXPECT_EQ(1, completions_);
  EXPECT_EQ(napi_cancelled, completion_status_);
  EXPECT_EQ(napi_generic_failure, dispatch_status_);
  EXPECT_EQ(0, reports_);
  ConfigureHandler();
}

TEST_P(FatalExceptionTest, WeakNodeApiDispatchUsesAdapter) {
  napi_value error = Value("new Error('weak')");
  handler_ = [&](napi_value actual) { ExpectSame(error, actual); };
  EXPECT_EQ(static_cast<int>(napi_ok),
            static_cast<int>(napi_fatal_exception_weak(
                reinterpret_cast<napi_env_weak>(env_),
                reinterpret_cast<napi_value_weak>(error))));
  EXPECT_EQ(1, reports_);
}
