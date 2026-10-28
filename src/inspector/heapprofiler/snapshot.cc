// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "inspector/heapprofiler/snapshot.h"

#include <assert.h>

#include "inspector/heapprofiler/gen.h"
#include "inspector/heapprofiler/heapprofiler.h"

namespace quickjs {

namespace heapprofiler {

HeapEntry* HeapSnapshot::GetEntryById(SnapshotObjectId id) {
  if (entries_by_id_cache_.empty()) {
    entries_by_id_cache_.reserve(entries_.size());
    for (auto& entry : entries_) {
      entries_by_id_cache_.emplace(entry.id(), &entry);
    }
  }
  auto it = entries_by_id_cache_.find(id);
  return it != entries_by_id_cache_.end() ? it->second : nullptr;
}

void HeapSnapshot::RememberLastJsObjectId() {
  max_object_id = profiler_->object_id_maps()->LastAssignedId();
}

void HeapSnapshot::Delete() { profiler_->RemoveSnapshot(this); }

// Share node storage growth and construction across object type cases.
no_inline HeapEntry* HeapSnapshot::AddEntry(HeapEntry::Type type,
                                            const std::string& name,
                                            SnapshotObjectId id, size_t size) {
  entries_.emplace_back(this, static_cast<uint32_t>(entries().size()), type,
                        name, id, size);
  return &entries_.back();
}

no_inline HeapEntry* HeapSnapshot::AddEntry(HeapEntry::Type type,
                                            const char* name,
                                            SnapshotObjectId id, size_t size) {
  entries_.emplace_back(this, static_cast<uint32_t>(entries_.size()), type,
                        name, id, size);
  return &entries_.back();
}

void HeapSnapshot::FillChildren() {
  uint32_t children_index = 0;
  for (auto& entry : entries_) {
    children_index = entry.set_chiledren_index(children_index);
  }
  assert(edges_.size() == static_cast<size_t>(children_index));
  children_.resize(edges_.size());

  for (auto& edge : edges_) {
    edge.from()->add_child(&edge);
  }
}

void HeapSnapshot::SetDiagnosticReference(HeapEntry* from,
                                          const std::string& name,
                                          HeapEntry* to,
                                          Diagnostic diagnostic) {
  if (!to) return;
  from->SetNamedReference(HeapGraphEdge::kInternal, name, to);
  MarkDiagnosticAllocation(to, diagnostic);
}

void HeapSnapshot::MarkDiagnosticAllocation(HeapEntry* entry,
                                            Diagnostic diagnostic) {
  if (!entry || !summarize_diagnostics_) return;
  diagnostic_allocations_.resize(entries_.size(), 0);
  auto& group = diagnostic_allocations_[entry->index()];
  assert(!group || group == static_cast<uint8_t>(diagnostic));
  group = static_cast<uint8_t>(diagnostic);
}

void HeapSnapshot::FilterForSlot(const std::vector<int32_t>& slots,
                                 const std::vector<size_t>& sizes,
                                 const std::vector<bool>& user_visible) {
  assert(slots.size() == entries_.size() && sizes.size() == entries_.size());
  assert(user_visible.empty() || user_visible.size() == entries_.size());
  const auto count = entries_.size();
  auto is_strong = [](const HeapGraphEdge& edge) {
    return edge.type() != HeapGraphEdge::kWeak &&
           edge.type() != HeapGraphEdge::kShortcut;
  };
  // Coverage owns only dedicated blocks. The expensive exclusive-subgraph
  // projection is needed solely for debugger registries and console values.
  diagnostic_allocations_.resize(count, 0);
  auto groups = std::move(diagnostic_allocations_);
  std::vector<uint32_t> pending;
#ifdef ENABLE_QUICKJS_DEBUGGER
  if (summarize_diagnostics_) {
    // Business reachability stops at dedicated diagnostic storage. A console
    // value with another root remains visible.
    std::vector<bool> business(count, false);
    pending.push_back(root_entry_->index());
    business[root_entry_->index()] = true;
    for (size_t i = 0; i < pending.size(); ++i) {
      auto& entry = entries_[pending[i]];
      for (uint32_t j = 0; j < entry.children_count(); ++j) {
        auto* edge = entry.child(j);
        auto to = edge->to()->index();
        if (is_strong(*edge) && !groups[to] && !business[to]) {
          business[to] = true;
          pending.push_back(to);
        }
      }
    }
    pending.clear();
    constexpr auto debugger = static_cast<uint8_t>(Diagnostic::kDebugger);
    for (uint32_t i = 0; i < count; ++i)
      if (groups[i] == debugger) pending.push_back(i);
    for (size_t i = 0; i < pending.size(); ++i) {
      auto& entry = entries_[pending[i]];
      for (uint32_t j = 0; j < entry.children_count(); ++j) {
        auto* edge = entry.child(j);
        auto to = edge->to()->index();
        if (is_strong(*edge) && !business[to] && !groups[to]) {
          groups[to] = debugger;
          pending.push_back(to);
        }
      }
    }
  }
#endif
  auto included = [&](uint32_t i) {
    return include_internal_allocations_ || groups[i] ||
           (user_visible.empty() ? sizes[i] != 0 : user_visible[i]);
  };
  auto visible_edge = [&](const HeapGraphEdge& edge) {
    return !groups[edge.from()->index()] && !groups[edge.to()->index()];
  };

  // CSR incoming edges: preserve all strong retainer paths, including cycles.
  std::vector<size_t> offsets(count + 1, 0);
  for (const auto& edge : edges_) {
    if (is_strong(edge) && visible_edge(edge))
      ++offsets[edge.to()->index() + 1];
  }
  for (size_t i = 1; i <= count; ++i) offsets[i] += offsets[i - 1];
  auto cursor = offsets;
  std::vector<uint32_t> incoming(offsets.back());
  std::vector<bool> cross_slot(count, false);
  for (const auto& edge : edges_) {
    if (!is_strong(edge) || !visible_edge(edge)) continue;
    auto from = edge.from()->index(), to = edge.to()->index();
    incoming[cursor[to]++] = from;
    if (slots[to] == slot_ && slots[from] >= 0 && slots[from] != slot_) {
      cross_slot[to] = true;
    }
  }
  std::vector<bool> keep(count, false), reachable(count, false);
  pending.clear();
  constexpr auto group_count = static_cast<uint8_t>(Diagnostic::kCount);
  size_t summary_bytes[group_count] = {};
  for (const auto& entry : entries_) {
    auto i = entry.index();
    // Compact mode gives internal allocations zero charge. They may still be
    // kept as strong ancestors, but must not seed the target inventory.
    if (slots[i] == slot_ && included(i)) {
      if (groups[i]) {
        summary_bytes[groups[i]] += sizes[i];
        continue;
      }
      keep[entry.index()] = true;
      pending.push_back(entry.index());
    }
  }
  for (size_t i = 0; i < pending.size(); ++i) {
    auto to = pending[i];
    for (auto j = offsets[to]; j < offsets[to + 1]; ++j) {
      auto from = incoming[j];
      if (!keep[from]) {
        keep[from] = true;
        pending.push_back(from);
      }
    }
  }
  // Keep the existing root containers, also for an empty target slot.
  for (size_t i = 0; i < 2 + static_cast<size_t>(Root::kNumberOfRoots); ++i) {
    keep[i] = true;
  }
  pending.assign(1, root_entry_->index());
  reachable[root_entry_->index()] = true;
  for (size_t i = 0; i < pending.size(); ++i) {
    auto& entry = entries_[pending[i]];
    for (uint32_t j = 0; j < entry.children_count(); ++j) {
      const auto& edge = *entry.child(j);
      auto to = edge.to()->index();
      if (is_strong(edge) && visible_edge(edge) && keep[to] && !reachable[to]) {
        reachable[to] = true;
        pending.push_back(to);
      }
    }
  }

  struct Node {
    HeapEntry::Type type;
    std::string name;
    SnapshotObjectId id;
    size_t size;
    bool uncovered;
    bool cross_slot;
  };
  struct Edge {
    HeapGraphEdge::Type type;
    uint32_t from, to, index;
    std::string name;
    bool indexed;
  };
  std::vector<Node> nodes;
  std::vector<Edge> edges;
  std::vector<uint32_t> remap(count);
  for (const auto& entry : entries_) {
    auto i = entry.index();
    if (!keep[i]) continue;
    remap[i] = static_cast<uint32_t>(nodes.size());
    std::string name = entry.name();
    const bool show_owner = included(i);
    const bool target = slots[i] == slot_ && show_owner;
    if (target) {
      name += " [slot=" + std::to_string(slot_) + "]";
    } else if (entry.type() != HeapEntry::kSynthetic && show_owner) {
      name += slots[i] >= 0 ? " [holder slot=" + std::to_string(slots[i]) + "]"
                            : " [holder untracked]";
    }
    nodes.push_back({entry.type(), std::move(name), entry.id(),
                     target ? sizes[i] : 0,
                     !reachable[i] && entry.type() != HeapEntry::kSynthetic,
                     target && cross_slot[i]});
  }
  for (const auto& edge : edges_) {
    auto from = edge.from()->index(), to = edge.to()->index();
    if (visible_edge(edge) && keep[from] && keep[to]) {
      edges.push_back({edge.type(), remap[from], remap[to],
                       edge.IsIndex() ? edge.index() : 0, edge.name(),
                       edge.IsIndex()});
    }
  }
  // Rebuild with contiguous indices. Edges and entries contain snapshot/index
  // pointers, so moving a filtered snapshot's containers would be incorrect.
  entries_by_id_cache_.clear();
  diagnostic_allocations_.clear();
  children_.clear();
  edges_.clear();
  entries_.clear();
  for (const auto& node : nodes)
    AddEntry(node.type, node.name, node.id, node.size);
  root_entry_ = &entries_[0];
  gc_root_entry_ = &entries_[1];
  for (size_t i = 0; i < static_cast<size_t>(Root::kNumberOfRoots); ++i) {
    gc_subroot_entries_[i] = &entries_[i + 2];
  }
  for (const auto& edge : edges) {
    auto* from = &entries_[edge.from];
    auto* to = &entries_[edge.to];
    if (edge.indexed) {
      from->SetIndexedReference(edge.type, edge.index, to);
    } else {
      from->SetNamedReference(edge.type, edge.name, to);
    }
  }
  for (uint32_t i = 1; i < group_count; ++i) {
    if (!summary_bytes[i]) continue;
    // Accounting leaves have stable reserved IDs and no retainer shortcuts.
    const char* name = "[coverage]";
    const char* edge_name = "coverage summary";
#ifdef ENABLE_QUICKJS_DEBUGGER
    if (i == static_cast<uint8_t>(Diagnostic::kDebugger)) {
      name = "[debugger]";
      edge_name = "debugger summary";
    }
#endif
    auto* summary =
        AddEntry(HeapEntry::kNative, name, 2 + i * 2, summary_bytes[i]);
    root_entry_->SetNamedReference(HeapGraphEdge::kInternal, edge_name,
                                   summary);
  }
  HeapEntry* uncovered = nullptr;
  HeapEntry* cross_slot_group = nullptr;
  for (uint32_t i = 0; i < nodes.size(); ++i) {
    // Diagnostics must not alter the node name used by V8 Comparison.
    // Even IDs are reserved here; real entries and GC roots use odd IDs.
    if (nodes[i].uncovered) {
      if (!uncovered) {
        uncovered =
            AddEntry(HeapEntry::kSynthetic, "[root path uncovered]", 0, 0);
        root_entry_->SetNamedReference(HeapGraphEdge::kInternal,
                                       "diagnostic allocations", uncovered);
      }
      uncovered->SetNamedAutoIndexReference(HeapGraphEdge::kWeak, &entries_[i]);
    }
    if (nodes[i].cross_slot) {
      if (!cross_slot_group) {
        cross_slot_group =
            AddEntry(HeapEntry::kSynthetic, "[cross-slot]", 2, 0);
        root_entry_->SetNamedReference(HeapGraphEdge::kInternal,
                                       "cross-slot allocations",
                                       cross_slot_group);
      }
      cross_slot_group->SetNamedAutoIndexReference(HeapGraphEdge::kWeak,
                                                   &entries_[i]);
    }
  }
  FillChildren();
}

void HeapSnapshot::AddSyntheticRootEntries() {
  AddRootEntry();
  AddGcRootEntry();
  AddGcSubRootEntry();
  return;
}

const char* HeapSnapshot::GetSubRootName(Root root) {
  switch (root) {
#define ROOT_CASE(root_id, description) \
  case Root::root_id:                   \
    return description;
    GC_ROOT_ID_LIST(ROOT_CASE)
#undef ROOT_CASE
    default:
      break;
  }
  return nullptr;
}

void HeapSnapshot::AddRootEntry() {
  root_entry_ =
      AddEntry(HeapEntry::kSynthetic, "", HeapObjectIdMaps::kRootEntryId, 0);
}

void HeapSnapshot::AddGcRootEntry() {
  gc_root_entry_ = AddEntry(HeapEntry::kSynthetic, "(GC roots)",
                            HeapObjectIdMaps::kGcRootsObjectId, 0);
  return;
}
void HeapSnapshot::AddGcSubRootEntry() {
  auto first_gc_subroots_id = HeapObjectIdMaps::kGcFirstGcRootsObjectId;
  for (size_t i = 0; i < static_cast<size_t>(Root::kNumberOfRoots); ++i) {
    gc_subroot_entries_[i] =
        AddEntry(HeapEntry::kSynthetic, GetSubRootName(static_cast<Root>(i)),
                 first_gc_subroots_id + i * HeapObjectIdMaps::kObjectIdStep, 0);
  }
  return;
}

}  // namespace heapprofiler
}  // namespace quickjs
