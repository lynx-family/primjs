
// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INSPECTOR_HEAPPROFILER_GEN_H_
#define SRC_INSPECTOR_HEAPPROFILER_GEN_H_

#include <unordered_map>

#include "inspector/heapprofiler/edge.h"
#include "inspector/heapprofiler/entry.h"
#include "inspector/heapprofiler/heapexplorer.h"

namespace quickjs {
namespace heapprofiler {

class HeapObjectIdMaps {
 public:
  // these entry's type is kSynthetic
  HeapObjectIdMaps() { next_id_ = kFirstAvailiableObjectId; }
  static constexpr uint64_t kObjectIdStep = 2;
  static constexpr SnapshotObjectId kRootEntryId = 1;

  static constexpr SnapshotObjectId kGcRootsObjectId =
      kRootEntryId + kObjectIdStep;

  static constexpr SnapshotObjectId kGcFirstGcRootsObjectId =
      kGcRootsObjectId + kObjectIdStep;

  static constexpr SnapshotObjectId kRootUserGlobalObjectId =
      kGcFirstGcRootsObjectId +
      kObjectIdStep * static_cast<uint32_t>(Root::kNumberOfRoots);

  static constexpr SnapshotObjectId kRootGlobalObjectId =
      kRootUserGlobalObjectId + kObjectIdStep;
  static constexpr SnapshotObjectId kObjListObjectId =
      kRootGlobalObjectId + kObjectIdStep;
  static constexpr SnapshotObjectId kFirstAvailiableObjectId =
      kObjListObjectId + kObjectIdStep;

  SnapshotObjectId GetEntryObjectId(const LEPUSValue& value);
  SnapshotObjectId GetEntryObjectId(const HeapObjPtr& ptr) {
    return GetHeapObjId(ptr.ptr_);
  }

  std::ostream& DumpObjectIdMaps(std::ostream& output);

  SnapshotObjectId LastAssignedId() { return next_id_; }

 private:
  SnapshotObjectId GetHeapObjId(const HeapPtr ptr);
  SnapshotObjectId next_id_;
  std::unordered_map<HeapPtr, SnapshotObjectId> objectid_maps_;
};

class ProgressReportInterface {
 public:
  virtual ~ProgressReportInterface() = default;

  virtual void ProgressResult(uint32_t done, uint32_t total, bool finished) = 0;
};

class HeapSnapshotGenerator {
 public:
  using HeapThing = const void*;
  using HeapEntriesMap = std::unordered_map<HeapThing, HeapEntry*>;

  HeapSnapshotGenerator(HeapSnapshot* snapshot, LEPUSContext*,
                        ProgressReportInterface* report);

  HeapSnapshotGenerator(const HeapSnapshotGenerator&) = delete;
  HeapSnapshotGenerator& operator=(const HeapSnapshotGenerator&) = delete;

  void GenerateSnapshot();

  HeapEntry* FindEntry(HeapThing ptr) {
    auto it = entries_map_.find(ptr);
    return it != entries_map_.end() ? it->second : nullptr;
  }

  HeapEntry* FindOrAddEntry(LEPUSContext* ctx, const LEPUSValue& value,
                            HeapEntriesAllocator* allocator) {
    if (QjsHeapExplorer::HasEntry(value)) {
      auto it = FindEntry(LEPUS_VALUE_GET_PTR(value));
      return it ? it
                : entries_map_
                      .emplace(LEPUS_VALUE_GET_PTR(value),
                               allocator->AllocateEntry(ctx, value))
                      .first->second;
    }
    return nullptr;
  }

  HeapEntry* FindOrAddEntry(LEPUSContext* ctx, const HeapObjPtr& obj,
                            HeapEntriesAllocator* allocator) {
    auto it = FindEntry(obj.ptr_);
    return it ? it
              : entries_map_
                    .emplace(obj.ptr_, allocator->AllocateEntry(ctx, obj))
                    .first->second;
  }

  LEPUSContext* context() const { return context_; }

 private:
  // main function for build object graph

  void ProgressGenResult();
  void FillReferences();
  HeapSnapshot* snapshot_;
  LEPUSContext* context_;
  QjsHeapExplorer quickjs_heap_explorer_;
  HeapEntriesMap entries_map_;  // ptr/id -> HeapEntry*
  ProgressReportInterface* reporter_;
};

}  // namespace heapprofiler
}  // namespace quickjs

#endif  // SRC_INSPECTOR_HEAPPROFILER_GEN_H_
