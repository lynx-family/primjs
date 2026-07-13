// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_SON_SCHEDULE_RESULT_H
#define PRIMJS_SON_SCHEDULE_RESULT_H

#include "primjs/base/bit_vector.h"
#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"
#include "primjs/son/cfgAnalysis.h"
#include "primjs/son/nodeGraph.h"

namespace son {
namespace node {

class BasicBlock : public BasicBlockBase {
 private:
  Node* _node;
  BasicBlock* _rpo_next;
  base::ZoneVector<Node*> _nodes;
  BasicBlock* _dominator;
  int _rpo_number;
  int _loop_number;
  int _dominator_depth;

 public:
  BasicBlock(int id, Node* node, base::Zone* zone)
      : BasicBlockBase(id),
        _node(node),
        _nodes(zone),
        _dominator(nullptr),
        _rpo_number(-1),
        _loop_number(-1),
        _dominator_depth(-1) {}

  static BasicBlock* cast(BasicBlockBase* base) {
    return static_cast<BasicBlock*>(base);
  }
  Node* control() const { return _node; }
  void AddNode(Node* node) { _nodes.push_back(node); }
  const base::ZoneVector<Node*>& nodes() const { return _nodes; }
  bool has_rpo_number() const { return _rpo_number >= 0; }
  int rpo_number() const { return _rpo_number; }
  void set_rpo_number(int rpo_number) { _rpo_number = rpo_number; }
  bool has_loop_number() const { return _loop_number >= 0; }
  int loop_number() const { return _loop_number; }
  void set_loop_number(int loop_number) { _loop_number = loop_number; }
  int dominator_depth() const { return _dominator_depth; }
  void set_dominator_depth(int depth) { _dominator_depth = depth; }
  BasicBlock* dominator() const { return _dominator; }
  void set_dominator(BasicBlock* dominator) { _dominator = dominator; }
  void set_rpo_next(BasicBlock* next) { _rpo_next = next; }
  BasicBlock* rpo_next() const { return _rpo_next; }

  static BasicBlock* GetCommonDominator(BasicBlock* lhs, BasicBlock* rhs) {
    while (lhs != rhs) {
      if (lhs->dominator_depth() < rhs->dominator_depth()) {
        rhs = rhs->dominator();
      } else {
        lhs = lhs->dominator();
      }
    }
    return lhs;
  }
};

class ScheduleResult : public base::ZoneObject {
 private:
  base::Zone* _zone;
  base::ZoneVector<BasicBlock*> _block_list;
  base::ZoneVector<BasicBlock*> _id_to_block;
  BasicBlock* _entry;
  BasicBlock* _end;
  NodeGraph* _graph;

 public:
  ScheduleResult(base::Zone* zone)
      : _zone(zone),
        _block_list(zone),
        _id_to_block(zone),
        _entry(nullptr),
        _end(nullptr),
        _graph(nullptr) {}
  void AddBlock(BasicBlock* bb) { _block_list.push_back(bb); }

  base::ZoneVector<BasicBlock*>& block_list() { return _block_list; }
  int BasicBlockCount() const { return static_cast<int>(_block_list.size()); }
  base::Zone* zone() const { return _zone; }
  BasicBlock* entry() const { return _entry; }
  BasicBlock* end() const { return _end; }
  void set_entry(BasicBlock* entry) { _entry = entry; }
  void set_end(BasicBlock* end) { _end = end; }
  BasicBlock* block(Node* node) {
    vmassert(node->index() < _id_to_block.size(), "node id out of range");
    return _id_to_block[node->index()];
  }
  void set_block(Node* node, BasicBlock* bb) {
    _id_to_block[node->index()] = bb;
  }
  void init_id_to_block(int node_count) { _id_to_block.resize(node_count); }
  NodeGraph* graph() const { return _graph; }
  void set_graph(NodeGraph* graph) { _graph = graph; }
};

}  // namespace node
}  // namespace son
#endif  // PRIMJS_SON_SCHEDULE_RESULT_H
