// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_SON_GRAPH_LINEARIZER_H
#define PRIMJS_SON_GRAPH_LINEARIZER_H

#include "primjs/base/bit_vector.h"
#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"
#include "primjs/son/cfgAnalysis.h"
#include "primjs/son/graphVisitor.h"
#include "primjs/son/nodeGraph.h"
#include "primjs/son/scheduleResult.h"

namespace son {
namespace node {

class BasicBlock;
class BlockLoopInfo : public base::ZoneObject {
 public:
  BasicBlock* _header;
  BlockLoopInfo* _parent;
  base::ZoneVector<BasicBlock*> _outgoing;
  base::BitVector* _members;
  BasicBlock* _insert_point;

  BlockLoopInfo(BasicBlock* header, base::Zone* zone)
      : _header(header),
        _parent(nullptr),
        _outgoing(zone),
        _members(nullptr),
        _insert_point(nullptr) {}

  void AddOutgoing(BasicBlock* bb) { _outgoing.push_back(bb); }

  int outgoing_count() const { return static_cast<int>(_outgoing.size()); }
  BasicBlock* outgoing_at(int index) const { return _outgoing[index]; }
};

enum class ScheduleState { kNone, kFixed, kSchedulable, kScheduled };

struct SchedulerData {
  ScheduleState _state;
  int _unscheduled_count;

  static SchedulerData Default() {
    return SchedulerData{ScheduleState::kNone, 0};
  }

  bool IsSchedulable() const { return _state == ScheduleState::kSchedulable; }
  bool IsScheduled() const { return _state == ScheduleState::kScheduled; }
  bool IsNone() const { return _state == ScheduleState::kNone; }
  bool IsFixed() const { return _state == ScheduleState::kFixed; }
};

class GraphLinearizer : public GraphZoneBase {
 private:
  ScheduleResult* _result;
  base::ZoneVector<SchedulerData> _node_data;
  base::ZoneVector<Node*> _schedule_root_nodes;
  base::ZoneVector<Node*> _fixed_nodes;
  CompilationOptions _options;

 public:
  GraphLinearizer(NodeGraph* graph, base::Zone* zone)
      : GraphZoneBase(graph, zone),
        _result(nullptr),
        _node_data(zone),
        _schedule_root_nodes(zone),
        _fixed_nodes(zone) {}

  void Run(ScheduleResult* result);

  ScheduleResult* schedule_result() const { return _result; }

  SchedulerData* GetNodeData(Node* node) {
    vmassert(node->index() < _node_data.size(), "node id out of range");
    return &_node_data[node->index()];
  }

  BasicBlock* block(Node* node) { return _result->block(node); }

  void AddBlock(BasicBlock* bb) {
    _result->set_block(bb->control(), bb);
    _result->AddBlock(bb);
  }

  int BasicBlockCount() const { return _result->BasicBlockCount(); }

  base::ZoneVector<Node*>& schedule_root_nodes() {
    return _schedule_root_nodes;
  }

  base::ZoneVector<Node*>& fixed_nodes() { return _fixed_nodes; }

  void AddScheduleRoot(Node* node) { _schedule_root_nodes.push_back(node); }

  void FixNode(BasicBlock* bb, Node* node) {
    auto data = GetNodeData(node);
    data->_state = ScheduleState::kFixed;
    AddNodeToBlock(bb, node);
  }

  void AddNodeToBlock(BasicBlock* bb, Node* node) {
    _result->set_block(node, bb);
    bb->AddNode(node);
  }

  void FixNodeToBlock(BasicBlock* bb, Node* node) {
    _result->set_block(node, bb);
    _fixed_nodes.push_back(node);
  }

  bool IsScheduled(Node* node) { return block(node) != nullptr; }

  ScheduleState GetScheduleState(Node* node) {
    return GetNodeData(node)->_state;
  }
  ScheduleState InitializeScheduleState(Node* node);

  void IncrementUnscheduledUseCount(Node* node) {
    auto data = GetNodeData(node);
    data->_unscheduled_count++;
  }
  BasicBlock* FindPredBB(Node* node);
  void PrintGraph();

  void set_options(CompilationOptions options) { _options = options; }
  CompilationOptions options() { return _options; }
};

}  // namespace node
}  // namespace son

#endif  // PRIMJS_SON_GRAPH_LINEARIZER_H
