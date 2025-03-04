// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "gc/sweeper.h"

#include <string.h>
#ifndef _WIN32
#include <unistd.h>
#endif

#include "gc/allocator.h"
#include "gc/thread_pool.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnull-pointer-arithmetic"

#ifndef _WIN32
#define VMPAGE_SIZE sysconf(_SC_PAGESIZE)
#else
#define VMPAGE_SIZE 16384
#endif
#define PAGE_ALIGN(addr) (((addr) + VMPAGE_SIZE - 1) & ~(VMPAGE_SIZE - 1))

#ifdef ENABLE_COMPATIBLE_MM
void Sweeper::traverse_finalizer(bool is_only, int64_t begin_time) {
  msegmentptr sp = &(m->seg);
  size_t psize;
  mchunkptr p;
  uintptr_t end;
  int64_t time_threadhold = 3000000;  // 3s
  while (sp != NULL) {
    if (is_only && get_daytime() - begin_time > time_threadhold) {
#if defined(ANDROID) || defined(__ANDROID__)
      __android_log_print(ANDROID_LOG_ERROR, "PRIMJS_GC",
                          "only_finalizer's time > 3s, rt: %p, footprint: %zu, "
                          "footprint_limit: %zu, rt_info: %s\n",
                          m->runtime, m->footprint / 1024,
                          m->footprint_limit / 1024,
                          reinterpret_cast<LEPUSRuntime*>(m->runtime)->rt_info);
#endif
      break;
    }
    p = align_as_chunk(sp->base);
    if (!p) return;
    void* mem;
    end = segment_holds(sp, m->top)
              ? (uintptr_t)(m->top)
              : (uintptr_t)(sp) - (uintptr_t)(chunk2mem(0));
    while ((uintptr_t)p < end) {
      psize = chunksize(p);
      // todo move mark bitmap to independent memory to avoid cache miss
      // __builtin_prefetch((void*)((uintptr_t)mem - 4));
      if (!cinuse(p)) {
        p = chunk_plus_offset(p, psize);
        continue;
      }
      mem = chunk2mem(p);
      if (!is_marked(mem)) {
        do_finalizer(m->runtime, mem, is_only);
      } else {
        m->cur_malloc_size += chunksize(p);
      }
      p = chunk_plus_offset(p, psize);
    }
    sp = sp->next;
  }
}

void Sweeper::traverse_chunk_for_finalizer(bool is_only) {
  // 1. segment
  int64_t begin_time = get_daytime();
  do_global_finalizer(m->runtime);
  traverse_finalizer(is_only, begin_time);

  // 2. mmap chunk
  void** mmap_array = m->mmap_array;
  uint32_t len = m->mmap_size;
  void* mem = NULL;
  for (uint32_t i = 0; i < len; i++) {
    mem = mmap_array[i];
    if (!mmap_is_free(mem)) {
      if (!is_marked(mem)) {
        do_finalizer(m->runtime, mem, is_only);
      } else {
        m->cur_malloc_size += chunksize(mem2chunk(mem));
      }
    }
  }
}

void Sweeper::reinit_freelist() {
  m->smallmap = 0;
  m->treemap = 0;
  init_bins(m);
  memset(m->treebins, 0, sizeof(tbinptr) * NTREEBINS);
  for (int i = 0; i < THREAD_NUM; i++) {
    m->local_smallmap[i] = 0;
    m->local_treemap[i] = {0};
    memset(m->local_treebins[i], 0, sizeof(tbinptr) * NTREEBINS);
  }
}

int Sweeper::calculate_task_granularity() {
  if (m->seg_count % (THREAD_NUM * 2) == 0) {
    return m->seg_count / (THREAD_NUM * 2);
  }
  return (m->seg_count + THREAD_NUM * 2) / (THREAD_NUM * 2);
}

void Sweeper::free_mmap_objects() {
  void** mmap_array = m->mmap_array;
  uint32_t len = m->mmap_size;
  void* mem = NULL;
  for (uint32_t i = 0; i < len; i++) {
    mem = mmap_array[i];
    if (!mmap_is_free(mem)) {
      if (is_marked(mem)) {
        clear_mark(mem);
      } else {
        gcfree(m, mem);
      }
    }
  }
}

void merge_dead_objs(mstate m, msegmentptr sp_begin, msegmentptr sp_end) {
#ifdef ENABLE_GC_DEBUG_TOOLS
  int local_idx = atomic_acqurie_local_idx(m);
  while (local_idx == -1) {
#ifndef _WIN32
    sched_yield();
#endif
    local_idx = atomic_acqurie_local_idx(m);
  }
#endif
  void* mem;
  size_t psize;
  uintptr_t end;
  msegmentptr sp = sp_begin;
  mchunkptr p;
  while (true) {
    p = align_as_chunk(sp->base);
    if (!p) {
#ifdef ENABLE_GC_DEBUG_TOOLS
      atomic_release_local_idx(m, local_idx);
#endif
      return;
    }
    end = segment_holds(sp, m->top)
              ? (uintptr_t)(m->top)
              : (uintptr_t)(sp) - (uintptr_t)(chunk2mem(0));
    while ((uintptr_t)p < end) {
      // __builtin_prefetch(p);
      psize = chunksize(p);
      if (!cinuse(p)) {
        p = chunk_plus_offset(p, psize);
        continue;
      }
      mem = chunk2mem(p);
      if (is_marked(mem)) {
        clear_mark(mem);
      } else {
#ifdef ENABLE_GC_DEBUG_TOOLS
        local_gcfree(m, mem, local_idx);
#else
        local_gcfree(m, mem, -1);
#endif
      }
      p = chunk_plus_offset(p, psize);
    }
    if (sp == sp_end) break;
    sp = sp->next;
  }
#ifdef ENABLE_GC_DEBUG_TOOLS
  atomic_release_local_idx(m, local_idx);
#endif
}
void parallel_traverse_heap_segment(
    mstate m, size_t segs_in_thread, ByteThreadPool* workerThreadPool,
    std::function<void(mstate, msegmentptr, msegmentptr)> func) {
  msegmentptr sp = &m->seg;
  msegmentptr sp_end;
  while (sp != NULL) {
    sp_end = sp;
    for (int i = 0; i < segs_in_thread - 1 && sp_end->next != nullptr; i++) {
      sp_end = sp_end->next;
    }
    workerThreadPool->AddTask(new ByteLambdaTask(
        [m, sp, sp_end, &func](size_t) { func(m, sp, sp_end); }));
    sp = sp_end->next;
  }
}

void Sweeper::traverse_chunk_for_free() {
  ByteThreadPool* workerThreadPool = reinterpret_cast<ByteThreadPool*>(m->pool);
  size_t segs_in_thread = calculate_task_granularity();
  bool addToExecute = (THREAD_NUM == CREATE_THREAD_NUM) ? false : true;

#ifdef ENABLE_TRACING_GC_LOG
  int64_t free_set_bit_begin = get_daytime();
#endif
  // PHASE1
  // 1.1 merge space-continued dead objs
  // 1.2 clear mark bits
  // 1.3 set free-list relation bits(chunksize,use_state)
  parallel_traverse_heap_segment(m, segs_in_thread, workerThreadPool,
                                 merge_dead_objs);
  workerThreadPool->WaitFinish(addToExecute);
#ifdef ENABLE_GC_DEBUG_TOOLS
  merge_mems(m->runtime);
#endif
  // PHASE2
  // destory all freelist, and will create several new free-lists later
  // the free-list number is same to THREAD_NUM
  reinit_freelist();
#ifdef ENABLE_TRACING_GC_LOG
  int64_t free_set_bit_end = get_daytime();
  m->free_set_bit_time = (free_set_bit_end - free_set_bit_begin) / 1000;
#endif
  // PHASE3
  parallel_traverse_heap_segment(m, segs_in_thread, workerThreadPool,
                                 Sweeper::generate_freelist);
  workerThreadPool->WaitFinish(addToExecute);
  m->dv = nullptr;
  m->dvsize = 0;
#ifdef ENABLE_TRACING_GC_LOG
  int64_t free_gene_freelist_end = get_daytime();
  m->free_gene_freelist_time =
      (free_gene_freelist_end - free_set_bit_end) / 1000;
#endif

  // PHASE4 free mmap_object(large object)
  free_mmap_objects();
#ifdef ENABLE_TRACING_GC_LOG
  m->free_mmap_chunk_time = (get_daytime() - free_gene_freelist_end) / 1000;
#endif
}

void Sweeper::sweep_finalizer() {
#ifdef ENABLE_TRACING_GC_LOG
  m->malloc_size_before_gc = get_malloc_size(m);
#endif
  m->footprint_before_gc = m->footprint;
  m->cur_malloc_size = 0;

  // finalizer
#ifdef ENABLE_TRACING_GC_LOG
  int64_t finalizer_begin = get_daytime();
#endif
  traverse_chunk_for_finalizer();
#ifdef ENABLE_TRACING_GC_LOG
  int64_t finalizer_end = get_daytime();
  m->finalizer_time = (finalizer_end - finalizer_begin) / 1000;
#endif
}
void Sweeper::sweep_free() {
  // free
#ifdef ENABLE_TRACING_GC_LOG
  int64_t free_begin = get_daytime();
#endif
  traverse_chunk_for_free();

#ifdef ENABLE_TRACING_GC_LOG
  int64_t free_end = get_daytime();
  m->free_time = (free_end - free_begin) / 1000;
#endif

  // release segments to os
  release_unused_segments(m);

#ifdef ENABLE_TRACING_GC_LOG
  m->release_time = (get_daytime() - free_end) / 1000;

  m->malloc_size_after_gc = get_malloc_size(m);
#endif
}

void Sweeper::generate_freelist(mstate m, msegmentptr sp_begin,
                                msegmentptr sp_end) {
  AcquireIdxScope local_idx(m);
  // uint64_t tid;
  // pthread_threadid_np(NULL, &tid);
  // printf("trace_gc_work_tid: %llu\n", tid);
  msegmentptr sp = sp_begin;
  bool flag = false;
  msegmentptr old_sp = nullptr;
  mchunkptr p;
  size_t psize;
  uintptr_t end;
  mchunkptr freed_chunk_start;
  while (true) {
    p = align_as_chunk(sp->base);
    if (!p) {
      return;
    }
    flag = false;
    old_sp = nullptr;
    mchunkptr seg_start = p;
    end = segment_holds(sp, m->top)
              ? (uintptr_t)(m->top)
              : (uintptr_t)(sp) - (uintptr_t)(chunk2mem(0));
    freed_chunk_start = nullptr;
    while ((uintptr_t)p < end) {
      // __builtin_prefetch(p);
      psize = chunksize(p);
      if (!cinuse(p)) {  // freed
        if (freed_chunk_start == nullptr) freed_chunk_start = p;
      } else {  // inused
        if (freed_chunk_start != nullptr) {
          size_t chunk_size = (uintptr_t)(p) - (uintptr_t)(freed_chunk_start);
          set_free_with_pinuse(freed_chunk_start, chunk_size, p);
          local_insert_chunk(m, freed_chunk_start, chunk_size, local_idx);
#if defined(ANDROID) || defined(__ANDROID__)
          if (m->open_madvise && chunk_size > 2 * VMPAGE_SIZE) {
            uintptr_t ptr = PAGE_ALIGN((uintptr_t)freed_chunk_start +
                                       sizeof(malloc_tree_chunk));
            size_t size = (uintptr_t)(p)-ptr;
            size = size & ~(VMPAGE_SIZE - 1);
            madvise(reinterpret_cast<void*>(ptr), size, MADV_DONTNEED);
          }
#endif
          freed_chunk_start = nullptr;
        }
      }
      p = chunk_plus_offset(p, psize);
    }
    if (freed_chunk_start != nullptr) {
      __attribute__((unused)) uintptr_t threadhold_size = 8 * 1024;
      __attribute__((unused)) uintptr_t last_size =
          (uintptr_t)sp->base + sp->size - (uintptr_t)freed_chunk_start;
      if (freed_chunk_start == seg_start) {
        if (!segment_holds(sp, m->top)) {
          // set flag for unused segment
          sp->sflags |= IS_UNUSED_BIT;
        } else {
          size_t chunk_size = end - (uintptr_t)(freed_chunk_start);
          set_free_with_pinuse(freed_chunk_start, chunk_size, p);
          local_insert_chunk(m, freed_chunk_start, chunk_size, local_idx);
#if defined(ANDROID) || defined(__ANDROID__)
          if (m->open_madvise && chunk_size > 2 * VMPAGE_SIZE) {
            uintptr_t ptr = PAGE_ALIGN((uintptr_t)freed_chunk_start +
                                       sizeof(malloc_tree_chunk));
            size_t size = (uintptr_t)(p)-ptr;
            size = size & ~(VMPAGE_SIZE - 1);
            madvise(reinterpret_cast<void*>(ptr), size, MADV_DONTNEED);
          }
#endif
        }
      } else {
        size_t chunk_size = end - (uintptr_t)(freed_chunk_start);
        if (segment_holds(sp, m->top)) {
          size_t tsize = m->topsize += chunk_size;
          m->top = freed_chunk_start;
          freed_chunk_start->head = tsize | PINUSE_BIT;
        } else {
          set_free_with_pinuse(freed_chunk_start, chunk_size, p);
          local_insert_chunk(m, freed_chunk_start, chunk_size, local_idx);
#if defined(ANDROID) || defined(__ANDROID__)
          if (m->open_madvise && chunk_size > 2 * VMPAGE_SIZE) {
            uintptr_t ptr = PAGE_ALIGN((uintptr_t)freed_chunk_start +
                                       sizeof(malloc_tree_chunk));
            size_t size = (uintptr_t)(p)-ptr;
            size = size & ~(VMPAGE_SIZE - 1);
            madvise(reinterpret_cast<void*>(ptr), size, MADV_DONTNEED);
          }
#endif
        }
      }
    }
    if (flag) {
      if (old_sp == sp_end) {
        break;
      }
    } else if (sp == sp_end) {
      break;
    }
    sp = sp->next;
  }
  m->gc_flag[local_idx] = 1;
}
#pragma clang diagnostic pop

#endif  // ENABLE_COMPATIBLE_MM
