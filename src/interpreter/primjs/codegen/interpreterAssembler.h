// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_INTERP_INTERPRETER_ASSEMBLER_H
#define PRIMJS_INTERP_INTERPRETER_ASSEMBLER_H

#include "primjs/base/globals.h"
#include "primjs/base/zone.h"
#include "primjs/codegen/codeAssembler.h"
#include "primjs/codegen/dispatchTable.h"

namespace primjs {

// const uint8_t *pc, LEPUSValue *sp, void* _arg0_
enum class HandlerArgIndex : int32_t { kPc = 0, kSp };

enum class HandlerRegister : int32_t {
#define DEF_REGISTER(name, reg, n) name = n,
#include "primjs/interp/interp.def"
};

enum class HandlerVarIndex : int32_t {
  kVarBuf = (int32_t)HandlerRegister::rVarBuf,
  kArgBuf = (int32_t)HandlerRegister::rArgBuf,
  kVarRef = (int32_t)HandlerRegister::rVarRef,
  kThisObject = (int32_t)HandlerRegister::rTop1,
  kNewTarget = (int32_t)HandlerRegister::rVarBuf,
  kFuncObj = (int32_t)HandlerRegister::rTop0,
  kArgc = (int32_t)HandlerRegister::rScratch,
  kCtx = (int32_t)HandlerRegister::rCtx,
  kDispatchTable = (int32_t)HandlerRegister::rDispatchTable,
  kPc = -1,
  kSp = -2,
  kFrame = (int32_t)HandlerRegister::rFrame,
  kScratch1 = (int32_t)HandlerRegister::rTop0,
  kScratch = (int32_t)HandlerRegister::rScratch,
  kTop0 = (int32_t)HandlerRegister::rTop0,
  kTop1 = (int32_t)HandlerRegister::rTop1,
  kLr = (int32_t)HandlerRegister::rLr,
  kFp = (int32_t)HandlerRegister::rFp,
  kRsp = (int32_t)HandlerRegister::rRsp,
  kRetVal = kScratch,
};

enum class CallBcIndex : int32_t {
#define FMT(f)
#define DEF(id, size, n_pop, n_push, f) k##id,
#define def(id, size, n_pop, n_push, f)
#include "interpreter/quickjs/include/quickjs-opcode.h"
#undef def
#undef DEF
#undef FMT
#undef DEF_OPCODE_DESC
  kBytecodeEnd = 0x100,
#define DEF_INTERP_HANDLER_RET(name) k##name,
#include "primjs/interp/interp.def"
  kAsmCount1,
#define DEF_INTERP_HANDLER_NO_RET(name) k##name,
#include "primjs/interp/interp.def"
  kAsmCount2,
  kStart = kBytecodeEnd + 1,
};

class DispatchTable;

class InterpreterAssembler : public CodeAssembler {
 protected:
  son::node::Node* _new_pc{nullptr};
  son::node::Node* _new_frame{nullptr};
  DispatchTable* _dispatch_table;
  bool _use_virtual_sp;
  bool _multi_table;
  bool _use_fast_path;

 public:
  InterpreterAssembler(son::node::NodeGraph* graph, base::Zone* zone);

  bool GeneratePrologue(PrimjsOpcode opcode);
  void GenerateEpilogue() { End(); }

  son::node::Node* GetParameter(HandlerArgIndex index) {
    return graph()->GetParameter(static_cast<int>(index));
  }
  son::node::Node* GetPc() {
    if (_new_pc != nullptr) {
      return _new_pc;
    }
    return GetVar(HandlerVarIndex::kPc);
  }
  son::node::Node* GetArgc() { return GetVar64(HandlerVarIndex::kArgc); }
  void SetScratch(son::node::Node* val) {
    SetVar64(HandlerVarIndex::kScratch, val);
  }
  son::node::Node* GetScratch() { return GetVar64(HandlerVarIndex::kScratch); }
  son::node::Node* GetThisObject() {
    return GetVar64(HandlerVarIndex::kThisObject);
  }
  son::node::Node* GetNewTarget() {
    return GetVar64(HandlerVarIndex::kNewTarget);
  }
  son::node::Node* GetFuncObj() { return GetVar64(HandlerVarIndex::kFuncObj); }
  son::node::Node* GetTop0() { return GetVar64(HandlerVarIndex::kTop0); }
  son::node::Node* GetTop1() { return GetVar64(HandlerVarIndex::kTop1); }
  void SetTop0(son::node::Node* val) { SetVar64(HandlerVarIndex::kTop0, val); }
  void SetTop1(son::node::Node* val) { SetVar64(HandlerVarIndex::kTop1, val); }

  son::node::Node* LoadTop0() { return _dispatch_table->LoadTop0(); }
  son::node::Node* LoadTop1() { return _dispatch_table->LoadTop1(); }
  void StoreTop0(son::node::Node* val) { _dispatch_table->StoreTop0(val); }
  void StoreTop1(son::node::Node* val) { _dispatch_table->StoreTop1(val); }
  void SetTop0Var(son::node::Node* val) {
    SetVar64(HandlerVarIndex::kTop0, val);
  }
  void SetTop1Var(son::node::Node* val) {
    SetVar64(HandlerVarIndex::kTop1, val);
  }
  son::node::Node* GetCpool() { return RestoreCpool(); }
  son::node::Node* GetCtx() { return GetVar(HandlerVarIndex::kCtx); }
  son::node::Node* GetDispatchTable() {
    return GetVar(HandlerVarIndex::kDispatchTable);
  }

  void CleanupAfterDispatch() {
    ClearNewSp();
    SetNewFrame(nullptr);
    SetNewPc(nullptr);
  }

  son::node::Node* get_new_sp() { return _dispatch_table->get_new_sp(); }

  son::node::Node* GetSp() {
    auto sp = get_new_sp();
    if (sp != nullptr) {
      return sp;
    }
    return GetVar(HandlerVarIndex::kSp);
  }
  son::node::Node* GetFrame() {
    if (_new_frame != nullptr) {
      return _new_frame;
    }
    return GetVar(HandlerVarIndex::kFrame);
  }
  int get_var_index(HandlerVarIndex index) { return static_cast<int>(index); }
  son::node::Node* GetVar64(HandlerVarIndex index) {
    int idx = get_var_index(index);
    vmassert(idx >= 0, "must be");
    return ReadRegister(idx);
  }
  son::node::Node* GetVar(HandlerVarIndex index) {
    int idx = get_var_index(index);
    if (idx < 0) {
      idx = -idx - 1;
      return GetParameter(HandlerArgIndex(idx));
    }
    return CastToRaw(GetVar64(index));
  }
  void SetVar64(HandlerVarIndex index, son::node::Node* val) {
    vmassert(val->type()->machine_type() == son::node::MachineType::kInt64 ||
                 val->type()->machine_type() == son::node::MachineType::kIntptr,
             "");
    int idx = get_var_index(index);
    if (idx < 0) {
      abort();
    }
    WriteRegister(static_cast<int>(index), val);
  }
  void SetVar(HandlerVarIndex index, son::node::Node* val) {
    vmassert(val->type()->machine_type() == son::node::MachineType::kRawType,
             "");
    vmassert((val->opcode() != son::node::Opcode::OP_ReadRegister) ||
                 (val->meta_value<int>() != static_cast<int>(index)),
             "must be");
    SetVar64(index, CastRawToInt64(val));
  }

  son::node::Node* Fetch(int index) {
    auto pc = GetPc();
    return LoadImpl(son::node::MachineType::kInt8, pc,
                    IntPtrValue(index * sizeof(int8_t)));
  }

  son::node::Node* Fetch_8(int index) { return ZExtInt8ToInt32(Fetch(index)); }

  son::node::Node* Fetch_8(son::node::Node* pc, int index) {
    auto value = LoadImpl(son::node::MachineType::kInt8, pc,
                          IntPtrValue(index * sizeof(int8_t)));
    return ZExtInt8ToInt32(value);
  }

  son::node::Node* Fetch_8(son::node::Node* pc, son::node::Node* index) {
    auto value = LoadImpl(son::node::MachineType::kInt8, pc, index);
    return ZExtInt8ToInt32(value);
  }

  son::node::Node* Fetch_16(int index) {
    auto pc = GetPc();
    pc = IntPtrAdd(pc, IntPtrValue(index * sizeof(int8_t)));
    auto res = LoadImpl(son::node::MachineType::kInt16, pc, IntPtrValue(0));
    return ZExtInt16ToInt32(res);
  }

  son::node::Node* Fetch_32(int index) {
    auto pc = GetPc();
    pc = IntPtrAdd(pc, IntPtrValue(index * sizeof(int8_t)));
    return LoadImpl(son::node::MachineType::kInt32, pc, IntPtrValue(0));
  }

  son::node::Node* Fetch_S8(int index) { return SExtToInt32(Fetch(index)); }

  son::node::Node* Fetch_S16(int index) {
    auto pc = GetPc();
    pc = IntPtrAdd(pc, IntPtrValue(index * sizeof(int8_t)));
    auto res = LoadImpl(son::node::MachineType::kInt16, pc, IntPtrValue(0));
    return SExtToInt32(res);
  }

  son::node::Node* Fetch_S32(int index) {
    auto pc = GetPc();
    pc = IntPtrAdd(pc, IntPtrValue(index * sizeof(int8_t)));
    auto res = LoadImpl(son::node::MachineType::kInt32, pc, IntPtrValue(0));
    return SExtToInt32(res);
  }

  son::node::Node* Fetch_S64(int index) {
    auto pc = GetPc();
    pc = IntPtrAdd(pc, IntPtrValue(index * sizeof(int8_t)));
    auto res = LoadImpl(son::node::MachineType::kInt64, pc, IntPtrValue(0));
    return SExtToInt64(res);
  }

  son::node::Node* Fetch_64(int index) {
    auto value1 = ZExtInt32ToInt64(Fetch_32(index));
    auto value2 = ZExtInt32ToInt64(Fetch_32(index + sizeof(int32_t)));
    value2 = Int64LSL(value2, Int64Value(32));
    return Int64Add(value1, value2);
  }

  void StoreSp(son::node::Node* sp, son::node::Node* index,
               son::node::Node* value) {
    Store(son::node::MachineType::kInt64, sp, index, value);
  }
  son::node::Node* LoadSp(son::node::Node* sp, son::node::Node* index) {
    return LoadImpl(son::node::MachineType::kInt64, sp, index);
  }

  son::node::Node* LeapSp(son::node::Node* sp, son::node::Node* index,
                          int size) {
    auto idx_ptr = IntPtrMul(ZExtInt32ToIntPtr(index), IntPtrValue(size));
    return CastToRaw(IntPtrSub(CastRawToIntPtr(sp), idx_ptr));
  }

  son::node::Node* LeapSp(son::node::Node* index) {
    if (_dispatch_table->support_multi_dispatch()) {
      return _dispatch_table->LeapSp(index);
    } else {
      return LeapSp(GetSp(), index, sizeof(LEPUSValue));
    }
  }

  son::node::Node* LoadSp(son::node::Node* sp, int idx) {
    auto index = IntValue(idx);
    return LoadImpl(son::node::MachineType::kInt64, sp, index);
  }

  son::node::Node* LoadSpImpl(int idx) {
    auto sp = GetSp();
    return LoadSp(sp, idx);
  }

  son::node::Node* LoadSp(int idx) {
    if (_dispatch_table->support_multi_dispatch()) {
      return _dispatch_table->LoadSp(idx);
    } else {
      return LoadSpImpl(idx);
    }
  }

  void StoreSp(son::node::Node* sp, int idx, son::node::Node* value) {
    auto index = IntValue(idx);
    return Store(son::node::MachineType::kInt64, sp, index, value);
  }

  void StoreSpImpl(int idx, son::node::Node* value) {
    vmassert(idx < 0, "must be");
    auto sp = GetSp();
    StoreSp(sp, idx, value);
  }

  void StoreSp(int idx, son::node::Node* value) {
    if (_dispatch_table->support_multi_dispatch()) {
      _dispatch_table->StoreSp(idx, value);
    } else {
      StoreSpImpl(idx, value);
    }
  }

  void PushSpImpl(son::node::Node* value) {
    IncSpImpl();
    StoreSpImpl(-1, value);
  }

  son::node::Node* PopSpImpl() {
    auto res = LoadSpImpl(-1);
    DecSp();
    return res;
  }

  void PushSp(son::node::Node* value) {
    if (_dispatch_table->support_multi_dispatch()) {
      _dispatch_table->PushSp(value);
    } else {
      PushSpImpl(value);
    }
  }

  son::node::Node* PopSp() {
    if (_dispatch_table->support_multi_dispatch()) {
      return _dispatch_table->PopSp();
    } else {
      return PopSpImpl();
    }
  }

  int lepus_value_size() { return sizeof(LEPUSValue); }

  void IncPc(int idx) {
    auto pc = GetPc();
    pc = IntPtrAdd(pc, IntValue(idx));
    _new_pc = CastIntPtrToRaw(pc);
  }

  son::node::Node* DecSp(son::node::Node* sp, int idx) {
    sp = CastRawToIntPtr(sp);
    auto index = IntPtrValue(idx * lepus_value_size());
    sp = IntPtrSub(sp, index);
    return CastIntPtrToRaw(sp);
  }

  son::node::Node* IncSp(son::node::Node* sp, int idx) {
    sp = CastRawToIntPtr(sp);
    auto index = IntPtrValue(idx * lepus_value_size());
    sp = IntPtrAdd(sp, index);
    return CastIntPtrToRaw(sp);
  }
  void WriteNewSp(son::node::Node* sp) { _dispatch_table->set_new_sp(sp); }
  void IncSpImpl(int idx = 1) {
    auto sp = IncSp(GetSp(), idx);
    WriteNewSp(sp);
  }
  void DecSpImpl(int idx = 1) {
    auto sp = DecSp(GetSp(), idx);
    WriteNewSp(sp);
  }
  void IncSp(int idx = 1) {
    if (_dispatch_table->support_multi_dispatch()) {
      _dispatch_table->IncSp(idx);
    } else {
      IncSpImpl(idx);
    }
  }
  void DecSp(int idx = 1) {
    if (_dispatch_table->support_multi_dispatch()) {
      _dispatch_table->DecSp(idx);
    } else {
      DecSpImpl(idx);
    }
  }
  void DecSp(son::node::Node* value) {
    if (_dispatch_table->support_multi_dispatch()) {
      _dispatch_table->WrapPopN(-1);
    }
    auto sp = CastRawToIntPtr(GetSp());
    auto index = IntPtrMul(value, IntPtrValue(lepus_value_size()));
    sp = IntPtrSub(sp, index);
    sp = CastIntPtrToRaw(sp);
    WriteNewSp(sp);
  }

  son::node::Node* RestoreThis() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_this_obj_offset();
    return LoadByteOffset(son::node::MachineType::kInt64, frame, offset);
  }
  son::node::Node* RestoreNewTarget() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_new_target_offset();
    return LoadByteOffset(son::node::MachineType::kInt64, frame, offset);
  }

  son::node::Node* RestoreLastFrame() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_last_frame_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, frame, offset);
  }

  void SaveLastFrame(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_last_frame_offset();
    StoreByteOffset(son::node::MachineType::kRawType, frame, offset, val);
  }

  void RestoreLastLr() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_last_lr_offset();
    auto lr = LoadByteOffset(son::node::MachineType::kIntptr, frame, offset);
    SetVar64(HandlerVarIndex::kLr, lr);
  }

  void SaveLastLr() {
    auto val = GetVar64(HandlerVarIndex::kLr);
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_last_lr_offset();
    StoreByteOffset(son::node::MachineType::kIntptr, frame, offset, val);
  }

  son::node::Node* RestoreCurFunc() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_cur_func_offset();
    auto func_obj =
        LoadByteOffset(son::node::MachineType::kInt64, frame, offset);
    return func_obj;
  }

  void SavePc(son::node::Node* pc = nullptr) {
    auto frame = GetFrame();
    if (pc == nullptr) {
      pc = GetPc();
    }
    auto offset = AccessBuilder::js_stack_frame_cur_pc_offset();
    StoreByteOffset(son::node::MachineType::kRawType, frame, offset, pc);
  }

  void SaveArgCount(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_arg_count_offset();
    StoreByteOffset(son::node::MachineType::kInt32, frame, offset, val);
  }

  void SaveSp(son::node::Node* val = nullptr) {
    if (val == nullptr) {
      val = GetSp();
    }
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_cur_sp_offset();
    StoreByteOffset(son::node::MachineType::kRawType, frame, offset, val);
  }

  void SaveFrameSp(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_sp_offset();
    StoreByteOffset(son::node::MachineType::kRawType, frame, offset, val);
  }

  void SaveVarBuf(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_var_buf_offset();
    StoreByteOffset(son::node::MachineType::kRawType, frame, offset, val);
    SetVar(HandlerVarIndex::kVarBuf, val);
  }

  void ReloadVarBuf() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_var_buf_offset();
    auto val = LoadByteOffset(son::node::MachineType::kRawType, frame, offset);
    SetVar(HandlerVarIndex::kVarBuf, val);
  }

  void ReloadActiveContextVars() {
    ReloadVarBuf();
    ReloadArgBuf();
    ReloadVarRefsCache();
  }

  son::node::Node* RestoreVarBuf() { return GetVar(HandlerVarIndex::kVarBuf); }
  void SaveArgBuffer(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_arg_buf_offset();
    StoreByteOffset(son::node::MachineType::kRawType, frame, offset, val);
    SetVar(HandlerVarIndex::kArgBuf, val);
  }
  void ReloadArgBuf() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_arg_buf_offset();
    auto val = LoadByteOffset(son::node::MachineType::kRawType, frame, offset);
    SetVar(HandlerVarIndex::kArgBuf, val);
  }
  son::node::Node* ReloadVarRefs(son::node::Node* func_obj) {
    auto var_refs = LoadVarRefs(CastToRaw(func_obj));
    return var_refs;
  }
  son::node::Node* GetVarRefsCache() {
    return GetVar(HandlerVarIndex::kVarRef);
  }
  void SaveVarRefsCache(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_var_refs_cache_offset();
    SetVar(HandlerVarIndex::kVarRef, val);
    StoreByteOffset(son::node::MachineType::kRawType, frame, offset, val);
  }
  void ReloadVarRefsCache() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_var_refs_cache_offset();
    auto val = LoadByteOffset(son::node::MachineType::kRawType, frame, offset);
    SetVar(HandlerVarIndex::kVarRef, val);
  }
  void SaveCpool(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_cpool_offset();
    StoreByteOffset(son::node::MachineType::kRawType, frame, offset, val);
  }
  son::node::Node* RestoreCpool() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_cpool_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, frame, offset);
  }

  son::node::Node* RestoreArgBuf() { return GetVar(HandlerVarIndex::kArgBuf); }
  void SaveCurFunc(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_cur_func_offset();
    StoreByteOffset(son::node::MachineType::kInt64, frame, offset, val);
  }

  void SaveJsMode(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_js_mode_offset();
    StoreByteOffset(son::node::MachineType::kInt32, frame, offset, val);
  }

  void SaveVarRefs(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_var_refs_offset();
    StoreByteOffset(son::node::MachineType::kRawType, frame, offset, val);
  }

  void SaveVarRefSize(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_ref_size_offset();
    StoreByteOffset(son::node::MachineType::kInt32, frame, offset, val);
  }
  void SaveThisObject(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_this_obj_offset();
    StoreByteOffset(son::node::MachineType::kInt64, frame, offset, val);
#ifdef ENABLE_QUICKJS_DEBUGGER
    offset = AccessBuilder::js_stack_frame_pthis_offset();
    StoreByteOffset(son::node::MachineType::kInt64, frame, offset, val);
#endif
  }

  void SaveDebuggerThisObject(son::node::Node* val) {
#ifdef ENABLE_QUICKJS_DEBUGGER
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_pthis_offset();
    StoreByteOffset(son::node::MachineType::kInt64, frame, offset, val);
#endif
  }

  void SaveNewTarget(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_new_target_offset();
    StoreByteOffset(son::node::MachineType::kInt64, frame, offset, val);
  }

  void SavePrevFrame(son::node::Node* val) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_prev_frame_offset();
    StoreByteOffset(son::node::MachineType::kRawType, frame, offset, val);
  }

  void SetPrevFrame(son::node::Node* cur_frame, son::node::Node* prev_frame) {
    StoreByteOffset(son::node::MachineType::kRawType, cur_frame,
                    AccessBuilder::js_stack_frame_prev_frame_offset(),
                    prev_frame);
    return;
  }

  son::node::Node* RestoreCurPc() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_cur_pc_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, frame, offset);
  }

  son::node::Node* RestoreCurSp() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_cur_sp_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, frame, offset);
  }

  son::node::Node* RestoreArgc() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_argc_offset();
    return LoadByteOffset(son::node::MachineType::kInt32, frame, offset);
  }

  void SaveArgc(son::node::Node* value) {
    auto frame = GetFrame();
    auto offset = AccessBuilder::interpreter_frame_argc_offset();
    StoreByteOffset(son::node::MachineType::kInt32, frame, offset, value);
  }

  void SaveRetVal(son::node::Node* value) {
    SetVar64(HandlerVarIndex::kRetVal, value);
  }
  son::node::Node* RestoreRetVal() {
    return GetVar64(HandlerVarIndex::kRetVal);
  }

  son::node::Node* RestoreJsMode() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_js_mode_offset();
    return LoadByteOffset(son::node::MachineType::kInt32, frame, offset);
  }

  son::node::Node* RestorePrevFrame() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_prev_frame_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, frame, offset);
  }

  son::node::Node* RestoreVarRefs() {
    auto frame = GetFrame();
    auto offset = AccessBuilder::js_stack_frame_var_refs_offset();
    return LoadByteOffset(son::node::MachineType::kRawType, frame, offset);
  }

  son::node::Node* RestoreFunctionBytecode() {
    auto cur_func = RestoreCurFunc();
    return LoadFunctionBytecode(CastToRaw(cur_func));
  }
  son::node::Node* RestoreCodeBuf() {
    auto func_bytecode = RestoreFunctionBytecode();
    return LoadBytecodeBuf(func_bytecode);
  }

  son::node::Node* GetGlobal() {
    auto ctx = GetCtx();
    auto offset = AccessBuilder::global_obj_offset();
    return LoadByteOffset(son::node::MachineType::kInt64, ctx, offset);
  }

  son::node::Node* GetGlobalVar() {
    auto ctx = GetCtx();
    auto offset = AccessBuilder::global_var_obj_offset();
    return LoadByteOffset(son::node::MachineType::kInt64, ctx, offset);
  }
#ifdef ENABLE_QUICKJS_DEBUGGER
  son::node::Node* GetIsDebuggerMode() {
    auto ctx = GetCtx();
    auto offset = AccessBuilder::debugger_mode_offset();
    auto val = LoadByteOffset(son::node::MachineType::kInt32, ctx, offset);
    return NotEqual(val, Int32Value(0));
  }
#endif

  void CheckException(son::node::Node* value);
  void JumpIfException(son::node::Node* value, son::node::Label* throw_e);
  void JumpIfUninitialized(son::node::Node* value, son::node::Label* throw_e);
  void CheckIntRetException(son::node::Node* value);
  void CheckAtomRetException(son::node::Node* value);
  void CheckStackOverflow(son::node::Node* sp);
  son::node::Node* PushStackFrame(son::node::Node* alloc_size,
                                  son::node::Node** sf_end = nullptr);
  void PopStackFrame(son::node::Node* prev_sf);

  void call_runtime_wrapper(int index = -1);
  void prim_debug_trace();

  void CallRuntimePrologue(const son::node::CallDescriptor& desc,
                           bool noThrow = false) {
    if (!noThrow) {
      son::node::Node* sp = nullptr;
      if (_dispatch_table->support_multi_dispatch()) {
        sp = _dispatch_table->SaveTop0Top1();
        SaveSp(sp);
        // call_runtime_wrapper(desc.call_index());
      } else {
        SaveSp(sp);
      }
    }
  }
  void CallRuntimeEpilogue() {}

  son::node::Node* TryMalloc(son::node::Node* ctx, son::node::Node* size,
                             int alloc_tag, son::node::Label* fail);
  son::node::Node* TryAllocateObject(son::node::Node* ctx,
                                     son::node::Node* shape,
                                     LEPUSClassID class_id, uint8_t flags,
                                     son::node::Label* fail);

  template <class... Args>
  son::node::Node* CallRuntime(const son::node::CallDescriptor& desc,
                               Args... args) {
    CallRuntimePrologue(desc);
    auto target = FunctionPointer(desc);
    auto res = CallImpl(desc, false, target, args...);
    CallRuntimeEpilogue();
    CheckException(res);
    return res;
  }
  template <class... Args>
  son::node::Node* CallIntRetRuntime(const son::node::CallDescriptor& desc,
                                     Args... args) {
    CallRuntimePrologue(desc);
    auto target = FunctionPointer(desc);
    auto res = CallImpl(desc, false, target, args...);
    CallRuntimeEpilogue();
    CheckIntRetException(res);
    return res;
  }
  template <class... Args>
  void CallJumpException(const son::node::CallDescriptor& desc, Args... args) {
    CallRuntimePrologue(desc);
    auto target = FunctionPointer(desc);
    auto res = CallImpl(desc, false, target, args...);
    CallRuntimeEpilogue();
    DispatchException();
  }
  template <class... Args>
  son::node::Node* CallAtomRetRuntime(const son::node::CallDescriptor& desc,
                                      Args... args) {
    CallRuntimePrologue(desc);
    auto target = FunctionPointer(desc);
    auto res = CallImpl(desc, false, target, args...);
    CallRuntimeEpilogue();
    CheckAtomRetException(res);
    return res;
  }
  template <class... Args>
  son::node::Node* CallRuntimeNoCheck(const son::node::CallDescriptor& desc,
                                      Args... args) {
    CallRuntimePrologue(desc);
    auto target = FunctionPointer(desc);
    auto res = CallImpl(desc, false, target, args...);
    CallRuntimeEpilogue();
    return res;
  }
  template <class... Args>
  son::node::Node* CallRuntimeNoThrow(const son::node::CallDescriptor& desc,
                                      Args... args) {
    CallRuntimePrologue(desc, true);
    auto target = FunctionPointer(desc);
    auto res = CallImpl(desc, false, target, args...);
    CallRuntimeEpilogue();
    return res;
  }
  son::node::Node* CallRuntimeArg0(son::node::CallDescriptor desc,
                                   son::node::Node* arg0) {
    return CallRuntime(desc, arg0);
  }
  son::node::Node* CallRuntimeArg1(son::node::CallDescriptor desc,
                                   son::node::Node* arg0,
                                   son::node::Node* arg1) {
    return CallRuntime(desc, arg0, arg1);
  }
  son::node::Node* CallRuntimeArg2(son::node::CallDescriptor desc,
                                   son::node::Node* arg0, son::node::Node* arg1,
                                   son::node::Node* arg2) {
    return CallRuntime(desc, arg0, arg1, arg2);
  }

  void Dispatch(PrimjsOpcode opcode);
  void DispatchJmp(son::node::Node* offset);
  void DispatchNext();
  void DispatchWithPc(son::node::Node* new_pc);
  void DispatchWithId(CallBcIndex index);
  void DispatchFastPath(CallBcIndex index);
  void DispatchCallHandler(CallBcIndex index);
  son::node::Node* CallFastPath(CallBcIndex index);
  void DispatchException();
  void DispatchCommonCall(son::node::Node* arg0);
  void DispatchWithIdArg0(CallBcIndex index, son::node::Node* arg0);
  void DispatchImpl(son::node::Node* new_pc);
  void DispatchPrevPc(int diff = 0);
  void SetCurrentToTable0() { _dispatch_table->SetCurrentToTable0(); }

  void set_init_state(DispatchState state) {
    _dispatch_table->set_init_state(state);
  }
  void CheckEqual(son::node::Node* val0, son::node::Node* val1);

  void ClearNewSp() { _dispatch_table->ClearNumPush(); }
  void SetNewSp(son::node::Node* value) {
    if (_dispatch_table->support_multi_dispatch()) {
      _dispatch_table->WrapPopN(-1);
    }
    WriteNewSp(value);
  }
  void SetNewSpAfterCall(son::node::Node* value) { WriteNewSp(value); }
  void SetNewPc(son::node::Node* value) { _new_pc = value; }
  void SetNewFrame(son::node::Node* value) { _new_frame = value; }

  void DebuggerCallEachOp();
  void DebuggerCallEachFunc();

  son::node::Node* SaveNewFrame() {
    auto save_frame = _new_frame;
    _new_frame = nullptr;
    return save_frame;
  }
};

}  // namespace primjs
#endif  // PRIMJS_INTERP_INTERPRETER_ASSEMBLER_H
