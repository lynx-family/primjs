// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#if !defined(_WIN32)
#include "inspector/cpuprofiler/cpu_profiler.h"

#include <assert.h>

#include "inspector/cpuprofiler/profile_generator.h"
#include "inspector/cpuprofiler/profiler_sampling.h"
#include "inspector/interface.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
namespace CpuProfiler {

// CpuProfiler
// set sampling interval
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Profiler/#method-setSamplingInterval
void CpuProfiler::set_sampling_interval(uint32_t value) {
  assert(!is_profiling_);
  sampling_interval_ = value;
}

void CpuProfiler::StartProfiling(const char* title) {
  if (is_profiling_) return;
  ctx_->debugger_info->is_profiling_started = true;
  profile_ = std::make_shared<CpuProfile>(this, title);
  StartProcessorIfNotStarted();
}

LEPUSContext* CpuProfiler::context() const { return ctx_; }
void CpuProfiler::StartProcessorIfNotStarted() {
  if (processor_) {
    processor_->AddCurrentStack();
    return;
  }

  if (!generator_) {
    generator_ = std::make_unique<ProfileGenerator>(profile_);
  }

  processor_ = std::make_unique<ProfilerSampling>(ctx_, generator_.get(),
                                                  sampling_interval_);
  is_profiling_ = true;

  // profiler thread begin to run
  processor_->Run();
}

std::shared_ptr<CpuProfile> CpuProfiler::StopProfiling(
    const std::string& title) {
  ctx_->debugger_info->is_profiling_started = false;
  if (!is_profiling_) return nullptr;
  StopProcessorIfLastProfile(title);
  profile_->FinishProfile();
  return profile_;
}

void CpuProfiler::StopProcessorIfLastProfile(const std::string& title) {
  StopProcessor();
}

void CpuProfiler::StopProcessor() {
  is_profiling_ = false;
  processor_->StopSynchronously();
  processor_.reset();
}

ProfileGenerator* CpuProfiler::Generator() const { return generator_.get(); }
ProfilerSampling* CpuProfiler::Processor() const { return processor_.get(); }
}  // namespace CpuProfiler
}  // namespace primjs
#endif
