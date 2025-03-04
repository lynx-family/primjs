
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

namespace quickjs {
namespace heapprofiler {

SnapshotObjectId HeapObjectIdMaps::GetHeapObjId(const HeapPtr ptr) {
  auto itr = objectid_maps_.find(ptr);

  if (itr != objectid_maps_.end()) {
    return itr->second;
  }
  objectid_maps_.emplace(ptr, (next_id_ += kObjectIdStep));
  return next_id_;
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

void HeapSnapshotGenerator::GenerateSnapshot() {
  // TODO: Implement
  // 1. GC
  // 2. count total obj
  // 3. Traverse the obj list and alloc entry for obj
  // 4. Iterate and extract every obj
  LEPUS_RunGC(LEPUS_GetRuntime(context_));

  snapshot_->AddSyntheticRootEntries();
  FillReferences();
  snapshot_->FillChildren();
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
