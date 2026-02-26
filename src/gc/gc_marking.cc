// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "gc/gc_marking.h"

#include <cassert>
#include <cinttypes>
#include <cstddef>
#include <cstdint>

#include "gc/alloc_config.h"
#include "gc/collector.h"
#include "gc/collector_ms.h"
#include "gc/gc_tracer.h"
#include "gc/logger.h"
#include "gc/mrt_bitmap.h"
#include "gc/page_group.h"
#include "gc/sizes.h"

#ifdef ENABLE_COMPATIBLE_MM
void GCWorkStack::PostInNode() { marking_->PostInNode(); }

void GCWorkStack::PostTask() { marking_->PostTask(); }

namespace ROS_GC {

void GCMarking::Execute(size_t workerID) {
  // auto startTime = std::chrono::steady_clock::now();
  auto &workStack = GetWorkStack(workerID);
  for (;;) {
    auto node = workStack.PopOutNode();
    if (UNLIKELY(node == nullptr)) {
      ASSERT_CHECKER(workStack.inNode_->IsEmpty());
      ASSERT_CHECKER(workStack.outNode_->IsEmpty());
      break;
    }
    auto ptr = node->Begin();
    while (ptr < node->End()) {
      address_t objaddr = *ptr++;
      int alloc_tag = get_alloc_tag((void *)objaddr);
      LOG(LEVEL_1) << "ros, MarkObject: " << (void *)objaddr;
      VisitEntry(alloc_tag, (void *)objaddr, workStack);
    }
    workStack.FinishNode(node);
  }
}

const GCMarking::VisitEntry0 GCMarking::VisitEntryPtrs[0x41] = {
    0,  // 0
    0,  // ALLOC_TAG_WITHOUT_PTR
    Visitor::VisitLEPUSObject,
    Visitor::VisitLEPUSLepusRef,
    0,  // ALLOC_TAG_JSString
    Visitor::VisitJSShape,
    Visitor::VisitLEPUSFunctionBytecode,
    Visitor::VisitJSTypedArray,
    Visitor::VisitJSMapState,
    Visitor::VisitJSMapIteratorData,
    Visitor::VisitJSFunctionDef,
    Visitor::VisitJSArrayBuffer,
    Visitor::VisitLEPUSScriptSource,
    Visitor::VisitLEPUSModuleDef,
    Visitor::VisitJSGeneratorData,
    Visitor::VisitJSAsyncFunctionData,
    Visitor::VisitJSVarRef,
    Visitor::VisitJSBoundFunction,
    Visitor::VisitJSCFunctionDataRecord,
    Visitor::VisitJSForInIterator,
    Visitor::VisitJSSeparableString,  // ALLOC_TAG_JSSeparableString
    Visitor::VisitJSArrayIteratorData,
    Visitor::VisitJSRegExpStringIteratorData,
    Visitor::VisitJSProxyData,
    Visitor::VisitJSPromiseData,
    Visitor::VisitJSPromiseReactionData,
    Visitor::VisitJSPromiseFunctionData,
    Visitor::VisitJSAsyncFromSyncIteratorData,
    Visitor::VisitJSAsyncGeneratorData,
    0,  // ALLOC_TAG_LEPUSPropertyEnum
    Visitor::VisitJSMapRecord,
    Visitor::VisitFinalizationRegistryData,
    0,  // ALLOC_TAG_WeakRefData
    Visitor::VisitFinalizationRegistryEntry,
    Visitor::VisitWeakRefRecord,
    Visitor::VisitRelocEntry,
    0,  // ALLOC_TAG_JSBigInt
    0,  // ALLOC_TAG_JSOSRWHandler
    0,  // ALLOC_TAG_JSOSSignalHandler
    0,  // ALLOC_TAG_JSOSTimer
    0,  // ALLOC_TAG_JSSTDFile
    0,  // ALLOC_TAG_JSSymbol
    Visitor::VisitJSValueArray,
    0,  // ALLOC_TAG_JSConstString
    Visitor::VisitJsonStrArray,
    Visitor::VisitLabelSlotArray,
    Visitor::VisitCallerStrSlotArray,
    Visitor::VisitLEPUSPropertyEnumArray,
    Visitor::VisitJSVarRefPtrArray,
    Visitor::VisitJSReqModuleEntryArray,
    Visitor::VisitJSExportEntryArray,
    Visitor::VisitJSImportEntryArray,
    Visitor::VisitJSResolveEntryArray,
    Visitor::VisitLEPUSBreakpointArray,
    Visitor::VisitJSPropertyArray,
    Visitor::VisitValueSlotArray,
    Visitor::VisitAtomArray,
    Visitor::VisitJSAsyncGeneratorRequest,
    Visitor::VisitJSAsyncVarRef,
    0,  // 58
    0,  // 59
    0,  // 60
    0,  // 61
    0,  // 62
    0,  // 63
};

void GCMarking::VisitEntry(int alloc_tag, void *ptr, GCWorkStack &workStack) {
  auto visitEntry = (VisitEntry0)VisitEntryPtrs[alloc_tag];
  if (UNLIKELY(visitEntry == nullptr)) return;
  visitEntry(ptr, workStack);
}

void GCMarking::Init(MplThreadPool *threadPool) {
  workerThreadPool_ = threadPool;
  threadCount_ = workerThreadPool_->GetMaxThreadNum() + 1;
  rt_ = ros_->GetRuntime();

  auto &pageList = ros_->GetPageGroups().GetPageList();
  for (int i = 0; i < threadCount_; ++i) {
    workStacks_.push_back(GCWorkStack(pageList, i));
    workStacks_[i].SetMarking(this);
    workStacks_[i].SetRuntime(rt_);
  }
  ros_->GetPageGroups().GetPageList().Init();
}

void GCMarking::Prologue() {
  if (workerThreadPool_ == nullptr) return;

  for (int i = 0; i < threadCount_; ++i) {
    GetWorkStack(i).InitNode();
  }
}

void GCMarking::Epilogue() {
  if (workerThreadPool_ == nullptr) return;
  for (int i = 0; i < threadCount_; ++i) {
    GetWorkStack(i).DeinitNode();
  }
  ros_->GetPageGroups().ResetPageListIfNeeded();
}

void GCMarking::AddMarkTask(bool isParallel) {
  if (!isParallel) {
    for (int i = 0; i < threadCount_; ++i) {
      GetWorkStack(i).RetireNode();
    }
  }
}

void GCMarking::PostTask() {
  workerThreadPool_->AddTask(new (std::nothrow) MplLambdaTask(
      [this](size_t workerID) { Execute(workerID); }));
}

void GCMarking::PostInNode() {
  if (!workerThreadPool_->CheckCanDistributeTask()) return;
  PostTask();
}

}  // namespace ROS_GC
#else
void GCWorkStack::PostInNode() {}
void GCWorkStack::PostTask() {}

namespace ROS_GC {

void GCMarking::Prologue() {}
void GCMarking::Epilogue() {}
void GCMarking::AddMarkTask(bool isParallel) {}
void GCMarking::Init(MplThreadPool *threadPool) {}
void GCMarking::Execute(size_t workerID) {}
void GCMarking::PostTask() {}
void GCMarking::PostInNode() {}
void GCMarking::VisitEntry(int alloc_tag, void *ptr, GCWorkStack &workStack) {}

const GCMarking::VisitEntry0 GCMarking::VisitEntryPtrs[0x41] = {};

}  // namespace ROS_GC
#endif  // ENABLE_COMPATIBLE_MM
