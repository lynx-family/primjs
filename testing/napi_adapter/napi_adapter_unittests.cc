
// Copyright 2024-2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "napi_adapter_unittests.h"

#include <gtest/gtest.h>

#include <chrono>
#include <filesystem>
#include <fstream>
#include <thread>
#include <unordered_map>
#include <unordered_set>

#include "napi.h"

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

namespace fs = std::filesystem;

class NAPITest : public test::NAPITestBase {
 public:
  static std::string GetNapiExceptionMessage(napi_env env) {
    napi_value exception{nullptr}, err_msg_key{nullptr}, err_msg{nullptr};
    CHECK_NAPI(napi_get_and_clear_last_exception(env, &exception));
    napi_valuetype exception_type = napi_undefined;
    CHECK_NAPI(napi_typeof(env, exception, &exception_type));
    if (exception == nullptr || exception_type != napi_object) {
      return "empty exception message.";
    }
    CHECK_NAPI(
        napi_create_string_utf8(env, "name", NAPI_AUTO_LENGTH, &err_msg_key));
    CHECK_NAPI(napi_get_property(env, exception, err_msg_key, &err_msg));
    size_t length = 0;
    CHECK_NAPI(napi_get_value_string_utf8(env, err_msg, nullptr, 0, &length));
    std::string name(length, 0);
    CHECK_NAPI(napi_get_value_string_utf8(env, err_msg, name.data(), length + 1,
                                          &length));

    CHECK_NAPI(napi_create_string_utf8(env, "message", NAPI_AUTO_LENGTH,
                                       &err_msg_key));
    CHECK_NAPI(napi_get_property(env, exception, err_msg_key, &err_msg));

    napi_valuetype type;
    napi_typeof(env, err_msg, &type);

    CHECK_NAPI(napi_get_value_string_utf8(env, err_msg, nullptr, 0, &length));
    std::string error_message(length, 0);
    CHECK_NAPI(napi_get_value_string_utf8(env, err_msg, error_message.data(),
                                          length + 1, &length));

    CHECK_NAPI(
        napi_create_string_utf8(env, "stack", NAPI_AUTO_LENGTH, &err_msg_key));
    CHECK_NAPI(napi_get_property(env, exception, err_msg_key, &err_msg));
    CHECK_NAPI(napi_get_value_string_utf8(env, err_msg, nullptr, 0, &length));
    std::string stack(length, 0);
    napi_get_value_string_utf8(env, err_msg, stack.data(), length + 1, &length);

    return name + ", " + error_message + ", stack:" + stack;
  }

  void EvalJsFile(const fs::path& file_path, napi_env env_) {
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
      CHECK_NAPI(napi_get_last_error_info(env_, &info));
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
  CHECK_NAPI(napi_get_global(env_, &global));
  napi_value run_call_checks;
  CHECK_NAPI(
      napi_get_named_property(env_, global, "runCallChecks", &run_call_checks));
  napi_valuetype type;
  napi_typeof(env_, run_call_checks, &type);
  if (type != napi_function) {
    return;
  }
  napi_status status =
      napi_call_function(env_, global, run_call_checks, 0, nullptr, nullptr);
  if (status != napi_ok) {
    const napi_extended_error_info* info;
    CHECK_NAPI(napi_get_last_error_info(env_, &info));
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
  CHECK_NAPI(napi_get_cb_info(env, info, &argc, argv, nullptr,
                              reinterpret_cast<void**>(&rt)));
  napi_ref func_ref;
  CHECK_NAPI(napi_create_reference(env, argv[0], 1, &func_ref));
  rt->delegate_->PostJSTask([rt, func_ref]() {
    napi_value func;
    CHECK_NAPI(napi_get_reference_value(rt->env_, func_ref, &func));
    napi_value global;
    CHECK_NAPI(napi_get_global(rt->env_, &global));
    napi_status status =
        napi_call_function(rt->env_, global, func, 0, nullptr, nullptr);
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

constexpr const char* kTargetPath = "../../testing/napi_adapter/js_native_api";

TEST_P(NAPITest, NapiJS) {
  for (const auto& dir_entry : fs::directory_iterator(kTargetPath)) {
    if (!dir_entry.is_directory()) {
      continue;
    }

    fs::path build_dir = dir_entry.path() / "build";
    if (!fs::is_directory(build_dir)) {
      continue;
    }

    env_ = runtime_->Env();
    {
      Napi::HandleScope(Napi::Env(env_));
      runtime_->SetupTestEnv(dir_entry.path().string());

      for (const auto& file_entry : fs::directory_iterator(build_dir)) {
        if (!file_entry.is_regular_file() ||
            file_entry.path().extension() != ".js") {
          continue;
        }
        EvalJsFile(file_entry.path(), env_);
        runtime_->ProcessTasks(file_entry.path().string());
      }
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
    Napi::HandleScope(Napi::Env(env_));
    runtime_->SetupTestEnv(sTestName);

    napi_value ret;
    napi_status status = eval(sJsContent, &ret);

    if (status != napi_ok) {
      const napi_extended_error_info* info;
      CHECK_NAPI(napi_get_last_error_info(env_, &info));
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
  CHECK_NAPI(napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr));
  size_t len = 0;
  CHECK_NAPI(napi_get_value_string_utf8(env, argv[0], nullptr, 0, &len));
  sTestName = std::string(len, 0);
  CHECK_NAPI(napi_get_value_string_utf8(env, argv[0], sTestName.data(), len + 1,
                                        &len));
  CHECK_NAPI(napi_get_value_string_utf8(env, argv[1], nullptr, 0, &len));
  sJsContent = std::string(len, 0);
  CHECK_NAPI(napi_get_value_string_utf8(env, argv[1], sJsContent.data(),
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
  napi_define_properties(env, exports, sizeof(descs) / sizeof(descs[0]), descs);
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
  napi_module_register(&HarmonyAdapterTestModule);
}

EXTERN_C_END
#endif  // JS_ENGINE_HARMONY

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif

#include "generated/weak_node_api.hpp"
void setup_weak_node_api_env(void) __attribute__((constructor));
void setup_weak_node_api_env() {
  static NodeApiHost* weak_host = new NodeApiHost{
      .napi_module_register_weak =
          reinterpret_cast<void (*)(napi_module_weak*)>(napi_module_register),
      .napi_fatal_error_weak =
          reinterpret_cast<void (*)(const char*, size_t, const char*, size_t)>(
              napi_fatal_error),
      .napi_get_threadsafe_function_context_weak =
          reinterpret_cast<napi_status_weak (*)(napi_threadsafe_function_weak,
                                                void**)>(
              napi_get_threadsafe_function_context),
      .napi_call_threadsafe_function_weak =
          reinterpret_cast<napi_status_weak (*)(
              napi_threadsafe_function_weak, void*,
              napi_threadsafe_function_call_mode_weak)>(
              napi_call_threadsafe_function),
      .napi_acquire_threadsafe_function_weak =
          reinterpret_cast<napi_status_weak (*)(napi_threadsafe_function_weak)>(
              napi_acquire_threadsafe_function),
      .napi_release_threadsafe_function_weak =
          reinterpret_cast<napi_status_weak (*)(
              napi_threadsafe_function_weak,
              napi_threadsafe_function_release_mode_weak)>(
              napi_release_threadsafe_function)};

  weak_host->napi_get_last_error_info_weak =
      reinterpret_cast<napi_status_weak (*)(
          node_api_basic_env_weak, const napi_extended_error_info_weak**)>(
          napi_get_last_error_info);
  weak_host->napi_get_undefined_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak*)>(
          napi_get_undefined);
  weak_host->napi_get_null_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak*)>(
          napi_get_null);
  weak_host->napi_get_global_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak*)>(
          napi_get_global);
  weak_host->napi_get_boolean_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, bool, napi_value_weak*)>(napi_get_boolean);
  weak_host->napi_create_object_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak*)>(
          napi_create_object);
  weak_host->napi_create_array_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak*)>(
          napi_create_array);
  weak_host->napi_create_array_with_length_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, size_t,
                                            napi_value_weak*)>(
          napi_create_array_with_length);
  weak_host->napi_create_double_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, double, napi_value_weak*)>(napi_create_double);
  weak_host->napi_create_int32_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, int32_t, napi_value_weak*)>(napi_create_int32);
  weak_host->napi_create_uint32_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, uint32_t, napi_value_weak*)>(napi_create_uint32);
  weak_host->napi_create_int64_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, int64_t, napi_value_weak*)>(napi_create_int64);
  weak_host->napi_create_string_latin1_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, const char*, size_t,
                                            napi_value_weak*)>(
          napi_create_string_latin1);
  weak_host->napi_create_string_utf8_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, const char*, size_t,
                                            napi_value_weak*)>(
          napi_create_string_utf8);
  weak_host->napi_create_string_utf16_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, const char16_t*,
                                            size_t, napi_value_weak*)>(
          napi_create_string_utf16);
  weak_host->napi_create_symbol_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak*)>(napi_create_symbol);
  weak_host->napi_create_function_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, const char*, size_t, napi_callback_weak, void*,
      napi_value_weak*)>(napi_create_function);
  weak_host->napi_create_error_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak, napi_value_weak*)>(
      napi_create_error);
  weak_host->napi_create_type_error_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            napi_value_weak, napi_value_weak*)>(
          napi_create_type_error);
  weak_host->napi_create_range_error_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            napi_value_weak, napi_value_weak*)>(
          napi_create_range_error);
  weak_host->napi_typeof_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_valuetype_weak*)>(napi_typeof);
  weak_host->napi_get_value_double_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, double*)>(napi_get_value_double);
  weak_host->napi_get_value_int32_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, int32_t*)>(napi_get_value_int32);
  weak_host->napi_get_value_uint32_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, uint32_t*)>(napi_get_value_uint32);
  weak_host->napi_get_value_int64_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, int64_t*)>(napi_get_value_int64);
  weak_host->napi_get_value_bool_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, bool*)>(napi_get_value_bool);
  weak_host->napi_get_value_string_latin1_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            char*, size_t, size_t*)>(
          napi_get_value_string_latin1);
  weak_host->napi_get_value_string_utf8_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            char*, size_t, size_t*)>(
          napi_get_value_string_utf8);
  weak_host->napi_get_value_string_utf16_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            char16_t*, size_t, size_t*)>(
          napi_get_value_string_utf16);
  weak_host->napi_coerce_to_bool_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak*)>(napi_coerce_to_bool);
  weak_host->napi_coerce_to_number_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak*)>(napi_coerce_to_number);
  weak_host->napi_coerce_to_object_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak*)>(napi_coerce_to_object);
  weak_host->napi_coerce_to_string_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak*)>(napi_coerce_to_string);
  weak_host->napi_get_prototype_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak*)>(napi_get_prototype);
  weak_host->napi_get_property_names_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            napi_value_weak*)>(
          napi_get_property_names);
  weak_host->napi_set_property_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak, napi_value_weak)>(
      napi_set_property);
  weak_host->napi_has_property_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak, bool*)>(
      napi_has_property);
  weak_host->napi_get_property_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak, napi_value_weak*)>(
      napi_get_property);
  weak_host->napi_delete_property_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak, bool*)>(
      napi_delete_property);
  weak_host->napi_has_own_property_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak, bool*)>(
      napi_has_own_property);
  weak_host->napi_set_named_property_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            const char*, napi_value_weak)>(
          napi_set_named_property);
  weak_host->napi_has_named_property_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            const char*, bool*)>(
          napi_has_named_property);
  weak_host->napi_get_named_property_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            const char*, napi_value_weak*)>(
          napi_get_named_property);
  weak_host->napi_set_element_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, uint32_t, napi_value_weak)>(
      napi_set_element);
  weak_host->napi_has_element_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, uint32_t, bool*)>(napi_has_element);
  weak_host->napi_get_element_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, uint32_t, napi_value_weak*)>(
      napi_get_element);
  weak_host->napi_delete_element_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, uint32_t, bool*)>(napi_delete_element);
  weak_host->napi_define_properties_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, napi_value_weak, size_t,
          const napi_property_descriptor_weak*)>(napi_define_properties);
  weak_host->napi_is_array_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, bool*)>(napi_is_array);
  weak_host->napi_get_array_length_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, uint32_t*)>(napi_get_array_length);
  weak_host->napi_strict_equals_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak, bool*)>(
      napi_strict_equals);
  weak_host->napi_call_function_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak, size_t,
      const napi_value_weak*, napi_value_weak*)>(napi_call_function);
  weak_host->napi_new_instance_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, size_t, const napi_value_weak*,
      napi_value_weak*)>(napi_new_instance);
  weak_host->napi_instanceof_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak, bool*)>(napi_instanceof);
  weak_host->napi_get_cb_info_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_callback_info_weak, size_t*, napi_value_weak*,
      napi_value_weak*, void**)>(napi_get_cb_info);
  weak_host->napi_get_new_target_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_callback_info_weak, napi_value_weak*)>(
      napi_get_new_target);
  weak_host->napi_define_class_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, const char*, size_t, napi_callback_weak, void*, size_t,
      const napi_property_descriptor_weak*, napi_value_weak*)>(
      napi_define_class);
  weak_host->napi_wrap_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, void*, node_api_basic_finalize_weak,
      void*, napi_ref_weak*)>(napi_wrap);
  weak_host->napi_unwrap_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, void**)>(napi_unwrap);
  weak_host->napi_remove_wrap_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, void**)>(napi_remove_wrap);
  weak_host->napi_create_external_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, void*, node_api_basic_finalize_weak, void*,
      napi_value_weak*)>(napi_create_external);
  weak_host->napi_get_value_external_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            void**)>(napi_get_value_external);
  weak_host->napi_create_reference_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, uint32_t, napi_ref_weak*)>(
      napi_create_reference);
  weak_host->napi_delete_reference_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_ref_weak)>(
          napi_delete_reference);
  weak_host->napi_reference_ref_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_ref_weak, uint32_t*)>(napi_reference_ref);
  weak_host->napi_reference_unref_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_ref_weak, uint32_t*)>(napi_reference_unref);
  weak_host->napi_get_reference_value_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_ref_weak,
                                            napi_value_weak*)>(
          napi_get_reference_value);
  weak_host->napi_open_handle_scope_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, napi_handle_scope_weak*)>(napi_open_handle_scope);
  weak_host->napi_close_handle_scope_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, napi_handle_scope_weak)>(napi_close_handle_scope);
  weak_host->napi_open_escapable_handle_scope_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak,
                                            napi_escapable_handle_scope_weak*)>(
          napi_open_escapable_handle_scope);
  weak_host->napi_close_escapable_handle_scope_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak,
                                            napi_escapable_handle_scope_weak)>(
          napi_close_escapable_handle_scope);
  weak_host->napi_escape_handle_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_escapable_handle_scope_weak, napi_value_weak,
      napi_value_weak*)>(napi_escape_handle);
  weak_host->napi_throw_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak)>(
          napi_throw);
  weak_host->napi_throw_error_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, const char*, const char*)>(napi_throw_error);
  weak_host->napi_throw_type_error_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, const char*, const char*)>(napi_throw_type_error);
  weak_host->napi_throw_range_error_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, const char*, const char*)>(napi_throw_range_error);
  weak_host->napi_is_error_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, bool*)>(napi_is_error);
  weak_host->napi_is_exception_pending_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, bool*)>(
          napi_is_exception_pending);
  weak_host->napi_get_and_clear_last_exception_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak*)>(
          napi_get_and_clear_last_exception);
  weak_host->napi_is_arraybuffer_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, bool*)>(napi_is_arraybuffer);
  weak_host->napi_create_arraybuffer_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, size_t, void**,
                                            napi_value_weak*)>(
          napi_create_arraybuffer);
  weak_host->napi_create_external_arraybuffer_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, void*, size_t, node_api_basic_finalize_weak, void*,
          napi_value_weak*)>(napi_create_external_arraybuffer);
  weak_host->napi_get_arraybuffer_info_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            void**, size_t*)>(
          napi_get_arraybuffer_info);
  weak_host->napi_is_typedarray_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, bool*)>(napi_is_typedarray);
  weak_host->napi_create_typedarray_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, napi_typedarray_type_weak, size_t, napi_value_weak,
          size_t, napi_value_weak*)>(napi_create_typedarray);
  weak_host->napi_get_typedarray_info_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, napi_value_weak, napi_typedarray_type_weak*, size_t*,
          void**, napi_value_weak*, size_t*)>(napi_get_typedarray_info);
  weak_host->napi_create_dataview_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, size_t, napi_value_weak, size_t, napi_value_weak*)>(
      napi_create_dataview);
  weak_host->napi_is_dataview_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, bool*)>(napi_is_dataview);
  weak_host->napi_get_dataview_info_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            size_t*, void**, napi_value_weak*,
                                            size_t*)>(napi_get_dataview_info);
  weak_host->napi_get_version_weak = reinterpret_cast<napi_status_weak (*)(
      node_api_basic_env_weak, uint32_t*)>(napi_get_version);
  weak_host->napi_create_promise_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_deferred_weak*, napi_value_weak*)>(
      napi_create_promise);
  weak_host->napi_resolve_deferred_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_deferred_weak, napi_value_weak)>(
      napi_resolve_deferred);
  weak_host->napi_reject_deferred_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_deferred_weak, napi_value_weak)>(
      napi_reject_deferred);
  weak_host->napi_is_promise_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, bool*)>(napi_is_promise);
  weak_host->napi_run_script_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, napi_value_weak*)>(napi_run_script);
  weak_host->napi_adjust_external_memory_weak =
      reinterpret_cast<napi_status_weak (*)(node_api_basic_env_weak, int64_t,
                                            int64_t*)>(
          napi_adjust_external_memory);
  weak_host->napi_create_date_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, double, napi_value_weak*)>(napi_create_date);
  weak_host->napi_is_date_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, bool*)>(napi_is_date);
  weak_host->napi_get_date_value_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, double*)>(napi_get_date_value);
  weak_host->napi_add_finalizer_weak = reinterpret_cast<napi_status_weak (*)(
      napi_env_weak, napi_value_weak, void*, node_api_basic_finalize_weak,
      void*, napi_ref_weak*)>(napi_add_finalizer);
  weak_host->napi_create_bigint_int64_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, int64_t, napi_value_weak*)>(napi_create_bigint_int64);
  weak_host->napi_create_bigint_uint64_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, uint64_t,
                                            napi_value_weak*)>(
          napi_create_bigint_uint64);
  weak_host->napi_create_bigint_words_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, int, size_t,
                                            const uint64_t*, napi_value_weak*)>(
          napi_create_bigint_words);
  weak_host->napi_get_value_bigint_int64_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            int64_t*, bool*)>(
          napi_get_value_bigint_int64);
  weak_host->napi_get_value_bigint_uint64_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            uint64_t*, bool*)>(
          napi_get_value_bigint_uint64);
  weak_host->napi_get_value_bigint_words_weak =
      reinterpret_cast<napi_status_weak (*)(napi_env_weak, napi_value_weak,
                                            int*, size_t*, uint64_t*)>(
          napi_get_value_bigint_words);
  weak_host->napi_get_all_property_names_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, napi_value_weak, napi_key_collection_mode_weak,
          napi_key_filter_weak, napi_key_conversion_weak, napi_value_weak*)>(
          napi_get_all_property_names);
  weak_host->napi_set_instance_data_weak =
      reinterpret_cast<napi_status_weak (*)(node_api_basic_env_weak, void*,
                                            napi_finalize_weak, void*)>(
          napi_set_instance_data);
  weak_host->napi_get_instance_data_weak =
      reinterpret_cast<napi_status_weak (*)(node_api_basic_env_weak, void**)>(
          napi_get_instance_data);
  weak_host->napi_add_env_cleanup_hook_weak =
      reinterpret_cast<napi_status_weak (*)(node_api_basic_env_weak,
                                            napi_cleanup_hook_weak, void*)>(
          napi_add_env_cleanup_hook);
  weak_host->napi_remove_env_cleanup_hook_weak =
      reinterpret_cast<napi_status_weak (*)(node_api_basic_env_weak,
                                            napi_cleanup_hook_weak, void*)>(
          napi_remove_env_cleanup_hook);
  weak_host->napi_create_async_work_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, napi_value_weak, napi_value_weak,
          napi_async_execute_callback_weak, napi_async_complete_callback_weak,
          void*, napi_async_work_weak*)>(napi_create_async_work);
  weak_host->napi_delete_async_work_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, napi_async_work_weak)>(napi_delete_async_work);
  weak_host->napi_queue_async_work_weak = reinterpret_cast<napi_status_weak (*)(
      node_api_basic_env_weak, napi_async_work_weak)>(napi_queue_async_work);
  weak_host->napi_cancel_async_work_weak =
      reinterpret_cast<napi_status_weak (*)(node_api_basic_env_weak,
                                            napi_async_work_weak)>(
          napi_cancel_async_work);
  weak_host->napi_create_threadsafe_function_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_env_weak, napi_value_weak, napi_value_weak, napi_value_weak,
          size_t, size_t, void*, napi_finalize_weak, void*,
          napi_threadsafe_function_call_js_weak,
          napi_threadsafe_function_weak*)>(napi_create_threadsafe_function);
  weak_host->napi_get_threadsafe_function_context_weak =
      reinterpret_cast<napi_status_weak (*)(napi_threadsafe_function_weak,
                                            void**)>(
          napi_get_threadsafe_function_context);
  weak_host->napi_call_threadsafe_function_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_threadsafe_function_weak, void*,
          napi_threadsafe_function_call_mode_weak)>(
          napi_call_threadsafe_function);
  weak_host->napi_acquire_threadsafe_function_weak =
      reinterpret_cast<napi_status_weak (*)(napi_threadsafe_function_weak)>(
          napi_acquire_threadsafe_function);
  weak_host->napi_release_threadsafe_function_weak =
      reinterpret_cast<napi_status_weak (*)(
          napi_threadsafe_function_weak,
          napi_threadsafe_function_release_mode_weak)>(
          napi_release_threadsafe_function);
  weak_host->napi_unref_threadsafe_function_weak =
      reinterpret_cast<napi_status_weak (*)(node_api_basic_env_weak,
                                            napi_threadsafe_function_weak)>(
          napi_unref_threadsafe_function);
  weak_host->napi_ref_threadsafe_function_weak =
      reinterpret_cast<napi_status_weak (*)(node_api_basic_env_weak,
                                            napi_threadsafe_function_weak)>(
          napi_ref_threadsafe_function);

  inject_weak_node_api_host(*weak_host);
}
