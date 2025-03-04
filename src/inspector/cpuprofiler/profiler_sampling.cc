// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#if !defined(_WIN32)
#include "inspector/cpuprofiler/profiler_sampling.h"

#include <algorithm>

#include "inspector/cpuprofiler/cpu_profiler.h"
#include "inspector/cpuprofiler/profile_generator.h"
#include "inspector/cpuprofiler/profiler_time.h"
#include "inspector/cpuprofiler/tracing_cpu_profiler.h"
#include "inspector/debugger/debugger.h"
#include "inspector/interface.h"
#include "quickjs/include/quickjs-inner.h"

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif

#if defined(ANDROID) || defined(__ANDROID__)
#include <android/log.h>
#endif

namespace primjs {
namespace CpuProfiler {

void SignalHandler::Install() {
  struct sigaction sa;
  // register profiler singal function
  sa.sa_sigaction = &HandleCpuProfilerSignal;
  sigemptyset(&sa.sa_mask);
  sa.sa_flags = SA_RESTART | SA_SIGINFO;
  signal_handler_installed_ = !sigaction(SIGPROF, &sa, &old_signal_handler_);
  return;
}

void SignalHandler::Restore() {
  if (signal_handler_installed_) {
    sigaction(SIGPROF, &old_signal_handler_, nullptr);
    signal_handler_installed_ = false;
  }
  return;
}

void SignalHandler::IncreaseClientCount() {
  std::lock_guard<std::mutex> lck{mtx};
  if (++client_count_ == 1) Install();
}

void SignalHandler::DecreaseClientCount() {
  std::lock_guard<std::mutex> lck{mtx};
  if (--client_count_ == 0) Restore();
}

void SignalHandler::HandleCpuProfilerSignal(int signal, siginfo_t* info,
                                            void* context) {
  if (signal != SIGPROF) return;
  SamplerManager::DoSample();
}

// ProfilerSampling
ProfilerSampling::ProfilerSampling(LEPUSContext* ctx,
                                   ProfileGenerator* generator, uint32_t period)
    : ctx_{ctx}, generator_(generator), period_(period) {
  return;
}

ProfilerSampling::~ProfilerSampling() {
  if (sampler_) sampler_->UnRegisterProcessor(ctx_);
}

static JSString* MakeStringPersistent(LEPUSContext* ctx, JSString* str,
                                      GCPersistent& handle) {
  if (ctx->gc_enable) {
    handle.Reset(ctx, LEPUS_MKPTR(LEPUS_TAG_STRING, str));
  } else {
    ++str->header.ref_count;
  }
  return str;
}

static JSString* GetFunctionNameString(LEPUSContext* ctx, LEPUSValue func_obj,
                                       GCPersistent& persistent) {
  // Get function name from closure object.no memory allocations
  // So this function is signal safety.
  auto name = LEPUS_GetProperty(ctx, func_obj, JS_ATOM_name);
  JSString* str = nullptr;
  if (LEPUS_VALUE_IS_STRING(name)) {
    str = LEPUS_VALUE_GET_STRING(name);
    MakeStringPersistent(ctx, str, persistent);
  }
  if (!ctx->gc_enable) {
    LEPUS_FreeValue(ctx, name);
  }
  return str;
}

static void GetRecordInfo(LEPUSContext* ctx, TickSampleEventRecord& record) {
  // function name, url, script id, line_num, col_num
  // tranverse from the top frame
  // running in the js thread.
  record.ctx_ = ctx;
  record.timestamp_ = TimeTicks::Now();
  int32_t level = 0;
  for (auto* sf = ctx->rt->current_stack_frame; sf;
       sf = sf->prev_frame, ++level) {
    auto& cur_data = record.stack_meta_info_[level];
    auto& cur_func = sf->cur_func;
    cur_data.pc_ = sf->cur_pc;
    auto* b = JS_GetFunctionBytecode(cur_func);
    if (b && b->has_debug) {
      cur_data.line_ = b->debug.line_num - 1;
      cur_data.col_ = b->debug.column_num;
      // for js and lepus
      cur_data.script_ = b->script;
      cur_data.file_name_ =
          b->debug.file_name ? MakeStringPersistent(ctx, b->debug.file_name,
                                                    cur_data.file_name_handle_)
                             : nullptr;
      if (b->debug.func_name) {
        /* Fast path to get function's name */
        cur_data.func_name_ = MakeStringPersistent(ctx, b->debug.func_name,
                                                   cur_data.func_name_handle_);
      } else {
        cur_data.func_name_ =
            GetFunctionNameString(ctx, cur_func, cur_data.func_name_handle_);
      }
    } else {
      // may be c function.
      cur_data.line_ = -1;
      cur_data.col_ = -1;
      cur_data.script_ = nullptr;
      cur_data.file_name_ = nullptr;
      cur_data.func_name_ =
          GetFunctionNameString(ctx, cur_func, cur_data.file_name_handle_);
    }

    if (level == TickSampleEventRecord::kMaxFramesCount - 1) {
      printf("QJS CPU PROFILER: FUNCTINON FRAME SIZE IS OVER 255\n");
      break;
    }
  }

  record.frames_count_ = level;
  return;
}

// get info needed by cpuprofiler thread
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#type-CallFrame
void ProfilerSampling::AddCurrentStack() {
  GetRecordInfo(ctx_, *record_);
  ProcessOneSample();
  return;
}

void ProfilerSampling::Run() {
  if (sampler_) return;
  sampler_ = SamplerManager::GetCurrentThreadSampler();
  sampler_->SetInterval(period_);
  sampler_->RegisterProcessor(ctx_, this);
  return;
}

void ProfilerSampling::StopSynchronously() {
  if (!sampler_) return;
  sampler_->UnRegisterProcessor(ctx_);
  return;
}

void ProfilerSampling::ProcessOneSample() {
  if (generator_ && record_->ctx_) {
    generator_->RecordTickSample(*record_);
  }
}

SampleProcessState CpuSampler::DoSample() {
  // send signal to target thread
  sample_stack_finish_.store(false, std::memory_order_relaxed);
  pthread_kill(platform_data().thread_id(), SIGPROF);

  return SUCCESS;
}

// CpuSampler

void CpuSampler::Install() {
  SignalHandler::GetInstance().IncreaseClientCount();
  return;
}

void CpuSampler::Restore() {
  SignalHandler::GetInstance().DecreaseClientCount();
  return;
}

void CpuSampler::RegisterProcessor(LEPUSContext* ctx,
                                   ProfilerSampling* processor) {
  {
    // running in the js thread.
    std::lock_guard<SpinLock> lck{lock_};
    profilers_.try_emplace(ctx, processor);
  }
  if (profilers_.size() == 1) {
    StartSampler();
  }
  return;
}

void CpuSampler::UnRegisterProcessor(LEPUSContext* ctx) {
  // running in the js thread.
  {
    std::lock_guard<SpinLock> lck{lock_};
    if (auto iter = profilers_.find(ctx); iter != profilers_.end()) {
      profilers_.erase(iter);
    }
  }
  if (profilers_.size() == 0) {
    StopSampler();
  }
  return;
}

void CpuSampler::RunThread() {
  // sampler thread begin to run
  uint64_t nextSampleTime = 0;
  while (true) {
    while (TimeTicks::Now() < nextSampleTime) {
    }
    nextSampleTime = TimeTicks::Now() + interval_;
    DoSample();
    // wait Js thread sample stack finished.
    while (!sample_stack_finish_.load(std::memory_order_acquire) &&
           running_.load(std::memory_order_relaxed)) {
    }
    if (!running_.load(std::memory_order_relaxed)) break;
    {
      // running in the sampler thread, the js thread may insert/erase profile,
      // so lock.
      std::lock_guard<SpinLock> lck{lock_};
      for (auto& [ctx, profiler] : profilers_) {
        // copy the record
        profiler->ProcessOneSample();
      }
    }
  }
}

void CpuSampler::SampleStack() {
  // running in js thread
  for (const auto [ctx, profiler] : profilers_) {
    GetRecordInfo(ctx, profiler->GetRecord());
  }
  sample_stack_finish_.store(true, std::memory_order_release);
  return;
}

// SamplerManager
std::shared_ptr<CpuSampler> SamplerManager::GetCurrentThreadSampler() {
  thread_local std::shared_ptr<CpuSampler> sampler{
      std::make_shared<CpuSampler>()};
  return sampler;
}

void SamplerManager::DoSample() {
  GetCurrentThreadSampler()->SampleStack();
  return;
}

}  // namespace CpuProfiler
}  // namespace primjs
#endif
