// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#if !defined(_WIN32)
#ifndef SRC_INSPECTOR_CPUPROFILER_PROFILER_SAMPLING_H_
#define SRC_INSPECTOR_CPUPROFILER_PROFILER_SAMPLING_H_

#include <signal.h>

#include <atomic>
#include <condition_variable>
#include <memory>
#include <mutex>
#include <queue>
#include <thread>
#include <unordered_map>
#include <vector>

struct LEPUSRuntime;
struct LEPUSContext;
namespace primjs {
namespace CpuProfiler {
class ProfileGenerator;
class TickSampleEventRecord;
class CpuSampler;

class Semaphore {
 public:
  explicit Semaphore(int32_t count = 0) : count_(count) {}

  inline void Notify() {
    std::unique_lock<std::mutex> lock(mtx_);
    count_++;
    cv_.notify_one();
  }

  inline void Wait() {
    std::unique_lock<std::mutex> lock(mtx_);

    while (count_ == 0) {
      cv_.wait(lock);
    }
    count_--;
  }

 private:
  std::mutex mtx_;
  std::condition_variable cv_;
  int32_t count_;
};

class SpinLock {
 public:
  SpinLock() = default;
  void lock() {
    while (flag.test_and_set(std::memory_order_acquire)) {
    }
  }

  void unlock() { flag.clear(std::memory_order_release); }

 private:
  std::atomic_flag flag = ATOMIC_FLAG_INIT;
};

class ProfilerSampling {
 public:
  ProfilerSampling(LEPUSContext*, ProfileGenerator*, uint32_t);
  ~ProfilerSampling();

  void Run();

  void StopSynchronously();

  void AddCurrentStack();

  void ProcessOneSample();

  TickSampleEventRecord& GetRecord() { return *record_; }

  LEPUSContext* context() const { return ctx_; }

 private:
  LEPUSContext* ctx_;
  std::shared_ptr<CpuSampler> sampler_{nullptr};
  std::unique_ptr<TickSampleEventRecord> record_{
      std::make_unique<TickSampleEventRecord>()};
  ProfileGenerator* generator_;
  const uint32_t period_;
};

typedef enum {
  UNINITIALIZE,
  SIGNAL_HANDLER_NOT_INSTALL,
  CONTEXT_DESTRUCTED,
  SUCCESS,
} SampleProcessState;

class PlatformData {
 public:
  pthread_t thread_id() const { return thread_id_; }

 private:
  pthread_t thread_id_{pthread_self()};
};

// when the cpuprofiler thread take a sample, the thread send a signal to main
// thread, the main thread get meta info the cpuprofiler needed, and add to
// the samples
class SignalHandler {
 public:
  static SignalHandler& GetInstance() {
    static SignalHandler signal_handler;
    return signal_handler;
  }

  void IncreaseClientCount();
  void DecreaseClientCount();

 private:
  // signal processing function
  static void HandleCpuProfilerSignal(int, siginfo_t*, void*);
  void Install();
  void Restore();
  std::mutex mtx;
  struct sigaction old_signal_handler_;
  int32_t client_count_{0};
  bool signal_handler_installed_{false};
};

class CpuSampler {
 public:
  ~CpuSampler() { Restore(); }
  CpuSampler() { Install(); }

  void SampleStack();
  void RegisterProcessor(LEPUSContext* ctx, ProfilerSampling*);
  void UnRegisterProcessor(LEPUSContext* ctx);
  const PlatformData& platform_data() const { return *data_; }

  void StartSampler() {
    if (running_) return;
    running_ = true;
    sample_thread_ = std::thread(&CpuSampler::RunThread, this);
#if defined(ANDROID) || defined(__ANDROID__)
    pthread_setname_np(sample_thread_.native_handle(), "QJS_Profile_Sampling");
#endif
  }

  void StopSampler() {
    if (!running_) return;
    running_ = false;
    sample_thread_.join();
    return;
  }

  void SetInterval(uint64_t interval) { interval_ = interval; }

 private:
  void Install();
  void Restore();
  void RunThread();
  SampleProcessState DoSample();

  std::unordered_map<LEPUSContext*, ProfilerSampling*> profilers_{};
  SpinLock lock_{};

  std::unique_ptr<PlatformData> data_{std::make_unique<PlatformData>()};
  std::thread sample_thread_;
  uint64_t interval_;
  std::atomic_bool sample_stack_finish_{false};
  std::atomic_bool running_{false};
};

class SamplerManager {
 public:
  static std::shared_ptr<CpuSampler> GetCurrentThreadSampler();
  static void DoSample();
};
}  // namespace CpuProfiler
}  // namespace primjs
#endif
#endif  // SRC_INSPECTOR_CPUPROFILER_PROFILER_SAMPLING_H_
