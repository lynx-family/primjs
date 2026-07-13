/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_INTERP_DISPATCH_TABLE_H
#define PRIMJS_INTERP_DISPATCH_TABLE_H

#include "primjs/base/zone.h"
#include "primjs/codegen/bytecode.h"
#include "primjs/son/graphBuilder.h"

namespace primjs {

enum DispatchState : int32_t {
  kUnknown = -1,
  U0_U1 = 0,  // r0 uncached, r1 uncached
  C0_U1 = 1,  // r0 cached, r1 uncached
  C0_C1 = 2,  // r0 cached, r1 cached
  Flexible = -2,
  kTable0 = U0_U1,
  kTable1 = C0_U1,
  kTable2 = C0_C1,
};

class InterpreterAssembler;

class DispatchTable : public base::ZoneObject {
 private:
  InterpreterAssembler* _assembler;
  // State Transition:
  // _current_state -> _state_in -> _state_out
  // _current_state -> U0_U1
  DispatchState _init_state{DispatchState::kUnknown};
  DispatchState _current_state{DispatchState::kUnknown};
  DispatchState _state_in{DispatchState::kUnknown};
  DispatchState _state_out{DispatchState::kUnknown};
  PrimjsOpcode _opcode{PrimjsOpcode::kCount};
  // use-def desc for opcode
  DispatchState _state_use{DispatchState::kUnknown};
  DispatchState _state_def{DispatchState::kUnknown};
  // use-def desc for opcode
  DispatchState _init_spill_state{DispatchState::kUnknown};
  DispatchState _spill_state{DispatchState::kUnknown};
  son::node::Node* _new_sp{nullptr};
  son::node::Node* _spill_in_sp{nullptr};
  int _n_push{-1};
  int _n_pop{-1};
  int _num_push{0};
  int _init_spill_push{0};
  int _num_spill_push{0};
  bool _is_dynamic_sp{false};
  bool _top0_dirty{false};
  bool _top1_dirty{false};
  bool _top0_reset{false};
  bool _top1_reset{false};
  bool _use_top0{false};
  bool _use_top1{false};
  bool _def_top0{false};
  bool _def_top1{false};

 public:
  DispatchTable(InterpreterAssembler* assembler) : _assembler(assembler) {}

  void InitDispatchState(PrimjsOpcode opcode);
  bool GeneratePrologue(PrimjsOpcode opcode);
  void TransitionInState();
  void WrapPopN(int n);
  void WrapPushN(int n);
  void TransitionToTable0(bool verify_stack = true);
  int TransitionForException();
  int DoTransition();
  void AssertState();
  void VerifyStack(DispatchState state);
  void CalculateStateOut();
  void CalculateStateIn();
  void SetDefaultState();
  void ClearNumPush() {
    _top0_dirty = false;
    _top1_dirty = false;
    _top0_reset = false;
    _top1_reset = false;
    _def_top0 = false;
    _def_top1 = false;
    _num_push = 0;
    set_current_state(_init_state);
    _spill_state = _init_spill_state;
    _new_sp = _spill_in_sp;
    _num_spill_push = _init_spill_push;
  }
  bool is_use_argv_opcode(PrimjsOpcode opcode) const;
  void GotoTable0();

  void WrapPushEntry(son::node::Node* val);
  son::node::Node* LoadTop0();
  son::node::Node* LoadTop1();
  void StoreTop0(son::node::Node* val);
  void StoreTop1(son::node::Node* val);
  void StoreTop0Impl(son::node::Node* val);
  void StoreTop1Impl(son::node::Node* val);
  void PushSp(son::node::Node* value);
  void StoreSp(int idx, son::node::Node* value);
  son::node::Node* LoadSp(int idx);
  void SpillState(DispatchState state);
  void SpillOut();
  void SpillPushPop();
  void ReloadStateIn();
  son::node::Node* PopSp();
  void IncSp(int n);
  void DecSp(int n);
  DispatchState DecState(DispatchState state) {
    if (state == DispatchState::C0_C1) {
      return DispatchState::C0_U1;
    }
    return DispatchState::U0_U1;
  }
  DispatchState IncState(DispatchState state) {
    if (state == DispatchState::U0_U1) {
      return DispatchState::C0_U1;
    }
    return DispatchState::C0_C1;
  }
  int get_state_value(DispatchState state) { return static_cast<int>(state); }
  son::node::Node* get_new_sp() { return _new_sp; }
  void set_new_sp(son::node::Node* sp) { _new_sp = sp; }

  son::node::Node* LeapSp(son::node::Node* index);

  son::node::Node* SaveTop0Top1();

  bool top0_available() const { return (!_top0_dirty) || _top0_reset; }
  bool top1_available() const { return (!_top1_dirty) || _top1_reset; }

  bool is_ext_handler() const {
    return _current_state == DispatchState::kUnknown;
  }
  bool support_multi_dispatch() const {
    return !is_ext_handler() && !_is_dynamic_sp;
  }

  int n_push_def() const { return _n_push - _n_pop; }

  void SetCurrentToTable0() {
    set_current_state(DispatchState::U0_U1);
    _state_in = DispatchState::U0_U1;
    _spill_state = DispatchState::U0_U1;
  }

  void set_init_state(DispatchState state) { _init_state = state; }
  void set_current_state(DispatchState state) { _current_state = state; }
  bool is_table2() const { return _init_state == DispatchState::C0_C1; }

  DispatchState current_state() { return _current_state; }
  int get_num_spill_push() { return _num_spill_push; }
  void set_num_spill_push(int num) { _num_spill_push = num; }

  friend class DispatchStateScope;
};

class DispatchStateScope {
 public:
  explicit DispatchStateScope(DispatchTable* table) : _table(table) {
    _new_sp = table->get_new_sp();
    _num_spill_push = table->get_num_spill_push();
    _spill_state = table->_spill_state;
  }
  ~DispatchStateScope() {
    _table->set_new_sp(_new_sp);
    _table->set_num_spill_push(_num_spill_push);
    _table->_spill_state = _spill_state;
  }

 private:
  DispatchTable* _table;
  son::node::Node* _new_sp{nullptr};
  int _num_spill_push{0};
  DispatchState _spill_state{DispatchState::kUnknown};
};

}  // namespace primjs
#endif  // PRIMJS_INTERP_DISPATCH_TABLE_H
