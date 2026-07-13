// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_SON_GRAPH_BUILDER_H
#define PRIMJS_SON_GRAPH_BUILDER_H

#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"
#include "primjs/son/callDescriptor.h"
#include "primjs/son/graphAssembler.h"
#include "primjs/son/nodeGraph.h"

namespace son {
namespace node {

class GraphBuilder {
 private:
  GraphEnvironment* _env;
  NodeGraph* _graph;
  base::Zone* _zone;
  base::ZoneVector<Node*> _exit_list;

 public:
  GraphBuilder(NodeGraph* graph, base::Zone* zone)
      : _env(nullptr), _graph(graph), _zone(zone), _exit_list(zone) {}

  GraphEnvironment* env() const { return _env; }
  void set_env(GraphEnvironment* env) {
    env->set_builder(this);
    _env = env;
  }

  Node* control() const { return _env->current_label()->control(); }

  void set_control(Node* node) {
    return _env->current_label()->set_control(node);
  }

  Node* depend() const { return _env->current_label()->depend(); }

  void set_depend(Node* node) {
    return _env->current_label()->set_depend(node);
  }

  base::Zone* zone() const { return _zone; }
  NodeGraph* graph() const { return _graph; }
  bool Is32Bit() { return graph()->options().Is32Bit(); }
  bool IsDebugger() { return graph()->options().SupportDebugger(); }
  bool IsHost() { return graph()->options().IsHost(); }
  bool IsDebugTrace() { return graph()->options().IsDebugTrace(); }
  Node* Branch(Node* condition, Label* true_label, Label* false_label,
               BranchHint hint = BranchHint::kNone);

  void BranchIf(Node* condition, Label* true_label,
                BranchHint hint = BranchHint::kNone);
  void BranchIfFalse(Node* condition, Label* false_label,
                     BranchHint hint = BranchHint::kNone);
  GraphBuilder* Switch(Node* condition);
  GraphBuilder* Case(int32_t value, Label* target);

  void Default(Label* target);
  void Jump(Label* target);
  void Goto(Label* target);
  void Bind(Label* target);
  void BindLoop(Label* target, int pred_size);
  void BindLoopWithoutJump(Label* target, int pred_size);

  Node* Branch(Node* control, Node* condition,
               BranchHint hint = BranchHint::kNone) {
    return graph()->NewNode(graph()->Branch_meta(hint), nullptr, control,
                            condition);
  }

  Node* IfTrue(Node* control) {
    return graph()->NewNode(graph()->IfTrue_meta(), nullptr, control);
  }
  Node* IfFalse(Node* control) {
    return graph()->NewNode(graph()->IfFalse_meta(), nullptr, control);
  }
  Node* Switch(Node* control, Node* condition) {
    return graph()->NewNode(graph()->Switch_meta(), nullptr, control,
                            condition);
  }
  Node* SwitchCase(Node* control, int32_t value) {
    return graph()->NewNode(graph()->SwitchCase_meta(value), nullptr, control);
  }
  Node* DefaultCase(Node* control) {
    return graph()->NewNode(graph()->DefaultCase_meta(), nullptr, control);
  }
  Node* Goto(Node* control) {
    return graph()->NewNode(graph()->Goto_meta(), nullptr, control);
  }
  Node* Merge(int n) {
    return graph()->NewNode(graph()->Merge_meta(n), nullptr);
  }
  Node* Loop(int n) { return graph()->NewNode(graph()->Loop_meta(n), nullptr); }
  Node* DependPhi(int n, Node* control) {
    return graph()->NewNode(graph()->DependPhi_meta(n), nullptr, control);
  }
  Node* Phi(int n, Node* control, NodeType* type) {
    return graph()->NewNode(graph()->Phi_meta(n), type, control);
  }
  Node* NullptrValue() {
    return graph()->NewConstant(MachineType::kRawType, 0);
  }
  Node* IntValue(int n) {
    return graph()->NewConstant(MachineType::kInt32, static_cast<uint64_t>(n));
  }
  Node* Int32Value(int n) { return IntValue(n); }
  Node* BooleanValue(bool v) {
    return graph()->NewConstant(MachineType::kBool, static_cast<uint64_t>(v));
  }
  Node* IntPtrValue(intptr_t n) {
    return graph()->NewConstant(MachineType::kIntptr, static_cast<uint64_t>(n));
  }
  Node* Int8Value(int n) {
    return graph()->NewConstant(MachineType::kInt8, static_cast<uint64_t>(n));
  }
  Node* Int16Value(int n) {
    return graph()->NewConstant(MachineType::kInt16, static_cast<uint64_t>(n));
  }
  Node* Int64Value(uint64_t n) {
    return graph()->NewConstant(MachineType::kInt64, n);
  }
  Node* DoubleValue(double n) {
    return graph()->NewConstant(MachineType::kFloat64, base::bit_cast(n));
  }
  Node* ConstantValue(MachineType machine_type, uint64_t value) {
    return graph()->NewConstant(machine_type, value);
  }
  Node* CurrentThread() {
    return graph()->GetParameter(RTSCallArgIndex::kThread);
  }
  Node* CurrentMethod() {
    return graph()->GetParameter(RTSCallArgIndex::kCalleeMethod);
  }

  Node* Equal(Node* left, Node* right) {
    auto type = left->type()->machine_type();
    vmassert(type == right->type()->machine_type(), "type not equal");
    auto res_type = MachineType::kBool;
    if (type == MachineType::kFloat64) {
      return BinaryOp(graph()->FCmp_meta(FCmpCondition::kOeq), res_type, left,
                      right);
    } else {
      return BinaryOp(graph()->ICmp_meta(ICmpCondition::kEq), res_type, left,
                      right);
    }
  }
  Node* NotEqual(Node* left, Node* right) {
    auto type = left->type()->machine_type();
    auto res_type = MachineType::kBool;
    if (type == MachineType::kFloat64) {
      return BinaryOp(graph()->FCmp_meta(FCmpCondition::kOne), res_type, left,
                      right);
    } else {
      return BinaryOp(graph()->ICmp_meta(ICmpCondition::kNe), res_type, left,
                      right);
    }
  }
  Node* LessThanOrEqual(Node* left, Node* right) {
    auto type = left->type()->machine_type();
    auto res_type = MachineType::kBool;
    if (type == MachineType::kFloat64) {
      return BinaryOp(graph()->FCmp_meta(FCmpCondition::kOle), res_type, left,
                      right);
    } else {
      return BinaryOp(graph()->ICmp_meta(ICmpCondition::kSle), res_type, left,
                      right);
    }
  }
  Node* GreaterThanOrEqual(Node* left, Node* right) {
    auto type = left->type()->machine_type();
    auto res_type = MachineType::kBool;
    if (type == MachineType::kFloat64) {
      return BinaryOp(graph()->FCmp_meta(FCmpCondition::kOge), res_type, left,
                      right);
    } else {
      return BinaryOp(graph()->ICmp_meta(ICmpCondition::kSge), res_type, left,
                      right);
    }
  }
  Node* UnsignedGreaterThanOrEqual(Node* left, Node* right) {
    auto res_type = MachineType::kBool;
    return BinaryOp(graph()->ICmp_meta(ICmpCondition::kUge), res_type, left,
                    right);
  }
  Node* UnsignedGreaterThan(Node* left, Node* right) {
    auto res_type = MachineType::kBool;
    return BinaryOp(graph()->ICmp_meta(ICmpCondition::kUgt), res_type, left,
                    right);
  }
  Node* UnsignedLessThanOrEqual(Node* left, Node* right) {
    auto res_type = MachineType::kBool;
    return BinaryOp(graph()->ICmp_meta(ICmpCondition::kUle), res_type, left,
                    right);
  }
  Node* UnsignedLessThan(Node* left, Node* right) {
    auto res_type = MachineType::kBool;
    return BinaryOp(graph()->ICmp_meta(ICmpCondition::kUlt), res_type, left,
                    right);
  }
  Node* LessThan(Node* left, Node* right) {
    auto type = left->type()->machine_type();
    vmassert(type == right->type()->machine_type(), "type not equal");
    auto res_type = MachineType::kBool;
    if (type == MachineType::kFloat64) {
      return BinaryOp(graph()->FCmp_meta(FCmpCondition::kOlt), res_type, left,
                      right);
    } else {
      return BinaryOp(graph()->ICmp_meta(ICmpCondition::kSlt), res_type, left,
                      right);
    }
  }
  Node* GreaterThan(Node* left, Node* right) {
    auto type = left->type()->machine_type();
    auto res_type = MachineType::kBool;
    if (type == MachineType::kFloat64) {
      return BinaryOp(graph()->FCmp_meta(FCmpCondition::kOgt), res_type, left,
                      right);
    } else {
      return BinaryOp(graph()->ICmp_meta(ICmpCondition::kSgt), res_type, left,
                      right);
    }
  }
  Node* LoadImpl(MachineType type, Node* object, Node* offset = nullptr);
  void StoreImpl(MachineType type, Node* object, Node* offset, Node* value);
  Node* Return(Node* value = nullptr);
  Node* Unreachable();

  Node* BinaryOp(const NodeMeta* meta, MachineType machine_type, Node* left,
                 Node* right) {
    auto type = NodeType::GetNodeType(machine_type);
    return graph()->NewNode(meta, type, left, right);
  }

  Node* UnaryOp(const NodeMeta* meta, MachineType machine_type, Node* value) {
    auto type = NodeType::GetNodeType(machine_type);
    return graph()->NewNode(meta, type, value);
  }

  Node* IntPtrAdd(Node* left, Node* right) {
    return BinaryOp(graph()->Add_meta(), MachineType::kIntptr, left, right);
  }
  Node* IntPtrSub(Node* left, Node* right) {
    return BinaryOp(graph()->Sub_meta(), MachineType::kIntptr, left, right);
  }
  Node* IntPtrMul(Node* left, Node* right) {
    return BinaryOp(graph()->Mul_meta(), MachineType::kIntptr, left, right);
  }

  Node* Int32Add(Node* left, Node* right) {
    return BinaryOp(graph()->Add_meta(), MachineType::kInt32, left, right);
  }
  Node* Int32Sub(Node* left, Node* right) {
    return BinaryOp(graph()->Sub_meta(), MachineType::kInt32, left, right);
  }
  Node* Int32Max(Node* left, Node* right) {
    return BinaryOp(graph()->Int32Max_meta(), MachineType::kInt32, left, right);
  }
  Node* Int32Min(Node* left, Node* right) {
    return BinaryOp(graph()->Int32Min_meta(), MachineType::kInt32, left, right);
  }
  Node* Int32SubOverflow(Node* left, Node* right) {
    return BinaryOp(graph()->SubWithOverFlow_meta(), MachineType::kRawType,
                    left, right);
  }
  Node* Int32AddOverflow(Node* left, Node* right) {
    return BinaryOp(graph()->AddWithOverFlow_meta(), MachineType::kRawType,
                    left, right);
  }
  Node* Int32MulOverflow(Node* left, Node* right) {
    return BinaryOp(graph()->MulWithOverFlow_meta(), MachineType::kRawType,
                    left, right);
  }
  Node* ExtractValue(Node* left, int idx) {
    auto right = IntValue(idx);
    return BinaryOp(graph()->ExtractValue_meta(), MachineType::kInt32, left,
                    right);
  }
  Node* Alloca(Node* left) {
    return UnaryOp(graph()->Alloca_meta(), MachineType::kRawType, left);
  }

  Node* Message(const char* msg) {
    auto meta = graph()->Message_meta(msg);
    auto type = NodeType::GetNodeType(MachineType::kRawType);
    return graph()->NewNode(meta, type);
  }

  Node* SaveStack() {
    auto type = NodeType::GetNodeType(MachineType::kRawType);
    return graph()->NewNode(graph()->SaveStack_meta(), type, control(),
                            depend());
  }
  void RestoreStack(Node* left) {
    auto type = NodeType::GetNodeType(MachineType::kRawType);
    auto res = graph()->NewNode(graph()->RestoreStack_meta(), type, control(),
                                depend(), left);
    set_depend(res);
  }
  Node* ReadRegister(int n) {
    auto type = NodeType::GetNodeType(MachineType::kInt64);
    auto res = graph()->NewNode(graph()->ReadRegister_meta(n), type, control(),
                                depend());
    set_depend(res);
    return res;
  }
  void WriteRegister(int n, Node* left) {
    auto type = NodeType::GetNodeType(MachineType::kInt64);
    auto res = graph()->NewNode(graph()->WriteRegister_meta(n), type, control(),
                                depend(), left);
    set_depend(res);
  }
  Node* Int32Mul(Node* left, Node* right) {
    return BinaryOp(graph()->Mul_meta(), MachineType::kInt32, left, right);
  }

  Node* Int32LSL(Node* left, Node* right) {
    return BinaryOp(graph()->LShift_meta(), MachineType::kInt32, left, right);
  }
  Node* Int32And(Node* left, Node* right) {
    return BinaryOp(graph()->And_meta(), MachineType::kInt32, left, right);
  }
  Node* BoolOr(Node* left, Node* right) {
    return BinaryOp(graph()->Or_meta(), MachineType::kBool, left, right);
  }
  Node* BoolAnd(Node* left, Node* right) {
    return BinaryOp(graph()->And_meta(), MachineType::kBool, left, right);
  }
  Node* BoolNot(Node* input) {
    return UnaryOp(graph()->Not_meta(), MachineType::kBool, input);
  }
  Node* Int32Not(Node* input) {
    return UnaryOp(graph()->Not_meta(), MachineType::kInt32, input);
  }
  Node* Int32LSR(Node* left, Node* right) {
    return BinaryOp(graph()->RShift_meta(), MachineType::kInt32, left, right);
  }
  Node* Int64LSR(Node* left, Node* right) {
    return BinaryOp(graph()->RShift_meta(), MachineType::kInt64, left, right);
  }
  Node* Int32URshift(Node* left, Node* right) {
    return BinaryOp(graph()->URshift_meta(), MachineType::kInt32, left, right);
  }
  Node* Int64URshift(Node* left, Node* right) {
    return BinaryOp(graph()->URshift_meta(), MachineType::kInt64, left, right);
  }

  Node* Int32Div(Node* left, Node* right) {
    return BinaryOp(graph()->Div_meta(), MachineType::kInt32, left, right);
  }

  Node* Int32Mod(Node* left, Node* right) {
    return BinaryOp(graph()->Mod_meta(), MachineType::kInt32, left, right);
  }
  Node* Int32Or(Node* left, Node* right) {
    return BinaryOp(graph()->Or_meta(), MachineType::kInt32, left, right);
  }

  Node* Int64LSL(Node* left, Node* right) {
    return BinaryOp(graph()->LShift_meta(), MachineType::kInt64, left, right);
  }

  Node* IntPtrLSL(Node* left, Node* right) {
    return BinaryOp(graph()->LShift_meta(), MachineType::kInt64, left, right);
  }

  Node* Int64Or(Node* left, Node* right) {
    return BinaryOp(graph()->Or_meta(), MachineType::kInt64, left, right);
  }
  Node* Int64And(Node* left, Node* right) {
    vmassert(left->type()->machine_type() == right->type()->machine_type(),
             "type not equal");
    return BinaryOp(graph()->And_meta(), MachineType::kInt64, left, right);
  }
  Node* IntPtrAnd(Node* left, Node* right) {
    return BinaryOp(graph()->And_meta(), MachineType::kIntptr, left, right);
  }
  Node* Int64Xor(Node* left, Node* right) {
    return BinaryOp(graph()->Xor_meta(), MachineType::kInt64, left, right);
  }
  Node* Int32Xor(Node* left, Node* right) {
    return BinaryOp(graph()->Xor_meta(), MachineType::kInt32, left, right);
  }
  Node* Int64Add(Node* left, Node* right) {
    return BinaryOp(graph()->Add_meta(), MachineType::kInt64, left, right);
  }
  Node* Int64Sub(Node* left, Node* right) {
    return BinaryOp(graph()->Sub_meta(), MachineType::kInt64, left, right);
  }
  Node* Int64Div(Node* left, Node* right) {
    return BinaryOp(graph()->Div_meta(), MachineType::kInt64, left, right);
  }
  Node* Int64Mod(Node* left, Node* right) {
    return BinaryOp(graph()->Mod_meta(), MachineType::kInt64, left, right);
  }
  Node* Float64Div(Node* left, Node* right) {
    return BinaryOp(graph()->Div_meta(), MachineType::kFloat64, left, right);
  }
  Node* Float64Mod(Node* left, Node* right) {
    return BinaryOp(graph()->Mod_meta(), MachineType::kFloat64, left, right);
  }
  Node* Float64Sub(Node* left, Node* right) {
    return BinaryOp(graph()->Sub_meta(), MachineType::kFloat64, left, right);
  }
  Node* Float64Add(Node* left, Node* right) {
    return BinaryOp(graph()->Add_meta(), MachineType::kFloat64, left, right);
  }
  Node* Float64Mul(Node* left, Node* right) {
    return BinaryOp(graph()->Mul_meta(), MachineType::kFloat64, left, right);
  }

  Node* ZExtInt8ToInt32(Node* input) {
    return Convert(input, ConvertType::kZext, MachineType::kInt32);
  }
  Node* ZExtInt16ToInt32(Node* input) {
    return Convert(input, ConvertType::kZext, MachineType::kInt32);
  }
  Node* ZExtToInt64(Node* input) {
    return Convert(input, ConvertType::kZext, MachineType::kInt64);
  }
  Node* CastIntPtrToRaw(Node* input) {
    return Convert(input, ConvertType::kCast, MachineType::kRawType);
  }
  Node* CastToRaw(Node* input) {
    return Convert(input, ConvertType::kCast, MachineType::kRawType);
  }
  Node* CastIntPtrToObject(Node* input) {
    return Convert(input, ConvertType::kCast, MachineType::kObject);
  }
  Node* CastRawToIntPtr(Node* input) {
    return Convert(input, ConvertType::kCast, MachineType::kIntptr);
  }
  Node* CastRawToInt64(Node* input) {
    return Convert(input, ConvertType::kCast, MachineType::kInt64);
  }
  Node* CastInt32ToDouble(Node* input) {
    return Convert(input, ConvertType::kIntToDouble, MachineType::kFloat64);
  }
  Node* CastDoubleToInt32(Node* input) {
    return Convert(input, ConvertType::kDoubleToInt, MachineType::kInt32);
  }
  Node* CastUInt32ToDouble(Node* input) {
    return Convert(input, ConvertType::kUIntToDouble, MachineType::kFloat64);
  }
  Node* CastDoubleToUInt32(Node* input) {
    return Convert(input, ConvertType::kDoubleToUInt, MachineType::kInt32);
  }
  Node* CastInt64ToDouble(Node* input) {
    return Convert(input, ConvertType::kIntToDouble, MachineType::kFloat64);
  }
  Node* CastDoubleToInt64(Node* input) {
    return Convert(input, ConvertType::kDoubleToInt, MachineType::kInt64);
  }
  Node* BitCastInt64ToDouble(Node* input) {
    return Convert(input, ConvertType::kBitCast, MachineType::kFloat64);
  }
  Node* BitCastDoubleToInt64(Node* input) {
    return Convert(input, ConvertType::kBitCast, MachineType::kInt64);
  }
  Node* TruncIntPtrToInt32(Node* input) {
    auto is_32bit = graph()->options().Is32Bit();
    if (!is_32bit) {
      return Convert(input, ConvertType::kTrunc, MachineType::kInt32);
    }
    return input;
  }
  Node* TruncInt64ToInt32(Node* input) {
    return Convert(input, ConvertType::kTrunc, MachineType::kInt32);
  }
  Node* TruncInt64ToInt8(Node* input) {
    return Convert(input, ConvertType::kTrunc, MachineType::kInt8);
  }
  Node* TruncInt32ToInt8(Node* input) {
    return Convert(input, ConvertType::kTrunc, MachineType::kInt8);
  }
  Node* TruncInt64ToBool(Node* input) {
    return Convert(input, ConvertType::kTrunc, MachineType::kBool);
  }
  Node* TruncInt64ToIntPtr(Node* input) {
    auto is_32bit = graph()->options().Is32Bit();
    if (is_32bit) {
      return Convert(input, ConvertType::kTrunc, MachineType::kInt32);
    }
    return input;
  }
  Node* SExtInt8ToIntPtr(Node* input) {
    auto is_32bit = graph()->options().Is32Bit();
    if (is_32bit) {
      return Convert(input, ConvertType::kSext, MachineType::kInt32);
    } else {
      return Convert(input, ConvertType::kSext, MachineType::kInt64);
    }
  }
  Node* SExtInt32ToIntPtr(Node* input) {
    auto is_32bit = graph()->options().Is32Bit();
    if (!is_32bit) {
      return Convert(input, ConvertType::kSext, MachineType::kInt64);
    }
    return input;
  }
  Node* ZExtInt32ToIntPtr(Node* input) {
    auto is_32bit = graph()->options().Is32Bit();
    if (!is_32bit) {
      return Convert(input, ConvertType::kZext, MachineType::kInt64);
    }
    return input;
  }

  Node* ZExtToIntPtr(Node* input) {
    auto is_32bit = graph()->options().Is32Bit();
    if (!is_32bit) {
      return Convert(input, ConvertType::kZext, MachineType::kInt64);
    } else {
      return Convert(input, ConvertType::kZext, MachineType::kInt32);
    }
  }

  Node* SExtToInt32(Node* input) {
    return Convert(input, ConvertType::kSext, MachineType::kInt32);
  }

  Node* ZExtToInt32(Node* input) {
    return Convert(input, ConvertType::kZext, MachineType::kInt32);
  }

  Node* SExtToInt64(Node* input) {
    return Convert(input, ConvertType::kSext, MachineType::kInt64);
  }

  Node* ZExtInt32ToInt64(Node* input) {
    return Convert(input, ConvertType::kZext, MachineType::kInt64);
  }

  Node* ZExtIntPtrToInt64(Node* input) {
    if (graph()->options().Is32Bit()) {
      return Convert(input, ConvertType::kZext, MachineType::kInt64);
    }
    return input;
  }

  Node* IntPtrSize() {
    return graph()->options().Is32Bit() ? IntPtrValue(sizeof(int))
                                        : IntPtrValue(sizeof(int64_t));
  }
  Node* IntPtrShiftSize() {
    return graph()->options().Is32Bit() ? IntPtrValue(2) : IntPtrValue(3);
  }
  int intptr_size() { return Is32Bit() ? sizeof(int) : sizeof(int64_t); }

  Node* Convert(Node* input, ConvertType type, MachineType machine_type) {
    return UnaryOp(graph()->builder()->Convert_meta(type), machine_type, input);
  }
  Node* DoubleIsNaN(Node* input) {
    auto equal = Equal(input, input);
    return Equal(equal, BooleanValue(false));
  }
  Node* DoubleNotNaN(Node* input) {
    auto equal = Equal(input, input);
    return NotEqual(equal, BooleanValue(false));
  }
  Node* FunctionPointer(const CallDescriptor& desc) {
    auto meta = graph()->builder()->FunctionPointer_meta(desc);
    return graph()->NewNode(meta, nullptr);
  }

  template <class... Args>
  Node* Call(const CallDescriptor& desc, Args... args) {
    return CallImpl(desc, false, args...);
  }

  template <class... Args>
  Node* TailCall(const CallDescriptor& desc, Args... args) {
    return CallImpl(desc, true, args...);
  }

  template <class... Args>
  Node* CallImpl(const CallDescriptor& desc, bool tail, Args... args);

  void End();
};

class Label {
 private:
  LabelImpl* _impl;

 public:
  Label(GraphBuilder* builder) : _impl(builder->env()->NewLabel()) {}
  Label(GraphBuilder* builder, bool loop) : _impl(builder->env()->NewLabel()) {
    _impl->set_is_loop(loop);
  }

  LabelImpl* impl() const { return _impl; }
};

class Variable {
 private:
  VariableImpl* _impl;

 public:
  Variable(GraphBuilder* builder, NodeType* type, Node* init)
      : _impl(builder->env()->NewVariable(type, init)) {}

  VariableImpl* impl() const { return _impl; }

  Variable& operator=(Node* value) {
    impl()->WriteVariable(value);
    return *this;
  }

  Node* operator*() { return impl()->ReadVariable(); }
};

inline void GraphBuilder::Bind(Label* target) {
  target->impl()->Bind();
  env()->set_current_label(target->impl());
}

inline void GraphBuilder::BindLoop(Label* target, int pred_size) {
  Jump(target);
  target->impl()->set_is_loop(true);
  target->impl()->Bind(pred_size);
  env()->set_current_label(target->impl());
}

inline void GraphBuilder::BindLoopWithoutJump(Label* target, int pred_size) {
  target->impl()->set_is_loop(true);
  target->impl()->Bind(pred_size);
  env()->set_current_label(target->impl());
}

}  // namespace node
}  // namespace son
#endif  // PRIMJS_SON_GRAPH_BUILDER_H
