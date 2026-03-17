// Copyright 2009 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "gc/global-handles.h"

#include <atomic>

#include "gc/base-global-handles.h"
#ifdef DEBUG
#if defined(ANDROID) || defined(__ANDROID__)
#include <android/log.h>
#endif
#endif

#define DCHECK(condition) ((void)0)
#define DCHECK_EQ(v1, v2) ((void)0)
#define DCHECK_NE(v1, v2) ((void)0)
#define DCHECK_GT(v1, v2) ((void)0)
#define DCHECK_GE(v1, v2) ((void)0)
#define DCHECK_LT(v1, v2) ((void)0)
#define DCHECK_LE(v1, v2) ((void)0)
#define DCHECK_NULL(val) ((void)0)
#define DCHECK_NOT_NULL(val) ((void)0)
#define DCHECK_IMPLIES(v1, v2) ((void)0)

constexpr size_t kBlockSize = 256;

class Node;
class NodeBase {
 public:
  static const Node* FromLocation(const Addr* location) {
    return reinterpret_cast<const Node*>(location);
  }

  static Node* FromLocation(Addr* location) {
    return reinterpret_cast<Node*>(location);
  }

  NodeBase() {
    DCHECK_EQ(offsetof(NodeBase, object_), 0);
    DCHECK_EQ(offsetof(NodeBase, flags_), Internals::kNodeFlagsOffset);
  }

  LEPUSValue* location() { return &object_; }

  LEPUSValue raw_object() const { return object_; }

  uint8_t index() const { return index_; }
  void set_index(uint8_t value) { index_ = value; }

  // Accessors for next free node in the free list.
  Node* next_free() {
    DCHECK(!AsChild()->IsInUse());
    return data_.next_free;
  }

  void set_parameter(void* parameter) {
    DCHECK(AsChild()->IsInUse());
    data_.parameter = parameter;
  }
  void* parameter() const {
    DCHECK(AsChild()->IsInUse());
    return data_.parameter;
  }

  void set_weakinfo(void (*cb_)(void*), void* cb_arg_) {
    cb = cb_;
    cb_arg = cb_arg_;
  }
  friend GlobalHandles;

 protected:
  Node* AsChild() { return reinterpret_cast<Node*>(this); }
  const Node* AsChild() const { return reinterpret_cast<const Node*>(this); }

  // Storage for object pointer.
  //
  // Placed first to avoid offset computation. The stored data is equivalent to
  // an Object. It is stored as a plain Addr for convenience (smallest number
  // of casts), and because it is a private implementation detail: the public
  // interface provides type safety.
  LEPUSValue object_;

  // will be reused when node memory used as qjsvaluevalue
  void (*cb)(void*) = nullptr;

  void* cb_arg = nullptr;

  // Index in the containing handle block.
  uint8_t index_;

  uint8_t flags_;

  // The meaning of this field depends on node state:
  // - Node in free list: Stores next free node pointer.
  // - Otherwise, specific to the node implementation.
  union {
    Node* next_free;
    void* parameter;
  } data_;
};

class Node final : public NodeBase {
 public:
  // State transition diagram:
  // FREE -> NORMAL <-> WEAK -> {FREE} -> FREE
  enum State : uint8_t {
    FREE = 0,
    // Strong global handle.
    NORMAL,
    // Flagged as weak and still considered as live.
    WEAK,
    DELETING,
  };

  Node() {}

  Node(const Node&) = delete;
  Node& operator=(const Node&) = delete;

  const char* label() const {
    return state() == NORMAL ? reinterpret_cast<char*>(data_.parameter)
                             : nullptr;
  }

  // State and flag accessors.

  State state() const { return (State)flags_; }
  void set_state(State state) { flags_ = (uint8_t)state; }

  bool IsInUse() const { return state() != FREE; }

  bool IsStrongRetainer() const { return state() == NORMAL; }

  // Accessors for next free node in the free list.
  Node* next_free() {
    DCHECK_EQ(FREE, state());
    return data_.next_free;
  }

  void ClearFields() {
    // Zap the values for eager trapping.
    object_ = LEPUS_UNDEFINED;
    cb = nullptr;
    cb_arg = nullptr;
  }

  void MarkAsFree() { set_state(FREE); }
  void MarkAsUsed() { set_state(NORMAL); }

  void MarkAsWeak() { set_state(WEAK); }

  void ClearValue() { object_ = LEPUS_UNDEFINED; }

  void CheckNodeIsFreeNode() const {
    DCHECK(LEPUS_IsUndefined(object_));
    AsChild()->CheckNodeIsFreeNodeImpl();
  }

  void Free(Node* free_list) {
    ClearFields();
    AsChild()->MarkAsFree();
    AsChild()->ClearValue();
    data_.next_free = free_list;
  }

  // Publishes all internal state to be consumed by other threads.
  LEPUSValue* Publish(LEPUSValue object, bool is_weak) {
    DCHECK(!AsChild()->IsInUse());
    data_.parameter = nullptr;
    object_ = object;
    if (is_weak)
      AsChild()->MarkAsWeak();
    else
      AsChild()->MarkAsUsed();
    DCHECK(AsChild()->IsInUse());
    return location();
  }

  void Release(Node* free_list) {
    DCHECK(AsChild()->IsInUse());
    Free(free_list);
    DCHECK(!AsChild()->IsInUse());
  }
  GlobalHandles* global_handles();

 private:
  void CheckNodeIsFreeNodeImpl() const { DCHECK(!IsInUse()); }

  friend class NodeBase;
};

class GlobalHandles::NODEBLOCK(GlobalHandles, Node);

GlobalHandles* Node::global_handles() {
  return GlobalHandles::NodeBlock::From(this)->global_handles();
}

const GlobalHandles::NodeBlock* GlobalHandles::NodeBlock::From(
    const Node* node) {
  const Node* firstNode = node - node->index();
  const NodeBlock* block = reinterpret_cast<const NodeBlock*>(firstNode);
  DCHECK_EQ(node, block->at(node->index()));
  return block;
}

GlobalHandles::NodeBlock* GlobalHandles::NodeBlock::From(Node* node) {
  Node* firstNode = node - node->index();
  NodeBlock* block = reinterpret_cast<NodeBlock*>(firstNode);
  DCHECK_EQ(node, block->at(node->index()));
  return block;
}

bool GlobalHandles::NodeBlock::IncreaseUsage() {
  DCHECK_LT(used_nodes_, kBlockSize);
  return used_nodes_++ == 0;
}

void GlobalHandles::NodeBlock::ListAdd(NodeBlock** top) {
  NodeBlock* old_top = *top;
  *top = this;
  next_used_ = old_top;
  prev_used_ = nullptr;
  if (old_top != nullptr) {
    old_top->prev_used_ = this;
  }
}

bool GlobalHandles::NodeBlock::DecreaseUsage() {
  DCHECK_GT(used_nodes_, 0);
  return --used_nodes_ == 0;
}

void GlobalHandles::NodeBlock::ListRemove(NodeBlock** top) {
  if (next_used_ != nullptr) next_used_->prev_used_ = prev_used_;
  if (prev_used_ != nullptr) prev_used_->next_used_ = next_used_;
  if (this == *top) {
    *top = next_used_;
  }
}

class GlobalHandles::ITERATOR(Node);

class GlobalHandles::NodeSpace final {
 public:
  using iterator = NodeIterator;

  static NodeSpace* From(Node* node);
  static void Release(Node* node);

  explicit NodeSpace(GlobalHandles* global_handles)
      : global_handles_(global_handles) {}
  ~NodeSpace();

  inline Node* Allocate();

  iterator begin() { return iterator(first_used_block_); }
  iterator end() { return iterator(nullptr); }

  size_t TotalSize() const { return blocks_ * sizeof(Node) * kBlockSize; }
  size_t handles_count() const { return handles_count_; }

 private:
  void PutNodesOnFreeList(NodeBlock* block);
  inline void Free(Node* node);

  GlobalHandles* const global_handles_;
  NodeBlock* first_block_ = nullptr;
  NodeBlock* first_used_block_ = nullptr;
  Node* first_free_ = nullptr;
  size_t blocks_ = 0;
  size_t handles_count_ = 0;
};

GlobalHandles::NodeSpace::~NodeSpace() {
  auto* block = first_block_;
  while (block != nullptr) {
    auto* tmp = block->next();
    delete block;
    block = tmp;
  }
}

Node* GlobalHandles::NodeSpace::Allocate() {
  if (first_free_ == nullptr) {
    first_block_ = new NodeBlock(global_handles_, this, first_block_);
    blocks_++;
    PutNodesOnFreeList(first_block_);
  }
  DCHECK_NOT_NULL(first_free_);
  Node* node = first_free_;
  first_free_ = first_free_->next_free();
  NodeBlock* block = NodeBlock::From(node);
  if (block->IncreaseUsage()) {
    block->ListAdd(&first_used_block_);
  }
  handles_count_++;
  node->CheckNodeIsFreeNode();
  return node;
}

void GlobalHandles::NodeSpace::PutNodesOnFreeList(NodeBlock* block) {
  for (int32_t i = kBlockSize - 1; i >= 0; --i) {
    Node* node = block->at(i);
    const uint8_t index = static_cast<uint8_t>(i);
    DCHECK_EQ(i, index);
    node->set_index(index);
    node->Free(first_free_);
    first_free_ = node;
  }
}

void GlobalHandles::NodeSpace::Release(Node* node) {
  NodeBlock* block = NodeBlock::From(node);
  block->space()->Free(node);
}

void GlobalHandles::NodeSpace::Free(Node* node) {
  node->Release(first_free_);
  first_free_ = node;
  NodeBlock* block = NodeBlock::From(node);
  if (block->DecreaseUsage()) {
    block->ListRemove(&first_used_block_);
  }
  handles_count_--;
}

size_t GlobalHandles::TotalSize() const { return regular_nodes_->TotalSize(); }

size_t GlobalHandles::UsedSize() const {
  return regular_nodes_->handles_count() * sizeof(Node);
}

size_t GlobalHandles::handles_count() const {
  return regular_nodes_->handles_count();
}

GlobalHandles::GlobalHandles(LEPUSRuntime* runtime) : runtime_(runtime) {
  regular_nodes_ = new NodeSpace(this);
}

GlobalHandles::~GlobalHandles() { delete regular_nodes_; }

LEPUSValue* GlobalHandles::Create(LEPUSValue value, bool is_weak) {
  Node* node = regular_nodes_->Allocate();
#ifdef ENABLE_GC_DEBUG_TOOLS
  AddCurNode(runtime_, reinterpret_cast<void*>(node), 1);
#endif
  return node->Publish(value, is_weak);
}

void GlobalHandles::Destroy(LEPUSValue* location) {
  if (location != nullptr) {
    NodeSpace::Release(Node::FromLocation(reinterpret_cast<Addr*>(location)));
  }
}

void GlobalHandles::SetWeak(LEPUSValue* location, void* data,
                            void (*cb)(void*)) {
  if (location != nullptr) {
    Node* node = Node::FromLocation(reinterpret_cast<Addr*>(location));
    node->set_state(Node::State::WEAK);
    node->set_weakinfo(cb, data);
  }
}

void GlobalHandles::ClearWeak(LEPUSValue* location) {
  if (location != nullptr) {
    Node* node = Node::FromLocation(reinterpret_cast<Addr*>(location));
    node->set_state(Node::State::NORMAL);
    node->set_weakinfo(nullptr, nullptr);
  }
}

void GlobalHandles::SetWeakState(LEPUSValue* location) {
  if (location != nullptr) {
    Node* node = Node::FromLocation(reinterpret_cast<Addr*>(location));
    node->set_state(Node::State::WEAK);
  }
}

void GlobalHandles::IterateAllRoots(int local_idx, int offset) {
  for (Node* node : *regular_nodes_) {
    if (node->IsStrongRetainer()) {
      LEPUSValue* val = reinterpret_cast<LEPUSValue*>(
          reinterpret_cast<uint8_t*>(node->location()) + offset);
      LEPUS_VisitLEPUSValue(runtime(), val, local_idx);
    }
  }
}
bool GlobalHandles::IsMarkedLEPUSValue(LEPUSValue* val) {
  if (LEPUS_VALUE_HAS_REF_COUNT((*val))) {
    void* ptr = LEPUS_VALUE_GET_PTR((*val));
#ifdef ENABLE_GC_DEBUG_TOOLS
    DCHECK(ptr && check_valid_ptr(runtime(), ptr));
#endif
#ifndef _WIN32
    return (reinterpret_cast<std::atomic<int>*>(ptr) - 1)
        ->load(std::memory_order_relaxed);
#endif
  }
  return true;
}

void GlobalHandles::GlobalRootsFinalizer() {
  for (Node* node : *regular_nodes_) {
    if (node->state() == Node::State::DELETING) {
      // abort();
    }
    if (node->state() == Node::State::WEAK &&
        !IsMarkedLEPUSValue(node->location())) {
      node->set_state(Node::State::DELETING);
      if (!node->cb) {
        // lynx weak handle
      } else {
        // napi weak handle
        node->cb(node->cb_arg);
      }
    }
  }
#ifdef DEBUG
#if defined(ANDROID) || defined(__ANDROID__)
  if (node_cnt > 0)
    __android_log_print(
        ANDROID_LOG_ERROR, "PRIMJS_GC",
        "GlobalRootsFinalizer, State is DELETING, node_count: %d\n", node_cnt);
#endif
#endif
}
