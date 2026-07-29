/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_SON_NODE_BUILDER_H
#define PRIMJS_SON_NODE_BUILDER_H

#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"
#include "primjs/son/callDescriptor.h"
#include "primjs/son/node.h"

namespace son {
namespace node {

struct NodeMetaCache final {
#define DEF_NODE_CONSTANT(name, op, f, c, d, v) \
  NodeMeta name##_meta = {Opcode::OP_##op, MetaFlags::k##f, c, d, v};
#include "primjs/son/node.def"
};

struct ClosureInfo {
  int tid;
  int mid;
};

struct EnvInfo {
  int depth;
  int offset;
};

enum CallType {
  kSpecial,
  kStatic,
  kVirtual,
  kInterface,
  kSuper,
  kClosure,
};

struct CallInfo {
  CallType _type;
  int _mid;

  CallInfo(CallType type, int mid) : _type(type), _mid(mid) {}

  int as_int() const { return _mid | (_type << 16); }
  static CallInfo from_int(int value) {
    return CallInfo(static_cast<CallType>(value >> 16), value & 0xffff);
  }
  bool is_static() const { return _type == CallType::kStatic; }
  bool is_virtual() const { return _type == CallType::kVirtual; }
};

enum class ICmpCondition : uint8_t {
  // equal
  kEq,
  // not equal
  kNe,
  // unsigned greater than
  kUgt,
  // unsigned greater or equal
  kUge,
  // unsigned less than
  kUlt,
  // unsigned less or equal
  kUle,
  // signed greater than
  kSgt,
  // signed greater or equal
  kSge,
  // signed less than
  kSlt,
  // signed less or equal
  kSle,
};

enum class FCmpCondition : uint8_t {
  // false: no comparison, always returns false
  kAlwaysFalse,
  // oeq: ordered and equal
  kOeq,
  // ogt: ordered and greater than
  kOgt,
  // oge: ordered and greater than or equal
  kOge,
  // olt: ordered and less than
  kOlt,
  // ole: ordered and less than or equal
  kOle,
  // one: ordered and not equal
  kOne,
  // ord: ordered (no nans)
  KOrd,
  // ueq: unordered or equal
  kUeq,
  // ugt: unordered or greater than
  kUgt,
  // uge: unordered or greater than or equal
  kUge,
  // ult: unordered or less than
  kUlt,
  // ule: unordered or less than or equal
  kUle,
  // une: unordered or not equal
  kUne,
  // uno: unordered (either nans)
  kUno,
  // true: no comparison, always returns true
  kAlwaysTrue,
};

enum class RTSConvertType : uint8_t {
  kI2S,
  kJ2S,
  kD2S,
  kZ2S,
  kO2S,
  kJ2I,
  kI2J,
  kI2D,
  kD2I,
  kJ2D,
  kD2J,
};

enum class ConvertType : uint8_t {
  kZext,
  kSext,
  kTrunc,
  kCast,
  kBitCast,
  kIntToDouble,
  kDoubleToInt,
  kUIntToDouble,
  kDoubleToUInt,
};

enum class BranchHint : uint8_t { kNone, kTrue, kFalse };

class MessageInfo {
 private:
  char* _buffer;
  int _buffer_len;

 public:
  MessageInfo(base::Zone* zone, const char* buffer, int len)
      : _buffer_len(len + 1) {
    _buffer = (char*)zone->alloc(len + 1);
    memcpy((void*)_buffer, buffer, len);
    _buffer[len] = 0;
  }

  const char* buffer() const { return _buffer; }
  int buffer_len() const { return _buffer_len; }
};

class NodeBuilder {
 public:
  NodeBuilder(base::Zone* zone);

  Node* NewNode(const NodeMeta* meta, NodeType* type, int n, Node** inputs);
  const NodeMeta* NewMeta(Opcode opcode, MetaFlags f, int c, int d, int v);

  template <typename T>
  const NodeMeta* NewMeta1(Opcode opcode, MetaFlags f, int c, int d, int v,
                           T val);

#define DEF_NODE_CONSTANT(name, op, f, c, d, v) \
  const NodeMeta* name##_meta() const { return &_node_cache.name##_meta; }
#include "primjs/son/node.def"

  base::Zone* zone() const { return _zone; }

  const NodeMeta* Branch_meta(BranchHint hint = BranchHint::kNone);
  const NodeMeta* SwitchCase_meta(int value);
  const NodeMeta* Phi_meta(int n);
  const NodeMeta* Merge_meta(int n);
  const NodeMeta* Loop_meta(int n);
  const NodeMeta* DependPhi_meta(int n);
  const NodeMeta* Parameter_meta(int n);

  Node* NewPhi(int n, Node* control, Node* value);
  Node* NewDependPhi(int n, Node* control);
  Node* NewConstant(MachineType type, uint64_t n);

  const NodeMeta* End_meta(int control_in);
  const NodeMeta* Convert_meta(ConvertType type);

  const NodeMeta* ICmp_meta(ICmpCondition cond);
  const NodeMeta* FCmp_meta(FCmpCondition cond);

  const NodeMeta* ReadRegister_meta(int reg);
  const NodeMeta* WriteRegister_meta(int reg);

  const NodeMeta* FunctionPointer_meta(const CallDescriptor& desc);
  const NodeMeta* Call_meta(const CallDescriptor& desc, int n);
  const NodeMeta* TailCall_meta(const CallDescriptor& desc, int n);

  const NodeMeta* Message_meta(const char* msg) {
    auto ptr = (MessageInfo*)_zone->alloc(sizeof(MessageInfo));
    auto info = new (ptr) MessageInfo(_zone, msg, strlen(msg));
    return NewMeta1<MessageInfo*>(Opcode::OP_Message, MetaFlags::kNone, 0, 0, 0,
                                  info);
  }

  Node** input_buffer(int n) {
    if (n > _input_buffer_size) {
      _input_buffer_size = n + 16;
      _input_buffer =
          static_cast<Node**>(_zone->alloc(sizeof(Node*) * _input_buffer_size));
    }
    return _input_buffer;
  }

  void print_id(int idx) PUA_USED { _all_nodes[idx]->print(); }

  int node_count() const { return _node_count; }
  Node* replacement() const { return _debug_replacement; }
  void set_replacement(Node* replacement) { _debug_replacement = replacement; }

 private:
  base::Zone* _zone;
  Node* _debug_replacement;
  const NodeMetaCache _node_cache;
  base::ZoneMap<std::pair<MachineType, uint64_t>, Node*> _constant_cache;
  base::ZoneVector<Node*> _all_nodes;
  int _node_count;
  int _input_buffer_size = 0;
  Node** _input_buffer{nullptr};
};

template <typename T>
inline const NodeMeta* NodeBuilder::NewMeta1(Opcode opcode, MetaFlags f, int c,
                                             int d, int v, T val) {
  auto ptr = _zone->alloc(sizeof(NodeMeta1<T>));
  return new (ptr) NodeMeta1<T>(opcode, f, c, d, v, val);
}

std::ostream& operator<<(std::ostream& os, const CallType& type);
std::ostream& operator<<(std::ostream& os, const CallInfo& type);
std::ostream& operator<<(std::ostream& os, const ICmpCondition& cond);
std::ostream& operator<<(std::ostream& os, const ConvertType& type);

}  // namespace node
}  // namespace son
#endif  // PRIMJS_SON_NODE_BUILDER_H
