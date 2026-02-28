// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_GC_GC_MARKING_H_
#define SRC_GC_GC_MARKING_H_

#include <vector>

#include "gc/allocator.h"
#include "gc/gc_work_stack.h"
#include "gc/mrt_bitmap.h"
#include "gc/ros_allocator.h"
#include "gc/thread_pool.h"
namespace ROS_GC {

class GCMarking {
 public:
  GCMarking(RosAllocImpl *ros) : ros_(ros) {}
  ~GCMarking() = default;

  void Prologue();
  void Epilogue();

  void AddMarkTask(bool isParallel);

  void Init(MplThreadPool *threadPool);
  void Execute(size_t workerID);

  GCWorkStack &GetWorkStack(size_t workerID) {
    ASSERT_CHECKER(workerID < threadCount_);
    return workStacks_[workerID];
  }
  void PostTask();
  void PostInNode();

  typedef void (*VisitEntry0)(void *ptr, GCWorkStack &workStack);

  void VisitEntry(int alloc_tag, void *ptr, GCWorkStack &workStack);

  LEPUSRuntime *GetRuntime() { return rt_; }

 private:
  static const VisitEntry0 VisitEntryPtrs[0x41];
  __attribute__((unused)) size_t threadCount_ = 0;
  __attribute__((unused)) RosAllocImpl *ros_{nullptr};
  LEPUSRuntime *rt_{nullptr};
  __attribute__((unused)) MplThreadPool *workerThreadPool_ = nullptr;
  std::vector<GCWorkStack> workStacks_;
};

}  // namespace ROS_GC
#endif  // SRC_GC_GC_MARKING_H_
