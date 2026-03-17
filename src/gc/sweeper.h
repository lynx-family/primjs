// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_GC_SWEEPER_H_
#define SRC_GC_SWEEPER_H_
#include <functional>

#include "quickjs/include/quickjs-inner.h"

class Sweeper {
 public:
  Sweeper(mstate state) : m(state) {}
  void sweep_finalizer();
  void sweep_free();
  void traverse_finalizer(bool is_only, int64_t begin_time);
  void traverse_chunk_for_finalizer(bool is_only = false);
  void free_mmap_objects();
  void traverse_chunk_for_free();
  void reinit_freelist();
  int calculate_task_granularity();
  static void generate_freelist(mstate m, msegmentptr sp_begin,
                                msegmentptr sp_end);

 private:
  mstate m;
};

void do_finalizer(void* runtime, void* ptr, bool is_only);

void do_global_finalizer(void* rt);

void merge_dead_objs(mstate m, msegmentptr sp_begin, msegmentptr sp_end);

class AcquireIdxScope {
 private:
  int local_idx;
  mstate m_;

 public:
  AcquireIdxScope(mstate m) {
    local_idx = atomic_acqurie_local_idx(m);
    m_ = m;
    while (local_idx == -1) {
#ifndef _WIN32
      sched_yield();
#endif
      local_idx = atomic_acqurie_local_idx(m);
    }
  }
  ~AcquireIdxScope() { atomic_release_local_idx(m_, local_idx); }
  operator int() { return local_idx; }
};
void parallel_traverse_heap_segment(
    mstate m, size_t segs_in_thread, ByteThreadPool* workerThreadPool,
    std::function<void(mstate, msegmentptr, msegmentptr)> func);

#endif  // SRC_GC_SWEEPER_H_
