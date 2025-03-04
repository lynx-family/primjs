// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#if !defined(_WIN32)
#include "inspector/cpuprofiler/profile_tree.h"

#include <assert.h>

#include "inspector/cpuprofiler/profile_generator.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
namespace CpuProfiler {
// CodeEntry
bool CodeEntry::IsSameFunctionAs(const CodeEntry& other) const {
  // no need to compare column number
  return script_id_ == other.script_id_ && name_ == other.name_ &&
         resource_name_ == other.resource_name_ &&
         line_number_ == other.line_number_ &&
         column_number_ == other.column_number_;
}

uint32_t CodeEntry::GetHash() const {
  uint32_t hash = 0;
  hash ^= ComputedHashUint64(HashString(name_.c_str()));
  hash ^= ComputedHashUint64(HashString(resource_name_.c_str()));
  hash ^= ComputedHashUint64(static_cast<uint64_t>(line_number_));
  hash ^= ComputedHashUint64(static_cast<uint64_t>(column_number_));
  if (script_id_ != "-1") {
    hash ^= ComputedHashUint64(HashString(script_id_.c_str()));
  }
  return hash;
}

// ProfileNode
ProfileNode* ProfileNode::FindOrAddChild(std::unique_ptr<CodeEntry> entry,
                                         int32_t line_number) {
  auto map_entry = children_.find({entry.get(), line_number});
  if (map_entry == children_.end()) {
    auto node = std::make_unique<ProfileNode>(std::move(entry), this, tree_);
    auto ret = node.get();
    children_[{node->entry_.get(), line_number}] = ret;
    children_list_.push_back(std::move(node));
    return ret;
  } else {
    return map_entry->second;
  }
}

void ProfileNode::IncrementLineTicks(int32_t src_line) {
  assert(src_line > 0);
  // Increment a hit counter of a certain source line.
  // Add a new source line if not found.
  auto map_entry = line_ticks_.find(src_line);
  if (map_entry == line_ticks_.end()) {
    line_ticks_[src_line] = 1;
  } else {
    line_ticks_[src_line]++;
  }
}

void ProfileNode::IncrementSelfTicks() { ++self_ticks_; }

bool ProfileNode::Equals::operator()(const CodeEntryAndLineNumber& lhs,
                                     const CodeEntryAndLineNumber& rhs) const {
  return (lhs.code_entry == rhs.code_entry ||
          lhs.code_entry->IsSameFunctionAs(*rhs.code_entry)) &&
         lhs.line_number == rhs.line_number;
}

std::size_t ProfileNode::Hasher::operator()(
    const CodeEntryAndLineNumber& pair) const {
  auto code_entry_hash = pair.code_entry->GetHash();
  auto line_number_hash =
      ComputedHashUint64(static_cast<uint64_t>(pair.line_number));
  return code_entry_hash ^ line_number_hash;
}
}  // namespace CpuProfiler
}  // namespace primjs
#endif
