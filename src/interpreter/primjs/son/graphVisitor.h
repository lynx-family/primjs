// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef RTSVM_SON_GRAPH_VISITOR_H_
#define RTSVM_SON_GRAPH_VISITOR_H_

#include "primjs/son/nodeGraph.h"

namespace son {
namespace node {

class NodeGraph;
enum class GraphVisitState : uint8_t {
  kContinue = 0,
  kNoChang,
  kRemove,
  kReplace,
  kAbort,
};

class VisitResult {
 private:
  Node* _replacement;
  GraphVisitState _state;

 public:
  VisitResult(Node* replacement)
      : _replacement(replacement), _state(GraphVisitState::kReplace) {}
  VisitResult() : _replacement(nullptr), _state(GraphVisitState::kNoChang) {}

  VisitResult(GraphVisitState state) : _replacement(nullptr), _state(state) {}

  bool IsContinue() const { return _state == GraphVisitState::kContinue; }
  bool is_changed() const { return _state != GraphVisitState::kNoChang; }

  Node* replacement() const { return _replacement; }

  static VisitResult Continue() {
    return VisitResult(GraphVisitState::kContinue);
  }
  static VisitResult Abort() { return VisitResult(GraphVisitState::kAbort); }
  static VisitResult NoChange() { return VisitResult(); }
  static VisitResult Replacement(Node* node) { return VisitResult(node); }
  static VisitResult Remove() { return VisitResult(GraphVisitState::kRemove); }
};

class NodeVisitor {
 private:
  NodeGraph* _graph;

 public:
  NodeVisitor(NodeGraph* graph) : _graph(graph) {}

  NodeGraph* graph() const { return _graph; }
  virtual ~NodeVisitor() = default;
  virtual VisitResult VisitNode(Node* node) = 0;
};

class CFGVisitor : public NodeVisitor {
 public:
  CFGVisitor(NodeGraph* graph) : NodeVisitor(graph) {}

  void VisitGraph();
};

class NodeEdge {
 private:
  Node* _node;
  size_t _index;

 public:
  NodeEdge(Node* node, size_t index) : _node(node), _index(index) {}
  Node* node() const { return _node; }
  size_t index() const { return _index; }
  void set_node(Node* node) { _node = node; }
  void set_index(size_t index) { _index = index; }
  void inc_index() { ++_index; }
  Node* to() const { return _node; }
  Node* from() const { return node()->input_at(_index); }
};

class ControlDepend {
 private:
  Node* _control;
  Node* _depend;

 public:
  ControlDepend() : _control(nullptr), _depend(nullptr) {}
  ControlDepend(Node* control, Node* depend)
      : _control(control), _depend(depend) {}

  Node* control() const { return _control; }
  Node* depend() const { return _depend; }
  void set_control(Node* control) { _control = control; }
  void set_depend(Node* depend) { _depend = depend; }
};

class RPOVisitor : public NodeVisitor {
 private:
  base::ZoneVector<NodeEdge> _stack;
  base::ZoneVector<Node*> _change_list;

 public:
  RPOVisitor(NodeGraph* graph, base::Zone* zone)
      : NodeVisitor(graph), _stack(zone), _change_list(zone) {}

  virtual ~RPOVisitor() = default;
  void VisitGraph();

  node::Node* current_node() { return _stack.back().node(); }

 private:
  void VisitTop(NodeEdge& edge);

  void ReplaceNode(Node* old_node, Node* new_node);
  bool RecurseNode(NodeEdge& current, Node* node, int index);

  void Push(Node* node, size_t index) {
    _stack.push_back(NodeEdge{node, index});
    graph()->SetState(node, NodeState::kVisited);
  }

  void PushChanged(Node* node) {
    _change_list.push_back(node);
    graph()->SetState(node, NodeState::kPreVisit);
  }

  void RevisitNode(Node* node) {
    if (graph()->GetState(node) == NodeState::kFinished) {
      PushChanged(node);
    }
  }

  void Pop() {
    auto edge = _stack.back();
    _stack.pop_back();
    graph()->SetState(edge.node(), NodeState::kFinished);
  }
};

class NodeEditor {
 private:
  NodeGraph* _graph;

 public:
  NodeEditor(NodeGraph* graph) : _graph(graph) {}

  NodeGraph* graph() const { return _graph; }
  void ReplaceNode(Node* old_node, Node* new_node);
  void ReplaceWithValue(Node* old_node, Node* control, Node* depend,
                        Node* value);
  void ReplaceWithBranch(Node* old_node, const ControlDepend& succ,
                         const ControlDepend& exce, Node* value);
  void AddReturn(Node* node);
};

class DebugScope {
 private:
  NodeGraph* _graph;

 public:
  DebugScope(NodeGraph* graph, Node* current) : _graph(graph) {
    _graph->set_replacement(current);
  }
  ~DebugScope() { _graph->set_replacement(nullptr); }
};

}  // namespace node
}  // namespace son
#endif  // RTSVM_SON_GRAPH_VISITOR_H_
