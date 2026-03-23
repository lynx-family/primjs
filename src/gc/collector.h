// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_GC_COLLECTOR_H_
#define SRC_GC_COLLECTOR_H_

#include <mutex>
#include <sstream>

#include "gc/alloc_utils.h"
#include "gc/gc_work_stack.h"
#include "gc/sizes.h"
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

enum HandleType;
class Visitor;
class Finalizer;
typedef struct JSString JSAtomStruct;
struct LEPUSRuntime;
struct JSAsyncFunctionState;
struct JSProperty;
struct JSRegExp;
struct BCReaderState;
struct JSToken;
struct ValueBuffer;

force_inline void SetRunSlotHasFinalizer(LEPUSRuntime *rt, void *ptr) {
  rt->finalizerSet->insert(ptr);
}

static no_inline void CombinedWriteBarrier(address_t new_field_value) {
  if (!new_field_value) return;
  // could remove atomic later?
  ROS_GC::Bitmap *mark_bitmap =
      ROS_GC::PageGroups::GetBitMapFromAddr(new_field_value);
  ROSIMPL_ASSERT(mark_bitmap, "mark_bitmap is null");
  // abort, todo , -header
  address_t new_field_value_addr =
      reinterpret_cast<address_t>(new_field_value) - ROS_GC::kHeaderSize;
  if (!mark_bitmap->MarkObject(new_field_value_addr)) {
    mark_bitmap->PushBarrierRef((address_t)new_field_value);
  }
}
force_inline void *StaticVisitRootLEPUSValue(LEPUSValue val) {
  int64_t tag = LEPUS_VALUE_GET_TAG(val);
  void *ptr = LEPUS_VALUE_GET_PTR(val);
  switch (tag) {
    case LEPUS_TAG_STRING:
      // if (IsConstString(ptr)) return nullptr;
      return ptr;
    case LEPUS_TAG_SEPARABLE_STRING:
    case LEPUS_TAG_FUNCTION_BYTECODE:
    case LEPUS_TAG_LEPUS_REF:
    case LEPUS_TAG_SYMBOL:
    case LEPUS_TAG_BIG_INT:
    case LEPUS_TAG_OBJECT: {
      return ptr;
    }
    default:
      // printf("__JS_FreeValue: unknown tag=%d\n", tag);
      return nullptr;
  }
}

#ifdef ENABLE_COMPATIBLE_MM
void force_inline HeapObjStore(LEPUSContext *ctx, void *fieldAddr,
                               void *value) {
  *reinterpret_cast<address_t *>(fieldAddr) = (address_t)value;
  if (UNLIKELY(ctx->con_mark_state)) {
    CombinedWriteBarrier((address_t)value);
  }
}

void force_inline HeapObjStore(LEPUSContext *ctx, void *fieldAddr,
                               LEPUSValue value) {
  *reinterpret_cast<LEPUSValue *>(fieldAddr) = value;
  if (UNLIKELY(ctx->con_mark_state)) {
    // todo, postpone call VisitRootLEPUSValue
    CombinedWriteBarrier((address_t)StaticVisitRootLEPUSValue(value));
  }
}
void force_inline WriteBarrierNoStore(LEPUSRuntime *rt, void *value) {
  if (UNLIKELY(rt->con_mark_state)) {
    CombinedWriteBarrier((address_t)value);
  }
}
void force_inline WriteBarrierNoStore(LEPUSContext *ctx, LEPUSValue value) {
  if (UNLIKELY(ctx->con_mark_state)) {
    CombinedWriteBarrier((address_t)StaticVisitRootLEPUSValue(value));
  }
}
void force_inline WriteBarrierNoStore(LEPUSContext *ctx, void *value) {
  if (UNLIKELY(ctx->con_mark_state)) {
    CombinedWriteBarrier((address_t)value);
  }
}

void force_inline HeapObjStoreNoCtx(void *fieldAddr, void *value) {
  *reinterpret_cast<address_t *>(fieldAddr) = (address_t)value;
  if (UNLIKELY(ROS_GC::PageGroups::GetIsConcurrentMarkingFromAddr(
          reinterpret_cast<address_t>(fieldAddr)))) {
    CombinedWriteBarrier((address_t)value);
  }
}
void force_inline HeapObjStoreNoCtx(void *fieldAddr, LEPUSValue value) {
  *reinterpret_cast<LEPUSValue *>(fieldAddr) = value;
  if (UNLIKELY(ROS_GC::PageGroups::GetIsConcurrentMarkingFromAddr(
          reinterpret_cast<address_t>(fieldAddr)))) {
    // todo, postpone call VisitRootLEPUSValue
    CombinedWriteBarrier((address_t)StaticVisitRootLEPUSValue(value));
  }
}
void force_inline *js_malloc_rt_gc(LEPUSRuntime *rt, size_t size,
                                   int alloc_tag) {
  return (void *)ROS_GC::RosAllocImpl::AllocateObj(rt, size, alloc_tag);
}

void force_inline *js_realloc_rt_gc(LEPUSRuntime *rt, void *ptr, size_t size,
                                    int alloc_tag) {
  return (void *)ROS_GC::RosAllocImpl::ReallocateObj(rt, ptr, size, alloc_tag);
}
void force_inline *lepus_malloc_gc(LEPUSContext *ctx, size_t size,
                                   int alloc_tag) {
  void *ptr;
  ptr = (void *)ROS_GC::RosAllocImpl::AllocateObj(ctx->rt, size, alloc_tag);
  // ptr = js_malloc_rt_gc(ctx->rt, size, alloc_tag);
  if (unlikely(!ptr)) {
    LEPUS_ThrowOutOfMemory(ctx);
    return NULL;
  }
  return ptr;
}
#else
void force_inline HeapObjStore(LEPUSContext *ctx, void *fieldAddr,
                               void *value) {
  *reinterpret_cast<address_t *>(fieldAddr) = (address_t)value;
}
void force_inline HeapObjStore(LEPUSContext *ctx, void *fieldAddr,
                               LEPUSValue value) {
  *reinterpret_cast<LEPUSValue *>(fieldAddr) = value;
}
void force_inline WriteBarrierNoStore(LEPUSRuntime *rt, void *value) {}
void force_inline WriteBarrierNoStore(LEPUSContext *ctx, LEPUSValue value) {}
void force_inline WriteBarrierNoStore(LEPUSContext *ctx, void *value) {}

void force_inline HeapObjStoreNoCtx(void *fieldAddr, LEPUSValue value) {
  *reinterpret_cast<LEPUSValue *>(fieldAddr) = value;
}
void force_inline HeapObjStoreNoCtx(void *fieldAddr, void *value) {
  *reinterpret_cast<address_t *>(fieldAddr) = (address_t)value;
}
#endif  // ENABLE_COMPATIBLE_MM

static force_inline void Release_Store(void *fieldAddr, void *value) {
  std::atomic_store_explicit(
      reinterpret_cast<std::atomic<address_t> *>(fieldAddr), (address_t)value,
      std::memory_order_release);
}
static force_inline void *Acquire_Load(void *fieldAddr) {
  return reinterpret_cast<void *>(std::atomic_load_explicit(
      reinterpret_cast<std::atomic<address_t> *>(fieldAddr),
      std::memory_order_acquire));
}

static force_inline void Release_Store8(void *fieldAddr, uint8_t value) {
  std::atomic_store_explicit(
      reinterpret_cast<std::atomic<uint8_t> *>(fieldAddr), value,
      std::memory_order_release);
}
static force_inline uint8_t Acquire_Load8(void *fieldAddr) {
  return std::atomic_load_explicit(
      reinterpret_cast<std::atomic<uint8_t> *>(fieldAddr),
      std::memory_order_acquire);
}

class Visitor {
 public:
  std::atomic<bool> doParallelScan{true};
  static constexpr int kAtomSplitSize = 3;
  Visitor(LEPUSRuntime *rt, Finalizer *finalizer_val) noexcept
      : rt_(rt), finalizer(finalizer_val) {}
  ~Visitor() {}
  static void *StaticVisitRootLEPUSValue(LEPUSValue val) noexcept;
  void *VisitRootLEPUSValue(LEPUSValue val) noexcept;
  void AddObjectDuringFinalizer(void *ptr) {
    finalizerObj_++;
    CombinedWriteBarrier((address_t)ptr);
  }
  void AddObjectDuringFinalizer(LEPUSValue val) {
    void *ptr = StaticVisitRootLEPUSValue(val);
    if (ptr) {
      AddObjectDuringFinalizer(ptr);
    }
  }
  bool HasObjsDuringFinalizer() { return finalizerObj_ != 0; }
  size_t GetAsyncStackSize() { return rt_->async_obj_recoder->size(); }
  void ReleaseFinalizerObj() { finalizerObj_ = 0; }

 public:
  void ScanStack(GCWorkStack &workStack) noexcept;
  void ScanAsyncStack(GCWorkStack &workStack) noexcept;
  void ScanRuntime(GCWorkStack &workStack, bool isFinalRemark,
                   bool markWeak) noexcept;
  void ScanShapeArray(GCWorkStack &workStack) noexcept;
  void ScanHandles(GCWorkStack &workStack) noexcept;
  void ScanContext(GCWorkStack &workStack, bool isFinalRemark) noexcept;

  static void GetHandlePtr(void *ptr, HandleType type,
                           GCWorkStack &workStack) noexcept;
  static JSString *GetCStringPtr(const char *cstr) noexcept;
  static void GetLEPUSTokenPtr(JSToken *token, GCWorkStack &workStack) noexcept;
  static void GetBCReaderStatePtr(BCReaderState *s,
                                  GCWorkStack &workStack) noexcept;
  static void GetValueBufferPtr(ValueBuffer *b,
                                GCWorkStack &workStack) noexcept;

  // visitor
  /* LEPUSValue with tag -> begin */
  static void VisitLEPUSLepusRef(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSShape(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSVarRef(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSAsyncVarRef(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitLEPUSFunctionBytecode(void *ptr,
                                         GCWorkStack &workStack) noexcept;
  static void VisitLEPUSObject(void *ptr, GCWorkStack &workStack) noexcept;
  /* LEPUSValue with tag -> end */
  // LEPUS_TAG_BIG_INT
  /* LEPUSObject with class_id -> begin */
  static void VisitJSBoundFunction(
      void *ptr,
      GCWorkStack &workStack) noexcept;  // normal_free
  static void VisitJSCFunctionDataRecord(
      void *ptr,
      GCWorkStack &workStack) noexcept;  // normal_free
  static void VisitJSForInIterator(
      void *ptr,
      GCWorkStack &workStack) noexcept;  // normal_free
  static void VisitJSArrayBuffer(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSTypedArray(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSMapState(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSMapRecord(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSMapIteratorData(void *ptr,
                                     GCWorkStack &workStack) noexcept;
  static void VisitJSArrayIteratorData(
      void *ptr,
      GCWorkStack &workStack) noexcept;  // normal_free
  static void VisitJSRegExpStringIteratorData(
      void *ptr,
      GCWorkStack &workStack) noexcept;  // normal_free
  static void VisitJSGeneratorData(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSProxyData(void *ptr,
                               GCWorkStack &workStack) noexcept;  // normal_free
  static void VisitJSPromiseData(
      void *ptr, GCWorkStack &workStack) noexcept;  // normal_free
  static void VisitJSPromiseReactionData(
      void *ptr,
      GCWorkStack &workStack) noexcept;  // normal_free
  static void VisitJSPromiseFunctionData(
      void *ptr,
      GCWorkStack &workStack) noexcept;  // normal_free
  static void VisitJSAsyncFunctionData(void *ptr,
                                       GCWorkStack &workStack) noexcept;
  static void VisitJSAsyncFromSyncIteratorData(
      void *ptr,
      GCWorkStack &workStack) noexcept;  // normal_free
  static void VisitJSAsyncGeneratorData(void *ptr,
                                        GCWorkStack &workStack) noexcept;
  /* LEPUSObject with class_id -> end */
  // scan context
  static void VisitLEPUSScriptSource(void *ptr,
                                     GCWorkStack &workStack) noexcept;
  // other
  static void VisitLEPUSModuleDef(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSFunctionDef(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSSeparableString(void *ptr,
                                     GCWorkStack &workStack) noexcept;
  static void VisitLEPUSDebuggerInfo(void *, GCWorkStack &workStack) noexcept;
  static void VisitFinalizationRegistryData(void *ptr,
                                            GCWorkStack &workStack) noexcept;

  static void VisitJSAsyncGeneratorRequest(void *ptr,
                                           GCWorkStack &workStack) noexcept;
  static void VisitWeakRefRecord(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitFinalizationRegistryEntry(void *ptr,
                                             GCWorkStack &workStack) noexcept;
  static void VisitRelocEntry(void *ptr, GCWorkStack &workStack) noexcept;

  static void VisitJSValueArray(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitLabelSlotArray(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSPropertyArray(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitCallerStrSlotArray(void *ptr,
                                      GCWorkStack &workStack) noexcept;
  static void VisitLEPUSPropertyEnumArray(void *ptr,
                                          GCWorkStack &workStack) noexcept;
  static void VisitJSVarRefPtrArray(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSReqModuleEntryArray(void *ptr,
                                         GCWorkStack &workStack) noexcept;
  static void VisitJSExportEntryArray(void *ptr,
                                      GCWorkStack &workStack) noexcept;
  static void VisitJSImportEntryArray(void *ptr,
                                      GCWorkStack &workStack) noexcept;
  static void VisitValueSlotArray(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJsonStrArray(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitLEPUSBreakpointArray(void *ptr,
                                        GCWorkStack &workStack) noexcept;
  static void VisitAtomArray(void *ptr, GCWorkStack &workStack) noexcept;
  static void VisitJSResolveEntryArray(void *ptr,
                                       GCWorkStack &workStack) noexcept;

  // push ptr
  static no_inline void PushObjLEPUSValue(LEPUSValue val,
                                          GCWorkStack &workStack) noexcept;
  static void PushObjAtom(LEPUSAtom atom, GCWorkStack &workStack) noexcept;
  static void *GetAtomObj(LEPUSAtom atom, GCWorkStack &workStack) noexcept;
  static void PushObjLEPUSAsyncFunctionState(JSAsyncFunctionState *s,
                                             GCWorkStack &workStack) noexcept;
  static void PushObjLEPUSStackFrame(LEPUSStackFrame *sf,
                                     GCWorkStack &workStack) noexcept;
  static void PushBytecodeAtoms(const uint8_t *bc_buf, int bc_len,
                                int use_short_opcodes,
                                GCWorkStack &workStack) noexcept;
  static void PushObjFunc(LEPUSObject *obj, GCWorkStack &workStack) noexcept;
  static void PushObjRegExp(LEPUSObject *obj, GCWorkStack &workStack) noexcept;
  static void PushObjProperty(JSProperty *pr, GCWorkStack &workStack) noexcept;

  void DoFinalizer(void *ptr);

  // tools
  static bool IsConstString(void *ptr) {
    return get_alloc_tag(ptr) == ALLOC_TAG_JSConstString;
  }

  // field
 public:
  LEPUSRuntime *rt_;
  Finalizer *finalizer;
  int finalizerObj_{0};
};

static force_inline void WriteBarrierNoStoreCStr(LEPUSContext *ctx,
                                                 const char *value) {
  if (UNLIKELY(ctx->con_mark_state)) {
    CombinedWriteBarrier((address_t)Visitor::GetCStringPtr(value));
  }
}

static force_inline void WriteBarrierNoStoreNoCheck(LEPUSValue value) {
  CombinedWriteBarrier((address_t)Visitor::StaticVisitRootLEPUSValue(value));
}

static __attribute__((unused)) void ReallocJsonStrArrayWB(LEPUSContext *ctx,
                                                          const char ***str_arr,
                                                          size_t ts) {
  for (size_t i = 0; i < ts; ++i) {
    CombinedWriteBarrier((address_t)Visitor::GetCStringPtr((*str_arr)[i]));
  }
}

class Finalizer {
 public:
  Finalizer(LEPUSRuntime *rt) noexcept : rt_(rt) {}
  void free_atom(LEPUSRuntime *rt, JSAtomStruct *p) noexcept;
  // do finalizer
  void DoGlobalFinalizer() noexcept;
  void DoFinalizer2(void *ptr) noexcept;
#ifdef ENABLE_LEPUSNG
  void JSLepusRefFinalizer(void *ptr) noexcept;
#endif
  void JSObjectFinalizer(void *ptr) noexcept;
  void JSObjectOnlyFinalizer(void *ptr) noexcept;
  void JSStringFinalizer(void *ptr) noexcept;
#ifdef ENABLE_LEPUSNG
  void JSStringOnlyFinalizer(void *ptr) noexcept;
#endif
  void JSSymbolFinalizer(void *ptr) noexcept;
  void JSShapeArrayFinalizer() noexcept;
  void BytecodeListFinalizer() noexcept;
  void JSArrayBufferFinalizer(void *ptr) noexcept;
  void JSTypedArrayFinalizer(void *ptr) noexcept;
  void JSMapStateFinalizer(void *ptr) noexcept;
  void JSMapIteratorDataFinalizer(void *ptr) noexcept;
  void JSModuleDefFinalizer(void *ptr) noexcept;
  void JSSeparableStringFinalizer(void *ptr) noexcept {}
  void FinalizationRegistryDataFinalizer(void *ptr) noexcept;
  void WeakRefDataFinalizer(void *ptr) noexcept;
  void JSGeneratorDataFinalizer(void *ptr) noexcept;
  void JSAsyncFunctionDataFinalizer(void *ptr) noexcept;
  void JSAsyncGeneratorDataFinalizer(void *ptr) noexcept;
  void close_var_refs_in_finalizer(LEPUSStackFrame *sf) noexcept;

 private:
  LEPUSRuntime *rt_;
};

void JSPropertyStore(LEPUSContext *ctx, LEPUSObject *obj, JSProperty *new_prop);

#endif
