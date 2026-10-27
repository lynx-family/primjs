
// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INSPECTOR_HEAPPROFILER_HEAPEXPLORER_H_
#define SRC_INSPECTOR_HEAPPROFILER_HEAPEXPLORER_H_

#include <string>
#include <unordered_set>
#include <vector>

#include "inspector/heapprofiler/snapshot.h"
#include "quickjs/include/quickjs-inner.h"

struct JSString;
struct JSAsyncFunctionData;
struct JSShape;
struct JSVarRef;
struct WeakRefRecord;

namespace quickjs {
namespace heapprofiler {

class HeapSnapshotGenerator;
class HeapObjectIdMaps;

#define OPERATOR_CONTEXT_MEMBER(V) \
  V(function_proto)                \
  V(function_ctor)                 \
  V(regexp_ctor)                   \
  V(promise_ctor)                  \
  V(iterator_proto)                \
  V(async_iterator_proto)          \
  V(array_proto_values)            \
  V(throw_type_error)              \
  V(eval_obj)                      \
  V(global_obj)                    \
  V(global_var_obj)

class HeapEntriesAllocator {
 public:
  virtual ~HeapEntriesAllocator() = default;
  virtual HeapEntry* AllocateEntry(LEPUSContext*, const LEPUSValue& value) = 0;
  virtual HeapEntry* AllocateEntry(LEPUSContext*, const HeapObjPtr&) = 0;
};

class QjsHeapExplorer : public HeapEntriesAllocator {
 public:
  QjsHeapExplorer(HeapSnapshot* snapshot, LEPUSContext* ctx);
  ~QjsHeapExplorer() override;
  QjsHeapExplorer(const QjsHeapExplorer&) = delete;
  QjsHeapExplorer& operator=(const QjsHeapExplorer&) = delete;

  static bool HasEntry(const LEPUSValue& value) {
    return LEPUS_VALUE_HAS_REF_COUNT(value);
  }

  HeapEntry* AllocateEntry(LEPUSContext* ctx,
                           const LEPUSValue& value) override {
    return AddEntry(ctx, value);
  }
  HeapEntry* AllocateEntry(LEPUSContext* ctx, const HeapObjPtr& obj) override {
    return snapshot_->is_slot_snapshot() ? AddEntryForSlot(ctx, obj)
                                         : AddEntry(ctx, obj);
  }

  void IterateAndExtractReference(HeapSnapshotGenerator* generator);
  // Slot-only: reuse semantic traversal and expose separately allocated
  // storage.
  void ExtractAllocationReferences(const HeapObjPtr& obj);
  void ExtractRuntimeAllocationReferences();
  void ExtractRCAllocationReferences();
  void MarkRCUserVisibleAllocations(std::vector<bool>& user_visible);

 private:
  static std::string AtomName(LEPUSContext* ctx, JSAtom atom);
  HeapEntry* AddEntryForSlot(LEPUSContext*, const HeapObjPtr&);
  void SetAllocationReference(HeapEntry*, const char* name, const void* ptr,
                              const char* allocation_name = nullptr);
  void SetDiagnosticAllocationReference(HeapEntry*, const char* name,
                                        const void* ptr,
                                        HeapSnapshot::Diagnostic,
                                        const char* allocation_name = nullptr);
  void ExtractObjectStorageReferences(HeapEntry*, const LEPUSObject*);
  void ExtractBytecodeStorageReferences(HeapEntry*,
                                        const LEPUSFunctionBytecode*);
  void ExtractAllocationStateReferences(HeapEntry*, const HeapObjPtr&);
  // used for a new object(node)
  HeapEntry* GetEntry(LEPUSContext*, const LEPUSValue&);
  HeapEntry* GetEntry(LEPUSContext*, const HeapObjPtr&);

  HeapEntry* AddEntry(LEPUSContext*, const LEPUSValue&);
  HeapEntry* AddEntry(LEPUSContext*, const HeapObjPtr&);

  void SetInternalReference(HeapEntry* parent_entry, const std::string& name,
                            HeapEntry* child) {
    if (child) {
      parent_entry->SetNamedReference(HeapGraphEdge::kInternal, name, child);
    }
    return;
  }
  void SetInternalReference(HeapEntry* parent, const char* name,
                            HeapEntry* child);

  void SetElementReference(HeapEntry* parent_entry, uint32_t index,
                           HeapEntry* child);  // for array

  void SetPropertyReference(LEPUSContext*, HeapEntry*, JSAtom, HeapEntry*,
                            HeapGraphEdge::Type = HeapGraphEdge::kProperty);
  void SetPropertyReference(HeapEntry*, const std::string&, HeapEntry*,
                            HeapGraphEdge::Type = HeapGraphEdge::kProperty);

  // root ---> gc_root
  void SetRootToGcRootReference();
  // gc_root ---> {stack, handleScope, contxt, runtime...}
  void SetGcRootReference(Root);
  // root_ ---> global_var_obj
  void SetUserGlobalReference();
  // root_ ---> global_obj
  void SetRootToGlobalReference();

  // gc_root ---> stack_node --> {...}
  void ExtractGcRootStackReference();
  // gc_root ---> handle_scope_node ---> {...}
  void ExtractGcRootHandleReference();
  // gc_root ---> context_list_node ---> {JSContext...}
  void ExtractGcRootContextReference();
  // gc_root ---> runtime_node ---> {}
  void ExtractGcRootRuntimeReference();
  void ExtractGcRootGlobalHandleReference();
  void SetGcRootObjectReference();

  void ExtractContextReference(LEPUSContext*, HeapEntry*);
  void ExtractRuntimeReference(LEPUSContext*, HeapEntry*, LEPUSRuntime*);
  void ExtractObjectReference(LEPUSContext*, HeapEntry*, const LEPUSObject*);
  void ExtractShapeReference(LEPUSContext*, HeapEntry*, const JSShape*);
  void ExtractVarrefReference(LEPUSContext*, HeapEntry*, const JSVarRef*);
  void ExtractPropertyGetSetReference(LEPUSContext*, HeapEntry*,
                                      const JSPropertyGetSet*);
  void ExtractFunctionBytecodeReference(LEPUSContext*, HeapEntry*,
                                        const LEPUSFunctionBytecode*);
  void ExtractValueArrayReference(LEPUSContext*, HeapEntry*, const LEPUSValue*,
                                  size_t, bool from_allocation = false);
  void ExtractLepusRefReference(LEPUSContext*, HeapEntry*,
                                const LEPUSLepusRef*);
  void ExtractModuleReference(LEPUSContext*, HeapEntry*, const LEPUSModuleDef*);
  void ExtractNapiHandleScopeReference(LEPUSContext*, HeapEntry*);
  void ExtractDebuggerInfoFromContext(LEPUSContext*, HeapEntry*);
  void ExtractStackFrameDebuggerThis(LEPUSContext*, HeapEntry*,
                                     const LEPUSStackFrame*);

  void ExtractValueReference(LEPUSContext*, HeapEntry*, const LEPUSValue&);
  void ExtractHandleObjReference(LEPUSContext*, HeapEntry*, const HeapObjPtr&);
  HeapObjPtr GetHandleObj(void* ptr);

  // class-specific object reference extraction, mirrors GC's VisitXxx.
  void ExtractClassSpecificReference(LEPUSContext*, HeapEntry*,
                                     const LEPUSObject*);
  void ExtractBoundFunctionReference(LEPUSContext*, HeapEntry*,
                                     const JSBoundFunction*);
  void ExtractProxyReference(LEPUSContext*, HeapEntry*, const JSProxyData*);
  void ExtractMapReference(LEPUSContext*, HeapEntry*, const JSMapState*);
  void ExtractMapRecordReference(LEPUSContext*, HeapEntry*, const JSMapRecord*,
                                 bool weak_key);
  void ExtractPromiseReference(LEPUSContext*, HeapEntry*, const JSPromiseData*);
  void ExtractFinalizationRegistryReference(LEPUSContext*, HeapEntry*,
                                            const FinalizationRegistryData*);
  void ExtractFinalizationRegistryEntryReference(
      LEPUSContext*, HeapEntry*, const FinalizationRegistryEntry*);
  void ExtractWeakRefRecordReference(LEPUSContext*, HeapEntry*,
                                     const WeakRefRecord*);
  void ExtractAsyncFunctionStateReference(LEPUSContext*, HeapEntry*,
                                          const JSAsyncFunctionState*);
  void ExtractStackFrameReference(LEPUSContext*, HeapEntry*,
                                  const LEPUSStackFrame*);
  void ExtractRuntimeRootReference(LEPUSContext*, HeapEntry*, LEPUSRuntime*);
  void ExtractJobListReference(LEPUSContext*, HeapEntry*, LEPUSRuntime*);
  void ExtractUnhandledRejectionReference(LEPUSContext*, HeapEntry*,
                                          LEPUSRuntime*);

  struct RootVisitorData {
    QjsHeapExplorer* explorer;
    LEPUSContext* ctx;
    HeapEntry* entry;
  };
  static void VisitGlobalHandleRoot(LEPUSValue, void*);

  // create a child node for `value`, add a named edge from `parent`, and
  // recurse into the child. No-op if `value` has no heap entry.
  void SetAndExtractValue(LEPUSContext*, HeapEntry* parent,
                          const std::string& name, const LEPUSValue& value,
                          HeapGraphEdge::Type = HeapGraphEdge::kInternal);
  void SetAndExtractValue(LEPUSContext*, HeapEntry* parent, const char* name,
                          const LEPUSValue& value,
                          HeapGraphEdge::Type = HeapGraphEdge::kInternal);

  // Keep hash-table operations out of the individual extraction methods.
  no_inline bool HasBeExtracted(const HeapPtr& ptr) {
    return has_extractedobj_.find(ptr) != has_extractedobj_.end();
  }

  no_inline void InsertExtractedObj(const HeapPtr& ptr) {
    has_extractedobj_.emplace(ptr);
    return;
  }

  HeapSnapshot* snapshot_;
  LEPUSContext* context_;
  HeapSnapshotGenerator* generator_ = nullptr;
  HeapObjectIdMaps* object_id_maps_ = nullptr;

  std::unordered_set<HeapPtr> has_extractedobj_;
  // Snapshot-local type information; RC allocations carry no type metadata.
  std::vector<HeapObjPtr> rc_objects_;

#ifdef ENABLE_QUICKJS_DEBUGGER
  void ExtractDebuggerInfoReference(LEPUSContext*, HeapEntry*,
                                    LEPUSDebuggerInfo*);
#endif
};

}  // namespace heapprofiler
}  // namespace quickjs

#endif  // SRC_INSPECTOR_HEAPPROFILER_HEAPEXPLORER_H_
