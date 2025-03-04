// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_GC_COLLECTOR_H_
#define SRC_GC_COLLECTOR_H_

#include <sstream>

#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

enum HandleType;
class Visitor;
class Finalizer;
class Sweeper;
typedef struct JSString JSAtomStruct;
struct LEPUSRuntime;
typedef struct malloc_state *mstate;
struct JSAsyncFunctionState;
struct JSProperty;
struct JSRegExp;
struct BCReaderState;
struct JSToken;
struct ValueBuffer;
class GarbageCollector {
 public:
  GarbageCollector(LEPUSRuntime *rt, mstate) noexcept;
  ~GarbageCollector();
  // gc
  void CollectGarbage(size_t size = 0) noexcept;
  void DoOnlyFinalizer() noexcept;

  void Init(LEPUSRuntime *rt);
  Visitor *GetVisitor() { return visitor; }
  Finalizer *GetFinalizer() { return finalizer; }
  // gc pause suppression mode
  void SetGCPauseSuppressionMode(bool mode) {
    gc_pause_suppression_mode_ = mode;
  }
  bool GetGCPauseSuppressionMode() { return gc_pause_suppression_mode_; }
  // forbid_gc
  void SetForbidGC() { forbid_gc_++; }
  void ResetForbidGC() { forbid_gc_--; }

  // for debug
#ifdef ENABLE_GC_DEBUG_TOOLS
  size_t mem_order_cnt;
  std::unordered_map<void *, size_t> cur_mems;
  std::unordered_set<void *> delete_mems[THREAD_NUM];
  size_t delete_order_cnt;
  std::unordered_map<void *, size_t> del_mems;

  size_t handle_order_cnt;
  std::unordered_map<void *, size_t> cur_handles;
  size_t qjsvalue_order_cnt;
  std::unordered_map<void *, size_t> cur_qjsvalues;
#endif

  size_t GetHandleSize() {
#ifdef ENABLE_GC_DEBUG_TOOLS
    return cur_handles.size();
#else
    return 0;
#endif
  }

  size_t GetQjsValueSize() {
#ifdef ENABLE_GC_DEBUG_TOOLS
    return cur_qjsvalues.size();
#else
    return 0;
#endif
  }

  void SetMaxLimit(size_t limit);
  size_t GetMaxLimit();
  void AddGCDuration(int64_t gc_time) { total_duration += gc_time; }
  int64_t GetGCDuration() { return total_duration; }
  int js_ref_count;

 private:
  // gc
  void MarkLiveObjects() noexcept;
  void SweepDeadObjects() noexcept;
#ifdef ENABLE_TRACING_GC_LOG
  void PrintGCLog(int64_t mark_begin, int64_t mark_end) noexcept;
#endif
  void UpdateFootprintLimit(size_t size) noexcept;
  void UpdateNGFootprintLimit(size_t size) noexcept;
  void UpdateGCInfo(size_t heapsize_before, int64_t duration);

  // field
  LEPUSRuntime *rt_;
  int forbid_gc_;
  bool gc_pause_suppression_mode_ = false;
  Visitor *visitor;
  Finalizer *finalizer;
  Sweeper *sweeper;
  size_t max_limit;
#ifdef ENABLE_TRACING_GC_LOG
  int64_t gc_begin_time;
  int64_t last_gc_time;
#endif
  int64_t total_duration;
  std::stringstream gc_info;
  int info_size;
};

class Visitor {
 public:
  Visitor(LEPUSRuntime *rt) noexcept
      : rt_(rt), objs(nullptr), objs_len(0), idx(0) {
    for (int i = 0; i < THREAD_NUM; i++) {
      queue[i] = new Queue(rt_);
    }
  }
  ~Visitor() {
    for (int i = 0; i < THREAD_NUM; i++) {
      delete queue[i];
    }
    if (objs != nullptr) {
      system_free(objs);
    }
  }
  void ScanRoots();
  void VisitRootLEPUSValue(LEPUSValue *val, int local_idx) noexcept;
  void VisitRootLEPUSValue(LEPUSValue &val, int local_idx) noexcept;
  void AddObjectDuringGC(void *ptr) {
    if (objs == nullptr) {
      objs = static_cast<void **>(system_malloc(16 * sizeof(void *)));
      objs_len = 16;
    }
    if (idx >= objs_len) {
      int new_len = objs_len * 2;
      void **new_objs =
          static_cast<void **>(system_realloc(objs, new_len * sizeof(void *)));
      if (!new_objs) abort();
      objs = new_objs;
      objs_len = new_len;
    }
    objs[idx] = ptr;
    idx++;
  }
  void VisitObjectDuringGC() {
    for (int i = 0; i < idx; i++) {
      VisitRootHeapObj(objs[i], 0);
    }
    idx = 0;
  }

 private:
  // private scanner
  void ScanStack() noexcept;
  void ScanRuntime() noexcept;
  void ScanHandles() noexcept;
  void ScanContext(LEPUSContext *ctx) noexcept;

  // visit root
  void VisitRoot(void *ptr, HandleType type, int local_idx) noexcept;
  void VisitRootHeapObj(void *ptr, int local_idx) noexcept;
  void VisitRootHeapObjForTask(Queue *q, void *ptr) noexcept;
  void VisitRootCString(char *cstr, int local_idx) noexcept;
  void VisitRootJSToken(JSToken *token, int local_idx) noexcept;
  void VisitRootBCReaderState(BCReaderState *s, int local_idx) noexcept;
  void VisitRootValueBuffer(ValueBuffer *b, int local_idx) noexcept;
  void VisitJSAtom(JSAtom atom, int local_idx) noexcept;

  // visitor
  /* LEPUSValue with tag -> begin */
  void VisitEntry(void *ptr, int local_idx) noexcept;
  void VisitLEPUSLepusRef(void *ptr, int local_idx) noexcept;
  void VisitJShape(void *ptr, int local_idx) noexcept;
  void VisitJSVarRef(void *ptr, int local_idx) noexcept;
  void VisitJSFunctionBytecode(void *ptr, int local_idx) noexcept;
  void VisitJSObject(void *ptr, int local_idx) noexcept;
  /* LEPUSValue with tag -> end */
  // LEPUS_TAG_BIG_INT
  // LEPUS_TAG_BIG_FLOAT
  /* LEPUSObject with class_id -> begin */
  void VisitJSBoundFunction(void *ptr,
                            int local_idx) noexcept;  // normal_free
  void VisitJSCFunctionDataRecord(void *ptr,
                                  int local_idx) noexcept;  // normal_free
  void VisitJSForInIterator(void *ptr,
                            int local_idx) noexcept;  // normal_free
  void VisitJSArrayBuffer(void *ptr, int local_idx) noexcept;
  void VisitJSTypedArray(void *ptr, int local_idx) noexcept;
  void VisitJSMapState(void *ptr, int local_idx) noexcept;
  void VisitJSMapIteratorData(void *ptr, int local_idx) noexcept;
  void VisitJSArrayIteratorData(void *ptr,
                                int local_idx) noexcept;  // normal_free
  void VisitJSRegExpStringIteratorData(void *ptr,
                                       int local_idx) noexcept;  // normal_free
  void VisitJSGeneratorData(void *ptr, int local_idx) noexcept;
  void VisitJSProxyData(void *ptr, int local_idx) noexcept;    // normal_free
  void VisitJSPromiseData(void *ptr, int local_idx) noexcept;  // normal_free
  void VisitJSPromiseReactionData(void *ptr,
                                  int local_idx) noexcept;  // normal_free
  void VisitJSPromiseFunctionData(void *ptr,
                                  int local_idx) noexcept;  // normal_free
  void VisitJSAsyncFunctionData(void *ptr, int local_idx) noexcept;
  void VisitJSAsyncFromSyncIteratorData(void *ptr,
                                        int local_idx) noexcept;  // normal_free
  void VisitJSAsyncGeneratorData(void *ptr, int local_idx) noexcept;
  /* LEPUSObject with class_id -> end */
  // scan context
#ifdef ENABLE_QUICKJS_DEBUGGER
  void VisitJSScriptSource(void *ptr, int local_idx) noexcept;
#endif
  // other
  void VisitJSPropertyEnum(void *ptr,
                           int local_idx) noexcept;  // normal_free
  void VisitJSModuleDef(void *ptr, int local_idx) noexcept;
  void VisitJSFunctionDef(void *ptr, int local_idx) noexcept;
  void VisitJSValueArray(void *ptr, int local_idx) noexcept;
  void VisitValueSlot(void *ptr, int local_idx) noexcept;
  void VisitJsonStrArray(void *ptr, int local_idx) noexcept;

  void VisitSeparableString(void *ptr, int local_idx) noexcept;
  void VisitDebuggerInfo(void *, int32_t) noexcept;
  void VisitFinalizationRegistryData(void *ptr, int local_idx) noexcept;

  // push ptr
  void PushObjLEPUSValue(LEPUSValue &val, int local_idx) noexcept;
  void PushObjLEPUSValue(LEPUSValue *val, int local_idx) noexcept;
  void PushObjAtom(JSAtom atom, int local_idx) noexcept;
  void PushObjJSAsyncFunctionState(JSAsyncFunctionState *s,
                                   int local_idx) noexcept;
  void PushObjJStackFrame(LEPUSStackFrame *sf, int local_idx) noexcept;
  void PushBytecodeAtoms(const uint8_t *bc_buf, int bc_len,
                         int use_short_opcodes, int local_idx) noexcept;
  void PushObjJSRegExp(JSRegExp *re, int local_idx) noexcept;
  void PushObjFunc(LEPUSObject *obj, int local_idx) noexcept;
  void PushObjArray(LEPUSObject *obj, int local_idx) noexcept;
  void PushObjRegExp(LEPUSObject *obj, int local_idx) noexcept;
  void PushObjProperty(JSProperty *pr, int prop_flags, int local_idx) noexcept;

  // tools
  bool IsConstString(void *ptr) {
    return get_alloc_tag(ptr) == ALLOC_TAG_JSConstString;
  }
  // field
  LEPUSRuntime *rt_;
  Queue *queue[THREAD_NUM];  // for visit
  void **objs;
  int objs_len;
  int idx;
};

class Finalizer {
 public:
  Finalizer(LEPUSRuntime *rt) noexcept : rt_(rt) {}
  void close_var_refs(LEPUSStackFrame *sf) noexcept;
  void free_atom(LEPUSRuntime *rt, JSAtomStruct *p) noexcept;
  // do finalizer
  void DoFinalizer(void *ptr) noexcept;
  void DoFinalizer2(void *ptr) noexcept;
#ifdef ENABLE_LEPUSNG
  void JSLepusRefFinalizer(void *ptr) noexcept;
#endif
#ifdef CONFIG_BIGNUM
  void JSBigFloatFinalizer(void *ptr) noexcept;
#endif
  void JSObjectFinalizer(void *ptr) noexcept;
  void JSObjectOnlyFinalizer(void *ptr) noexcept;
  void JSStringFinalizer(void *ptr) noexcept;
#ifdef ENABLE_LEPUSNG
  void JSStringOnlyFinalizer(void *ptr) noexcept;
#endif
  void JSSymbolFinalizer(void *ptr) noexcept;
  void JSShapeFinalizer(void *ptr) noexcept;
  void JSVarRefFinalizer(void *ptr) noexcept;
  void JSFunctionBytecodeFinalizer(void *ptr) noexcept;
  void JSArrayBufferFinalizer(void *ptr) noexcept;
  void JSTypedArrayFinalizer(void *ptr) noexcept;
  void JSMapStateFinalizer(void *ptr) noexcept;
  void JSMapIteratorDataFinalizer(void *ptr) noexcept;
  void JSGeneratorDataFinalizer(void *ptr) noexcept;
  void JSAsyncFunctionDataFinalizer(void *ptr) noexcept;
  void JSAsyncGeneratorDataFinalizer(void *ptr) noexcept;
  void JSModuleDefFinalizer(void *ptr) noexcept;
  void JSFunctionDefFinalizer(void *ptr) noexcept;
  void JSSeparableStringFinalizer(void *ptr) noexcept {}
  void FinalizationRegistryDataFinalizer(void *ptr) noexcept;
  void WeakRefDataFinalizer(void *ptr) noexcept;

 private:
  LEPUSRuntime *rt_;
};

class MlockScope {
 public:
  MlockScope(Queue **q) : queue(q) {
#ifndef _WIN32
    for (int i = 0; i < THREAD_NUM; i++) {
      SYSCALL_CHECK(
          mlock(queue[i]->GetQueue(), queue[i]->GetSize() * sizeof(uintptr_t)))
    }
#endif
  }
  ~MlockScope() {
#ifndef _WIN32
    for (int i = 0; i < THREAD_NUM; i++) {
      SYSCALL_CHECK(munlock(queue[i]->GetQueue(),
                            queue[i]->GetSize() * sizeof(uintptr_t)));
    }
#endif
  }

 private:
  Queue **queue;
};
#endif  // SRC_GC_COLLECTOR_H_
