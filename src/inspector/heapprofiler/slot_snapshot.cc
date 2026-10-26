// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <string>
#include <vector>

#include "gc/collector.h"
#include "gc/collector_ms.h"
#include "gc/ros_allocator.h"
#include "inspector/heapprofiler/gen.h"
#include "inspector/heapprofiler/heapprofiler.h"

namespace quickjs {
namespace heapprofiler {

static bool IsUserVisibleAllocation(int tag) {
  switch (tag) {
    case ALLOC_TAG_LEPUSObject:
    case ALLOC_TAG_JSString:
    case ALLOC_TAG_JSSymbol:
    case ALLOC_TAG_JSSeparableString:
    case ALLOC_TAG_JSBigInt:
      return true;
    default:
      return false;
  }
}

bool HeapSnapshotGenerator::GenerateSnapshotForSlot() {
  auto* rt = LEPUS_GetRuntime(context_);
  auto* rc_allocations = JS_GetRCAllocationSet(rt);
  if (!snapshot_->is_slot_snapshot() ||
      !LEPUS_IsMemorySlotTrackingEnabled(rt) ||
      snapshot_->slot() > rt->malloc_state.max_slot_index ||
      (!rt->gc_enable && !rc_allocations)) {
    return false;
  }
#ifdef ENABLE_COMPATIBLE_MM
  if (rt->gc_enable &&
      (rt->collector_->IsForbidGC() || rt->ros_->InGCPauseSuppressionMode()))
    return false;
#endif
  ScopedCommonMemorySlot common_slot(rt);
  // forceParallel completes prior concurrent work and synchronously sweeps.
  LEPUS_RunGC(rt);
#ifdef ENABLE_COMPATIBLE_MM
  struct ForbidGC {
    ROS_GC::MarkSweepCollector* collector;
    explicit ForbidGC(ROS_GC::MarkSweepCollector* c) : collector(c) {
      if (collector) collector->SetForbidGC();
    }
    ~ForbidGC() {
      if (collector) collector->ResetForbidGC();
    }
  } forbid(rt->gc_enable ? rt->collector_ : nullptr);
#endif

  struct Allocation {
    HeapObjPtr obj;
    size_t size;
    int32_t slot;
  };
  std::vector<Allocation> allocations;
  size_t target_bytes = 0;
  auto record = [&](HeapObjPtr obj, size_t size, int32_t slot) {
    allocations.push_back({obj, size, slot});
    if (slot == snapshot_->slot()) target_bytes += size;
  };
  // Freeze the allocation set before formatting, including for common slot.
#ifdef ENABLE_COMPATIBLE_MM
  if (rt->gc_enable) {
    ROS_GC::HeapAliveObjsVisitor visitor = [&](ROS_GC::HeapObjType,
                                               address_t header) {
      auto* ptr = reinterpret_cast<void*>(header + ROS_GC::kHeaderSize);
      record(
          HeapObjPtr{ptr, static_cast<HeapObjPtr::PtrType>(get_alloc_tag(ptr)),
                     get_obj_size(ptr)},
          rt->ros_->GetAllocatedObjectSize(header), get_memory_slot(ptr));
    };
    rt->ros_->ForEachObj(visitor);
  } else
#endif
  {
    rc_allocations->ForEach([&](void* ptr) {
      size_t size = 0;
      int32_t slot = 0;
      JS_GetRCAllocationInfo(ptr, &size, &slot);
      // RC tags are incomplete. Never interpret an unknown block's contents.
      record(HeapObjPtr{ptr, HeapObjPtr::kWithoutPtr}, size, slot);
    });
  }
  size_t counters[LEPUS_MEMORY_SIZE_SLOTS];
  LEPUS_DumpMemorySlots(rt, counters);
  if (target_bytes != counters[snapshot_->slot()]) return false;

  snapshot_->AddSyntheticRootEntries();
  FillReferences();
  // Census every allocation, even those absent from the business object graph.
  // Existing entries win, so interior views never carry a second charge.
  for (const auto& allocation : allocations) {
    FindOrAddEntry(context_, allocation.obj, &quickjs_heap_explorer_);
  }
  quickjs_heap_explorer_.ExtractRuntimeAllocationReferences();
  if (rt->gc_enable) {
    for (const auto& allocation : allocations) {
      quickjs_heap_explorer_.ExtractAllocationReferences(allocation.obj);
    }
  } else {
    quickjs_heap_explorer_.ExtractRCAllocationReferences();
  }
  std::vector<int32_t> slots(snapshot_->entries().size(), -1);
  std::vector<size_t> sizes(snapshot_->entries().size(), 0);
  std::vector<bool> user_visible(snapshot_->entries().size(), false);
  for (const auto& allocation : allocations) {
    auto* entry = FindEntry(allocation.obj.ptr_);
    assert(entry);
    slots[entry->index()] = allocation.slot;
    // Retain physical charges until projection: compact summaries also include
    // diagnostic native storage, while other internal charges stay excluded.
    sizes[entry->index()] = allocation.size;
    user_visible[entry->index()] =
        IsUserVisibleAllocation(allocation.obj.type_);
  }
  if (!rt->gc_enable)
    quickjs_heap_explorer_.MarkRCUserVisibleAllocations(user_visible);
  snapshot_->FillChildren();
  snapshot_->FilterForSlot(slots, sizes, user_visible);
  ProgressGenResult();
  snapshot_->RememberLastJsObjectId();
  return true;
}

void QjsHeapExplorer::ExtractRCAllocationReferences() {
  for (size_t i = 0; i < rc_objects_.size(); ++i) {
    // Extraction may append entries, invalidating references into the vector.
    HeapObjPtr obj = rc_objects_[i];
    ExtractAllocationReferences(obj);
  }
}

void QjsHeapExplorer::MarkRCUserVisibleAllocations(
    std::vector<bool>& user_visible) {
  for (const auto& obj : rc_objects_) {
    if (IsUserVisibleAllocation(obj.type_)) {
      user_visible[generator_->FindEntry(obj.ptr_)->index()] = true;
    }
  }
}

no_inline void QjsHeapExplorer::SetAllocationReference(
    HeapEntry* entry, const char* name, const void* ptr,
    const char* allocation_name) {
  // Never inspect a header through an arbitrary storage pointer. An existing
  // interior view may have edges, but only census bases receive a byte charge.
  if (auto* child = generator_->FindEntry(ptr)) {
    if (allocation_name) child->set_name(allocation_name);
    SetInternalReference(entry, name, child);
  }
}

no_inline void QjsHeapExplorer::SetDiagnosticAllocationReference(
    HeapEntry* entry, const char* name, const void* ptr,
    HeapSnapshot::Diagnostic diagnostic, const char* allocation_name) {
  if (auto* child = generator_->FindEntry(ptr)) {
    if (allocation_name) child->set_name(allocation_name);
    snapshot_->SetDiagnosticReference(entry, name, child, diagnostic);
  }
}

void QjsHeapExplorer::ExtractRuntimeAllocationReferences() {
  auto* rt = context_->rt;
  auto* runtime = generator_->FindEntry(rt);
  if (!runtime) return;
  // The GC roots this raw bucket array separately from atom_array. Its
  // integer bucket indices are not pointers and must not produce object edges.
  SetAllocationReference(runtime, "atom_hash", rt->atom_hash,
                         "system / atom_hash");
  // Coverage archives outlive bytecode; mirror the Runtime GC roots.
  list_head* el;
  list_for_each(el, &rt->coverage_list) {
    auto* info = list_entry(el, JSCoverageInfo, link);
    constexpr auto coverage = HeapSnapshot::Diagnostic::kCoverage;
    SetDiagnosticAllocationReference(runtime, "coverage_info", info, coverage,
                                     "system / coverage_info");
    if (auto* entry = generator_->FindEntry(info)) {
      SetDiagnosticAllocationReference(entry, "coverage_slots",
                                       info->coverage_slots, coverage);
      SetDiagnosticAllocationReference(entry, "coverage_counters",
                                       info->coverage_counters, coverage);
    }
  }
#ifdef ENABLE_QUICKJS_DEBUGGER
  list_for_each(el, &rt->context_list) {
    auto* ctx = list_entry(el, LEPUSContext, link);
    auto* info = ctx->debugger_info;
    if (!info) continue;
    if (auto* entry = generator_->FindEntry(info)) {
      constexpr auto debugger = HeapSnapshot::Diagnostic::kDebugger;
      SetDiagnosticAllocationReference(entry, "source_code", info->source_code,
                                       debugger);
      SetDiagnosticAllocationReference(entry, "bps", info->bps, debugger);
      if (!rt->gc_enable && info->bps) {
        ExtractAllocationStateReferences(
            generator_->FindEntry(info->bps),
            HeapObjPtr{info->bps, HeapObjPtr::kLEPUSBreakpointArray,
                       sizeof(LEPUSBreakpoint) * info->breakpoints_num});
      }
      SetDiagnosticAllocationReference(entry, "pause_on_next_statement_reason",
                                       info->pause_on_next_statement_reason,
                                       debugger);
    }
  }
#endif
}

no_inline void QjsHeapExplorer::ExtractObjectStorageReferences(
    HeapEntry* entry, const LEPUSObject* p) {
  // Semantic class references already exist in ExtractObjectReference. These
  // edges expose the separately allocated buffers and class state themselves.
  const void* state = nullptr;
  const char* name = nullptr;
  switch (p->class_id) {
    case JS_CLASS_ARRAY:
    case JS_CLASS_ARGUMENTS:
      SetAllocationReference(entry, "elements", p->u.array.u.values);
      if (!context_->gc_enable) {
        ExtractValueArrayReference(context_,
                                   generator_->FindEntry(p->u.array.u.values),
                                   p->u.array.u.values, p->u.array.count, true);
      }
      break;
    case JS_CLASS_BYTECODE_FUNCTION:
    case JS_CLASS_GENERATOR_FUNCTION:
    case JS_CLASS_ASYNC_FUNCTION:
    case JS_CLASS_ASYNC_GENERATOR_FUNCTION:
      SetAllocationReference(entry, "var_refs", p->u.func.var_refs);
      if (!context_->gc_enable && p->u.func.var_refs) {
        auto* refs = generator_->FindEntry(p->u.func.var_refs);
        if (refs) {
          for (int i = 0; i < p->u.func.function_bytecode->closure_var_count;
               ++i) {
            SetAllocationReference(refs, "var_ref", p->u.func.var_refs[i]);
          }
        }
      }
      break;
      // clang-format off
#define STATE(id, field) \
  case id:              \
    state = p->u.field; \
    name = #field;      \
    break;
    STATE(JS_CLASS_BOUND_FUNCTION, bound_function)
    STATE(JS_CLASS_C_FUNCTION_DATA, c_function_data_record)
    STATE(JS_CLASS_FOR_IN_ITERATOR, for_in_iterator)
    case JS_CLASS_ARRAY_BUFFER:
      STATE(JS_CLASS_SHARED_ARRAY_BUFFER, array_buffer)
    case JS_CLASS_UINT8C_ARRAY:
    case JS_CLASS_INT8_ARRAY:
    case JS_CLASS_UINT8_ARRAY:
    case JS_CLASS_INT16_ARRAY:
    case JS_CLASS_UINT16_ARRAY:
    case JS_CLASS_INT32_ARRAY:
    case JS_CLASS_UINT32_ARRAY:
    case JS_CLASS_BIG_INT64_ARRAY:
    case JS_CLASS_BIG_UINT64_ARRAY:
    case JS_CLASS_FLOAT32_ARRAY:
    case JS_CLASS_FLOAT64_ARRAY:
      STATE(JS_CLASS_DATAVIEW, typed_array)
    case JS_CLASS_MAP:
    case JS_CLASS_SET:
    case JS_CLASS_WEAKMAP:
      STATE(JS_CLASS_WEAKSET, map_state)
    case JS_CLASS_MAP_ITERATOR:
      STATE(JS_CLASS_SET_ITERATOR, map_iterator_data)
    case JS_CLASS_ARRAY_ITERATOR:
      STATE(JS_CLASS_STRING_ITERATOR, array_iterator_data)
    STATE(JS_CLASS_REGEXP_STRING_ITERATOR, regexp_string_iterator_data)
    STATE(JS_CLASS_GENERATOR, generator_data)
    STATE(JS_CLASS_PROXY, proxy_data)
    STATE(JS_CLASS_PROMISE, promise_data)
    case JS_CLASS_PROMISE_RESOLVE_FUNCTION:
      STATE(JS_CLASS_PROMISE_REJECT_FUNCTION, promise_function_data)
    case JS_CLASS_ASYNC_FUNCTION_RESOLVE:
      STATE(JS_CLASS_ASYNC_FUNCTION_REJECT, async_function_data)
    STATE(JS_CLASS_ASYNC_FROM_SYNC_ITERATOR, async_from_sync_iterator_data)
    STATE(JS_CLASS_ASYNC_GENERATOR, async_generator_data)
    STATE(JS_CLASS_WeakRef, weak_ref_data)
    STATE(JS_CLASS_FinalizationRegistry, fin_reg_data)
#undef STATE
    // clang-format on
    default:
      break;
  }
  if (state) {
    SetAllocationReference(entry, name, state);
    if (!context_->gc_enable) {
      if (auto* child = generator_->FindEntry(state))
        ExtractClassSpecificReference(context_, child, p);
    }
  }
  if (!context_->gc_enable && p->class_id >= JS_CLASS_MAP &&
      p->class_id <= JS_CLASS_WEAKSET && p->u.map_state) {
    if (auto* state = generator_->FindEntry(p->u.map_state)) {
      SetAllocationReference(state, "hash_table", p->u.map_state->hash_table);
    }
  }
}

void QjsHeapExplorer::ExtractBytecodeStorageReferences(
    HeapEntry* entry, const LEPUSFunctionBytecode* b) {
  if (b->vardefs_ext) SetAllocationReference(entry, "vardefs", b->vardefs);
  constexpr auto coverage = HeapSnapshot::Diagnostic::kCoverage;
  if (b->has_debug) {
#ifdef ENABLE_QUICKJS_DEBUGGER
    constexpr auto debugger = HeapSnapshot::Diagnostic::kDebugger;
    SetDiagnosticAllocationReference(entry, "debug.pc2line",
                                     b->debug.pc2line_buf, debugger);
    SetDiagnosticAllocationReference(entry, "debug.caller_slots",
                                     b->debug.caller_slots, debugger);
    if (!context_->gc_enable && b->debug.caller_slots) {
      ExtractAllocationStateReferences(
          generator_->FindEntry(b->debug.caller_slots),
          HeapObjPtr{b->debug.caller_slots, HeapObjPtr::kCallerStrSlotArray,
                     b->debug.caller_size * sizeof(CallerStrSlot)});
    }
#else
    SetAllocationReference(entry, "debug.pc2line", b->debug.pc2line_buf);
    SetAllocationReference(entry, "debug.caller_slots", b->debug.caller_slots);
#endif
  }
  SetDiagnosticAllocationReference(entry, "coverage_info", b->coverage_info,
                                   coverage);
  SetDiagnosticAllocationReference(entry, "coverage_slots", b->coverage_slots,
                                   coverage);
  SetDiagnosticAllocationReference(entry, "coverage_counters",
                                   b->coverage_counters, coverage);
}

no_inline void QjsHeapExplorer::ExtractAllocationReferences(
    const HeapObjPtr& obj) {
  auto* entry = generator_->FindEntry(obj.ptr_);
  // Reuse the semantic traversal for allocations not encountered from roots.
  // Object extraction also adds shape/property storage edges exactly once.
  ExtractHandleObjReference(context_, entry, obj);
  switch (obj.type_) {
    case HeapObjPtr::kLEPUSObject:
      ExtractObjectStorageReferences(entry,
                                     static_cast<const LEPUSObject*>(obj.ptr_));
      break;
    case HeapObjPtr::kLEPUSFunctionBytecode:
      ExtractBytecodeStorageReferences(
          entry, static_cast<const LEPUSFunctionBytecode*>(obj.ptr_));
      break;
    default:
      ExtractAllocationStateReferences(entry, obj);
      break;
  }
}

no_inline void QjsHeapExplorer::ExtractAllocationStateReferences(
    HeapEntry* entry, const HeapObjPtr& obj) {
  if (!entry) return;
  auto* ctx = context_;
  switch (obj.type_) {
    case HeapObjPtr::kCallerStrSlotArray: {
      auto* slots = static_cast<const CallerStrSlot*>(obj.ptr_);
      for (size_t i = 0; i < obj.size_ / sizeof(CallerStrSlot); ++i) {
        if (slots[i].is_str)
#ifdef ENABLE_QUICKJS_DEBUGGER
          SetDiagnosticAllocationReference(entry, "caller", slots[i].str,
                                           HeapSnapshot::Diagnostic::kDebugger);
#else
          SetAllocationReference(entry, "caller", slots[i].str);
#endif
      }
      break;
    }
    case HeapObjPtr::kJSValueArray: {
      // RC backing arrays are visited through their owner's live count.
      if (!ctx->gc_enable) break;
      ExtractValueArrayReference(ctx, entry,
                                 static_cast<const LEPUSValue*>(obj.ptr_),
                                 obj.size_ / sizeof(LEPUSValue), true);
      break;
    }
    case HeapObjPtr::kJSPropertyArray:
      // The owner's shape is required to interpret this union safely.
      // ExtractObjectReference handles only live properties.
      break;
    case HeapObjPtr::kJSVarRefPtrArray: {
      auto* refs = static_cast<JSVarRef* const*>(obj.ptr_);
      for (size_t i = 0; i < obj.size_ / sizeof(JSVarRef*); ++i) {
        SetAllocationReference(entry, "var_ref", refs[i]);
      }
      break;
    }
    case HeapObjPtr::kJSSeparableString: {
      auto* str = static_cast<const JSSeparableString*>(obj.ptr_);
      if (!LEPUS_IsUndefined(str->flat_content)) {
        SetAndExtractValue(ctx, entry, "flat_content", str->flat_content);
      } else {
        SetAndExtractValue(ctx, entry, "left", str->left_op);
        SetAndExtractValue(ctx, entry, "right", str->right_op);
      }
      break;
    }
    case HeapObjPtr::kJSArrayBuffer: {
      auto* s = static_cast<const JSArrayBuffer*>(obj.ptr_);
      if (s->from_js_heap) SetAllocationReference(entry, "data", s->data);
      break;
    }
    case HeapObjPtr::kJSTypedArray: {
      auto* s = static_cast<const JSTypedArray*>(obj.ptr_);
      SetAllocationReference(entry, "buffer", s->buffer);
      break;
    }
    case HeapObjPtr::kJSMapState: {
      auto* s = static_cast<const JSMapState*>(obj.ptr_);
      SetAllocationReference(entry, "hash_table", s->hash_table);
      ExtractMapReference(ctx, entry, s);
      break;
    }
    case HeapObjPtr::kJSMapRecord: {
      auto* s = static_cast<const JSMapRecord*>(obj.ptr_);
      ExtractMapRecordReference(ctx, entry, s, s->map && s->map->is_weak);
      break;
    }
    case HeapObjPtr::kJSBoundFunction: {
      ExtractBoundFunctionReference(
          ctx, entry, static_cast<const JSBoundFunction*>(obj.ptr_));
      break;
    }
    case HeapObjPtr::kJSProxyData: {
      ExtractProxyReference(ctx, entry,
                            static_cast<const JSProxyData*>(obj.ptr_));
      break;
    }
    case HeapObjPtr::kJSPromiseData:
      ExtractPromiseReference(ctx, entry,
                              static_cast<const JSPromiseData*>(obj.ptr_));
      break;
#ifdef ENABLE_QUICKJS_DEBUGGER
    case HeapObjPtr::kLEPUSBreakpointArray: {
      auto* bps = static_cast<const LEPUSBreakpoint*>(obj.ptr_);
      for (size_t i = 0; i < obj.size_ / sizeof(LEPUSBreakpoint); ++i) {
        SetDiagnosticAllocationReference(entry, "script_url", bps[i].script_url,
                                         HeapSnapshot::Diagnostic::kDebugger);
        SetAndExtractValue(ctx, entry, "breakpoint_id", bps[i].breakpoint_id);
        SetAndExtractValue(ctx, entry, "condition", bps[i].condition);
      }
      break;
    }
    case HeapObjPtr::kLEPUSScriptSource: {
      auto* script = static_cast<const LEPUSScriptSource*>(obj.ptr_);
      // These dedicated blocks need only classification for accounting.
      // Keep no script storage edges or purpose strings in the snapshot.
      constexpr auto debugger = HeapSnapshot::Diagnostic::kDebugger;
      snapshot_->MarkDiagnosticAllocation(entry, debugger);
      for (const void* ptr : {script->url, script->source, script->hash,
                              script->source_map_url}) {
        snapshot_->MarkDiagnosticAllocation(generator_->FindEntry(ptr),
                                            debugger);
      }
      break;
    }
#endif
    default:
      break;
  }
}

}  // namespace heapprofiler
}  // namespace quickjs
