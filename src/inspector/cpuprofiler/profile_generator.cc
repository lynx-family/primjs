// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#if !defined(_WIN32)
#include "inspector/cpuprofiler/profile_generator.h"

#include <assert.h>

#include <functional>
#include <memory>

#include "gc/trace-gc.h"
#include "inspector/cpuprofiler/cpu_profiler.h"
#include "inspector/cpuprofiler/profile_tree.h"
#include "inspector/cpuprofiler/profiler_time.h"
#include "inspector/cpuprofiler/tracing_cpu_profiler.h"
#include "inspector/debugger/debugger.h"
#include "inspector/interface.h"

namespace primjs {
namespace CpuProfiler {

// Thomas Wang, Integer Hash Functions.
// http://www.concentric.net/~Ttwang/tech/inthash.htm`
uint64_t ComputedHashUint64(uint64_t u) {
  uint64_t v = u * 3935559000370003845 + 2691343689449507681;
  v ^= v >> 21;
  v ^= v << 37;
  v ^= v >> 4;
  v *= 4768777513237032717;
  v ^= v << 20;
  v ^= v >> 41;
  v ^= v << 5;
  return v;
}

uint64_t HashString(const char* s) {
  uint64_t h = 37;
  while (*s) {
    h = (h * 54059) ^ (s[0] * 76963);
    s++;
  }
  return h;
}

static std::string GetLEPUSString(const JSString* str) {
  int32_t c;
  bool is_wide_char = str->is_wide_char;
  if (!is_wide_char) {
    c = 0;
    for (int32_t i = 0; i < str->len; ++i) {
      c |= str->u.str8[i];
    }
    if (c < 0x80)
      return std::string{reinterpret_cast<const char*>(str->u.str8), str->len};
  }

  static constexpr size_t buffer_size = 64;
  static char buffer[buffer_size]{};
  char* q = buffer;
  for (int32_t i = 0; i < str->len; ++i) {
    c = is_wide_char ? str->u.str16[i] : str->u.str8[i];
    if ((q - buffer) >= (buffer_size - UTF8_CHAR_LEN_MAX)) break;
    if (c < 128) {
      *q++ = c;
    } else {
      q += unicode_to_utf8(reinterpret_cast<uint8_t*>(q), c);
    }
  }
  *q = '\0';
  return std::string(buffer, q - buffer);
}

CpuProfile::CpuProfile(CpuProfiler* profiler, std::string title)
    : title_(std::move(title)),
      profiler_(profiler),
      start_time_{TimeTicks::Now()} {
  // use new context for profiler thread
  ctx_ = profiler_->context();
  top_down_ = std::make_unique<ProfileTree>(profiler->context());
}

static std::unique_ptr<CodeEntry> GetCodeEntry(
    LEPUSContext* ctx, const CpuProfileMetaInfo& each_sample) {
  auto* script = each_sample.script_;
  std::string func_name =
      each_sample.func_name_ ? GetLEPUSString(each_sample.func_name_) : "";
  std::string filename =
      each_sample.file_name_ ? GetLEPUSString(each_sample.file_name_) : "";
  return std::make_unique<CodeEntry>(
      std::move(func_name), script ? script->url : std::move(filename),
      each_sample.line_, each_sample.col_, script ? script->id : -1);
}

void CpuProfile::AddPath(const TickSampleEventRecord& sample) {
  // tranverse the stack, start from the top frame
  int32_t frame_count = sample.frames_count_;
  ProfileNode* node = top_down_->root();
  int32_t parent_line_number = 0;
  for (int32_t i = frame_count - 1; i >= 0; i--) {
    auto& cur_stack_info = sample.stack_meta_info_[i];
    auto code_entry = GetCodeEntry(ctx_, cur_stack_info);
    if (!code_entry) continue;
    node = node->FindOrAddChild(std::move(code_entry), parent_line_number);
  }

  node->IncrementSelfTicks();
  sample_info_.push_back(SampleInfo{sample.timestamp_, node->node_id()});
  return;
}

LEPUSValue CpuProfile::GetCpuProfileContent(LEPUSContext* ctx) const& {
  CpuProfileJSONSerialize serializer{*this};
  return serializer.Serialize(ctx);
}

void CpuProfile::FinishProfile() {
  // microseconds
  end_time_ = TimeTicks::Now();
  return;
}

// ProfileGenerator
ProfileGenerator::ProfileGenerator(std::shared_ptr<CpuProfile>& profile)
    : profile_(profile) {}

void ProfileGenerator::RecordTickSample(const TickSampleEventRecord& sample) {
  // traverse the frame, start from the top frame
  profile_->AddPath(sample);
}

LEPUSValue CpuProfileJSONSerialize::SerializeChildren(LEPUSContext* ctx,
                                                      const ProfileNode& node) {
  LEPUSValue children = LEPUS_NewArray(ctx);
  HandleScope func_scope{ctx, &children, HANDLE_TYPE_LEPUS_VALUE};
  uint32_t idx = 0;
  for (const auto& child : node.children_list()) {
    LEPUS_SetPropertyUint32(ctx, children, idx++,
                            LEPUS_NewInt32(ctx, child->node_id()));
  }
  return children;
}

LEPUSValue CpuProfileJSONSerialize::SerializeCallFrame(
    LEPUSContext* ctx, const ProfileNode& node) {
  LEPUSValue call_frame, func_name, script_id, url;
  HandleScope func_scope{ctx, &call_frame, HANDLE_TYPE_LEPUS_VALUE};
  func_scope.PushHandle(&func_name, HANDLE_TYPE_LEPUS_VALUE);
  func_scope.PushHandle(&script_id, HANDLE_TYPE_LEPUS_VALUE);
  func_scope.PushHandle(&url, HANDLE_TYPE_LEPUS_VALUE);
  call_frame = LEPUS_NewObject(ctx);
  func_name = LEPUS_NewStringLen(ctx, node.entry()->name().c_str(),
                                 node.entry()->name().size());
  script_id = LEPUS_NewStringLen(ctx, node.entry()->script_id().c_str(),
                                 node.entry()->script_id().size());
  url = LEPUS_NewStringLen(ctx, node.entry()->resource_name().c_str(),
                           node.entry()->resource_name().size());

  LEPUS_SetPropertyStr(ctx, call_frame, "functionName", func_name);
  LEPUS_SetPropertyStr(ctx, call_frame, "scriptId", script_id);
  LEPUS_SetPropertyStr(ctx, call_frame, "url", url);
  LEPUS_SetPropertyStr(ctx, call_frame, "lineNumber",
                       LEPUS_NewInt32(ctx, node.entry()->line_number()));
  LEPUS_SetPropertyStr(ctx, call_frame, "columnNumber",
                       LEPUS_NewInt32(ctx, node.entry()->column_number()));
  return call_frame;
}

LEPUSValue CpuProfileJSONSerialize::SerializePositionTicks(
    LEPUSContext* ctx, const ProfileNode& node) {
  LEPUSValue position_ticks = LEPUS_NewArray(ctx);
  HandleScope func_scope{ctx, &position_ticks, HANDLE_TYPE_LEPUS_VALUE};
  uint32_t idx = 0;
  for (const auto& tick_info : node.line_ticks()) {
    LEPUSValue ele = LEPUS_NewObject(ctx);
    HandleScope block_scope{ctx, &ele, HANDLE_TYPE_LEPUS_VALUE};
    LEPUS_SetPropertyStr(ctx, ele, "line",
                         LEPUS_NewInt32(ctx, tick_info.first));
    LEPUS_SetPropertyStr(ctx, ele, "ticks",
                         LEPUS_NewInt32(ctx, tick_info.second));
    LEPUS_SetPropertyUint32(ctx, position_ticks, idx++, ele);
  }
  return position_ticks;
}

LEPUSValue CpuProfileJSONSerialize::SerializeNode(LEPUSContext* ctx,
                                                  const ProfileNode& node) {
  LEPUSValue profile_node = LEPUS_NewObject(ctx);
  LEPUSValue call_frame, children;
  HandleScope func_scope{ctx, &profile_node, HANDLE_TYPE_LEPUS_VALUE};
  func_scope.PushHandle(&call_frame, HANDLE_TYPE_LEPUS_VALUE);
  func_scope.PushHandle(&children, HANDLE_TYPE_LEPUS_VALUE);
  call_frame = SerializeCallFrame(ctx, node);
  children = SerializeChildren(ctx, node);

  LEPUS_SetPropertyStr(ctx, profile_node, "id",
                       LEPUS_NewInt32(ctx, node.node_id()));
  LEPUS_SetPropertyStr(ctx, profile_node, "callFrame", call_frame);
  LEPUS_SetPropertyStr(ctx, profile_node, "hitCount",
                       LEPUS_NewInt32(ctx, node.self_ticks()));
  LEPUS_SetPropertyStr(ctx, profile_node, "children", children);
  return profile_node;
}

std::vector<const ProfileNode*> CpuProfileJSONSerialize::FlattenProfileNodes() {
  std::vector<const ProfileNode*> nodes;
  auto* top_node = profile_.TopDown()->root();
  std::function<void(const ProfileNode*)> flattenNode;
  flattenNode = [&](const ProfileNode* node) {
    nodes.push_back(node);
    for (const auto& child : node->children_list()) {
      flattenNode(child.get());
    }
    return;
  };
  flattenNode(top_node);
  return nodes;
}

LEPUSValue CpuProfileJSONSerialize::SerializeNodes(LEPUSContext* ctx) {
  LEPUSValue nodes = LEPUS_NewArray(ctx);
  HandleScope func_scope{ctx, &nodes, HANDLE_TYPE_LEPUS_VALUE};
  auto profile_nodes = FlattenProfileNodes();
  size_t idx = 0;
  for (const auto& node : profile_nodes) {
    LEPUSValue node_result = SerializeNode(ctx, *node);
    HandleScope block_scope{ctx, &node_result, HANDLE_TYPE_LEPUS_VALUE};
    LEPUS_SetPropertyUint32(ctx, nodes, idx++, node_result);
  }
  return nodes;
}

std::pair<LEPUSValue, LEPUSValue>
CpuProfileJSONSerialize::SerializeSamplesAndDeltas(LEPUSContext* ctx) {
  LEPUSValue samples, deltas;
  HandleScope func_scope{ctx, &samples, HANDLE_TYPE_LEPUS_VALUE};
  func_scope.PushHandle(&deltas, HANDLE_TYPE_LEPUS_VALUE);
  samples = LEPUS_NewArray(ctx);
  deltas = LEPUS_NewArray(ctx);

  const auto& sample = profile_.SampleInfos();

  uint32_t last_node_id = 0, idx = 0;
  uint64_t last_timestamp = profile_.start_time();
  for (size_t i = 0; i < sample.size(); ++i) {
    auto node_id = sample[i].node_id_;
    auto time_stample = sample[i].time_stample_;
    if (node_id == last_node_id) continue;
    LEPUS_SetPropertyUint32(ctx, samples, idx, LEPUS_NewInt32(ctx, node_id));
    LEPUS_SetPropertyUint32(
        ctx, deltas, idx++,
        LEPUS_NewInt64(ctx, (time_stample - last_timestamp)));
    last_node_id = node_id;
    last_timestamp = time_stample;
  }
  return {samples, deltas};
}

LEPUSValue CpuProfileJSONSerialize::Serialize(LEPUSContext* ctx) {
  LEPUSValue samples, deltas, nodes, profile_obj, ret, start_time, end_time;
  ret = LEPUS_NewObject(ctx);
  HandleScope func_scope{ctx, &ret, HANDLE_TYPE_LEPUS_VALUE};
  profile_obj = LEPUS_NewObject(ctx);
  func_scope.PushHandle(&profile_obj, HANDLE_TYPE_LEPUS_VALUE);
  func_scope.PushHandle(&samples, HANDLE_TYPE_LEPUS_VALUE);
  func_scope.PushHandle(&deltas, HANDLE_TYPE_LEPUS_VALUE);
  func_scope.PushHandle(&nodes, HANDLE_TYPE_LEPUS_VALUE);
  func_scope.PushHandle(&start_time, HANDLE_TYPE_LEPUS_VALUE);
  func_scope.PushHandle(&end_time, HANDLE_TYPE_LEPUS_VALUE);

  auto sample_delta = SerializeSamplesAndDeltas(ctx);
  samples = sample_delta.first;
  deltas = sample_delta.second;
  nodes = SerializeNodes(ctx);
  start_time = LEPUS_NewInt64(ctx, profile_.start_time());
  end_time = LEPUS_NewInt64(ctx, profile_.end_time());

  LEPUS_SetPropertyStr(ctx, profile_obj, "nodes", nodes);
  LEPUS_SetPropertyStr(ctx, profile_obj, "startTime", start_time);
  LEPUS_SetPropertyStr(ctx, profile_obj, "endTime", end_time);
  LEPUS_SetPropertyStr(ctx, profile_obj, "samples", samples);
  LEPUS_SetPropertyStr(ctx, profile_obj, "timeDeltas", deltas);
  LEPUS_SetPropertyStr(ctx, ret, "profile", profile_obj);
  return ret;
}
}  // namespace CpuProfiler
}  // namespace primjs
#endif
