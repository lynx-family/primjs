// Copyright 2024-2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef TESTING_NAPI_ADAPTER_NAPI_ADAPTER_UNITTESTS_H_
#define TESTING_NAPI_ADAPTER_NAPI_ADAPTER_UNITTESTS_H_

#include <gtest/gtest.h>

#include <condition_variable>
#include <functional>
#include <memory>
#include <mutex>
#include <queue>
#include <string>
#include <thread>
#include <utility>

#include "basic/log/logging.h"
#include "js_native_api.h"
#include "js_native_api_adapter.h"
#include "js_native_api_types.h"
#include "napi/env/napi_env.h"
#include "napi/env/napi_runtime.h"
#include "napi/napi.h"
#ifdef JS_ENGINE_HARMONY
#include "napi/harmony/napi_env_harmony.h"
#endif  // JS_ENGINE_HARMONY

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

#define CHECK_NAPI(expr)         \
  do {                           \
    napi_status status = (expr); \
    EXPECT_EQ(status, napi_ok);  \
  } while (0)

namespace test {
class TaskDelegate : public std::enable_shared_from_this<TaskDelegate> {
 public:
  TaskDelegate() : stop_(false) {
    creation_thread_id_ = std::this_thread::get_id();
  }

  ~TaskDelegate() {
    {
      std::unique_lock<std::mutex> lock(queue_mutex_);
      stop_ = true;
    }
    condition_.notify_all();
  }

  static std::shared_ptr<TaskDelegate> Create() {
    return std::shared_ptr<TaskDelegate>(new TaskDelegate());
  }

  void PostJSTask(std::function<void()> closure) {
    std::unique_lock<std::mutex> lock(queue_mutex_);
    task_queue_.emplace(std::move(closure));
    condition_.notify_one();
  }

  void Clear() {
    std::queue<std::function<void()>> tasks;
    {
      std::unique_lock<std::mutex> lock(queue_mutex_);
      if (task_queue_.empty()) {
        return;
      }
      tasks.swap(task_queue_);
    }
  }

  void ProcessTasks() {
    if (std::this_thread::get_id() != creation_thread_id_) {
      return;
    }

    {
      std::unique_lock<std::mutex> lock(queue_mutex_);
      if (task_queue_.empty()) {
        return;
      }
    }
    while (true) {
      std::unique_lock<std::mutex> lock(queue_mutex_);
      if (task_queue_.empty()) {
        return;
      }
      std::queue<std::function<void()>> tasks;
      tasks.swap(task_queue_);
      lock.unlock();
      while (!tasks.empty()) {
        tasks.front()();
        tasks.pop();
      }
      lock.lock();
      if (!task_queue_.empty()) {
        continue;
      }
      condition_.wait_for(lock, std::chrono::seconds(1),
                          [this]() { return !task_queue_.empty() || stop_; });
    }
  }

 private:
  std::thread::id creation_thread_id_;
  std::queue<std::function<void()>> task_queue_;
  std::mutex queue_mutex_;
  std::condition_variable condition_;
  bool stop_;
};

void PostNAPIJSTask(napi_foreground_cb js_cb, void* data, void* task_ctx) {
  auto delegate_observer = std::weak_ptr<TaskDelegate>(
      *static_cast<std::shared_ptr<TaskDelegate>*>(task_ctx));
  delegate_observer.lock().get()->PostJSTask(
      [delegate_observer, js_cb, data]() {
        if (delegate_observer.lock()) {
          js_cb(data);
        }
      });
}

class NAPIRuntime {
 public:
  virtual ~NAPIRuntime() = default;
  napi_env Env() { return env_; }

  virtual void ConstructEnv() {
    env_ = napi_new_env();
    napi_runtime_configuration runtime_conf =
        napi_create_runtime_configuration();
    delegate_->Clear();
    napi_runtime_config_foreground_handler(runtime_conf, PostNAPIJSTask,
                                           &delegate_);
    napi_runtime_config_uncaught_handler(
        runtime_conf,
        [](napi_env env, napi_value exception, void* data) {
          std::string err_msg =
              Napi::Value(env, exception).ToString().Utf8Value();
          ASSERT_NO_FATAL_FAILURE("uncaught exception: " + err_msg);
          ADD_FAILURE() << "uncaught exception: " << err_msg;
        },
        &uncaught_err_msg_);
    napi_attach_runtime_with_configuration(env_, runtime_conf);
    napi_delete_runtime_configuration(runtime_conf);
  }

  virtual void DestructEnv() { napi_detach_runtime(env_); }

  virtual void TriggerGC() = 0;
  virtual void RunCallChecks(const std::string& name);
  virtual void SetupTestEnv(const std::string& name) {
    path_ = name;
    napi_setup_loader(env_, "napiLoaderForTest");
    napi_value global;
    CHECK_NAPI(napi_get_global(env_, &global));
    CHECK_NAPI(napi_set_named_property(env_, global, "window", global));

    CHECK_NAPI(napi_add_finalizer(
        env_, global, this,
        [](napi_env env, void* finalize_data, void* finalize_hint) {
          NAPIRuntime* rt = reinterpret_cast<NAPIRuntime*>(finalize_data);
          rt->RunCallChecks(rt->path_);
        },
        nullptr, nullptr));

    napi_value func;
    CHECK_NAPI(napi_create_function(env_, "triggerGC", NAPI_AUTO_LENGTH,
                                    TriggerGCEntry, this, &func));
    CHECK_NAPI(napi_set_named_property(env_, global, "gc", func));

    CHECK_NAPI(napi_create_function(env_, "setTimeout", NAPI_AUTO_LENGTH,
                                    SetTimeout, this, &func));
    CHECK_NAPI(napi_set_named_property(env_, global, "setTimeout", func));

    CHECK_NAPI(napi_create_function(env_, "clearTimeout", NAPI_AUTO_LENGTH,
                                    ClearTimeout, this, &func));
    CHECK_NAPI(napi_set_named_property(env_, global, "clearTimeout", func));
  }

  virtual void ProcessTasks(const std::string& path) {
    delegate_->ProcessTasks();
  }

  static napi_value TriggerGCEntry(napi_env env, napi_callback_info info) {
    NAPIRuntime* rt;
    CHECK_NAPI(napi_get_cb_info(env, info, 0, nullptr, nullptr,
                                reinterpret_cast<void**>(&rt)));
    rt->TriggerGC();
    return nullptr;
  }

  static napi_value SetTimeout(napi_env env, napi_callback_info info);

  static napi_value ClearTimeout(napi_env env, napi_callback_info info) {
    return nullptr;
  }

 protected:
  napi_env env_;
  NAPIRuntime() = default;
  std::shared_ptr<TaskDelegate> delegate_ = std::make_shared<TaskDelegate>();
  std::string uncaught_err_msg_;
  std::string path_;
};
}  // namespace test

#ifdef JS_ENGINE_V8
#include <libplatform/libplatform.h>
#include <v8.h>

#include "napi_env_v8.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

namespace test {
class IsolateScopeWrapper {
 public:
  IsolateScopeWrapper(v8::Isolate* isolate) : _scope(isolate) {}

 private:
  v8::Isolate::Scope _scope;
};

class HandleScopeWrapper {
 public:
  HandleScopeWrapper(v8::Isolate* isolate) : _scope(isolate) {}

 private:
  v8::HandleScope _scope;
};

class ContextScopeWrapper {
 public:
  ContextScopeWrapper(v8::Local<v8::Context> context) : _scope(context) {}

 private:
  v8::Context::Scope _scope;
};

class NAPIRuntimeV8SingleMode : public NAPIRuntime {
 public:
  NAPIRuntimeV8SingleMode() { ConstructEnv(); }

  ~NAPIRuntimeV8SingleMode() override { DestructEnv(); }

  void ConstructEnv() override {
    NAPIRuntime::ConstructEnv();

    static std::once_flag flag;
    static std::unique_ptr<v8::Platform> platform =
        v8::platform::NewDefaultPlatform();
    std::call_once(flag, [] {
      std::string flags = "--expose_gc";
      v8::V8::SetFlagsFromString(flags.c_str(), flags.size());
      v8::V8::InitializeICU();
      v8::V8::InitializePlatform(platform.get());
      v8::V8::Initialize();
    });

    _create_params.array_buffer_allocator =
        v8::ArrayBuffer::Allocator::NewDefaultAllocator();
    _isolate = v8::Isolate::New(_create_params);
    _isolate_scope = std::make_unique<IsolateScopeWrapper>(_isolate);
    _isolate_handle_scope = std::make_unique<HandleScopeWrapper>(_isolate);
    v8::Local<v8::Context> context = v8::Context::New(_isolate);
    _context = new v8::Local<v8::Context>(context);
    _context_scope = std::make_unique<ContextScopeWrapper>(context);
    napi_attach_v8(env_, context);
  }

  void DestructEnv() override {
    NAPIRuntime::DestructEnv();
    napi_detach_v8(env_);
    _context_scope.reset();
    delete _context;
    _isolate_handle_scope.reset();
    _isolate_scope.reset();
    _isolate->Dispose();
    delete _create_params.array_buffer_allocator;

    napi_free_env(env_);
  }

  void TriggerGC() override {
    _isolate->RequestGarbageCollectionForTesting(
        v8::Isolate::GarbageCollectionType::kFullGarbageCollection);
  }

 private:
  v8::Isolate* _isolate;
  std::unique_ptr<IsolateScopeWrapper> _isolate_scope;
  std::unique_ptr<HandleScopeWrapper> _isolate_handle_scope;
  v8::Local<v8::Context>* _context;
  std::unique_ptr<ContextScopeWrapper> _context_scope;
  v8::Isolate::CreateParams _create_params;
};
}  // namespace test

#endif

#ifdef JS_ENGINE_JSC
#include <JavaScriptCore/JavaScript.h>

#include "napi_env_jsc.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

extern "C" void JSSynchronousGarbageCollectForDebugging(JSContextRef);
extern "C" void JSSynchronousEdenCollectForDebugging(JSContextRef);
extern "C" void JSReportExtraMemoryCost(JSContextRef, size_t);

namespace test {
class NAPIRuntimeJSCSingleMode : public NAPIRuntime {
 public:
  NAPIRuntimeJSCSingleMode() { ConstructEnv(); }

  ~NAPIRuntimeJSCSingleMode() override { DestructEnv(); }

  void ConstructEnv() override {
    NAPIRuntime::ConstructEnv();
    context_ = JSGlobalContextCreate(nullptr);
    napi_attach_jsc(env_, context_);
  }

  void DestructEnv() override {
    NAPIRuntime::DestructEnv();
    napi_detach_jsc(env_);
    JSGlobalContextRelease(context_);

    napi_free_env(env_);
  }

  void TriggerGC() override {
    // Explicitly triggering GC in JSC can break napi_call_function, so this is
    // left as a no-op. JSSynchronousGarbageCollectForDebugging(context_);
  }

 private:
  JSGlobalContextRef context_;
};
}  // namespace test
#endif

#ifdef JS_ENGINE_QJS
#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif  // __cplusplus
#include "napi/quickjs/napi_env_quickjs.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

namespace test {
class NAPIRuntimeQJS : public NAPIRuntime {
 public:
  NAPIRuntimeQJS() { ConstructEnv(); }

  ~NAPIRuntimeQJS() override { DestructEnv(); }

  void ConstructEnv() override {
    NAPIRuntime::ConstructEnv();

    _rt = LEPUS_NewRuntime();
    _ctx = LEPUS_NewContext(_rt);
    napi_attach_quickjs(env_, _ctx);
    napi_open_handle_scope(env_, &_handle_scope);
  }

  void DestructEnv() override {
    NAPIRuntime::DestructEnv();
    napi_close_handle_scope(env_, _handle_scope);
    napi_detach_quickjs(env_);
    LEPUS_FreeContext(_ctx);
    LEPUS_FreeRuntime(_rt);

    napi_free_env(env_);
  }

  void ProcessTasks(const std::string& path) override;

  void TriggerGC() override { LEPUS_RunGC(_rt); }

 private:
  napi_handle_scope _handle_scope;
  LEPUSRuntime* _rt;
  LEPUSContext* _ctx;
};
}  // namespace test

#endif

#ifdef JS_ENGINE_HARMONY
#include "napi/harmony/napi_env_harmony.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

namespace test {
class NAPIRuntimeHarmony : public NAPIRuntime {
 public:
  NAPIRuntimeHarmony() { ConstructEnv(); }

  void RegisterConsoleLog() {
    JSVM_HandleScope func_scope;
    OH_JSVM_OpenHandleScope(vm_env_, &func_scope);
    JSVM_Value global, console, log;
    OH_JSVM_GetGlobal(vm_env_, &global);
    auto* jsvm_callback = new JSVM_CallbackStruct();
    jsvm_callback->callback = [](JSVM_Env env, JSVM_CallbackInfo info) {
      size_t argc;
      OH_JSVM_GetCbInfo(env, info, &argc, nullptr, nullptr, nullptr);
      std::vector<JSVM_Value> args(argc);
      OH_JSVM_GetCbInfo(env, info, &argc, args.data(), nullptr, nullptr);
      std::ostringstream sstream;
      for (size_t i = 0; i < argc; ++i) {
        JSVM_HandleScope block_scope;
        OH_JSVM_OpenHandleScope(env, &block_scope);
        JSVM_Value str;
        size_t len;
        OH_JSVM_JsonStringify(env, args[i], &str);
        OH_JSVM_GetValueStringUtf8(env, str, nullptr, JSVM_AUTO_LENGTH, &len);
        std::string output_str;
        output_str.resize(len + 1);
        OH_JSVM_GetValueStringUtf8(env, str, output_str.data(),
                                   output_str.size(), nullptr);
        sstream << output_str.c_str() << ", ";
        OH_JSVM_CloseHandleScope(env, block_scope);
      }
      LOGE(sstream.str());
      return JSVM_Value(nullptr);
    };
    jsvm_callback->data = nullptr;
    OH_JSVM_CreateFunction(vm_env_, "log", JSVM_AUTO_LENGTH, jsvm_callback,
                           &log);
    OH_JSVM_AddFinalizer(
        vm_env_, log, jsvm_callback,
        [](JSVM_Env env, void* data, void* hint) {
          delete reinterpret_cast<JSVM_CallbackStruct*>(data);
          return;
        },
        nullptr, nullptr);
    OH_JSVM_CreateObject(vm_env_, &console);
    OH_JSVM_SetNamedProperty(vm_env_, console, "log", log);
    OH_JSVM_SetNamedProperty(vm_env_, global, "console", console);
    OH_JSVM_CloseHandleScope(vm_env_, func_scope);
  }

  virtual ~NAPIRuntimeHarmony() { DestructEnv(); }

  void ConstructEnv() override {
    NAPIRuntime::ConstructEnv();

    static std::once_flag flag;
    std::call_once(flag, []() {
      JSVM_InitOptions init_options;
      memset(&init_options, 0, sizeof(init_options));
      OH_JSVM_Init(&init_options);
    });

    JSVM_CreateVMOptions options;
    memset(&options, 0, sizeof(options));
    OH_JSVM_CreateVM(&options, &vm_);
    OH_JSVM_OpenVMScope(vm_, &vm_scope_);
    OH_JSVM_CreateEnv(vm_, 0, nullptr, &vm_env_);
    OH_JSVM_OpenEnvScope(vm_env_, &vm_env_scope_);
    napi_attach_harmony(env_, vm_env_);
    OH_JSVM_OpenHandleScope(vm_env_, &default_scope_);
    RegisterConsoleLog();
  }

  void DestructEnv() override {
    if (!env_) {
      return;
    }
    NAPIRuntime::DestructEnv();

    OH_JSVM_CloseHandleScope(vm_env_, default_scope_);
    napi_detach_harmony(env_);
    OH_JSVM_CloseEnvScope(vm_env_, vm_env_scope_);
    OH_JSVM_CloseVMScope(vm_, vm_scope_);
    OH_JSVM_DestroyEnv(vm_env_);
    OH_JSVM_DestroyVM(vm_);

    napi_free_env(env_);
    env_ = nullptr;
  }

  void TriggerGC() override {
    OH_JSVM_MemoryPressureNotification(vm_env_,
                                       JSVM_MEMORY_PRESSURE_LEVEL_MODERATE);
  }

 private:
  JSVM_VM vm_;
  JSVM_VMScope vm_scope_;
  JSVM_Env vm_env_;
  JSVM_EnvScope vm_env_scope_;
  JSVM_HandleScope default_scope_;
};
}  // namespace test

#endif  // JS_ENGINE_HARMONY

namespace test {
using RuntimeFactory =
    std::pair<std::string, std::function<std::unique_ptr<NAPIRuntime>()>>;

RuntimeFactory runtimeFactory[] = {
#ifdef JS_ENGINE_QJS
    {"QJS", [] { return std::unique_ptr<NAPIRuntime>(new NAPIRuntimeQJS()); }},
#endif

#ifdef JS_ENGINE_V8
    {"V8",
     [] {
       return std::unique_ptr<NAPIRuntime>(new NAPIRuntimeV8SingleMode());
     }},
#endif

#ifdef JS_ENGINE_JSC
    {"JSC",
     [] {
       return std::unique_ptr<NAPIRuntime>(new NAPIRuntimeJSCSingleMode());
     }},
#endif

#ifdef JS_ENGINE_HARMONY
    {"HARMONY",
     [] { return std::unique_ptr<NAPIRuntime>(new NAPIRuntimeHarmony()); }},
#endif

};

class NAPITestBase : public ::testing::TestWithParam<RuntimeFactory> {
 private:
  RuntimeFactory _factory;

 protected:
  std::unique_ptr<NAPIRuntime> runtime_;

 public:
  napi_status eval(const std::string& code, napi_value* result) {
    napi_status status;
    napi_value js_source;

    status = napi_create_string_utf8(env_, code.c_str(), NAPI_AUTO_LENGTH,
                                     &js_source);
    if (status != napi_ok) return status;

    return napi_run_script(env_, js_source, result);
  }

  NAPITestBase()
      : _factory(GetParam()),
        runtime_(_factory.second()),
        env_(runtime_->Env()) {}
  napi_env env_;
};
}  // namespace test

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif

#endif  // TESTING_NAPI_ADAPTER_NAPI_ADAPTER_UNITTESTS_H_
