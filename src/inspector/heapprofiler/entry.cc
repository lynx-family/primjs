
// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "inspector/heapprofiler/entry.h"

#include "inspector/heapprofiler/snapshot.h"

namespace quickjs {

namespace heapprofiler {
HeapEntry::HeapEntry(HeapSnapshot* snapshot, uint32_t index, Type type,
                     const char* name, SnapshotObjectId id, size_t self_size)
    : type_(type),
      index_(index),
      name_(name),
      children_count_(0),
      snapshot_(snapshot),
      self_size_(self_size),
      id_(id) {}

HeapEntry::HeapEntry(HeapSnapshot* snapshot, uint32_t index, Type type,
                     const std::string& name, SnapshotObjectId id,
                     size_t self_size)
    : type_(type),
      index_(index),
      name_(name),
      children_count_(0),
      snapshot_(snapshot),
      self_size_(self_size),
      id_(id) {}

void HeapEntry::SetNamedReference(HeapGraphEdge::Type type, const char* name,
                                  HeapEntry* entry) {
  ++children_count_;
  snapshot_->edges().emplace_back(type, name, this, entry);
}

void HeapEntry::SetNamedReference(HeapGraphEdge::Type type,
                                  const std::string& name, HeapEntry* entry) {
  ++children_count_;
  snapshot_->edges().emplace_back(type, name, this, entry);
}

void HeapEntry::SetIndexedReference(HeapGraphEdge::Type type, uint32_t index,
                                    HeapEntry* entry) {
  ++children_count_;
  snapshot_->edges().emplace_back(type, index, this, entry);
}

void HeapEntry::SetIndexedAutoIndexReference(HeapGraphEdge::Type type,
                                             HeapEntry* child) {
  SetIndexedReference(type, children_count_ + 1, child);
}

void HeapEntry::SetNamedAutoIndexReference(HeapGraphEdge::Type type,
                                           HeapEntry* child) {
  SetNamedReference(type, std::to_string(children_count_ + 1), child);
  return;
}

std::vector<HeapGraphEdge*>::iterator HeapEntry::children_end() const {
  return snapshot_->childrens().begin() + children_end_index_;
}

std::vector<HeapGraphEdge*>::iterator HeapEntry::children_begin() const {
  return index_ == 0 ? snapshot_->childrens().begin()
                     : snapshot_->entries()[index_ - 1].children_end();
}

uint32_t HeapEntry::set_chiledren_index(uint32_t index) {
  uint32_t next_index = index + children_count_;
  children_end_index_ = index;
  return next_index;
}

void HeapEntry::add_child(HeapGraphEdge* edge) {
  snapshot_->childrens()[children_end_index_++] = edge;
}

HeapGraphEdge* HeapEntry::child(uint32_t i) { return children_begin()[i]; }

uint32_t HeapEntry::children_count() const {
  return static_cast<uint32_t>(children_end() - children_begin());
}

}  // namespace heapprofiler
}  // namespace quickjs
