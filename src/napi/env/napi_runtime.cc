/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "napi_runtime.h"

#if !defined(OS_WIN)
#include <pthread.h>
#endif

#include <cassert>
#include <cstdlib>
#include <future>
#include <memory>
#include <mutex>
#include <queue>
#include <string>
#include <unordered_set>
#include <utility>

#include "napi.h"
#include "napi/common/napi_state.h"

#ifdef ENABLE_CODECACHE
#include "napi/common/code_cache.h"
#endif  // ENABLE_CODECACHE
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif
namespace {
class WorkerThread {
 public:
  using Task = std::function<void()>;

  WorkerThread(napi_worker_lifecycle_callback on_worker_start,
               napi_worker_lifecycle_callback on_worker_stop,
               napi_worker_task_handler task_handler, void* worker_ctx,
               size_t stack_size)
      : stopped_(false),
        on_worker_start_(on_worker_start),
        on_worker_stop_(on_worker_stop),
        task_handler_(task_handler),
        worker_ctx_(worker_ctx) {
#if !defined(OS_WIN)
#if WIN32
    thread_.p = nullptr;
    thread_.x = 0;
#else
    thread_ = (pthread_t)((unsigned long long)0);
#endif
    pthread_attr_t thread_attr;
    pthread_attr_init(&thread_attr);

    if (stack_size) {
      pthread_attr_setstacksize(&thread_attr, stack_size);
    }

    int ret = pthread_create(
        &thread_, &thread_attr,
        [](void* data) -> void* {
          static_cast<WorkerThread*>(data)->Run();
          return nullptr;
        },
        this);
    (void)ret;
    assert(ret == 0);

    pthread_attr_destroy(&thread_attr);
#endif
  }

  ~WorkerThread() { Stop(); }

  void Stop() {
#if !defined(OS_WIN)
#if WIN32
    if (nullptr != thread_.p) {
#else
    if ((pthread_t)((unsigned long long)0) != thread_) {
#endif
      {
        std::lock_guard<std::mutex> lock(mutex_);
        stopped_ = true;
        cond_.notify_one();
      }
      ::pthread_join(thread_, nullptr);
#if WIN32
      thread_.p = nullptr;
      thread_.x = 0;
#else
      thread_ = (pthread_t)((unsigned long long)0);
#endif
    }
#endif
  }

  void PostTask(Task task) {
    std::lock_guard<std::mutex> lock(mutex_);
    bool empty = queue_.empty();
    queue_.push(std::move(task));
    if (empty) {
      cond_.notify_one();
    }
  }

 private:
  void Run() {
    if (on_worker_start_) {
      on_worker_start_(worker_ctx_);
    }
    while (true) {
      Task task;
      {
        std::unique_lock<std::mutex> lock(mutex_);
        cond_.wait(lock, [this] { return !queue_.empty() || stopped_; });
        if (stopped_) {
          break;
        }
        task = std::move(queue_.front());
        queue_.pop();
      }
      if (task_handler_) {
        task_handler_([](void* task) { (*reinterpret_cast<Task*>(task))(); },
                      &task, worker_ctx_);
      } else {
        task();
      }
    }
    if (on_worker_stop_) {
      on_worker_stop_(worker_ctx_);
    }
  }

#if !defined(OS_WIN)
  pthread_t thread_;
#endif
  std::mutex mutex_;
  std::condition_variable cond_;
  std::queue<Task> queue_;
  bool stopped_;

  napi_worker_lifecycle_callback on_worker_start_;
  napi_worker_lifecycle_callback on_worker_stop_;
  napi_worker_task_handler task_handler_;
  void* worker_ctx_;
};

class AutoCloseable {
 public:
  explicit AutoCloseable(napi_runtime rt);

  virtual ~AutoCloseable();

  virtual void onClose() { delete this; }

 protected:
  napi_runtime rt_;
};
}  // namespace

struct napi_runtime_configuration__ {
  napi_foreground_handler task_handler{};
  void* task_ctx{};

  napi_uncaught_exception_handler uncaught_handler{};
  void* uncaught_ctx{};

  napi_worker_lifecycle_callback on_worker_start{};
  napi_worker_lifecycle_callback on_worker_stop{};
  napi_worker_task_handler worker_task_handler{};
  void* worker_ctx{};

  size_t worker_stack_size = 0;  //
};

struct napi_runtime__ {
  napi_runtime__(napi_env env, napi_runtime_configuration conf)
      : env_(env), conf_(*conf) {}

  ~napi_runtime__() {
    if (worker_) {
      // must stop worker first to prevent data racing
      worker_->Stop();
    }

    while (!closeables_.empty()) {
      auto it = closeables_.begin();
      AutoCloseable* p = *it;
      p->onClose();
    }
  }

  napi_env Env() { return env_; }

  void RegisterCloseable(AutoCloseable* closeable) {
    closeables_.insert(closeable);
  }

  void RemoveCloseable(AutoCloseable* closeable) {
    closeables_.erase(closeable);
  }

  template <typename Cb>
  void CallIntoModule(Cb cb) {
    Napi::Env env(env_);
    Napi::HandleScope hscope(env_);
    Napi::ContextScope cscope(env_);
    Napi::ErrorScope escope(env_);
    cb(env);
  }

  void ReportUncaught(napi_value exc) {
    conf_.uncaught_handler(env_, exc, conf_.uncaught_ctx);
  }

  template <typename T>
  using JSCallback = void (*)(T*);

  // no way to destruct js task certainly, so we use pointers
  template <typename T>
  void PostJSTask(T* data, JSCallback<T> callback) {
    assert(conf_.task_handler);
    conf_.task_handler(reinterpret_cast<JSCallback<void>>(callback), data,
                       conf_.task_ctx);
  }

  // called in JS thread only
  void PostWorkerTask(WorkerThread::Task task) {
    if (!worker_) {
      // lazy create worker thread
      worker_ = std::make_unique<WorkerThread>(
          conf_.on_worker_start, conf_.on_worker_stop,
          conf_.worker_task_handler, conf_.worker_ctx, conf_.worker_stack_size);
    }
    worker_->PostTask(std::move(task));
  }

#ifdef ENABLE_CODECACHE
  bool StoreCodeCache(const std::string& filename, const uint8_t* data,
                      int length) {
    if (blob_ != nullptr) {
      return blob_->insert(filename, data, length);
    }
    return false;
  }

  void GetCodeCache(const std::string& filename, const uint8_t** data,
                    int* length) {
    if (blob_ == nullptr) return;
    const CachedData* dt = blob_->find(filename, length);
    if (dt != nullptr) {
      *data = dt->data_;
    }
  }

  void WriteCache() {
    if (blob_ != nullptr) {
      blob_->output();
    }
  }

  bool ReadCache() {
    if (blob_ != nullptr) {
      return blob_->input();
    }
    return false;
  }

  void InitCacheBlob(const std::string& cache_path, int max_cap) {
    blob_ = std::make_unique<CacheBlob>(cache_path, max_cap);
  }

#ifdef PROFILE_CODECACHE
  void DumpCacheStatus(void* dump_vec) {
    if (blob_ != nullptr) blob_->dump_status(dump_vec);
  }
#endif  // PROFILE_CODECACHE
#endif  // ENABLE_CODECACHE

 private:
#ifdef ENABLE_CODECACHE
  std::unique_ptr<CacheBlob> blob_;
#endif  // ENABLE_CODECACHE
  std::unique_ptr<WorkerThread> worker_;
  napi_env env_;

  napi_runtime_configuration__ conf_{};
  std::unordered_set<AutoCloseable*> closeables_;
};

namespace {
AutoCloseable::AutoCloseable(napi_runtime rt) : rt_(rt) {
  rt_->RegisterCloseable(this);
}

AutoCloseable::~AutoCloseable() { rt_->RemoveCloseable(this); }
}  // namespace

namespace {
class Work : AutoCloseable {
 public:
  void onClose() override {
    // no need to lock, since the worker thread is stopped
    Complete(this);
  }

  static Work* New(napi_runtime rt, napi_async_execute_callback execute,
                   napi_async_complete_callback complete, void* data) {
    return new Work(rt, execute, complete, data);
  }

  static void Delete(Work* w) { delete w; }

  void ScheduleWork() {
    rt_->PostWorkerTask([this] {
      if (!canceled_) {
        execute_(rt_->Env(), data_);
        finished_ = true;
      }
      rt_->PostJSTask<Work>(this, Complete);
    });
  }

  bool CancelWork() {
    bool already_cancelled = canceled_.exchange(true);
    return already_cancelled;
  }

 private:
  Work(napi_runtime rt, napi_async_execute_callback execute,
       napi_async_complete_callback complete, void* data)
      : AutoCloseable(rt),
        execute_(execute),
        complete_(complete),
        data_(data) {}

  ~Work() override = default;

  static void Complete(Work* work) {
    work->rt_->CallIntoModule([&](Napi::Env env) {
      work->complete_(env, work->finished_ ? napi_ok : napi_cancelled,
                      work->data_);  // deleted during complete
    });
  }

  napi_async_execute_callback execute_;
  napi_async_complete_callback complete_;
  void* data_;
  bool finished_{false};
  std::atomic_bool canceled_{false};
};

napi_status napi_create_async_work(napi_env env, napi_value async_resource,
                                   napi_value async_resource_name,
                                   napi_async_execute_callback execute,
                                   napi_async_complete_callback complete,
                                   void* data, napi_async_work* result) {
  *result = reinterpret_cast<napi_async_work>(
      Work::New(env->rt, execute, complete, data));
  return napi_clear_last_error(env);
}

napi_status napi_delete_async_work(napi_env env, napi_async_work work) {
  Work::Delete(reinterpret_cast<Work*>(work));

  return napi_clear_last_error(env);
}

napi_status napi_queue_async_work(napi_env env, napi_async_work work) {
  Work* w = reinterpret_cast<Work*>(work);

  w->ScheduleWork();

  return napi_clear_last_error(env);
}

napi_status napi_cancel_async_work(napi_env env, napi_async_work work) {
  Work* w = reinterpret_cast<Work*>(work);

  if (!w->CancelWork()) {
    return napi_set_last_error(env, napi_cancelled);
  }

  return napi_clear_last_error(env);
}

namespace {
struct PendingTask {
  std::unique_ptr<std::promise<void>> blocking_promise;
  void* data;

  PendingTask() : blocking_promise(), data(nullptr) {}

  PendingTask(std::unique_ptr<std::promise<void>> blocking_promise, void* data)
      : blocking_promise(std::move(blocking_promise)), data(data) {}

  PendingTask& operator=(PendingTask&& other) {
    blocking_promise = std::move(other.blocking_promise);
    data = other.data;
    return *this;
  }
};

// Rust is better
template <typename T>
class MutexGuard {
 public:
  T* operator->() { return &val_; }

  MutexGuard(T& val, std::recursive_mutex& mutex) : val_(val), mutex_(mutex) {
    mutex_.lock();
  }

  ~MutexGuard() { mutex_.unlock(); }

 private:
  T& val_;
  std::recursive_mutex& mutex_;
};

template <typename T>
class Mutex {
 public:
  template <typename... Args>
  explicit Mutex(Args&&... args) : val_(std::forward(args)...) {}

  MutexGuard<T> Lock() { return MutexGuard<T>(val_, mutex_); }

 private:
  T val_;

  // tsfn may be called in JS thread, a recursive
  // mutex is necessary to prevent dead lock
  std::recursive_mutex mutex_;
};

class ThreadSafeJSRunner;

struct SharedState {
  std::queue<PendingTask> queue;
  ThreadSafeJSRunner* runner = nullptr;
};

// JS thread only
class ThreadSafeJSRunner : public AutoCloseable {
 public:
  ThreadSafeJSRunner(napi_runtime rt, napi_finalize finalize,
                     void* finalize_data,
                     napi_threadsafe_function_call_js call_js, void* context,
                     std::shared_ptr<Mutex<SharedState>> state)
      : AutoCloseable(rt),
        thread_finalize_cb_(finalize),
        thread_finalize_data_(finalize_data),
        call_js_cb_(call_js),
        context_(context),
        state_(std::move(state)) {}

  void DispatchWork() {
    rt_->PostJSTask<ThreadSafeJSRunner>(
        this, [](ThreadSafeJSRunner* self) { self->DoWork(); });
  }

  void DispatchClose() {
    // only called once when delete ThreadSafeFunction
    rt_->PostJSTask<ThreadSafeJSRunner>(
        this, [](ThreadSafeJSRunner* self) { self->Finalize(); });
  }

 protected:
  void onClose() override { Finalize(); }

 private:
  void DoWork() {
    std::queue<PendingTask> tasks;

    {
      auto state = state_->Lock();
      tasks = std::move(state->queue);
    }

    while (!tasks.empty()) {
      DoTask(tasks.front(), context_);
      tasks.pop();
    }
  }

  // only in JS thread
  void DoTask(PendingTask& task, void* context) {
    rt_->CallIntoModule(
        [&](Napi::Env env) { call_js_cb_(env, context_, task.data); });

    if (task.blocking_promise) {
      task.blocking_promise->set_value();
    }
  }

  void Finalize() {
    std::queue<PendingTask> tasks;

    {
      auto state = state_->Lock();
      state->runner = nullptr;
      tasks = std::move(state->queue);
    }

    while (!tasks.empty()) {
      DoTask(tasks.front(), context_);
      tasks.pop();
    }

    if (thread_finalize_cb_) {
      rt_->CallIntoModule([&](Napi::Env env) {
        thread_finalize_cb_(env, thread_finalize_data_, context_);
      });
    }

    delete this;
  }

  ~ThreadSafeJSRunner() override = default;

  napi_finalize thread_finalize_cb_;
  void* thread_finalize_data_;
  napi_threadsafe_function_call_js call_js_cb_;
  void* context_;
  std::shared_ptr<Mutex<SharedState>> state_;
};

}  // namespace

class ThreadSafeFunction {
 public:
  ThreadSafeFunction(napi_runtime rt, void* context, napi_finalize finalize,
                     void* finalize_data,
                     napi_threadsafe_function_call_js call_js)
      : context_(context), state_(std::make_shared<Mutex<SharedState>>()) {
    state_->Lock()->runner = new ThreadSafeJSRunner(rt, finalize, finalize_data,
                                                    call_js, context, state_);
  }

  // can be called in any thread
  inline void* Context() const { return context_; }

  // can be called in any thread
  napi_status Call(void* data, napi_threadsafe_function_call_mode mode) {
    std::future<void> f;

    {
      auto state = state_->Lock();

      if (state->runner == nullptr) {
        return napi_closing;
      }

      std::unique_ptr<std::promise<void>> blocking_promise;
      if (mode == napi_tsfn_blocking) {
        blocking_promise = std::make_unique<std::promise<void>>();
        f = blocking_promise->get_future();
      }
      state->queue.emplace(std::move(blocking_promise), data);
      if (state->queue.size() == 1) {
        state->runner->DispatchWork();
      }
    }

    if (mode == napi_tsfn_blocking) {
      f.wait();
    }

    return napi_ok;
  }

  static void Delete(ThreadSafeFunction* fun) {
    {
      auto state = fun->state_->Lock();
      if (state->runner) {
        state->runner->DispatchClose();
        state->runner = nullptr;
      }
    }
    delete fun;
  }

 private:
  void* context_;
  std::shared_ptr<Mutex<SharedState>> state_;
};

napi_status napi_create_threadsafe_function(
    napi_env env, void* thread_finalize_data, napi_finalize thread_finalize_cb,
    void* context, napi_threadsafe_function_call_js call_js_cb,
    napi_threadsafe_function* result) {
  ThreadSafeFunction* tsfn = new ThreadSafeFunction(
      env->rt, context, thread_finalize_cb, thread_finalize_data, call_js_cb);

  *result = reinterpret_cast<napi_threadsafe_function>(tsfn);

  return napi_clear_last_error(env);
}

napi_status napi_get_threadsafe_function_context(napi_threadsafe_function func,
                                                 void** result) {
  *result = reinterpret_cast<ThreadSafeFunction*>(func)->Context();
  return napi_ok;
}

napi_status napi_call_threadsafe_function(
    napi_threadsafe_function func, void* data,
    napi_threadsafe_function_call_mode is_blocking) {
  return reinterpret_cast<ThreadSafeFunction*>(func)->Call(data, is_blocking);
}

napi_status napi_delete_threadsafe_function(napi_threadsafe_function func) {
  ThreadSafeFunction::Delete(reinterpret_cast<ThreadSafeFunction*>(func));
  return napi_ok;
}

class ErrorScope {
 public:
  explicit ErrorScope(napi_env env) : env_(env) {}

  ~ErrorScope() {
    Napi::Env env(env_);
    if (env.IsExceptionPending()) {
      Napi::Value error = env.GetAndClearPendingException();
      env_->rt->ReportUncaught(error);
    }
  }

  NAPI_DISALLOW_ASSIGN_COPY(ErrorScope)

 private:
  napi_env env_;
};

napi_status napi_open_error_scope(napi_env env, napi_error_scope* result) {
  *result = reinterpret_cast<napi_error_scope>(new ErrorScope(env));
  return napi_ok;
}

napi_status napi_close_error_scope(napi_env env, napi_error_scope scope) {
  delete reinterpret_cast<ErrorScope*>(scope);
  return napi_ok;
}

#ifdef ENABLE_CODECACHE
napi_status napi_post_worker_task(napi_env env, std::function<void()> task) {
  env->rt->PostWorkerTask(std::move(task));
  return napi_ok;
}

napi_status napi_store_code_cache(napi_env env, const std::string& filename,
                                  const uint8_t* data, int length) {
  uint8_t* buf = new uint8_t[length];
  memcpy(buf, data, length);
  env->rt->PostWorkerTask([=] {
    if (!env->rt->StoreCodeCache(filename, buf, length)) {
      // If store failed, delete this data.
      delete[] buf;
    }
  });
  return napi_ok;
}

napi_status napi_get_code_cache(napi_env env, const std::string& filename,
                                const uint8_t** data, int* length) {
  env->rt->GetCodeCache(filename, data, length);
  return napi_ok;
}

napi_status napi_init_code_cache(napi_env env, int capacity,
                                 const std::string& cache_file,
                                 std::function<void(bool)> callback) {
  // directy post to worker thread
  env->rt->InitCacheBlob(cache_file, capacity);
  env->rt->PostWorkerTask([env, callback] {
    LOG_TIME_START();
    callback(env->rt->ReadCache());
    LOG_TIME_END("----- ReadCache time consumption -----");
  });
  return napi_ok;
}

napi_status napi_output_code_cache(napi_env env, unsigned int place_holder) {
  // Considering that with very very small possibility that this task be
  // completed if it's posted to napi's worker thread, A synchonous file
  // operation is performed.
  LOG_TIME_START();
  env->rt->WriteCache();
  LOG_TIME_END("----- WriteCache time consumption -----");
  return napi_ok;
}

napi_status napi_dump_code_cache_status(napi_env env, void* dump_vec) {
#ifdef PROFILE_CODECACHE
  env->rt->DumpCacheStatus(dump_vec);
#endif  // PROFILE_CODECACHE
  return napi_ok;
}
#endif  // ENABLE_CODECACHE

}  // namespace

napi_runtime_configuration napi_create_runtime_configuration() {
  return new napi_runtime_configuration__{};
}

void napi_delete_runtime_configuration(napi_runtime_configuration conf) {
  delete conf;
}

void napi_runtime_config_foreground_handler(
    napi_runtime_configuration configuration,
    napi_foreground_handler task_handler, void* task_ctx) {
  configuration->task_handler = task_handler;
  configuration->task_ctx = task_ctx;
}

void napi_runtime_config_uncaught_handler(
    napi_runtime_configuration configuration,
    napi_uncaught_exception_handler task_handler, void* uncaught_ctx) {
  configuration->uncaught_handler = task_handler;
  configuration->uncaught_ctx = uncaught_ctx;
}

void napi_runtime_config_worker_handler(
    napi_runtime_configuration configuration,
    napi_worker_lifecycle_callback on_worker_start,
    napi_worker_lifecycle_callback on_worker_stop,
    napi_worker_task_handler worker_task_handler, void* worker_ctx) {
  configuration->on_worker_start = on_worker_start;
  configuration->on_worker_stop = on_worker_stop;
  configuration->worker_task_handler = worker_task_handler;
  configuration->worker_ctx = worker_ctx;
}

void napi_runtime_config_worker_stack_size(
    napi_runtime_configuration configuration, size_t stack_size) {
  configuration->worker_stack_size = stack_size;
}

void napi_attach_runtime_with_configuration(
    napi_env env, napi_runtime_configuration configuration) {
  env->rt = new napi_runtime__(env, configuration);

#define SET_METHOD(API) env->napi_##API = napi_##API;

  FOR_EACH_NAPI_RUNTIME_CALL(SET_METHOD)

#undef SET_METHOD
}

void napi_attach_runtime(napi_env env, napi_foreground_handler task_handler,
                         void* task_ctx,
                         napi_uncaught_exception_handler uncaught_handler,
                         void* uncaught_ctx) {
  napi_runtime_configuration__ conf{};
  conf.task_handler = task_handler;
  conf.task_ctx = task_ctx;
  conf.uncaught_handler = uncaught_handler;
  conf.uncaught_ctx = uncaught_ctx;
  napi_attach_runtime_with_configuration(env, &conf);
}

void napi_detach_runtime(napi_env env) {
  delete env->rt;
  env->rt = nullptr;
}
