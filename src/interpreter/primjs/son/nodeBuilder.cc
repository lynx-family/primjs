/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */

#include "primjs/son/nodeBuilder.h"

namespace son {
namespace node {

static NodeMetaCache* GetNodeMetaCache() {
  static NodeMetaCache cache{};
  return &cache;
}

NodeBuilder::NodeBuilder(base::Zone* zone)
    : _zone(zone),
      _debug_replacement(nullptr),
      _node_cache(*GetNodeMetaCache()),
      _constant_cache(zone),
      _all_nodes(zone),
      _node_count(0) {}

Node* NodeBuilder::NewNode(const NodeMeta* meta, NodeType* type, int n,
                           Node** inputs) {
  int input_count = meta->intput_count();
  vmassert(input_count >= n, "input count not match");
  auto alloc_size = input_count * (sizeof(Node*) + sizeof(Use)) + sizeof(Node);
  auto ptr = (uint8_t*)_zone->alloc(alloc_size);
  ptr += input_count * sizeof(Use);

  auto node = new (ptr) Node(meta, _node_count++, type);
  for (int i = 0; i < input_count; ++i) {
    auto use = node->GetUse(i);
    use->_prev = nullptr;
    use->_next = nullptr;
    use->_input_index = i;
    node->set_input_at(i, nullptr);
  }
  for (int i = 0; i < n; ++i) {
    node->NewInput(i, inputs[i]);
  }
  for (int i = n; i < input_count; ++i) {
    node->set_input_at(i, nullptr);
  }
  _all_nodes.emplace_back(node);
  if (_debug_replacement != nullptr) {
    node->set_debug_offset(_debug_replacement->debug_offset());
  }
  return node;
}

Node* NodeBuilder::NewPhi(int n, Node* control, Node* value) {
  auto const meta = Phi_meta(n);
  Node* inputs[] = {control, value};
  return NewNode(meta, value->type(), 2, inputs);
}

Node* NodeBuilder::NewConstant(MachineType basic_type, uint64_t n) {
  auto it = _constant_cache.find({basic_type, n});
  if (it != _constant_cache.end()) {
    return it->second;
  }
  auto const meta =
      NewMeta1<uint64_t>(Opcode::OP_Constant, MetaFlags::kNone, 0, 0, 0, n);
  auto node_type = NodeType::GetNodeType(basic_type);
  auto res = NewNode(meta, node_type, 0, nullptr);
  _constant_cache[{basic_type, n}] = res;
  return res;
}

const NodeMeta* NodeBuilder::End_meta(int control_in) {
  return NewMeta(Opcode::OP_End, MetaFlags::kControl, control_in, 0, 0);
}

const NodeMeta* NodeBuilder::Branch_meta(BranchHint hint) {
  return NewMeta1<BranchHint>(Opcode::OP_Branch, MetaFlags::kControl, 1, 0, 1,
                              hint);
}

const NodeMeta* NodeBuilder::SwitchCase_meta(int value) {
  return NewMeta1<int>(Opcode::OP_SwitchCase, MetaFlags::kControl, 1, 0, 0,
                       value);
}

const NodeMeta* NodeBuilder::Convert_meta(ConvertType type) {
  return NewMeta1<ConvertType>(Opcode::OP_Convert, MetaFlags::kNone, 0, 0, 1,
                               type);
}

const NodeMeta* NodeBuilder::ICmp_meta(ICmpCondition cond) {
  return NewMeta1<ICmpCondition>(Opcode::OP_ICmp, MetaFlags::kNone, 0, 0, 2,
                                 cond);
}

const NodeMeta* NodeBuilder::FCmp_meta(FCmpCondition cond) {
  return NewMeta1<FCmpCondition>(Opcode::OP_FCmp, MetaFlags::kNone, 0, 0, 2,
                                 cond);
}

Node* NodeBuilder::NewDependPhi(int n, Node* control) {
  auto const meta = DependPhi_meta(n);
  Node* inputs[] = {control};
  return NewNode(meta, nullptr, 1, inputs);
}

const NodeMeta* NodeBuilder::NewMeta(Opcode opcode, MetaFlags f, int c, int d,
                                     int v) {
  auto ptr = (NodeMeta*)_zone->alloc(sizeof(NodeMeta));
  ptr->_opcode = opcode;
  ptr->_flags = f;
  ptr->_control_in = c;
  ptr->_depend_in = d;
  ptr->_value_in = v;
  return ptr;
}

const NodeMeta* NodeBuilder::Phi_meta(int n) {
  if (n == 1) {
    return Phi1_meta();
  } else if (n == 2) {
    return Phi2_meta();
  } else if (n == 3) {
    return Phi3_meta();
  }
  return NewMeta(Opcode::OP_Phi, MetaFlags::kNone, 1, 0, n);
}

const NodeMeta* NodeBuilder::Parameter_meta(int n) {
  return NewMeta1<int>(Opcode::OP_Parameter, MetaFlags::kNone, 0, 0, 0, n);
}

const NodeMeta* NodeBuilder::ReadRegister_meta(int reg) {
  return NewMeta1<int>(Opcode::OP_ReadRegister, MetaFlags::kNone, 1, 1, 0, reg);
}
const NodeMeta* NodeBuilder::WriteRegister_meta(int reg) {
  return NewMeta1<int>(Opcode::OP_WriteRegister, MetaFlags::kNone, 1, 1, 1,
                       reg);
}

const NodeMeta* NodeBuilder::Merge_meta(int n) {
  if (n == 1) {
    return Merge1_meta();
  } else if (n == 2) {
    return Merge2_meta();
  } else if (n == 3) {
    return Merge3_meta();
  }
  return NewMeta(Opcode::OP_Merge, MetaFlags::kControl, n, 0, 0);
}

const NodeMeta* NodeBuilder::Loop_meta(int n) {
  if (n == 1) {
    return Loop1_meta();
  } else if (n == 2) {
    return Loop2_meta();
  } else if (n == 3) {
    return Loop3_meta();
  }
  return NewMeta(Opcode::OP_Loop, MetaFlags::kControl, n, 0, 0);
}

const NodeMeta* NodeBuilder::DependPhi_meta(int n) {
  if (n == 1) {
    return DependPhi1_meta();
  } else if (n == 2) {
    return DependPhi2_meta();
  } else if (n == 3) {
    return DependPhi3_meta();
  }
  return NewMeta(Opcode::OP_DependPhi, MetaFlags::kNone, 1, n, 0);
}

const NodeMeta* NodeBuilder::FunctionPointer_meta(const CallDescriptor& desc) {
  return NewMeta1<CallDescriptor>(Opcode::OP_FunctionPointer, MetaFlags::kNone,
                                  0, 0, 0, desc);
}

const NodeMeta* NodeBuilder::Call_meta(const CallDescriptor& desc, int n) {
  auto flags = desc.meta_flags();
  int c = desc.meta_flags() == MetaFlags::kThrow ? 1 : 0;
  int d = desc.meta_flags() == MetaFlags::kNone ? 0 : 1;
  return NewMeta1<CallDescriptor>(Opcode::OP_Call, flags, c, d, n, desc);
}

const NodeMeta* NodeBuilder::TailCall_meta(const CallDescriptor& desc, int n) {
  auto flags = desc.meta_flags();
  int c = desc.meta_flags() == MetaFlags::kThrow ? 1 : 0;
  int d = desc.meta_flags() == MetaFlags::kNone ? 0 : 1;
  return NewMeta1<CallDescriptor>(Opcode::OP_TailCall, flags, c, d, n, desc);
}

}  // namespace node
}  // namespace son
