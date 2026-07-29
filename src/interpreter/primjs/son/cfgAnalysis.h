/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_SON_CFG_ANALYSIS_H_
#define PRIMJS_SON_CFG_ANALYSIS_H_

#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"
#include "primjs/son/nodeGraph.h"

namespace son {
namespace node {

enum class VisitState : uint8_t {
  kUnvisit = 0,
  kPenging,
  kOnStck,
  kVisited,
  kVisited1,
  kUnvisit1 = kVisited,
};

class LoopInfoBase {
 public:
  int _parent;
  int _header;
  int _end;

  LoopInfoBase(int parent, int header, int end)
      : _parent(parent), _header(header), _end(end) {}

  int parent() const { return _parent; }
  int header() const { return _header; }
  int end() const { return _end; }
};

class BasicBlockBase : public base::ZoneObject {
 public:
  class NextBlock : public base::ZoneObject {
   public:
    BasicBlockBase* _to;
    NextBlock* _next;

    NextBlock(BasicBlockBase* to) : _to(to), _next(nullptr) {}

    BasicBlockBase* to() const { return _to; }
    NextBlock* next() const { return _next; }
  };
  int _id;
  int _bb_preds;
  int _bb_succs;
  VisitState _state{VisitState::kUnvisit};
  NextBlock _first_out;
  NextBlock _first_in;

  using value_type = NextBlock*;

  BasicBlockBase(int id)
      : _id(id),
        _bb_preds(0),
        _bb_succs(0),
        _first_out(nullptr),
        _first_in(nullptr) {}

  void set_state(VisitState state) { _state = state; }
  VisitState state() const { return _state; }

  int successor_count() const { return _bb_succs; }

  template <typename T>
  T* successor_at(int index);

  template <typename T>
  T* predecessor_at(int index);

  bool has_succssor() const { return _first_out._to != nullptr; }

  int predecessor_count() const { return _bb_preds; }
  bool has_predssor() const { return _first_in._to != nullptr; }

  BasicBlockBase::NextBlock* first_out() {
    return has_succssor() ? &_first_out : nullptr;
  }
  BasicBlockBase::NextBlock* first_in() {
    return has_predssor() ? &_first_in : nullptr;
  }

  int id() const { return _id; }

  void AddSuccessor(base::Zone* zone, BasicBlockBase* to) {
    _bb_succs++;
    if (_first_out._to == nullptr) {
      _first_out._to = to;
    } else {
      auto new_bb = new (zone) NextBlock(to);
      new_bb->_next = _first_out._next;
      _first_out._next = new_bb;
    }
  }

  void AddPredecessor(base::Zone* zone, BasicBlockBase* to) {
    _bb_preds++;
    if (_first_in._to == nullptr) {
      _first_in._to = to;
    } else {
      auto new_bb = new (zone) NextBlock(to);
      new_bb->_next = _first_in._next;
      _first_in._next = new_bb;
    }
  }

  class const_iterator {
   public:
    NextBlock* _current;

    const_iterator(NextBlock* current)
        : _current(current->_to == nullptr ? nullptr : current) {}
    const_iterator() : _current(nullptr) {}

    bool operator==(const const_iterator& other) const {
      return _current == other._current;
    }

    bool operator!=(const const_iterator& other) const {
      return _current != other._current;
    }

    BasicBlockBase* operator*() { return _current->_to; }

    const_iterator& operator++() {
      vmassert(_current != nullptr, "use iterator is null");
      _current = _current->_next;
      return *this;
    }
  };

  class BlockList {
   public:
    using value_type = BasicBlockBase*;
    explicit BlockList(NextBlock* item) : _item(item) {}

    inline const_iterator begin() const {
      return const_iterator(const_cast<NextBlock*>(_item));
    }
    inline const_iterator end() const { return const_iterator(); }

   private:
    NextBlock* _item;
  };

  BlockList preds() { return BlockList(&_first_in); }

  BlockList succs() { return BlockList(&_first_out); }
};

template <typename T>
inline T* BasicBlockBase::successor_at(int index) {
  int i = 0;
  for (auto bb : succs()) {
    if (i == index) {
      return static_cast<T*>(bb);
    }
    i++;
  }
  return nullptr;
}

template <typename T>
inline T* BasicBlockBase::predecessor_at(int index) {
  int i = 0;
  for (auto bb : preds()) {
    if (i == index) {
      return static_cast<T*>(bb);
    }
    i++;
  }
  return nullptr;
}

class NodeGraph;
class ZoneBase {
 private:
  base::Zone* _zone;

 public:
  ZoneBase(base::Zone* zone) : _zone(zone) {}
  base::Zone* zone() const { return _zone; }
};

class GraphZoneBase : public ZoneBase {
 private:
  NodeGraph* _graph;

 public:
  GraphZoneBase(NodeGraph* graph, base::Zone* zone)
      : ZoneBase(zone), _graph(graph) {}

  NodeGraph* graph() const { return _graph; }
};

}  // namespace node
}  // namespace son

#endif  // PRIMJS_SON_CFG_ANALYSIS_H_
