/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#include "primjs/son/graphAssembler.h"

#include "primjs/son/graphBuilder.h"

namespace son {
namespace node {

GraphEnvironment::GraphEnvironment(GraphBuilder* builder, Node* control,
                                   Node* depend)
    : _zone(builder->zone()), _builder(builder), _graph(builder->graph()) {
  _entry_label = NewLabel();
  _entry_label->set_control(control);
  _entry_label->set_depend(depend);
  _current_label = _entry_label;
  _builder->set_env(this);
  _entry_label->set_bound();
}

GraphEnvironment::GraphEnvironment(GraphBuilder* builder)
    : GraphEnvironment(builder, builder->graph()->start(),
                       builder->graph()->start()) {}

GraphEnvironment::GraphEnvironment(GraphBuilder* builder, Node* hir)
    : GraphEnvironment(builder, hir->control_at(), hir->depend_at()) {}

VariableImpl::VariableImpl(GraphEnvironment* env, NodeType* type, Node* value)
    : _env(env), _type(type) {
  vmassert(type == value->type(), "must be");
  env->WriteVariable(this, value);
}

LabelImpl::LabelImpl(GraphEnvironment* env)
    : _env(env),
      _merge_control(nullptr),
      _merge_depend(nullptr),
      _control(nullptr),
      _depend(nullptr),
      _preds_control(env->zone()),
      _preds(env->zone()),
      _var_map(env->zone()),
      _var_phis(env->zone()),
      _pred_size(0),
      _bound(false),
      _is_loop(false),
      _is_finished(false) {}

void LabelImpl::Bind(int pred_size) {
  vmassert(!_bound, "must be");
  _bound = true;
  _is_finished = false;
  vmassert(!_preds.empty(), "must be");
  set_pred_size(pred_size);
  auto count = _preds.size();
  for (int i = 0; i < count; i++) {
    auto pred = _preds.at(i);
    MergeLabel(i, pred);
  }
  _control = _merge_control;
  _depend = _merge_depend;
}

void LabelImpl::MergeLabel(int index, LabelImpl* pred) {
  _merge_control = MergeControl(index, pred);
  _merge_depend = MergeDepend(index, pred);
  for (auto it : _var_map) {
    MergeVariableValue(index, pred, it.first);
  }
}

Node* LabelImpl::MergeControl(int index, LabelImpl* other) {
  auto other_control = other->control();
  auto pred_size = get_pred_size();
  if (pred_size == 1) {
    if (!_preds_control.empty()) {
      vmassert(_preds_control.size() == 1, "must be");
      return _preds_control.at(0);
    }
    return other_control;
  }
  if (!_preds_control.empty()) {
    for (auto pred_control : _preds_control) {
      vmassert(pred_control->control_in() == 1, "must be");
      if (pred_control->control_at() == other_control) {
        vmassert((other_control->opcode() == Opcode::OP_Branch) ||
                     (other_control->opcode() == Opcode::OP_Switch),
                 "must be");
        other_control = pred_control;
        break;
      }
    }
  }

  if (_merge_control == nullptr) {
    if (is_loop()) {
      _merge_control = env()->builder()->Loop(pred_size);
    } else {
      _merge_control = env()->builder()->Merge(pred_size);
    }
  } else if (pred_size != _merge_control->control_in()) {
    auto old_size = _merge_control->control_in();
    auto old_control = _merge_control;
    if (is_loop()) {
      _merge_control = env()->builder()->Loop(pred_size);
    } else {
      _merge_control = env()->builder()->Merge(pred_size);
    }
    for (int i = 0; i < old_size; i++) {
      _merge_control->NewInput(i, old_control->control_at(i));
    }
  }
  _merge_control->NewInput(index, other_control);
  return _merge_control;
}

Node* LabelImpl::MergeDepend(int index, LabelImpl* other) {
  auto other_depend = other->depend();
  auto pred_size = get_pred_size();
  if (pred_size == 1) {
    return other_depend;
  }
  vmassert(_merge_control->control_in() == pred_size, "must be");
  if (_merge_depend == nullptr) {
    _merge_depend = env()->builder()->DependPhi(pred_size, _merge_control);
    _merge_depend->NewInput(index + 1, other_depend);
    return _merge_depend;
  }
  vmassert(_merge_depend->opcode() == Opcode::OP_DependPhi, "must be");
  vmassert(_merge_depend->control_at() == _merge_control, "must be");
  auto old_size = _merge_depend->depend_in();
  if (old_size != pred_size) {
    auto old_depend = _merge_depend;
    _merge_depend = env()->builder()->DependPhi(pred_size, _merge_control);
    for (int i = 0; i < old_size; i++) {
      _merge_depend->NewInput(i + 1, old_depend->depend_at(i));
    }
  }
  _merge_depend->NewInput(index + 1, other_depend);
  return _merge_depend;
}

Node* LabelImpl::MergeValue(int index, Node* value, Node* other) {
  int n = _merge_control->control_in();
  vmassert(n == get_pred_size(), "must be");
  if ((value->opcode() == Opcode::OP_Phi) &&
      (value->control_at() == _merge_control)) {
    if (value->value_in() != n) {
      auto new_phi = env()->builder()->Phi(n, _merge_control, value->type());
      for (int i = 0; i < new_phi->value_in(); i++) {
        new_phi->NewInput(i + 1, new_phi->value_at(i));
      }
    }
    value->NewInput(index + 1, other);
  } else if (value != other) {
    auto phi = env()->builder()->Phi(n, _merge_control, value->type());
    for (int i = 0; i < index; i++) {
      phi->NewInput(i + 1, value);
    }
    phi->NewInput(index + 1, other);
    value = phi;
  }
  return value;
}

Node* LabelImpl::MergeVariableValue(int index, LabelImpl* other,
                                    VariableImpl* var) {
  auto other_value = other->ReadVariable(var);
  auto pred_size = get_pred_size();
  if (pred_size == 1) {
    BindVariable(var, other_value);
    return other_value;
  }
  Node* value = nullptr;
  if (index == 0) {
    if (is_loop() && !is_finished()) {
      value =
          env()->builder()->Phi(pred_size, _merge_control, other_value->type());
      value = MergeValue(index, value, other_value);
      BindPhi(var, value);
    } else {
      value = other_value;
    }
  } else {
    auto current_value = FindVariablePhi(var);
    if (current_value == nullptr) {
      current_value = ReadVariable(var);
    }
    value = MergeValue(index, current_value, other_value);
    if (current_value != value) {
      BindPhi(var, value);
    }
  }
  BindVariable(var, value);
  return value;
}

Node* LabelImpl::ReadVariableRecursive(VariableImpl* var) {
  Node* value = nullptr;
  auto pred_size = get_pred_size();
  if (pred_size == 1) {
    value = _preds.at(0)->ReadVariable(var);
  } else {
    auto count = _preds.size();
    vmassert(count <= pred_size, "must be");
    for (int i = 0; i < count; i++) {
      auto pred = _preds.at(i);
      vmassert(pred->is_bound(), "must be");
      value = MergeVariableValue(i, pred, var);
    }
  }
  return value;
}

void LabelImpl::AppendPred(LabelImpl* impl, Node* control) {
  if (control != nullptr) {
    _preds_control.emplace_back(control);
  }
  set_is_finished();
  if (!_bound) {
    _preds.emplace_back(impl);
    return;
  }
  auto pred_size = _preds.size();
  _preds.emplace_back(impl);
  MergeLabel(pred_size, impl);
}

}  // namespace node
}  // namespace son
