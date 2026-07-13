/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#include "primjs/codegen/interpreterAssembler.h"

#include "primjs/codegen/bytecode.h"
#include "primjs/codegen/dispatchTable.h"
#include "primjs/son/graphAssembler.h"
#include "primjs/son/graphBuilder.h"

namespace primjs {

InterpreterAssembler::InterpreterAssembler(son::node::NodeGraph* graph,
                                           base::Zone* zone)
    : CodeAssembler(graph, zone) {
  _dispatch_table = new (zone) DispatchTable(this);
  graph->NewParameter(0, son::node::NodeType::RawType());
  graph->NewParameter(1, son::node::NodeType::RawType());
  _is_debugger = graph->options().SupportDebugger();
  _use_virtual_sp = graph->options().SupportVirtualSp();
  _multi_table = graph->options().SupportMultiTable();
  _use_fast_path = graph->options().UseFastPath();
}

void InterpreterAssembler::CheckEqual(son::node::Node* val0,
                                      son::node::Node* val1) {
  son::node::Label slow(this);
  son::node::Label done(this);

  auto cond = NotEqual(val0, val1);
  Branch(cond, &slow, &done, son::node::BranchHint::kFalse);
  Bind(&slow);
  {
    auto desc = son::node::CallDescriptors::prim_abort0();
    CallRuntimeNoThrow(desc, val0, val1);
    Jump(&done);
  }
  Bind(&done);
}

bool InterpreterAssembler::GeneratePrologue(PrimjsOpcode opcode) {
  auto current_state = _dispatch_table->current_state();
  if (IsDebugTrace()) {
    prim_debug_trace();
  }
  return _dispatch_table->GeneratePrologue(opcode);
}

void InterpreterAssembler::DispatchImpl(son::node::Node* new_pc) {
  DispatchStateScope scope(_dispatch_table);
  if (new_pc == nullptr) {
    new_pc = GetPc();
  }

  auto new_op = LoadImpl(son::node::MachineType::kInt8, new_pc);
  new_pc = IntPtrAdd(new_pc, IntPtrValue(1));
  new_pc = CastIntPtrToRaw(new_pc);
  auto new_offset = ZExtInt8ToInt32(new_op);

  auto state_offset = _dispatch_table->DoTransition();
  if (state_offset != 0) {
    auto offset = IntValue(state_offset * (int)PrimjsOpcode::kCount);
    new_offset = Int32Add(new_offset, offset);
  }

  auto dispatch_table = GetDispatchTable();
  auto desc = son::node::CallDescriptors::DefaultCallBcHandler();
  auto target =
      LoadImpl(son::node::MachineType::kIntptr, dispatch_table, new_offset);
  TailCall(desc, target, new_pc, GetSp());
  Return();
}

void InterpreterAssembler::DispatchWithId(CallBcIndex index) {
  DispatchStateScope scope(_dispatch_table);
  _dispatch_table->TransitionToTable0(false);
  auto desc =
      son::node::CallDescriptors::ExtCallBcHandler(static_cast<int>(index));
  auto target = FunctionPointer(desc);
  TailCall(desc, target, GetPc(), GetSp());
  Return();
}

void InterpreterAssembler::DispatchFastPath(CallBcIndex index) {
  auto desc =
      son::node::CallDescriptors::ExtCallBcHandler(static_cast<int>(index));
  auto target = FunctionPointer(desc);
  TailCall(desc, target, GetPc(), GetSp());
  Return();
}

void InterpreterAssembler::DispatchCallHandler(CallBcIndex index) {
  auto desc =
      son::node::CallDescriptors::CallHandlerBcHandler(static_cast<int>(index));
  auto target = FunctionPointer(desc);
  TailCall(desc, target, GetPc(), GetSp());
  Return();
}

son::node::Node* InterpreterAssembler::CallFastPath(CallBcIndex index) {
  auto desc =
      son::node::CallDescriptors::ExtCallBcHandler(static_cast<int>(index));
  auto target = FunctionPointer(desc);
  return Call(desc, target);
}

void InterpreterAssembler::DispatchException() {
  DispatchStateScope scope(_dispatch_table);
  auto index = _dispatch_table->TransitionForException();
  auto desc = son::node::CallDescriptors::ExtCallBcHandler(index);
  auto target = FunctionPointer(desc);
  TailCall(desc, target, GetPc(), GetSp());
  Return();
}

void InterpreterAssembler::DispatchWithIdArg0(CallBcIndex index,
                                              son::node::Node* arg0) {
  SetScratch(arg0);
  DispatchWithId(index);
}

void InterpreterAssembler::DispatchCommonCall(son::node::Node* arg0) {
  _dispatch_table->TransitionToTable0();
  auto index = CallBcIndex::kcommon_call;
  auto desc =
      son::node::CallDescriptors::ExtCallBcHandler(static_cast<int>(index));
  auto target = FunctionPointer(desc);
  SetVar64(HandlerVarIndex::kArgc, arg0);
  Call(desc, target, GetPc(), GetSp());
}

void InterpreterAssembler::Dispatch(PrimjsOpcode opcode) {
  auto size = get_opcode_size(opcode);
  auto pc = GetPc();

  if (size - 1 != 0) {
    auto offset = IntPtrValue(size - 1);  // -1 skip current op
    pc = IntPtrAdd(pc, offset);
    DispatchImpl(pc);
  } else {
    DispatchImpl(nullptr);
  }
}

void InterpreterAssembler::DispatchJmp(son::node::Node* offset) {
  auto pc = GetPc();
  pc = IntPtrAdd(pc, offset);
  DispatchImpl(pc);
}

void InterpreterAssembler::DispatchWithPc(son::node::Node* new_pc) {
  DispatchImpl(new_pc);
}

void InterpreterAssembler::DispatchNext() { DispatchImpl(nullptr); }

void InterpreterAssembler::DispatchPrevPc(int diff) {
  _dispatch_table->TransitionToTable0();
  auto pc = GetPc();
  son::node::Node* dispatch_table = GetDispatchTable();

  auto new_op = LoadImpl(son::node::MachineType::kInt8, pc, IntValue(-1));
  auto new_offset = ZExtInt8ToInt32(new_op);
  if (diff != 0) {
    auto offset = IntValue(diff * (int)PrimjsOpcode::kCount);
    new_offset = Int32Add(new_offset, offset);
  }

  auto desc = son::node::CallDescriptors::DefaultCallBcHandler();
  auto target =
      LoadImpl(son::node::MachineType::kIntptr, dispatch_table, new_offset);
  TailCall(desc, target, pc, GetSp());
  Return();
}

void InterpreterAssembler::CheckException(son::node::Node* value) {
  son::node::Label slow(this);
  son::node::Label done(this);

  auto cond = IsException(value);
  Branch(cond, &slow, &done, son::node::BranchHint::kFalse);
  Bind(&slow);
  { DispatchException(); }
  Bind(&done);
}

void InterpreterAssembler::JumpIfException(son::node::Node* value,
                                           son::node::Label* throw_e) {
  auto cond = IsException(value);
  BranchIf(cond, throw_e, son::node::BranchHint::kFalse);
}

void InterpreterAssembler::JumpIfUninitialized(son::node::Node* value,
                                               son::node::Label* throw_e) {
  auto cond = Equal(value, Uninitialized());
  BranchIf(cond, throw_e, son::node::BranchHint::kFalse);
}

void InterpreterAssembler::CheckIntRetException(son::node::Node* value) {
  son::node::Label slow(this);
  son::node::Label done(this);

  auto cond = LessThan(value, IntValue(0));
  Branch(cond, &slow, &done, son::node::BranchHint::kFalse);
  Bind(&slow);
  { DispatchException(); }
  Bind(&done);
}

void InterpreterAssembler::CheckAtomRetException(son::node::Node* value) {
  son::node::Label slow(this);
  son::node::Label done(this);

  auto cond = Equal(value, IntValue(JS_ATOM_NULL));
  Branch(cond, &slow, &done, son::node::BranchHint::kFalse);
  Bind(&slow);
  { DispatchException(); }
  Bind(&done);
}

void InterpreterAssembler::CheckStackOverflow(son::node::Node* sp) {
  auto ctx = GetCtx();
  son::node::Label stack_overflow(this);
  son::node::Label not_overflow(this);

  auto stack_end = CastRawToIntPtr(sp);
  son::node::Node* cond = nullptr;
  auto stack_limit = LoadJSStackLimit(ctx);
  cond = UnsignedLessThanOrEqual(stack_end, stack_limit);
  Branch(cond, &stack_overflow, &not_overflow, son::node::BranchHint::kFalse);
  Bind(&stack_overflow);
  { DispatchWithId(CallBcIndex::kThrowStackOverflow_Return); }
  Bind(&not_overflow);
}

son::node::Node* InterpreterAssembler::PushStackFrame(
    son::node::Node* alloc_size, son::node::Node** sf_end_ptr) {
  son::node::Node* rsp = nullptr;
  auto ctx = GetCtx();
  if (_use_virtual_sp) {
    rsp = LoadJSStack(ctx);
  } else {
    rsp = SaveStack();
  }

  // sf = (QuickJsFrame*)alloc_buf;
  if (!_use_virtual_sp) {
    auto aligin_mark = Int32And(alloc_size, IntValue(15));
    alloc_size = Int32Add(alloc_size, aligin_mark);
  }
  auto alloc_buf =
      IntPtrSub(CastRawToIntPtr(rsp), ZExtInt32ToIntPtr(alloc_size));
  auto sf = CastToRaw(alloc_buf);
  SetNewFrame(sf);

  CheckStackOverflow(sf);
  if (sf_end_ptr != nullptr) {
    *sf_end_ptr = rsp;
  }

  if (_use_virtual_sp) {
    StoreJSStack(ctx, alloc_buf);
  } else {
    RestoreStack(sf);
  }
  return sf;
}

void InterpreterAssembler::PopStackFrame(son::node::Node* prev_sf) {
  if (_use_virtual_sp) {
    auto ctx = GetCtx();
    StoreJSStack(ctx, prev_sf);
    return;
  }
  RestoreStack(prev_sf);
  return;
}

void InterpreterAssembler::DebuggerCallEachOp() {
  if (!_is_debugger) return;
  son::node::Label not_debugger_mode(this);

  auto debug_mode = GetIsDebuggerMode();
  BranchIfFalse(debug_mode, &not_debugger_mode);
  {
    // DebuggerCallEachOp(ctx, pc + 1, b);
    auto desc = son::node::CallDescriptors::DebuggerCallEachOp();
    auto func_obj = RestoreCurFunc();
    auto b = LoadFunctionBytecode(CastToRaw(func_obj));
    auto pc = GetPc();
    CallRuntimeNoCheck(desc, GetCtx(), pc, b);
    Jump(&not_debugger_mode);
  }
  Bind(&not_debugger_mode);
}

void InterpreterAssembler::DebuggerCallEachFunc() {
  if (!_is_debugger) return;
  son::node::Label not_debugger_mode(this);

  auto debug_mode = GetIsDebuggerMode();
  BranchIfFalse(debug_mode, &not_debugger_mode);
  {
    // DebuggerCallEachFunc(ctx, pc + 1);
    auto desc = son::node::CallDescriptors::DebuggerCallEachFunc();
    auto pc = GetPc();
    pc = IntPtrAdd(pc, IntPtrValue(1));
    CallRuntimeNoCheck(desc, GetCtx(), CastToRaw(pc));
    Jump(&not_debugger_mode);
  }
  Bind(&not_debugger_mode);
}

void InterpreterAssembler::prim_debug_trace() {
  son::node::Label done(this);
  auto desc = son::node::CallDescriptors::prim_debug_trace();
  auto target = FunctionPointer(desc);
  Call(desc, target, GetCtx(), GetDispatchTable(), GetPc(), GetSp(),
       GetFrame());
  Goto(&done);
  Bind(&done);
}

void InterpreterAssembler::call_runtime_wrapper(int index) {
  son::node::Label done(this);
  auto desc = son::node::CallDescriptors::call_runtime_wrapper();
  if (index == -1) {
    index = desc.call_index();
  }
  auto target = FunctionPointer(desc);
  Call(desc, target, GetCtx(), IntValue(index));
  Goto(&done);
  Bind(&done);
}

}  // namespace primjs
