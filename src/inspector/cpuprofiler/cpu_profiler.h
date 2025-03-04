// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#if !defined(_WIN32)
#ifndef SRC_INSPECTOR_CPUPROFILER_CPU_PROFILER_H_
#define SRC_INSPECTOR_CPUPROFILER_CPU_PROFILER_H_

#include <condition_variable>
#include <memory>
#include <mutex>
#include <string>
#include <thread>

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif
#include "inspector/cpuprofiler/profile_generator.h"
#include "inspector/cpuprofiler/profiler_sampling.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
namespace CpuProfiler {

class ProfilerSampling;
class CpuSampler;
class SamplerManager;
class CpuProfile;
class ProfileGenerator;

typedef struct CpuProfileMetaInfo {
  explicit CpuProfileMetaInfo() = default;
  CpuProfileMetaInfo(CpuProfileMetaInfo& right)
      : pc_{right.pc_},
        script_{right.script_},
        func_name_{right.func_name_},
        file_name_{right.file_name_},
        line_{right.line_},
        col_{right.col_} {}

  const uint8_t* pc_ = nullptr;
  LEPUSScriptSource* script_ = nullptr;
  JSString* func_name_{nullptr};
  JSString* file_name_{nullptr};
  GCPersistent func_name_handle_{};
  GCPersistent file_name_handle_{};
  int32_t line_ = 0;
  int32_t col_ = 0;
} CpuProfileMetaInfo;

class TickSampleEventRecord {
 public:
  static const unsigned kMaxFramesCountLog2 = 8;
  static const unsigned kMaxFramesCount = (1 << kMaxFramesCountLog2) - 1;
  CpuProfileMetaInfo stack_meta_info_[kMaxFramesCount];
  LEPUSContext* ctx_;
  uint64_t timestamp_{0};
  int32_t frames_count_{0};
};

class CpuProfiler {
 public:
  explicit CpuProfiler(LEPUSContext* ctx) : ctx_{ctx} {}
  ~CpuProfiler() = default;

  void set_sampling_interval(uint32_t);
  void StartProfiling(const char*);
  std::shared_ptr<CpuProfile> StopProfiling(const std::string&);

  ProfileGenerator* Generator() const;
  ProfilerSampling* Processor() const;
  LEPUSContext* context() const;
  auto& IsProfiling() const { return is_profiling_; }

 private:
  void StartProcessorIfNotStarted();
  void StopProcessorIfLastProfile(const std::string&);
  void StopProcessor();

  LEPUSContext* ctx_{nullptr};
  std::unique_ptr<ProfileGenerator> generator_;
  std::unique_ptr<ProfilerSampling> processor_;
  std::shared_ptr<CpuProfile> profile_;
  uint32_t sampling_interval_{100};
  bool is_profiling_{false};
};
}  // namespace CpuProfiler
}  // namespace primjs
#endif
#endif  // SRC_INSPECTOR_CPUPROFILER_CPU_PROFILER_H_
