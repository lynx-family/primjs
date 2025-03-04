
// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "inspector/heapprofiler/edge.h"

#include "inspector/heapprofiler/entry.h"
#include "inspector/heapprofiler/snapshot.h"

namespace quickjs {

namespace heapprofiler {

HeapGraphEdge::HeapGraphEdge(Type type, const char* name, HeapEntry* from,
                             HeapEntry* to)
    : name_(name),
      to_entry_(to),
      bit_filed_((static_cast<uint32_t>(type)) |
                 ((static_cast<uint32_t>(from->index())) << kEdegeTypeSize)),
      is_index_or_name_(false) {}

HeapGraphEdge::HeapGraphEdge(Type type, const std::string& name,
                             HeapEntry* from, HeapEntry* to)
    : name_(name),
      to_entry_(to),
      bit_filed_((static_cast<uint32_t>(type)) |
                 ((static_cast<uint32_t>(from->index())) << kEdegeTypeSize)),
      is_index_or_name_(false) {}

HeapGraphEdge::HeapGraphEdge(Type type, uint32_t index, HeapEntry* from,
                             HeapEntry* to)
    : index_(index),
      to_entry_(to),
      bit_filed_((static_cast<uint32_t>(type)) |
                 ((static_cast<uint32_t>(from->index())) << kEdegeTypeSize)),
      is_index_or_name_(true) {}

HeapEntry* HeapGraphEdge::from() const {
  return &(snapshot()->entries()[from_index()]);
}

HeapSnapshot* HeapGraphEdge::snapshot() const { return to_entry_->snapshot(); }

}  // namespace heapprofiler
}  // namespace quickjs
