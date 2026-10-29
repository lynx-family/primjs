
// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "inspector/heapprofiler/heapprofiler.h"

#include <algorithm>
#include <cstdlib>
#include <cstring>
#include <ostream>
#include <sstream>

#if defined(OS_ANDROID)
#include <unistd.h>
#endif

#include "gc/collector_ms.h"
#include "gc/ros_allocator.h"
#include "gc/trace-gc.h"
#include "inspector/heapprofiler/gen.h"
#include "inspector/heapprofiler/serialize.h"
#include "inspector/interface.h"

namespace quickjs {
namespace heapprofiler {

// online close
#define DUMP_OBJINFO 0

HeapProfiler::HeapProfiler() : objectids_(new HeapObjectIdMaps()) {}

void HeapProfiler::DeleteAllSnapShots() { snapshots_.clear(); }

void HeapProfiler::RemoveSnapshot(HeapSnapshot* snapshot) {
  snapshots_.erase(
      std::find_if(snapshots_.begin(), snapshots_.end(),
                   [&snapshot](const std::unique_ptr<HeapSnapshot>& entry) {
                     return entry.get() == snapshot;
                   }));
}

HeapSnapshot* HeapProfiler::TakeSnapshot(LEPUSContext* ctx,
                                         ProgressReportInterface* reporter,
                                         int32_t slot, uint32_t flags) {
  context_ = ctx;
  is_takingsnapshot = true;
  HeapSnapshot* result = new HeapSnapshot(this, slot, flags);
  bool success = true;
  {
    HeapSnapshotGenerator generator(result, context_, reporter);
    if (result->is_slot_snapshot()) {
      success = generator.GenerateSnapshotForSlot();
    } else {
      generator.GenerateSnapshot();
    }
  }
  if (success) {
    snapshots_.emplace_back(result);
  } else {
    delete result;
    result = nullptr;
  }
  is_takingsnapshot = false;
  context_ = nullptr;
  return result;
}

std::ostream& HeapProfiler::DumpObjectIdMaps(std::ostream& output) {
  return objectids_->DumpObjectIdMaps(output);
}

namespace {
// No TLS destructor: Runtime owners can query this after profiler teardown.
thread_local QjsHeapProfilerImpl* active_heap_profiler = nullptr;
}  // namespace

QjsHeapProfilerImpl& GetQjsHeapProfilerImplInstance() {
  struct ThreadLocalHeapProfiler {
    ThreadLocalHeapProfiler() { active_heap_profiler = &profiler; }
    ~ThreadLocalHeapProfiler() { active_heap_profiler = nullptr; }
    QjsHeapProfilerImpl profiler;
  };
  thread_local static ThreadLocalHeapProfiler instance;
  return instance.profiler;
}

auto* QjsHeapProfilerImpl::FindOrNewHeapProfiler(LEPUSContext* ctx) {
  LEPUSRuntime* rt = LEPUS_GetRuntime(ctx);
  auto itr = profilers_.find(rt);
  if (itr != profilers_.end()) {
    return itr->second.get();
  } else {
    auto qjs_heapprofiler = new HeapProfiler();
    profilers_.emplace(rt, qjs_heapprofiler);
    return qjs_heapprofiler;
  }
}

HeapProfiler* QjsHeapProfilerImpl::FindHeapProfiler(LEPUSRuntime* rt) {
  auto it = profilers_.find(rt);
  return it == profilers_.end() ? nullptr : it->second.get();
}

HeapSnapshot* QjsHeapProfilerImpl::TakeHeapSnapshotForSlot(LEPUSContext* ctx,
                                                           int32_t slot,
                                                           uint32_t flags) {
  return FindOrNewHeapProfiler(ctx)->TakeSnapshot(ctx, nullptr, slot, flags);
}

void QjsHeapProfilerImpl::TakeHeapSnapshot(
    LEPUSContext* ctx, const std::shared_ptr<Fronted>& fronted) {
  auto* profiler = FindOrNewHeapProfiler(ctx);

  auto progress_report =
      std::make_unique<HeapSnapshotGeneratorProgressReport>(fronted);

  // snapshot result
  auto* snapshot = profiler->TakeSnapshot(ctx, progress_report.get());

  // serializer tool
  HeapSnapshotJSONSerializer serializer(snapshot);

  // output tool, serializer snapshot to string to fronted
  HeapSnapshotOutputStream stream(fronted);

  serializer.Serialize(&stream);

  profiler->RemoveSnapshot(snapshot);

// if need, dump object -> id map
#if DUMP_OBJINFO
  std::ostringstream id_infos;
  profiler->DumpObjectIdMaps(id_infos);
  js_heap_dump_file(id_infos.str(), "ids");
#endif
}

void QjsHeapProfilerImpl::TakeHeapSnapshot(
    LEPUSContext* ctx, LEPUSValue message,
    const std::shared_ptr<Fronted>& fronted) {
  TakeHeapSnapshot(ctx, fronted);
  fronted->SendReponse(message);
}

HeapSnapshot* QjsHeapProfilerImpl::TakeHeapSnapshot(LEPUSContext* ctx,
                                                    uint32_t flags) {
  auto* profiler = FindOrNewHeapProfiler(ctx);

  return profiler->TakeSnapshot(ctx, nullptr, -1, flags);
}

}  // namespace heapprofiler
}  // namespace quickjs

extern "C" void js_profile_remove_runtime(LEPUSRuntime* rt) {
  if (auto* profiler = quickjs::heapprofiler::active_heap_profiler) {
    profiler->RemoveRuntime(rt);
  }
}

namespace {
class StringOutputStream : public quickjs::heapprofiler::OutputStream {
 public:
  uint32_t GetChunkSize() override { return 10240; }
  void WriteChunk(const std::string& chunk) override {
    snapshot_.append(chunk);
  }

  const std::string& Content() const { return snapshot_; }

 private:
  std::string snapshot_;
};

const char* SerializeAndDeleteSnapshot(
    quickjs::heapprofiler::HeapSnapshot* snapshot) {
  if (!snapshot) return nullptr;
  StringOutputStream stream;
  quickjs::heapprofiler::HeapSnapshotJSONSerializer(snapshot).Serialize(
      &stream);
  snapshot->Delete();
  const auto& json = stream.Content();
  auto* result = static_cast<char*>(std::malloc(json.size() + 1));
  if (result) {
    std::memcpy(result, json.data(), json.size());
    result[json.size()] = '\0';
  }
  return result;
}
}  // namespace

extern "C" const char* js_profile_take_heap_snapshot(LEPUSContext* ctx) {
  return js_profile_take_heap_snapshot_flags(ctx, 0);
}

extern "C" const char* js_profile_take_heap_snapshot_flags(LEPUSContext* ctx,
                                                           uint32_t flags) {
  if (!ctx) return nullptr;
  return SerializeAndDeleteSnapshot(
      quickjs::heapprofiler::GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(
          ctx, flags));
}

extern "C" const char* js_profile_take_heap_snapshot_for_slot(LEPUSContext* ctx,
                                                              int32_t slot,
                                                              uint32_t flags) {
  if (!ctx || !LEPUS_IsMemorySlotTrackingEnabled(ctx->rt) || slot < 0 ||
      slot > ctx->rt->malloc_state.max_slot_index ||
      (!ctx->gc_enable && !JS_GetRCAllocationSet(ctx->rt))) {
    return nullptr;
  }
#ifdef ENABLE_COMPATIBLE_MM
  if (ctx->gc_enable && (ctx->rt->collector_->IsForbidGC() ||
                         ctx->rt->ros_->InGCPauseSuppressionMode()))
    return nullptr;
#endif
  ScopedCommonMemorySlot common_slot(ctx->rt);
  return SerializeAndDeleteSnapshot(
      quickjs::heapprofiler::GetQjsHeapProfilerImplInstance()
          .TakeHeapSnapshotForSlot(ctx, slot, flags));
}

extern "C" void js_profile_free_heap_snapshot(const char* snapshot) {
  if (snapshot == nullptr) {
    return;
  }
  std::free(const_cast<char*>(snapshot));
}

#ifdef ENABLE_QUICKJS_DEBUGGER
#include "inspector/debugger_inner.h"
#include "inspector/protocols.h"

namespace quickjs {
namespace heapprofiler {

void DevtoolFronted::AddHeapSnapshotChunk(const std::string& chunk) {
  if (context_ == nullptr) return;

  LEPUSValue chunkvalue = LEPUS_NewString(context_, chunk.c_str());
  LEPUSValue params = LEPUS_NewObject(context_);
  LEPUS_SetPropertyStr(context_, params, "chunk", chunkvalue);
  SendNotification(context_, "HeapProfiler.addHeapSnapshotChunk", params);
}

void DevtoolFronted::ReportHeapSnapshotProgress(uint32_t done, uint32_t total,
                                                bool finished) {
  if (context_ == nullptr) return;

  LEPUSValue param = LEPUS_NewObject(context_);

  LEPUS_SetPropertyStr(context_, param, "done", LEPUS_NewInt64(context_, done));
  LEPUS_SetPropertyStr(context_, param, "total",
                       LEPUS_NewInt64(context_, total));
  LEPUS_SetPropertyStr(context_, param, "finished",
                       LEPUS_NewBool(context_, finished));
  SendNotification(context_, "HeapProfiler.reportHeapSnapshotProgress", param);
}

void DevtoolFronted::SendReponse(LEPUSValue message) {
  LEPUSValue nullobj = LEPUS_NewObject(context_);
  SendResponse(context_, message, nullobj);
}

}  // namespace heapprofiler
}  // namespace quickjs

void HandleHeapProfilerProtocols(DebuggerParams* param) {
  quickjs::heapprofiler::GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(
      param->ctx, param->message,
      std::make_shared<quickjs::heapprofiler::DevtoolFronted>(param->ctx));
}
#endif  // ENABLE_QUICKJS_DEBUGGER

#ifdef HEAPPROFILER_UNITTEST

void take_heap_snapshot_test(LEPUSContext* ctx) {
  js_profile_free_heap_snapshot(js_profile_take_heap_snapshot(ctx));
}
#endif
