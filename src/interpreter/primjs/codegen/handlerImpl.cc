// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/handlerImpl.h"

#include "primjs/codegen/bytecode.h"
#include "primjs/son/graphAssembler.h"
#include "primjs/son/graphBuilder.h"

namespace primjs {

void HandlerImpl::GenBinaryArithFloatOp(PrimjsOpcode opcode,
                                        son::node::Node* op1_float64,
                                        son::node::Node* op2_float64,
                                        son::node::Node* var_buf,
                                        son::node::Node* index) {
  son::node::Node* res = nullptr;
  if (opcode == PrimjsOpcode::OP_mod) {
    auto desc = son::node::CallDescriptors::fmod();
    res = CallRuntimeNoThrow(desc, op1_float64, op2_float64);
  } else if (opcode == PrimjsOpcode::OP_div) {
    res = Float64Div(op1_float64, op2_float64);
  } else if (opcode == PrimjsOpcode::OP_add) {
    res = Float64Add(op1_float64, op2_float64);
  } else if (opcode == PrimjsOpcode::OP_sub) {
    res = Float64Sub(op1_float64, op2_float64);
  } else if (opcode == PrimjsOpcode::OP_mul) {
    res = Float64Mul(op1_float64, op2_float64);
  } else if (opcode == PrimjsOpcode::OP_add_loc) {
    res = Float64Add(op1_float64, op2_float64);
  }
  ClearNewSp();
  DecSp();
  if (opcode == PrimjsOpcode::OP_add_loc) {
    StoreLepusVal(var_buf, index, NewFloat64(res));
  } else {
    StoreTop0(NewFloat64(res));
  }
  Dispatch(opcode);
}

void HandlerImpl::GenBinaryArithOp(PrimjsOpcode opcode) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   int v1, v2;
  //   v1 = LEPUS_VALUE_GET_INT(op1);
  //   v2 = LEPUS_VALUE_GET_INT(op2);
  //   sp[-2] = LEPUS_NewFloat64(ctx, (double)v1 / (double)v2);
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_binary_arith_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_div)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  son::node::Label not_ptr(this);
  son::node::Label op1_int(this);
  son::node::Label op1_not_int(this);
  son::node::Label op1_int_op2_not_int(this);
  son::node::Label op1_float64_op2_not_int(this);
  son::node::Label both_is_int(this);
  son::node::Label set_int(this);
  son::node::Label set_double(this);
  son::node::Label slow(this);

  son::node::Node* op1 = nullptr;
  son::node::Node* op2 = nullptr;
  son::node::Node* var_buf = nullptr;
  son::node::Node* index = nullptr;

  if (opcode == PrimjsOpcode::OP_add_loc) {
    var_buf = RestoreVarBuf();
    index = Fetch_8(0);
    op1 = LoadLepusVal(var_buf, index);
    op2 = LoadTop0();
  } else {
    op1 = LoadTop1();
    op2 = LoadTop0();
  }
  auto func = [=](BinaryOpState flag) {
    son::node::Node* f_op1 = nullptr;
    son::node::Node* f_op2 = nullptr;
    if (flag == BinaryOpState::kBothFloat64) {
      f_op1 = GetLepusFloat64(op1);
      f_op2 = GetLepusFloat64(op2);
    } else if (flag == BinaryOpState::kLeftFloat64RightInt) {
      f_op1 = GetLepusFloat64(op1);
      f_op2 = CastInt32ToDouble(GetLepusInt(op2));
    } else if (flag == BinaryOpState::kLeftIntRightFloat64) {
      f_op1 = CastInt32ToDouble(GetLepusInt(op1));
      f_op2 = GetLepusFloat64(op2);
    }
    GenBinaryArithFloatOp(opcode, f_op1, f_op2, var_buf, index);
  };
  WrapBinaryEntry(op1, op2, &both_is_int, &slow, func);
  Bind(&both_is_int);
  {
    ClearNewSp();
    DecSp();
    bool overflow_check = false;
    son::node::Node* res = nullptr;
    if (opcode == PrimjsOpcode::OP_mod) {
      // if (unlikely(v1 < 0 || v2 <= 0))
      auto cond1 = LessThan(GetLepusInt(op1), IntValue(0));
      auto cond2 = LessThanOrEqual(GetLepusInt(op2), IntValue(0));
      Branch(BoolOr(cond1, cond2), &slow, &set_int,
             son::node::BranchHint::kFalse);
      Bind(&set_int);
      {
        res = Int32Mod(GetLepusInt(op1), GetLepusInt(op2));
        StoreTop0(NewInt32(res));
      }
    } else if (opcode == PrimjsOpcode::OP_div) {
      auto v1 = CastInt32ToDouble(GetLepusInt(op1));
      auto v2 = CastInt32ToDouble(GetLepusInt(op2));
      res = Float64Div(v1, v2);

      son::node::Label exit(this);
      auto res_int = CastDoubleToInt32(res);
      auto d = ZExtToInt64(res_int);
      auto t = BitCastDoubleToInt64(res);
      Branch(Equal(d, t), &set_int, &set_double);
      Bind(&set_int);
      {
        StoreTop0(NewInt32(res_int));
        Jump(&exit);
      }
      Bind(&set_double);
      {
        StoreTop0(NewFloat64(res));
        Jump(&exit);
      }
      Bind(&exit);
    } else if (opcode == PrimjsOpcode::OP_add) {
      res = Int32AddOverflow(GetLepusInt(op1), GetLepusInt(op2));
      overflow_check = true;
    } else if (opcode == PrimjsOpcode::OP_sub) {
      overflow_check = true;
      res = Int32SubOverflow(GetLepusInt(op1), GetLepusInt(op2));
    } else if (opcode == PrimjsOpcode::OP_mul) {
      overflow_check = true;
      res = Int32MulOverflow(GetLepusInt(op1), GetLepusInt(op2));
    } else if (opcode == PrimjsOpcode::OP_add_loc) {
      res = Int32AddOverflow(GetLepusInt(op1), GetLepusInt(op2));
      overflow_check = true;
    }
    if (overflow_check) {
      auto overflow = ExtractValue(res, 1);
      res = ExtractValue(res, 0);
      Branch(overflow, &slow, &set_int, son::node::BranchHint::kFalse);
      Bind(&set_int);

      // check -0
      if (opcode == PrimjsOpcode::OP_mul) {
        // if (unlikely(r == 0 && (v1 | v2) < 0))
        son::node::Label set_minus_zero(this);
        son::node::Label set_int_next(this);
        son::node::Label exit(this);

        auto cond1 = Equal(res, IntValue(0));
        auto cond2 =
            LessThan(Int32Or(GetLepusInt(op1), GetLepusInt(op2)), IntValue(0));
        auto cond = BoolAnd(cond1, cond2);
        Branch(cond, &set_minus_zero, &set_int_next,
               son::node::BranchHint::kFalse);
        Bind(&set_minus_zero);
        {
          StoreTop0(NewFloat64(DoubleValue(-0.0)));
          Jump(&exit);
        }
        Bind(&set_int_next);
        {
          StoreTop0(NewInt32(res));
          Jump(&exit);
        }
        Bind(&exit);
      } else if (opcode == PrimjsOpcode::OP_add_loc) {
        StoreLepusVal(var_buf, index, NewInt32(res));
      } else {
        StoreTop0(NewInt32(res));
      }
    }
    Dispatch(opcode);
  }
  Bind(&slow);
  {
    if ((opcode == PrimjsOpcode::OP_add_loc) ||
        (opcode == PrimjsOpcode::OP_add)) {
      son::node::Label not_string(this);
      auto cond1 = IsStringValue(op1);
      auto cond2 = IsStringValue(op2);
      BranchIfFalse(BoolAnd(cond1, cond2), &not_string);
      {
        ClearNewSp();
        auto desc = son::node::CallDescriptors::JS_ConcatString_GC();
        auto res = CallRuntime(desc, GetCtx(), op1, op2);
        DecSp();
        if (opcode == PrimjsOpcode::OP_add_loc) {
          index = Fetch_8(0);
          StoreLepusVal(var_buf, index, res);
        } else {
          StoreTop0(res);
        }
        Dispatch(opcode);
      }
      Bind(&not_string);
    }
    ClearNewSp();
    if (opcode == PrimjsOpcode::OP_add_loc) {
      auto desc = son::node::CallDescriptors::prim_js_add_slow_gc();

      auto res = CallRuntime(desc, GetCtx(), op1, op2);
      auto var_buf = RestoreVarBuf();
      DecSp();
      StoreLepusVal(var_buf, Fetch_8(0), res);
      Dispatch(opcode);
    } else if (opcode == PrimjsOpcode::OP_add) {
      auto desc = son::node::CallDescriptors::prim_js_add_slow_gc();
      auto res = CallRuntime(desc, GetCtx(), op1, op2);
      DecSp();
      StoreTop0(res);
      Dispatch(opcode);
    } else {
      auto desc = son::node::CallDescriptors::prim_js_binary_arith_slow_gc();
      auto res = CallRuntime(desc, GetCtx(), op1, op2, Int8Value((int)opcode));
      DecSp();
      StoreTop0(res);
      Dispatch(opcode);
    }
  }
}

void HandlerImpl::FastDoubleToInt(son::node::Node* val,
                                  son::node::Variable& op_h,
                                  son::node::Label* overflow) {
  vmassert(val->type() == son::node::NodeType::Int64Type(), "must be");
  son::node::Label next(this);
  son::node::Label done(this);
  auto double_val = GetLepusFloat64(val);

  // e = (u.u64 >> 52) & 0x7ff;
  auto exp = Int64And(Int64URshift(val, Int64Value(52)), Int64Value(0x7ff));
  // if (likely(e <= (1023 + 30)))
  Branch(LessThanOrEqual(exp, Int64Value(1023 + 30)), &next, overflow,
         son::node::BranchHint::kTrue);
  Bind(&next);
  {
    op_h = CastDoubleToInt32(double_val);
    Jump(&done);
  }
  Bind(&done);
}

void HandlerImpl::GenBinaryLogicOp(PrimjsOpcode opcode) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewInt32(ctx, LEPUS_VALUE_GET_INT(op1) |
  //   LEPUS_VALUE_GET_INT(op2)); sp--;
  // } else {
  //   sp[-2] = prim_js_binary_logic_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_or)); if (unlikely(LEPUS_IsException(sp[-2])))
  //   {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  son::node::Label is_int(this);
  son::node::Label set_int(this);
  son::node::Label set_double(this);
  son::node::Label slow(this);

  auto op1 = LoadTop1();
  auto op2 = LoadTop0();

  auto int_op1 = GetLepusInt(op1);
  auto int_op2 = GetLepusInt(op2);
  son::node::Variable op1_h(this, son::node::NodeType::IntType(), int_op1);
  son::node::Variable op2_h(this, son::node::NodeType::IntType(), int_op2);

  auto func = [&](BinaryOpState flag) {
    if (flag == BinaryOpState::kBothFloat64) {
      Jump(&slow);
    } else if (flag == BinaryOpState::kLeftFloat64RightInt) {
      FastDoubleToInt(op1, op1_h, &slow);
      Jump(&is_int);
    } else if (flag == BinaryOpState::kLeftIntRightFloat64) {
      Jump(&slow);
    }
  };
  WrapBinaryEntry(op1, op2, &is_int, &slow, func);
  Bind(&is_int);
  {
    ClearNewSp();
    DecSp();
    auto v1 = *op1_h;
    auto v2 = *op2_h;
    son::node::Node* res = nullptr;
    if (opcode == PrimjsOpcode::OP_xor) {
      // if (unlikely(v1 < 0 || v2 <= 0))
      res = Int32Xor(v1, v2);
    } else if (opcode == PrimjsOpcode::OP_or) {
      res = Int32Or(v1, v2);
    } else if (opcode == PrimjsOpcode::OP_and) {
      res = Int32And(v1, v2);
    } else if (opcode == PrimjsOpcode::OP_shl) {
      v2 = Int32And(v2, IntValue(0x1f));
      res = Int32LSL(v1, v2);
    } else if (opcode == PrimjsOpcode::OP_sar) {
      v2 = Int32And(v2, IntValue(0x1f));
      res = Int32LSR(v1, v2);
    } else if (opcode == PrimjsOpcode::OP_shr) {
      son::node::Label exit(this);

      v2 = Int32And(v2, IntValue(0x1f));
      res = Int32URshift(v1, v2);
      auto cond = UnsignedLessThanOrEqual(res, Int32Value(0x7fffffff));
      Branch(cond, &set_int, &set_double, son::node::BranchHint::kTrue);
      Bind(&set_int);
      {
        StoreTop0(NewInt32(res));
        Jump(&exit);
      }
      Bind(&set_double);
      {
        StoreTop0(NewFloat64(CastUInt32ToDouble(res)));
        Jump(&exit);
      }
      Bind(&exit);
    } else {
      unreachable();
    }
    if (opcode != PrimjsOpcode::OP_shr) {
      StoreTop0(NewInt32(res));
    }
    Dispatch(opcode);
  }
  Bind(&slow);
  {
    ClearNewSp();
    auto ctx = GetCtx();
    son::node::Node* res = nullptr;
    if (opcode == PrimjsOpcode::OP_shr) {
      auto desc = son::node::CallDescriptors::prim_js_shr_slow_gc();
      res = CallRuntime(desc, ctx, op1, op2);
    } else {
      auto desc = son::node::CallDescriptors::prim_js_binary_logic_slow_gc();
      res = CallRuntime(desc, ctx, op1, op2, Int8Value((int)opcode));
    }
    DecSp();
    StoreTop0(res);
    Dispatch(opcode);
  }
}

void HandlerImpl::GenCompareOp(PrimjsOpcode opcode) {
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewBool(
  //       ctx, LEPUS_VALUE_GET_INT(op1) == LEPUS_VALUE_GET_INT(op2));
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_eq_slow_gc(ctx, op1, op2, 0);
  //   if (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  son::node::Label is_int(this);
  son::node::Label set_int(this);
  son::node::Label slow(this);

  auto op1 = LoadTop1();
  auto op2 = LoadTop0();

  auto func = [=](BinaryOpState flag) {
    son::node::Node* f_op1 = nullptr;
    son::node::Node* f_op2 = nullptr;
    if (flag == BinaryOpState::kBothFloat64) {
      f_op1 = GetLepusFloat64(op1);
      f_op2 = GetLepusFloat64(op2);
    } else if (flag == BinaryOpState::kLeftFloat64RightInt) {
      f_op1 = GetLepusFloat64(op1);
      f_op2 = CastInt32ToDouble(GetLepusInt(op2));
    } else if (flag == BinaryOpState::kLeftIntRightFloat64) {
      f_op1 = CastInt32ToDouble(GetLepusInt(op1));
      f_op2 = GetLepusFloat64(op2);
    }
    son::node::Node* res = nullptr;
    switch (opcode) {
      case PrimjsOpcode::OP_gt:
        res = GreaterThan(f_op1, f_op2);
        break;
      case PrimjsOpcode::OP_gte:
        res = GreaterThanOrEqual(f_op1, f_op2);
        break;
      case PrimjsOpcode::OP_lt:
        res = LessThan(f_op1, f_op2);
        break;
      case PrimjsOpcode::OP_lte:
        res = LessThanOrEqual(f_op1, f_op2);
        break;
      case PrimjsOpcode::OP_strict_eq:
      case PrimjsOpcode::OP_eq: {
        auto cond1 = Equal(f_op1, f_op2);
        auto cond2 = DoubleNotNaN(f_op1);
        res = BoolAnd(cond1, cond2);
        break;
      }
      case PrimjsOpcode::OP_strict_neq:
      case PrimjsOpcode::OP_neq: {
        auto cond1 = Equal(f_op1, f_op2);
        auto cond2 = DoubleNotNaN(f_op1);
        res = BoolNot(BoolAnd(cond1, cond2));
        break;
      }
      default:
        unreachable();
        break;
    }
    ClearNewSp();
    DecSp();
    StoreTop0(NewBoolean(res));
    Dispatch(opcode);
  };
  WrapBinaryEntry(op1, op2, &is_int, &slow, func);
  Bind(&is_int);
  {
    son::node::Node* res = nullptr;
    switch (opcode) {
      case PrimjsOpcode::OP_gt:
        res = GreaterThan(GetLepusInt(op1), GetLepusInt(op2));
        break;
      case PrimjsOpcode::OP_gte:
        res = GreaterThanOrEqual(GetLepusInt(op1), GetLepusInt(op2));
        break;
      case PrimjsOpcode::OP_lt:
        res = LessThan(GetLepusInt(op1), GetLepusInt(op2));
        break;
      case PrimjsOpcode::OP_lte:
        res = LessThanOrEqual(GetLepusInt(op1), GetLepusInt(op2));
        break;
      case PrimjsOpcode::OP_strict_eq:
      case PrimjsOpcode::OP_eq:
        res = Equal(GetLepusInt(op1), GetLepusInt(op2));
        break;
      case PrimjsOpcode::OP_strict_neq:
      case PrimjsOpcode::OP_neq:
        res = NotEqual(GetLepusInt(op1), GetLepusInt(op2));
        break;
      default:
        unreachable();
        break;
    }
    ClearNewSp();
    DecSp();
    StoreTop0(NewBoolean(res));
    Dispatch(opcode);
  }
  Bind(&slow);
  {
    son::node::Label call_slow(this);
    // not number
    if ((opcode == PrimjsOpcode::OP_eq) || (opcode == PrimjsOpcode::OP_neq) ||
        (opcode == PrimjsOpcode::OP_strict_eq) ||
        (opcode == PrimjsOpcode::OP_strict_neq)) {
      son::node::Label equal(this);
      son::node::Label not_equal(this);

      auto cond = Equal(op1, op2);
      Branch(cond, &equal, &not_equal, son::node::BranchHint::kTrue);
      Bind(&equal);
      {
        ClearNewSp();
        DecSp();
        if ((opcode == PrimjsOpcode::OP_eq) ||
            (opcode == PrimjsOpcode::OP_strict_eq)) {
          StoreTop0(LepusTrue());
        } else {
          StoreTop0(LepusFalse());
        }
        Dispatch(opcode);
      }
      Bind(&not_equal);
      {
        son::node::Label op2_is_undefined_or_null(this);
        son::node::Label op2_next(this);
        son::node::Label op1_next(this);
        son::node::Label if_false(this);
        son::node::Label if_true(this);
        if ((opcode == PrimjsOpcode::OP_eq) ||
            (opcode == PrimjsOpcode::OP_neq)) {
          Branch(IsUndefinedOrNull(op2), &op2_is_undefined_or_null, &op2_next);
          Bind(&op2_is_undefined_or_null);
          {
            // undefind == null
            Branch(IsUndefinedOrNull(op1), &if_true, &if_false,
                   son::node::BranchHint::kFalse);
          }
          Bind(&op2_next);
          {
            son::node::Label op2_next1(this);
            son::node::Label op2_is_boolean(this);
            Branch(IsUndefinedOrNull(op1), &if_false, &op2_next1,
                   son::node::BranchHint::kFalse);

            Bind(&op2_next1);
            Branch(IsLepusBoolean(op2), &op2_is_boolean, &call_slow);
            Bind(&op2_is_boolean);
            {
              // true != false
              Branch(IsLepusBoolean(op1), &if_false, &call_slow);
            }
          }
          Bind(&if_true);
          {
            ClearNewSp();
            DecSp();
            if (opcode == PrimjsOpcode::OP_eq) {
              StoreTop0(LepusTrue());
            } else {
              StoreTop0(LepusFalse());
            }
            Dispatch(opcode);
          }
          Bind(&if_false);
          {
            ClearNewSp();
            DecSp();
            if (opcode == PrimjsOpcode::OP_eq) {
              StoreTop0(LepusFalse());
            } else {
              StoreTop0(LepusTrue());
            }
            Dispatch(opcode);
          }
        } else {
          son::node::Label not_string_and_not_bigint(this);

          auto cond1 = BoolOr(IsLepusString(op1), IsBigIntValue(op1));
          auto cond2 = BoolOr(IsLepusString(op2), IsBigIntValue(op2));
          Branch(BoolAnd(cond1, cond2), &call_slow, &not_string_and_not_bigint,
                 son::node::BranchHint::kFalse);
          Bind(&not_string_and_not_bigint);
          {
            son::node::Label both_lepus_ref(this);
            son::node::Label not_both_lepus_ref(this);
            Branch(BoolAnd(IsLepusRef(op1), IsLepusRef(op2)), &both_lepus_ref,
                   &not_both_lepus_ref, son::node::BranchHint::kFalse);
            Bind(&both_lepus_ref);
            {
              son::node::Label same_lepus_ref(this);
              son::node::Label different_lepus_ref(this);
              auto same_ref =
                  Equal(GetLepusRefPoint(op1), GetLepusRefPoint(op2));
              Branch(same_ref, &same_lepus_ref, &different_lepus_ref,
                     son::node::BranchHint::kFalse);
              Bind(&same_lepus_ref);
              {
                ClearNewSp();
                DecSp();
                if (opcode == PrimjsOpcode::OP_strict_eq) {
                  StoreTop0(LepusTrue());
                } else {
                  StoreTop0(LepusFalse());
                }
                Dispatch(opcode);
              }
              Bind(&different_lepus_ref);
              {
                ClearNewSp();
                DecSp();
                if (opcode == PrimjsOpcode::OP_strict_eq) {
                  StoreTop0(LepusFalse());
                } else {
                  StoreTop0(LepusTrue());
                }
                Dispatch(opcode);
              }
            }
            Bind(&not_both_lepus_ref);
            ClearNewSp();
            DecSp();
            if (opcode == PrimjsOpcode::OP_strict_eq) {
              StoreTop0(LepusFalse());
            } else {
              StoreTop0(LepusTrue());
            }
            Dispatch(opcode);
          }
        }
      }
      Bind(&call_slow);
    }
    ClearNewSp();
    auto ctx = GetCtx();
    son::node::Node* res = nullptr;
    switch (opcode) {
      case PrimjsOpcode::OP_gt:
      case PrimjsOpcode::OP_gte:
      case PrimjsOpcode::OP_lt:
      case PrimjsOpcode::OP_lte: {
        auto desc = son::node::CallDescriptors::prim_js_relation_slow_gc();
        res = CallRuntime(desc, ctx, op1, op2, Int8Value((int)opcode));
        break;
      }
      case PrimjsOpcode::OP_eq:
      case PrimjsOpcode::OP_neq: {
        int flags = opcode == PrimjsOpcode::OP_neq ? 1 : 0;
        auto desc = son::node::CallDescriptors::prim_js_eq_slow_gc();
        res = CallRuntime(desc, ctx, op1, op2, Int32Value(flags));
        break;
      }
      case PrimjsOpcode::OP_strict_eq:
      case PrimjsOpcode::OP_strict_neq: {
        int flags = opcode == PrimjsOpcode::OP_strict_neq ? 1 : 0;
        auto desc = son::node::CallDescriptors::prim_js_strict_eq_slow_gc();

        res = CallRuntime(desc, ctx, op1, op2, Int32Value(flags));
        break;
      }
      default:
        unreachable();
        break;
    }
    DecSp();
    StoreTop0(res);
    Dispatch(opcode);
  }
}

void HandlerImpl::WrapUnaryEntry(son::node::Node* op1, son::node::Label* is_int,
                                 son::node::Label* is_float64,
                                 son::node::Label* slow) {
  son::node::Label not_ptr(this);
  // 0xffff000000000000ll
  auto ptr_tag = Int64Value(LEPUS_PTR_TAG);
  // 0xfffe000000000000
  auto numer_tag = Int64Value(NUMBER_TAG);
  auto cond = UnsignedLessThan(op1, ptr_tag);
  Branch(cond, &not_ptr, slow, son::node::BranchHint::kTrue);
  Bind(&not_ptr);
  {
    son::node::Label op1_not_int(this);
    cond = UnsignedLessThan(op1, numer_tag);
    Branch(cond, &op1_not_int, is_int, son::node::BranchHint::kFalse);
    Bind(&op1_not_int);
    {
      auto and_val = Int64And(op1, numer_tag);
      cond = Equal(and_val, Int64Value(0));
      // not other ptr
      Branch(cond, slow, is_float64, son::node::BranchHint::kFalse);
    }
  }
}

void HandlerImpl::WrapBinaryEntry(son::node::Node* op1, son::node::Node* op2,
                                  son::node::Label* both_is_int,
                                  son::node::Label* slow,
                                  const BinaryOperation& binary_op) {
  son::node::Label not_ptr(this);
  son::node::Label op1_not_int(this);
  son::node::Label op1_int(this);
  son::node::Label op1_int_op2_not_int(this);
  son::node::Label op1_float64_op2_not_int(this);

  // 0xffff000000000000ll
  auto ptr_tag = Int64Value(LEPUS_PTR_TAG);
  // 0xfffe000000000000
  auto numer_tag = Int64Value(NUMBER_TAG);
  auto cond1 = UnsignedLessThan(op1, ptr_tag);
  auto cond2 = UnsignedLessThan(op2, ptr_tag);
  auto cond = BoolAnd(cond1, cond2);
  Branch(cond, &not_ptr, slow, son::node::BranchHint::kTrue);
  Bind(&not_ptr);
  {
    cond = UnsignedLessThan(op1, numer_tag);
    Branch(cond, &op1_not_int, &op1_int, son::node::BranchHint::kFalse);
    Bind(&op1_int);
    {
      cond = UnsignedLessThan(op2, numer_tag);
      Branch(cond, &op1_int_op2_not_int, both_is_int,
             son::node::BranchHint::kFalse);
    }
    Bind(&op1_not_int);
    {
      son::node::Label op1_float64(this);
      son::node::Label op1_float64_op2_int(this);

      auto and_val = Int64And(op1, numer_tag);
      cond = Equal(and_val, Int64Value(0));
      // not other ptr
      Branch(cond, slow, &op1_float64, son::node::BranchHint::kFalse);
      Bind(&op1_float64);
      {
        cond = UnsignedLessThan(op2, numer_tag);
        Branch(cond, &op1_float64_op2_not_int, &op1_float64_op2_int,
               son::node::BranchHint::kFalse);
        Bind(&op1_float64_op2_int);
        {
          // 2 is int
          binary_op(BinaryOpState::kLeftFloat64RightInt);
        }
      }
    }
    Bind(&op1_int_op2_not_int);
    {
      son::node::Label op2_is_float64(this);

      auto and_val = Int64And(op2, numer_tag);
      cond = Equal(and_val, Int64Value(0));
      // not other ptr
      Branch(cond, slow, &op2_is_float64, son::node::BranchHint::kFalse);
      Bind(&op2_is_float64);
      {
        // 1 is int
        binary_op(BinaryOpState::kLeftIntRightFloat64);
      }
    }
    Bind(&op1_float64_op2_not_int);
    {
      son::node::Label op2_is_float64(this);

      auto and_val = Int64And(op2, numer_tag);
      cond = Equal(and_val, Int64Value(0));
      // not other ptr
      Branch(cond, slow, &op2_is_float64, son::node::BranchHint::kFalse);
      Bind(&op2_is_float64);
      { binary_op(BinaryOpState::kBothFloat64); }
    }
  }
}

void HandlerImpl::GenUnaryArithOp(PrimjsOpcode opcode) {
  // LEPUSValue op1;
  // int val;
  // op1 = sp[-1];
  // if (LEPUS_VALUE_IS_INT(op1)) {
  //   val = LEPUS_VALUE_GET_INT(op1);
  //   if (unlikely(val == INT32_MIN)) goto dec_slow;
  //   sp[-1] = LEPUS_NewInt32(ctx, val - 1);
  // } else {
  // dec_slow:
  //   sp[-1] = prim_js_unary_arith_slow_gc(ctx, op1, OP_dec);
  //   if (unlikely(LEPUS_IsException(sp[-1]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  // }
  son::node::Label is_int(this);
  son::node::Label is_float64(this);
  son::node::Label set_int(this);
  son::node::Label slow(this);

  son::node::Node* op1 = nullptr;
  son::node::Node* var_buf = nullptr;
  son::node::Node* idx = nullptr;
  if ((opcode == PrimjsOpcode::OP_dec_loc) ||
      (opcode == PrimjsOpcode::OP_inc_loc)) {
    idx = Fetch_8(0);
    var_buf = RestoreVarBuf();
    op1 = LoadLepusVal(var_buf, idx);
  } else {
    op1 = LoadTop0();
  }

  WrapUnaryEntry(op1, &is_int, &is_float64, &slow);
  Bind(&is_int);
  {
    son::node::Node* val = nullptr;
    auto int_val = GetLepusInt(op1);
    if ((opcode == PrimjsOpcode::OP_dec) ||
        (opcode == PrimjsOpcode::OP_dec_loc)) {
      val = Int32SubOverflow(int_val, Int32Value(1));
      // {i32, i1}
      auto overflow = ExtractValue(val, 1);
      val = ExtractValue(val, 0);
      Branch(overflow, &slow, &set_int, son::node::BranchHint::kFalse);
      Bind(&set_int);
    } else if ((opcode == PrimjsOpcode::OP_inc) ||
               (opcode == PrimjsOpcode::OP_inc_loc)) {
      val = Int32AddOverflow(int_val, Int32Value(1));
      // {i32, i1}
      auto overflow = ExtractValue(val, 1);
      val = ExtractValue(val, 0);
      Branch(overflow, &slow, &set_int, son::node::BranchHint::kFalse);
      Bind(&set_int);
    } else {
      vmassert(opcode == PrimjsOpcode::OP_neg, "must be");
      auto cond1 = Equal(int_val, IntValue(0));
      auto cond2 = Equal(int_val, IntValue(INT32_MIN));
      Branch(BoolOr(cond1, cond2), &slow, &set_int,
             son::node::BranchHint::kFalse);
      Bind(&set_int);
      val = Int32Sub(IntValue(0), int_val);
    }

    if ((opcode == PrimjsOpcode::OP_dec) || (opcode == PrimjsOpcode::OP_inc)) {
      StoreTop0(NewInt32(val));
    } else if ((opcode == PrimjsOpcode::OP_dec_loc) ||
               (opcode == PrimjsOpcode::OP_inc_loc)) {
      StoreLepusVal(var_buf, idx, NewInt32(val));
    } else if (opcode == PrimjsOpcode::OP_neg) {
      StoreTop0(NewInt32(val));
    }
    Dispatch(opcode);
  }
  Bind(&is_float64);
  {
    son::node::Node* res = nullptr;
    auto op1_float64_val = GetLepusFloat64(op1);
    if ((opcode == PrimjsOpcode::OP_dec) ||
        (opcode == PrimjsOpcode::OP_dec_loc)) {
      res = Float64Sub(op1_float64_val, DoubleValue(1.0));
    } else if ((opcode == PrimjsOpcode::OP_inc) ||
               (opcode == PrimjsOpcode::OP_inc_loc)) {
      res = Float64Add(op1_float64_val, DoubleValue(1.0));
    } else {
      vmassert(opcode == PrimjsOpcode::OP_neg, "must be");
      res = Float64Sub(DoubleValue(0.0), op1_float64_val);
    }

    if ((opcode == PrimjsOpcode::OP_dec) || (opcode == PrimjsOpcode::OP_inc)) {
      StoreTop0(NewFloat64(res));
    } else if ((opcode == PrimjsOpcode::OP_dec_loc) ||
               (opcode == PrimjsOpcode::OP_inc_loc)) {
      StoreLepusVal(var_buf, idx, NewFloat64(res));
    } else if (opcode == PrimjsOpcode::OP_neg) {
      StoreTop0(NewFloat64(res));
    }
    Dispatch(opcode);
  }
  Bind(&slow);
  {
    auto ctx = GetCtx();
    auto desc = son::node::CallDescriptors::prim_js_unary_arith_slow_gc();
    int opcode1 = 0;
    if ((opcode == PrimjsOpcode::OP_dec_loc) ||
        (opcode == PrimjsOpcode::OP_inc_loc)) {
      opcode1 = opcode == PrimjsOpcode::OP_dec_loc ? (int)PrimjsOpcode::OP_dec
                                                   : (int)PrimjsOpcode::OP_inc;
    } else {
      opcode1 = (int)opcode;
    }
    auto ret_val = CallRuntimeArg2(desc, ctx, op1, Int8Value(opcode1));
    if ((opcode == PrimjsOpcode::OP_dec_loc) ||
        (opcode == PrimjsOpcode::OP_inc_loc)) {
      idx = Fetch_8(0);
      StoreLepusVal(var_buf, idx, ret_val);
    } else {
      StoreTop0(ret_val);
    }
    Dispatch(opcode);
  }
}

void HandlerImpl::GenPlusOp(PrimjsOpcode opcode) {
  son::node::Label done(this);
  son::node::Label slow(this);
  // op1 = sp[-1];
  // if (LEPUS_VALUE_IS_INT(op1) || LEPUS_VALUE_IS_FLOAT64(op1)) {
  // } else {
  //   if (js_unary_arith_slow(ctx, sp, static_cast<OPCodeEnum>(opcode)))
  //     goto exception;
  // }
  auto op1 = LoadTop0();
  WrapUnaryEntry(op1, &done, &done, &slow);
  Bind(&slow);
  {
    auto ctx = GetCtx();
    auto desc = son::node::CallDescriptors::prim_js_unary_arith_slow_gc();
    auto ret_val = CallRuntimeArg2(desc, ctx, op1, Int8Value((uint8_t)opcode));
    StoreTop0(ret_val);
    Jump(&done);
  }
  Bind(&done);
  Dispatch(opcode);
}

void HandlerImpl::GenPostInc(PrimjsOpcode opcode) {
  // if (js_post_inc_slow_gc(ctx, sp, static_cast<OPCodeEnum>(OP_post_dec))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // sp++;
  son::node::Label is_int(this);
  son::node::Label is_float64(this);
  son::node::Label slow(this);

  auto op1 = LoadTop0();
  WrapUnaryEntry(op1, &is_int, &is_float64, &slow);

  Bind(&is_int);
  {
    son::node::Label set_int(this);
    son::node::Node* val = nullptr;
    auto int_val = GetLepusInt(op1);
    if (opcode == PrimjsOpcode::OP_post_dec) {
      val = Int32SubOverflow(int_val, Int32Value(1));
    } else {
      vmassert(opcode == PrimjsOpcode::OP_post_inc, "must be");
      val = Int32AddOverflow(int_val, Int32Value(1));
    }
    auto overflow = ExtractValue(val, 1);
    val = ExtractValue(val, 0);
    Branch(overflow, &slow, &set_int, son::node::BranchHint::kFalse);
    Bind(&set_int);
    {
      ClearNewSp();
      PushSp(NewInt32(val));
      Dispatch(opcode);
    }
  }
  Bind(&is_float64);
  {
    ClearNewSp();
    son::node::Node* res = nullptr;
    auto float64_val = GetLepusFloat64(op1);
    if (opcode == PrimjsOpcode::OP_post_dec) {
      res = Float64Sub(float64_val, DoubleValue(1.0));
    } else {
      vmassert(opcode == PrimjsOpcode::OP_post_inc, "must be");
      res = Float64Add(float64_val, DoubleValue(1.0));
    }
    PushSp(NewFloat64(res));
    Dispatch(opcode);
  }
  Bind(&slow);
  {
    // restore param sp
    ClearNewSp();
    DispatchWithIdArg0(CallBcIndex::kSlowJSPostInc,
                       Int64Value((uint64_t)opcode));
  }
}

void HandlerImpl::GenNotOp(PrimjsOpcode opcode) {
  // op1 = sp[-1];
  // if (LEPUS_VALUE_IS_INT(op1)) {
  //   sp[-1] = LEPUS_NewInt32(ctx, ~LEPUS_VALUE_GET_INT(op1));
  // } else {
  //   sp[-1] = prim_js_not_slow_gc(ctx, op1);
  //   if (unlikely(LEPUS_IsException(sp[-1]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  // }
  son::node::Label is_int(this);
  son::node::Label set_int(this);
  son::node::Label slow(this);
  auto op1 = LoadTop0();

  Branch(IsLepusInt(op1), &is_int, &slow, son::node::BranchHint::kTrue);
  Bind(&is_int);
  {
    son::node::Node* val = nullptr;
    auto int_val = GetLepusInt(op1);
    val = Int32Not(int_val);
    StoreTop0(NewInt32(val));
    Dispatch(opcode);
  }
  Bind(&slow);
  {
    // restore param sp
    ClearNewSp();
    DispatchWithIdArg0(CallBcIndex::kSlowJSNot, op1);
  }
}

void HandlerImpl::GenLNotOp(PrimjsOpcode opcode) {
  // op1 = sp[-1];
  // int64_t tag = LEPUS_VALUE_GET_TAG(op1);
  // if (tag == LEPUS_TAG_BOOL) {
  //   res = LEPUS_VALUE_GET_BOOL(op1);
  // } else if (tag == LEPUS_TAG_INT) {
  //   res = LEPUS_VALUE_GET_INT(op1);
  // } else if (tag == LEPUS_TAG_UNDEFINED) {
  //   res = 0;
  // } else if (tag == LEPUS_TAG_NULL) {
  //   res = 0;
  // } else {
  //   res = JS_ToBoolFree_GC(ctx, op1);
  // }
  // sp[-1] = LEPUS_NewBool(ctx, !res);
  son::node::Label is_bool_false(this);
  son::node::Label is_int(this);
  son::node::Label is_undefined_or_null(this);
  son::node::Label to_boolean(this);
  son::node::Label if_false(this);
  son::node::Label if_true(this);
  son::node::Label done(this);

  auto op1 = LoadTop0();
  auto cond = Equal(op1, LepusTrue());
  Branch(cond, &if_true, &is_bool_false);
  Bind(&is_bool_false);
  {
    cond = Equal(op1, LepusFalse());
    Branch(cond, &if_false, &is_undefined_or_null);
  }
  Bind(&is_undefined_or_null);
  {
    auto cond1 = Equal(op1, LepusUndefined());
    auto cond2 = Equal(op1, LepusNull());
    auto cond3 = Equal(op1, Int64Value(AccessBuilder::JS_NewInt32(0)));
    cond = BoolOr(cond1, cond2);
    Branch(BoolOr(cond, cond3), &if_false, &is_int);
  }
  Bind(&is_int);
  {
    cond = IsLepusInt(op1);
    // not int 0
    Branch(cond, &if_true, &to_boolean, son::node::BranchHint::kTrue);
  }
  Bind(&to_boolean);
  { DispatchWithIdArg0(CallBcIndex::kSlowToBoolean, op1); }
  Bind(&if_true);
  {
    StoreTop0(LepusFalse());
    Jump(&done);
  }
  Bind(&if_false);
  {
    StoreTop0(LepusTrue());
    Jump(&done);
  }
  Bind(&done);
  Dispatch(opcode);
}

void HandlerImpl::GenIfBranch(PrimjsOpcode opcode) {
  // int res;
  // LEPUSValue op1;

  // op1 = sp[-1];
  // pc += 4;
  // int64_t tag = LEPUS_VALUE_GET_TAG(op1);
  // if (tag == LEPUS_TAG_BOOL) {
  //   res = LEPUS_VALUE_GET_BOOL(op1);
  // } else if (tag == LEPUS_TAG_INT) {
  //   res = LEPUS_VALUE_GET_INT(op1);
  // } else if (tag == LEPUS_TAG_UNDEFINED) {
  //   res = 0;
  // } else if (tag == LEPUS_TAG_NULL) {
  //   res = 0;
  // } else {
  //   res = JS_ToBoolFree_GC(ctx, op1);
  // }
  // sp--;
  // if (res) {
  //   pc += (int32_t)get_u32(pc - 4) - 4;
  // }
  bool branch_condition = (opcode == PrimjsOpcode::OP_if_true8) ||
                          (opcode == PrimjsOpcode::OP_if_true);
  son::node::Label is_bool_false(this);
  son::node::Label check_is_int(this);
  son::node::Label is_undefined_or_null(this);
  son::node::Label to_boolean(this);
  son::node::Label if_false(this);
  son::node::Label if_true(this);

  auto op1 = LoadTop0();
  DecSp();
  auto cond = Equal(op1, LepusTrue());
  Branch(cond, &if_true, &is_bool_false);
  Bind(&is_bool_false);
  {
    cond = Equal(op1, LepusFalse());
    Branch(cond, &if_false, &is_undefined_or_null);
  }
  Bind(&is_undefined_or_null);
  {
    auto cond1 = Equal(op1, LepusUndefined());
    auto cond2 = Equal(op1, LepusNull());
    auto cond3 = Equal(op1, Int64Value(AccessBuilder::JS_NewInt32(0)));
    cond = BoolOr(cond1, cond2);
    Branch(BoolOr(cond, cond3), &if_false, &check_is_int);
  }
  Bind(&check_is_int);
  {
    son::node::Label is_float64(this);
    // not int 0
    WrapUnaryEntry(op1, &if_true, &is_float64, &to_boolean);
    cond = IsLepusInt(op1);

    Bind(&is_float64);
    {
      // return !isnan(d) && d != 0;
      auto op1_float64_val = GetLepusFloat64(op1);
      auto cond1 = NotEqual(op1_float64_val, DoubleValue(0.0));
      auto cond2 = DoubleNotNaN(op1_float64_val);
      cond = BoolAnd(cond1, cond2);
      Branch(cond, &if_true, &if_false);
    }
  }
  if (branch_condition) {
    Bind(&if_true);
  } else {
    Bind(&if_false);
  }
  {
    son::node::Node* imm = nullptr;
    if ((opcode == PrimjsOpcode::OP_if_true8) ||
        (opcode == PrimjsOpcode::OP_if_false8)) {
      imm = Fetch_S8(0);
    } else {
      imm = Fetch_S32(0);
    }
    auto offset = SExtInt32ToIntPtr(imm);
    DispatchJmp(offset);
  }
  if (branch_condition) {
    Bind(&if_false);
  } else {
    Bind(&if_true);
  }
  Dispatch(opcode);

  Bind(&to_boolean);
  {
    ClearNewSp();
    DispatchWithIdArg0(CallBcIndex::kSlowToBoolean, op1);
  }
}

void HandlerImpl::GenToPropertyKey(PrimjsOpcode opcode) {
  // if (unlikely(LEPUS_IsUndefined(sp[-2]) || LEPUS_IsNull(sp[-2]))) {
  //   LEPUS_ThrowTypeError(ctx, "value has no property");
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // switch (LEPUS_VALUE_GET_TAG(sp[-1])) {
  //   case LEPUS_TAG_INT:
  //   case LEPUS_TAG_STRING:
  //   case LEPUS_TAG_SYMBOL:
  //   case LEPUS_TAG_SEPARABLE_STRING:
  //     break;
  //   default:
  //     auto ret_val = LEPUS_ToPropertyKey(ctx, sp[-1]);
  //     if (LEPUS_IsException(ret_val)) {
  //       TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //     }
  //     sp[-1] = ret_val;
  //     break;
  // }

  if (opcode == PrimjsOpcode::OP_to_propkey2) {
    son::node::Label is_undefined_or_null(this);
    son::node::Label exit(this);

    auto prop = LoadTop1();
    auto cond1 = Equal(prop, LepusUndefined());
    auto cond2 = Equal(prop, LepusNull());
    Branch(BoolOr(cond1, cond2), &is_undefined_or_null, &exit,
           son::node::BranchHint::kFalse);
    Bind(&is_undefined_or_null);
    {
      auto message = Message("value has no property");
      auto desc = son::node::CallDescriptors::LEPUS_ThrowTypeError();
      CallJumpException(desc, GetCtx(), message);
    }
    Bind(&exit);
  }
  auto op1 = LoadTop0();

  son::node::Label is_property_key(this);
  son::node::Label not_int(this);
  son::node::Label not_string(this);
  son::node::Label not_symbol(this);
  son::node::Label not_property_key(this);

  Branch(IsLepusInt(op1), &is_property_key, &not_int);
  Bind(&not_int);
  { Branch(IsStringValue(op1), &is_property_key, &not_string); }
  Bind(&not_string);
  { Branch(IsSymbolValue(op1), &is_property_key, &not_symbol); }
  Bind(&not_symbol);
  {
    Branch(IsSeparableStringValue(op1), &is_property_key, &not_property_key,
           son::node::BranchHint::kTrue);
  }
  Bind(&is_property_key);
  Dispatch(opcode);

  Bind(&not_property_key);
  {
    ClearNewSp();
    auto desc = son::node::CallDescriptors::JS_ToPropertyKey_GC();
    auto res = CallRuntime(desc, GetCtx(), op1);
    StoreTop0(res);
    Dispatch(opcode);
  }
}

void HandlerImpl::CheckUninitialized(son::node::Node* val, bool check_init,
                                     bool check_local) {
  son::node::Label is_uninitialized(this);
  son::node::Label done(this);

  auto cond =
      check_init ? NotEqual(val, Uninitialized()) : Equal(val, Uninitialized());
  Branch(cond, &is_uninitialized, &done, son::node::BranchHint::kFalse);
  Bind(&is_uninitialized);
  {
    if (check_local) {
      DispatchWithId(CallBcIndex::kThrowThisReferenceError);
    } else {
      DispatchWithId(CallBcIndex::kThrowReferenceErrorUninitialized);
    }
  }
  Bind(&done);
}

void HandlerImpl::GenGetBuf(PrimjsOpcode opcode, int idx, bool is_ref,
                            son::node::Node* buf) {
  son::node::Node* index = nullptr;
  if (idx < 0) {
    if ((opcode == PrimjsOpcode::OP_get_arg) ||
        (opcode == PrimjsOpcode::OP_get_loc) ||
        (opcode == PrimjsOpcode::OP_get_loc_check) ||
        (opcode == PrimjsOpcode::OP_get_var_ref) ||
        (opcode == PrimjsOpcode::OP_get_var_ref_check)) {
      index = Fetch_16(0);
    } else {
      vmassert(opcode == PrimjsOpcode::OP_get_loc8, "must be");
      index = Fetch_8(0);
    }
  } else {
    index = IntValue(idx);
  }
  son::node::Node* val = nullptr;
  if (is_ref) {
    // *sp++ = *sf->var_refs_cache[0]->pvalue;
    auto var_ref = LoadRawVal(buf, index);
    auto pvalue = LoadRawVal(var_ref, AccessBuilder::var_ref_pvalue_off());
    val = LoadLepusVal(pvalue, IntValue(0));
  } else {
    val = LoadLepusVal(buf, index);
  }
  if (opcode == PrimjsOpcode::OP_get_var_ref_check ||
      opcode == PrimjsOpcode::OP_get_loc_check) {
    CheckUninitialized(val, false, false);
  }
  PushSp(val);
  Dispatch(opcode);
}

void HandlerImpl::GenSetBuf(PrimjsOpcode opcode, int idx, bool is_put,
                            bool is_ref, son::node::Node* buf) {
  son::node::Node* index = nullptr;
  bool need_ref_check_init =
      (opcode == PrimjsOpcode::OP_put_var_ref_check) ||
      (opcode == PrimjsOpcode::OP_put_var_ref_check_init);
  bool need_loc_check_init = (opcode == PrimjsOpcode::OP_put_loc_check) ||
                             (opcode == PrimjsOpcode::OP_put_loc_check_init);
  if (idx < 0) {
    bool is_local_16 = (opcode == PrimjsOpcode::OP_put_loc) ||
                       (opcode == PrimjsOpcode::OP_set_loc);
    if ((opcode == PrimjsOpcode::OP_set_arg) ||
        (opcode == PrimjsOpcode::OP_set_var_ref) ||
        (opcode == PrimjsOpcode::OP_put_arg) ||
        (opcode == PrimjsOpcode::OP_put_var_ref) || need_ref_check_init ||
        is_local_16 || need_loc_check_init) {
      index = Fetch_16(0);
    } else {
      vmassert((opcode == PrimjsOpcode::OP_set_loc8) ||
                   (opcode == PrimjsOpcode::OP_put_loc8),
               "must be");
      index = Fetch_8(0);
    }
  } else {
    index = IntValue(idx);
  }
  son::node::Node* val = LoadTop0();
  if (is_ref) {
    auto var_ref = LoadRawVal(buf, index);
    auto pvalue = LoadRawVal(var_ref, AccessBuilder::var_ref_pvalue_off());
    if (need_ref_check_init) {
      auto old_val = LoadLepusVal(pvalue, IntValue(0));
      bool check_init = opcode == PrimjsOpcode::OP_put_var_ref_check_init;
      CheckUninitialized(old_val, check_init, false);
    }
    StoreLepusVal(pvalue, IntValue(0), val);
  } else {
    if (need_loc_check_init) {
      bool check_init = (opcode == PrimjsOpcode::OP_put_loc_check_init);
      auto old_val = LoadLepusVal(buf, index);
      CheckUninitialized(old_val, check_init, check_init);
    }
    StoreLepusVal(buf, index, val);
  }
  if (is_put) {
    DecSp();
  }
  Dispatch(opcode);
}

void HandlerImpl::FindOwnProperty(
    son::node::Node* obj, son::node::Node* atom, son::node::Label* fail_exit,
    const FindOwnPropertyOperation& get_property_value) {
  son::node::Label success(this);
  son::node::Label exit(this);

  // sh = p->shape;
  auto sh = LoadObjectShape(obj);
  // h = (uintptr_t)atom & sh->prop_hash_mask;
  auto hash_mask = LoadShapePropHashMask(sh);
  auto h = Int32And(atom, hash_mask);
  // h = sh->hash_table[h];
  auto hash_table_offset = AccessBuilder::shape_hash_table_offset();
  auto hash_table = IntPtrAdd(sh, IntPtrValue(hash_table_offset));
  h = LoadIntVal(CastToRaw(hash_table), h);
  // prop = get_shape_prop(sh) = hash_table + (prop_hash_mask + 1)
  auto hash_size = Int32Add(hash_mask, Int32Value(1));
  auto prop_offset = Int32Mul(hash_size, Int32Value(sizeof(uint32_t)));
  auto prop = IntPtrAdd(hash_table, ZExtInt32ToIntPtr(prop_offset));

  son::node::Label next(this);
  son::node::Label next1(this);
  son::node::Label loop(this, true);
  son::node::Variable var_h(this, son::node::NodeType::IntType(), h);

  BindLoop(&loop, 2);
  {
    // while(h != 0)
    auto condition = NotEqual(*var_h, IntValue(0));
    Branch(condition, &next, fail_exit, son::node::BranchHint::kTrue);

    son::node::Node* pr = nullptr;
    Bind(&next);
    {
      // pr = &prop[h - 1];
      auto offset = Int32Mul(Int32Add(*var_h, IntValue(-1)),
                             Int32Value(sizeof(JSShapeProperty)));
      pr = CastToRaw(IntPtrAdd(prop, ZExtInt32ToIntPtr(offset)));
      // if (likely(pr->atom == atom)) {
      auto cond = Equal(LoadJsShapePropertyAtom(pr), atom);
      Branch(cond, &exit, &next1, son::node::BranchHint::kFalse);
      Bind(&next1);
      // h = pr->hash_next;
      var_h = LoadJsShapePropertyHashNext(pr);
      Jump(&loop);
      Bind(&exit);
      { get_property_value(pr, *var_h); }
    }
  }
}

son::node::Node* HandlerImpl::FindPropertyForGet(son::node::Node* obj,
                                                 son::node::Node* atom,
                                                 son::node::Label* slow_get,
                                                 son::node::Label* not_found) {
  son::node::Variable res_h(this, son::node::NodeType::Int64Type(),
                            LepusUndefined());
  son::node::Label success_exit(this);
  if (not_found == nullptr) {
    not_found = &success_exit;
  }

  auto func = [&](son::node::Node* prs, son::node::Node* obj,
                  son::node::Node* h) {
    son::node::Label check_succ(this);
    // if (unlikely(prs->flags & LEPUS_PROP_TMASK)) {
    // } else {
    // return pr->u.value;
    // }
    auto flags = LoadJsShapePropertyHashFlags(prs);
    auto cond = Equal(Int32And(flags, IntValue(LEPUS_PROP_TMASK)), IntValue(0));
    Branch(cond, &check_succ, slow_get, son::node::BranchHint::kTrue);
    Bind(&check_succ);
    {
      // *ppr = &p->prop[h - 1];
      auto pr = LoadObjectProp(obj);
      auto h_index = Int32Sub(h, IntValue(1));
      auto property_size = Int32Value(sizeof(JSPropertyGC) / sizeof(int64_t));
      // val = pr->u.value;
      res_h = LoadLepusVal(pr, Int32Mul(h_index, property_size));
      Jump(&success_exit);
    }
  };
  FindProperty(obj, atom, slow_get, not_found, func);
  Bind(&success_exit);
  return *res_h;
}

void HandlerImpl::FindPropertyForSet(son::node::Node* obj,
                                     son::node::Node* atom,
                                     son::node::Node* val,
                                     son::node::Label* slow_set,
                                     son::node::Label* not_found) {
  son::node::Label prototype_lookup(this);
  son::node::Label success_exit(this);

  auto func = [&](son::node::Node* prs, son::node::Node* h) {
    son::node::Label check_succ(this);
    // if (likely((prs->flags & (LEPUS_PROP_TMASK | LEPUS_PROP_WRITABLE |
    //                       LEPUS_PROP_LENGTH)) == LEPUS_PROP_WRITABLE)) {
    auto flags = LoadJsShapePropertyHashFlags(prs);
    auto mask =
        IntValue(LEPUS_PROP_TMASK | LEPUS_PROP_WRITABLE | LEPUS_PROP_LENGTH);
    auto cond = Equal(Int32And(flags, mask), IntValue(LEPUS_PROP_WRITABLE));
    Branch(cond, &check_succ, slow_set, son::node::BranchHint::kTrue);
    Bind(&check_succ);
    {
      // *ppr = &p->prop[h - 1];
      auto pr = LoadObjectProp(obj);
      auto h_index = Int32Sub(h, IntValue(1));
      auto property_size = Int32Value(sizeof(JSPropertyGC) / sizeof(int64_t));
      // set_value_gc(ctx, &pr->u.value, val);
      StoreHeapVal(GetCtx(), pr, Int32Mul(h_index, property_size), val);
      Jump(&success_exit);
    }
  };
  FindOwnProperty(obj, atom, &prototype_lookup, func);

  Bind(&prototype_lookup);
  {
    auto func = [&](son::node::Node* prs, son::node::Node* obj,
                    son::node::Node* h) { Jump(slow_set); };
    FindProperty(obj, atom, slow_set, not_found, func);
  }
  Bind(&success_exit);
}

void HandlerImpl::FindProperty(son::node::Node* obj, son::node::Node* atom,
                               son::node::Label* slow,
                               son::node::Label* not_found,
                               const FindPropertyOperation& found_func) {
  son::node::Label out_loop(this);
  son::node::Label next_proto(this);

  son::node::Variable object_h(this, son::node::NodeType::RawType(), obj);
  BindLoop(&out_loop, 2);
  {
    auto func = [&](son::node::Node* prs, son::node::Node* h) {
      found_func(prs, *object_h, h);
    };
    FindOwnProperty(*object_h, atom, &next_proto, func);
    Bind(&next_proto);
    {
      son::node::Label not_exotic(this);

      auto is_exotic = LoadObjectIsExotic(*object_h);
      Branch(is_exotic, slow, &not_exotic, son::node::BranchHint::kFalse);

      Bind(&not_exotic);
      {
        auto sh = LoadObjectShape(*object_h);
        object_h = LoadShapeProto(sh);
        auto cond = NotEqual(*object_h, NullptrValue());
        Branch(cond, &out_loop, not_found, son::node::BranchHint::kTrue);
      }
    }
  }
}

void HandlerImpl::GenSetProperty() {
  // int ret;
  // JSAtom atom;
  // atom = get_u32(pc);
  // pc += 4;

  // ret = JS_SetPropertyInternalImpl_GC(ctx, sp[-2], atom, sp[-1],
  //                                     LEPUS_PROP_THROW_STRICT);
  // sp -= 2;
  // if (unlikely(ret < 0)) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  PrimjsOpcode opcode = PrimjsOpcode::OP_put_field;
  son::node::Label slow_put(this);
  son::node::Label try_fast_set(this);
  son::node::Label throw_e(this);
  son::node::Label add_prop(this);

  // C0_C1
  auto obj = LoadTop1();
  auto val = LoadTop0();
  auto obj_raw = CastToRaw(obj);
  auto atom = Fetch_32(0);

  if (!_use_fast_path) {
    auto desc = son::node::CallDescriptors::JS_SetPropertyInternalImpl_GC();
    CallIntRetRuntime(desc, GetCtx(), obj, atom, val,
                      IntValue(LEPUS_PROP_THROW_STRICT));
    DecSp(2);
    Dispatch(opcode);
    return;
  }

  // if (likely(LEPUS_VALUE_IS_OBJECT(obj))) {
  Branch(IsLepusObject(obj), &try_fast_set, &slow_put,
         son::node::BranchHint::kTrue);
  Bind(&try_fast_set);

  FindPropertyForSet(obj_raw, atom, val, &slow_put, &add_prop);
  {
    ClearNewSp();
    DecSp(2);
    Dispatch(opcode);
  }
  Bind(&add_prop);
  {
    ClearNewSp();
    auto is_extensible = LoadObjectIsExtensible(obj_raw);
    BranchIfFalse(is_extensible, &slow_put);

    auto desc = son::node::CallDescriptors::add_property_gc();
    auto pr = CallRuntimeNoCheck(desc, GetCtx(), obj_raw, atom,
                                 IntValue(LEPUS_PROP_C_W_E));
    BranchIf(Equal(pr, NullptrValue()), &throw_e);
    // HeapObjStore(ctx, &pr->u.value, val);
    auto val1 = LoadTop0();
    StoreHeapVal(GetCtx(), pr, Int32Value(0), val1);
    DecSp(2);
    Dispatch(opcode);
  }

  Bind(&slow_put);
  {
    ClearNewSp();
    auto desc = son::node::CallDescriptors::JS_SetPropertyInternalImpl_GC();
    CallIntRetRuntime(desc, GetCtx(), obj, atom, val,
                      IntValue(LEPUS_PROP_THROW_STRICT));
    DecSp(2);
    Dispatch(opcode);
  }
  Bind(&throw_e);
  {
    ClearNewSp();
    DecSp(2);
    DispatchException();
  }
}

void HandlerImpl::GenGetGlobalVarCommon(PrimjsOpcode opcode,
                                        son::node::Label* slow_get) {
  bool throw_error = (opcode == PrimjsOpcode::OP_get_var);
  auto obj = CastToRaw(GetGlobalVar());
  auto atom = TruncInt64ToInt32(Fetch_32(0));

  son::node::Label success_exit(this);

  son::node::Variable res_h(this, son::node::NodeType::Int64Type(),
                            LepusUndefined());

  son::node::Label get_global(this);
  auto func = [&](son::node::Node* prs, son::node::Node* h) {
    // auto ppr = &p->prop[h - 1];
    auto pr = LoadObjectProp(obj);
    auto h_index = Int32Sub(h, IntValue(1));
    auto property_size = Int32Value(sizeof(JSPropertyGC) / sizeof(int64_t));
    // val = ppr->u.value;
    res_h = LoadLepusVal(pr, Int32Mul(h_index, property_size));
    Jump(&success_exit);
  };
  FindOwnProperty(obj, atom, &get_global, func);
  Bind(&get_global);
  {
    obj = CastToRaw(GetGlobal());
    son::node::Node* ret_val = nullptr;
    if (throw_error) {
      ret_val = FindPropertyForGet(obj, atom, slow_get, slow_get);
    } else {
      ret_val = FindPropertyForGet(obj, atom, slow_get, nullptr);
    }
    res_h = ret_val;
    Jump(&success_exit);
  }

  Bind(&success_exit);
  {
    auto ret_val = *res_h;
    CheckUninitialized(ret_val, false, false);
    {
      ClearNewSp();
      PushSp(ret_val);
      Dispatch(opcode);
    }
  }
}

void HandlerImpl::GenGetGlobalVar(PrimjsOpcode opcode) {
  bool throw_error = (opcode == PrimjsOpcode::OP_get_var);

  if (_use_fast_path) {
    son::node::Label slow_get(this);

    GenGetGlobalVarCommon(opcode, &slow_get);
    Bind(&slow_get);
  }
  {
    ClearNewSp();
    son::node::Node* flag = nullptr;
    if (throw_error) {
      flag = Int32Value(1);
    } else {
      flag = Int32Value(0);
    }
    auto atom = Fetch_32(0);
    auto desc = son::node::CallDescriptors::JS_GetGlobalVarImpl_GC();
    auto ret_val = CallRuntimeArg2(desc, GetCtx(), atom, flag);
    PushSp(ret_val);
    Dispatch(opcode);
  }
}

void HandlerImpl::GenGetField(PrimjsOpcode opcode) {
  auto obj = LoadTop0();
  auto obj_raw = CastToRaw(obj);
  son::node::Node* atom = nullptr;
  if (opcode == PrimjsOpcode::OP_get_length) {
    atom = IntValue(JS_ATOM_length);
  } else {
    atom = Fetch_32(0);
  }
  if (_use_fast_path) {
    son::node::Label slow_get(this);
    // if (likely(LEPUS_VALUE_IS_OBJECT(obj))) {
    BranchIfFalse(IsLepusObject(obj), &slow_get, son::node::BranchHint::kTrue);
    auto ret_val = FindPropertyForGet(obj_raw, atom, &slow_get, nullptr);
    {
      ClearNewSp();
      if (opcode == PrimjsOpcode::OP_get_field2) {
        PushSp(ret_val);
      } else {
        StoreTop0(ret_val);
      }
      Dispatch(opcode);
    }
    Bind(&slow_get);
  }
  {
    ClearNewSp();
    auto desc = son::node::CallDescriptors::JS_GetPropertyInternalImpl_GC();
    auto ret_val = CallRuntime(desc, GetCtx(), obj, atom, obj, IntValue(0));
    if (opcode == PrimjsOpcode::OP_get_field2) {
      PushSp(ret_val);
    } else {
      StoreTop0(ret_val);
    }
    Dispatch(opcode);
  }
}

void HandlerImpl::GenPutField(PrimjsOpcode opcode) { GenSetProperty(); }

void HandlerImpl::GenGetArrayEl(PrimjsOpcode opcode) {
  son::node::Label slow_get(this);

  auto obj = LoadTop1();
  auto prop = LoadTop0();
  if (_use_fast_path) {
    // if (likely(LEPUS_VALUE_IS_OBJECT(obj))) {
    auto cond1 = IsLepusObject(obj);
    auto cond2 = IsLepusInt(prop);
    BranchIfFalse(BoolAnd(cond1, cond2), &slow_get,
                  son::node::BranchHint::kTrue);

    GenGetPropertyValue(opcode, obj, prop, &slow_get);
    Bind(&slow_get);
  }
  {
    auto desc = son::node::CallDescriptors::JS_GetPropertyValue_GC();
    if (opcode == PrimjsOpcode::OP_get_array_el2) {
      auto ret_val = CallRuntime(desc, GetCtx(), obj, prop);
      StoreTop0(ret_val);
    } else {
      ClearNewSp();
      auto ret_val = CallRuntimeArg2(desc, GetCtx(), obj, prop);
      vmassert(opcode == PrimjsOpcode::OP_get_array_el, "msut be");
      DecSp();
      StoreTop0(ret_val);
    }
    Dispatch(opcode);
  }
}

void HandlerImpl::GenGetPropertyValue(PrimjsOpcode opcode, son::node::Node* obj,
                                      son::node::Node* prop,
                                      son::node::Label* slow_get) {
  auto obj_raw = CastToRaw(GetObject(obj));

  son::node::Label fast_get(this);
  {
    son::node::Label is_array(this);
    auto class_id = LoadClassId(obj_raw);
    auto cond = Equal(class_id, Int16Value(JS_CLASS_ARRAY));
    Branch(cond, &is_array, slow_get, son::node::BranchHint::kTrue);
    Bind(&is_array);
    {
      son::node::Label fast_get_prop_atom(this);
      son::node::Label fast_get_prop(this);

      auto int_prop = GetLepusInt(prop);
      auto length = LoadArrayCount(obj_raw);
      auto cond = UnsignedLessThan(int_prop, length);
      Branch(cond, &fast_get, &fast_get_prop_atom,
             son::node::BranchHint::kTrue);
      Bind(&fast_get);
      {
        auto values = LoadArrayValues(obj_raw);
        auto ret_val = LoadLepusVal(values, int_prop);
        if (opcode == PrimjsOpcode::OP_get_array_el) {
          ClearNewSp();
          DecSp();
        }
        StoreTop0(ret_val);
        Dispatch(opcode);
      }
      Bind(&fast_get_prop_atom);
      {
        auto int_prop = GetLepusInt(prop);
        cond = UnsignedLessThanOrEqual(int_prop, IntValue(JS_ATOM_MAX_INT));
        Branch(cond, &fast_get_prop, slow_get, son::node::BranchHint::kTrue);
        Bind(&fast_get_prop);
        {
          auto atom = AtomFromUInt32(int_prop);
          auto ret_val = FindPropertyForGet(obj_raw, atom, slow_get, nullptr);
          if (opcode == PrimjsOpcode::OP_get_array_el) {
            ClearNewSp();
            DecSp();
          }
          StoreTop0(ret_val);
          Dispatch(opcode);
        }
      }
    }
  }
}

void HandlerImpl::CheckFastArrayAdd(son::node::Node* obj,
                                    son::node::Label* slow) {
  son::node::Label check_proto(this);
  son::node::Label done(this);

  auto is_fast_array = LoadObjectIsFastArray(obj);
  auto is_extensible = LoadObjectIsExtensible(obj);
  auto cond = BoolAnd(is_fast_array, is_extensible);
  Branch(cond, &check_proto, slow, son::node::BranchHint::kTrue);
  Bind(&check_proto);

  son::node::Label loop(this);
  son::node::Label next(this);
  son::node::Label next_prop(this);

  // p1 = p->shape->proto;
  auto sh = LoadObjectShape(obj);
  auto p1 = LoadShapeProto(sh);
  son::node::Variable p1_h(this, son::node::NodeType::RawType(), p1);
  BindLoop(&loop, 2);
  {
    auto sh1 = LoadObjectShape(*p1_h);
    cond = Equal(*p1_h, NullptrValue());
    Branch(cond, &done, &next);
    Bind(&next);
    {
      son::node::Label is_array(this);
      son::node::Label not_array(this);
      son::node::Label is_object(this);

      auto class_id = LoadClassId(*p1_h);
      cond = Equal(class_id, Int16Value(JS_CLASS_ARRAY));
      Branch(cond, &is_array, &not_array, son::node::BranchHint::kTrue);
      Bind(&is_array);
      {
        // if (unlikely(!p1->fast_array)) goto slow_path;
        auto is_fast_array = LoadObjectIsFastArray(*p1_h);
        Branch(is_fast_array, &next_prop, slow, son::node::BranchHint::kTrue);
      }
      Bind(&not_array);
      {
        cond = Equal(class_id, Int16Value(JS_CLASS_OBJECT));
        Branch(cond, &is_object, slow, son::node::BranchHint::kTrue);
      }
      Bind(&is_object);
      {
        // if (unlikely(sh1->has_small_array_index)) goto slow_path;
        auto has_small_array_index =
            NotEqual(LoadHasSmallArrayIndex(sh1), Int8Value(0));
        Branch(has_small_array_index, slow, &next_prop,
               son::node::BranchHint::kFalse);
      }
      Bind(&next_prop);
      {
        // p1 = sh1->proto;
        p1_h = LoadShapeProto(sh1);
        Jump(&loop);
      }
    }
  }
  Bind(&done);
}

void HandlerImpl::AddFastArrayElement(son::node::Node* obj,
                                      son::node::Node* len,
                                      son::node::Node* val,
                                      son::node::Label* slow_add) {
  son::node::Label set_val(this);
  son::node::Label next_check(this);
  son::node::Label check_length(this);

  auto new_len = Int32Add(len, IntValue(1));

  // if (likely(LEPUS_VALUE_IS_INT(p->prop[0].u.value))) {
  auto pr = LoadObjectProp(obj);
  auto array_len = LoadLepusVal(pr, IntValue(0));
  auto cond = IsLepusInt(array_len);
  Branch(cond, &check_length, &next_check, son::node::BranchHint::kTrue);

  // if (new_len > array_len) {
  Bind(&check_length);
  cond = UnsignedGreaterThan(new_len, GetLepusInt(array_len));
  Branch(cond, slow_add, &next_check, son::node::BranchHint::kFalse);

  Bind(&next_check);
  // if (unlikely(new_len > p->u.array.u1.size)) {
  auto array_size = LoadArraySize(obj);
  cond = UnsignedGreaterThan(new_len, array_size);
  Branch(cond, slow_add, &set_val, son::node::BranchHint::kFalse);
  Bind(&set_val);
  {
    auto values = LoadArrayValues(obj);
    StoreArrayCount(obj, new_len);
    StoreHeapVal(GetCtx(), values, len, val);
  }
}

void HandlerImpl::GenPutArrayEl(PrimjsOpcode opcode) { GenSetPropertyValue(); }

void HandlerImpl::GenSetPropertyValue() {
  // ret = JS_SetPropertyValue_GC(ctx, sp[-3], sp[-2], sp[-1],
  //     (LEPUS_IsTypedArray(ctx, sp[-3]) ? 0 : LEPUS_PROP_THROW_STRICT));
  // sp -= 3;
  // if (unlikely(ret < 0)) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  PrimjsOpcode opcode = PrimjsOpcode::OP_put_array_el;
  auto prop = LoadTop1();
  auto val = LoadTop0();
  auto this_obj = LoadSp(-3);
  auto obj_raw = CastToRaw(GetObject(this_obj));

  son::node::Node* flags = IntValue(LEPUS_PROP_THROW_STRICT);

  auto init = Int32Value(LEPUS_PROP_THROW_STRICT);
  son::node::Variable flags_var(this, son::node::NodeType::IntType(), init);
  son::node::Label is_type_array(this);
  son::node::Label is_object(this);
  son::node::Label slow_set(this);
  son::node::Label slow_set_type_array(this);
  son::node::Label slow_set_object(this);
  son::node::Label slow_add(this);

  Branch(IsLepusObject(this_obj), &is_object, &slow_set,
         son::node::BranchHint::kTrue);
  Bind(&is_object);
  {
    son::node::Label is_array(this);
    son::node::Label not_array(this);

    auto class_id = LoadClassId(CastToRaw(GetObject(this_obj)));
    auto cond = Equal(class_id, Int16Value(JS_CLASS_ARRAY));
    Branch(cond, &is_array, &not_array, son::node::BranchHint::kTrue);
    Bind(&is_array);
    if (_use_fast_path) {
      son::node::Label fast_set_int(this);

      Branch(IsLepusInt(prop), &fast_set_int, &slow_set,
             son::node::BranchHint::kTrue);
      Bind(&fast_set_int);
      {
        son::node::Label fast_set(this);
        son::node::Label length_overflow(this);
        son::node::Label fast_add(this);

        auto int_prop = GetLepusInt(prop);
        auto length = LoadArrayCount(obj_raw);
        auto cond = UnsignedLessThan(int_prop, length);
        Branch(cond, &fast_set, &length_overflow, son::node::BranchHint::kTrue);
        Bind(&fast_set);
        {
          ClearNewSp();
          auto values = LoadArrayValues(obj_raw);
          StoreHeapVal(GetCtx(), values, int_prop, val);
          DecSp(3);
          Dispatch(opcode);
        }
        Bind(&length_overflow);
        cond = Equal(int_prop, length);
        Branch(cond, &fast_add, &slow_set, son::node::BranchHint::kTrue);
        Bind(&fast_add);
        {
          ClearNewSp();
          CheckFastArrayAdd(obj_raw, &slow_set);
          AddFastArrayElement(obj_raw, length, val, &slow_add);
          DecSp(3);
          Dispatch(opcode);
        }
      }
    } else {
      Jump(&not_array);
    }
    Bind(&not_array);
    {
      // (class_id >= JS_CLASS_UINT8C_ARRAY) && (class_id <=
      // JS_CLASS_BIG_UINT64_ARRAY);
      auto cond1 =
          GreaterThanOrEqual(class_id, Int16Value(JS_CLASS_UINT8C_ARRAY));
      // JS_CLASS_BIG_UINT64_ARRAY for bigint
      auto cond2 =
          LessThanOrEqual(class_id, Int16Value(JS_CLASS_FLOAT64_ARRAY));
      Branch(BoolAnd(cond1, cond2), &slow_set_type_array, &slow_set);
    }
  }
  if (_use_fast_path) {
    Bind(&slow_add);
    {
      ClearNewSp();
      auto desc = son::node::CallDescriptors::add_fast_array_element_gc();
      CallIntRetRuntime(desc, GetCtx(), obj_raw, val, flags);
      DecSp(3);
      Dispatch(opcode);
    }
  }
  Bind(&slow_set_type_array);
  {
    flags_var = Int32Value(0);
    Jump(&slow_set);
  }
  Bind(&slow_set);
  {
    ClearNewSp();
    auto desc = son::node::CallDescriptors::JS_SetPropertyValue_GC();
    CallIntRetRuntime(desc, GetCtx(), this_obj, prop, val, *flags_var);
    DecSp(3);
    Dispatch(opcode);
  }
}

void HandlerImpl::GenArrayFrom(PrimjsOpcode opcode) {
  // auto call_argc = get_u16(pc);
  // pc += 2;
  // auto ret_val = PRIM_JS_NewArray_GC(ctx);
  // if (unlikely(LEPUS_IsException(ret_val))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // auto call_argv = sp - call_argc;
  // for (i = 0; i < call_argc; i++) {
  //   ret = LEPUS_DefinePropertyValue(ctx, ret_val, __JS_AtomFromUInt32(i),
  //                                   call_argv[i],
  //                                   LEPUS_PROP_C_W_E | LEPUS_PROP_THROW);
  //   call_argv[i] = LEPUS_UNDEFINED;
  //   if (ret < 0) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  // }
  // sp -= call_argc;
  // *sp++ = ret_val;
  // Dispatch(opcode);
  auto ctx = GetCtx();
  auto call_argc = Fetch_16(0);
  auto call_argv = LeapSp(call_argc);
  auto desc = son::node::CallDescriptors::JS_NewArrayWithArgs_GC();
  auto ret_val = CallRuntime(desc, ctx, call_argc, call_argv);

  call_argc = Fetch_16(0);
  auto call_argc_ptr = ZExtInt32ToIntPtr(call_argc);
  DecSp(call_argc_ptr);
  PushSp(ret_val);
  Dispatch(opcode);
}

void HandlerImpl::GenSpecialObject(PrimjsOpcode opcode) {
  auto arg = Fetch_8(0);

  son::node::Label done(this);
  son::node::Label is_arguments(this);
  son::node::Label is_mapped_arguments(this);
  son::node::Label is_this_func(this);
  son::node::Label is_new_target(this);
  son::node::Label is_home_object(this);
  son::node::Label is_object_var(this);
  son::node::Label is_default(this);

  Switch(arg)
      ->Case(OP_SPECIAL_OBJECT_ARGUMENTS, &is_arguments)
      ->Case(OP_SPECIAL_OBJECT_MAPPED_ARGUMENTS, &is_mapped_arguments)
      ->Case(OP_SPECIAL_OBJECT_THIS_FUNC, &is_this_func)
      ->Case(OP_SPECIAL_OBJECT_NEW_TARGET, &is_new_target)
      ->Case(OP_SPECIAL_OBJECT_HOME_OBJECT, &is_home_object)
      ->Case(OP_SPECIAL_OBJECT_VAR_OBJECT, &is_object_var)
      ->Default(&is_default);
  Bind(&is_arguments);
  {
    // clean up sp
    ClearNewSp();
    auto argc = RestoreArgc();
    auto argv = RestoreArgBuf();
    auto desc = son::node::CallDescriptors::js_build_arguments_gc();
    auto ret_Val = CallRuntimeArg2(desc, GetCtx(), argc, argv);
    PushSp(ret_Val);
    Jump(&done);
  }
  Bind(&is_mapped_arguments);
  {
    // clean up sp
    ClearNewSp();
    auto argc = RestoreArgc();
    auto argv = RestoreArgBuf();
    auto desc = son::node::CallDescriptors::js_build_mapped_arguments_gc();

    auto func_obj = RestoreCurFunc();
    auto b = LoadFunctionBytecode(CastToRaw(func_obj));
    auto arg_count = ZExtToInt32(LoadArgCount(b));
    auto min_int = Int32Min(arg_count, argc);
    auto ret_Val = CallRuntime(desc, GetCtx(), argc, argv, GetFrame(), min_int);
    PushSp(ret_Val);
    Jump(&done);
  }
  Bind(&is_this_func);
  {
    // clean up sp
    ClearNewSp();
    auto this_obj = RestoreCurFunc();
    PushSp(this_obj);
    Jump(&done);
  }
  Bind(&is_new_target);
  {
    // clean up sp
    ClearNewSp();
    auto new_target = RestoreNewTarget();
    PushSp(new_target);
    Jump(&done);
  }
  Bind(&is_home_object);
  {
    auto func_obj = RestoreCurFunc();
    auto home_obj = LoadHomeObject(CastToRaw(func_obj));
    son::node::Label is_nullptr(this);
    son::node::Label not_nullptr(this);
    auto cond = Equal(home_obj, Int64Value(0));
    Branch(cond, &is_nullptr, &not_nullptr, son::node::BranchHint::kFalse);
    Bind(&is_nullptr);
    {
      // clean up sp
      ClearNewSp();
      PushSp(LepusUndefined());
      Jump(&done);
    }
    Bind(&not_nullptr);
    {
      // clean up sp
      ClearNewSp();
      PushSp(home_obj);
      Jump(&done);
    }
  }
  Bind(&is_object_var);
  {
    // clean up sp
    ClearNewSp();
    auto desc = son::node::CallDescriptors::JS_NewObjectProto_GC();
    auto ret_Val = CallRuntimeArg1(desc, GetCtx(), LepusNull());
    PushSp(ret_Val);
    Jump(&done);
  }
  Bind(&is_default);
  { Unreachable(); }

  Bind(&done);
  Dispatch(opcode);
}

void HandlerImpl::GenCallBinaryOperator(PrimjsOpcode opcode) {
  // op1 = sp[-2];
  // op2 = sp[-1];
  auto op1 = LoadTop1();
  auto op2 = LoadTop0();

  son::node::Node* ret_val = nullptr;
  if (opcode == PrimjsOpcode::OP_delete) {
    auto desc = son::node::CallDescriptors::prim_js_operator_delete_gc();
    ret_val = CallRuntimeArg2(desc, GetCtx(), op1, op2);
  } else if (opcode == PrimjsOpcode::OP_instanceof) {
    auto desc = son::node::CallDescriptors::prim_js_operator_instanceof_gc();
    ret_val = CallRuntimeArg2(desc, GetCtx(), op1, op2);
  } else if (opcode == PrimjsOpcode::OP_in) {
    auto desc = son::node::CallDescriptors::prim_js_operator_in_gc();
    ret_val = CallRuntimeArg2(desc, GetCtx(), op1, op2);
  } else {
    unreachable();
  }
  DecSp();
  StoreTop0(ret_val);
  Dispatch(opcode);
}

void HandlerImpl::GenPushOp(son::node::Node* val, PrimjsOpcode opcode) {
  PushSp(val);
  Dispatch(opcode);
}

void HandlerImpl::GenWithOp(PrimjsOpcode opcode) {
  auto desc = son::node::CallDescriptors::prim_js_with_op_gc();

  auto ctx = GetCtx();
  auto sp = GetSp();

  auto atom = Fetch_32(0);
  auto is_with = Fetch_8(8);

  auto op = IntValue((int)opcode);
  auto ret_val = CallIntRetRuntime(desc, ctx, sp, atom, is_with, op);

  son::node::Label no_jump(this);
  auto cond = Equal(ret_val, IntValue(0));
  BranchIf(cond, &no_jump);

  int sp_size = 0;
  if (opcode == PrimjsOpcode::OP_with_put_var) {
    DecSp(2);
  } else if ((opcode == PrimjsOpcode::OP_with_make_ref) ||
             (opcode == PrimjsOpcode::OP_with_get_ref) ||
             (opcode == PrimjsOpcode::OP_with_get_ref_undef)) {
    IncSp(1);
  }

  auto imm = Int32Add(Fetch_S32(4), Int32Value(4));
  auto offset = SExtInt32ToIntPtr(imm);
  DispatchJmp(offset);

  Bind(&no_jump);
  {
    ClearNewSp();
    DecSp();
    Dispatch(opcode);
  }
}

void HandlerImpl::GenMakeRefOp(PrimjsOpcode opcode) {
  // atom = get_u32(pc);
  // idx = get_u16(pc + 4);
  // pc += 6;
  // *sp++ = LEPUS_NewObjectProto(ctx, LEPUS_NULL);
  // if (unlikely(LEPUS_IsException(sp[-1]))) goto exception;
  // if (opcode == OP_make_var_ref_ref) {
  //   var_ref = var_refs[idx];
  //   var_ref->header.ref_count++;
  // } else {
  //   var_ref = get_var_ref(ctx, sf, idx, opcode == OP_make_arg_ref);
  //   if (!var_ref) goto exception;
  // }
  // pr = add_property(ctx, LEPUS_VALUE_GET_OBJ(sp[-1]), atom,
  //                   LEPUS_PROP_WRITABLE | LEPUS_PROP_VARREF);
  // if (!pr) {
  //   free_var_ref(rt, var_ref);
  //   goto exception;
  // }
  // pr->u.var_ref = var_ref;
  // *sp++ = JS_AtomToValue_RC(ctx, atom);
  auto ctx = GetCtx();

  son::node::Label throw_e(this);

  auto desc = son::node::CallDescriptors::JS_NewObjectProto_GC();
  auto ret = CallRuntime(desc, ctx, LepusNull());

  IncSp(2);
  StoreTop1(ret);
  // store undefined to sp[-1] incase gc mark
  StoreTop0(LepusUndefined());
  son::node::Node* var_ref = nullptr;
  if (opcode != PrimjsOpcode::OP_make_var_ref_ref) {
    auto idx = Fetch_16(4);
    desc = son::node::CallDescriptors::get_var_ref();
    auto is_arg = (opcode == PrimjsOpcode::OP_make_arg_ref) ? 1 : 0;
    auto sf = GetFrame();
    var_ref = CallRuntimeNoCheck(desc, ctx, sf, idx, IntValue(is_arg));
    BranchIf(Equal(var_ref, NullptrValue()), &throw_e);

    ret = LoadTop1();
  }
  auto val = CastToRaw(ret);
  auto atom = Fetch_32(0);
  desc = son::node::CallDescriptors::add_property_gc();
  auto pr = CallRuntimeNoCheck(
      desc, ctx, val, atom, IntValue(LEPUS_PROP_WRITABLE | LEPUS_PROP_VARREF));

  BranchIf(Equal(pr, NullptrValue()), &throw_e);
  if (var_ref == nullptr) {
    auto idx = Fetch_16(4);
    auto var_refs = GetVarRefsCache();
    var_ref = LoadRawVal(var_refs, idx);
  }
  // pr->u.var_ref = var_ref;
  StoreJsPropertyVarRef(ctx, pr, var_ref);
  desc = son::node::CallDescriptors::__JS_AtomToValue_GC();
  atom = Fetch_32(0);
  auto ret_val = CallRuntime(desc, ctx, atom, IntValue(0));
  StoreTop0(ret_val);
  Dispatch(opcode);

  Bind(&throw_e);
  { DispatchException(); }
}

void HandlerImpl::GenDefineMethod(PrimjsOpcode opcode) {
#define OP_DEFINE_METHOD_METHOD 0
#define OP_DEFINE_METHOD_GETTER 1
#define OP_DEFINE_METHOD_SETTER 2
#define OP_DEFINE_METHOD_ENUMERABLE 4

  //   is_computed = (opcode == OP_define_method_computed);
  //   if (is_computed) {
  //     atom = js_value_to_atom(ctx, sp[-2]);
  //     if (unlikely(atom == JS_ATOM_NULL)) goto exception;
  //     opcode += OP_define_method - OP_define_method_computed;
  //   } else {
  //     atom = get_u32(pc);
  //     pc += 4;
  //   }
  //   op_flags = *pc++;
  //   obj = sp[-2 - is_computed];
  auto ctx = GetCtx();
  auto is_computed = (opcode == PrimjsOpcode::OP_define_method_computed);
  son::node::Node* atom = nullptr;
  son::node::Node* op_flags = nullptr;
  son::node::Node* obj = nullptr;
  if (is_computed) {
    auto prop = LoadTop1();
    auto desc = son::node::CallDescriptors::js_value_to_atom_gc();
    atom = CallAtomRetRuntime(desc, GetCtx(), prop);
    op_flags = Fetch_8(0);
    obj = LoadSp(-3);
  } else {
    atom = Fetch_32(0);
    op_flags = Fetch_8(4);
    obj = LoadTop1();
  }

  //   flags = LEPUS_PROP_HAS_CONFIGURABLE | LEPUS_PROP_CONFIGURABLE |
  //           LEPUS_PROP_HAS_ENUMERABLE | LEPUS_PROP_THROW;
  //   if (op_flags & OP_DEFINE_METHOD_ENUMERABLE)
  //     flags |= LEPUS_PROP_ENUMERABLE;
  //   op_flags &= 3;
  //   value = LEPUS_UNDEFINED;
  //   getter = LEPUS_UNDEFINED;
  //   setter = LEPUS_UNDEFINED;
  son::node::Label set_flags(this);
  son::node::Label next(this);

  auto flags_int = LEPUS_PROP_HAS_CONFIGURABLE | LEPUS_PROP_CONFIGURABLE |
                   LEPUS_PROP_HAS_ENUMERABLE | LEPUS_PROP_THROW;
  son::node::Variable flags_h(this, son::node::NodeType::IntType(),
                              IntValue(flags_int));

  // if (op_flags & OP_DEFINE_METHOD_ENUMERABLE)
  auto op_and_flags = Int32And(op_flags, IntValue(OP_DEFINE_METHOD_ENUMERABLE));
  auto cond = NotEqual(op_and_flags, Int32Value(0));
  Branch(cond, &set_flags, &next);
  Bind(&set_flags);
  {
    // flags |= LEPUS_PROP_ENUMERABLE;
    flags_h = IntValue(flags_int | LEPUS_PROP_ENUMERABLE);
    Jump(&next);
  }
  Bind(&next);
  // op_flags &= 3;
  op_flags = Int32And(op_flags, IntValue(3));
  son::node::Variable value_h(this, son::node::NodeType::Int64Type(),
                              LepusUndefined());
  son::node::Variable getter_h(this, son::node::NodeType::Int64Type(),
                               LepusUndefined());
  son::node::Variable setter_h(this, son::node::NodeType::Int64Type(),
                               LepusUndefined());
  son::node::Variable flags_h1(this, son::node::NodeType::IntType(), *flags_h);

  //   if (op_flags == OP_DEFINE_METHOD_METHOD) {
  //     value = sp[-1];
  //     flags |= LEPUS_PROP_HAS_VALUE | LEPUS_PROP_HAS_WRITABLE |
  //              LEPUS_PROP_WRITABLE;
  //   } else if (op_flags == OP_DEFINE_METHOD_GETTER) {
  //     getter = sp[-1];
  //     flags |= LEPUS_PROP_HAS_GET;
  //   } else {
  //     setter = sp[-1];
  //     flags |= LEPUS_PROP_HAS_SET;
  //   }
  son::node::Label set_method(this);
  son::node::Label set_getter(this);
  son::node::Label set_setter(this);
  son::node::Label set_next(this);

  auto val = LoadTop0();
  cond = Equal(op_flags, IntValue(OP_DEFINE_METHOD_METHOD));
  BranchIf(cond, &set_method);

  cond = Equal(op_flags, IntValue(OP_DEFINE_METHOD_GETTER));
  Branch(cond, &set_getter, &set_setter);
  Bind(&set_method);
  {
    value_h = val;
    flags_h1 = Int32Or(
        *flags_h1, Int32Value(LEPUS_PROP_HAS_VALUE | LEPUS_PROP_HAS_WRITABLE |
                              LEPUS_PROP_WRITABLE));
    Jump(&set_next);
  }
  Bind(&set_getter);
  {
    getter_h = val;
    flags_h1 = Int32Or(*flags_h1, Int32Value(LEPUS_PROP_HAS_GET));
    Jump(&set_next);
  }
  Bind(&set_setter);
  {
    setter_h = val;
    flags_h1 = Int32Or(*flags_h1, Int32Value(LEPUS_PROP_HAS_SET));
    Jump(&set_next);
  }
  Bind(&set_next);
  auto flags = *flags_h1;
  auto value = *value_h;
  auto getter = *getter_h;
  auto setter = *setter_h;
  //   ret = js_method_set_properties(ctx, sp[-1], atom, flags, obj);
  //   if (ret >= 0) {
  //     ret = JS_DefineProperty_RC(ctx, obj, atom, value, getter, setter,
  //                                flags);
  //   }
  //   sp -= 1 + is_computed;
  //   if (unlikely(ret < 0)) goto exception;
  // }
  auto func_obj = LoadTop0();
  auto desc = son::node::CallDescriptors::js_method_set_properties_gc();
  CallIntRetRuntime(desc, ctx, func_obj, atom, flags, obj);

  desc = son::node::CallDescriptors::JS_DefineProperty_GC();
  CallIntRetRuntime(desc, ctx, obj, atom, value, getter, setter, flags);

  // sp -= 1 + is_computed;
  DecSp(1 + (is_computed ? 1 : 0));
  Dispatch(opcode);
#undef OP_DEFINE_METHOD_METHOD
#undef OP_DEFINE_METHOD_GETTER
#undef OP_DEFINE_METHOD_SETTER
#undef OP_DEFINE_METHOD_ENUMERABLE
}

void HandlerImpl::GenDoneGenerator(PrimjsOpcode opcode) {
  son::node::Node* ret_val = nullptr;
  if (opcode == PrimjsOpcode::OP_await) {
    ret_val = Int64Value(AccessBuilder::JS_NewInt32(FUNC_RET_AWAIT));
  } else if (opcode == PrimjsOpcode::OP_yield) {
    ret_val = Int64Value(AccessBuilder::JS_NewInt32(FUNC_RET_YIELD));
  } else if ((opcode == PrimjsOpcode::OP_yield_star) ||
             (opcode == PrimjsOpcode::OP_async_yield_star)) {
    ret_val = Int64Value(AccessBuilder::JS_NewInt32(FUNC_RET_YIELD_STAR));
  } else if ((opcode == PrimjsOpcode::OP_return_async) ||
             (opcode == PrimjsOpcode::OP_initial_yield)) {
    ret_val = LepusUndefined();
  }

  SavePc();
  SaveSp();

  SaveRetVal(ret_val);
  DispatchWithId(CallBcIndex::kcommon_return_direct);
}

void HandlerImpl::GenCallOp(PrimjsOpcode opcode) {
  // sf->caller_argc = 0;
  // auto this_obj = LEPUS_UNDEFINED.ptr;
  // TAIL_CALL return common_call_h(HANDLER_PARAM_WITH_ARG1(0, this_obj));
  int call_argc = -1;
  bool tail_call = false;
  bool has_this = false;
  switch (opcode) {
    case PrimjsOpcode::OP_call0:
    case PrimjsOpcode::OP_call1:
    case PrimjsOpcode::OP_call2:
    case PrimjsOpcode::OP_call3:
      call_argc = (int)opcode - (int)OP_call0;
      break;
    case PrimjsOpcode::OP_call:
      break;
    case PrimjsOpcode::OP_tail_call:
      tail_call = true;
      break;
    case PrimjsOpcode::OP_call_method:
      has_this = true;
      break;
    case PrimjsOpcode::OP_tail_call_method:
      tail_call = true;
      has_this = true;
      break;
    default:
      unreachable();
      break;
  }

  son::node::Node* call_argc_val = nullptr;
  if (call_argc < 0) {
    call_argc_val = Fetch_16(0);
  } else {
    call_argc_val = IntValue(call_argc);
  }
  auto size = get_opcode_size(opcode);
  IncPc(size - 1);
  SavePc();
  SaveSp();
  // call_argv = sp - call_argc;
  son::node::Node* call_argv = nullptr;
  if (call_argc == 0) {
    call_argv = GetSp();
  } else {
    call_argv = LeapSp(call_argc_val);
  }
  son::node::Node* this_obj = nullptr;
  son::node::Node* func_obj = nullptr;
  if (call_argc >= 0) {
    vmassert(!has_this, "must be");
    func_obj = LoadSp(-1 - call_argc);
    this_obj = LepusUndefined();
  } else {
    // auto func_obj = call_argv[-1];
    func_obj = LoadSp(call_argv, -1);
    if (has_this) {
      this_obj = LoadSp(call_argv, -2);
    } else {
      this_obj = LepusUndefined();
    }
  }
  SetVar64(HandlerVarIndex::kFuncObj, func_obj);
  SetVar64(HandlerVarIndex::kThisObject, this_obj);
  SetVar64(HandlerVarIndex::kNewTarget, LepusUndefined());
  if (call_argc != 0) {
    SetNewSp(call_argv);
  }
  DispatchCommonCall(ZExtInt32ToInt64(call_argc_val));
  CleanupAfterDispatch();
  SetCurrentToTable0();
  if (tail_call) {
    auto ret_val = RestoreRetVal();
    SetNewPc(NullptrValue());
    SetNewSpAfterCall(NullptrValue());
    CheckException(ret_val);

    ReloadVarRefsCache();
    DispatchWithId(CallBcIndex::kcommon_return);
  } else {
    auto ret_val = RestoreRetVal();
    // pc = sf->cur_pc;
    auto pc = RestoreCurPc();
    SetNewPc(pc);
    // sp = sf->cur_sp;
    auto sp = RestoreCurSp();
    SetNewSpAfterCall(sp);
    ReloadActiveContextVars();
    CheckException(ret_val);
    // sp -= sf->caller_argc + 1;
    if (has_this) {
      call_argc_val = Fetch_16(-2);
      auto argc = Int32Add(call_argc_val, IntValue(2));
      DecSp(ZExtInt32ToIntPtr(argc));
      // *sp++ = ret_val;
      PushSp(ret_val);
    } else {
      if (call_argc < 0) {
        call_argc_val = Fetch_16(-2);
        auto argc = Int32Add(call_argc_val, IntValue(1));
        DecSp(ZExtInt32ToIntPtr(argc));
        // *sp++ = ret_val;
        PushSp(ret_val);
      } else {
        if (call_argc != 0) {
          DecSp(call_argc);
        }
        StoreTop0(ret_val);
      }
    }
    DispatchImpl(pc);
  }
}

void HandlerImpl::GenCallCFunction(son::node::Label* call_fail) {
  auto call_argc = TruncInt64ToInt32(GetArgc());
  auto func_obj = GetFuncObj();
  auto this_obj = GetThisObject();
  auto call_argv = GetSp();
  auto ctx = GetCtx();

  // arg_count = p->u.cfunc.length;
  auto func_obj_raw = CastToRaw(func_obj);
  auto arg_count = ZExtToInt32(LoadCFunctionLength(func_obj_raw));
  // if (unlikely(argc < arg_count)) {
  auto cond = LessThan(call_argc, arg_count);
  BranchIf(cond, call_fail, son::node::BranchHint::kFalse);

  // LEPUSStackFrame sf_s, *sf = &sf_s, *prev_sf;
  auto alloc_size = IntValue(AccessBuilder::js_stack_frame_size());
  auto prev_frame = GetFrame();
  son::node::Node* prev_stack = nullptr;
  auto sf = PushStackFrame(alloc_size, &prev_stack);
  // SaveLastLr();

  // sf->prev_frame = rt->current_stack_frame;
  SavePrevFrame(prev_frame);
  // sf->cur_func = func_obj;
  SaveCurFunc(func_obj);
  // if (is_debug_mode) {
  //  sf->pthis = this_obj;
  SaveDebuggerThisObject(this_obj);

  // init_list_head(&sf->var_ref_list);
  auto var_ref_list_ptr = GetVarRefListAddress();
  StoreListPrev(var_ref_list_ptr, var_ref_list_ptr);
  StoreListNext(var_ref_list_ptr, var_ref_list_ptr);

  // sf->js_mode = 0;
  SaveJsMode(IntValue(0));
  // sf->sp = nullptr;
  SaveSp(NullptrValue());
  SaveFrameSp(NullptrValue());
  // sf->arg_count = argc;
  SaveArgCount(call_argc);
  // sf->arg_buf = arg_buf;
  SaveArgBuffer(call_argv);
  // sf->var_buf = nullptr;
  SaveVarBuf(NullptrValue());
  // sf->var_refs = nullptr;
  SaveVarRefs(IntPtrValue(0));
  // sf->ref_size = 0;
  SaveVarRefSize(IntValue(0));
  // rt->current_stack_frame = sf;
  auto rt = LoadRt(ctx);
  StoreCurrentStackFrame(rt, sf);

  // cproto = static_cast<LEPUSCFunctionEnum>(p->u.cfunc.cproto);
  auto cproto = ZExtToInt32(LoadCFunctionProto(func_obj_raw));
  // func = p->u.cfunc.c_function;
  auto call_func = LoadCFunctionFunction(func_obj_raw);

  son::node::Label done(this);
  son::node::Label is_generic_conctructor(this);
  son::node::Label is_generic(this);
  son::node::Label is_generic_magic_conctructor(this);
  son::node::Label is_generic_magic(this);
  son::node::Label is_getter(this);
  son::node::Label is_setter(this);
  son::node::Label is_getter_magic(this);
  son::node::Label is_setter_magic(this);
  son::node::Label is_default(this);

  // flags & LEPUS_CALL_FLAG_CONSTRUCTOR == 0
  Switch(cproto)
      ->Case(LEPUS_CFUNC_constructor_or_func, &is_generic_conctructor)
      ->Case(LEPUS_CFUNC_generic, &is_generic)
      ->Case(LEPUS_CFUNC_constructor_or_func_magic,
             &is_generic_magic_conctructor)
      ->Case(LEPUS_CFUNC_generic_magic, &is_generic_magic)
      ->Case(LEPUS_CFUNC_getter, &is_getter)
      ->Case(LEPUS_CFUNC_setter, &is_setter)
      ->Case(LEPUS_CFUNC_getter_magic, &is_getter_magic)
      ->Case(LEPUS_CFUNC_setter_magic, &is_setter_magic)
      ->Default(&is_default);
  Bind(&is_generic_conctructor);
  {
    // this_obj = LEPUS_UNDEFINED;
    auto desc = son::node::CallDescriptors::call_cfunc_generic();
    auto ret_val =
        Call(desc, call_func, ctx, LepusUndefined(), call_argc, call_argv);
    SaveRetVal(ret_val);
    Jump(&done);
  }
  Bind(&is_generic);
  {
    // ret_val = func.generic(ctx, this_obj, argc, call_argv);
    auto desc = son::node::CallDescriptors::call_cfunc_generic();
    auto ret_val = Call(desc, call_func, ctx, this_obj, call_argc, call_argv);
    SaveRetVal(ret_val);
    Jump(&done);
  }
  Bind(&is_generic_magic_conctructor);
  {
    auto magic = SExtToInt32(LoadCFunctionMagic(func_obj_raw));
    // this_obj = LEPUS_UNDEFINED;
    auto desc = son::node::CallDescriptors::call_cfunc_generic_magic();
    auto ret_val = Call(desc, call_func, ctx, LepusUndefined(), call_argc,
                        call_argv, magic);
    SaveRetVal(ret_val);
    Jump(&done);
  }
  Bind(&is_generic_magic);
  {
    auto magic = SExtToInt32(LoadCFunctionMagic(func_obj_raw));
    // ret_val = func.generic_magic(ctx, this_obj, argc, arg_buf,
    // p->u.cfunc.magic);
    auto desc = son::node::CallDescriptors::call_cfunc_generic_magic();
    auto ret_val =
        Call(desc, call_func, ctx, this_obj, call_argc, call_argv, magic);
    SaveRetVal(ret_val);
    Jump(&done);
  }
  Bind(&is_getter);
  {
    // ret_val = func.getter(ctx, this_obj);
    auto desc = son::node::CallDescriptors::call_getter();
    auto ret_val = Call(desc, call_func, ctx, this_obj);
    SaveRetVal(ret_val);
    Jump(&done);
  }
  Bind(&is_setter);
  {
    auto arg0 = LoadLepusVal(call_argv, IntValue(0));
    // ret_val = func.setter(ctx, this_obj, arg_buf[0]);
    auto desc = son::node::CallDescriptors::call_setter();
    auto ret_val = Call(desc, call_func, ctx, this_obj, arg0);
    SaveRetVal(ret_val);
    Jump(&done);
  }
  Bind(&is_getter_magic);
  {
    auto magic = SExtToInt32(LoadCFunctionMagic(func_obj_raw));
    // ret_val = func.getter_magic(ctx, this_obj, p->u.cfunc.magic);
    auto desc = son::node::CallDescriptors::call_getter_magic();
    auto ret_val = Call(desc, call_func, ctx, this_obj, magic);
    SaveRetVal(ret_val);
    Jump(&done);
  }
  Bind(&is_setter_magic);
  {
    auto arg0 = LoadLepusVal(call_argv, IntValue(0));
    auto magic = SExtToInt32(LoadCFunctionMagic(func_obj_raw));
    // ret_val = func.setter_magic(ctx, this_obj, arg_buf[0], p->u.cfunc.magic);
    auto desc = son::node::CallDescriptors::call_setter_magic();
    auto ret_val = Call(desc, call_func, ctx, this_obj, arg0, magic);
    SaveRetVal(ret_val);
    Jump(&done);
  }
  Bind(&is_default);
  {
    // ret_val = prim_call_c_function_default(ctx, func_obj, this_obj, argc,
    // arg_buf);
    auto desc = son::node::CallDescriptors::prim_call_c_function_default();
    auto target = FunctionPointer(desc);
    auto ret_val =
        Call(desc, target, ctx, func_obj, this_obj, call_argc, call_argv);
    SaveRetVal(ret_val);
    Jump(&done);
  }
  Bind(&done);

  auto scratch = GetVar(HandlerVarIndex::kArgBuf);
  SetVar(HandlerVarIndex::kLr, scratch);

  SetNewFrame(prev_frame);
  rt = LoadRt(ctx);
  StoreCurrentStackFrame(rt, prev_frame);

  // RestoreLastLr();
  PopStackFrame(prev_stack);

  Return();
}

void HandlerImpl::GenCallCFunctionData(son::node::Label* call_fail) {
  //   JSCFunctionDataRecord *s = static_cast<JSCFunctionDataRecord *>(
  //    LEPUS_GetOpaque(func_obj, JS_CLASS_C_FUNCTION_DATA));
  auto call_argc = TruncInt64ToInt32(GetArgc());
  auto func_obj = GetFuncObj();
  auto this_obj = GetThisObject();
  auto func_obj_raw = CastToRaw(func_obj);
  auto record = LoadOpaque(func_obj_raw);
  auto s_length = ZExtToInt32(LoadCFunctionDataLength(record));
  auto call_argv = GetSp();

  // if (unlikely(argc < s->length))
  auto cond = LessThan(call_argc, s_length);
  BranchIf(cond, call_fail, son::node::BranchHint::kFalse);
  auto ctx = GetCtx();
  auto call_func = LoadCFunctionDataFunc(record);
  auto magic = ZExtToInt32(LoadCFunctionDataMagic(record));
  auto call_data = LeapCFunctionDataData(record);

  // SaveLastLr();
  // s->func(ctx, this_val, argc, arg_buf, s->magic, s->data);
  auto desc = son::node::CallDescriptors::call_cfunc_func();
  auto ret_val = Call(desc, call_func, ctx, this_obj, call_argc, call_argv,
                      magic, call_data);

  // RestoreLastLr();
  SaveRetVal(ret_val);
  Return();
}

void HandlerImpl::GenCallNative(bool from_entry) {
  // int call_argc = _arg0_;
  // auto this_obj = ((LEPUSValue){.as_int64 = _arg1_});
  // auto call_argv = sp - call_argc;

  // auto p = LEPUS_VALUE_GET_OBJ(func_obj);
  auto call_argc = TruncInt64ToInt32(GetArgc());
  auto func_obj = GetFuncObj();
  auto this_obj = GetThisObject();
  auto call_argv = GetSp();
  son::node::Node* flags = nullptr;
  if (from_entry) {
    auto pc = CastRawToIntPtr(GetPc());
    flags = TruncIntPtrToInt32(pc);
  } else {
    flags = IntValue(0);
  }

  auto b = LoadFunctionBytecode(CastToRaw(func_obj));
  // auto rt = ctx->rt;
  auto ctx = GetCtx();
  auto rt = LoadRt(ctx);
  // auto call_func = rt->class_array[p->class_id].call;
  auto class_id = ZExtInt16ToInt32(LoadClassId(CastToRaw(func_obj)));

  son::node::Label call_c_function(this);
  son::node::Label not_c_function(this);
  son::node::Label call_c_func(this);

  auto is_c_function = Equal(class_id, IntValue(JS_CLASS_C_FUNCTION));
  Branch(is_c_function, &call_c_function, &not_c_function,
         son::node::BranchHint::kTrue);
  Bind(&call_c_function);
  { GenCallCFunction(&call_c_func); }
  Bind(&not_c_function);
  son::node::Label call_c_functiondata(this);
  son::node::Label not_c_functiondata(this);
  auto is_c_functiond_data =
      Equal(class_id, IntValue(JS_CLASS_C_FUNCTION_DATA));
  Branch(is_c_functiond_data, &call_c_functiondata, &not_c_functiondata,
         son::node::BranchHint::kTrue);
  Bind(&call_c_functiondata);
  { GenCallCFunctionData(&call_c_func); }
  Bind(&not_c_functiondata);
  auto class_array = LoadRtClassArray(rt);
  auto class_id_offset =
      Int32Mul(class_id, IntValue(sizeof(LEPUSClass) / IntPtrSizeInt()));
  auto call_offset = AccessBuilder::class_call_offset() / IntPtrSizeInt();
  class_id_offset = Int32Add(class_id_offset, IntValue(call_offset));
  auto call_func = LoadRawValPOffset(class_array, class_id_offset);
  // if (!call_func) {
  //   TAIL_CALL return ThrowTypeErrorNotFunction_c_h(HANDLER_PARAM(pc));
  // }

  son::node::Label is_null(this);
  auto cond = Equal(call_func, NullptrValue());
  Branch(cond, &is_null, &call_c_func, son::node::BranchHint::kFalse);
  Bind(&is_null);
  { DispatchWithId(CallBcIndex::kThrowTypeErrorNotFunction_Return); }
  Bind(&call_c_func);
  // SaveLastLr();
  // auto ret_val = call_func(ctx, func_obj, this_obj, call_argc,
  // (LEPUSValueConst *)call_argv, 0);
  auto desc = son::node::CallDescriptors::call_c_func();
  auto ret_val = Call(desc, call_func, ctx, func_obj, this_obj, call_argc,
                      call_argv, flags);
  // if (unlikely(sf->caller_argc < 0)) {
  //   // tail call
  //   if (sf->caller_argc == -1) {
  //     TAIL_CALL return
  //     common_return_asm_h(HANDLER_PARAM_WITH_ARG(ret_val.as_int64));
  //   }
  //   sf->ret_val = ret_val;
  //   return;
  // }
  // RestoreLastLr();
  SaveRetVal(ret_val);
  Return();
}

void HandlerImpl::GenCommonReturn() {
  RestoreLastLr();
  // js_pop_virtual_sp_with_sp(ctx, (address)sf);
  // sf = (QuickJsFrame*)sf->prev_frame;
  // rt->current_stack_frame = sf;
  // auto ret_val = sp[-1];
  auto cur_frame = GetFrame();
  auto prev_frame = RestorePrevFrame();
  auto frame = prev_frame;

  auto prev_stack = RestoreLastFrame();
  PopStackFrame(prev_stack);

  SetNewFrame(frame);
  SetVar(HandlerVarIndex::kFrame, frame);

  // rt->current_stack_frame = sf;
  auto ctx = GetCtx();
  auto rt = LoadRt(ctx);
  StoreCurrentStackFrame(rt, frame);

  Return();
}

void HandlerImpl::CheckFunctIsObject(son::node::Node* func_obj) {
  // if (unlikely(LEPUS_VALUE_IS_NOT_OBJECT(func_obj))) {
  //   TAIL_CALL return ThrowTypeErrorNotFunction_h(HANDLER_PARAM(pc));
  // }
  son::node::Label is_object(this);
  son::node::Label not_object(this);

  Branch(IsLepusObject(func_obj), &is_object, &not_object,
         son::node::BranchHint::kTrue);
  Bind(&not_object);
  { DispatchWithId(CallBcIndex::kThrowTypeErrorNotFunction_Return); }
  Bind(&is_object);
}

void HandlerImpl::CheckCallNative(son::node::Node* func_obj, bool from_entry) {
  // auto p = LEPUS_VALUE_GET_OBJ(func_obj);
  // if (unlikely(p->class_id != JS_CLASS_BYTECODE_FUNCTION)) {
  //   TAIL_CALL return call_native_h(HANDLER_PARAM(pc));
  // }
  son::node::Label is_function(this);
  son::node::Label not_function(this);
  auto class_id = LoadClassId(CastToRaw(func_obj));

  auto cond = NotEqual(class_id, Int16Value(JS_CLASS_BYTECODE_FUNCTION));
  Branch(cond, &not_function, &is_function, son::node::BranchHint::kFalse);
  Bind(&not_function);
  {
    auto idx = from_entry ? CallBcIndex::kcall_native_entry
                          : CallBcIndex::kcall_native;
    DispatchCallHandler(idx);
  }
  Bind(&is_function);
}

void HandlerImpl::GenCallFromEntry() {
  auto call_argc = TruncInt64ToInt32(GetArgc());
  auto call_argv = GetSp();
  auto func_obj = GetFuncObj();
  auto pc = CastRawToIntPtr(GetPc());
  auto flags = TruncIntPtrToInt32(pc);

  son::node::Label call_async(this);
  son::node::Label call_normal(this);

  // (flags & JS_CALL_FLAG_GENERATOR)
  auto and_val = Int32And(flags, IntValue(JS_CALL_FLAG_GENERATOR));
  auto cond = NotEqual(and_val, IntValue(0));
  Branch(cond, &call_async, &call_normal);

  Bind(&call_async);
  {
    GenCallGenerator(func_obj);
    CleanupAfterDispatch();
  }

  Bind(&call_normal);
  {
    CheckFunctIsObject(func_obj);
    CheckCallNative(func_obj, true);

    auto b = LoadFunctionBytecode(CastToRaw(func_obj));
    auto arg_count = ZExtToInt32(LoadArgCount(b));

    son::node::Label arg_match(this);
    son::node::Label arg_mismatch(this);
    // if (unlikely(argc < b->arg_count))
    auto cond = LessThan(call_argc, arg_count);
    Branch(cond, &arg_mismatch, &arg_match, son::node::BranchHint::kFalse);
    Bind(&arg_match);
    {
      GenCommonCallInternal(b, func_obj, arg_count, call_argc, call_argv, false,
                            true);
      CleanupAfterDispatch();
    }
    Bind(&arg_mismatch);
    {
      GenCommonCallInternal(b, func_obj, arg_count, call_argc, call_argv, true,
                            true);
    }
  }
}

void HandlerImpl::GenCallGenerator(son::node::Node* func_obj) {
  // JSAsyncFunctionState *s =
  //    static_cast<JSAsyncFunctionState *>(LEPUS_VALUE_GET_PTR(func_obj));
  // sf = &s->frame;
  auto ctx = GetCtx();
  auto s = CastToRaw(GetPtr(func_obj));
  auto old_frame = LeapAsyncStackFrame(s);

  SetVar(HandlerVarIndex::kFrame, old_frame);
  SetNewFrame(old_frame);
  son::node::Node* js_stack = nullptr;
  if (_use_virtual_sp) {
    js_stack = LoadJSStack(ctx);
  } else {
    js_stack = SaveStack();
  }
  SaveLastLr();
  SaveLastFrame(js_stack);

  auto rt = LoadRt(ctx);
  // sf->prev_frame = rt->current_stack_frame;
  auto prev_frame = LoadCurrentStackFrame(rt);
  SavePrevFrame(prev_frame);
  // rt->current_stack_frame = sf;
  StoreCurrentStackFrame(rt, old_frame);
  // sf->cur_sp = NULL; /* cur_sp is NULL if the function is running */
  auto pc = RestoreCurPc();
  SetNewPc(pc);
  // sp = sf->cur_sp;
  auto sp = RestoreCurSp();
  SetNewSp(sp);

  // var_buf = sf->var_buf;
  ReloadVarBuf();
  // arg_buf = sf->arg_buf;
  ReloadArgBuf();
  // var_refs = p->u.func.var_refs;
  ReloadVarRefsCache();

  // if (s->throw_flag)
  //   goto exception;
  // else
  //   goto restart;
  son::node::Label throw_e(this);
  son::node::Label next(this);
  auto throw_flag = LoadAsyncStackThrowFlag(s);
  auto cond = NotEqual(throw_flag, IntValue(0));
  Branch(cond, &throw_e, &next, son::node::BranchHint::kFalse);
  Bind(&throw_e);
  { DispatchException(); }
  Bind(&next);
  DispatchWithPc(pc);
}

void HandlerImpl::GenCommonCall() {
  son::node::Label is_object(this);
  son::node::Label not_object(this);

  auto call_argc = TruncInt64ToInt32(GetArgc());
  auto call_argv = GetSp();
  auto func_obj = GetFuncObj();
  CheckFunctIsObject(func_obj);
  CheckCallNative(func_obj, false);

  // auto b = p->u.func.function_bytecode;
  // auto arg_count = b->arg_count;
  auto b = LoadFunctionBytecode(CastToRaw(func_obj));
  auto arg_count = ZExtToInt32(LoadArgCount(b));

  son::node::Label arg_mismatch(this);
  son::node::Label arg_equal(this);

  // if (unlikely(call_argc < arg_count))
  auto cond = LessThan(call_argc, arg_count);
  Branch(cond, &arg_mismatch, &arg_equal, son::node::BranchHint::kFalse);
  Bind(&arg_equal);
  GenCommonCallInternal(b, func_obj, arg_count, call_argc, call_argv, false);
  Bind(&arg_mismatch);
  {
    ClearNewSp();
    SetNewFrame(nullptr);
    SetNewPc(nullptr);
    GenCommonCallInternal(b, func_obj, arg_count, call_argc, call_argv, true);
  }
}

void HandlerImpl::GenCommonCallInternal(son::node::Node* b,
                                        son::node::Node* func_obj,
                                        son::node::Node* arg_count,
                                        son::node::Node* call_argc,
                                        son::node::Node* call_argv,
                                        bool copy_arg, bool from_entry) {
  auto var_count = ZExtToInt32(LoadVarCount(b));
  auto stack_size = ZExtToInt32(LoadStackSize(b));
  auto val_count = Int32Add(var_count, stack_size);

  son::node::Node* arg_allocated_size = nullptr;
  // if (unlikely(call_argc < arg_count)) {
  if (copy_arg) {
    arg_allocated_size = arg_count;
    val_count = Int32Add(val_count, arg_allocated_size);
  } else if (from_entry) {
    // from_entry copy argv
    val_count = Int32Add(val_count, call_argc);
  }
  auto alloca_size = Int32Mul(val_count, IntValue(sizeof(LEPUSValue)));
  auto frame_size = IntValue(AccessBuilder::js_stack_frame_size());
  alloca_size = Int32Add(alloca_size, frame_size);
  auto ctx = GetCtx();

  // sp = var_buf + var_count;
  auto prev_frame = GetFrame();
  son::node::Node* prev_sp = nullptr;
  auto sf = PushStackFrame(alloca_size, &prev_sp);
  SetVar(HandlerVarIndex::kFrame, sf);
  SaveLastLr();
  SaveLastFrame(prev_sp);

  // sf->prev_frame = rt->current_stack_frame;
  SavePrevFrame(prev_frame);
  // sf->cur_func = func_obj;
  SaveCurFunc(func_obj);

  auto this_obj = GetThisObject();
  // sf->this_obj = this_obj;
  SaveThisObject(this_obj);
  auto new_target = GetNewTarget();
  // sf->new_target = new_target;
  SaveNewTarget(new_target);

  auto var_refs = LoadVarRefs(CastToRaw(func_obj));
  SaveVarRefsCache(var_refs);
  // init_list_head(&sf->var_ref_list);
  auto var_ref_list_ptr = GetVarRefListAddress();
  StoreListPrev(var_ref_list_ptr, var_ref_list_ptr);
  StoreListNext(var_ref_list_ptr, var_ref_list_ptr);

  // sf->js_mode = b->js_mode;
  auto js_mode = LoadJsMode(b);
  SaveJsMode(ZExtToInt32(js_mode));

  // sf->cur_pc = pc;
  auto pc = LoadBytecodeBuf(b);
  // sf->argc = call_argc;
  SaveArgc(call_argc);

  // cpool = b->cpool;
  auto cpool = LoadCpool(b);
  SaveCpool(cpool);

  // auto local_buf = (LEPUSValue*)(sf + 1);
  // auto var_buf = local_buf + arg_allocated_size;
  // sf->var_buf = var_buf;
  son::node::Node* var_buf = nullptr;
  // if (unlikely(arg_allocated_size)) {
  if (arg_allocated_size != nullptr) {
    auto local_buf = CastToRaw(
        IntPtrAdd(sf, IntPtrValue(AccessBuilder::js_stack_frame_size())));
    // int n = min_int(call_argc, arg_count); // call_argc < arg_count
    auto n = Int32Min(call_argc, arg_count);
    // for (i = 0; i < n; i++) arg_buf[i] = call_argv[i];
    auto offset =
        IntPtrMul(ZExtInt32ToIntPtr(n), IntPtrValue(sizeof(LEPUSValue)));
    auto buffer_end = CastToRaw(IntPtrAdd(local_buf, offset));
    CopyArgs(local_buf, buffer_end, call_argv);
    // auto var_buf = local_buf + arg_allocated_size;
    offset = IntPtrMul(ZExtInt32ToIntPtr(arg_allocated_size),
                       IntPtrValue(sizeof(LEPUSValue)));
    var_buf = CastToRaw(IntPtrAdd(local_buf, offset));
    // for (; i < arg_count; i++) arg_buf[i] = LEPUS_UNDEFINED;
    CopyArgsUndefined(buffer_end, var_buf);
    // sf->arg_count = arg_count;
    SaveArgCount(arg_count);
    // sf->arg_buf = arg_buf;
    SaveArgBuffer(local_buf);
  } else if (from_entry) {
    // copy argv
    auto local_buf = CastToRaw(
        IntPtrAdd(sf, IntPtrValue(AccessBuilder::js_stack_frame_size())));
    // for (i = 0; i < n; i++) arg_buf[i] = call_argv[i];
    auto offset = IntPtrMul(ZExtInt32ToIntPtr(call_argc),
                            IntPtrValue(sizeof(LEPUSValue)));
    auto buffer_end = CastToRaw(IntPtrAdd(local_buf, offset));
    CopyArgs(local_buf, buffer_end, call_argv);
    var_buf = buffer_end;
    // sf->arg_count = call_argc;
    SaveArgCount(call_argc);
    // sf->arg_buf = arg_buf;
    SaveArgBuffer(local_buf);
  } else {
    var_buf = CastToRaw(
        IntPtrAdd(sf, IntPtrValue(AccessBuilder::js_stack_frame_size())));
    // sf->arg_count = call_argc;
    SaveArgCount(call_argc);
    // sf->arg_buf = arg_buf;
    SaveArgBuffer(call_argv);
  }
  SaveVarBuf(var_buf);
  // sf->var_refs = nullptr;
  SaveVarRefs(IntPtrValue(0));
  // sf->ref_size = sf->arg_count + var_count;
  if (arg_allocated_size != nullptr) {
    SaveVarRefSize(Int32Add(arg_count, var_count));
  } else {
    SaveVarRefSize(Int32Add(call_argc, var_count));
  }
  auto rt = LoadRt(ctx);
  StoreCurrentStackFrame(rt, sf);

  auto offset =
      IntPtrMul(ZExtInt32ToIntPtr(var_count), IntPtrValue(sizeof(LEPUSValue)));
  auto sp = CastToRaw(IntPtrAdd(var_buf, offset));
  // for (int i = 0; i < var_count; i++) var_buf[i] = LEPUS_UNDEFINED;
  CopyArgsUndefined(var_buf, sp);
  SetNewSp(sp);
  SetNewPc(pc);

  DebuggerCallEachFunc();
  DispatchWithPc(pc);
}

void HandlerImpl::GenInsert(PrimjsOpcode opcode) {
  // sp[0] = sp[-1];
  // sp[-1] = sp[-2];
  auto top0 = LoadTop0();
  auto top1 = LoadTop1();
  PushSp(top0);
  StoreTop1(top1);
  if (opcode == PrimjsOpcode::OP_insert2) {
    // sp[0] = sp[-1];
    // sp[-1] = sp[-2];
    // sp[-2] = sp[0];
    // sp++;
    StoreSp(-3, top0);
  } else if (opcode == PrimjsOpcode::OP_insert3) {
    // sp[0] = sp[-1];
    // sp[-1] = sp[-2];
    // sp[-2] = sp[-3];
    // sp[-3] = sp[0];
    // sp++;
    StoreSp(-3, LoadSp(-4));
    StoreSp(-4, top0);
  } else if (opcode == PrimjsOpcode::OP_insert4) {
    // sp[0] = sp[-1];
    // sp[-1] = sp[-2];
    // sp[-2] = sp[-3];
    // sp[-3] = sp[-4];
    // sp[-4] = sp[0];
    // sp++;
    StoreSp(-3, LoadSp(-4));
    StoreSp(-4, LoadSp(-5));
    StoreSp(-5, top0);
  } else {
    unreachable();
  }
  Dispatch(opcode);
}

void HandlerImpl::GenDup(PrimjsOpcode opcode) {
  auto top0 = LoadTop0();
  if (opcode == PrimjsOpcode::OP_dup) {
    // sp[0] = sp[-1];
    // sp++;
    PushSp(top0);
    Dispatch(opcode);
    return;
  }

  auto top1 = LoadTop1();
  if (opcode == PrimjsOpcode::OP_dup1) {
    // sp[0] = sp[-1];
    // sp[-1] = sp[-2];
    // sp++;
    PushSp(top0);
    StoreTop1(top1);
  } else if (opcode == PrimjsOpcode::OP_dup2) {
    // sp[0] = sp[-2];
    // sp[1] = sp[-1];
    // sp += 2;
    IncSp(2);
    StoreTop1(top1);
    StoreTop0(top0);
  } else if (opcode == PrimjsOpcode::OP_dup3) {
    // sp[0] = sp[-3];
    // sp[1] = sp[-2];
    // sp[2] = sp[-1];
    // sp += 3;
    auto val = LoadSp(-3);
    IncSp(3);
    StoreSp(-3, val);
    StoreTop1(top1);
    StoreTop0(top0);
  } else {
    unreachable();
  }
  Dispatch(opcode);
}

void HandlerImpl::GenSwap(PrimjsOpcode opcode) {
  auto top0 = LoadTop0();
  auto top1 = LoadTop1();
  if (opcode == PrimjsOpcode::OP_swap) {
    // tmp = sp[-2];
    // sp[-2] = sp[-1];
    // sp[-1] = tmp;
    StoreTop1(top0);
    StoreTop0(top1);
  } else if (opcode == PrimjsOpcode::OP_swap2) {
    // tmp1 = sp[-4];
    // tmp2 = sp[-3];
    // sp[-4] = sp[-2];
    // sp[-3] = sp[-1];
    // sp[-2] = tmp1;
    // sp[-1] = tmp2;
    auto tmp1 = LoadSp(-4);
    auto tmp2 = LoadSp(-3);
    StoreSp(-4, top1);
    StoreSp(-3, top0);
    StoreTop1(tmp1);
    StoreTop0(tmp2);
  }
  Dispatch(opcode);
}

void HandlerImpl::GenRot(PrimjsOpcode opcode) {
  auto top0 = LoadTop0();
  auto top1 = LoadTop1();
  if (opcode == PrimjsOpcode::OP_rot3l) {
    // tmp = sp[-3];
    // sp[-3] = sp[-2];
    // sp[-2] = sp[-1];
    // sp[-1] = tmp;
    auto tmp = LoadSp(-3);
    StoreSp(-3, top1);
    StoreTop1(top0);
    StoreTop0(tmp);
  } else if (opcode == PrimjsOpcode::OP_rot3r) {
    // tmp = sp[-1];
    // sp[-1] = sp[-2];
    // sp[-2] = sp[-3];
    // sp[-3] = tmp;
    auto tmp = top0;
    StoreTop0(top1);
    StoreTop1(LoadSp(-3));
    StoreSp(-3, tmp);
  } else if (opcode == PrimjsOpcode::OP_rot4l) {
    // tmp = sp[-4];
    // sp[-4] = sp[-3];
    // sp[-3] = sp[-2];
    // sp[-2] = sp[-1];
    // sp[-1] = tmp;
    auto tmp = LoadSp(-4);
    StoreSp(-4, LoadSp(-3));
    StoreSp(-3, top1);
    StoreTop1(top0);
    StoreTop0(tmp);
  } else if (opcode == PrimjsOpcode::OP_rot5l) {
    // tmp = sp[-5];
    // sp[-5] = sp[-4];
    // sp[-4] = sp[-3];
    // sp[-3] = sp[-2];
    // sp[-2] = sp[-1];
    // sp[-1] = tmp;
    auto tmp = LoadSp(-5);
    StoreSp(-5, LoadSp(-4));
    StoreSp(-4, LoadSp(-3));
    StoreSp(-3, top1);
    StoreTop1(top0);
    StoreTop0(tmp);
  } else {
    unreachable();
  }
  Dispatch(opcode);
}

void HandlerImpl::GenPerm(PrimjsOpcode opcode) {
  auto top1 = LoadTop1();
  if (opcode == PrimjsOpcode::OP_perm3) {
    // tmp = sp[-2];
    // sp[-2] = sp[-3];
    // sp[-3] = tmp;
    StoreTop1(LoadSp(-3));
    StoreSp(-3, top1);
  } else if (opcode == PrimjsOpcode::OP_perm4) {
    // tmp = sp[-2];
    // sp[-2] = sp[-3];
    // sp[-3] = sp[-4];
    // sp[-4] = tmp;
    StoreTop1(LoadSp(-3));
    StoreSp(-3, LoadSp(-4));
    StoreSp(-4, top1);
  } else if (opcode == PrimjsOpcode::OP_perm5) {
    // tmp = sp[-2];
    // sp[-2] = sp[-3];
    // sp[-3] = sp[-4];
    // sp[-4] = sp[-5];
    // sp[-5] = tmp;
    StoreTop1(LoadSp(-3));
    StoreSp(-3, LoadSp(-4));
    StoreSp(-4, LoadSp(-5));
    StoreSp(-5, top1);

  } else {
    unreachable();
  }
  Dispatch(opcode);
}

void HandlerImpl::GenDrop(PrimjsOpcode opcode) {
  if (opcode == PrimjsOpcode::OP_drop) {
    // sp--;
    DecSp();
  } else if (opcode == PrimjsOpcode::OP_nip) {
    auto top0 = LoadTop0();
    // sp[-2] = sp[-1];
    // sp--;
    DecSp();
    StoreTop0(top0);
  } else if (opcode == PrimjsOpcode::OP_nip1) {
    auto top0 = LoadTop0();
    auto top1 = LoadTop1();
    // sp[-3] = sp[-2];
    // sp[-2] = sp[-1];
    // sp--;
    DecSp();
    StoreTop1(top1);
    StoreTop0(top0);
  } else {
    unreachable();
  }
  Dispatch(opcode);
}

void HandlerImpl::GenPushConst(PrimjsOpcode opcode) {
  //   auto p = LEPUS_VALUE_GET_OBJ(sf->cur_func);
  //   auto b = p->u.func.function_bytecode;
  //   *sp = b->cpool[*pc];
  // #ifdef ENABLE_QUICKJS_DEBUGGER
  //   if (is_debug_mode) {
  //     DebuggerPause(ctx, *sp, pc);
  //   }
  // #endif
  //   sp++;
  //   pc++;
  auto cpool = GetCpool();
  son::node::Node* idx = nullptr;
  if (opcode == PrimjsOpcode::OP_push_const8) {
    idx = Fetch_8(0);
  } else {
    vmassert(opcode == PrimjsOpcode::OP_push_const, "must be");
    idx = Fetch_32(0);
  }
  auto val = LoadLepusVal(cpool, idx);
#ifdef ENABLE_QUICKJS_DEBUGGER
  son::node::Label not_debugger_mode(this);

  auto debug_mode = GetIsDebuggerMode();
  BranchIfFalse(debug_mode, &not_debugger_mode);
  {
    auto desc = son::node::CallDescriptors::DebuggerPause();
    CallRuntimeNoCheck(desc, GetCtx(), val, GetPc());
    Jump(&not_debugger_mode);
  }
  Bind(&not_debugger_mode);
#endif
  PushSp(val);
  Dispatch(opcode);
}

void HandlerImpl::GenFclosure(PrimjsOpcode opcode) {
  // auto p = LEPUS_VALUE_GET_OBJ(sf->cur_func);
  // auto b = p->u.func.function_bytecode;
  // auto cpool = b->cpool;
  // *sp++ = js_closure_gc(ctx, cpool[*pc++], sf->var_refs_cache, sf);
  // if (unlikely(LEPUS_IsException(sp[-1]))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  auto cpool = GetCpool();
  son::node::Node* idx = nullptr;
  if (opcode == PrimjsOpcode::OP_fclosure8) {
    idx = Fetch_8(0);
  } else {
    vmassert(opcode == PrimjsOpcode::OP_fclosure, "must be");
    idx = Fetch_32(0);
  }
  auto val = LoadLepusVal(cpool, idx);

  auto desc = son::node::CallDescriptors::js_closure_gc();
  auto var_refs_cache = GetVarRefsCache();
  auto ret_val = CallRuntime(desc, GetCtx(), val, var_refs_cache, GetFrame());
  PushSp(ret_val);
  Dispatch(opcode);
}

}  // namespace primjs
