
// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "inspector/heapprofiler/gen.h"

#include <ostream>
#include <string>

#include "gc/collector.h"
#include "inspector/heapprofiler/heapexplorer.h"
#include "quickjs/include/quickjs-inner.h"

#ifdef ENABLE_QUICKJS_DEBUGGER
#include "inspector/runtime/runtime.h"
#endif

namespace quickjs {
namespace heapprofiler {

SnapshotObjectId HeapObjectIdMaps::GetHeapObjId(const HeapPtr ptr) {
  auto result = objectid_maps_.try_emplace(ptr, next_id_ + kObjectIdStep);
  if (result.second) next_id_ += kObjectIdStep;
  return result.first->second;
}

std::ostream& HeapObjectIdMaps::DumpObjectIdMaps(std::ostream& output) {
  std::string header = "Object Id Maps: \nObjAddress  : ObjectId\n";
  output << header.c_str();
  for (auto& itr : objectid_maps_) {
    output << (itr.first) << " : " << itr.second << "\n";
  }
  return output;
}

SnapshotObjectId HeapObjectIdMaps::GetEntryObjectId(const LEPUSValue& value) {
  // only allocate entry if value's tag < 0 or value is number.
  // if the value is a heap object, use it's ptr as object id.
  return GetHeapObjId(LEPUS_VALUE_GET_PTR(value));
}

HeapSnapshotGenerator::HeapSnapshotGenerator(HeapSnapshot* snapshot,
                                             LEPUSContext* ctx,
                                             ProgressReportInterface* report)
    : snapshot_(snapshot),
      context_(ctx),
      quickjs_heap_explorer_(snapshot, ctx),
      reporter_(report) {}

no_inline HeapEntry* HeapSnapshotGenerator::InsertEntry(HeapThing ptr,
                                                        HeapEntry* entry) {
  return entries_map_.emplace(ptr, entry).first->second;
}

void HeapSnapshotGenerator::CollectGarbage() {
  auto* rt = LEPUS_GetRuntime(context_);
#ifdef ENABLE_QUICKJS_DEBUGGER
  if (snapshot_->clear_console_messages()) {
    ScopedCommonMemorySlot common_slot(rt);
    list_head* el;
    list_for_each(el, &rt->context_list) {
      auto* ctx = list_entry(el, LEPUSContext, link);
      if (ctx->debugger_info && ctx->debugger_info->console.length) {
        ClearConsoleMessages(ctx);
      }
    }
  }
#endif
  // forceParallel completes prior concurrent work and synchronously sweeps.
  LEPUS_RunGC(rt);
}

void HeapSnapshotGenerator::GenerateSnapshot() {
  CollectGarbage();

  snapshot_->AddSyntheticRootEntries();
  FillReferences();
  quickjs_heap_explorer_.ExtractRuntimeAllocationReferences();
  snapshot_->FillChildren();
  if (snapshot_->summarize_diagnostics()) snapshot_->SummarizeDiagnostics();
  ProgressGenResult();

  snapshot_->RememberLastJsObjectId();
  return;
}

void HeapSnapshotGenerator::FillReferences() {
  quickjs_heap_explorer_.IterateAndExtractReference(this);
  return;
}

void HeapSnapshotGenerator::ProgressGenResult() {
  if (!reporter_) return;
  reporter_->ProgressResult(snapshot_->entries().size(),
                            snapshot_->entries().size(), true);
}
}  // namespace heapprofiler
}  // namespace quickjs
