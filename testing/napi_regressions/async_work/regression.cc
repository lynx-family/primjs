// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <chrono>
#include <condition_variable>
#include <cstdio>
#include <cstdlib>
#include <mutex>
#include <queue>

#include "js_native_api_adapter.h"
#include "napi.h"
#include "napi_env.h"
#include "napi_env_quickjs.h"
#include "napi_runtime.h"

namespace {
void Require(bool condition) {
  if (!condition) std::abort();
}
void Check(napi_status status) { Require(status == napi_ok); }

struct Data {
  napi_async_work work = nullptr;
  int executed = 0;
  int completed = 0;
  bool adapter = false;
  bool delete_in_complete = true;
  napi_status status = napi_generic_failure;
};
void Execute(napi_env, void* pointer) {
  ++static_cast<Data*>(pointer)->executed;
}
void Complete(napi_env env, napi_status status, void* pointer) {
  auto* data = static_cast<Data*>(pointer);
  ++data->completed;
  data->status = status;
  if (data->delete_in_complete) {
    Check(data->adapter ? napi_delete_async_work_primjs(env, data->work)
                        : env->napi_delete_async_work(env, data->work));
    data->work = nullptr;
  }
}

class Environment {
 public:
  explicit Environment(bool adapter) : adapter(adapter) {
    env = napi_new_env();
    runtime = LEPUS_NewRuntime();
    context = LEPUS_NewContext(runtime);
    napi_attach_quickjs(env, context);
    auto configuration = napi_create_runtime_configuration();
    napi_runtime_config_foreground_handler(
        configuration,
        [](napi_foreground_cb callback, void* data, void* pointer) {
          auto* self = static_cast<Environment*>(pointer);
          std::lock_guard<std::mutex> lock(self->mutex);
          self->tasks.push({callback, data});
          self->condition.notify_all();
        },
        this);
    napi_runtime_config_worker_handler(
        configuration, nullptr, nullptr,
        [](napi_worker_task_runner runner, void* task, void* pointer) {
          auto* self = static_cast<Environment*>(pointer);
          {
            std::unique_lock<std::mutex> lock(self->mutex);
            self->condition.wait(lock, [self] { return self->release_worker; });
          }
          runner(task);
        },
        this);
    napi_attach_runtime_with_configuration(env, configuration);
    napi_delete_runtime_configuration(configuration);
  }
  ~Environment() { Close(); }
  void Close() {
    if (!env) return;
    napi_detach_runtime(env);
    napi_detach_quickjs(env);
    napi_free_env(env);
    LEPUS_FreeContext(context);
    LEPUS_FreeRuntime(runtime);
    env = nullptr;
  }
  napi_status Create(napi_env argument, napi_async_execute_callback execute,
                     napi_async_complete_callback complete, Data* data,
                     napi_async_work* result) {
    return adapter
               ? napi_create_async_work_primjs(argument, nullptr, nullptr,
                                               execute, complete, data, result)
               : env->napi_create_async_work(argument, nullptr, nullptr,
                                             execute, complete, data, result);
  }
  napi_status Delete(napi_env argument, napi_async_work work) {
    return adapter ? napi_delete_async_work_primjs(argument, work)
                   : env->napi_delete_async_work(argument, work);
  }
  napi_status Queue(napi_async_work work) {
    return adapter ? napi_queue_async_work_primjs(env, work)
                   : env->napi_queue_async_work(env, work);
  }
  napi_status Cancel(napi_async_work work) {
    return adapter ? napi_cancel_async_work_primjs(env, work)
                   : env->napi_cancel_async_work(env, work);
  }
  void WaitForTask() {
    std::unique_lock<std::mutex> lock(mutex);
    Require(condition.wait_for(lock, std::chrono::seconds(5),
                               [this] { return !tasks.empty(); }));
  }
  void RunTask() {
    WaitForTask();
    std::pair<napi_foreground_cb, void*> task;
    {
      std::lock_guard<std::mutex> lock(mutex);
      task = tasks.front();
      tasks.pop();
    }
    task.first(task.second);
  }
  void ReleaseWorker() {
    std::lock_guard<std::mutex> lock(mutex);
    release_worker = true;
    condition.notify_all();
  }
  napi_env env;
  bool adapter;
  std::mutex mutex;
  std::condition_variable condition;
  std::queue<std::pair<napi_foreground_cb, void*>> tasks;
  bool release_worker = true;

 private:
  LEPUSRuntime* runtime;
  LEPUSContext* context;
};

void InvalidArguments(bool adapter) {
  Data data;
  Environment test(adapter);
  Require(test.Create(nullptr, Execute, Complete, &data, &data.work) ==
          napi_invalid_arg);
  Require(test.Create(test.env, Execute, Complete, &data, nullptr) ==
          napi_invalid_arg);
  Require(test.Queue(nullptr) == napi_invalid_arg);
  Require(test.Cancel(nullptr) == napi_invalid_arg);
  Require(test.Delete(nullptr, nullptr) == napi_invalid_arg);
  Check(test.Delete(test.env, nullptr));
  auto unattached = napi_new_env();
  Require(test.Create(unattached, Execute, Complete, &data, &data.work) ==
          napi_invalid_arg);
  napi_free_env(unattached);
  Check(test.Create(test.env, Execute, Complete, &data, &data.work));
  Require(test.Delete(nullptr, data.work) == napi_invalid_arg);
  Check(test.Delete(test.env, data.work));
  Check(test.Create(test.env, nullptr, nullptr, &data, &data.work));
  Require(test.Queue(data.work) == napi_invalid_arg);
  Check(test.Delete(test.env, data.work));
  test.Close();
}

void WorkLifecycle(bool adapter, bool cancel, bool delete_in_complete) {
  Data data;
  data.adapter = adapter;
  data.delete_in_complete = delete_in_complete;
  Environment test(adapter);
  test.release_worker = !cancel;
  Check(test.Create(test.env, Execute, Complete, &data, &data.work));
  Check(test.Queue(data.work));
  if (cancel) {
    Require(test.Queue(data.work) == napi_generic_failure);
    Check(test.Cancel(data.work));
    test.ReleaseWorker();
  }
  test.RunTask();
  Require(data.executed == (cancel ? 0 : 1));
  Require(data.completed == 1);
  Require(data.status == (cancel ? napi_cancelled : napi_ok));
  test.Close();
  Require(data.completed == 1);
}

void NoComplete(bool adapter, bool queue, bool explicitly_delete) {
  Data data;
  Environment test(adapter);
  Check(test.Create(test.env, Execute, nullptr, &data, &data.work));
  if (queue) {
    Check(test.Queue(data.work));
    test.RunTask();
    Require(data.executed == 1);
  }
  if (explicitly_delete) Check(test.Delete(test.env, data.work));
  test.Close();
  Require(data.completed == 0);
}

void ExitWithPendingDelivery(bool adapter, bool replay) {
  Data data;
  data.adapter = adapter;
  Environment test(adapter);
  Check(test.Create(test.env, Execute, Complete, &data, &data.work));
  Check(test.Queue(data.work));
  test.WaitForTask();
  test.Close();
  Require(data.executed == 1 && data.completed == 1);
  if (replay) test.RunTask();
  Require(data.completed == 1);
}

class LegacyWorker : public Napi::AsyncWorker {
 public:
  LegacyWorker(napi_env env, Data* data)
      : Napi::AsyncWorker(Napi::Env(env)), data(data) {}

 protected:
  void Execute() override { ++data->executed; }
  void OnOK() override { ++data->completed; }

 private:
  Data* data;
};
void LegacyClass() {
  Data data;
  Environment test(false);
  delete new LegacyWorker(test.env, &data);
  auto* worker = new LegacyWorker(test.env, &data);
  worker->Queue();
  test.RunTask();
  Require(data.executed == 1 && data.completed == 1);
  test.Close();
}
}  // namespace

int main() {
  for (bool adapter : {false, true}) {
    InvalidArguments(adapter);
    for (bool cancel : {false, true})
      for (bool delete_in_complete : {false, true})
        WorkLifecycle(adapter, cancel, delete_in_complete);
    for (bool queue : {false, true})
      for (bool explicitly_delete : {false, true})
        NoComplete(adapter, queue, explicitly_delete);
    ExitWithPendingDelivery(adapter, false);
    ExitWithPendingDelivery(adapter, true);
    std::fprintf(stdout, "%s async_work checks and lifecycle: passed\n",
                 adapter ? "adapter" : "legacy");
  }
  LegacyClass();
  std::fprintf(stdout, "legacy C++ AsyncWorker: passed\n");
}
