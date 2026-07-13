// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_SON_GRAPH_ASSEMBLER_H
#define PRIMJS_SON_GRAPH_ASSEMBLER_H

#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"
#include "primjs/son/nodeGraph.h"

namespace son {
namespace node {

class VariableImpl;
class GraphBuilder;
class GraphEnvironment;
class Label;
class Variable;

class LabelImpl : public base::ZoneObject {
 private:
  GraphEnvironment* _env;
  Node* _merge_control;
  Node* _merge_depend;
  Node* _control;
  Node* _depend;
  base::ZoneVector<Node*> _preds_control;
  base::ZoneVector<LabelImpl*> _preds;
  base::ZoneMap<VariableImpl*, Node*> _var_map;
  base::ZoneMap<VariableImpl*, Node*> _var_phis;
  int _pred_size;
  bool _bound;
  bool _is_loop;
  bool _is_finished;

 public:
  LabelImpl(GraphEnvironment* env);

  Node* control() const { return _control; }
  Node* depend() const { return _depend; }

  void set_control(Node* value) { _control = value; }

  void set_depend(Node* value) { _depend = value; }

  void set_is_loop(bool value) { _is_loop = value; }
  bool is_loop() const { return _is_loop; }
  bool is_bound() const { return _bound; }
  void set_bound() { _bound = true; }
  bool is_finished() const { return _is_finished; }
  void set_is_finished() { _is_finished = true; }
  int get_pred_size() const {
    return _pred_size == 0 ? _preds.size() : _pred_size;
  }
  void set_pred_size(int value) { _pred_size = value; }
  GraphEnvironment* env() const { return _env; }

  void AppendPred(LabelImpl* impl, Node* control);
  void MergeLabel(int index, LabelImpl* other);
  Node* MergeControl(int index, LabelImpl* other);
  Node* MergeDepend(int index, LabelImpl* other);
  Node* MergeVariableValue(int index, LabelImpl* other, VariableImpl* var);
  Node* MergeValue(int index, Node* value, Node* other);

  void WriteVariable(VariableImpl* var, Node* value);
  void BindVariable(VariableImpl* var, Node* value);
  Node* ReadVariable(VariableImpl* var);
  Node* ReadVariableRecursive(VariableImpl* var);
  Node* FindVariable(VariableImpl* var);
  Node* FindVariablePhi(VariableImpl* var);

  void BindPhi(VariableImpl* var, Node* value) { _var_phis[var] = value; }

  void Bind(int pred_size = 0);
};

class VariableImpl : public base::ZoneObject {
 private:
  GraphEnvironment* _env;
  NodeType* _type;

 public:
  VariableImpl(GraphEnvironment* env, NodeType* type, Node* value);

  NodeType* type() const { return _type; }

  GraphEnvironment* env() const { return _env; }

  void WriteVariable(Node* value);

  Node* ReadVariable();
};

class GraphEnvironment {
 private:
  base::Zone* _zone;
  GraphBuilder* _builder;
  LabelImpl* _current_label;
  NodeGraph* _graph;
  LabelImpl* _entry_label;

 public:
  GraphEnvironment(GraphBuilder* builder);
  GraphEnvironment(GraphBuilder* builder, Node* control, Node* depend);

  GraphEnvironment(GraphBuilder* builder, Node* hir);

  base::Zone* zone() const { return _zone; }
  LabelImpl* NewLabel() { return new (zone()) LabelImpl(this); }

  VariableImpl* NewVariable(NodeType* type, Node* init) {
    return new (zone()) VariableImpl(this, type, init);
  }

  NodeGraph* graph() const { return _graph; }

  LabelImpl* current_label() const { return _current_label; }

  void set_current_label(LabelImpl* impl) { _current_label = impl; }

  GraphBuilder* builder() const { return _builder; }

  void set_builder(GraphBuilder* builder) { _builder = builder; }

  void WriteVariable(VariableImpl* var, Node* value) {
    _current_label->WriteVariable(var, value);
  }
  Node* ReadVariable(VariableImpl* var) {
    return _current_label->ReadVariable(var);
  }
};

inline void VariableImpl::WriteVariable(Node* value) {
  _env->WriteVariable(this, value);
}

inline Node* VariableImpl::ReadVariable() { return _env->ReadVariable(this); }

inline void LabelImpl::WriteVariable(VariableImpl* var, Node* value) {
  _var_map[var] = value;
}

inline void LabelImpl::BindVariable(VariableImpl* var, Node* value) {
  _var_map[var] = value;
}

inline Node* LabelImpl::FindVariable(VariableImpl* var) {
  auto it = _var_map.find(var);
  if (it != _var_map.end()) {
    return it->second;
  }
  return nullptr;
}

inline Node* LabelImpl::FindVariablePhi(VariableImpl* var) {
  auto it = _var_phis.find(var);
  if (it != _var_phis.end()) {
    return it->second;
  }
  return nullptr;
}

inline Node* LabelImpl::ReadVariable(VariableImpl* var) {
  auto value = FindVariable(var);
  if (value != nullptr) {
    return value;
  }
  value = ReadVariableRecursive(var);
  // bind value to var
  BindVariable(var, value);
  return value;
}

}  // namespace node
}  // namespace son
#endif  // PRIMJS_SON_GRAPH_ASSEMBLER_H
