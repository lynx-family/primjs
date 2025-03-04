
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
    return AddEntry(ctx, obj);
  }

  void IterateAndExtractReference(HeapSnapshotGenerator* generator);

 private:
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
  void ExtractFunctionBytecodeReference(LEPUSContext*, HeapEntry*,
                                        const LEPUSFunctionBytecode*);
  void ExtractValueArrayReference(LEPUSContext*, HeapEntry*, const LEPUSValue*,
                                  size_t);
  void ExtractLepusRefReference(LEPUSContext*, HeapEntry*,
                                const LEPUSLepusRef*);

  void ExtractValueReference(LEPUSContext*, HeapEntry*, const LEPUSValue&);
  void ExtractHandleObjReference(LEPUSContext*, HeapEntry*, const HeapObjPtr&);
  HeapObjPtr GetHandleObj(void* ptr);

  bool HasBeExtracted(const HeapPtr& ptr) {
    return has_extractedobj_.find(ptr) != has_extractedobj_.end();
  }

  void InsertExtractedObj(const HeapPtr& ptr) {
    has_extractedobj_.emplace(ptr);
    return;
  }

  HeapSnapshot* snapshot_;
  LEPUSContext* context_;
  HeapSnapshotGenerator* generator_ = nullptr;
  HeapObjectIdMaps* object_id_maps_ = nullptr;

  std::unordered_set<HeapPtr> has_extractedobj_;
};

}  // namespace heapprofiler
}  // namespace quickjs

#endif  // SRC_INSPECTOR_HEAPPROFILER_HEAPEXPLORER_H_
