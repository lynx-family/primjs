
// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "inspector/heapprofiler/heapprofiler.h"

#include <algorithm>
#include <ostream>

#include "inspector/debugger_inner.h"
#include "inspector/heapprofiler/gen.h"
#include "inspector/heapprofiler/serialize.h"
#include "inspector/protocols.h"

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
                                         ProgressReportInterface* reporter) {
  context_ = ctx;
  is_takingsnapshot = true;
  HeapSnapshot* result = new HeapSnapshot(this);
  {
    HeapSnapshotGenerator generator(result, context_, reporter);
    generator.GenerateSnapshot();
    snapshots_.emplace_back(result);
  }
  is_takingsnapshot = false;
  context_ = nullptr;
  return result;
}

std::ostream& HeapProfiler::DumpObjectIdMaps(std::ostream& output) {
  return objectids_->DumpObjectIdMaps(output);
}

QjsHeapProfilerImpl& GetQjsHeapProfilerImplInstance() {
  thread_local static QjsHeapProfilerImpl instance;
  return instance;
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

HeapSnapshot* QjsHeapProfilerImpl::TakeHeapSnapshot(LEPUSContext* ctx) {
  auto* profiler = FindOrNewHeapProfiler(ctx);

  return profiler->TakeSnapshot(ctx, nullptr);
}

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

class PrintFronted : public Fronted {
 public:
  // send notification
  void AddHeapSnapshotChunk(const std::string& chunk) override {
    stream << chunk;
  }

  void ReportHeapSnapshotProgress(uint32_t done, uint32_t total,
                                  bool finished) override{};
  // send reponse
  void SendReponse(LEPUSValue message) override{};

  const std::stringstream& GetStream() { return stream; }

  virtual ~PrintFronted() { stream.clear(); }

 private:
  std::stringstream stream;
};

}  // namespace heapprofiler
}  // namespace quickjs

void js_profile_take_heap_snapshot(LEPUSContext* ctx) {
  auto outstream = std::make_shared<quickjs::heapprofiler::PrintFronted>();

  quickjs::heapprofiler::GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(
      ctx, outstream);

  quickjs::heapprofiler::js_heap_dump_file(outstream->GetStream().str(),
                                           "heapsnapshot");
  return;
}

void HandleHeapProfilerProtocols(DebuggerParams* param) {
  quickjs::heapprofiler::GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(
      param->ctx, param->message,
      std::make_shared<quickjs::heapprofiler::DevtoolFronted>(param->ctx));
}

// for unittest
#ifdef HEAPPROFILER_UNITTEST
void take_heap_snapshot_test(LEPUSContext* ctx) {
  auto outstream = std::make_shared<quickjs::heapprofiler::PrintFronted>();

  quickjs::heapprofiler::GetQjsHeapProfilerImplInstance().TakeHeapSnapshot(
      ctx, outstream);
}
#endif
