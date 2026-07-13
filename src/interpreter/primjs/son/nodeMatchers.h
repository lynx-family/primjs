/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_SON_NODE_MATCHERS_H
#define PRIMJS_SON_NODE_MATCHERS_H

#include "primjs/base/globals.h"
#include "primjs/son/nodeGraph.h"

namespace son {
namespace node {

class NodeMatcher {
 private:
  Node* _node;

 public:
  explicit NodeMatcher(Node* node) : _node(node) {}

  Node* node() const { return _node; }

#define DEF_NODE_KIND(kind, f, meta) \
  bool Is##kind() const { return _node->opcode() == node::Opcode::OP_##kind; }
#include "primjs/son/node.def"
};

template <typename T, Opcode kOpcode>
class ValueMatcher : public NodeMatcher {
 private:
  T _value;
  bool _has_resolved;

 public:
  explicit ValueMatcher(Node* node) : NodeMatcher(node), _value() {
    _has_resolved = node->opcode() == kOpcode;
    if (_has_resolved) {
      _value = static_cast<T>(node->meta_value<uint64_t>());
    }
  }

  bool HasResolved() const { return _has_resolved; }
  T value() const {
    vmassert(_has_resolved, "must be");
    return _value;
  }

  bool Is(const T& value) const {
    return this->HasResolved() && this->value() == value;
  }
};

using Int32Matcher = ValueMatcher<int32_t, Opcode::OP_Constant>;
using Int64Matcher = ValueMatcher<int64_t, Opcode::OP_Constant>;
using Float64Matcher = ValueMatcher<double, Opcode::OP_Constant>;

}  // namespace node
}  // namespace son

#endif  // PRIMJS_SON_NODE_MATCHERS_H
