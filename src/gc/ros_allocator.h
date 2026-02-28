#ifndef SRC_GC_ROS_ALLOCATOR_H_
#define SRC_GC_ROS_ALLOCATOR_H_

#include <algorithm>
#include <cinttypes>
#include <condition_variable>
#include <cstdint>
#include <cstdlib>
#include <unordered_set>

#include "gc/allocator.h"
#include "gc/mrt_bitmap.h"
#include "gc/ros_alloc_run.h"
#include "gc/space.h"
#include "gc/structs.h"
#include "gc/thread_pool.h"

#define ROSALLOC_MEMSET_S(addr, dstsize, c, size)                        \
  do {                                                                   \
    static_assert(c == 0, "we only allow zeroing");                      \
    ROSIMPL_ASSERT(addr, "null destination");                            \
    ROSIMPL_ASSERT(dstsize >= size, "destination size too small");       \
    ROSIMPL_ASSERT(size >= 8, "we only allow size ge 8");                \
    ROSIMPL_ASSERT(addr % 4 == 0, "addr must be aligned to at least 4"); \
    ROSIMPL_ASSERT(size % 4 == 0, "size must be aligned to at least 4"); \
    memset(reinterpret_cast<void *>(addr + ROS_GC::kHeaderSize), 0xcc,   \
           size - ROS_GC::kHeaderSize);                                  \
  } while (0)

struct LEPUSRuntime;
class Visitor;
class Finalizer;

namespace ROS_GC {

// sweep timeout.
constexpr auto kSweepTimeout = std::chrono::seconds(3);
class RosAllocImpl;
class MarkSweepCollector;

class SweepContext {
  friend class RunSlots;
  friend class RosAllocImpl;

  class ScopedAliveClosure {
   public:
    ScopedAliveClosure(SweepContext &context) : sweepContext(context) {
      alive = sweepContext.TryIncRC();
    }

    ~ScopedAliveClosure() {
      if (alive) {
        sweepContext.DecRC();
      }
    }

    bool Alive() const { return alive; }

   private:
    SweepContext &sweepContext;
    bool alive;
  };

 public:
  // only called in STW
  void Init(const Allocator &allocator, const size_t endPageIndex,
            const PageMap &snapshot) {
    highestPageIndex = endPageIndex;
    oldAllocatedBytes = allocator.AllocatedMemory();
    // alloc page map to store the snapshot of page labels
    void *ret = nullptr;
#ifndef _WIN32
    ret = mmap(nullptr, TotalBytesOfPageMap(), PROT_READ | PROT_WRITE,
               MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
#endif
    pageMap = reinterpret_cast<PageLabel *>(ret);
    refCount.store(1, std::memory_order_relaxed);
    if (memcpy(pageMap, snapshot.GetMap(), TotalBytesOfPageMap()) != 0) {
      abort();
      // LOG(FATAL) << "memcpy error for page_map snapshot";
    }
    emptyRuns.store(0, std::memory_order_relaxed);
    nonFullRuns.store(0, std::memory_order_relaxed);
    scanedRuns.store(0, std::memory_order_relaxed);
    sweptRuns.store(0, std::memory_order_relaxed);
    releasedObjects.store(0, std::memory_order_relaxed);
    releasedLargeObjects.store(0, std::memory_order_relaxed);
    releasedBytes.store(0, std::memory_order_relaxed);
  }

  // called after concurrent sweep, may run concurrently with java thread
  void Release() {
    DecRC();
    std::deque<address_t>().swap(deadNeighbours);
  }

  inline void AddDeadNeighbours(std::vector<address_t> &candidates) {
    lock_guard<mutex> guard(contextMutex);
    for (address_t obj : candidates) {
      deadNeighbours.push_back(obj);
    }
  }

  // Try to set sweeping state for the given page,
  // when another thread is sweeping the page, wait until it finished.
  // return true if set to sweeping success, otherwise false.
  // when success, old_state will be the original page type.
  bool SetSweeping(size_t pageIndex, PageLabel &oldState) {
    ScopedAliveClosure sac(*this);
    // check page index bound.
    if (UNLIKELY(pageIndex >= highestPageIndex || !sac.Alive())) {
      // page_index out of bound, we treat it as swept.
      oldState = kPSwept;
      return false;
    }

    // get atomic state object by page index.
    auto &atomicState = AtomicPageState(pageIndex);

    // load the old state.
    oldState = atomicState.load(std::memory_order_acquire);

    do {
      if (oldState == kPSweeping) {
        // another thread is sweeping the page,
        // wait until it finished.
        if (UNLIKELY(!WaitUntilSwept(atomicState))) {
          abort();
        }
        return false;
      }
      if (oldState != kPRun && oldState != kPLargeObj) {
        // all other states except kPRun and kPLargeObj are treat as swept.
        oldState = kPSwept;
        return false;
      }
      // try to change state from kPRun/kPLargeObj to kPSweeping,
      // loop to try again if change state failed.
    } while (!atomicState.compare_exchange_weak(oldState, kPSweeping,
                                                std::memory_order_release,
                                                std::memory_order_acquire));
    return true;
  }

  // atomic mark page to swept state.
  inline void SetSwept(size_t pageIndex) {
    ScopedAliveClosure sac(*this);
    if (LIKELY(sac.Alive() && pageIndex < highestPageIndex)) {
      AtomicPageState(pageIndex).store(kPSwept, std::memory_order_release);
      contextCondVar.notify_all();
    }
  }

 protected:
  // input
  size_t highestPageIndex;
  size_t oldAllocatedBytes;

  // page map snapshot. contains a pointer to an array of PageLabel
  PageLabel *pageMap;
  std::atomic<size_t> refCount;

  std::mutex contextMutex;
  std::condition_variable contextCondVar;

  // output
  std::deque<address_t> deadNeighbours;
  std::atomic<size_t> emptyRuns;
  std::atomic<size_t> nonFullRuns;
  std::atomic<size_t> scanedRuns;
  std::atomic<size_t> sweptRuns;
  std::atomic<size_t> releasedObjects;
  std::atomic<size_t> releasedLargeObjects;
  std::atomic<size_t> releasedBytes;

 private:
  inline size_t TotalBytesOfPageMap() const {
    return highestPageIndex * sizeof(PageLabel);
  }

  inline void ReleaseMap() {
    // PagePool::Instance().ReturnPage(reinterpret_cast<uint8_t*>(pageMap),
    // TotalBytesOfPageMap());
    pageMap = nullptr;
  }

  inline bool TryIncRC() noexcept {
    size_t old = refCount.load(std::memory_order_acquire);
    do {
      if (old == 0) {
        return false;
      }
    } while (!refCount.compare_exchange_weak(
        old, old + 1, std::memory_order_release, std::memory_order_acquire));
    return true;
  }

  inline void DecRC() noexcept {
    size_t old = refCount.load(std::memory_order_acquire);
    while (!refCount.compare_exchange_weak(
        old, old - 1, std::memory_order_release, std::memory_order_acquire)) {
    };
    if (old == 1) {
      ReleaseMap();
    }
  }

  inline std::atomic<PageLabel> &AtomicPageState(size_t pageIndex) const {
    return reinterpret_cast<std::atomic<PageLabel> &>(*(pageMap + pageIndex));
  }

  // return false if timeout.
  inline bool WaitUntilSwept(const std::atomic<PageLabel> &state) {
    std::unique_lock<std::mutex> lock(contextMutex);
    return contextCondVar.wait_for(lock, kSweepTimeout, [&state] {
      return state.load(std::memory_order_acquire) == kPSwept;
    });
  }
};

// allocation can .. in order to succeed
enum AllocEagerness {
  kEagerLevelMin = 0,
  kEagerWaitConMark = 0,  // wait concurrent-mark finished
  kEagerWaitConSweep,     // wait concurrent-sweep finished
  kEagerLiteParallel,     // fast parallel
  kEagerFullParallel,     // full parallel, ReleaseEmptyLocalruns,
                          // ReleasePageGroups, ReleaseFreePages
  kEagerLevelMax,
};

// thread-local data structure
template <uint32_t kLocalRuns>
class ROSAllocMutator : public AllocMutator {
 public:
  static inline ROSAllocMutator *Get() {
    abort();
    return nullptr;
  }

  ROSAllocMutator() { ResetRuns(); }
  ~ROSAllocMutator() = default;

  static constexpr uint64_t kLocalAllocActivenessThreshold = 64;
  static int gcIndex;
  bool throwingOOME = false;
  bool useLocal = false;
  int mutatorGCIndex = 0;
  uint64_t allocActiveness = 0;
  uint16_t freeListSizes[kLocalRuns];
  uint32_t freeListHeads[kLocalRuns];  // a backup storage for free list heads
  FreeList freeLists[kLocalRuns];
  RunSlots *localRuns[kLocalRuns];

  inline void DisableLocalBeforeSweep(int idx) {
    if (freeLists[idx].GetHead() != 0) {
      ROSIMPL_ASSERT(freeListHeads[idx] == 0, "backup already in use");
      std::swap(*reinterpret_cast<uint32_t *>(&(freeLists[idx])),
                freeListHeads[idx]);
    }
  }

  inline void EnableLocalAfterSweep(int idx) {
    if (freeListHeads[idx] != 0) {
      ROSIMPL_ASSERT(freeLists[idx].GetHead() == 0, "free list already in use");
      std::swap(freeListHeads[idx],
                *reinterpret_cast<uint32_t *>(&(freeLists[idx])));
    }
  }

  inline address_t Alloc(int idx) {
    address_t addr = reinterpret_cast<address_t>(freeLists[idx].Fetch());
    if (LIKELY(addr != 0)) {
      --freeListSizes[idx];
    }
    return addr;
  }

  // localise a free list for this mutator for thread-local operations
  inline void Localise(int idx, FreeList &freeList, uint32_t &freeListSize) {
    this->freeLists[idx].Prepend(freeList);
    this->freeListSizes[idx] += freeListSize;
    freeListSize = 0;
  }

  // localise the free list *currently left* in the run
  // also making this run *owned* by this mutator, that is, other mutator can't
  // alloc from it
  inline void Localise(RunSlots &run) {
    // FAST_ALLOC_ACCOUNT_ADD(run.nFree * run.GetRunSize());
    Localise(run.mIdx, run.freeList, run.nFree);

    // this will make the run owned by the mutator
    // alternatively, we can only localise part of the run, i.e., the current
    // list of slots the difference is very subtle: theoretically localising
    // whole runs yields more allocation speed; localising lists yields more
    // memory efficiency
    run.SetLocalFlag(true);
    localRuns[run.mIdx] = &run;
  }

  // release the ownership of the slots in the list
  inline void Globalise(int idx, FreeList &freeList, uint32_t &freeListSize) {
    freeList.Prepend(this->freeLists[idx]);
    freeListSize += this->freeListSizes[idx];
    this->freeListSizes[idx] = 0;
  }

  // release the ownership of the run
  inline void Globalise(RunSlots &run) {
    if (freeListSizes[run.mIdx] != 0) {
      // FAST_ALLOC_ACCOUNT_SUB(freeListSizes[run.mIdx] * run.GetRunSize());
      Globalise(run.mIdx, run.freeList, run.nFree);
    }

    run.SetLocalFlag(false);
    localRuns[run.mIdx] = nullptr;
  }

  // get a local address that belongs to this mutator, this is used to compute
  // the run address
  inline address_t GetLocalAddress(int idx) const {
    return reinterpret_cast<address_t>(localRuns[idx]);
  }

  inline void ResetRuns() {
    for (size_t i = 0; i < kLocalRuns; i++) {
      freeListSizes[i] = 0;
      freeListHeads[i] = 0;
      freeLists[i].SetHead(0);
      freeLists[i].SetTail(0);
      localRuns[i] = nullptr;
    }
  }
};

// initial index is -1, so mutator's index (0) will be different
template <uint32_t kLocalRuns>
int ROSAllocMutator<kLocalRuns>::gcIndex = -1;

template class ROSAllocMutator<RunConfig::kRunConfigs>;

class FreeTask;
class BaseFreeTask;
class ConcurrentFreeTask;
class ForEachTask;

class RosAllocImpl : public Allocator {
 public:
  static const size_t kLargeObjSize = kROSAllocLargeSize;
  static const size_t kHugeObjSize = kROSAllocHugeSize;
  static const int kNumberROSRuns = RunConfig::kRunConfigs;
  static uint8_t kRunMagic;

  RosAllocImpl(LEPUSRuntime *rt, bool enable_concurrent);
  ~RosAllocImpl();
  static address_t AllocateObj(LEPUSRuntime *rt, size_t size, int alloc_tag);
  static address_t ReallocateObj(LEPUSRuntime *rt, void *ptr, size_t size,
                                 int alloc_tag);

  inline address_t NewObjInternal(size_t &size);
  inline bool NeedTriggerConcurrentPhases(size_t size) {
    return concurrent_mark_is_running || concurrent_sweep_is_running;
  }
  address_t NewObj(size_t size) override {
    *((int *)0xdeadbeef) = 0;
    return 0;
  }
  void FreeObj(address_t objAddr);
  bool ParallelFreeAllIf(MplThreadPool &threadPool);
  void ReleaseAllPageGroups();
  bool ConcurrentSweep(MplThreadPool &threadPool);
  void ForEachObj(HeapAliveObjsVisitor &visitor);
  bool ParallelForEachObj(MplThreadPool &threadPool,
                          VisitorFactory visitorFactory);

  // AccurateIsValidObjAddr(Concurrent) is used to identify heap objs when using
  // conservative stack scan, where the input addr can be a random number for
  // fast checks (precise stack scan), we use FastIsValidObjAddr
  bool AccurateIsValidObjAddr(address_t addr);
  bool AccurateIsValidObjAddrConcurrent(address_t addr);
  void TryToRecordValidObjAddr(RootSet *rootSet, address_t obj);
  address_t HeapLowerBound() const;
  address_t HeapUpperBound() const;
  void Init(const VMHeapParam &) override;

  std::vector<address_t> DumpHeap();

  PageGroups &GetPageGroups() { return allocSpace.page_groups; }

  // releases the empty range of pages at the end of the heap.
  // returns true if any pages were released
  // It grabs the global lock
  bool ReleaseFreePages(bool aggressive = false);
  void IterateCTree();
  void ReleaseEmptyLocalruns();
  // This function computes the capacity by (end addr - begin addr)
  // This doesn't reflect the actual physical memory usage
  size_t GetCurrentSpaceCapacity() const { return allocSpace.GetSize(); }
  // returns the estimate value of current available bytes in the space. this is
  // an approximate because it does not account for the space occupied by run
  // headers
  size_t GetCurrentFreeBytes() const {
    // get the live bytes in the heap
    size_t allocatedSize = AllocatedMemory();
    // the current free bytes is equal to (current heap size - allocated size)
    size_t heapSize = GetCurrentSpaceCapacity();
    ROSIMPL_ASSERT(heapSize >= allocatedSize, "heap stats error");
    return (heapSize - allocatedSize);
  }
  // This function sums the size of the non-released pages in the heap
  // Only non-released pages are backed by actual physical memory
  size_t GetActualSize() const { return allocSpace.GetNonReleasedPageSize(); }

  // returns the current available page count within the reserved virtual memory
  size_t GetAvailPages() {
    ALLOC_LOCK_TYPE guard(ALLOC_CURRENT_THREAD globalLock);
    return allocSpace.GetAvailPageCount();
  }

  // returns the approximate number of pages being used within the current
  // reserved memory range.
  size_t GetUsedPages() {
    ALLOC_LOCK_TYPE guard(ALLOC_CURRENT_THREAD globalLock);
    return ALLOCUTIL_PAGE_BYTE2CNT(allocSpace.GetAllocatedPageSize());
  }

  size_t GetMaxCapacity() const { return allocSpace.GetMaxCapacity(); }

  // HasAddress/FastIsValidObjAddr is a range-based check, used to quickly
  // identify heap objs, assuming non-heap objs never fall into the same address
  // range for a more accurate check, use AccurateIsValidObjAddr(Concurrent)
  inline bool HasAddress(address_t addr) const {
    return true;
    // return HeapStats::IsHeapAddr(addr);
  }
  inline bool FastIsValidObjAddr(address_t addr) {
    return ((addr & (kAllocAlign - 1)) == 0) && allocSpace.HasAddress(addr);
  }

  address_t GetValidHeapAddr(address_t addr);

  // Concurrent sweep heap pages.
  // if thread_pool not null, do it parallel.
  // DO Not trim heap when this function is running.
  void ConcurrentSweep(MplThreadPool *threadPool);

#ifdef ALLOC_ENABLE_LOCK_CONTENTION_STATS
  // because some runs are deleted, we need to record the
  // contention stats of the page locks in the deleted runs
  static uint32_t pageLockContentionRec;
  static uint64_t pageLockWaitTimeRec;
#endif
  inline void DumpContention(std::basic_ostream<char> &os) const {
    // no longer supported
    (void)os;
  }

  size_t GetAllocatedInternalSize() { return allocatedInternalSize; }

  bool InGCPauseSuppressionMode() {
    return gcPauseSuppressionMode && allocSpace.GetSize() < 240 * MB;
  }

  inline void ReleasePageGroups() { allocSpace.ReleaseFreeGroups(); }

  void UpdateHeapSizeLimitForBusymode(size_t alloc_size) {
    // should disable InternalSize trig GC during busymode, otherwise the GC
    // will be trig several times and eventually throw oom
    return allocSpace.UpdateHeapSizeLimitForBusymode(alloc_size,
                                                     allocatedInternalSize);
  }

  void ConSweepPrologue();
  void ConMarkPrologue();
  void ConSweepEpilogue();
  // traverse each pagegroup and reset concurrent-mark flag(in pagegroup header)
  void ConMarkEpilogue();
  void SweepLocalRuns(
      std::function<bool(address_t, ROS_GC::Bitmap *)> &shouldFree);
  void SweepNonFullRuns(
      std::function<bool(address_t, ROS_GC::Bitmap *)> &shouldFree);
  void SweepRunForConSweepPrologue(
      RunSlots &run,
      std::function<bool(address_t, ROS_GC::Bitmap *)> &shouldFree,
      PageGroups &groups);
  bool SweepHugeObjs(
      std::function<bool(address_t, ROS_GC::Bitmap *)> shouldFree);

  // Mark related funciotns.
  bool MarkObject(address_t obj_addr) {
    ROSIMPL_ASSERT(obj_addr, "obj_addr is null");
    // todo, reopen this check
    // ROSIMPL_ASSERT(AccurateIsValidObjAddr(obj_addr), "obj_addr is not
    // valid");
    Bitmap *bit_map = PageGroups::GetBitMapFromAddr(obj_addr);
    if (bit_map == nullptr) return false;
    return bit_map->MarkObject(obj_addr);
  }
  void UnMarkObject(address_t obj_addr) {
    Bitmap *bit_map = PageGroups::GetBitMapFromAddr(obj_addr);
    bit_map->UnMarkObject(obj_addr);
  }
  // used in cold path, to help cpu preload instructions more performance
  bool __attribute__((noinline)) MarkObjectNoInline(address_t obj_addr) {
    return MarkObject(obj_addr);
  }
  bool IsObjectMarked(address_t obj_addr) {
    Bitmap *bit_map = PageGroups::GetBitMapFromAddr(obj_addr);
    return bit_map->IsObjectMarked(obj_addr);
  }
  void MarkPrologue() {
    allocSpace.page_groups.CopySortedGroups();
    remarkCounter = 0;
    {
      // reinit con-sweep flags
      conSweepFinished = false;
    }
  }
  void MarkEpilogue() { allocSpace.page_groups.ClearSortedGroupsSnapshot(); }

  void SetCollector(MarkSweepCollector *collect) {
    collector = collect;
    return;
  }
  MarkSweepCollector *GetCollector() { return collector; }

  void SetConcurrentMarkState(bool flag) { concurrent_mark_is_running = flag; }
  bool GetConcurrentMarkState() { return concurrent_mark_is_running; }
  bool GetConcurrentSweepState() { return concurrent_sweep_is_running; }
  void EnableMarkNewObj() { should_mark_new_obj = true; }
  void DisableMarkNewObj() { should_mark_new_obj = false; }

  // Worker thread related.
  void SetWorkerThreadPoolInMainThread(MplThreadPool *threadPool) {
    ROSIMPL_ASSERT(threadPool, "Thread pool is null during set");
    workerThreadPool = threadPool;
  }
  MplThreadPool *GetWorkerThreadPool() {
    ROSIMPL_ASSERT(workerThreadPool, "Thread pool is null during get");
    return workerThreadPool;
  }

  void IncRemarkCounter() { remarkCounter++; }

  size_t GetRemarkCounter() { return remarkCounter; }

  // PtrHandles *GetPtrHandles() {
  //   return ptr_handles;
  // }
  void SetConMarkFinishedState(bool state) { conMarkFinished = state; }

  void SetConSweepFinishedState(bool state) { conSweepFinished = state; }

  bool GetConSweepFinishedState() { return conSweepFinished; }

  bool GetConMarkFinishedState() { return conMarkFinished; }
  LEPUSRuntime *GetRuntime() { return rt_; }

  GCTracer *GetGCTracer() { return allocSpace.GetGCTracer(); }

  bool GetEnableConcurrent() { return enable_concurrent_; }

  void SetConcurrentSweepRunning(bool state) {
    concurrent_sweep_is_running = state;
  }

  void SetGCPauseSuppressionMode(bool mode) { gcPauseSuppressionMode = mode; }
  bool GetGCPauseSuppressionMode() { return gcPauseSuppressionMode; }

#ifdef ENABLE_RTS_GC_DEBUG
  void DumpSpace() const;
#endif  // ENABLE_RTS_GC_DEBUG

#define DEFINE_GC_SCOPER_DECLARATION(ActionType)                               \
 public:                                                                       \
  virtual void Set##ActionType##GC(bool enabled) { ActionType##GC = enabled; } \
                                                                               \
 private:                                                                      \
  bool ActionType##GC{false};

  DEFINE_GC_SCOPER_DECLARATION(Forbid)
  DEFINE_GC_SCOPER_DECLARATION(Force)
#undef DEFINE_GC_SCOPER_DECLARATION
#ifdef ENABLE_GC_LOG
 public:
#define GENERATE_GET_STATICS_IN_MB_FUNCTION_FOR_GC_LOG(FUNC_NAME, STATICS) \
  double FUNC_NAME() { return (double)(STATICS) / MB; }

  GENERATE_GET_STATICS_IN_MB_FUNCTION_FOR_GC_LOG(GetHeapSizeInMBForGCLog,
                                                 allocSpace.heapSize)
  GENERATE_GET_STATICS_IN_MB_FUNCTION_FOR_GC_LOG(GetUsedHeapSizeInMBForGCLog,
                                                 allocatedInternalSize)
  GENERATE_GET_STATICS_IN_MB_FUNCTION_FOR_GC_LOG(
      GetTotalReleasedBytesInMBForGCLog, totalReleasedBytesForGCLog)

#undef GENERATE_GET_STATICS_IN_MB_FUNCTION_FOR_GC_LOG

  double GetTotalReleasedBytesInMBAndResetForGCLog() {
    double ret = GetTotalReleasedBytesInMBForGCLog();
    totalReleasedBytesForGCLog = 0;
    return ret;
  }

 private:
#define RecordTotalReleasedBytesForGCLog(releasedBytes) \
  totalReleasedBytesForGCLog += releasedBytes

  atomic<size_t> totalReleasedBytesForGCLog{0};
#else
 private:
#define RecordTotalReleasedBytesForGCLog(releasedBytes)
#endif  // ENABLE_GC_LOG

 private:
#define DCHECK_OBJ_IS_ALLOCATED_BY_ALLOCATOR(memAddr) \
  ROSIMPL_ASSERT(IsAllocatedByAllocator(memAddr),     \
                 "obj isn't allocated by allocator");

  friend FreeTask;
  friend BaseFreeTask;
  friend ConcurrentFreeTask;
  friend ForEachTask;
  friend RunSlots;

  bool concurrent_mark_is_running = false;
  bool conMarkFinished = false;
  bool conSweepFinished = false;
  bool concurrent_sweep_is_running = false;
  bool should_mark_new_obj = false;

  // The instance space associated with the allocator
  Space allocSpace;
  LEPUSRuntime *rt_;
  bool enable_concurrent_;
  bool gcPauseSuppressionMode;
  // PtrHandles *ptr_handles = nullptr;
  ALLOC_MUTEX_TYPE runLocks[kNumberROSRuns];
  ThreeTierList<RunSlots> nonFullRuns[kNumberROSRuns];
  address_t pageBuf = 0;
  // Unit is page
  size_t pageBufSize = 0;

  ROSAllocMutator<RunConfig::kRunConfigs> globalMutator;

  // context data for concurrent sweep.
  SweepContext sweepContext;
  atomic<size_t> allocatedInternalSize = 0;
  MarkSweepCollector *collector = nullptr;
  MplThreadPool *workerThreadPool{nullptr};
  size_t remarkCounter = 0;

  // inline functions that are used within the allocator (not exposed)
  static inline void InitkRunMagicIfNeeded();
  static inline void CheckRunMagic(RunSlots &run);
  static inline uint32_t GetRunIdx(size_t size);
  static inline uint32_t GetPagesPerRun(int index);
  static inline size_t GetRunSize(int index);
  inline address_t AllocRun(int idx, int eagerness);
  inline RunSlots *FetchRunFromNonFulls(int idx);
  inline RunSlots *FetchOrAllocRun(int idx, int eagerness);
  enum LocalAllocResult {
    kLocalAllocSucceeded = 0,
    kLocalAllocFailed,
    kLocalAllocDismissed
  };
  template <uint32_t kLocalRuns>
  inline address_t AllocFromLocalRun(ROSAllocMutator<kLocalRuns> &mutator,
                                     int idx, int eagerness);
  inline address_t AllocFromGlobalRun(int idx, int eagerness);
  inline address_t AllocFromRun(size_t &internalSize, int eagerness);
  // inline void RevokeLocalRun(RosBasedMutator &mutator, RunSlots &run);
  inline size_t FreeFromRun(RunSlots &run, address_t internalAddr);
  inline bool UpdateGlobalsAfterFree(RunSlots &run, bool wasFull);
  inline void SweepSlot(RunSlots &run, address_t slotAddr);
  inline bool LocalRunIsEmpty(RunSlots &run);
  inline void SweepRun(RunSlots &run, Bitmap *markBitmap, size_t &releasedSize);
  inline void ConcurrentSweepRun(RunSlots &run, Bitmap *markBitmap);
  // tries to allocate an object given the size
  inline address_t AllocInternal(size_t &allocSize);
  // returns the number of bytes freed including overhead.
  inline size_t FreeInternal(address_t objAddr);
#ifndef _WIN32
  inline void ForEachObjInRun(
      RunSlots &run, HeapAliveObjsVisitor &visitor,
      size_t numHint = numeric_limits<size_t>::max()) const;
#endif
  inline bool AccurateIsValidObjAddrUnsafe(address_t addr);

  address_t AllocPagesInternal(size_t reqSize, size_t &actualSize,
                               int forceLevel, uint32_t &idx);

  address_t AllocLargeObject(size_t &allocSize, int forceLevel);
  address_t AllocHugeObject(size_t &allocSize);
  address_t AllocHugeInternal(size_t allocSize);
  void DecreaseAllocatedInternalSize(size_t size) {
    allocatedInternalSize -= size;
  }
  void FreeLargeObj(address_t objAddr, size_t &internalSize, uint32_t pageIdx);
  void SweepLargeObj(address_t objAddr, size_t &internalSize, uint32_t pageIdx);
  void SweepHugeObj(PageGroup &group, size_t &internalSize);
  void FreeHugeObj(PageGroup &group, size_t &internalSize);
  bool SweepPage(size_t, size_t &);
  void SweepPages(size_t, size_t);

  // Handle the case when we fail to allocate. force level will pass the context
  // of the situation, this will allow to change the aggressiveness of the
  // memory allocation
  bool HandleAllocFailure(size_t allocSize, int &forceLevel);
  void FreeRun(RunSlots &run, bool delayFree = false);
  // void RevokeLocalRuns(RosBasedMutator &mutator);

#if defined(ENABLE_DEBUG)
 private:
#define CheckObjHasValidKlassForDebug(memAddr)

#define InitWithAllocatedBitForDebug(allocAddr) InitWithAllocatedBit(allocAddr);
#else
 private:
#define CheckObjHasValidKlassForDebug(memAddr)
#define InitWithAllocatedBitForDebug(allocAddr)
#endif  // defined(ENABLE_DEBUG)
 private:
#define CheckHasAddressGCedForAsan(addr)
#define EarlyReturnIfGroupIsGCed(group)
#define InterceptSigbusAsan(ros)
#define NewObjPrologueForAsan()
#define NewObjEpilogueForAsan()
#define ResetCurDealtObjAddrIsInAsanObjAddrSetAndEarlyReturnIfNeedForAsan()
#define SetHeapGrowthLimitForAsan()

  bool TryToReleaseHugeMemForAsan(PageGroup &group) { return false; }
  bool TryToFreeRegionForAsan(address_t bigObjAddr, size_t pageCnt,
                              uint32_t pageIdx) {
    return false;
  }

 public:
  void SetHeapSize(size_t size) { allocSpace.SetHeapSize(size); }
  size_t GetHeapSize() { return allocSpace.heapSize; }
  size_t GetHeapGrowthLimit() { return allocSpace.heapGrowthLimit; }
  void SetHeapGrowthLimit(size_t growthLimit) {
    allocSpace.heapGrowthLimit = growthLimit;
  }
  size_t GetAllocatedSize() { return allocatedInternalSize; }

 public:
  int js_ref_count = 0;
  size_t outer_heap_size = 0;
  int gc_cnt = 0;
};  // class RosAllocImpl
}  // namespace ROS_GC
#endif  // RTS_GC_ROSALLOCATOR_H
