// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INSPECTOR_HEAPPROFILER_SNAPSHOT_H_
#define SRC_INSPECTOR_HEAPPROFILER_SNAPSHOT_H_

#include <deque>
#include <queue>
#include <string>
#include <unordered_map>
#include <vector>

#include "inspector/heapprofiler/entry.h"

namespace quickjs {
namespace heapprofiler {
class HeapProfiler;

class HeapSnapshot {
 public:
  enum class Diagnostic : uint8_t {
#ifdef ENABLE_QUICKJS_DEBUGGER
    kDebugger = 1,
#endif
    kCoverage = 2,
    kCount = 3
  };

  explicit HeapSnapshot(HeapProfiler* profiler, int32_t slot = -1,
                        uint32_t flags = LEPUS_HEAP_SNAPSHOT_INCLUDE_LOCATIONS)
      : profiler_(profiler), slot_(slot), flags_(flags) {
    memset(gc_subroot_entries_, 0, sizeof(gc_subroot_entries_));
  }
  HeapSnapshot(const HeapSnapshot&) = delete;
  HeapSnapshot& operator=(const HeapSnapshot&) = delete;
  void Delete();

  HeapProfiler* profiler() const { return profiler_; }
  std::deque<HeapEntry>& entries() { return entries_; }
  const std::deque<HeapEntry>& entries() const { return entries_; }
  std::vector<HeapGraphEdge>& edges() { return edges_; }
  const std::vector<HeapGraphEdge>& edges() const { return edges_; }
  std::vector<HeapGraphEdge*>& childrens() { return children_; }
  bool is_complete() const { return !children_.empty(); }

  HeapEntry* AddEntry(HeapEntry::Type, const std::string& name,
                      SnapshotObjectId id, size_t size);
  HeapEntry* AddEntry(HeapEntry::Type, const char* name, SnapshotObjectId id,
                      size_t size);

  void FillChildren();
  void AddSyntheticRootEntries();
  HeapEntry* GetEntryById(SnapshotObjectId id);
  bool is_slot_snapshot() const { return slot_ >= 0; }
  int32_t slot() const { return slot_; }
  bool summarize_diagnostics() const {
    return flags_ & LEPUS_HEAP_SNAPSHOT_SUMMARIZE_DIAGNOSTICS;
  }
  bool include_locations() const {
    return flags_ & LEPUS_HEAP_SNAPSHOT_INCLUDE_LOCATIONS;
  }
  struct Location {
    uint32_t entry_index, script_id, source_offset;
  };
  // Copies source metadata; serialization never dereferences VM allocations.
  void AddFunctionLocation(LEPUSContext* ctx, HeapEntry* entry,
                           const LEPUSFunctionBytecode* bytecode);
  const std::vector<Location>& locations() const { return locations_; }
  const std::vector<std::string>& sources() const { return sources_; }
  // Register dedicated diagnostic storage, never inferred from JS field names.
  void SetDiagnosticReference(HeapEntry* from, const std::string& name,
                              HeapEntry* to, Diagnostic diagnostic);
  void MarkDiagnosticAllocation(HeapEntry* entry, Diagnostic diagnostic);
  // Filters a completed graph and rebuilds its children. Ownership is assigned
  // only to allocation bases.
  void FilterForSlot(const std::vector<int32_t>& slots,
                     const std::vector<size_t>& sizes);
  void SummarizeDiagnostics();

  HeapEntry* root() const { return root_entry_; }
  HeapEntry* gc_root() const { return gc_root_entry_; }
  HeapEntry* gc_subroot(Root root) const {
    return gc_subroot_entries_[static_cast<uint32_t>(root)];
  }

  void RememberLastJsObjectId();
  SnapshotObjectId max_snapshot_js_object_id() const { return max_object_id; }

 private:
  const char* GetSubRootName(Root root);
  void AddRootEntry();
  void AddGcRootEntry();
  void AddGcSubRootEntry();
  void FilterGraph(const std::vector<int32_t>& slots,
                   const std::vector<size_t>& sizes);

  std::deque<HeapEntry> entries_;  // all node
  // Edge addresses are published only after graph construction.
  std::vector<HeapGraphEdge> edges_;
  std::vector<HeapGraphEdge*> children_;  // all edges by sort
  std::unordered_map<SnapshotObjectId, HeapEntry*> entries_by_id_cache_;
  std::vector<uint8_t> diagnostic_allocations_;
  std::vector<Location> locations_;
  std::vector<std::string> sources_;
  // Snapshot-local IDs preserve distinct compilations, including equal
  // filenames.
  std::unordered_map<uint32_t, uint32_t> source_ids_;

  HeapProfiler* profiler_ = nullptr;
  HeapEntry* root_entry_ = nullptr;
  HeapEntry* gc_root_entry_ = nullptr;
  HeapEntry* gc_subroot_entries_[static_cast<int>(Root::kNumberOfRoots)];

  SnapshotObjectId max_object_id = 0;
  int32_t slot_ = -1;
  uint32_t flags_;
};

}  // namespace heapprofiler
}  // namespace quickjs

#endif  // SRC_INSPECTOR_HEAPPROFILER_SNAPSHOT_H_
