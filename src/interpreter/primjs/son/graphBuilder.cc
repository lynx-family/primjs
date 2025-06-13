// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/son/graphBuilder.h"

#define REPEAT_10(V, T)        \
  V(T)                         \
  V(T, T)                      \
  V(T, T, T)                   \
  V(T, T, T, T)                \
  V(T, T, T, T, T)             \
  V(T, T, T, T, T, T)          \
  V(T, T, T, T, T, T, T)       \
  V(T, T, T, T, T, T, T, T)    \
  V(T, T, T, T, T, T, T, T, T) \
  V(T, T, T, T, T, T, T, T, T, T)

namespace son {
namespace node {

Node* GraphBuilder::Branch(Node* condition, Label* true_label,
                           Label* false_label, BranchHint hint) {
  auto current = env()->current_label();
  auto branch = Branch(current->control(), condition, hint);
  current->set_control(branch);
  auto if_true = IfTrue(branch);
  true_label->impl()->AppendPred(current, if_true);
  auto if_false = IfFalse(branch);
  false_label->impl()->AppendPred(current, if_false);
  env()->set_current_label(nullptr);
  return branch;
}

void GraphBuilder::BranchIf(Node* condition, Label* true_label,
                            BranchHint hint) {
  Label false_label(this);
  Branch(condition, true_label, &false_label, hint);
  Bind(&false_label);
}

void GraphBuilder::BranchIfFalse(Node* condition, Label* false_label,
                                 BranchHint hint) {
  Label true_label(this);
  Branch(condition, &true_label, false_label, hint);
  Bind(&true_label);
}

GraphBuilder* GraphBuilder::Switch(Node* condition) {
  auto current = env()->current_label();
  auto switch_branch = Switch(current->control(), condition);
  current->set_control(switch_branch);
  return this;
}

GraphBuilder* GraphBuilder::Case(int32_t value, Label* target) {
  auto current = env()->current_label();
  auto switch_case = SwitchCase(current->control(), value);
  target->impl()->AppendPred(current, switch_case);
  return this;
}

void GraphBuilder::Default(Label* target) {
  auto current = env()->current_label();
  auto default_case = DefaultCase(current->control());
  target->impl()->AppendPred(current, default_case);
  env()->set_current_label(nullptr);
}

void GraphBuilder::Jump(Label* target) {
  auto current = env()->current_label();
  target->impl()->AppendPred(current, nullptr);
  env()->set_current_label(nullptr);
}

void GraphBuilder::Goto(Label* target) {
  auto current = env()->current_label();
  auto goto_node = Goto(current->control());
  target->impl()->AppendPred(current, goto_node);
  env()->set_current_label(nullptr);
}

Node* GraphBuilder::LoadImpl(MachineType type, Node* object, Node* offset) {
  auto meta = graph()->Load_meta();
  auto node_type = NodeType::GetNodeType(type);
  if (offset == nullptr) offset = IntValue(0);
  auto res =
      graph()->NewNode(meta, node_type, control(), depend(), object, offset);
  set_depend(res);
  return res;
}

void GraphBuilder::StoreImpl(MachineType type, Node* object, Node* offset,
                             Node* value) {
  auto meta = graph()->Store_meta();
  auto node_type = NodeType::GetNodeType(type);
  if (offset == nullptr) offset = IntValue(0);
  auto res = graph()->NewNode(meta, node_type, control(), depend(), object,
                              offset, value);
  set_depend(res);
}

Node* GraphBuilder::Return(Node* value) {
  auto type = NodeType::NoneType();
  Node* res = nullptr;
  if (value == nullptr) {
    auto meta = graph()->Return0_meta();
    res = graph()->NewNode(meta, type, control(), depend());
  } else {
    auto meta = graph()->Return1_meta();
    res = graph()->NewNode(meta, type, control(), depend(), value);
  }
  set_depend(res);
  set_control(res);
  _exit_list.push_back(res);
  return res;
}

Node* GraphBuilder::Unreachable() {
  auto res = graph()->NewNode(graph()->Unreachable_meta(), nullptr, control(),
                              depend());
  set_depend(res);
  set_control(res);
  _exit_list.push_back(res);
  return res;
}

template Node* GraphBuilder::CallImpl(const CallDescriptor& desc, bool tail);
#define INSTANTIATE(...)                                                       \
  template Node* GraphBuilder::CallImpl(const CallDescriptor& desc, bool tail, \
                                        __VA_ARGS__);
REPEAT_10(INSTANTIATE, Node*)
#undef INSTANTIATE

template <class... Args>
Node* GraphBuilder::CallImpl(const CallDescriptor& desc, bool tail,
                             Args... args) {
  Node* argv[] = {control(), depend(), args...};
  // control, depend, thread
  int argc = sizeof...(args) + 2;
  // -2: control, depend
  const NodeMeta* meta = nullptr;
  if (tail) {
    meta = graph()->TailCall_meta(desc, argc - 2);
  } else {
    meta = graph()->Call_meta(desc, argc - 2);
  }
  auto desc_data = graph()->GetCallDescriptor(desc);
  auto type = NodeType::GetNodeType(desc_data->return_type());
  auto res = graph()->builder()->NewNode(meta, type, argc, argv);
  if (desc.meta_flags() != MetaFlags::kNone) {
    set_depend(res);
  }
  if (desc.meta_flags() == MetaFlags::kThrow) {
    set_control(res);
  }
  return res;
}

void GraphBuilder::End() {
  int input_count = static_cast<int>(_exit_list.size());
  Node** inputs = &_exit_list.front();
  auto meta = graph()->builder()->End_meta(input_count);
  auto end = graph()->builder()->NewNode(meta, nullptr, input_count, inputs);
  graph()->set_end(end);
}

}  // namespace node
}  // namespace son
