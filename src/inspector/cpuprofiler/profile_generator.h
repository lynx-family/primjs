// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#if !defined(_WIN32)
#ifndef SRC_INSPECTOR_CPUPROFILER_PROFILE_GENERATOR_H_
#define SRC_INSPECTOR_CPUPROFILER_PROFILE_GENERATOR_H_

#include <iostream>
#include <memory>
#include <string>
#include <utility>
#include <vector>

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif
#include "inspector/cpuprofiler/profile_tree.h"

namespace primjs {
namespace CpuProfiler {

class TickSampleEventRecord;
class CpuProfiler;

uint64_t HashString(const char*);
uint64_t ComputedHashUint64(uint64_t);
struct SampleInfo {
  uint64_t time_stample_;
  uint32_t node_id_;
};

class CpuProfile {
 public:
  CpuProfile(CpuProfiler*, std::string);
  ~CpuProfile() = default;
  void AddPath(const TickSampleEventRecord&);
  void FinishProfile();
  const std::string& title() const { return title_; }
  LEPUSValue GetCpuProfileContent(LEPUSContext*) const&;

  uint64_t start_time() const& { return start_time_; }
  uint64_t end_time() const& { return end_time_; }
  auto& TopDown() const& { return top_down_; }
  auto& SampleInfos() const& { return sample_info_; }

 private:
  std::string title_;
  std::vector<SampleInfo> sample_info_;
  CpuProfiler* profiler_;
  std::unique_ptr<ProfileTree> top_down_;
  LEPUSContext* ctx_{nullptr};
  uint64_t start_time_{0};
  uint64_t end_time_{0};
};

class ProfileGenerator {
 public:
  explicit ProfileGenerator(std::shared_ptr<CpuProfile>&);
  void RecordTickSample(const TickSampleEventRecord&);

 private:
  std::shared_ptr<CpuProfile> profile_;
};

class CpuProfileJSONSerialize {
 public:
  explicit CpuProfileJSONSerialize(const CpuProfile& profile)
      : profile_{profile} {}
  LEPUSValue Serialize(LEPUSContext*);

 private:
  std::vector<const ProfileNode*> FlattenProfileNodes();
  LEPUSValue SerializeNodes(LEPUSContext*);
  LEPUSValue SerializeNode(LEPUSContext*, const ProfileNode&);
  LEPUSValue SerializeCallFrame(LEPUSContext*, const ProfileNode&);
  LEPUSValue SerializeChildren(LEPUSContext*, const ProfileNode&);
  LEPUSValue SerializePositionTicks(LEPUSContext*, const ProfileNode&);
  std::pair<LEPUSValue, LEPUSValue> SerializeSamplesAndDeltas(LEPUSContext*);
  const CpuProfile& profile_;
};

}  // namespace CpuProfiler
}  // namespace primjs
#endif
#endif  // SRC_INSPECTOR_CPUPROFILER_PROFILE_GENERATOR_H_
