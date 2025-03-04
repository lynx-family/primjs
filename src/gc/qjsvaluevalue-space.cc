// Copyright 2009 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "gc/qjsvaluevalue-space.h"

#include "gc/base-global-handles.h"
#include "gc/global-handles.h"

constexpr size_t kBlockSize = 256;
enum State : uint8_t {
  FREE = 0,
  NORMAL,
};

class Element {
 public:
  Element(const Element&) = delete;
  Element& operator=(const Element&) = delete;

  Element() = default;

  static Element* FromLocation(Addr* location) {
    return reinterpret_cast<Element*>(location);
  }

  void* location() { return &mem; }

  uint8_t index() const { return index_; }
  void set_index(uint8_t value) { index_ = value; }

  Element* next_free() { return data_.next_free; }

  friend QJSValueValueSpace;

  State state() const { return (State)flags_; }
  void set_state(State state) { flags_ = (uint8_t)state; }

  bool IsInUse() const { return state() != FREE; }

  bool IsStrongRetainer() const { return state() == NORMAL; }

  void MarkAsFree() { set_state(FREE); }
  void MarkAsUsed() { set_state(NORMAL); }

  void Free(Element* free_list) {
    MarkAsFree();
    data_.next_free = free_list;
  }

  void Release(Element* free_list) { Free(free_list); }
  QJSValueValueSpace* global_handles1();
  char mem[48];

 protected:
  uint8_t flags_;
  uint8_t index_;
  union {
    Element* next_free;
  } data_;
};

class QJSValueValueSpace::NODEBLOCK(QJSValueValueSpace, Element);
QJSValueValueSpace* Element::global_handles1() {
  return QJSValueValueSpace::NodeBlock::From(this)->global_handles();
}

const QJSValueValueSpace::NodeBlock* QJSValueValueSpace::NodeBlock::From(
    const Element* node) {
  const Element* firstNode = node - node->index();
  const NodeBlock* block = reinterpret_cast<const NodeBlock*>(firstNode);
  return block;
}

QJSValueValueSpace::NodeBlock* QJSValueValueSpace::NodeBlock::From(
    Element* node) {
  Element* firstNode = node - node->index();
  NodeBlock* block = reinterpret_cast<NodeBlock*>(firstNode);
  return block;
}

void QJSValueValueSpace::NodeBlock::ListAdd(NodeBlock** top) {
  NodeBlock* old_top = *top;
  *top = this;
  next_used_ = old_top;
  prev_used_ = nullptr;
  if (old_top != nullptr) {
    old_top->prev_used_ = this;
  }
}

void QJSValueValueSpace::NodeBlock::ListRemove(NodeBlock** top) {
  if (next_used_ != nullptr) next_used_->prev_used_ = prev_used_;
  if (prev_used_ != nullptr) prev_used_->next_used_ = next_used_;
  if (this == *top) {
    *top = next_used_;
  }
}

class QJSValueValueSpace::ITERATOR(Element);

class QJSValueValueSpace::NodeSpace final {
 public:
  using iterator = NodeIterator;

  static NodeSpace* From(Element* node);
  static void Release(Element* node);

  explicit NodeSpace(QJSValueValueSpace* global_handles)
      : global_handles_(global_handles) {}
  ~NodeSpace();

  inline Element* Allocate();

  iterator begin() { return iterator(first_used_block_); }
  iterator end() { return iterator(nullptr); }

 private:
  void PutNodesOnFreeList(NodeBlock* block);
  inline void Free(Element* node);

  QJSValueValueSpace* const global_handles_;
  NodeBlock* first_block_ = nullptr;
  NodeBlock* first_used_block_ = nullptr;
  Element* first_free_ = nullptr;
};

QJSValueValueSpace::NodeSpace::~NodeSpace() {
  auto* block = first_block_;
  while (block != nullptr) {
    auto* tmp = block->next();
    delete block;
    block = tmp;
  }
}

bool QJSValueValueSpace::NodeBlock::IncreaseUsage() {
  return used_nodes_++ == 0;
}

bool QJSValueValueSpace::NodeBlock::DecreaseUsage() {
  return --used_nodes_ == 0;
}

Element* QJSValueValueSpace::NodeSpace::Allocate() {
  if (first_free_ == nullptr) {
    first_block_ = new NodeBlock(global_handles_, this, first_block_);
    PutNodesOnFreeList(first_block_);
  }

  Element* node = first_free_;
  first_free_ = first_free_->next_free();

  NodeBlock* block = NodeBlock::From(node);
  if (block->IncreaseUsage()) {
    block->ListAdd(&first_used_block_);
  }
  return node;
}

void QJSValueValueSpace::NodeSpace::PutNodesOnFreeList(NodeBlock* block) {
  for (int32_t i = kBlockSize - 1; i >= 0; --i) {
    Element* node = block->at(i);
    const uint8_t index = static_cast<uint8_t>(i);
    node->set_index(index);
    node->Free(first_free_);
    first_free_ = node;
  }
}

void QJSValueValueSpace::NodeSpace::Release(Element* node) {
  NodeBlock* block = NodeBlock::From(node);
  block->space()->Free(node);
}

void QJSValueValueSpace::NodeSpace::Free(Element* node) {
  node->Release(first_free_);
  first_free_ = node;
  NodeBlock* block = NodeBlock::From(node);
  if (block->DecreaseUsage()) {
    block->ListRemove(&first_used_block_);
  }
}

QJSValueValueSpace::QJSValueValueSpace(LEPUSRuntime* runtime)
    : runtime_(runtime) {
  regular_nodes_ = new NodeSpace(this);
}

QJSValueValueSpace::~QJSValueValueSpace() { delete regular_nodes_; }
void* QJSValueValueSpace::Create() {
  Element* node = regular_nodes_->Allocate();
#ifdef ENABLE_GC_DEBUG_TOOLS
  AddCurNode(runtime_, reinterpret_cast<void*>(node), 2);
#endif
  node->set_state(State::NORMAL);
  return node->mem;
}

void QJSValueValueSpace::Destroy(void* location) {
  NodeSpace::Release(Element::FromLocation(reinterpret_cast<Addr*>(location)));
}

void QJSValueValueSpace::IterateAllRoots(int local_idx) {
  for (Element* node : *regular_nodes_) {
    if (node->IsStrongRetainer()) {
      LEPUSValue* val = reinterpret_cast<LEPUSValue*>(
          reinterpret_cast<uint8_t*>(node->location()) + 8);
      LEPUS_VisitLEPUSValue(runtime(), val, local_idx);
    }
  }
}
