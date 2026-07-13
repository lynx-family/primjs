/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_SON_NODE_H
#define PRIMJS_SON_NODE_H

#include <ostream>

#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"
#include "primjs/son/nodeType.h"

namespace son {
namespace node {

enum class Opcode : uint8_t {
#define DEF_NODE_KIND(kind, f, meta) OP_##kind,
#include "primjs/son/node.def"
};

enum class MetaKind : uint8_t {
#define DEF_META_KIND(meta) k##meta,
#include "primjs/son/node.def"
};

enum class MetaFlags : uint8_t {
#define DEF_META_FLAG(flag, v) k##flag = v,
#include "primjs/son/node.def"
};

class NodeMeta {
 public:
  Opcode _opcode;
  MetaFlags _flags;
  int _control_in;
  int _depend_in;
  int _value_in;

  bool has_control() const { return _control_in > 0; }

  bool has_depend() const { return _depend_in > 0; }

  bool has_value() const { return _value_in > 0; }

  NodeMeta(Opcode opcode, MetaFlags f, int c, int d, int v)
      : _opcode(opcode),
        _flags(f),
        _control_in(c),
        _depend_in(d),
        _value_in(v) {}

  int intput_count() const { return _value_in + _depend_in + _control_in; }

  MetaFlags flags() const { return _flags; }

  bool has_flag(MetaFlags flag) const {
    return (static_cast<int>(flags()) & static_cast<int>(flag)) ==
           static_cast<int>(flag);
  }

  Opcode opcode() const { return _opcode; }
};

template <typename T>
class NodeMeta1 : public NodeMeta {
 public:
  NodeMeta1(Opcode opcode, MetaFlags f, int c, int d, int v, T parameter)
      : NodeMeta(opcode, f, c, d, v), parameter_(parameter) {}

  T const& parameter() const { return parameter_; }

 private:
  T const parameter_;
};

using Uint64NodeMeta = NodeMeta1<uint64_t>;

class Node;

// | UseN | ... | Use0 | Node | Input0  |... | InputN |
struct Use {
  Use* _next;
  Use* _prev;
  int _input_index;

  Node* node() const {
    Use* start = const_cast<Use*>(this) + 1 + _input_index;
    return reinterpret_cast<Node*>(start);
  }

  Node* input_node() const { return *input_ptr(); }

  int input_index() const { return _input_index; }

  void UpdateTo(Node* new_node);

  Node** input_ptr() const;
};

class UseIterator;
class UseList final {
 public:
  using value_type = Node*;
  using iterator = UseIterator;

  explicit UseList(Node* node) : _node(node) {}

  bool empty() const;

  inline iterator begin() const;
  inline iterator end() const;

 private:
  Node* _node;
};

class ConstUseIterator;
class ConstUseList final {
 public:
  using value_type = Node*;
  explicit ConstUseList(Node* node) : _node(node) {}

  using const_iterator = ConstUseIterator;
  inline const_iterator begin() const;
  inline const_iterator end() const;

 private:
  Node* _node;
};

class ConstInputIterator;
class ConstInputList final {
 public:
  using value_type = Node*;
  explicit ConstInputList(Node* node) : _node(node) {}

  using const_iterator = ConstInputIterator;
  inline const_iterator begin() const;
  inline const_iterator end() const;

 private:
  Node* _node;
};

class Node {
 public:
  Node(const NodeMeta* meta, int index, NodeType* type)
      : _meta(meta),
        _first_use(nullptr),
        _type(type),
        _idx(index),
        _mark(0),
        _debug_offset(0) {}

  void* operator new(size_t size, void* ptr) { return ptr; }

  Node* input_at(int index) const {
    vmassert(index < input_count() || index < 0, "index out of range");
    return inputs()[index];
  }

  Node** input_ptr(int index) const {
    vmassert(index < input_count() || index < 0, "index out of range");
    return inputs() + index;
  }

  void set_input_at(int index, Node* node) {
    vmassert(index < input_count() || index < 0, "index out of range");
    inputs()[index] = node;
  }

  Use* GetUse(int input_index) {
    Use* use = reinterpret_cast<Use*>(this);
    return &use[-1 - input_index];
  }

  Node* control_at(int index = 0) const {
    vmassert(index < control_end() || index >= control_start(),
             "index out of range");
    return controls()[index];
  }
  Node* depend_at(int index = 0) const {
    vmassert(index < depend_end() || index >= depend_start(),
             "index out of range");
    return depends()[index];
  }
  Node* value_at(int index) const {
    vmassert(index < value_end() || index >= value_start(),
             "index out of range");
    return values()[index];
  }
  int input_count() const { return _meta->intput_count(); }
  int value_in() const { return _meta->_value_in; }
  int depend_in() const { return _meta->_depend_in; }
  int control_in() const { return _meta->_control_in; }
  const NodeMeta* meta() const { return _meta; }
  Opcode opcode() const { return meta()->_opcode; }
  bool is_phi() const {
    return meta()->_opcode == Opcode::OP_Phi ||
           meta()->_opcode == Opcode::OP_DependPhi;
  }
  bool is_meta1() const;
  bool is_dead() const { return opcode() == Opcode::OP_Dead; }

  template <typename T>
  T meta_value() const {
    vmassert(is_meta1(), "must be");
    return reinterpret_cast<const NodeMeta1<T>*>(_meta)->parameter();
  }

  int constant_int_value() const {
    vmassert(opcode() == Opcode::OP_Constant, "must be");
    auto value = meta_value<uint64_t>();
    return static_cast<int>(value);
  }
  bool is_constant() const { return opcode() == Opcode::OP_Constant; }

  void set_meta(const NodeMeta* meta) { _meta = meta; }
  NodeType* type() const { return _type; }
  void set_type(NodeType* type) { _type = type; }
  int index() const { return _idx; }

  uint32_t mark() const { return _mark; }

  void set_mark(uint32_t mark) { _mark = mark; }
  uint32_t debug_offset() const { return _debug_offset; }

  void set_debug_offset(uint32_t val) { _debug_offset = val; }

  void NewInput(int idx, Node* node);
  void ReplaceAllUses(Node* other);
  void ReplaceInput(int idx, Node* node);

  UseList use_list() { return UseList(this); }

  ConstUseList const_use_list() { return ConstUseList(this); }

  ConstInputList const_input_list() { return ConstInputList(this); }

  void Kill(const NodeMeta* meta);
  void print() const;
  void print_json();

  int control_start() const { return 0; }
  int control_end() const { return control_in(); }
  Node** inputs() const {
    return reinterpret_cast<Node**>(reinterpret_cast<intptr_t>(this) +
                                    sizeof(Node));
  }
  Node** values() const { return inputs() + value_start(); }

 private:
  // depend value control
  int depend_start() const { return control_end(); }
  int depend_end() const { return depend_start() + depend_in(); }
  int value_start() const { return depend_end(); }
  int value_end() const { return input_count(); }
  Node** controls() const { return inputs() + control_start(); }
  Node** depends() const { return inputs() + depend_start(); }
  Node** inputs_end() { return inputs() + input_count(); }

  void AddUse(Use* use);
  void DeleteUse(Use* use);

  const NodeMeta* _meta;
  Use* _first_use;
  NodeType* _type;
  int _idx;
  uint32_t _mark;
  int _debug_offset;

  friend class UseIterator;
  friend class ConstUseIterator;
  friend class ConstInputList;
  friend struct Use;
  friend class UseList;
};

class UseIterator {
 private:
  Use* _current;
  Use* _next;

 public:
  UseIterator(Node* node)
      : _current(node->_first_use),
        _next(_current == nullptr ? nullptr : _current->_next) {}
  UseIterator() : _current(nullptr) {}

  Node* operator*() { return _current == nullptr ? nullptr : _current->node(); }

  Use* use() const { return _current; }

  int index() const { return use()->input_index(); }

  bool operator==(const UseIterator& other) const {
    return _current == other._current;
  }

  bool operator!=(const UseIterator& other) const {
    return _current != other._current;
  }

  UseIterator& operator++() {
    vmassert(_current != nullptr, "use iterator is null");
    _current = _next;
    _next = (_current == nullptr) ? nullptr : _current->_next;
    return *this;
  }

  Node* input_node() { return use()->input_node(); }

  bool isInRange(int start, int end) const {
    auto index = use()->_input_index;
    return start <= index && index < end;
  }

  bool IsControlIn() const {
    Node* node = use()->node();
    auto start = node->control_start();
    auto end = node->control_end();
    return isInRange(start, end);
  }

  bool IsDependIn() const {
    Node* node = use()->node();
    auto start = node->depend_start();
    auto end = node->depend_end();
    return isInRange(start, end);
  }

  bool IsValueIn() const {
    Node* node = use()->node();
    auto start = node->value_start();
    auto end = node->value_end();
    return isInRange(start, end);
  }
};

class ConstUseIterator {
 private:
  Use* _current;

 public:
  using difference_type = int;
  using value_type = Node*;
  using pointer = Node**;
  using reference = Node*&;

  ConstUseIterator(Node* node) : _current(node->_first_use) {}
  ConstUseIterator() : _current(nullptr) {}

  Node* operator*() { return _current == nullptr ? nullptr : _current->node(); }

  bool operator==(const ConstUseIterator& other) const {
    return _current == other._current;
  }

  bool operator!=(const ConstUseIterator& other) const {
    return _current != other._current;
  }

  ConstUseIterator& operator++() {
    vmassert(_current != nullptr, "use iterator is null");
    _current = (_current == nullptr) ? nullptr : _current->_next;
    return *this;
  }
};

class ConstInputIterator {
 private:
  Node** _input_ptr;

 public:
  using difference_type = int;
  using value_type = Node*;
  using pointer = Node**;
  using reference = Node*&;

  ConstInputIterator(Node** input_ptr) : _input_ptr(input_ptr) {}

  Node* operator*() { return *_input_ptr; }

  bool operator==(const ConstInputIterator& other) const {
    return _input_ptr == other._input_ptr;
  }

  bool operator!=(const ConstInputIterator& other) const {
    return _input_ptr != other._input_ptr;
  }

  ConstInputIterator& operator++() {
    vmassert(_input_ptr != nullptr, "use iterator is null");
    _input_ptr++;
    return *this;
  }
};

inline UseIterator UseList::begin() const { return UseIterator(this->_node); }

inline UseIterator UseList::end() const { return UseIterator(); }

inline bool UseList::empty() const { return _node->_first_use == nullptr; }

ConstUseIterator ConstUseList::begin() const { return const_iterator(_node); }

ConstUseIterator ConstUseList::end() const { return const_iterator(); }

ConstInputIterator ConstInputList::begin() const {
  return const_iterator(_node->inputs());
}

ConstInputIterator ConstInputList::end() const {
  return const_iterator(_node->inputs_end());
}

inline Node** Use::input_ptr() const {
  Node* node = this->node();
  return node->input_ptr(_input_index);
}

std::ostream& operator<<(std::ostream& os, const NodeType& type);
std::ostream& operator<<(std::ostream& os, const Opcode& opcode);
std::ostream& operator<<(std::ostream& os, const NodeMeta& meta);
std::ostream& operator<<(std::ostream& os, const Node& n);

}  // namespace node
}  // namespace son
#endif  // PRIMJS_SON_NODE_H
