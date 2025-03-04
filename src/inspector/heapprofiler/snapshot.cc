// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "inspector/heapprofiler/snapshot.h"

#include <assert.h>

#include "inspector/heapprofiler/gen.h"
#include "inspector/heapprofiler/heapprofiler.h"

namespace quickjs {

namespace heapprofiler {

HeapEntry* HeapSnapshot::GetEntryById(SnapshotObjectId id) {
  if (entries_by_id_cache_.empty()) {
    entries_by_id_cache_.reserve(entries_.size());
    for (auto& entry : entries_) {
      entries_by_id_cache_.emplace(entry.id(), &entry);
    }
  }
  auto it = entries_by_id_cache_.find(id);
  return it != entries_by_id_cache_.end() ? it->second : nullptr;
}

void HeapSnapshot::RememberLastJsObjectId() {
  max_object_id = profiler_->object_id_maps()->LastAssignedId();
}

void HeapSnapshot::Delete() { profiler_->RemoveSnapshot(this); }

HeapEntry* HeapSnapshot::AddEntry(HeapEntry::Type type, const std::string& name,
                                  SnapshotObjectId id, size_t size) {
  entries_.emplace_back(this, static_cast<uint32_t>(entries().size()), type,
                        name, id, size);
  return &entries_.back();
}

void HeapSnapshot::FillChildren() {
  uint32_t children_index = 0;
  for (auto& entry : entries_) {
    children_index = entry.set_chiledren_index(children_index);
  }
  assert(edges_.size() == static_cast<size_t>(children_index));
  children_.resize(edges_.size());

  for (auto& edge : edges_) {
    edge.from()->add_child(&edge);
  }
}

void HeapSnapshot::AddSyntheticRootEntries() {
  AddRootEntry();
  AddGcRootEntry();
  AddGcSubRootEntry();
  return;
}

const char* HeapSnapshot::GetSubRootName(Root root) {
  switch (root) {
#define ROOT_CASE(root_id, description) \
  case Root::root_id:                   \
    return description;
    GC_ROOT_ID_LIST(ROOT_CASE)
#undef ROOT_CASE
    default:
      break;
  }
  return nullptr;
}

void HeapSnapshot::AddRootEntry() {
  root_entry_ =
      AddEntry(HeapEntry::kSynthetic, "", HeapObjectIdMaps::kRootEntryId, 0);
}

void HeapSnapshot::AddGcRootEntry() {
  gc_root_entry_ = AddEntry(HeapEntry::kSynthetic, "(GC roots)",
                            HeapObjectIdMaps::kGcRootsObjectId, 0);
  return;
}
void HeapSnapshot::AddGcSubRootEntry() {
  auto first_gc_subroots_id = HeapObjectIdMaps::kGcFirstGcRootsObjectId;
  for (size_t i = 0; i < static_cast<size_t>(Root::kNumberOfRoots); ++i) {
    gc_subroot_entries_[i] =
        AddEntry(HeapEntry::kSynthetic, GetSubRootName(static_cast<Root>(i)),
                 first_gc_subroots_id + i * HeapObjectIdMaps::kObjectIdStep, 0);
  }
  return;
}

}  // namespace heapprofiler
}  // namespace quickjs
