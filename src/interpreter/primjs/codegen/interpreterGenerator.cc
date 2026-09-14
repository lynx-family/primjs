// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/interpreterGenerator.h"

#include "primjs/codegen/handlerImpl.h"

namespace primjs {

#define DEFINE_BYTECODE_HANDLER(Name)                              \
  class Name##Assembler : public HandlerImpl {                     \
   public:                                                         \
    Name##Assembler(son::node::NodeGraph* graph, base::Zone* zone) \
        : HandlerImpl(graph, zone) {}                              \
    void Generate(PrimjsOpcode opcode) {                           \
      son::node::GraphEnvironment env(this);                       \
      if (opcode != PrimjsOpcode::OP_invalid) {                    \
        if (!GeneratePrologue(opcode)) {                           \
          GenerateEpilogue();                                      \
          return;                                                  \
        }                                                          \
      }                                                            \
      GenerateImpl(opcode);                                        \
      GenerateEpilogue();                                          \
    }                                                              \
    void GenerateImpl(PrimjsOpcode opcode);                        \
  };                                                               \
  void Name##Assembler::GenerateImpl(PrimjsOpcode opcode)

DEFINE_BYTECODE_HANDLER(invalid) {
  auto message = Message("invalid opcode: pc=%u opcode=0x%02x");
  auto desc = son::node::CallDescriptors::LEPUS_ThrowInternalError();

  auto ctx = GetCtx();
  // (pc - b->byte_code_buf - 1)
  auto code_buf = RestoreCodeBuf();
  auto base = CastRawToIntPtr(code_buf);
  auto offset = IntPtrSub(CastRawToIntPtr(GetPc()), base);
  offset = IntPtrSub(offset, IntPtrValue(1));
  auto op = Int32Value((int)opcode);
  CallJumpException(desc, ctx, message, TruncIntPtrToInt32(offset), op);
}

DEFINE_BYTECODE_HANDLER(nop) { Dispatch(opcode); }

DEFINE_BYTECODE_HANDLER(inc_coverage) {
  son::node::Label ensure_counters(this);
  son::node::Label update_counter(this);
  son::node::Label done(this);

  auto function_bytecode = RestoreFunctionBytecode();
  auto counters =
      LoadByteOffset(son::node::MachineType::kRawType, function_bytecode,
                     AccessBuilder::coverage_counters_offset());
  auto counters_missing = Equal(counters, NullptrValue());
  Branch(counters_missing, &ensure_counters, &update_counter,
         son::node::BranchHint::kFalse);

  Bind(&ensure_counters);
  {
    auto desc = son::node::CallDescriptors::EnsureCoverageCounters();
    CallRuntimeNoCheck(desc, GetCtx(), function_bytecode);
    Jump(&update_counter);
  }

  Bind(&update_counter);
  {
    // The runtime call may move GC-managed objects, so reload both the
    // bytecode object and its lazily allocated counter array.
    function_bytecode = RestoreFunctionBytecode();
    counters =
        LoadByteOffset(son::node::MachineType::kRawType, function_bytecode,
                       AccessBuilder::coverage_counters_offset());
    auto counters_available = NotEqual(counters, NullptrValue());
    BranchIfFalse(counters_available, &done, son::node::BranchHint::kFalse);

    auto slot = Fetch_32(0);
    auto slot_count =
        LoadByteOffset(son::node::MachineType::kInt32, function_bytecode,
                       AccessBuilder::coverage_slot_count_offset());
    auto slot_out_of_range = UnsignedGreaterThanOrEqual(slot, slot_count);
    BranchIf(slot_out_of_range, &done, son::node::BranchHint::kFalse);

    auto count = LoadImpl(son::node::MachineType::kInt32, counters, slot);
    Store(son::node::MachineType::kInt32, counters, slot,
          Int32Add(count, IntValue(1)));
    Jump(&done);
  }

  Bind(&done);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(push_i32) {
  // *sp++ = LEPUS_NewInt32(ctx, get_u32(pc));
  // DISPATCH(4);
  auto imm = Fetch_32(0);
  auto val = NewInt32(imm);
  GenPushOp(val, opcode);
}

DEFINE_BYTECODE_HANDLER(push_const) { GenPushConst(opcode); }

DEFINE_BYTECODE_HANDLER(fclosure) { GenFclosure(opcode); }

DEFINE_BYTECODE_HANDLER(push_atom_value) {
  // *sp++ = JS_AtomToValue_GC(ctx, get_u32(pc));
  // pc += 4;
  auto desc = son::node::CallDescriptors::__JS_AtomToValue_GC();
  auto imm = Fetch_32(0);
  auto ctx = GetCtx();
  auto res = CallRuntimeArg2(desc, ctx, imm, IntValue(0));
  PushSp(res);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(private_symbol) {
  // atom = get_u32(pc);
  // pc += 4;
  // val = JS_NewSymbolFromAtom(ctx, atom, JS_ATOM_TYPE_PRIVATE);
  // if (LEPUS_IsException(val)) goto exception;
  // *sp++ = val;
  auto atom = Fetch_32(0);

  auto desc = son::node::CallDescriptors::JS_NewSymbolFromAtom_GC();
  auto ctx = GetCtx();
  auto atom2 = IntValue(JS_ATOM_TYPE_PRIVATE);
  auto res = CallRuntimeArg2(desc, ctx, atom, atom2);
  PushSp(res);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(undefined) {
  // *sp++ = LEPUS_UNDEFINED;
  GenPushOp(LepusUndefined(), opcode);
}
DEFINE_BYTECODE_HANDLER(null) {
  // *sp++ = LEPUS_NULL;
  GenPushOp(LepusNull(), opcode);
}
DEFINE_BYTECODE_HANDLER(push_this) {
  // LEPUSValue val;
  // auto this_obj = sf->this_obj;
  // if (!(sf->js_mode & JS_MODE_STRICT)) {
  //   if (likely(LEPUS_VALUE_IS_OBJECT(this_obj))) {
  //     val = this_obj;
  //   }
  //   if (LEPUS_VALUE_IS_NULL(this_obj) || LEPUS_VALUE_IS_UNDEFINED(this_obj))
  //   {
  //     val = ctx->global_obj;
  //   } else {
  //     val = LEPUS_ToObject(ctx, this_obj);
  //     if (LEPUS_IsException(val)) {
  //       TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //     }
  //   }
  // } else {
  //   val = this_obj;
  // }
  // *sp++ = val;
  auto this_obj = RestoreThis();
  auto js_mode = RestoreJsMode();

  son::node::Label is_strict(this);
  son::node::Label not_strict(this);
  son::node::Label normal_this(this);

  auto mark = Int32And(js_mode, IntValue(JS_MODE_STRICT));
  auto is_equal = Equal(mark, IntValue(0));
  Branch(is_equal, &not_strict, &normal_this, son::node::BranchHint::kTrue);
  Bind(&not_strict);
  {
    son::node::Label not_normal_this(this);
    Branch(IsLepusObject(this_obj), &normal_this, &not_normal_this,
           son::node::BranchHint::kTrue);
    Bind(&not_normal_this);
    {
      son::node::Label to_object(this);
      son::node::Label use_global(this);
      auto cond = BoolOr(IsUndefined(this_obj), IsNull(this_obj));
      Branch(cond, &use_global, &to_object, son::node::BranchHint::kTrue);
      Bind(&use_global);
      {
        auto global = GetGlobal();
        // clean up sp
        ClearNewSp();
        PushSp(global);
        Dispatch(opcode);
      }
      Bind(&to_object);
      {
        // clean up sp
        ClearNewSp();
        this_obj = RestoreThis();
        auto ctx = GetCtx();
        auto desc = son::node::CallDescriptors::JS_ToObject_GC();
        auto res = CallRuntimeArg1(desc, ctx, this_obj);
        PushSp(res);
        Dispatch(opcode);
      }
    }
  }
  Bind(&normal_this);
  {
    // clean up sp
    ClearNewSp();
    PushSp(this_obj);
    Dispatch(opcode);
  }
}
DEFINE_BYTECODE_HANDLER(push_false) {
  // *sp++ = LEPUS_FALSE;
  GenPushOp(LepusFalse(), opcode);
}
DEFINE_BYTECODE_HANDLER(push_true) {
  // *sp++ = LEPUS_TRUE;
  GenPushOp(LepusTrue(), opcode);
}
DEFINE_BYTECODE_HANDLER(object) {
  // *sp++ = LEPUS_NewObject(ctx);
  // if (unlikely(LEPUS_IsException(sp[-1]))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  auto desc = son::node::CallDescriptors::PRIM_JS_NewObject_GC();
  auto res = CallRuntimeArg0(desc, GetCtx());
  PushSp(res);
  Dispatch(opcode);
}
DEFINE_BYTECODE_HANDLER(special_object) { GenSpecialObject(opcode); }
DEFINE_BYTECODE_HANDLER(rest) {
  // int first = get_u16(pc);
  // pc += 2;
  // *sp++ = js_build_rest(ctx, first, argc, (LEPUSValueConst *)argv);
  // if (unlikely(LEPUS_IsException(sp[-1]))) goto exception;
  auto firset = Fetch_16(0);
  auto argc = RestoreArgc();
  auto argv = RestoreArgBuf();
  auto desc = son::node::CallDescriptors::js_build_rest_gc();
  auto res = CallRuntime(desc, GetCtx(), firset, argc, argv);
  PushSp(res);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(drop) { GenDrop(opcode); }

DEFINE_BYTECODE_HANDLER(nip) { GenDrop(opcode); }
DEFINE_BYTECODE_HANDLER(nip1) { GenDrop(opcode); }

DEFINE_BYTECODE_HANDLER(dup) { GenDup(opcode); }

DEFINE_BYTECODE_HANDLER(dup1) { GenDup(opcode); }

DEFINE_BYTECODE_HANDLER(dup2) { GenDup(opcode); }

DEFINE_BYTECODE_HANDLER(dup3) { GenDup(opcode); }

DEFINE_BYTECODE_HANDLER(insert2) { GenInsert(opcode); }

DEFINE_BYTECODE_HANDLER(insert3) { GenInsert(opcode); }

DEFINE_BYTECODE_HANDLER(insert4) { GenInsert(opcode); }

DEFINE_BYTECODE_HANDLER(perm3) { GenPerm(opcode); }
DEFINE_BYTECODE_HANDLER(perm4) { GenPerm(opcode); }

DEFINE_BYTECODE_HANDLER(perm5) { GenPerm(opcode); }

DEFINE_BYTECODE_HANDLER(swap) { GenSwap(opcode); }

DEFINE_BYTECODE_HANDLER(swap2) { GenSwap(opcode); }

DEFINE_BYTECODE_HANDLER(rot3l) { GenRot(opcode); }
DEFINE_BYTECODE_HANDLER(rot3r) { GenRot(opcode); }
DEFINE_BYTECODE_HANDLER(rot4l) { GenRot(opcode); }
DEFINE_BYTECODE_HANDLER(rot5l) { GenRot(opcode); }

DEFINE_BYTECODE_HANDLER(call) {
  // auto call_argc = get_u16(pc);
  // pc += 2;
  // auto this_obj = LEPUS_UNDEFINED.ptr;
  // sf->caller_argc = call_argc;
  // TAIL_CALL return common_call_h(HANDLER_PARAM_WITH_ARG1((intptr_t)call_argc,
  // this_obj));
  GenCallOp(opcode);
}

DEFINE_BYTECODE_HANDLER(call_constructor) {
  // auto call_argc = get_u16(pc);
  // pc += 2;
  // auto call_argv = sp - call_argc;
  // sf->cur_pc = pc;
  // auto ret_val = JS_CallConstructorInternal_GC(ctx, call_argv[-2],
  // call_argv[-1],
  //                                              call_argc, call_argv, 0);
  // if (unlikely(LEPUS_IsException(ret_val))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // sp -= call_argc + 2;
  // *sp++ = ret_val;
  auto saved_pc = IntPtrAdd(GetPc(), IntPtrValue(get_opcode_size(opcode) - 1));
  SavePc(CastIntPtrToRaw(saved_pc));
  auto call_argc = Fetch_16(0);
  auto call_argc_intptr = ZExtInt32ToIntPtr(call_argc);
  auto call_argv = LeapSp(call_argc);

  auto func_obj = LoadSp(call_argv, -2);
  auto new_target = LoadSp(call_argv, -1);

  auto desc = son::node::CallDescriptors::JS_CallConstructorInternal_GC();
  auto res = CallRuntime(desc, GetCtx(), func_obj, new_target, call_argc,
                         call_argv, IntValue(0));

  call_argc = Fetch_16(0);
  DecSp(IntPtrAdd(ZExtInt32ToIntPtr(call_argc), IntPtrValue(2)));
  PushSp(res);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(tail_call) {
  // auto call_argc = get_u16(pc);
  // pc += 2;
  // auto this_obj = LEPUS_UNDEFINED.ptr;
  // sf->caller_argc = -1;
  // TAIL_CALL return common_call_h(HANDLER_PARAM_WITH_ARG1((intptr_t)call_argc,
  // this_obj));
  GenCallOp(opcode);
}

DEFINE_BYTECODE_HANDLER(call_method) {
  // auto call_argc = (intptr_t)get_u16(pc);
  // pc += 2;
  // auto call_argv = sp - call_argc;
  // auto this_obj = call_argv[-2].ptr;
  // sf->caller_argc = call_argc + 1; // +1 for this
  // TAIL_CALL return common_call_h(HANDLER_PARAM_WITH_ARG1(call_argc,
  // this_obj));
  GenCallOp(opcode);
}

DEFINE_BYTECODE_HANDLER(tail_call_method) {
  // auto call_argc = (intptr_t)get_u16(pc);
  // pc += 2;
  // auto call_argv = sp - call_argc;
  // auto this_obj = call_argv[-2].ptr;
  // sf->caller_argc = -1; // +1 for this
  // TAIL_CALL return common_call_h(HANDLER_PARAM_WITH_ARG1(call_argc,
  // this_obj));
  GenCallOp(opcode);
}

DEFINE_BYTECODE_HANDLER(array_from) { GenArrayFrom(opcode); }

DEFINE_BYTECODE_HANDLER(apply) {
  // magic = get_u16(pc);
  // ret_val = js_function_apply(ctx, sp[-3], 2, (LEPUSValueConst *)&sp[-2],
  //                             magic);
  // if (unlikely(LEPUS_IsException(ret_val))) goto exception;
  // sp -= 3;
  // *sp++ = ret_val;
  PollInterrupts();
  auto magic = Fetch_16(0);
  auto this_obj = LoadSp(-3);
  auto argv = LeapSp(IntValue(2));
  auto desc = son::node::CallDescriptors::js_function_apply_gc();
  auto res = CallRuntime(desc, GetCtx(), this_obj, IntValue(2), argv, magic);
  DecSp(2);
  StoreTop0(res);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(return) {
  // TAIL_CALL return common_return_h(HANDLER_PARAM(pc));
  // ret_val = *--sp;
  auto ret_val = PopSp();
  SaveRetVal(ret_val);
  DispatchFastPath(CallBcIndex::kcommon_return);
}

DEFINE_BYTECODE_HANDLER(return_undef) {
  // sp[-1] = LEPUS_UNDEFINED;
  // TAIL_CALL return common_return_h(HANDLER_PARAM(pc));
  SaveRetVal(LepusUndefined());
  DispatchFastPath(CallBcIndex::kcommon_return);
}

DEFINE_BYTECODE_HANDLER(check_ctor_return) {
  // if (!LEPUS_IsObject(sp[-1])) {
  //   if (!LEPUS_IsUndefined(sp[-1])) {
  //     LEPUS_ThrowTypeError(
  //         caller_ctx,
  //         "derived class constructor must return an object or undefined");
  //     goto exception;
  //   }
  //   sp[0] = LEPUS_TRUE;
  // }
  // else {
  //   sp[0] = LEPUS_FALSE;
  // }
  // sp++;
  auto obj = LoadTop0();
  son::node::Label not_object(this);
  son::node::Label throw_e(this);

  auto cond = IsLepusObject(obj);
  BranchIfFalse(cond, &not_object);
  {
    ClearNewSp();
    PushSp(LepusFalse());
    Dispatch(opcode);
  }
  Bind(&not_object);
  {
    ClearNewSp();
    cond = NotEqual(obj, LepusUndefined());
    BranchIf(cond, &throw_e);
    PushSp(LepusTrue());
    Dispatch(opcode);

    Bind(&throw_e);
    {
      ClearNewSp();
      // "iterator does not have a throw method";
      auto desc = son::node::CallDescriptors::LEPUS_ThrowTypeError();
      auto message = Message(
          "derived class constructor must return an object or undefined");
      CallJumpException(desc, GetCtx(), message);
    }
  }
}
DEFINE_BYTECODE_HANDLER(check_ctor) {
  // if (LEPUS_IsUndefined(new_target)) {
  //    LEPUS_ThrowTypeError(caller_ctx,
  //        "class constructors must be invoked with 'new'");
  // goto exception;
  son::node::Label is_undefined(this);

  auto new_target = RestoreNewTarget();
  auto cond = Equal(new_target, LepusUndefined());
  BranchIf(cond, &is_undefined);
  { Dispatch(opcode); }
  Bind(&is_undefined);
  {
    auto desc = son::node::CallDescriptors::LEPUS_ThrowTypeError();
    auto message = Message("class constructors must be invoked with 'new'");
    CallJumpException(desc, GetCtx(), message);
  }
}
DEFINE_BYTECODE_HANDLER(check_brand) {
  // if (JS_CheckBrand(ctx, sp[-2], sp[-1]) < 0) goto exception;
  auto obj = LoadTop1();
  auto home_obj = LoadTop0();
  auto desc = son::node::CallDescriptors::JS_CheckBrand_GC();
  CallIntRetRuntime(desc, GetCtx(), obj, home_obj);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(add_brand) {
  // if (JS_AddBrand(ctx, sp[-2], sp[-1]) < 0) goto exception;
  // sp -= 2;
  auto obj = LoadTop1();
  auto home_obj = LoadTop0();
  auto desc = son::node::CallDescriptors::JS_AddBrand_GC();
  CallIntRetRuntime(desc, GetCtx(), obj, home_obj);
  DecSp(2);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(throw) {
  auto ctx = GetCtx();

  auto desc = son::node::CallDescriptors::LEPUS_Throw();
  auto op1 = LoadTop0();
  DecSp();
  CallJumpException(desc, GetCtx(), op1);
}

DEFINE_BYTECODE_HANDLER(throw_var) {
#define JS_THROW_VAR_RO 0
#define JS_THROW_VAR_REDECL 1
#define JS_THROW_VAR_UNINITIALIZED 2
#define JS_THROW_ERROR_DELETE_SUPER 3
#define JS_THROW_ERROR_ITERATOR_THROW 4

  son::node::Label var_ro(this);
  son::node::Label var_redecl(this);
  son::node::Label var_uninit(this);
  son::node::Label delete_super(this);
  son::node::Label iterator_throw(this);
  son::node::Label is_default(this);
  son::node::Label done(this);

  auto ctx = GetCtx();
  auto atom = Fetch_32(0);
  auto type = Fetch_8(4);
  Switch(type)
      ->Case(JS_THROW_VAR_RO, &var_ro)
      ->Case(JS_THROW_VAR_REDECL, &var_redecl)
      ->Case(JS_THROW_VAR_UNINITIALIZED, &var_uninit)
      ->Case(JS_THROW_ERROR_DELETE_SUPER, &delete_super)
      ->Case(JS_THROW_ERROR_ITERATOR_THROW, &iterator_throw)
      ->Default(&is_default);

  Bind(&var_ro);
  {
    auto desc = son::node::CallDescriptors::JS_ThrowTypeErrorReadOnly();
    CallRuntimeNoCheck(desc, ctx, IntValue(LEPUS_PROP_THROW), atom);
    Jump(&done);
  }
  Bind(&var_redecl);
  {
    auto desc =
        son::node::CallDescriptors::JS_ThrowSyntaxErrorVarRedeclaration_GC();
    CallRuntimeNoCheck(desc, ctx, atom);
    Jump(&done);
  }
  Bind(&var_uninit);
  {
    auto desc =
        son::node::CallDescriptors::JS_ThrowReferenceErrorUninitialized_GC();
    CallRuntimeNoCheck(desc, ctx, atom);
    Jump(&done);
  }
  Bind(&delete_super);
  {
    // const char* msg = "unsupported reference to 'super'";
    auto desc = son::node::CallDescriptors::LEPUS_ThrowReferenceError();
    auto message = Message("unsupported reference to 'super'");
    CallRuntimeNoCheck(desc, ctx, message);
    Jump(&done);
  }
  Bind(&iterator_throw);
  {
    // "iterator does not have a throw method";
    auto desc = son::node::CallDescriptors::LEPUS_ThrowTypeError();
    auto message = Message("iterator does not have a throw method");
    CallRuntimeNoCheck(desc, ctx, message);
    Jump(&done);
  }
  Bind(&is_default);
  {
    // "invalid throw var type %d";
    auto message = Message("invalid throw var type %d");
    auto desc = son::node::CallDescriptors::LEPUS_ThrowInternalError();
    CallRuntimeNoCheck(desc, ctx, message, atom);
    Jump(&done);
  }
  Bind(&done);
  DispatchException();

#undef JS_THROW_VAR_RO
#undef JS_THROW_VAR_REDEL
#undef JS_THROW_VAR_UNINITIALIZED
#undef JS_THROW_ERROR_DELETE_SUPER
#undef JS_THROW_ERROR_ITERATOR_THROW
}
DEFINE_BYTECODE_HANDLER(eval) {
  // scope_idx = get_u16(pc) - 1;
  // pc += 2;
  // obj = sp[-1];
  // sp[-1] = JS_EvalObject(ctx, LEPUS_UNDEFINED, obj,
  //                              LEPUS_EVAL_TYPE_DIRECT, scope_idx);
  // if (unlikely(LEPUS_IsException(sp[-1]))) goto exception;
  auto scope_idx = Int32Sub(Fetch_16(0), IntValue(1));
  auto obj = LoadTop0();
  auto desc = son::node::CallDescriptors::prim_js_op_eval_gc();
  auto res = CallRuntime(desc, GetCtx(), scope_idx, obj);
  StoreTop0(res);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(regexp) {
  auto ctx = GetCtx();

  auto desc = son::node::CallDescriptors::js_regexp_constructor_internal_gc();

  auto op1 = LoadTop1();
  auto op2 = LoadTop0();
  auto ret_val = CallRuntime(desc, ctx, LepusUndefined(), op1, op2);
  DecSp();
  StoreTop0(ret_val);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(get_super) {
  // proto = LEPUS_DupValue(ctx, JS_GetPrototype_RC(ctx, sp[-1]));
  // if (LEPUS_IsException(proto)) goto exception;
  // sp[-1] = proto;
  auto ctx = GetCtx();
  auto desc = son::node::CallDescriptors::JS_GetPrototype_GC();
  auto obj = LoadTop0();
  auto res = CallRuntime(desc, ctx, obj);
  StoreTop0(res);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(get_super_ctor) {
  // proto = LEPUS_DupValue(ctx, JS_GetPrototype_RC(ctx, sp[-1]));
  // if (LEPUS_IsException(proto)) goto exception;
  // if (!LEPUS_IsConstructor(ctx, proto)) {
  //   LEPUS_FreeValue(ctx, proto);
  //   LEPUS_ThrowTypeError(ctx, "not a constructor");
  //   goto exception;
  // }
  // LEPUS_FreeValue(ctx, sp[-1]);
  // sp[-1] = proto;
  auto ctx = GetCtx();
  auto desc = son::node::CallDescriptors::primjs_get_super_ctor_gc();
  auto obj = LoadTop0();
  auto res = CallRuntime(desc, ctx, obj);
  StoreTop0(res);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(import) {
  // val = js_dynamic_import(ctx, sp[-1]);
  // if (LEPUS_IsException(val)) goto exception;
  // LEPUS_FreeValue(ctx, sp[-1]);
  // sp[-1] = val;
  auto ctx = GetCtx();
  auto desc = son::node::CallDescriptors::js_dynamic_import();
  auto obj = LoadTop0();
  auto val = CallRuntime(desc, ctx, obj);
  StoreTop0(val);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(check_var) {
  // atom = get_u32(pc);
  // auto ret = JS_CheckGlobalVar(ctx, atom);
  // if (ret < 0) goto exception;
  // *sp++ = LEPUS_NewBool(ctx, ret);
  auto atom = Fetch_32(0);
  auto ctx = GetCtx();
  auto desc = son::node::CallDescriptors::JS_CheckGlobalVar_GC();
  auto res = CallIntRetRuntime(desc, ctx, atom);

  auto cond = NotEqual(res, IntValue(0));
  PushSp(NewBoolean(cond));
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(get_var_undef) {
  // LEPUSValue val;
  // JSAtom atom;
  // atom = get_u32(pc);
  // pc += 4;

  // val = JS_GetGlobalVarImpl_GC(ctx, atom, false);
  // if (unlikely(LEPUS_IsException(val))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // *sp++ = val;
  GenGetGlobalVar(opcode);
}

DEFINE_BYTECODE_HANDLER(get_var) {
  // LEPUSValue val;
  // JSAtom atom;
  // atom = get_u32(pc);
  // pc += 4;

  // val = JS_GetGlobalVarImpl_GC(ctx, atom, true);
  // if (unlikely(LEPUS_IsException(val))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // *sp++ = val;
  GenGetGlobalVar(opcode);
}

DEFINE_BYTECODE_HANDLER(put_var) {
  // int ret;
  // JSAtom atom;
  // atom = get_u32(pc);
  // pc += 4;

  // ret = LEPUS_SetGlobalVar(ctx, atom, sp[-1], 0);
  // sp--;
  // if (unlikely(ret < 0)) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  auto atom = Fetch_32(0);
  auto desc = son::node::CallDescriptors::JS_SetGlobalVar_GC();
  auto val = LoadTop0();
  auto ret_val = CallIntRetRuntime(desc, GetCtx(), atom, val, IntValue(0));
  DecSp();
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(put_var_init) {
  // int ret;
  // JSAtom atom;
  // atom = get_u32(pc);
  // pc += 4;

  // ret = LEPUS_SetGlobalVar(ctx, atom, sp[-1], 1);
  // sp--;
  // if (unlikely(ret < 0)) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  auto atom = Fetch_32(0);
  auto desc = son::node::CallDescriptors::JS_SetGlobalVar_GC();
  auto val = LoadTop0();
  auto ret_val = CallIntRetRuntime(desc, GetCtx(), atom, val, IntValue(1));
  DecSp();
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(put_var_strict) {
  // atom = get_u32(pc);
  // if (unlikely(!LEPUS_VALUE_GET_BOOL(sp[-2]))) {
  //   JS_ThrowReferenceErrorNotDefined(ctx, atom);
  //   goto exception;
  // }
  // ret = JS_SetGlobalVar_RC(ctx, atom, sp[-1], 2);
  // sp -= 2;
  // if (unlikely(ret < 0)) goto exception;
  auto atom = Fetch_32(0);

  son::node::Label throw_e(this);

  auto val = LoadTop1();
  auto cond = NotEqual(val, LepusTrue());
  BranchIf(cond, &throw_e, son::node::BranchHint::kFalse);

  auto obj = LoadTop0();
  auto desc = son::node::CallDescriptors::JS_SetGlobalVar_GC();
  CallIntRetRuntime(desc, GetCtx(), atom, obj, IntValue(2));
  DecSp(2);
  Dispatch(opcode);

  Bind(&throw_e);
  {
    ClearNewSp();
    auto desc =
        son::node::CallDescriptors::JS_ThrowReferenceErrorNotDefined_GC();
    atom = Fetch_32(0);
    CallJumpException(desc, GetCtx(), atom);
  }
}

DEFINE_BYTECODE_HANDLER(get_ref_value) {
  // if (unlikely(LEPUS_IsUndefined(sp[-2]))) {
  //   JSAtom atom = js_value_to_atom(ctx, sp[-1]);
  //   if (atom != JS_ATOM_NULL) {
  //     JS_ThrowReferenceErrorNotDefined(ctx, atom);
  //     LEPUS_FreeAtom(ctx, atom);
  //   }
  //   goto exception;
  // }
  // val = JS_GetPropertyValue(ctx, sp[-2], LEPUS_DupValue(ctx, sp[-1]));
  // if (unlikely(LEPUS_IsException(val))) goto exception;
  // sp[0] = val;
  // sp++;
  son::node::Label is_indefined(this);

  auto obj = LoadTop1();
  auto prop = LoadTop0();
  auto cond = Equal(obj, LepusUndefined());
  BranchIf(cond, &is_indefined, son::node::BranchHint::kFalse);

  auto desc = son::node::CallDescriptors::JS_GetPropertyValue_GC();
  auto res = CallRuntime(desc, GetCtx(), obj, prop);
  PushSp(res);
  Dispatch(opcode);

  Bind(&is_indefined);
  {
    ClearNewSp();
    desc = son::node::CallDescriptors::js_value_to_atom_gc();
    auto atom = CallAtomRetRuntime(desc, GetCtx(), prop);
    desc = son::node::CallDescriptors::JS_ThrowReferenceErrorNotDefined_GC();
    CallJumpException(desc, GetCtx(), atom);
  }
}
DEFINE_BYTECODE_HANDLER(put_ref_value) {
  // if (unlikely(LEPUS_IsUndefined(sp[-3]))) {
  //   if (is_strict_mode(ctx)) {
  //     JSAtom atom = js_value_to_atom(ctx, sp[-2]);
  //     if (atom != JS_ATOM_NULL) {
  //       JS_ThrowReferenceErrorNotDefined(ctx, atom);
  //       LEPUS_FreeAtom(ctx, atom);
  //     }
  //     goto exception;
  //   } else {
  //     sp[-3] = LEPUS_DupValue(ctx, ctx->global_obj);
  //   }
  // }
  // ret = JS_SetPropertyValue(ctx, sp[-3], sp[-2], sp[-1],
  //                           LEPUS_PROP_THROW_STRICT);
  // LEPUS_FreeValue(ctx, sp[-3]);
  // sp -= 3;
  // if (unlikely(ret < 0)) goto exception;
  son::node::Label is_indefined(this);
  son::node::Label not_indefined(this);

  auto obj = LoadSp(-3);
  son::node::Variable obj_h(this, son::node::NodeType::Int64Type(), obj);
  auto prop = LoadTop1();
  auto val = LoadTop0();
  auto cond = Equal(obj, LepusUndefined());
  Branch(cond, &is_indefined, &not_indefined, son::node::BranchHint::kFalse);
  Bind(&is_indefined);
  {
    son::node::Label is_strict_mode(this);
    son::node::Label not_strict(this);

    auto js_mode = RestoreJsMode();
    auto mark = Int32And(js_mode, IntValue(JS_MODE_STRICT));
    auto is_equal = Equal(mark, IntValue(0));
    Branch(is_equal, &not_strict, &is_strict_mode,
           son::node::BranchHint::kTrue);

    Bind(&not_strict);
    {
      obj_h = GetGlobal();
      Jump(&not_indefined);
    }

    Bind(&is_strict_mode);
    auto desc = son::node::CallDescriptors::js_value_to_atom_gc();
    auto atom = CallAtomRetRuntime(desc, GetCtx(), prop);
    desc = son::node::CallDescriptors::JS_ThrowReferenceErrorNotDefined_GC();
    CallJumpException(desc, GetCtx(), atom);
  }
  Bind(&not_indefined);
  {
    auto desc = son::node::CallDescriptors::JS_SetPropertyValue_GC();
    CallIntRetRuntime(desc, GetCtx(), *obj_h, prop, val,
                      IntValue(LEPUS_PROP_THROW_STRICT));
    DecSp(3);
    Dispatch(opcode);
  }
}

DEFINE_BYTECODE_HANDLER(define_var) {
  // JSAtom atom;
  // int flags;
  // atom = get_u32(pc);
  // flags = pc[4];
  // pc += 5;
  // if (JS_DefineGlobalVar_GC(ctx, atom, flags)) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  auto atom = Fetch_32(0);
  auto flags = Fetch_8(4);
  auto desc = son::node::CallDescriptors::JS_DefineGlobalVar_GC();
  CallIntRetRuntime(desc, GetCtx(), atom, flags);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(check_define_var) {
  // JSAtom atom;
  // int flags;
  // atom = get_u32(pc);
  // flags = pc[4];
  // pc += 5;
  // if (JS_CheckDefineGlobalVar_GC(ctx, atom, flags)) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  auto atom = Fetch_32(0);
  auto flags = Fetch_8(4);
  auto desc = son::node::CallDescriptors::JS_CheckDefineGlobalVar_GC();
  CallIntRetRuntime(desc, GetCtx(), atom, flags);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(define_func) {
  // JSAtom atom;
  // int flags;
  // atom = get_u32(pc);
  // flags = pc[4];
  // pc += 5;
  // if (JS_DefineGlobalFunction_GC(ctx, atom, sp[-1], flags)) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // sp--;
  auto atom = Fetch_32(0);
  auto flags = Fetch_8(4);
  auto desc = son::node::CallDescriptors::JS_DefineGlobalFunction_GC();
  auto val = LoadTop0();
  CallIntRetRuntime(desc, GetCtx(), atom, val, flags);
  DecSp();
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(get_field) {
  // LEPUSValue val;
  // JSAtom atom;
  // atom = get_u32(pc);
  // pc += 4;

  // val = JS_GetPropertyInternalImpl_GC(ctx, sp[-1], atom, sp[-1], 0);
  // if (unlikely(LEPUS_IsException(val))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // sp[-1] = val;
  GenGetField(opcode);
}

DEFINE_BYTECODE_HANDLER(get_field2) {
  // LEPUSValue val;
  // JSAtom atom;
  // atom = get_u32(pc);
  // pc += 4;

  // val = JS_GetPropertyInternalImpl_GC(ctx, sp[-1], atom, sp[-1], 0);
  // if (unlikely(LEPUS_IsException(val))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // *sp++ = val;
  GenGetField(opcode);
}

DEFINE_BYTECODE_HANDLER(put_field) { GenPutField(opcode); }

DEFINE_BYTECODE_HANDLER(get_private_field) {
  //        val = JS_GetPrivateField(ctx, sp[-2], sp[-1]);
  // sp[-2] = val;
  // sp--;
  // if (unlikely(LEPUS_IsException(val))) goto exception;
  auto obj = LoadTop1();
  auto prop = LoadTop0();
  auto desc = son::node::CallDescriptors::JS_GetPrivateField_GC();
  auto val = CallRuntime(desc, GetCtx(), obj, prop);
  DecSp();
  StoreTop0(val);
  Dispatch(opcode);
}
DEFINE_BYTECODE_HANDLER(put_private_field) {
  // ret = JS_SetPrivateField(ctx, sp[-3], sp[-1], sp[-2]);
  // sp -= 3;
  // if (unlikely(ret < 0)) goto exception;
  auto obj = LoadSp(-3);
  auto prop = LoadTop0();
  auto val = LoadTop1();
  auto desc = son::node::CallDescriptors::JS_SetPrivateField_GC();
  CallIntRetRuntime(desc, GetCtx(), obj, prop, val);
  DecSp(3);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(define_private_field) {
  // ret = JS_DefinePrivateField(ctx, sp[-3], sp[-2], sp[-1]);
  // sp -= 2;
  // if (unlikely(ret < 0)) goto exception;
  auto obj = LoadSp(-3);
  auto prop = LoadTop1();
  auto val = LoadTop0();
  auto desc = son::node::CallDescriptors::JS_DefinePrivateField_GC();
  CallIntRetRuntime(desc, GetCtx(), obj, prop, val);
  DecSp(2);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(get_array_el) {
  // LEPUSValue val;

  // val = JS_GetPropertyValue_GC(ctx, sp[-2], sp[-1]);
  // sp[-2] = val;
  // sp--;
  // if (unlikely(LEPUS_IsException(val))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  GenGetArrayEl(opcode);
}

DEFINE_BYTECODE_HANDLER(get_array_el2) {
  // LEPUSValue val;

  // val = JS_GetPropertyValue_GC(ctx, sp[-2], sp[-1]);
  // sp[-1] = val;
  // if (unlikely(LEPUS_IsException(val))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  GenGetArrayEl(opcode);
}

DEFINE_BYTECODE_HANDLER(put_array_el) { GenPutArrayEl(opcode); }

DEFINE_BYTECODE_HANDLER(get_super_value) {
  // atom = js_value_to_atom(ctx, sp[-1]);
  // if (unlikely(atom == JS_ATOM_NULL)) goto exception;
  // val = LEPUS_GetPropertyInternal(ctx, sp[-2], atom, sp[-3], FALSE);
  // if (unlikely(LEPUS_IsException(val))) goto exception;
  // sp[-3] = val;
  // sp -= 2;
  auto prop = LoadTop0();
  auto desc = son::node::CallDescriptors::js_value_to_atom_gc();
  auto atom = CallAtomRetRuntime(desc, GetCtx(), prop);

  auto this_obj = LoadTop1();
  auto receiver = LoadSp(-3);
  desc = son::node::CallDescriptors::JS_GetPropertyInternalImpl_GC();
  auto ret_val =
      CallRuntime(desc, GetCtx(), this_obj, atom, receiver, IntValue(0));
  StoreSp(-3, ret_val);
  DecSp(2);
  Dispatch(opcode);
}
DEFINE_BYTECODE_HANDLER(put_super_value) {
  // if (LEPUS_VALUE_IS_NOT_OBJECT(sp[-3])) {
  //   JS_ThrowTypeErrorNotAnObject(ctx);
  //   goto exception;
  // }
  // atom = js_value_to_atom(ctx, sp[-2]);
  // if (unlikely(atom == JS_ATOM_NULL)) goto exception;
  // ret = JS_SetPropertyGeneric(ctx, LEPUS_VALUE_GET_OBJ(sp[-3]), atom,
  //                             sp[-1], sp[-4], LEPUS_PROP_THROW_STRICT);
  // sp -= 4;
  // if (ret < 0) goto exception;
  auto receiver = LoadSp(-3);
  son::node::Label not_object(this);

  auto cond = IsLepusObject(receiver);
  BranchIfFalse(cond, &not_object, son::node::BranchHint::kFalse);

  auto prop = LoadTop1();
  auto desc = son::node::CallDescriptors::js_value_to_atom_gc();
  auto atom = CallAtomRetRuntime(desc, GetCtx(), prop);

  auto val = LoadTop0();
  auto this_obj = LoadSp(-4);
  // ret = JS_SetPropertyGeneric(ctx, LEPUS_VALUE_GET_OBJ(sp[-3]), atom,
  //                             sp[-1], sp[-4], LEPUS_PROP_THROW_STRICT);
  desc = son::node::CallDescriptors::JS_SetPropertyGeneric_GC();
  CallIntRetRuntime(desc, GetCtx(), CastToRaw(receiver), atom, val, this_obj,
                    IntValue(LEPUS_PROP_THROW_STRICT));
  DecSp(4);
  Dispatch(opcode);
  Bind(&not_object);
  {
    ClearNewSp();
    auto desc = son::node::CallDescriptors::JS_ThrowTypeErrorNotAnObject();
    CallJumpException(desc, GetCtx());
  }
}

DEFINE_BYTECODE_HANDLER(define_field) {
  // int ret;
  // JSAtom atom;
  // atom = get_u32(pc);
  // pc += 4;

  // ret = JS_DefinePropertyValue_GC(ctx, sp[-2], atom, sp[-1],
  //                                 LEPUS_PROP_C_W_E | LEPUS_PROP_THROW);
  // sp--;
  // if (unlikely(ret < 0)) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  auto atom = Fetch_32(0);
  auto val = LoadTop0();
  auto this_obj = LoadTop1();

  auto desc = son::node::CallDescriptors::JS_DefinePropertyValue_GC();
  auto flags = IntValue(LEPUS_PROP_C_W_E | LEPUS_PROP_THROW);
  CallIntRetRuntime(desc, GetCtx(), this_obj, atom, val, flags);
  DecSp();
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(set_name) {
  // int ret;
  // JSAtom atom;
  // atom = get_u32(pc);
  // pc += 4;

  // ret = JS_DefineObjectName_GC(ctx, sp[-1], atom, LEPUS_PROP_CONFIGURABLE);
  // if (unlikely(ret < 0)) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  auto atom = Fetch_32(0);
  auto this_obj = LoadTop0();
  auto desc = son::node::CallDescriptors::JS_DefineObjectName();
  auto flags = IntValue(LEPUS_PROP_CONFIGURABLE);
  CallIntRetRuntime(desc, GetCtx(), this_obj, atom, flags);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(set_name_computed) {
  // ret = JS_DefineObjectNameComputed(ctx, sp[-1], sp[-2],
  //                                   LEPUS_PROP_CONFIGURABLE);
  // if (unlikely(ret < 0)) goto exception;
  auto obj = LoadTop0();
  auto str = LoadTop1();
  auto desc = son::node::CallDescriptors::JS_DefineObjectNameComputed_GC();
  auto flags = IntValue(LEPUS_PROP_CONFIGURABLE);
  CallIntRetRuntime(desc, GetCtx(), obj, str, flags);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(set_proto) {
  // proto = sp[-1];
  // if (LEPUS_IsObject(proto) || LEPUS_IsNull(proto)) {
  //   if (JS_SetPrototypeInternal(ctx, sp[-2], proto, TRUE) < 0)
  //     goto exception;
  // }
  // LEPUS_FreeValue(ctx, proto);
  // sp--;
  auto proto = LoadTop0();

  son::node::Label done(this);
  auto cond1 = IsLepusObject(proto);
  auto cond2 = IsNull(proto);
  BranchIfFalse(BoolOr(cond1, cond2), &done, son::node::BranchHint::kFalse);
  auto desc = son::node::CallDescriptors::JS_SetPrototypeInternal_GC();
  auto obj = LoadTop1();
  CallIntRetRuntime(desc, GetCtx(), obj, proto, IntValue(1));
  Jump(&done);

  Bind(&done);
  DecSp(1);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(set_home_object) {
  // js_method_set_home_object(ctx, sp[-1], sp[-2]);
  auto func_obj = LoadTop0();
  auto home_obj = LoadTop1();
  auto desc = son::node::CallDescriptors::js_method_set_home_object_gc();
  CallRuntimeNoCheck(desc, GetCtx(), func_obj, home_obj);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(define_array_el) {
  // ret = JS_DefinePropertyValueValue(ctx, sp[-3],
  //                                   LEPUS_DupValue(ctx, sp[-2]), sp[-1],
  //                                   LEPUS_PROP_C_W_E | LEPUS_PROP_THROW);
  // sp -= 1;
  // if (unlikely(ret < 0)) goto exception;

  auto this_obj = LoadSp(-3);
  auto prop = LoadTop1();
  auto val = LoadTop0();
  auto desc = son::node::CallDescriptors::JS_DefinePropertyValueValue_GC();
  auto flags = IntValue(LEPUS_PROP_C_W_E | LEPUS_PROP_THROW);
  CallIntRetRuntime(desc, GetCtx(), this_obj, prop, val, flags);
  DecSp(1);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(append) {
  // if (js_append_enumerate(ctx, sp)) goto exception;
  // LEPUS_FreeValue(ctx, *--sp);
  auto desc = son::node::CallDescriptors::js_append_enumerate_gc();
  CallIntRetRuntime(desc, GetCtx(), GetSp());
  DecSp(1);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(copy_data_properties) {
  // mask = *pc++;
  // if (JS_CopyDataProperties(ctx, sp[-1 - (mask & 3)],
  //                             sp[-1 - ((mask >> 2) & 7)],
  //                             sp[-1 - ((mask >> 5) & 7)], 0))
  //    goto exception;
  // }
  auto desc = son::node::CallDescriptors::prim_js_copy_data_properties_gc();
  auto mask = Fetch_8(0);
  CallIntRetRuntime(desc, GetCtx(), GetSp(), mask);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(define_method) { GenDefineMethod(opcode); }
DEFINE_BYTECODE_HANDLER(define_method_computed) { GenDefineMethod(opcode); }

DEFINE_BYTECODE_HANDLER(define_class) {
  // atom = get_u32(pc);
  // class_flags = pc[4];
  // pc += 5;
  // if (js_op_define_class(ctx, sp, atom, class_flags, var_refs, sf) < 0)
  //   goto exception;
  auto atom = Fetch_32(0);
  auto class_flags = Fetch_8(4);
  auto sf = GetFrame();
  auto var_refs = GetVarRefsCache();

  auto desc = son::node::CallDescriptors::js_op_define_class();
  CallIntRetRuntime(desc, GetCtx(), GetSp(), atom, class_flags, var_refs, sf);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(get_loc) {
  // idx = get_u16(pc);
  // pc += 2;
  // sp[0] = LEPUS_DupValue(ctx, var_buf[idx]);
  // sp++;
  GenGetVarBuf(opcode, -1);
}

DEFINE_BYTECODE_HANDLER(put_loc) {
  // idx = get_u16(pc);
  // pc += 2;
  // set_value(ctx, &var_buf[idx], sp[-1]);
  // sp--;
  GenSetVarBuf(opcode, -1, true);
}
DEFINE_BYTECODE_HANDLER(set_loc) {
  // idx = get_u16(pc);
  // pc += 2;
  // set_value(ctx, &var_buf[idx], LEPUS_DupValue(ctx, sp[-1]));
  GenSetVarBuf(opcode, -1, false);
}

DEFINE_BYTECODE_HANDLER(get_arg) {
  // int idx;
  // idx = get_u16(pc);
  // pc += 2;
  // sp[0] = sf->arg_buf[idx];
  // sp++;
  GenGetArgBuf(opcode, -1);
}

DEFINE_BYTECODE_HANDLER(put_arg) {
  // int idx;
  // idx = get_u16(pc);
  // pc += 2;
  // sf->arg_buf[idx] = sp[-1];
  // sp--;
  GenSetArgBuf(opcode, -1, true);
}

DEFINE_BYTECODE_HANDLER(set_arg) {
  // int idx;
  // idx = get_u16(pc);
  // pc += 2;
  // sf->arg_buf[idx] = sp[-1];
  GenSetArgBuf(opcode, -1, false);
}

DEFINE_BYTECODE_HANDLER(get_var_ref) {
  // int idx;
  // idx = get_u16(pc);
  // pc += 2;
  // sp[0] = *sf->var_refs_cache[idx]->pvalue;
  // // std::cout << "get_var_ref_h: idx: " << idx << " " << sp[0].ptr <<
  // std::endl; sp++;
  GenGetVarRefs(opcode, -1);
}

DEFINE_BYTECODE_HANDLER(set_var_ref) {
  // int idx;
  // idx = get_u16(pc);
  // pc += 2;
  // // std::cout << "set_var_ref_h: idx: " << idx << " " << sp[-1].ptr <<
  // std::endl; *sf->var_refs_cache[idx]->pvalue = sp[-1];
  GenSetVarRefs(opcode, -1, false);
}

DEFINE_BYTECODE_HANDLER(put_var_ref) {
  // int idx;
  // idx = get_u16(pc);
  // pc += 2;
  // // std::cout << "put_var_ref_h: idx: " << idx << " " << sp[-1].ptr <<
  // std::endl; *sf->var_refs_cache[idx]->pvalue = sp[-1]; sp--;
  GenSetVarRefs(opcode, -1, true);
}

DEFINE_BYTECODE_HANDLER(get_var_ref_check) { GenGetVarRefs(opcode, -1); }
DEFINE_BYTECODE_HANDLER(put_var_ref_check) { GenSetVarRefs(opcode, -1, true); }
DEFINE_BYTECODE_HANDLER(put_var_ref_check_init) {
  GenSetVarRefs(opcode, -1, true);
}

DEFINE_BYTECODE_HANDLER(set_loc_uninitialized) {
  // int idx;
  // idx = get_u16(pc);
  // pc += 2;
  // set_value(ctx, &var_buf[idx], LEPUS_UNINITIALIZED);
  auto idx = Fetch_16(0);
  auto var_buf = RestoreVarBuf();
  StoreLepusVal(var_buf, idx, Int64Value(LEPUS_UNINITIALIZED.as_int64));
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(get_loc_check) {
  // int idx;
  // idx = get_u16(pc);
  // pc += 2;
  // if (unlikely(LEPUS_IsUninitialized(var_buf[idx]))) {
  //   JS_ThrowReferenceErrorUninitialized(ctx, JS_ATOM_NULL);
  //   goto exception;
  // }
  // sp[0] = LEPUS_DupValue(ctx, var_buf[idx]);
  // sp++;
  GenGetVarBuf(opcode, -1);
}

DEFINE_BYTECODE_HANDLER(put_loc_check) {
  // int idx;
  // idx = get_u16(pc);
  // pc += 2;
  // if (unlikely(LEPUS_IsUninitialized(var_buf[idx]))) {
  //   JS_ThrowReferenceErrorUninitialized(ctx, JS_ATOM_NULL);
  //   goto exception;
  // }
  // set_value(ctx, &var_buf[idx], sp[-1]);
  // sp--;
  GenSetVarBuf(opcode, -1, true);
}

DEFINE_BYTECODE_HANDLER(put_loc_check_init) {
  // int idx;
  // idx = get_u16(pc);
  // pc += 2;
  // if (unlikely(!LEPUS_IsUninitialized(var_buf[idx]))) {
  //   LEPUS_ThrowReferenceError(ctx, "'this' can be initialized only once");
  //   goto exception;
  // }
  // set_value(ctx, &var_buf[idx], sp[-1]);
  // sp--;
  GenSetVarBuf(opcode, -1, true);
}

DEFINE_BYTECODE_HANDLER(close_loc) {
  auto idx = Fetch_16(0);
  auto desc = son::node::CallDescriptors::close_lexical_var();
  CallRuntimeNoThrow(desc, GetCtx(), GetFrame(), idx);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(if_true) {
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
  GenIfBranch(PrimjsOpcode::OP_if_true);
}

DEFINE_BYTECODE_HANDLER(if_false) {
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
  // if (!res) {
  //   pc += (int32_t)get_u32(pc - 4) - 4;
  // }
  GenIfBranch(PrimjsOpcode::OP_if_false);
}

DEFINE_BYTECODE_HANDLER(goto) {
  // pc += (int32_t)get_u32(pc);
  auto imm = Fetch_S32(0);
  auto offset = SExtInt32ToIntPtr(imm);
  DispatchJmp(offset);
}

DEFINE_BYTECODE_HANDLER(catch) {
  // int32_t diff;
  // diff = get_u32(pc);
  // auto p = LEPUS_VALUE_GET_OBJ(sf->cur_func);
  // auto b = p->u.func.function_bytecode;
  // sp[0] = LEPUS_NewCatchOffset(ctx, pc + diff - b->byte_code_buf);
  // sp++;
  // pc += 4;
  auto diff = ZExtInt32ToIntPtr(Fetch_32(0));
  auto code_buf = RestoreCodeBuf();
  auto base = CastRawToIntPtr(code_buf);
  // pc + diff - code_buf
  auto offset = IntPtrSub(CastRawToIntPtr(GetPc()), base);
  offset = IntPtrAdd(offset, diff);
  auto res = NewCatchOffset(ZExtIntPtrToInt64(offset));
  PushSp(res);
  Dispatch(opcode);
}
DEFINE_BYTECODE_HANDLER(gosub) {
  // int32_t diff;
  // diff = get_u32(pc);
  // /* XXX: should have a different tag to avoid security flaw */
  // sp[0] = LEPUS_NewInt32(ctx, pc + 4 - b->byte_code_buf);
  // sp++;
  // pc += diff;
  auto diff = Fetch_S32(0);
  auto code_buf = RestoreCodeBuf();
  auto base = CastRawToIntPtr(code_buf);
  // pc + 4 - b->byte_code_buf
  auto pc = IntPtrAdd(CastRawToIntPtr(GetPc()), IntPtrValue(4));
  auto offset = IntPtrSub(pc, base);
  PushSp(NewInt32(TruncIntPtrToInt32(offset)));

  DispatchJmp(SExtInt32ToIntPtr(diff));
}

DEFINE_BYTECODE_HANDLER(ret) {
  // op1 = sp[-1];
  // if (unlikely(!LEPUS_VALUE_IS_INT(op1))) goto ret_fail;
  // pos = LEPUS_VALUE_GET_INT(op1);
  // if (unlikely(pos >= b->byte_code_len)) {
  // ret_fail:
  //   LEPUS_ThrowInternalError(ctx, "invalid ret value");
  //   goto exception;
  // }
  // sp--;
  // pc = b->byte_code_buf + pos;
  auto op1 = LoadTop0();

  son::node::Label throw_e(this);

  auto cond = IsLepusInt(op1);
  BranchIfFalse(cond, &throw_e, son::node::BranchHint::kTrue);

  auto pos = GetLepusInt(op1);
  auto func_bytecode = RestoreFunctionBytecode();
  auto byte_code_len = LoadBytecodeLen(func_bytecode);

  cond = GreaterThanOrEqual(pos, byte_code_len);
  BranchIf(cond, &throw_e, son::node::BranchHint::kFalse);
  DecSp();

  // pc = b->byte_code_buf + pos;
  auto base = LoadBytecodeBuf(func_bytecode);
  auto new_pc = IntPtrAdd(base, pos);
  DispatchWithPc(new_pc);

  Bind(&throw_e);
  {
    ClearNewSp();
    auto desc = son::node::CallDescriptors::LEPUS_ThrowInternalError();
    auto message = Message("invalid ret value");
    CallJumpException(desc, GetCtx(), message);
  }
}

DEFINE_BYTECODE_HANDLER(to_object) {
  // if (LEPUS_VALUE_IS_NOT_OBJECT(sp[-1])) {
  //   auto ret_val = LEPUS_ToObject(ctx, sp[-1]);
  //   if (LEPUS_IsException(ret_val)) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp[-1] = ret_val;
  // }
  son::node::Label is_object(this);
  son::node::Label not_object(this);

  auto obj = LoadTop0();
  Branch(IsLepusObject(obj), &is_object, &not_object,
         son::node::BranchHint::kTrue);
  Bind(&not_object);
  {
    auto ctx = GetCtx();
    auto desc = son::node::CallDescriptors::JS_ToObject_GC();
    auto res = CallRuntimeArg1(desc, ctx, obj);
    StoreTop0(res);
    Jump(&is_object);
  }
  Bind(&is_object);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(to_propkey) {
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
  GenToPropertyKey(opcode);
}

DEFINE_BYTECODE_HANDLER(to_propkey2) { GenToPropertyKey(opcode); }

DEFINE_BYTECODE_HANDLER(with_get_var) { GenWithOp(opcode); }
DEFINE_BYTECODE_HANDLER(with_put_var) { GenWithOp(opcode); }
DEFINE_BYTECODE_HANDLER(with_delete_var) { GenWithOp(opcode); }
DEFINE_BYTECODE_HANDLER(with_make_ref) { GenWithOp(opcode); }
DEFINE_BYTECODE_HANDLER(with_get_ref) { GenWithOp(opcode); }
DEFINE_BYTECODE_HANDLER(with_get_ref_undef) { GenWithOp(opcode); }

DEFINE_BYTECODE_HANDLER(make_loc_ref) { GenMakeRefOp(opcode); }

DEFINE_BYTECODE_HANDLER(make_arg_ref) { GenMakeRefOp(opcode); }
DEFINE_BYTECODE_HANDLER(make_var_ref_ref) { GenMakeRefOp(opcode); }

DEFINE_BYTECODE_HANDLER(make_var_ref) {
  // atom = get_u32(pc);
  // pc += 4;
  // if (JS_GetGlobalVarRef(ctx, atom, sp)) goto exception;
  // sp += 2;
  auto atom = Fetch_32(0);
  auto sp = GetSp();
  auto desc = son::node::CallDescriptors::JS_GetGlobalVarRef_GC();
  auto ret_Val = CallIntRetRuntime(desc, GetCtx(), atom, sp);
  IncSp(2);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(for_in_start) {
  auto desc = son::node::CallDescriptors::prim_js_for_in_start_gc();
  auto obj = LoadTop0();
  auto ret_Val = CallRuntimeArg1(desc, GetCtx(), obj);
  StoreTop0(ret_Val);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(for_of_start) {
  auto desc = son::node::CallDescriptors::js_for_of_start_gc();

  // js_for_of_start(ctx, sp, FALSE)
  CallIntRetRuntime(desc, GetCtx(), GetSp(), IntValue(0));

  // sp += 1;
  // *sp++ = LEPUS_NewCatchOffset(ctx, 0);
  IncSp(1);
  PushSp(NewCatchOffset(Int64Value(0)));
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(for_await_of_start) {
  auto desc = son::node::CallDescriptors::js_for_of_start_gc();
  // js_for_of_start(ctx, sp, TRUE)
  CallIntRetRuntime(desc, GetCtx(), GetSp(), IntValue(1));

  // sp += 1;
  // *sp++ = LEPUS_NewCatchOffset(ctx, 0);
  IncSp(1);
  PushSp(NewCatchOffset(Int64Value(0)));
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(for_in_next) {
  auto desc = son::node::CallDescriptors::js_for_in_next_gc();

  auto ret_Val = CallIntRetRuntime(desc, GetCtx(), GetSp());
  // sp += 2;
  IncSp(2);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(for_of_next) {
  auto desc = son::node::CallDescriptors::js_for_of_next_gc();

  auto offset = Int32Sub(IntValue(-3), Fetch_8(0));

  auto ret_Val = CallIntRetRuntime(desc, GetCtx(), GetSp(), offset);
  // sp += 2;
  IncSp(2);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(for_await_of_next) {
  auto desc = son::node::CallDescriptors::js_for_await_of_next_gc();

  auto ret_Val = CallIntRetRuntime(desc, GetCtx(), GetSp());
  // sp += 1;
  IncSp(1);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(iterator_get_value_done) {
  // if (js_iterator_get_value_done(ctx, sp)) goto exception;
  // sp += 1;
  auto desc = son::node::CallDescriptors::js_iterator_get_value_done_gc();
  CallIntRetRuntime(desc, GetCtx(), GetSp());
  IncSp(1);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(iterator_close) {
  // sp--; /* drop the catch offset to avoid getting caught by exception
  //              */
  // LEPUS_FreeValue(ctx, sp[-1]); /* drop the next method */
  // sp--;
  // if (!LEPUS_IsUndefined(sp[-1])) {
  //   if (JS_IteratorClose(ctx, sp[-1], FALSE)) goto exception;
  //   LEPUS_FreeValue(ctx, sp[-1]);
  // }
  // sp--;
  son::node::Label done(this);
  auto val = LoadSp(-3);
  DecSp(2);
  auto cond = Equal(val, LepusUndefined());
  BranchIf(cond, &done);
  {
    auto desc = son::node::CallDescriptors::JS_IteratorClose();
    CallIntRetRuntime(desc, GetCtx(), val, IntValue(0));
    Jump(&done);
  }
  Bind(&done);
  DecSp(1);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(iterator_close_return) {
  // ret_val = *--sp;
  // while (sp > stack_buf && !LEPUS_VALUE_IS_CATCH_OFFSET(sp[-1])) {
  //   LEPUS_FreeValue(ctx, *--sp);
  // }
  auto ctx = GetCtx();
  auto ret_val = LoadTop0();
  DecSp();
  auto var_buf = RestoreVarBuf();
  auto b = RestoreFunctionBytecode();
  auto var_count = ZExtToInt32(LoadVarCount(b));

  auto offset =
      IntPtrMul(ZExtInt32ToIntPtr(var_count), IntPtrValue(sizeof(LEPUSValue)));
  auto stack_buf = CastToRaw(IntPtrAdd(var_buf, offset));

  son::node::Label loop(this, true);
  son::node::Label done(this);
  son::node::Label throw_e(this);
  auto sp = GetSp();
  son::node::Variable var_sp(this, son::node::NodeType::RawType(), sp);

  BindLoop(&loop, 2);
  {
    auto cond = GreaterThan(*var_sp, stack_buf);
    BranchIfFalse(cond, &done);
    auto val = LoadSp(*var_sp, -1);
    cond = IsCatchOffset(val);
    BranchIf(cond, &done);

    var_sp = DecSp(*var_sp, 1);
    Jump(&loop);
  }
  Bind(&done);

  auto new_sp = *var_sp;
  SetNewSp(new_sp);
  // if (unlikely(sp < stack_buf + 3)) {
  //   LEPUS_ThrowInternalError(ctx, "iterator_close_return");
  //   LEPUS_FreeValue(ctx, ret_val);
  //   goto exception;
  // }
  auto offset1 = IntPtrValue(3 * lepus_value_size());
  stack_buf = CastToRaw(IntPtrAdd(stack_buf, offset1));
  auto cond = LessThan(new_sp, stack_buf);
  BranchIf(cond, &throw_e, son::node::BranchHint::kFalse);

  // sp[0] = sp[-1];
  // sp[-1] = sp[-2];
  // sp[-2] = sp[-3];
  // sp[-3] = ret_val;
  // sp++;
  IncSp();
  StoreTop0(LoadSpImpl(-2));
  StoreTop1(LoadSp(-3));
  StoreSp(-3, LoadSp(-4));
  StoreSp(-4, ret_val);

  Dispatch(opcode);

  Bind(&throw_e);
  {
    auto message = Message("iterator_close_return");
    auto desc = son::node::CallDescriptors::LEPUS_ThrowInternalError();
    CallJumpException(desc, ctx, message);
  }
}

DEFINE_BYTECODE_HANDLER(async_iterator_close) {
  auto desc = son::node::CallDescriptors::prim_js_async_iterator_close_gc();
  CallIntRetRuntime(desc, GetCtx(), GetSp());
  DecSp(1);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(async_iterator_next) {
  // ret = JS_Call_RC(ctx, sp[-3], sp[-4], 1, (LEPUSValueConst *)(sp - 1));
  // if (LEPUS_IsException(ret)) goto exception;
  // LEPUS_FreeValue(ctx, sp[-1]);
  // sp[-1] = ret;
  auto func_obj = LoadSp(-3);
  auto this_obj = LoadSp(-4);
  auto desc = son::node::CallDescriptors::JS_Call_GC();
  auto argv = LeapSp(IntValue(1));
  auto ret = CallRuntime(desc, GetCtx(), func_obj, this_obj, IntValue(1), argv);
  StoreTop0(ret);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(async_iterator_get) {
  auto flags = Fetch_8(0);
  auto desc = son::node::CallDescriptors::prim_js_async_iterator_get_gc();
  CallIntRetRuntime(desc, GetCtx(), GetSp(), flags);
  IncSp(1);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(return_async) { GenDoneGenerator(opcode); }

DEFINE_BYTECODE_HANDLER(initial_yield) { GenDoneGenerator(opcode); }

DEFINE_BYTECODE_HANDLER(yield) { GenDoneGenerator(opcode); }

DEFINE_BYTECODE_HANDLER(yield_star) { GenDoneGenerator(opcode); }

DEFINE_BYTECODE_HANDLER(async_yield_star) { GenDoneGenerator(opcode); }

DEFINE_BYTECODE_HANDLER(await) { GenDoneGenerator(opcode); }

DEFINE_BYTECODE_HANDLER(neg) { GenUnaryArithOp(opcode); }

DEFINE_BYTECODE_HANDLER(plus) { GenPlusOp(opcode); }

DEFINE_BYTECODE_HANDLER(dec) {
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
  GenUnaryArithOp(opcode);
}

DEFINE_BYTECODE_HANDLER(inc) {
  // LEPUSValue op1;
  // int val;
  // op1 = sp[-1];
  // if (LEPUS_VALUE_IS_INT(op1)) {
  //   val = LEPUS_VALUE_GET_INT(op1);
  //   if (unlikely(val == INT32_MAX)) goto inc_slow;
  //   sp[-1] = LEPUS_NewInt32(ctx, val + 1);
  // } else {
  // inc_slow:
  //   sp[-1] = prim_js_unary_arith_slow_gc(ctx, op1, OP_inc);
  //   if (unlikely(LEPUS_IsException(sp[-1]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  // }
  GenUnaryArithOp(opcode);
}

DEFINE_BYTECODE_HANDLER(post_dec) {
  // if (js_post_inc_slow_gc(ctx, sp, static_cast<OPCodeEnum>(OP_post_dec))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // sp++;
  GenPostInc(opcode);
}

DEFINE_BYTECODE_HANDLER(post_inc) {
  // if (js_post_inc_slow_gc(ctx, sp, static_cast<OPCodeEnum>(OP_post_inc))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // sp++;
  GenPostInc(opcode);
}

DEFINE_BYTECODE_HANDLER(dec_loc) {
  // LEPUSValue op1;
  // int val;
  // int idx;
  // idx = *pc;
  // pc += 1;

  // auto var_buf = sf->var_buf;
  // op1 = var_buf[idx];
  // if (LEPUS_VALUE_IS_INT(op1)) {
  //   val = LEPUS_VALUE_GET_INT(op1);
  //   if (unlikely(val == INT32_MIN)) goto dec_loc_slow;
  //   var_buf[idx] = LEPUS_NewInt32(ctx, val - 1);
  // } else {
  // dec_loc_slow:
  //   /* must duplicate otherwise the variable value may
  //     be destroyed before JS code accesses it */
  //   op1 = prim_js_unary_arith_slow_gc(ctx, op1, OP_dec);
  //   if (unlikely(LEPUS_IsException(op1))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   var_buf[idx] = op1;
  // }
  GenUnaryArithOp(opcode);
}

DEFINE_BYTECODE_HANDLER(inc_loc) {
  // LEPUSValue op1;
  // int val;
  // int idx;
  // idx = *pc;
  // pc += 1;

  // auto var_buf = sf->var_buf;
  // op1 = var_buf[idx];
  // if (LEPUS_VALUE_IS_INT(op1)) {
  //   val = LEPUS_VALUE_GET_INT(op1);
  //   if (unlikely(val == INT32_MAX)) goto inc_loc_slow;
  //   var_buf[idx] = LEPUS_NewInt32(ctx, val + 1);
  // } else {
  // inc_loc_slow:
  //   /* must duplicate otherwise the variable value may
  //     be destroyed before JS code accesses it */
  //   op1 = prim_js_unary_arith_slow_gc(ctx, op1, OP_inc);
  //   if (unlikely(LEPUS_IsException(op1))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   var_buf[idx] = op1;
  // }
  GenUnaryArithOp(opcode);
}

DEFINE_BYTECODE_HANDLER(add_loc) { GenBinaryArithOp(opcode); }

DEFINE_BYTECODE_HANDLER(not ) {
  // LEPUSValue op1;
  // op1 = sp[-1];
  // if (LEPUS_VALUE_IS_INT(op1)) {
  //   sp[-1] = LEPUS_NewInt32(ctx, ~LEPUS_VALUE_GET_INT(op1));
  // } else {
  //   sp[-1] = prim_js_not_slow_gc(ctx, op1);
  //   if (unlikely(LEPUS_IsException(sp[-1]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  // }
  GenNotOp(opcode);
}
DEFINE_BYTECODE_HANDLER(lnot) {
  // int res;
  // LEPUSValue op1;

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
  GenLNotOp(opcode);
}

DEFINE_BYTECODE_HANDLER(typeof) {
  // op1 = sp[-1];
  // atom = js_operator_typeof(ctx, op1);
  // LEPUS_FreeValue(ctx, op1);
  // sp[-1] = LEPUS_AtomToString(ctx, atom);
  auto op1 = LoadTop0();
  auto desc = son::node::CallDescriptors::js_operator_typeof_gc();
  auto atom = CallRuntimeNoThrow(desc, GetCtx(), op1);

  auto desc1 = son::node::CallDescriptors::__JS_AtomToValue_GC();
  // __JS_AtomToValue(ctx, atom, TRUE);
  auto ret_value = CallRuntime(desc1, GetCtx(), atom, IntValue(1));
  StoreTop0(ret_value);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(delete) { GenCallBinaryOperator(opcode); }

DEFINE_BYTECODE_HANDLER(delete_var) {
  // atom = get_u32(pc);
  // pc += 4;
  // ret = LEPUS_DeleteProperty(ctx, ctx->global_obj, atom, 0);
  // if (unlikely(ret < 0)) goto exception;
  // *sp++ = LEPUS_NewBool(ctx, ret);

  auto atom = Fetch_32(0);
  auto global = GetGlobal();
  auto desc = son::node::CallDescriptors::JS_DeleteProperty_GC();
  auto res = CallIntRetRuntime(desc, GetCtx(), global, atom, IntValue(0));
  auto cond = NotEqual(res, IntValue(0));
  PushSp(NewBoolean(cond));
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(mul) {
  // LEPUSValue op1, op2;
  // double d;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   int32_t v1, v2;
  //   int64_t r;
  //   v1 = LEPUS_VALUE_GET_INT(op1);
  //   v2 = LEPUS_VALUE_GET_INT(op2);
  //   r = (int64_t)v1 * v2;
  //   if (unlikely((int)r != r)) {
  //     d = (double)r;
  //     sp[-2] = __JS_NewFloat64(ctx, d);
  //     sp--;
  //   } else {
  //     /* need to test zero case for -0 result */
  //     if (unlikely(r == 0 && (v1 | v2) < 0)) {
  //       d = -0.0;
  //       sp[-2] = __JS_NewFloat64(ctx, d);
  //       sp--;
  //     } else {
  //       sp[-2] = LEPUS_NewInt32(ctx, r);
  //       sp--;
  //     }
  //   }
  // } else if (LEPUS_VALUE_IS_BOTH_FLOAT(op1, op2)) {
  //   d = LEPUS_VALUE_GET_FLOAT64(op1) * LEPUS_VALUE_GET_FLOAT64(op2);
  //   sp[-2] = __JS_NewFloat64(ctx, d);
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_binary_arith_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_mul)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenBinaryArithOp(opcode);
}

DEFINE_BYTECODE_HANDLER(div) {
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
  GenBinaryArithOp(opcode);
}

DEFINE_BYTECODE_HANDLER(mod) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   int v1, v2, r;
  //   v1 = LEPUS_VALUE_GET_INT(op1);
  //   v2 = LEPUS_VALUE_GET_INT(op2);
  //   /* We must avoid v2 = 0, v1 = INT32_MIN and v2 =
  //       -1 and the cases where the result is -0. */
  //   if (unlikely(v1 < 0 || v2 <= 0))  {
  //     sp[-2] = prim_js_binary_arith_slow_gc(ctx, op1, op2,
  //     static_cast<OPCodeEnum>(OP_mod)); if
  //     (unlikely(LEPUS_IsException(sp[-2]))) {
  //       TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //     }
  //   } else {
  //     r = v1 % v2;
  //     sp[-2] = LEPUS_NewInt32(ctx, (int32_t)r);
  //     sp--;
  //   }
  // } else {
  //   sp[-2] = prim_js_binary_arith_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_mod)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  // }
  GenBinaryArithOp(opcode);
}

DEFINE_BYTECODE_HANDLER(add) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   int64_t r;
  //   r = (int64_t)LEPUS_VALUE_GET_INT(op1) + LEPUS_VALUE_GET_INT(op2);
  //   if (unlikely((int)r != r)) goto add_slow;
  //     sp[-2] = LEPUS_NewInt32(ctx, r);
  //     sp--;
  // } else if (LEPUS_VALUE_IS_BOTH_FLOAT(op1, op2)) {
  //     sp[-2] = __JS_NewFloat64(
  //         ctx, LEPUS_VALUE_GET_FLOAT64(op1) + LEPUS_VALUE_GET_FLOAT64(op2));
  //     sp--;
  // } else {
  //   add_slow:
  //     sp[-2] = prim_js_add_slow_gc(ctx, op1, op2);
  //     if (unlikely(LEPUS_IsException(sp[-2]))) {
  //       TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //     }
  //     sp--;
  // }
  GenBinaryArithOp(opcode);
}

DEFINE_BYTECODE_HANDLER(sub) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   int64_t r;
  //   r = (int64_t)LEPUS_VALUE_GET_INT(op1) - LEPUS_VALUE_GET_INT(op2);
  //   if (unlikely((int)r != r)) goto binary_arith_slow;
  //   sp[-2] = LEPUS_NewInt32(ctx, r);
  //   sp--;
  // } else if (LEPUS_VALUE_IS_BOTH_FLOAT(op1, op2)) {
  //   sp[-2] = __JS_NewFloat64(
  //   ctx, LEPUS_VALUE_GET_FLOAT64(op1) - LEPUS_VALUE_GET_FLOAT64(op2));
  //   sp--;
  // } else {
  // binary_arith_slow:
  //   sp[-2] = prim_js_binary_arith_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_sub)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenBinaryArithOp(opcode);
}

DEFINE_BYTECODE_HANDLER(pow) {
  auto ctx = GetCtx();
  // op1 = sp[-2];
  // op2 = sp[-1];
  auto op1 = LoadTop1();
  auto op2 = LoadTop0();

  auto desc = son::node::CallDescriptors::prim_js_binary_arith_slow_gc();
  auto res = CallRuntime(desc, ctx, op1, op2, Int8Value((uint8_t)opcode));
  DecSp();
  StoreTop0(res);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(shl) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   uint32_t v1, v2;
  //   v1 = LEPUS_VALUE_GET_INT(op1);
  //   v2 = LEPUS_VALUE_GET_INT(op2);
  //   v2 &= 0x1f;
  //   sp[-2] = LEPUS_NewInt32(ctx, v1 << v2);
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_binary_logic_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_shl)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenBinaryLogicOp(opcode);
}

DEFINE_BYTECODE_HANDLER(sar) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   uint32_t v2;
  //   v2 = LEPUS_VALUE_GET_INT(op2);
  //   v2 &= 0x1f;
  //   sp[-2] = LEPUS_NewInt32(ctx, (int)LEPUS_VALUE_GET_INT(op1) >> v2);
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_binary_logic_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_sar)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenBinaryLogicOp(opcode);
}

DEFINE_BYTECODE_HANDLER(shr) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   uint32_t v2;
  //   v2 = LEPUS_VALUE_GET_INT(op2);
  //   /* v1 >>> v2 retains its LEPUS semantics if CONFIG_BIGNUM */
  //   v2 &= 0x1f;
  //   uint32_t val = (uint32_t)LEPUS_VALUE_GET_INT(op1) >> v2;
  //   if (val <= 0x7fffffff) {
  //     sp[-2] = LEPUS_MKVAL(LEPUS_TAG_INT, static_cast<int32_t>(val));
  //   } else {
  //     sp[-2] = __JS_NewFloat64(ctx, val);
  //   }
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_binary_logic_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_sar)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenBinaryLogicOp(opcode);
}

DEFINE_BYTECODE_HANDLER(instanceof) { GenCallBinaryOperator(opcode); }

DEFINE_BYTECODE_HANDLER(in) { GenCallBinaryOperator(opcode); }

DEFINE_BYTECODE_HANDLER(lt) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewBool(
  //       ctx, LEPUS_VALUE_GET_INT(op1) < LEPUS_VALUE_GET_INT(op2));
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_relation_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_lt)); if (unlikely(LEPUS_IsException(sp[-2])))
  //   {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenCompareOp(opcode);
}

DEFINE_BYTECODE_HANDLER(lte) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewBool(
  //       ctx, LEPUS_VALUE_GET_INT(op1) <= LEPUS_VALUE_GET_INT(op2));
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_relation_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_lte)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenCompareOp(opcode);
}

DEFINE_BYTECODE_HANDLER(gt) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewBool(
  //       ctx, LEPUS_VALUE_GET_INT(op1) > LEPUS_VALUE_GET_INT(op2));
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_relation_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_gt)); if (unlikely(LEPUS_IsException(sp[-2])))
  //   {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenCompareOp(opcode);
}

DEFINE_BYTECODE_HANDLER(gte) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewBool(
  //       ctx, LEPUS_VALUE_GET_INT(op1) >= LEPUS_VALUE_GET_INT(op2));
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_relation_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_gte)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenCompareOp(opcode);
}

DEFINE_BYTECODE_HANDLER(eq) {
  // LEPUSValue op1, op2;
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
  GenCompareOp(opcode);
}

DEFINE_BYTECODE_HANDLER(neq) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewBool(
  //       ctx, LEPUS_VALUE_GET_INT(op1) != LEPUS_VALUE_GET_INT(op2));
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_eq_slow_gc(ctx, op1, op2, 1);
  //   if (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenCompareOp(opcode);
}
DEFINE_BYTECODE_HANDLER(strict_eq) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewBool(
  //       ctx, LEPUS_VALUE_GET_INT(op1) == LEPUS_VALUE_GET_INT(op2));
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_strict_eq_slow_gc(ctx, op1, op2, 0);
  //   if (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenCompareOp(opcode);
}
DEFINE_BYTECODE_HANDLER(strict_neq) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewBool(
  //       ctx, LEPUS_VALUE_GET_INT(op1) != LEPUS_VALUE_GET_INT(op2));
  //   sp--;
  // } else {
  //   sp[-2] = prim_js_strict_eq_slow_gc(ctx, op1, op2, 1);
  //   if (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenCompareOp(opcode);
}

DEFINE_BYTECODE_HANDLER(and) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewInt32(ctx, LEPUS_VALUE_GET_INT(op1) &
  //   LEPUS_VALUE_GET_INT(op2)); sp--;
  // } else {
  //   sp[-2] = prim_js_binary_logic_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_and)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenBinaryLogicOp(opcode);
}

DEFINE_BYTECODE_HANDLER(xor) {
  // LEPUSValue op1, op2;
  // op1 = sp[-2];
  // op2 = sp[-1];
  // if (likely(LEPUS_VALUE_IS_BOTH_INT(op1, op2))) {
  //   sp[-2] = LEPUS_NewInt32(ctx, LEPUS_VALUE_GET_INT(op1) ^
  //   LEPUS_VALUE_GET_INT(op2)); sp--;
  // } else {
  //   sp[-2] = prim_js_binary_logic_slow_gc(ctx, op1, op2,
  //   static_cast<OPCodeEnum>(OP_xor)); if
  //   (unlikely(LEPUS_IsException(sp[-2]))) {
  //     TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  //   }
  //   sp--;
  // }
  GenBinaryLogicOp(opcode);
}

DEFINE_BYTECODE_HANDLER(or) {
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
  GenBinaryLogicOp(opcode);
}

DEFINE_BYTECODE_HANDLER(push_minus1) {
  // *sp++ = LEPUS_NewInt32(ctx, -1);
  auto val = AccessBuilder::JS_NewInt32(-1);
  GenPushOp(Int64Value(val), opcode);
}

DEFINE_BYTECODE_HANDLER(push_0) {
  // *sp++ = LEPUS_NewInt32(ctx, 0);
  auto val = AccessBuilder::JS_NewInt32(0);
  GenPushOp(Int64Value(val), opcode);
}
DEFINE_BYTECODE_HANDLER(push_1) {
  // *sp++ = LEPUS_NewInt32(ctx, 1);
  auto val = AccessBuilder::JS_NewInt32(1);
  GenPushOp(Int64Value(val), opcode);
}
DEFINE_BYTECODE_HANDLER(push_2) {
  // *sp++ = LEPUS_NewInt32(ctx, 2);
  auto val = AccessBuilder::JS_NewInt32(2);
  GenPushOp(Int64Value(val), opcode);
}
DEFINE_BYTECODE_HANDLER(push_3) {
  // *sp++ = LEPUS_NewInt32(ctx, 3);
  auto val = AccessBuilder::JS_NewInt32(3);
  GenPushOp(Int64Value(val), opcode);
}
DEFINE_BYTECODE_HANDLER(push_4) {
  // *sp++ = LEPUS_NewInt32(ctx, 4);
  auto val = AccessBuilder::JS_NewInt32(4);
  GenPushOp(Int64Value(val), opcode);
}
DEFINE_BYTECODE_HANDLER(push_5) {
  // *sp++ = LEPUS_NewInt32(ctx, 5);
  auto val = AccessBuilder::JS_NewInt32(5);
  GenPushOp(Int64Value(val), opcode);
}
DEFINE_BYTECODE_HANDLER(push_6) {
  // *sp++ = LEPUS_NewInt32(ctx, 6);
  auto val = AccessBuilder::JS_NewInt32(6);
  GenPushOp(Int64Value(val), opcode);
}
DEFINE_BYTECODE_HANDLER(push_7) {
  // *sp++ = LEPUS_NewInt32(ctx, 7);
  auto val = AccessBuilder::JS_NewInt32(7);
  GenPushOp(Int64Value(val), opcode);
}

DEFINE_BYTECODE_HANDLER(push_i8) {
  // *sp++ = LEPUS_NewInt32(ctx, get_i8(pc));
  // pc += 1;
  auto val = Fetch_S8(0);
  val = ZExtToInt64(val);
  val = Int64And(val, Int64Value(0xFFFFFFFF));
  val = TruncInt64ToInt32(val);
  GenPushOp(NewInt32(val), opcode);
}

DEFINE_BYTECODE_HANDLER(push_i16) {
  // *sp++ = LEPUS_NewInt32(ctx, get_i16(pc));
  // pc += 2;
  auto val = Fetch_S16(0);
  val = ZExtToInt64(val);
  val = Int64And(val, Int64Value(0xFFFFFFFF));
  val = TruncInt64ToInt32(val);
  GenPushOp(NewInt32(val), opcode);
}

DEFINE_BYTECODE_HANDLER(push_const8) { GenPushConst(opcode); }

DEFINE_BYTECODE_HANDLER(fclosure8) { GenFclosure(opcode); }

DEFINE_BYTECODE_HANDLER(push_empty_string) {
  // *sp++ = LEPUS_AtomToString(ctx, JS_ATOM_empty_string);
  auto desc = son::node::CallDescriptors::__JS_AtomToValue_GC();
  auto atom = IntValue(JS_ATOM_empty_string);
  auto ctx = GetCtx();
  auto ret_val = CallRuntimeArg2(desc, ctx, atom, IntValue(1));
  PushSp(ret_val);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(get_loc8) {
  // *sp++ = sf->var_buf[*pc++];
  GenGetVarBuf(opcode, -1);
}

DEFINE_BYTECODE_HANDLER(put_loc8) {
  // sf->var_buf[*pc++] = *--sp;
  GenSetVarBuf(opcode, -1, true);
}

DEFINE_BYTECODE_HANDLER(set_loc8) {
  // sf->var_buf[*pc++] = sp[-1];
  GenSetVarBuf(opcode, -1, false);
}

DEFINE_BYTECODE_HANDLER(get_loc0) {
  // *sp++ = sf->var_buf[0];
  GenGetVarBuf(opcode, 0);
}

DEFINE_BYTECODE_HANDLER(get_loc1) {
  // *sp++ = sf->var_buf[1];
  GenGetVarBuf(opcode, 1);
}

DEFINE_BYTECODE_HANDLER(get_loc2) {
  // *sp++ = sf->var_buf[2];
  GenGetVarBuf(opcode, 2);
}

DEFINE_BYTECODE_HANDLER(get_loc3) {
  // *sp++ = sf->var_buf[3];
  GenGetVarBuf(opcode, 3);
}

DEFINE_BYTECODE_HANDLER(put_loc0) {
  // sf->var_buf[0] = *--sp;
  GenSetVarBuf(opcode, 0, true);
}
DEFINE_BYTECODE_HANDLER(put_loc1) {
  // sf->var_buf[1] = *--sp;
  GenSetVarBuf(opcode, 1, true);
}

DEFINE_BYTECODE_HANDLER(put_loc2) {
  // sf->var_buf[2] = *--sp;
  GenSetVarBuf(opcode, 2, true);
}
DEFINE_BYTECODE_HANDLER(put_loc3) {
  // sf->var_buf[3] = *--sp;
  GenSetVarBuf(opcode, 3, true);
}

DEFINE_BYTECODE_HANDLER(set_loc0) {
  // sf->var_buf[0] = sp[-1];
  GenSetVarBuf(opcode, 0, false);
}
DEFINE_BYTECODE_HANDLER(set_loc1) {
  // sf->var_buf[1] = sp[-1];
  GenSetVarBuf(opcode, 1, false);
}
DEFINE_BYTECODE_HANDLER(set_loc2) {
  // sf->var_buf[2] = sp[-1];
  GenSetVarBuf(opcode, 2, false);
}
DEFINE_BYTECODE_HANDLER(set_loc3) {
  // sf->var_buf[3] = sp[-1];
  GenSetVarBuf(opcode, 3, false);
}

DEFINE_BYTECODE_HANDLER(get_arg0) {
  // *sp++ = sf->arg_buf[0];
  GenGetArgBuf(opcode, 0);
}
DEFINE_BYTECODE_HANDLER(get_arg1) {
  // *sp++ = sf->arg_buf[1];
  GenGetArgBuf(opcode, 1);
}
DEFINE_BYTECODE_HANDLER(get_arg2) {
  // *sp++ = sf->arg_buf[2];
  GenGetArgBuf(opcode, 2);
}

DEFINE_BYTECODE_HANDLER(get_arg3) {
  // *sp++ = sf->arg_buf[3];
  GenGetArgBuf(opcode, 3);
}

DEFINE_BYTECODE_HANDLER(put_arg0) {
  // sf->arg_buf[0] = *--sp;
  GenSetArgBuf(opcode, 0, true);
}
DEFINE_BYTECODE_HANDLER(put_arg1) {
  // sf->arg_buf[1] = *--sp;
  GenSetArgBuf(opcode, 1, true);
}
DEFINE_BYTECODE_HANDLER(put_arg2) {
  // sf->arg_buf[2] = *--sp;
  GenSetArgBuf(opcode, 2, true);
}
DEFINE_BYTECODE_HANDLER(put_arg3) {
  // sf->arg_buf[3] = *--sp;
  GenSetArgBuf(opcode, 3, true);
}

DEFINE_BYTECODE_HANDLER(set_arg0) {
  // sf->arg_buf[0] = sp[-1];
  GenSetArgBuf(opcode, 0, false);
}
DEFINE_BYTECODE_HANDLER(set_arg1) {
  // sf->arg_buf[1] = sp[-1];
  GenSetArgBuf(opcode, 1, false);
}
DEFINE_BYTECODE_HANDLER(set_arg2) {
  // sf->arg_buf[2] = sp[-1];
  GenSetArgBuf(opcode, 2, false);
}
DEFINE_BYTECODE_HANDLER(set_arg3) {
  // sf->arg_buf[3] = sp[-1];
  GenSetArgBuf(opcode, 3, false);
}

DEFINE_BYTECODE_HANDLER(get_var_ref0) {
  // *sp++ = *sf->var_refs_cache[0]->pvalue;
  GenGetVarRefs(opcode, 0);
}

DEFINE_BYTECODE_HANDLER(get_var_ref1) {
  // *sp++ = *sf->var_refs_cache[1]->pvalue;
  GenGetVarRefs(opcode, 1);
}

DEFINE_BYTECODE_HANDLER(get_var_ref2) {
  // *sp++ = *sf->var_refs_cache[2]->pvalue;
  GenGetVarRefs(opcode, 2);
}
DEFINE_BYTECODE_HANDLER(get_var_ref3) {
  // *sp++ = *sf->var_refs_cache[3]->pvalue;
  GenGetVarRefs(opcode, 3);
}

DEFINE_BYTECODE_HANDLER(put_var_ref0) {
  // *sf->var_refs_cache[0]->pvalue = *--sp;
  GenSetVarRefs(opcode, 0, true);
}
DEFINE_BYTECODE_HANDLER(put_var_ref1) {
  // *sf->var_refs_cache[1]->pvalue = *--sp;
  GenSetVarRefs(opcode, 1, true);
}
DEFINE_BYTECODE_HANDLER(put_var_ref2) {
  // *sf->var_refs_cache[2]->pvalue = *--sp;
  GenSetVarRefs(opcode, 2, true);
}
DEFINE_BYTECODE_HANDLER(put_var_ref3) {
  // *sf->var_refs_cache[3]->pvalue = *--sp;
  GenSetVarRefs(opcode, 3, true);
}

DEFINE_BYTECODE_HANDLER(set_var_ref0) {
  // *sf->var_refs_cache[0]->pvalue = sp[-1];
  GenSetVarRefs(opcode, 0, false);
}
DEFINE_BYTECODE_HANDLER(set_var_ref1) {
  // *sf->var_refs_cache[1]->pvalue = sp[-1];
  GenSetVarRefs(opcode, 1, false);
}
DEFINE_BYTECODE_HANDLER(set_var_ref2) {
  // *sf->var_refs_cache[2]->pvalue = sp[-1];
  GenSetVarRefs(opcode, 2, false);
}
DEFINE_BYTECODE_HANDLER(set_var_ref3) {
  // *sf->var_refs_cache[3]->pvalue = sp[-1];
  GenSetVarRefs(opcode, 3, false);
}

DEFINE_BYTECODE_HANDLER(get_length) { GenGetField(opcode); }

DEFINE_BYTECODE_HANDLER(if_true8) { GenIfBranch(PrimjsOpcode::OP_if_true8); }

DEFINE_BYTECODE_HANDLER(if_false8) { GenIfBranch(PrimjsOpcode::OP_if_false8); }

DEFINE_BYTECODE_HANDLER(goto8) {
  // pc += (int8_t)pc[0];
  auto imm = Fetch_S8(0);
  auto offset = SExtInt32ToIntPtr(imm);
  DispatchJmp(offset);
}

DEFINE_BYTECODE_HANDLER(goto16) {
  // pc += (int16_t)get_u16(pc);
  auto imm = Fetch_S16(0);
  auto offset = SExtInt32ToIntPtr(imm);
  DispatchJmp(offset);
}

DEFINE_BYTECODE_HANDLER(is_undefined) {
  // if (LEPUS_VALUE_IS_UNDEFINED(sp[-1])) {
  //   sp[-1] = LEPUS_TRUE;
  // } else {
  //   sp[-1] = LEPUS_FALSE;
  // }
  son::node::Label is_undefined(this);
  son::node::Label not_undefined(this);
  son::node::Label done(this);

  auto op1 = LoadTop0();
  auto cond = Equal(op1, LepusUndefined());
  Branch(cond, &is_undefined, &not_undefined);
  Bind(&is_undefined);
  {
    StoreTop0(LepusTrue());
    Jump(&done);
  }
  Bind(&not_undefined);
  {
    StoreTop0(LepusFalse());
    Jump(&done);
  }
  Bind(&done);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(is_null) {
  // if (LEPUS_VALUE_IS_NULL(sp[-1])) {
  //   sp[-1] = LEPUS_TRUE;
  // } else {
  //   sp[-1] = LEPUS_FALSE;
  // }
  son::node::Label is_null(this);
  son::node::Label not_null(this);
  son::node::Label done(this);

  auto op1 = LoadTop0();
  auto cond = Equal(op1, LepusNull());
  Branch(cond, &is_null, &not_null);
  Bind(&is_null);
  {
    StoreTop0(LepusTrue());
    Jump(&done);
  }
  Bind(&not_null);
  {
    StoreTop0(LepusFalse());
    Jump(&done);
  }
  Bind(&done);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(is_function) {
  // if (js_operator_typeof_gc(ctx, sp[-1]) == JS_ATOM_function) {
  //   sp[-1] = LEPUS_TRUE;
  // } else {
  //   sp[-1] = LEPUS_FALSE;
  // }
  son::node::Label is_function(this);
  son::node::Label not_function(this);
  son::node::Label done(this);

  auto op1 = LoadTop0();
  auto desc = son::node::CallDescriptors::js_operator_typeof_gc();
  auto ret_value = CallRuntimeNoThrow(desc, GetCtx(), op1);

  auto cond = Equal(ret_value, IntValue(JS_ATOM_function));
  Branch(cond, &is_function, &not_function);
  Bind(&is_function);
  {
    StoreTop0(LepusTrue());
    Jump(&done);
  }
  Bind(&not_function);
  {
    StoreTop0(LepusFalse());
    Jump(&done);
  }
  Bind(&done);
  Dispatch(opcode);
}

DEFINE_BYTECODE_HANDLER(call0) {
  // sf->caller_argc = 0;
  // auto this_obj = LEPUS_UNDEFINED.ptr;
  // TAIL_CALL return common_call_h(HANDLER_PARAM_WITH_ARG1(0, this_obj));
  GenCallOp(opcode);
}

DEFINE_BYTECODE_HANDLER(call1) {
  // sf->caller_argc = 1;
  // auto this_obj = LEPUS_UNDEFINED.ptr;
  // TAIL_CALL return common_call_h(HANDLER_PARAM_WITH_ARG1(1, this_obj));
  GenCallOp(opcode);
}

DEFINE_BYTECODE_HANDLER(call2) {
  // sf->caller_argc = 2;
  // auto this_obj = LEPUS_UNDEFINED.ptr;
  // TAIL_CALL return common_call_h(HANDLER_PARAM_WITH_ARG1(2, this_obj));
  GenCallOp(opcode);
}

DEFINE_BYTECODE_HANDLER(call3) {
  // sf->caller_argc = 3;
  // auto this_obj = LEPUS_UNDEFINED.ptr;
  // TAIL_CALL return common_call_h(HANDLER_PARAM_WITH_ARG1(3, this_obj));
  GenCallOp(opcode);
}

DEFINE_BYTECODE_HANDLER(common_call) { GenCommonCall(); }

DEFINE_BYTECODE_HANDLER(call_native) { GenCallNative(false); }

DEFINE_BYTECODE_HANDLER(call_native_entry) { GenCallNative(true); }

DEFINE_BYTECODE_HANDLER(common_call_from_entry) { GenCallFromEntry(); }

DEFINE_BYTECODE_HANDLER(common_return) {
  // auto rt = ctx->rt;
  // if (unlikely(sf->var_refs != nullptr)) {
  //   prim_close_var_refs_gc(ctx, sf);
  // }
  son::node::Label close_refs(this);
  auto var_refs = RestoreVarRefs();

  auto cond = Equal(var_refs, NullptrValue());
  BranchIfFalse(cond, &close_refs);

  auto con_mark_state = LoadConMarkState(GetCtx());
  auto cond2 = NotEqual(con_mark_state, Int8Value(0));

  auto var_refs_cache = GetVarRefsCache();
  auto cond3 = NotEqual(var_refs_cache, NullptrValue());
  BranchIf(BoolAnd(cond2, cond3), &close_refs);

  DispatchFastPath(CallBcIndex::kcommon_return_direct);

  Bind(&close_refs);
  { DispatchWithId(CallBcIndex::kSlowCloseVarRefs); }
}

DEFINE_BYTECODE_HANDLER(common_return_direct) { GenCommonReturn(); }

DEFINE_BYTECODE_HANDLER(common_call_debugger0) {
  DebuggerCallEachOp();
  DispatchPrevPc(-3);
}

DEFINE_BYTECODE_HANDLER(common_call_debugger1) {
  DebuggerCallEachOp();
  DispatchPrevPc(-2);
}

DEFINE_BYTECODE_HANDLER(common_call_debugger2) {
  DebuggerCallEachOp();
  DispatchPrevPc(-1);
}

DEFINE_BYTECODE_HANDLER(exception_spill_top0) {
  auto val0 = GetTop0();
  PushSpImpl(val0);
  DispatchWithId(CallBcIndex::kexception);
}

DEFINE_BYTECODE_HANDLER(exception_spill_top1) {
  auto val1 = GetTop1();
  PushSpImpl(val1);
  DispatchWithId(CallBcIndex::kexception);
}

DEFINE_BYTECODE_HANDLER(exception_spill_top0_top1) {
  auto val0 = GetTop0();
  auto val1 = GetTop1();
  PushSpImpl(val0);
  PushSpImpl(val1);
  DispatchWithId(CallBcIndex::kexception);
}

DEFINE_BYTECODE_HANDLER(exception) {
  auto ctx = GetCtx();
  auto rt = LoadRt(GetCtx());
  auto exception = LoadCurrentException(rt);
  auto need_backtrace = LoadExceptionNeedsBacktrace(rt);

  son::node::Label build_backtrace(this);
  son::node::Label set_next(this);

  auto cond = NotEqual(need_backtrace, IntValue(0));
  Branch(cond, &build_backtrace, &set_next);
  Bind(&build_backtrace);
  {
    auto desc = son::node::CallDescriptors::build_backtrace();
    auto fname = NullptrValue();
    auto line_num = Int64Value(0);
    auto backtrace_flags = IntValue(0);
    auto is_parse_error = Int8Value(0);
    // build_backtrace(ctx, rt->current_exception, NULL, 0, pc, 0);
    CallRuntimeNoThrow(desc, ctx, exception, fname, line_num, GetPc(),
                       backtrace_flags, is_parse_error);
    Jump(&set_next);
  }
  Bind(&set_next);

  son::node::Label c_return(this);
  son::node::Label find_catach_handler(this);

  auto desc = son::node::CallDescriptors::JS_IsUncatchableError_GC();
  auto is_uncatchable = CallRuntimeNoThrow(desc, ctx, exception);
  cond = NotEqual(is_uncatchable, IntValue(0));
  Branch(cond, &c_return, &find_catach_handler);
  Bind(&find_catach_handler);

  auto var_buf = RestoreVarBuf();
  auto func_bytecode = RestoreFunctionBytecode();
  auto var_count = ZExtToInt32(LoadVarCount(func_bytecode));

  auto offset =
      IntPtrMul(ZExtInt32ToIntPtr(var_count), IntPtrValue(sizeof(LEPUSValue)));
  auto stack_buf = CastToRaw(IntPtrAdd(var_buf, offset));
  auto sp = GetSp();
  son::node::Variable var_sp(this, son::node::NodeType::RawType(), sp);

  son::node::Label loop(this, true);
  son::node::Label pos_is_zero(this, true);
  son::node::Label pos_not_zero(this, true);

  // while (sp > stack_buf)
  BindLoop(&loop, 3);
  {
    auto cond = GreaterThan(*var_sp, stack_buf);
    BranchIfFalse(cond, &c_return);
    // LEPUSValue val = *--sp;
    auto val = LoadSp(*var_sp, -1);
    var_sp = DecSp(*var_sp, 1);
    // if (LEPUS_VALUE_IS_CATCH_OFFSET(val))
    cond = IsCatchOffset(val);
    BranchIfFalse(cond, &loop);

    auto pos = GetCatchOffset(val);
    cond = Equal(pos, Int32Value(0));
    Branch(cond, &pos_is_zero, &pos_not_zero);
    Bind(&pos_is_zero);
    {
      // sp--;
      var_sp = DecSp(*var_sp, 1);
      // JS_IteratorClose(ctx, sp[-1], TRUE);
      auto new_val = LoadSp(*var_sp, -1);
      auto desc = son::node::CallDescriptors::JS_IteratorClose();
      CallRuntimeNoThrow(desc, ctx, new_val, IntValue(1));
      Jump(&loop);
    }
    Bind(&pos_not_zero);
    {
      // *sp++ = rt->current_exception;
      auto exp = LoadCurrentException(rt);
      StoreSp(*var_sp, 0, exp);
      var_sp = IncSp(*var_sp, 1);
      // rt->current_exception = LEPUS_NULL;
      StoreCurrentException(rt, LepusNull());
      // pc = b->byte_code_buf + pos;
      auto base = LoadBytecodeBuf(func_bytecode);
      auto new_pc = IntPtrAdd(base, pos);
      SetNewSp(*var_sp);
      DispatchImpl(new_pc);
      CleanupAfterDispatch();
    }
  }
  Bind(&c_return);
  // ret_val = LEPUS_EXCEPTION;
  auto ret_val = Int64Value(LEPUS_EXCEPTION.as_int64);
  SaveRetVal(ret_val);
  DispatchFastPath(CallBcIndex::kcommon_return);
}

DEFINE_BYTECODE_HANDLER(SlowCloseVarRefs) {
  auto retVal = RestoreRetVal();
  SetVar64(HandlerVarIndex::kScratch1, retVal);
  auto ctx = GetCtx();
  auto desc = son::node::CallDescriptors::prim_close_var_refs_gc();
  CallRuntimeNoThrow(desc, ctx, GetFrame());

  auto retVal1 = GetVar64(HandlerVarIndex::kScratch1);
  SaveRetVal(retVal1);
  DispatchFastPath(CallBcIndex::kcommon_return_direct);
}

DEFINE_BYTECODE_HANDLER(SlowToBoolean) {
  auto obj = GetScratch();

  auto ctx = GetCtx();
  auto desc = son::node::CallDescriptors::JS_ToBoolFree_GC();

  auto res = CallIntRetRuntime(desc, ctx, obj);
  auto cond = NotEqual(res, IntValue(0));
  StoreTop0(NewBoolean(cond));
  DispatchPrevPc();
}

DEFINE_BYTECODE_HANDLER(SlowJSPostInc) {
  // if (js_post_inc_slow_gc(ctx, sp, static_cast<OPCodeEnum>(OP_post_inc))) {
  //   TAIL_CALL return exception_h(HANDLER_PARAM(pc));
  // }
  // sp++;
  auto opcode1 = GetScratch();

  auto ctx = GetCtx();
  auto desc = son::node::CallDescriptors::js_post_inc_slow_gc();

  auto res = CallIntRetRuntime(desc, ctx, GetSp(), TruncInt64ToInt8(opcode1));
  IncSp();
  DispatchNext();
}

DEFINE_BYTECODE_HANDLER(SlowJSNot) {
  auto op1 = GetScratch();

  auto ctx = GetCtx();
  auto desc = son::node::CallDescriptors::prim_js_not_slow_gc();

  auto res = CallRuntime(desc, ctx, op1);
  StoreTop0(res);
  DispatchNext();
}

DEFINE_BYTECODE_HANDLER(ThrowReferenceErrorUninitialized) {
  auto desc =
      son::node::CallDescriptors::JS_ThrowReferenceErrorUninitialized_GC();
  auto atom = IntValue(JS_ATOM_NULL);
  CallJumpException(desc, GetCtx(), atom);
}

DEFINE_BYTECODE_HANDLER(ThrowThisReferenceError) {
  auto message = Message("'this' can be initialized only once");
  auto desc = son::node::CallDescriptors::LEPUS_ThrowReferenceError();
  CallJumpException(desc, GetCtx(), message);
}

DEFINE_BYTECODE_HANDLER(ThrowTypeErrorNotFunction_Return) {
  auto desc = son::node::CallDescriptors::JS_ThrowTypeErrorNotFunction();
  auto lr = GetVar(HandlerVarIndex::kLr);
  SetVar(HandlerVarIndex::kScratch1, lr);
  auto ret_val = CallRuntimeNoThrow(desc, GetCtx());
  auto scratch = GetVar(HandlerVarIndex::kScratch1);
  SetVar(HandlerVarIndex::kLr, scratch);
  SaveRetVal(ret_val);
  Return();
}

DEFINE_BYTECODE_HANDLER(ThrowStackOverflow_Return) {
  auto desc = son::node::CallDescriptors::JS_ThrowStackOverflow();
  auto lr = GetVar(HandlerVarIndex::kLr);
  SetVar(HandlerVarIndex::kScratch1, lr);
  auto ret_val = CallRuntimeNoThrow(desc, GetCtx());
  auto scratch = GetVar(HandlerVarIndex::kScratch1);
  SetVar(HandlerVarIndex::kLr, scratch);
  SaveRetVal(ret_val);
  Return();
}

void InterpreterGenerator::GenerateBcHandler(son::node::NodeGraph* graph,
                                             int call_index,
                                             DispatchState dispatch_state) {
  PrimjsOpcode opcode = static_cast<PrimjsOpcode>(call_index);
  base::Zone* zone = graph->zone();
  switch (opcode) {
#define DEF_OPCODE_DESC(name)                 \
  case PrimjsOpcode::OP_##name: {             \
    name##Assembler assembler(graph, zone);   \
    assembler.set_init_state(dispatch_state); \
    assembler.Generate(opcode);               \
    break;                                    \
  }

#define FMT(f)
#define DEF(id, size, n_pop, n_push, f) DEF_OPCODE_DESC(id)
#define def(id, size, n_pop, n_push, f)
#include "interpreter/quickjs/include/quickjs-opcode.h"
#undef def
#undef DEF
#undef FMT
#undef DEF_OPCODE_DESC
    default:
      unreachable();
      break;
  }
}

void InterpreterGenerator::GenerateExtHandler(son::node::NodeGraph* graph,
                                              int call_index) {
  CallBcIndex index = static_cast<CallBcIndex>(call_index);
  base::Zone* zone = graph->zone();
  switch (index) {
#define DEF_INTERP_HANDLER(name)                  \
  case CallBcIndex::k##name: {                    \
    name##Assembler assembler(graph, zone);       \
    assembler.Generate(PrimjsOpcode::OP_invalid); \
    break;                                        \
  }
#include "primjs/interp/interp.def"
    default:
      unreachable();
      break;
  }
}

void InterpreterGenerator::Generate(son::node::NodeGraph* graph) {
  auto call_index = graph->call_descriptor().call_index();
  if (call_index < static_cast<int>(CallBcIndex::kStart)) {
    auto kind = graph->call_descriptor().kind();
    DispatchState state = DispatchState::kTable0;
    if (kind == son::node::CallKind::kBcHandler1) {
      state = DispatchState::kTable1;
    } else if (kind == son::node::CallKind::kBcHandler2) {
      state = DispatchState::kTable2;
    }
    GenerateBcHandler(graph, call_index, state);
  } else {
    GenerateExtHandler(graph, call_index);
  }
}

}  // namespace primjs
