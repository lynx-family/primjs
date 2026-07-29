/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#ifndef RTSVM_TOOLS_VERIFIER_NODE_GRAPH_H_
#define RTSVM_TOOLS_VERIFIER_NODE_GRAPH_H_

#include "primjs/son/callDescriptor.h"
#include "primjs/son/compilationOptions.h"
#include "primjs/son/nodeBuilder.h"

namespace base {
class InstanceKlass;
}

namespace son {
namespace node {

enum class NodeState : uint8_t {
  kUnvisited = 0,
  kPreVisit = 1,
  kVisited = 2,
  kFinished = 3,
};

class NodeGraph : public base::ZoneObject {
 private:
  base::Zone* _zone;
  NodeBuilder _builder;
  Node* _root;
  Node* _end;
  uint32_t _mark_min;
  uint32_t _mark_max;
  base::ZoneVector<Node*> _worklist;
  base::ZoneVector<Node*> _param_list;
  CallDescriptors _call_descriptors;
  CompilationOptions _options{};
  CallDescriptor _desc = {};

 public:
  NodeGraph(base::Zone* zone);

  node::NodeBuilder* builder() { return &_builder; }
  CallDescriptor call_descriptor() { return _desc; }
  void set_call_descriptor(CallDescriptor desc) { _desc = desc; }

  Node* NewParameter(int n, NodeType* type);
  template <class... Args>
  Node* NewNode(const NodeMeta* meta, NodeType* type, Args... args) {
    return NewNodeImpl(meta, type, args...);
  }

  template <class... Args>
  Node* NewNodeImpl(const NodeMeta* meta, NodeType* type, Args... args);

  Node* NewConstant(MachineType type, uint64_t n) {
    return _builder.NewConstant(type, n);
  }
  Node* GetParameter(RTSCallArgIndex index) {
    int i = -static_cast<int>(index) - 1;
    return _param_list.at(i);
  }

  Node* GetParameter(int index) { return _param_list.at(index); }

  void AddParameter(Node* node) { _param_list.push_back(node); }

  const NodeMeta* ICmp_meta(ICmpCondition cond) {
    return _builder.ICmp_meta(cond);
  }

  const NodeMeta* FCmp_meta(FCmpCondition cond) {
    return _builder.FCmp_meta(cond);
  }

  const NodeMeta* Branch_meta(BranchHint hint) {
    return _builder.Branch_meta(hint);
  }
  const NodeMeta* SwitchCase_meta(int value) {
    return _builder.SwitchCase_meta(value);
  }
  const NodeMeta* Phi_meta(int n) { return _builder.Phi_meta(n); }
  const NodeMeta* Merge_meta(int n) { return _builder.Merge_meta(n); }
  const NodeMeta* Loop_meta(int n) { return _builder.Loop_meta(n); }
  const NodeMeta* DependPhi_meta(int n) { return _builder.DependPhi_meta(n); }
  const NodeMeta* ReadRegister_meta(int reg) {
    return _builder.ReadRegister_meta(reg);
  }
  const NodeMeta* WriteRegister_meta(int reg) {
    return _builder.WriteRegister_meta(reg);
  }
  const NodeMeta* Call_meta(const CallDescriptor& desc, int n) {
    return _builder.Call_meta(desc, n);
  }
  const NodeMeta* TailCall_meta(const CallDescriptor& desc, int n) {
    return _builder.TailCall_meta(desc, n);
  }
  const NodeMeta* Message_meta(const char* msg) {
    return _builder.Message_meta(msg);
  }

#define DEF_NODE_CONSTANT(name, op, f, c, d, v) \
  const NodeMeta* name##_meta() const { return _builder.name##_meta(); }
#include "primjs/son/node.def"

  Node* root() const { return _root; }

  Node* end() const { return _end; }

  Node* start() const { return root(); }

  Node* replacement() const { return _builder.replacement(); }
  void set_replacement(Node* replacement) {
    _builder.set_replacement(replacement);
  }

  void set_end(Node* end) { _end = end; }
  void print();
  void print_json();
  void print_id(int n) PUA_USED { _builder.print_id(n); }

  void AdvanceMarker(int step = 4) {
    vmassert(_mark_max + step < UINT32_MAX, "mark overflow");
    _mark_min = _mark_max;
    _mark_max = _mark_max + step;
  }

  void SetState(Node* node, NodeState state) {
    set_mark(node, static_cast<uint32_t>(state));
  }

  NodeState GetState(Node* node) {
    return static_cast<NodeState>(get_mark(node));
  }

  base::Zone* zone() const { return _zone; }

  base::ZoneVector<Node*>& worklist() { return _worklist; }

  int node_count() const { return _builder.node_count(); }

  CallDescriptorData* GetCallDescriptor(const CallDescriptor& desc) {
    return _call_descriptors.Get(desc);
  }
  CallDescriptors* GetCallDescriptors() { return &_call_descriptors; }

  void set_options(CompilationOptions options) { _options = options; }
  CompilationOptions options() { return _options; }

 private:
  void set_mark(Node* node, uint32_t mark) {
    vmassert(mark < (_mark_max - _mark_min), "mark overflow");
    vmassert(node->mark() < _mark_max, "mark overflow");
    node->set_mark(mark + _mark_min);
  }

  uint32_t get_mark(Node* node) {
    uint32_t mark = node->mark();
    if (mark < _mark_min) {
      return 0;
    }
    return mark - _mark_min;
  }
};
}  // namespace node
}  // namespace son
#endif  // RTSVM_TOOLS_VERIFIER_NODE_GRAPH_H_
