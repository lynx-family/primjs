// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#if !defined(_WIN32)
#ifndef SRC_INSPECTOR_CPUPROFILER_PROFILE_TREE_H_
#define SRC_INSPECTOR_CPUPROFILER_PROFILE_TREE_H_

#include <memory>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif

namespace primjs {
namespace CpuProfiler {

class ProfileTree;
class ProfileNode;

class CodeEntry {
 public:
  CodeEntry(std::string name, std::string resource_name = "",
            int32_t line_number = -1, int64_t column_number = -1,
            int32_t script_id = 0)
      : name_(std::move(name)),
        resource_name_(std::move(resource_name)),
        script_id_(std::to_string(script_id)),
        line_number_(line_number),
        column_number_(column_number) {}

  const std::string& name() const& { return name_; }
  const std::string& resource_name() const& { return resource_name_; }
  const std::string& script_id() const& { return script_id_; }

  int32_t line_number() const { return line_number_; }
  int64_t column_number() const { return column_number_; }
  uint32_t GetHash() const;
  bool IsSameFunctionAs(const CodeEntry&) const;

 private:
  std::string name_;
  std::string resource_name_;
  std::string script_id_;
  int32_t line_number_;    // function line number
  int64_t column_number_;  // function column number
};

struct CodeEntryAndLineNumber {
  const CodeEntry* code_entry;
  int32_t line_number;
};

class ProfileNode {
 public:
  inline ProfileNode(std::unique_ptr<CodeEntry>, ProfileNode*, ProfileTree*);

  ProfileNode* FindOrAddChild(std::unique_ptr<CodeEntry>,
                              int32_t line_number = 0);
  void IncrementSelfTicks();
  void IncrementLineTicks(int32_t);

  auto& entry() const& { return entry_; }
  auto entry() && { return std::move(entry_); }
  int64_t self_ticks() const { return self_ticks_; }
  const auto& children_list() const& { return children_list_; }
  uint32_t node_id() const { return node_id_; }
  ProfileNode* parent() const { return parent_; }
  const std::unordered_map<int32_t, uint64_t>& line_ticks() const {
    return line_ticks_;
  }

 private:
  struct Equals {
    bool operator()(const CodeEntryAndLineNumber&,
                    const CodeEntryAndLineNumber&) const;
  };
  struct Hasher {
    std::size_t operator()(const CodeEntryAndLineNumber&) const;
  };

  std::unique_ptr<CodeEntry> entry_;
  std::unordered_map<int32_t, uint64_t> line_ticks_{};
  std::unordered_map<CodeEntryAndLineNumber, ProfileNode*, Hasher, Equals>
      children_{};
  std::vector<std::unique_ptr<ProfileNode>> children_list_{};
  ProfileNode* parent_;
  ProfileTree* tree_;
  int64_t self_ticks_{0};
  uint32_t node_id_;
};

class ProfileTree {
 public:
  explicit ProfileTree(LEPUSContext* ctx) : ctx_{ctx} {};
  ~ProfileTree() = default;
  ProfileNode* root() const& { return root_.get(); }
  uint32_t NextNodeId() { return next_node_id_++; }
  LEPUSContext* context() const { return ctx_; }

 private:
  LEPUSContext* ctx_;
  uint32_t next_node_id_{1};
  std::unique_ptr<ProfileNode> root_{std::make_unique<ProfileNode>(
      std::make_unique<CodeEntry>("(root)"), nullptr, this)};
};

ProfileNode::ProfileNode(std::unique_ptr<CodeEntry> entry, ProfileNode* parent,
                         ProfileTree* tree)
    : entry_{std::move(entry)},
      parent_{parent},
      tree_{tree},
      node_id_{tree->NextNodeId()} {}

}  // namespace CpuProfiler
}  // namespace primjs
#endif
#endif  // SRC_INSPECTOR_CPUPROFILER_PROFILE_TREE_H_
