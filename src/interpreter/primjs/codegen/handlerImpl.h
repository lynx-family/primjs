// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_INTERP_HANDLER_IMPL_H
#define PRIMJS_INTERP_HANDLER_IMPL_H

#include "primjs/base/globals.h"
#include "primjs/base/zone.h"
#include "primjs/codegen/interpreterAssembler.h"

namespace primjs {

class HandlerImpl : public InterpreterAssembler {
 public:
  HandlerImpl(son::node::NodeGraph* graph, base::Zone* zone)
      : InterpreterAssembler(graph, zone) {}

  void GenBinaryArithOp(PrimjsOpcode opcode);
  void GenBinaryArithFloatOp(PrimjsOpcode opcode, son::node::Node* op1_float64,
                             son::node::Node* op2_float64,
                             son::node::Node* var_buf, son::node::Node* index);

  void WrapUnaryEntry(son::node::Node* op1, son::node::Label* is_int,
                      son::node::Label* is_float64, son::node::Label* slow);

  void GenPushOp(son::node::Node* val, PrimjsOpcode opcode);

  enum BinaryOpState {
    kBothInt = 0,
    kBothFloat64 = 1,
    kLeftIntRightFloat64 = 2,
    kLeftFloat64RightInt = 3,
  };
  using BinaryOperation = std::function<void(BinaryOpState)>;
  void WrapBinaryEntry(son::node::Node* op1, son::node::Node* op2,
                       son::node::Label* is_int, son::node::Label* slow,
                       const BinaryOperation& binary_op);
  void FastDoubleToInt(son::node::Node* d, son::node::Variable& op_h,
                       son::node::Label* overflow);
  void GenBinaryLogicOp(PrimjsOpcode opcode);
  void GenCompareOp(PrimjsOpcode opcode);
  void GenUnaryArithOp(PrimjsOpcode opcode);
  void GenPostInc(PrimjsOpcode opcode);
  void GenPlusOp(PrimjsOpcode opcode);
  void GenNotOp(PrimjsOpcode opcode);
  void GenLNotOp(PrimjsOpcode opcode);
  void GenIfBranch(PrimjsOpcode opcode);
  void GenToPropertyKey(PrimjsOpcode opcode);
  void CheckUninitialized(son::node::Node* val, bool check_init,
                          bool check_local);
  void GenGetBuf(PrimjsOpcode opcode, int idx, bool is_ref,
                 son::node::Node* buf);
  void GenSetBuf(PrimjsOpcode opcode, int idx, bool is_put, bool is_ref,
                 son::node::Node* buf);
  void GenGetVarBuf(PrimjsOpcode opcode, int idx) {
    GenGetBuf(opcode, idx, false, RestoreVarBuf());
  }
  void GenSetVarBuf(PrimjsOpcode opcode, int idx, bool is_put) {
    GenSetBuf(opcode, idx, is_put, false, RestoreVarBuf());
  }
  void GenGetArgBuf(PrimjsOpcode opcode, int idx) {
    GenGetBuf(opcode, idx, false, RestoreArgBuf());
  }
  void GenSetArgBuf(PrimjsOpcode opcode, int idx, bool is_put) {
    GenSetBuf(opcode, idx, is_put, false, RestoreArgBuf());
  }
  void GenGetVarRefs(PrimjsOpcode opcode, int idx) {
    GenGetBuf(opcode, idx, true, GetVarRefsCache());
  }
  void GenSetVarRefs(PrimjsOpcode opcode, int idx, bool is_put) {
    GenSetBuf(opcode, idx, is_put, true, GetVarRefsCache());
  }
  void GenSpecialObject(PrimjsOpcode opcode);
  void GenCallBinaryOperator(PrimjsOpcode opcode);
  void GenWithOp(PrimjsOpcode opcode);
  void GenMakeRefOp(PrimjsOpcode opcode);
  void GenDoneGenerator(PrimjsOpcode opcode);
  void GenDefineMethod(PrimjsOpcode opcode);

  void GenCallOp(PrimjsOpcode opcode);
  void GenFastCallConstructor(bool is_derived);
  void GenCallNative(bool from_entry);
  void GenCallCFunction(son::node::Label* call_fail);
  void GenCallCFunctionData(son::node::Label* call_fail);
  void GenCommonReturn();
  void CheckFunctIsObject(son::node::Node* func_obj);
  void CheckCallNative(son::node::Node* func_obj, bool from_entry);
  void GenCallGenerator(son::node::Node* func_obj);
  void GenCallFromEntry();
  void GenCommonCall();
  void GenCommonCallInternal(son::node::Node* b, son::node::Node* func_obj,
                             son::node::Node* arg_count,
                             son::node::Node* call_argc,
                             son::node::Node* call_argv, bool copy_arg,
                             bool from_entry = false);

  using FindPropertyOperation =
      std::function<void(son::node::Node*, son::node::Node*, son::node::Node*)>;
  void FindProperty(son::node::Node* obj, son::node::Node* atom,
                    son::node::Label* slow, son::node::Label* not_found,
                    const FindPropertyOperation& func);

  son::node::Node* FindPropertyForGet(son::node::Node* obj,
                                      son::node::Node* atom,
                                      son::node::Label* slow_get,
                                      son::node::Label* not_found,
                                      bool own_only = false);

  void FindPropertyForSet(son::node::Node* obj, son::node::Node* atom,
                          son::node::Node* val, son::node::Label* slow_set,
                          son::node::Label* not_found);
  void FastAddProperty(son::node::Node* obj, son::node::Node* atom,
                       son::node::Node* val, son::node::Label* success,
                       son::node::Label* slow);

  using FindOwnPropertyOperation =
      std::function<void(son::node::Node*, son::node::Node*)>;
  void FindOwnProperty(son::node::Node* obj, son::node::Node* atom,
                       son::node::Label* fail_exit,
                       const FindOwnPropertyOperation& func);
  void CheckFastArrayAdd(son::node::Node* obj, son::node::Label* slow);
  void AddFastArrayElement(son::node::Node* obj, son::node::Node* len,
                           son::node::Node* val, son::node::Label* slow_add);
  void GenGetField(PrimjsOpcode opcode);
  void GenPutField(PrimjsOpcode opcode);
  void GenGetGlobalVar(PrimjsOpcode opcode);
  void GenGetGlobalVarCommon(PrimjsOpcode opcode, son::node::Label* slow_get);
  void GenSetProperty();
  void GenSetPropertyValue();
  void GenGetPropertyValue(PrimjsOpcode opcode, son::node::Node* obj,
                           son::node::Node* prop, son::node::Label* slow_get);
  void GenGetTypedArrayElement(PrimjsOpcode opcode, son::node::Node* obj,
                               son::node::Node* index,
                               son::node::Node* class_id,
                               son::node::Label* slow_get);
  void GenSetTypedArrayElement(PrimjsOpcode opcode, son::node::Node* obj,
                               son::node::Node* index, son::node::Node* val,
                               son::node::Node* class_id,
                               son::node::Label* slow_set);
  void GenGetArrayEl(PrimjsOpcode opcode);
  void GenPutArrayEl(PrimjsOpcode opcode);
  void GenArrayFrom(PrimjsOpcode opcode);
  son::node::Node* FastBuildArguments(son::node::Node* argc,
                                      son::node::Node* argv,
                                      son::node::Label* fallback);
  void GenInsert(PrimjsOpcode opcode);
  void GenDup(PrimjsOpcode opcode);
  void GenSwap(PrimjsOpcode opcode);
  void GenPerm(PrimjsOpcode opcode);
  void GenRot(PrimjsOpcode opcode);
  void GenDrop(PrimjsOpcode opcode);
  void GenPushConst(PrimjsOpcode opcode);
  void GenFclosure(PrimjsOpcode opcode);
  void GenForInNext(PrimjsOpcode opcode);
};

}  // namespace primjs
#endif  // PRIMJS_INTERP_HANDLER_IMPL_H
