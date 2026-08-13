// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <gtest/gtest.h>

#include <chrono>
#include <condition_variable>
#include <memory>
#include <mutex>
#include <queue>
#include <thread>
#include <vector>

extern "C" {
#include "quickjs/include/quickjs.h"
}

#include "napi/env/napi_env.h"
#include "napi/env/napi_runtime.h"
#include "napi/quickjs/napi_env_quickjs.h"

namespace {

constexpr auto kAsyncWorkTimeout = std::chrono::seconds(5);

struct AsyncWorkData {
  std::mutex mutex;
  std::condition_variable condition;
  napi_async_work work = nullptr;
  napi_status completion_status = napi_generic_failure;
  std::thread::id execute_thread;
  bool block_execute = false;
  bool execute_started = false;
  bool release_execute = false;
  bool completed = false;
};

void ExecuteAsyncWork(napi_env env, void* data) {
  auto* work_data = static_cast<AsyncWorkData*>(data);
  std::unique_lock<std::mutex> lock(work_data->mutex);
  work_data->execute_thread = std::this_thread::get_id();
  work_data->execute_started = true;
  work_data->condition.notify_all();
  if (work_data->block_execute) {
    work_data->condition.wait_for(lock, kAsyncWorkTimeout, [work_data] {
      return work_data->release_execute;
    });
  }
}

void CompleteAsyncWork(napi_env env, napi_status status, void* data) {
  auto* work_data = static_cast<AsyncWorkData*>(data);
  {
    std::lock_guard<std::mutex> lock(work_data->mutex);
    work_data->completion_status = status;
    work_data->completed = true;
  }
  work_data->condition.notify_all();
  EXPECT_EQ(env->napi_delete_async_work(env, work_data->work), napi_ok);
  work_data->work = nullptr;
}

class NAPIAsyncWorkTest : public ::testing::Test {
 public:
  NAPIAsyncWorkTest()
      : env_(napi_new_env()),
        runtime_(LEPUS_NewRuntime()),
        context_(LEPUS_NewContext(runtime_)) {
    napi_runtime_configuration configuration =
        napi_create_runtime_configuration();
    napi_runtime_config_foreground_handler(
        configuration,
        [](napi_foreground_cb callback, void* data, void* context) {
          auto* test = static_cast<NAPIAsyncWorkTest*>(context);
          {
            std::lock_guard<std::mutex> lock(test->foreground_mutex_);
            test->foreground_tasks_.push({callback, data});
          }
          test->foreground_condition_.notify_all();
        },
        this);
    napi_attach_runtime_with_configuration(env_, configuration);
    napi_delete_runtime_configuration(configuration);
    napi_attach_quickjs(env_, context_);
  }

  ~NAPIAsyncWorkTest() override {
    napi_detach_runtime(env_);
    napi_detach_quickjs(env_);
    napi_free_env(env_);
    LEPUS_FreeContext(context_);
    LEPUS_FreeRuntime(runtime_);
  }

 protected:
  AsyncWorkData* CreateAndQueueWork(bool block_execute = false) {
    work_data_.push_back(std::make_unique<AsyncWorkData>());
    AsyncWorkData* data = work_data_.back().get();
    data->block_execute = block_execute;
    napi_status status =
        env_->napi_create_async_work(env_, nullptr, nullptr, ExecuteAsyncWork,
                                     CompleteAsyncWork, data, &data->work);
    EXPECT_EQ(status, napi_ok);
    if (status == napi_ok) {
      EXPECT_EQ(env_->napi_queue_async_work(env_, data->work), napi_ok);
    }
    return data;
  }

  bool WaitForExecute(AsyncWorkData* data) {
    std::unique_lock<std::mutex> lock(data->mutex);
    return data->condition.wait_for(lock, kAsyncWorkTimeout,
                                    [data] { return data->execute_started; });
  }

  void ReleaseExecute(AsyncWorkData* data) {
    {
      std::lock_guard<std::mutex> lock(data->mutex);
      data->release_execute = true;
    }
    data->condition.notify_all();
  }

  bool WaitForForegroundTaskCount(size_t count) {
    std::unique_lock<std::mutex> lock(foreground_mutex_);
    return foreground_condition_.wait_for(
        lock, kAsyncWorkTimeout,
        [this, count] { return foreground_tasks_.size() >= count; });
  }

  bool RunNextForegroundTask() {
    ForegroundTask task;
    {
      std::lock_guard<std::mutex> lock(foreground_mutex_);
      if (foreground_tasks_.empty()) {
        return false;
      }
      task = foreground_tasks_.front();
      foreground_tasks_.pop();
    }
    task.callback(task.data);
    return true;
  }

  napi_env env_;

 private:
  struct ForegroundTask {
    napi_foreground_cb callback = nullptr;
    void* data = nullptr;
  };

  LEPUSRuntime* runtime_;
  LEPUSContext* context_;
  std::mutex foreground_mutex_;
  std::condition_variable foreground_condition_;
  std::queue<ForegroundTask> foreground_tasks_;
  std::vector<std::unique_ptr<AsyncWorkData>> work_data_;
};

TEST_F(NAPIAsyncWorkTest, ExecutesAndCancelsOnlyQueuedWork) {
  const std::thread::id js_thread = std::this_thread::get_id();
  AsyncWorkData* running_work = CreateAndQueueWork(true);
  ASSERT_TRUE(WaitForExecute(running_work));

  AsyncWorkData* queued_work = CreateAndQueueWork();
  AsyncWorkData* completed_work = CreateAndQueueWork();

  EXPECT_EQ(env_->napi_cancel_async_work(env_, running_work->work),
            napi_generic_failure);
  EXPECT_EQ(env_->napi_cancel_async_work(env_, queued_work->work), napi_ok);
  EXPECT_EQ(env_->napi_cancel_async_work(env_, queued_work->work),
            napi_generic_failure);

  ReleaseExecute(running_work);
  ASSERT_TRUE(WaitForForegroundTaskCount(3));
  EXPECT_EQ(env_->napi_cancel_async_work(env_, completed_work->work),
            napi_generic_failure);

  ASSERT_TRUE(RunNextForegroundTask());
  ASSERT_TRUE(RunNextForegroundTask());
  ASSERT_TRUE(RunNextForegroundTask());

  EXPECT_TRUE(running_work->execute_started);
  EXPECT_NE(running_work->execute_thread, js_thread);
  EXPECT_TRUE(running_work->completed);
  EXPECT_EQ(running_work->completion_status, napi_ok);
  EXPECT_FALSE(queued_work->execute_started);
  EXPECT_TRUE(queued_work->completed);
  EXPECT_EQ(queued_work->completion_status, napi_cancelled);
  EXPECT_TRUE(completed_work->execute_started);
  EXPECT_NE(completed_work->execute_thread, js_thread);
  EXPECT_TRUE(completed_work->completed);
  EXPECT_EQ(completed_work->completion_status, napi_ok);
}

}  // namespace
