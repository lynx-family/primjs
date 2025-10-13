// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/son/node.h"

#include <iomanip>
#include <iostream>

#include "primjs/son/nodeBuilder.h"

namespace son {
namespace node {

void Node::NewInput(int idx, Node* node) {
  vmassert(idx < input_count() || idx < 0, "index out of range");
  vmassert(input_at(idx) == nullptr, "input already set");
  vmassert(!node->is_dead(), "input node cannot be nullptr");
  inputs()[idx] = node;
  auto use = GetUse(idx);
  node->AddUse(use);
}

void Node::ReplaceAllUses(Node* other) {
  auto use_list = this->use_list();
  for (auto it = use_list.begin(); it != use_list.end(); ++it) {
    auto use_node = *it;
    auto use = it.use();
    use->UpdateTo(other);
  }
}

void Node::ReplaceInput(int idx, Node* node) {
  vmassert(idx < input_count() || idx < 0, "index out of range");
  auto old = inputs()[idx];
  if (old != node) {
    auto use = GetUse(idx);
    if (old != nullptr) old->DeleteUse(use);
    inputs()[idx] = node;
    if (node != nullptr) node->AddUse(use);
  }
}

void Use::UpdateTo(Node* new_node) {
  vmassert(new_node != nullptr, "input node cannot be nullptr");
  Node* old_node = input_node();
  if (old_node != new_node) {
    if (old_node != nullptr) old_node->DeleteUse(this);
    *input_ptr() = new_node;
    if (new_node != nullptr) new_node->AddUse(this);
  }
}

void Node::AddUse(Use* use) {
  vmassert(_first_use == nullptr || _first_use->_prev == nullptr,
           "use already added");
  vmassert(this == use->input_node(), "use node not match");

  use->_next = _first_use;
  use->_prev = nullptr;
  if (_first_use != nullptr) {
    _first_use->_prev = use;
  }
  _first_use = use;
  vmassert(_first_use->_prev == nullptr, "use already added");
}

void Node::DeleteUse(Use* use) {
  vmassert(_first_use == nullptr || _first_use->_prev == nullptr, "must be");
  if (use->_prev != nullptr) {
    vmassert(_first_use != use, "must be");
    use->_prev->_next = use->_next;
  } else {
    vmassert(_first_use == use, "must be");
    _first_use = use->_next;
  }
  if (use->_next != nullptr) {
    use->_next->_prev = use->_prev;
  }
  vmassert(_first_use == nullptr || _first_use->_prev == nullptr, "must be");
}

void Node::Kill(const NodeMeta* meta) {
  for (int i = 0; i < input_count(); ++i) {
    auto input = input_at(i);
    set_input_at(i, nullptr);
    if (input != nullptr) {
      input->DeleteUse(GetUse(i));
    }
  }
  set_meta(meta);
}

bool Node::is_meta1() const {
  switch (opcode()) {
#define DEF_NODE_KIND(name, f, meta) \
  case Opcode::OP_##name:            \
    return MetaKind::kMeta1 == MetaKind::k##meta;
#include "primjs/son/node.def"
    default:
      unreachable();
      break;
  }
  return false;
}

std::ostream& operator<<(std::ostream& os, const Opcode& opcode) {
  static const char* opCodeStrings[] = {
#define DEF_NODE_KIND(name, f, meta) #name,
#include "primjs/son/node.def"
  };

  os << "OP_" << opCodeStrings[(unsigned)opcode];
  return os;
}

std::ostream& operator<<(std::ostream& os, const NodeMeta& meta) {
  os << meta._opcode;
  return os;
}

std::ostream& operator<<(std::ostream& os, const ICmpCondition& cond) {
  switch (cond) {
    case ICmpCondition::kEq:
      os << "eq";
      break;
    case ICmpCondition::kNe:
      os << "ne";
      break;
    case ICmpCondition::kSlt:
      os << "slt";
      break;
    case ICmpCondition::kSle:
      os << "sle";
      break;
    case ICmpCondition::kSgt:
      os << "sgt";
      break;
    case ICmpCondition::kSge:
      os << "sge";
      break;
    case ICmpCondition::kUge:
      os << "uge";
      break;
    default:
      os << "unknown";
      break;
  }
  return os;
}

namespace {
void print_type(std::ostream& os, MachineType type) {
  switch (type) {
    case MachineType::kInt32:
      os << "int";
      break;
    case MachineType::kFloat64:
      os << "double";
      break;
    case MachineType::kInt64:
      os << "long";
      break;
    case MachineType::kBool:
      os << "boolean";
      break;
    case MachineType::kInt8:
      os << "int8";
      break;
    case MachineType::kInt16:
      os << "int16";
      break;
    case MachineType::kRawType:
      os << "raw type";
      break;
    case MachineType::kIntptr:
      os << "intptr";
      break;
    case MachineType::kNone:
      os << "none";
      break;
    default:
      os << "unknown";
      break;
  }
}

void print_node(std::ostream& os, Node* node) {
  os << node->index() << ": " << *node->meta();
  if (node->opcode() == Opcode::OP_Constant) {
    os << "#";
    auto basic_type = node->type()->machine_type();
    print_type(os, basic_type);
    os << ": " << node->meta_value<int64_t>();
  }
}
}  // namespace

void Node::print() const { std::cout << *this << std::endl; }

void Node::print_json() {
  std::cout << std::dec << "{\"id\":" << _idx;
  std::cout << ", \"label\":\"" << opcode();
  std::cout << " " << _idx << ": " << _debug_offset << "\"";
  std::cout << ",\"in\":[";
  for (int i = 0; i < input_count(); ++i) {
    if (i >= meta()->_control_in) {
      continue;
    }
    auto input = input_at(i);
    if (i != 0) std::cout << ", ";
    if (input != nullptr) {
      std::cout << input->index();
    }
  }
  std::cout << "], \"out\":[";
  int i = 0;
  for (auto use : this->const_use_list()) {
    if (i != 0) std::cout << ", ";
    if (use != nullptr) {
      std::cout << use->index();
    }
    i++;
  }
  std::cout << "]}," << std::endl;
}

std::ostream& operator<<(std::ostream& os, const NodeType& type) {
  print_type(os, type.machine_type());
  return os;
}

std::ostream& operator<<(std::ostream& os, const CallType& type) {
  switch (type) {
    case CallType::kSpecial:
      os << "special";
      break;
    case CallType::kStatic:
      os << "static";
      break;
    case CallType::kVirtual:
      os << "virtual";
      break;
    case CallType::kInterface:
      os << "interface";
      break;
    case CallType::kSuper:
      os << "super";
      break;
    case CallType::kClosure:
      os << "closure";
      break;
    default:
      unreachable();
      break;
  }
  return os;
}
std::ostream& operator<<(std::ostream& os, const CallInfo& info) {
  os << info._type << " " << info._mid;
  return os;
}

std::ostream& operator<<(std::ostream& os, const CallKind& kind) {
  switch (kind) {
    case CallKind::kRuntime:
      os << "call runtime";
      break;
    case CallKind::kStub:
      os << "call stub";
      break;
    case CallKind::kRTS:
      os << "call rts";
      break;
    case CallKind::kBcHandler:
      os << "call bc handler";
      break;
    case CallKind::kBcHandler1:
      os << "call bc handler 1";
      break;
    case CallKind::kBcHandler2:
      os << "call bc handler 2";
      break;
    default:
      unreachable();
      break;
  }
  return os;
}

std::ostream& operator<<(std::ostream& os, const ConvertType& type) {
  switch (type) {
    case ConvertType::kCast:
      os << "cast";
      break;
    case ConvertType::kZext:
      os << "zext";
      break;
    case ConvertType::kSext:
      os << "sext";
      break;
    case ConvertType::kTrunc:
      os << "trunc";
      break;
    case ConvertType::kBitCast:
      os << "bit cast";
      break;
    case ConvertType::kIntToDouble:
      os << "int to double";
      break;
    case ConvertType::kDoubleToInt:
      os << "double to int";
      break;
    default:
      unreachable();
      break;
  }
  return os;
}

std::ostream& operator<<(std::ostream& os, const CallDescriptor& info) {
  os << info.kind() << ": ";

  CallId call_runtime_id = static_cast<CallId>(info.call_index());
  switch (call_runtime_id) {
#define DEF_CALL_RUNTIME(name, ...) \
  case CallId::k##name:             \
    os << #name;                    \
    break;
#include "primjs/son/vmTrampoline.def"
    break;
    default:
      os << "unknown " << info.call_index();
      break;
  }
  return os;
}

std::ostream& operator<<(std::ostream& os, const Node& node) {
  os << std::setfill('0') << std::setw(4) << std::hex << node.debug_offset();
  os << " " << std::dec << std::setfill(' ') << std::setw(4) << node.index();
  os << ": " << *node.meta();
  os << "(";
  if (node.input_count() != 0) {
    for (int i = 0; i < node.input_count(); ++i) {
      auto input = node.input_at(i);
      if (i != 0) os << ", ";
      if (input != nullptr) {
        print_node(os, input);
      } else {
        os << "null";
      }
    }
  }
  os << ")";

  if (node.meta()->has_control()) {
    int i = 0;
    os << " [";
    Node* current_node = const_cast<Node*>(&node);
    for (auto use : current_node->const_use_list()) {
      if (i != 0) os << ", ";
      if (use != nullptr) {
        print_node(os, use);
      } else {
        std::cout << "null";
      }
      i++;
    }
    os << "]";
  }
  if (node.is_meta1()) {
    if (node.opcode() == Opcode::OP_Call) {
      os << " #" << node.meta_value<CallDescriptor>();
    } else if (node.opcode() == Opcode::OP_ICmp) {
      os << " #" << node.meta_value<ICmpCondition>();
    } else if (node.opcode() == Opcode::OP_Convert) {
      os << " #" << node.meta_value<ConvertType>();
    } else {
      os << " value: #" << node.meta_value<int>();
    }
  }
  if (node.type() != nullptr) {
    os << " type: " << *node.type();
  }
  return os;
}

}  // namespace node
}  // namespace son
