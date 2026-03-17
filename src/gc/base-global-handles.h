// Copyright 2009 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_GC_BASE_GLOBAL_HANDLES_H_
#define SRC_GC_BASE_GLOBAL_HANDLES_H_

#define ITERATOR(NODETYPE)                                     \
  NodeIterator final {                                         \
   public:                                                     \
    explicit NodeIterator(NodeBlock* block) : block_(block) {} \
    NodeIterator(NodeIterator&& other)                         \
        : block_(other.block_), index_(other.index_) {}        \
    NodeIterator(const NodeIterator&) = delete;                \
    NodeIterator& operator=(const NodeIterator&) = delete;     \
    bool operator==(const NodeIterator& other) const {         \
      return block_ == other.block_;                           \
    }                                                          \
    bool operator!=(const NodeIterator& other) const {         \
      return block_ != other.block_;                           \
    }                                                          \
    NodeIterator& operator++() {                               \
      if (++index_ < kBlockSize) return *this;                 \
      index_ = 0;                                              \
      block_ = block_->next_used();                            \
      return *this;                                            \
    }                                                          \
    NODETYPE* operator*() { return block_->at(index_); }       \
    NODETYPE* operator->() { return block_->at(index_); }      \
                                                               \
   private:                                                    \
    NodeBlock* block_ = nullptr;                               \
    size_t index_ = 0;                                         \
  };

#define NODEBLOCK(HANDLETYPE, NODETYPE)                                  \
  NodeBlock final {                                                      \
   public:                                                               \
    inline static const NodeBlock* From(const NODETYPE* node);           \
    inline static NodeBlock* From(NODETYPE* node);                       \
    NodeBlock(HANDLETYPE* global_handles, HANDLETYPE::NodeSpace* space,  \
              NodeBlock* next)                                           \
        : next_(next), global_handles_(global_handles), space_(space) {} \
    ~NodeBlock() = default;                                              \
    NodeBlock(const NodeBlock&) = delete;                                \
    NodeBlock& operator=(const NodeBlock&) = delete;                     \
    NODETYPE* at(size_t index) { return &nodes_[index]; }                \
    const NODETYPE* at(size_t index) const { return &nodes_[index]; }    \
    HANDLETYPE::NodeSpace* space() const { return space_; }              \
    HANDLETYPE* global_handles() const { return global_handles_; }       \
    inline bool IncreaseUsage();                                         \
    inline bool DecreaseUsage();                                         \
    inline void ListAdd(NodeBlock** top);                                \
    inline void ListRemove(NodeBlock** top);                             \
    NodeBlock* next() const { return next_; }                            \
    NodeBlock* next_used() const { return next_used_; }                  \
    const void* begin_address() const { return nodes_; }                 \
    const void* end_address() const { return &nodes_[kBlockSize]; }      \
                                                                         \
   private:                                                              \
    NODETYPE nodes_[kBlockSize];                                         \
    NodeBlock* const next_;                                              \
    HANDLETYPE* const global_handles_;                                   \
    HANDLETYPE::NodeSpace* const space_;                                 \
    NodeBlock* next_used_ = nullptr;                                     \
    NodeBlock* prev_used_ = nullptr;                                     \
    uint32_t used_nodes_ = 0;                                            \
  };
#endif  // SRC_GC_BASE_GLOBAL_HANDLES_H_
