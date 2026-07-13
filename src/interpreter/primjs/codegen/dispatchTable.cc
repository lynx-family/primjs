// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/dispatchTable.h"

#include <algorithm>
#include <iostream>

#include "primjs/codegen/bytecode.h"
#include "primjs/codegen/interpreterAssembler.h"
#include "primjs/son/graphAssembler.h"
#include "primjs/son/graphBuilder.h"

namespace primjs {
void DispatchTable::SetDefaultState() {
  _is_dynamic_sp = true;
  _state_def = DispatchState::U0_U1;
  _state_use = DispatchState::U0_U1;
  _state_in = _init_state;
  _state_out = DispatchState::U0_U1;
}

void DispatchTable::InitDispatchState(PrimjsOpcode opcode) {
  vmassert(_init_state != DispatchState::kUnknown, "must be");
  _opcode = opcode;
  _n_push = get_npush(opcode);
  _n_pop = get_npop(opcode);
  set_current_state(_init_state);
  _spill_state = _init_spill_state = _init_state;
  if (!_assembler->graph()->options().SupportMultiTable()) {
    SetDefaultState();
    return;
  }
  int index = static_cast<int>(opcode);
  switch (index) {
#define DEF_INTERP_DESP(name, state_use, state_out) \
  case static_cast<int>(CallBcIndex::k##name):      \
    _state_def = DispatchState::state_out;          \
    _state_use = state_use;                         \
    break;
#include "primjs/codegen/handler.def"
    default:
      SetDefaultState();
      return;
  }
  vmassert(!is_use_argv_opcode(opcode), "must be");
  vmassert(_state_use != DispatchState::kUnknown, "must be");
  vmassert(_state_def != DispatchState::kUnknown, "must be");
  CalculateStateIn();
  CalculateStateOut();
}

void DispatchTable::CalculateStateIn() {
  // _state_in = max(_state_use, _current_state)
  _state_in = (DispatchState)std::max(static_cast<int>(_state_use),
                                      static_cast<int>(_current_state));
}

void DispatchTable::CalculateStateOut() {
  int cur_state = static_cast<int>(DispatchState::kUnknown);
  auto npush = n_push_def();
  if (npush == 0) {
    cur_state = static_cast<int>(_state_in);
  } else if (npush > 1 || npush < -1) {
    cur_state = 0;
  } else if (npush == 1) {
    if (_state_in != DispatchState::U0_U1) {
      // new_top1 = top0
      cur_state = DispatchState::C0_C1;
    } else {
      cur_state = DispatchState::C0_U1;
    }
  } else {
    // pop
    vmassert(npush == -1, "must be");
    cur_state = static_cast<int>(_state_in);
    cur_state -= 1;
  }
  // _state_out = max(_state_def, cur_state)
  _state_out = (DispatchState)std::max(static_cast<int>(_state_def), cur_state);
  vmassert((_state_out >= DispatchState::U0_U1) &&
               (_state_out <= DispatchState::C0_C1),
           "must be");
}

void DispatchTable::GotoTable0() {
  auto idx = (CallBcIndex)_opcode;
  _assembler->DispatchWithId(idx);
}

bool DispatchTable::GeneratePrologue(PrimjsOpcode opcode) {
  InitDispatchState(opcode);
  TransitionInState();
  if ((_init_state != DispatchState::U0_U1) && (_is_dynamic_sp)) {
    GotoTable0();
    return false;
  }
  // continue
  return true;
}

void DispatchTable::TransitionInState() {
  if (_is_dynamic_sp) {
    SpillState(_current_state);
  } else {
    SpillPushPop();
    ReloadStateIn();
  }
  _init_spill_state = _spill_state;
  _spill_in_sp = _new_sp;
  _init_spill_push = _num_spill_push;
}

void DispatchTable::WrapPushEntry(son::node::Node* val) {
  // top0 = val
  // new_top1 = top0
  // push top1
  IncSp(1);
  if (_state_out == DispatchState::U0_U1) {
    vmassert(_state_in == DispatchState::U0_U1, "msut be");
    _assembler->StoreSpImpl(-1, val);
  } else if (_state_out == DispatchState::C0_U1) {
    vmassert(_state_in == DispatchState::U0_U1, "msut be");
    _assembler->SetTop0Var(val);
  } else if (_state_out == DispatchState::C0_C1) {
    vmassert(_state_in != DispatchState::U0_U1, "msut be");
    if (_state_in == DispatchState::C0_C1) {
      _assembler->SetTop0Var(_assembler->GetTop1());
      _assembler->SetTop1Var(val);
    } else if (_state_in == DispatchState::C0_U1) {
      _assembler->SetTop1Var(val);
    }
    _top1_reset = true;
  }
  _top0_reset = true;
  _def_top0 = true;
}

son::node::Node* DispatchTable::LoadTop0() {
  _use_top0 = true;
  vmassert(!_top0_dirty, "must be");
  if (_state_in == DispatchState::C0_U1) {
    return _assembler->GetTop0();
  } else if (_state_in == DispatchState::C0_C1) {
    return _assembler->GetTop1();
  }
  vmassert(_state_in == DispatchState::U0_U1, "must be");
  return _assembler->LoadSpImpl(-1);
}

son::node::Node* DispatchTable::LoadTop1() {
  _use_top1 = true;
  vmassert(!_top1_dirty, "must be");
  if (_state_in == DispatchState::C0_U1) {
    return _assembler->LoadSpImpl(-2);
  } else if (_state_in == DispatchState::C0_C1) {
    return _assembler->GetTop0();
  }
  vmassert(_state_in == DispatchState::U0_U1, "must be");
  return _assembler->LoadSpImpl(-2);
}

void DispatchTable::StoreTop0(son::node::Node* val) {
  vmassert(n_push_def() != 1, "should use push sp");
  StoreTop0Impl(val);
  _top0_reset = true;
  _def_top0 = true;
}

void DispatchTable::StoreTop1(son::node::Node* val) {
  StoreTop1Impl(val);
  _top1_reset = true;
  _def_top1 = true;
}

void DispatchTable::StoreTop0Impl(son::node::Node* val) {
  if (_state_out == DispatchState::C0_C1) {
    _assembler->SetTop1Var(val);
  } else if (_state_out == DispatchState::C0_U1) {
    _assembler->SetTop0Var(val);
  } else {
    _assembler->StoreSpImpl(-1, val);
  }
}

void DispatchTable::StoreTop1Impl(son::node::Node* val) {
  if (_state_out == DispatchState::C0_C1) {
    _assembler->SetTop0Var(val);
  } else {
    _assembler->StoreSpImpl(-2, val);
  }
}

void DispatchTable::StoreSp(int idx, son::node::Node* value) {
  if (idx == -1) {
    StoreTop0(value);
    return;
  } else if (idx == -2) {
    StoreTop1(value);
    return;
  }
  if (_num_push == 0) {
    idx += get_state_value(_spill_state);
  } else {
    idx += get_state_value(_state_out);
  }
  _assembler->StoreSpImpl(idx, value);
}

son::node::Node* DispatchTable::LoadSp(int idx) {
  if (idx == -1) {
    return LoadTop0();
  } else if (idx == -2) {
    return LoadTop1();
  }
  if (_num_push == 0) {
    idx += get_state_value(_spill_state);
  } else {
    idx += get_state_value(_state_out);
  }
  return _assembler->LoadSpImpl(idx);
}

void DispatchTable::IncSp(int n) {
  if (_is_dynamic_sp) {
    _assembler->IncSpImpl(n);
    _num_spill_push += n;
    return;
  }
  vmassert(n == n_push_def(), "must be");
  WrapPushN(n);
  if (_state_out == _spill_state) {
    _assembler->IncSpImpl(n);
    _num_spill_push += n;
    return;
  }
  int num = n_push_def();
  num += get_state_value(_spill_state) - get_state_value(_state_out);
  if (num < 0) {
    _assembler->DecSpImpl(-num);
  } else if (num != 0) {
    _assembler->IncSpImpl(num);
  }
  _num_spill_push += num;
}

void DispatchTable::DecSp(int n) {
  if (_is_dynamic_sp) {
    _assembler->DecSpImpl(n);
    _num_spill_push -= n;
    return;
  }
  vmassert(n == -n_push_def(), "must be");
  WrapPopN(n);
  if (_state_out == _spill_state) {
    _assembler->DecSpImpl(n);
    _num_spill_push -= n;
    return;
  }
  int num = -n_push_def();
  num -= get_state_value(_spill_state) - get_state_value(_state_out);
  vmassert(num >= 0, "must be");
  if (num != 0) {
    _assembler->DecSpImpl(num);
    _num_spill_push -= num;
  }
}

son::node::Node* DispatchTable::LeapSp(son::node::Node* index) {
  vmassert(_is_dynamic_sp, "must be");
  return _assembler->LeapSp(_assembler->GetSp(), index, sizeof(LEPUSValue));
}

void DispatchTable::PushSp(son::node::Node* val) {
  if (_is_dynamic_sp) {
    _assembler->PushSpImpl(val);
    _num_spill_push += 1;
    return;
  }
  vmassert(n_push_def() == 1, "must be");
  WrapPushEntry(val);
}

son::node::Node* DispatchTable::PopSp() {
  vmassert(_num_push == 0, "must be");
  auto res = LoadTop0();
  _assembler->DecSp();
  return res;
}

son::node::Node* DispatchTable::SaveTop0Top1() {
  if (_is_dynamic_sp) {
    return nullptr;
  }
  DispatchStateScope scope(this);
  SpillOut();
  return get_new_sp();
}

void DispatchTable::SpillState(DispatchState state) {
  if (_spill_state == DispatchState::U0_U1) {
    return;
  }
  if (_spill_state == state) {
    if (state == DispatchState::C0_C1) {
      auto val0 = _assembler->GetTop0();
      auto val1 = _assembler->GetTop1();
      _assembler->PushSpImpl(val0);
      _assembler->PushSpImpl(val1);
      _num_spill_push += 2;
    } else if (state == DispatchState::C0_U1) {
      auto val = _assembler->GetTop0();
      _assembler->PushSpImpl(val);
      _num_spill_push += 1;
    }
  } else {
    // C0_U1 -> C0_C1, swap t0 & t1
    if (_spill_state == DispatchState::C0_U1) {
      vmassert(state == DispatchState::C0_C1, "must be");
      auto val = _assembler->GetTop1();
      _assembler->PushSpImpl(val);
      _num_spill_push += 1;
    } else {
      unreachable();
    }
  }
  _spill_state = DispatchState::U0_U1;
}

void DispatchTable::SpillOut() {
  int n = n_push_def();
  if ((_num_push != n) || (n == 0)) {
    vmassert(_num_push == 0, "must be");
    vmassert(_current_state == _init_state, "must be");
    // before push
    SpillState(_state_in);
  } else {
    unreachable();
  }
}

void DispatchTable::ReloadStateIn() {
  if (_state_in == _current_state) {
    return;
  }

  if (_current_state == DispatchState::U0_U1) {
    if (_state_in == DispatchState::C0_U1) {
      // U0_U1 -> C0_U1
      auto top0 = _assembler->LoadSpImpl(-1);
      _assembler->SetTop0Var(top0);
    } else {
      vmassert(_state_in == DispatchState::C0_C1, "must be");
      // U0_U1 -> C0_C1
      auto top0 = _assembler->LoadSpImpl(-2);
      auto top1 = _assembler->LoadSpImpl(-1);
      _assembler->SetTop0Var(top0);
      _assembler->SetTop1Var(top1);
    }
  } else if (_current_state == DispatchState::C0_U1) {
    vmassert(_state_in == DispatchState::C0_C1, "must be");
    // C0_U1 -> C0_C1
    auto top0 = _assembler->GetTop0();
    _assembler->SetTop1Var(top0);
    auto val = _assembler->LoadSpImpl(-1);  // -1
    _assembler->SetTop0Var(val);
  } else {
    unreachable();
  }
}

void DispatchTable::SpillPushPop() {
  int n = n_push_def();
  if ((n <= 0) || (_spill_state == DispatchState::U0_U1)) {
    return;
  }
  vmassert(_current_state == _spill_state, "msut be");
  if (n == 1) {
    auto state = _spill_state;
    if (state == DispatchState::C0_C1) {
      auto val0 = _assembler->GetTop0();
      _assembler->PushSpImpl(val0);
      _num_spill_push += 1;
      _spill_state = DispatchState::C0_U1;
    }
  } else {
    vmassert(n >= 2, "must be");
    SpillState(_spill_state);
  }
}

void DispatchTable::WrapPushN(int n) {
  vmassert(n > 0, "must be");
  vmassert(!_def_top0 && !_def_top1, "must be");
  if (_is_dynamic_sp) {
    return;
  }
  _top1_dirty = true;
  _top0_dirty = true;
  _num_push += n;
}

void DispatchTable::WrapPopN(int n) {
  vmassert(!_def_top0 && !_def_top1, "must be");
  vmassert(n != 0, "must be");
  if (n == -1) {
    vmassert(_is_dynamic_sp, "must be");
    return;
  }
  if (_is_dynamic_sp) {
    return;
  }
  vmassert(n > 0, "must be");
  _top1_dirty = true;
  _top0_dirty = true;
  if ((n == 1) && (_state_in == DispatchState::C0_C1)) {
    // new_top0 = top1
    _top0_reset = true;
  }

  _num_push -= n;
}

void DispatchTable::AssertState() {
  if (_state_out == DispatchState::C0_C1) {
    vmassert(top0_available() && top1_available(), "must be");
  } else if (_state_out == DispatchState::C0_U1) {
    vmassert(top0_available(), "must be");
  }
  if (_use_top1) {
    vmassert(_state_use == DispatchState::C0_C1, "must be");
  } else if (_use_top0) {
    vmassert(_state_use == DispatchState::C0_U1, "must be");
  } else {
    vmassert(_state_use == DispatchState::U0_U1, "must be");
  }
  if (_def_top1 && _def_top0) {
    vmassert(_state_def == DispatchState::C0_C1, "must be");
  } else if (_def_top1) {
    vmassert(n_push_def() == 0, "must be");
    vmassert(_state_def == DispatchState::C0_C1, "must be");
  } else if (_def_top0) {
    vmassert(_state_def == DispatchState::C0_U1, "must be");
  } else {
    vmassert(!_def_top1, "must be");
    vmassert(_state_def != DispatchState::C0_C1, "must be");
  }
}

void DispatchTable::VerifyStack(DispatchState state) {
  if (_is_dynamic_sp) {
    return;
  }
  [[maybe_unused]] int n = n_push_def();
  n += get_state_value(_init_state) - get_state_value(state);
  vmassert(n == _num_spill_push, "must be");
}

void DispatchTable::TransitionToTable0(bool verify_stack) {
  if (is_ext_handler()) {
    return;
  }
  SpillOut();
  if (verify_stack) {
    VerifyStack(DispatchState::U0_U1);
  }
}

int DispatchTable::TransitionForException() {
  auto res_index = CallBcIndex::kexception;
  if (!support_multi_dispatch()) {
    return static_cast<int>(res_index);
  }
  int n = n_push_def();
  if ((_num_push == n) && (n != 0)) {
    vmassert((n != 1) && (n != -1), "must be");
  }

  if (_spill_state == DispatchState::U0_U1) {
    return static_cast<int>(res_index);
  }
  if (_spill_state == _state_in) {
    if (_state_in == DispatchState::C0_C1) {
      res_index = CallBcIndex::kexception_spill_top0_top1;
    } else if (_state_in == DispatchState::C0_U1) {
      res_index = CallBcIndex::kexception_spill_top0;
    }
  } else {
    // C0_U1 -> C0_C1, swap t0 & t1
    if (_spill_state == DispatchState::C0_U1) {
      vmassert(_state_in == DispatchState::C0_C1, "must be");
      res_index = CallBcIndex::kexception_spill_top1;
    } else {
      unreachable();
    }
  }
  return static_cast<int>(res_index);
}

int DispatchTable::DoTransition() {
  if (!support_multi_dispatch()) {
    TransitionToTable0();
    return 0;
  }
  vmassert(n_push_def() == _num_push, "must be");
  int n = n_push_def();
  // not call incsp or decsp
  if (n == 0) {
    vmassert(_num_spill_push == 0, "must be");
    auto num = get_state_value(_init_state) - get_state_value(_state_out);
    if (num != 0) {
      _assembler->IncSpImpl(num);
      _num_spill_push += num;
    }
  }
  AssertState();
  VerifyStack(_state_out);
  return static_cast<int>(_state_out);
}

bool DispatchTable::is_use_argv_opcode(PrimjsOpcode opcode) const {
  switch (opcode) {
    case PrimjsOpcode::OP_call0:
    case PrimjsOpcode::OP_call1:
    case PrimjsOpcode::OP_call2:
    case PrimjsOpcode::OP_call3:
    case PrimjsOpcode::OP_call:
    case PrimjsOpcode::OP_call_method:
    case PrimjsOpcode::OP_tail_call:
    case PrimjsOpcode::OP_tail_call_method:
    case PrimjsOpcode::OP_call_constructor:
    case PrimjsOpcode::OP_array_from:
    case PrimjsOpcode::OP_apply:
    case PrimjsOpcode::OP_iterator_close_return:
    case PrimjsOpcode::OP_async_iterator_next:
    case PrimjsOpcode::OP_append:
    case PrimjsOpcode::OP_copy_data_properties:
    case PrimjsOpcode::OP_define_class:
    case PrimjsOpcode::OP_make_var_ref:
    case PrimjsOpcode::OP_for_of_start:
    case PrimjsOpcode::OP_for_await_of_start:
    case PrimjsOpcode::OP_for_in_next:
    case PrimjsOpcode::OP_for_of_next:
    case PrimjsOpcode::OP_for_await_of_next:
    case PrimjsOpcode::OP_iterator_get_value_done:
    case PrimjsOpcode::OP_async_iterator_close:
    case PrimjsOpcode::OP_async_iterator_get:
    case PrimjsOpcode::OP_await:
    case PrimjsOpcode::OP_yield:
    case PrimjsOpcode::OP_yield_star:
    case PrimjsOpcode::OP_async_yield_star:
    case PrimjsOpcode::OP_return_async:
    case PrimjsOpcode::OP_initial_yield:
      return true;
    default:
      break;
  }
  return is_with_opcode(_opcode);
}

}  // namespace primjs
