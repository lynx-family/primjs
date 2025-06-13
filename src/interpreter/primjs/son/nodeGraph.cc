// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/son/nodeGraph.h"

#include <iostream>

#include "primjs/son/graphVisitor.h"

#define REPEAT_6(V, T) \
  V(T) V(T, T) V(T, T, T) V(T, T, T, T) V(T, T, T, T, T) V(T, T, T, T, T, T)

namespace son {
namespace node {

NodeGraph::NodeGraph(base::Zone* zone)
    : _zone(zone),
      _builder(zone),
      _worklist(zone),
      _param_list(zone),
      _call_descriptors(zone) {
  auto start = builder()->NewNode(builder()->Start_meta(), nullptr, 0, nullptr);
  _root = start;
  _call_descriptors.InitCallDescriptors();
}

Node* NodeGraph::NewParameter(int n, NodeType* type) {
  auto const meta = _builder.Parameter_meta(n);
  auto res = _builder.NewNode(meta, type, 0, nullptr);
  AddParameter(res);
  return res;
}

template Node* NodeGraph::NewNodeImpl(const NodeMeta* meta, NodeType* type);
#define INSTANTIATE(...)                                                      \
  template Node* NodeGraph::NewNodeImpl(const NodeMeta* meta, NodeType* type, \
                                        __VA_ARGS__);
REPEAT_6(INSTANTIATE, node::Node*)
#undef INSTANTIATE

template <class... Args>
Node* NodeGraph::NewNodeImpl(const NodeMeta* meta, NodeType* type,
                             Args... args) {
  Node* argv[] = {args...};
  int argc = sizeof...(args);
  return _builder.NewNode(meta, type, argc, argv);
}

class PrintVisitor : public RPOVisitor {
 private:
  bool _use_json = false;

 public:
  PrintVisitor(NodeGraph* graph, bool use_json)
      : RPOVisitor(graph, graph->zone()), _use_json(use_json) {}

  VisitResult VisitNode(Node* node) override {
    if (_use_json) {
      if (node->meta()->has_control()) {
        node->print_json();
      }
    } else {
      std::cout << *node << std::endl;
    }
    return VisitResult::NoChange();
  }
};

void NodeGraph::print() {
  auto desc_data = GetCallDescriptor(call_descriptor());
  std::cout << "----------------------- " << desc_data->func_name()
            << "-----------------------\n";
  PrintVisitor visitor(this, false);
  visitor.VisitGraph();
}

void NodeGraph::print_json() {
  std::cout
      << "----------------------- dump node graph -----------------------\n";
  PrintVisitor visitor(this, true);
  std::cout << "[" << std::endl;
  visitor.VisitGraph();
  std::cout << "]" << std::endl;
}

void CFGVisitor::VisitGraph() {
  auto worklist = graph()->worklist();
  worklist.clear();
  graph()->AdvanceMarker();

  auto start = graph()->start();
  graph()->SetState(start, NodeState::kVisited);
  worklist.push_back(start);

  while (!worklist.empty()) {
    auto node = worklist.back();
    worklist.pop_back();
    auto result = VisitNode(node);
    if (!result.IsContinue()) {
      break;
    }
    auto use_list = node->use_list();
    for (auto node : use_list) {
      if (graph()->GetState(node) == NodeState::kUnvisited) {
        graph()->SetState(node, NodeState::kVisited);
        worklist.push_back(node);
      }
    }
  }
}

bool RPOVisitor::RecurseNode(NodeEdge& current, Node* node, int index) {
  auto input = node->input_at(index);
  if (input == node) {
    return false;
  }
  vmassert(input != node, "input is node");
  vmassert(input != nullptr, "input is null");
  if (graph()->GetState(input) < NodeState::kVisited) {
    Push(input, 0);
    current.set_index(index + 1);
    return true;
  }
  return false;
}

void RPOVisitor::VisitTop(NodeEdge& current) {
  auto node = current.node();
  if (node->opcode() == Opcode::OP_Dead) {
    Pop();
    return;
  }
  auto input_count = node->input_count();
  auto current_index = static_cast<int>(current.index());
  if (current_index >= input_count) {
    current_index = 0;
  }
  for (int i = current_index; i < input_count; i++) {
    if (RecurseNode(current, node, i)) {
      return;
    }
  }
  for (int i = 0; i < current_index; i++) {
    if (RecurseNode(current, node, i)) {
      return;
    }
  }
  auto result = VisitNode(node);
  if (!result.is_changed()) {
    Pop();
    return;
  }
  auto replacement = result.replacement();
  if (replacement != node) {
    Pop();
    ReplaceNode(node, replacement);
  } else {
    auto use_list = node->use_list();
    for (auto use_node : use_list) {
      if (use_node != node) {
        RevisitNode(use_node);
      }
    }
    // revisit this
    for (int i = 0; i < node->input_count(); i++) {
      if (RecurseNode(current, node, i)) {
        return;
      }
    }
    Pop();
  }
}

void RPOVisitor::ReplaceNode(Node* old_node, Node* new_node) {
  auto use_list = old_node->use_list();
  for (auto it = use_list.begin(); it != use_list.end(); ++it) {
    auto use_node = *it;
    auto use = it.use();
    use->UpdateTo(new_node);
    if (use_node != old_node) {
      RevisitNode(use_node);
    }
  }
  old_node->Kill(graph()->Dead_meta());
}

void RPOVisitor::VisitGraph() {
  graph()->AdvanceMarker();

  auto end = graph()->end();
  Push(end, 0);

  while (true) {
    if (!_stack.empty()) {
      NodeEdge& edge = _stack.back();
      VisitTop(edge);
    } else if (!_change_list.empty()) {
      auto node = _change_list.back();
      _change_list.pop_back();
      if (graph()->GetState(node) < NodeState::kVisited) {
        Push(node, 0);
      }
    } else {
      break;
    }
  }
}

void NodeEditor::ReplaceNode(Node* old_node, Node* new_node) {
  auto use_list = old_node->use_list();
  for (auto it = use_list.begin(); it != use_list.end(); ++it) {
    auto use = it.use();
    vmassert(new_node != nullptr, "must be");
    use->UpdateTo(new_node);
  }
  old_node->Kill(graph()->Dead_meta());
}

void NodeEditor::AddReturn(Node* node) {
  auto old_end = graph()->end();
  auto input_count = old_end->input_count();
  auto inputs = old_end->inputs();

  auto meta = graph()->builder()->End_meta(input_count + 1);
  auto end = graph()->builder()->NewNode(meta, nullptr, input_count, inputs);
  ReplaceNode(old_end, end);
  end->NewInput(input_count, node);
  graph()->set_end(end);
}

void NodeEditor::ReplaceWithBranch(Node* old_node, const ControlDepend& succ,
                                   const ControlDepend& exce, Node* value) {
  auto use_list = old_node->use_list();
  Node* if_exception = nullptr;
  for (auto it = use_list.begin(); it != use_list.end(); ++it) {
    auto use = it.use();
    auto use_node = use->node();
    if (it.IsControlIn()) {
      if (use_node->opcode() == Opcode::OP_IfSuccess) {
        ReplaceNode(use_node, succ.control());
      } else if (use_node->opcode() == Opcode::OP_IfException) {
        if_exception = use_node;
        if (exce.control() != nullptr) {
          ReplaceWithValue(use_node, exce.control(), exce.depend(), nullptr);
        } else {
          ++it;
        }
      } else {
        use->UpdateTo(succ.control());
      }
    } else if (it.IsDependIn()) {
      if (use_node->opcode() == Opcode::OP_IfException) {
        ++it;
      } else {
        use->UpdateTo(succ.depend());
      }
    } else {
      use->UpdateTo(value);
    }
  }
  if (if_exception == nullptr) {
    if (exce.control() != nullptr) {
      auto res = graph()->NewNode(graph()->ExceptionReturn_meta(), nullptr,
                                  exce.control(), exce.depend());
      AddReturn(res);
    }
  } else {
    if_exception->Kill(graph()->Dead_meta());
  }
  old_node->Kill(graph()->Dead_meta());
}

void NodeEditor::ReplaceWithValue(Node* old_node, Node* control, Node* depend,
                                  Node* value) {
  auto use_list = old_node->use_list();
  for (auto it = use_list.begin(); it != use_list.end(); ++it) {
    auto use = it.use();
    if (it.IsControlIn()) {
      vmassert(use->node()->opcode() != Opcode::OP_IfException, "must be");
      vmassert(use->node()->opcode() != Opcode::OP_IfSuccess, "must be");
      vmassert(control != nullptr, "must be");
      use->UpdateTo(control);
    } else if (it.IsDependIn()) {
      vmassert(depend != nullptr, "must be");
      use->UpdateTo(depend);
    } else {
      vmassert(value != nullptr, "must be");
      use->UpdateTo(value);
    }
  }
  old_node->Kill(graph()->Dead_meta());
}

}  // namespace node
}  // namespace son
