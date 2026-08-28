#ifndef SRC_GC_ROS_ALLOCATOR_INLINED_H_
#define SRC_GC_ROS_ALLOCATOR_INLINED_H_

#include "gc/logger.h"
#include "gc/ros_allocator.h"

namespace ROS_GC {
inline void RosAllocImpl::InitkRunMagicIfNeeded() {
  if (kRunMagic) return;
  AllocUtilRand<size_t> rand(1, std::numeric_limits<uint8_t>::max());
  kRunMagic = static_cast<uint8_t>(rand.next());
}

inline void RosAllocImpl::CheckRunMagic(RunSlots &ROSIMPL_DUNUSED(run)) {
  ROSIMPL_ASSERT(run.magic == kRunMagic, "invalid run");
}

inline uint32_t RosAllocImpl::GetRunIdx(size_t size) {
  ROSIMPL_ASSERT(size <= kLargeObjSize, "large size doesn't have an idx");
  return ROSIMPL_RUN_IDX(size);
}

inline uint32_t RosAllocImpl::GetPagesPerRun(int index) {
  ROSIMPL_ASSERT(index >= 0 && index < kNumberROSRuns, "index out of bound");
  return ROSIMPL_N_PAGES_PER_RUN(index);
}

inline size_t RosAllocImpl::GetRunSize(int index) {
  ROSIMPL_ASSERT(index >= 0 && index < kNumberROSRuns, "index out of bound");
  return ROSIMPL_RUN_SIZE(index);
}

inline address_t RosAllocImpl::AllocRun(int idx, int eagerness) {
  size_t pageCount = GetPagesPerRun(idx);
  size_t size = ALLOCUTIL_PAGE_CNT2BYTE(pageCount);
  size_t internalSize = 0;
  uint32_t page_idx = 0;
  address_t pageAddr =
      AllocPagesInternal(size, internalSize, eagerness, page_idx);
  if (UNLIKELY(pageAddr == 0)) {
    return 0U;
  }
  ROSIMPL_ASSERT(internalSize == size, "page alloc for run error");
  size_t converted =
      allocSpace.page_groups.SetAsRunPage(page_idx, pageAddr, pageCount);
  allocSpace.RecordReleasedToNonReleased(converted);
  return pageAddr;
}

inline RunSlots *RosAllocImpl::FetchRunFromNonFulls(int idx) {
  return nonFullRuns[idx].Fetch();
}

inline RunSlots *RosAllocImpl::FetchOrAllocRun(int idx, int eagerness) {
  RunSlots *run = nullptr;
  {
    if (UNLIKELY(concurrent_sweep_is_running)) {
      // if (runLocks[idx].try_lock()) {
      //   run = FetchRunFromNonFulls(idx);
      //   runLocks[idx].unlock();
      // }
    } else {
      run = FetchRunFromNonFulls(idx);
    }
  }
  if (UNLIKELY(run == nullptr)) {
    address_t runAddr = 0;
    { runAddr = AllocRun(idx, eagerness); }
    if (LIKELY(runAddr != 0)) {
      // we new run out of lock, in order to prevent page faults holding the
      // lock for too long a problem is that unsafe heap scan (e.g., concurrent
      // gc) will scan unintialised runs we use the init bit in each run to tell
      // whether the run is ready for scan
      run = new (reinterpret_cast<void *>(runAddr)) RunSlots(idx);
      run->Init();
    }
  }
  return run;
}

template <uint32_t kLocalRuns>
__attribute__((always_inline)) address_t RosAllocImpl::AllocFromLocalRun(
    ROSAllocMutator<kLocalRuns> &mutator, int idx, int eagerness) {
  ROSIMPL_ASSERT(static_cast<uint32_t>(idx) < kLocalRuns,
                 "idx >= number of local runs");
  address_t localAddress = mutator.GetLocalAddress(idx);

  // try to allocate from the mutator's local run
  address_t addr = 0;
  if (LIKELY(localAddress)) {
    // try lockless path first
    addr = mutator.Alloc(idx);
    if (LIKELY(addr)) {
      return addr;
    } else {
      RunSlots &run = *reinterpret_cast<RunSlots *>(localAddress);
      if (UNLIKELY(run.IsFull())) {
        mutator.Globalise(run);
      } else {
        mutator.Localise(run);
        addr = mutator.Alloc(idx);
        ROSIMPL_ASSERT(addr != 0, "unable to alloc from local list");
        return addr;
      }
    }
  }

  // if we have used up the local run (we could dismiss local alloc,
  // unimplemented)
  RunSlots *localRun = nullptr;
  localRun = FetchOrAllocRun(idx, eagerness);
  if ((UNLIKELY(localRun == nullptr))) {
    return 0;
  } else {
    // we can potentially localise multiple runs
    mutator.Localise(*localRun);
  }

  addr = mutator.Alloc(idx);
  ROSIMPL_ASSERT(addr, "mutator unable to alloc");
  return addr;
}

// return internal addr
__attribute__((always_inline)) address_t RosAllocImpl::AllocFromRun(
    size_t &internalSize, int eagerness) {
  int idx = static_cast<int>(GetRunIdx(internalSize));
  internalSize = GetRunSize(idx);
  return AllocFromLocalRun<RunConfig::kRunConfigs>(globalMutator, idx,
                                                   eagerness);
}

inline bool RosAllocImpl::UpdateGlobalsAfterFree(RunSlots &run, bool wasFull) {
  // local runs must be globalised before they are passed in here
  if (LIKELY(run.IsLocal())) {
    return false;
  }
  uint8_t idx = run.mIdx;
  bool needRemove = false;
  if (UNLIKELY(run.IsEmpty())) {
    bool wasInNonFullRuns = false;
    if (run.IsInList()) {
      wasInNonFullRuns = true;
      // IsInList is atomic-op, lock until Erase this runslots
      ALLOC_LOCK_TYPE guard(ALLOC_CURRENT_THREAD runLocks[idx]);
      nonFullRuns[idx].Erase(run);
    }
    if (wasInNonFullRuns || wasFull) {
      needRemove = true;
    }
  } else if (wasFull && !run.IsFull()) {
    ROSIMPL_ASSERT(!run.IsInList(), "full run in nfrs");
    ALLOC_LOCK_TYPE guard(ALLOC_CURRENT_THREAD runLocks[idx]);
    nonFullRuns[idx].Insert(run);
  }
  return needRemove;
}

// must be called in critical section, either in STW or holding lock
inline void RosAllocImpl::SweepSlot(RunSlots &run, address_t slotAddr) {
  address_t objAddr = ROSIMPL_GET_OBJ_FROM_ADDR(slotAddr);
  DCHECK_OBJ_IS_ALLOCATED_BY_ALLOCATOR(objAddr);
  CheckObjHasValidKlassForDebug(objAddr);
  ROS_GC::Allocator::ReleaseResource(objAddr);
#ifdef ALLOC_USE_FAST_PATH
  size_t objSize = PreObjFree<true>(objAddr);
#else
  size_t objSize = PreObjFree(objAddr);
#endif
  size_t slotSize = run.GetRunSize();
#ifdef ROSIMPL_MEMSET_AT_FREE
  ROSALLOC_MEMSET_S(slotAddr, slotSize, 0, slotSize);
#endif
  // FreeSlot have already cleared allocatedBit
  run.FreeSlot(slotAddr);
#ifdef ALLOC_USE_FAST_PATH
  PostObjFree<true>(objAddr, objSize, slotSize);
#else
  PostObjFree(objAddr, objSize, slotSize);
#endif
}
inline bool RosAllocImpl::LocalRunIsEmpty(RunSlots &run) {
  if (run.IsEmpty()) {
    return true;
  }

  size_t slotSize = run.GetRunSize();
  size_t slotCount = run.GetMaxSlots();
  address_t slotAddr = run.GetBaseAddress();
  for (size_t i = 0; i < slotCount; ++i) {
    address_t objAddr = ROSIMPL_GET_OBJ_FROM_ADDR(slotAddr);
    if (IsAllocatedByAllocator(objAddr)) {
      return false;
    }
    slotAddr += slotSize;
  }
  return true;
}
inline void RosAllocImpl::SweepRun(RunSlots &run, Bitmap *markBitmap,
                                   size_t &releasedSize) {
  bool wasFull = run.IsFull();
  run.FreeIterator([&releasedSize, &markBitmap, this, &run](
                       address_t objAddr, address_t slotAddr, size_t slotSize) {
    if (!markBitmap->IsObjectMarked(objAddr)) {
      LOG(LEVEL_1) << "ros, SweepRun: " << (void *)(objAddr);
      this->SweepSlot(run, slotAddr);
      ClearAllocatedBit(objAddr);
#ifdef FUTURE_OPTIMIZE
      __asm __volatile("dc cvau, %0" ::"r"(slotAddr));
#endif
      releasedSize += slotSize;
    }
  });

  if (UpdateGlobalsAfterFree(run, wasFull)) {
    FreeRun(run);
  }
}

inline void RosAllocImpl::ConcurrentSweepRun(RunSlots &run,
                                             Bitmap *markBitmap) {
  size_t releasedBytes = 0;
  bool wasFull = run.IsFull();
  bool locked = false;
  if (run.IsInList()) {
    runLocks[run.mIdx].lock();
    locked = true;
  }
  run.FreeIterator([&releasedBytes, markBitmap, this, &run](
                       address_t objAddr, address_t slotAddr, size_t slotSize) {
    if (!markBitmap->IsObjectMarked(objAddr)) {
      LOG(LEVEL_1) << "ros, ConcurrentSweepRun: " << (void *)(objAddr);
      this->SweepSlot(run, slotAddr);
      ClearAllocatedBit(objAddr);
      releasedBytes += slotSize;
    }
  });

  RecordTotalReleasedBytesForGCLog(releasedBytes);

  allocatedInternalSize -= releasedBytes;
  if (locked) {
    // the original runidx must record before FreeRun. when this run is reused
    // after free, the runidx will be changed
    uint8_t runIdx = run.mIdx;
    if (UNLIKELY(run.IsEmpty())) {
      nonFullRuns[run.mIdx].Erase(run);
      FreeRun(run);
    }
    runLocks[runIdx].unlock();
    return;
  }
  if (UpdateGlobalsAfterFree(run, wasFull)) {
    FreeRun(run);
  }
}
__attribute__((always_inline)) void Allocator::PostObjAlloc(
    address_t objAddress, size_t objSize, size_t internalSize) {
  bool isLarge = internalSize > RosAllocImpl::kLargeObjSize;
  account.AtAlloc(objSize, internalSize, isLarge);
}
__attribute__((always_inline)) address_t RosAllocImpl::AllocInternal(
    size_t &allocSize) {
  bool allocSuccess = false;
  int eagerness = kEagerLevelMin;
  address_t internalAddr = 0U;
  do {
    if (LIKELY(allocSize <= kLargeObjSize)) {
      internalAddr = AllocFromRun(allocSize, eagerness);
    } else {
      internalAddr = AllocLargeObject(allocSize, eagerness);
    }
    allocSuccess = (internalAddr != 0U);
    if (UNLIKELY(!allocSuccess && !HandleAllocFailure(allocSize, eagerness))) {
      break;
    }
  } while (!allocSuccess);
  return internalAddr;
}

__attribute__((always_inline)) address_t RosAllocImpl::NewObjInternal(
    size_t &allocSize) {
  NewObjPrologueForAsan();
  address_t allocAddr = AllocInternal(allocSize);
  if (UNLIKELY(allocAddr == 0)) return allocAddr;
  NewObjEpilogueForAsan();

  if (UNLIKELY(should_mark_new_obj)) {
    MarkObjectNoInline(allocAddr);
  }
  allocatedInternalSize.fetch_add(allocSize, std::memory_order_relaxed);
  return allocAddr;
}

inline void RosAllocImpl::ForEachObjInRun(RunSlots &run,
                                          HeapAliveObjsVisitor &visitor,
                                          size_t numHint) const {
  if (!run.HasInit() || run.IsEmpty()) {
    return;
  }
  run.ForEachObj(visitor, numHint);
}

inline bool RosAllocImpl::AccurateIsValidObjAddrUnsafe(address_t addr) {
  RunSlots *run = nullptr;
  address_t pageAddr = ALLOCUTIL_PAGE_ADDR(addr);
  PageGroup &group = allocSpace.page_groups.GetGroup(addr);
  // here means we have encoutered a derived-pointer from huge-obj
  if (group.IsHugeObj()) return false;
  PageLabel pageType = group.GetPageMap()->GetTypeForAddr(addr);
  if (LIKELY(pageType == kPRun)) {
    run = reinterpret_cast<RunSlots *>(pageAddr);
  } else if (pageType == kPRunRem) {
    pageAddr = group.GetPageMap()->GetTypeForAddr(addr);
    run = reinterpret_cast<RunSlots *>(pageAddr);
  } else if (pageType == kPLargeObj) {
    if (pageAddr == ROSIMPL_GET_ADDR_FROM_OBJ(addr)) {
      return IsAllocatedByAllocator(addr);
    }
    return false;
  } else {
    return false;
  }

  if (!run->HasInit()) {
    return false;
  }
  // run obj
  ROSIMPL_DEBUG(CheckRunMagic(*run));
  return run->IsLiveObjAddr(addr);
}
}  // namespace ROS_GC
#endif  // RTS_GC_ROSALLOCATOR_INLINED_H
