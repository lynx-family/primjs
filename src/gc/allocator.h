#ifndef SRC_GC_ALLOCATOR_H_
#define SRC_GC_ALLOCATOR_H_

#include <cstdlib>
#include <functional>
#include <mutex>
#include <string>

#include "gc/alloc_config.h"
#include "gc/structs.h"

#define ALLOC_MUTEX_TYPE std::mutex
#define ALLOC_LOCK_TYPE std::lock_guard<mutex>
#define ALLOC_CURRENT_THREAD

namespace ROS_GC {
// The allocator collects five kinds of data from the heap:
// 1. Fragmentation related: the utilisation of the heap
// 2. Per-mutator allocation data: this is non-atomic
// 3. Global allocation data: this is atomic
// 4. Allocation time statistics
// 5. Lock contention statistics
// These are written in the contract and every allocator implementation should
// support them. Additional stats can be supported by adding callbacks to the
// callback interface.
class FragmentationRecord {
 public:
  // this is allocator-specific, move into allocator implementation header
  size_t GetExternalFragmentation() const {
    return runFreeSlots + runOverhead + freePages;
  }
  size_t GetInternalFragmentation() const { return internal; }
  size_t GetRCHeader() const { return rcOverhead; }
  size_t GetBytesInFreePages() const { return freePages; }
  size_t GetBytesInPages() const { return totalPages; }
  size_t GetFreeSlots() const { return runFreeSlots; }
  size_t GetSlots() const { return runTotalSlots; }
  size_t GetRunCacheVolume() const { return runCacheVolume; }
  size_t GetRunOverhead() const { return runOverhead; }
  size_t GetRun(bool isFree) const {
    if (isFree) {
      return freeRun;
    } else {
      return totalRun;
    }
  }

  void RecordInternalFrag(size_t totalBytes, size_t requestedBytes) {
    internal = totalBytes - requestedBytes;
  }

  void IncFreePages(size_t bytes) { freePages += bytes; }
  void IncPages(size_t bytes) { totalPages += bytes; }
  void IncFreeSlots(size_t bytes) { runFreeSlots += bytes; }
  void IncSlots(size_t bytes) { runTotalSlots += bytes; }
  void IncRunOverhead(size_t bytes) { runOverhead += bytes; }
  void IncRunCacheVolume(size_t bytes) { runCacheVolume += bytes; }
  void IncRun(size_t bytes, bool isFree) {
    if (isFree) {
      freeRun += bytes;
    }
    totalRun += bytes;
  }

  FragmentationRecord()
      : internal(0),
        freePages(0),
        totalPages(0),
        runFreeSlots(0),
        runTotalSlots(0),
        runOverhead(0),
        rcOverhead(0),
        runCacheVolume(0),
        freeRun(0),
        totalRun(0) {}
  ~FragmentationRecord() = default;

  void Reset() {
    internal = 0;
    freePages = 0;
    totalPages = 0;
    runFreeSlots = 0;
    runTotalSlots = 0;
    runOverhead = 0;
    rcOverhead = 0;
    runCacheVolume = 0;
    freeRun = 0;
    totalRun = 0;
  }

 private:
  // fragmentation fields:
  size_t internal;   // internal frag. caused by rc/gc header and alignment
  size_t freePages;  // external frag. free pages in bytes not yet allocated
  size_t totalPages;
  size_t runFreeSlots;  // external frag. total bytes of the free slots
  size_t runTotalSlots;
  size_t runOverhead;  // external frag. total bytes of the run header and the
                       // trailing space
  // extra fields:
  size_t rcOverhead;      // total bytes used by RC header
  size_t runCacheVolume;  // bytes consumed by the cached runs
  size_t freeRun;
  size_t totalRun;
};  // class FragmentationRecord

class AccUnSynchedSizeField {
 public:
  inline size_t LoadSize() const { return val; }
  inline void Inc(size_t param) { val += param; }
  inline void Dec(size_t param) { val -= param; }
  inline void Init() { val = 0; }
  AccUnSynchedSizeField() : val(0) {}
  ~AccUnSynchedSizeField() = default;

 private:
  size_t val;
};

class AccSynchedSizeField {
 public:
  inline size_t LoadSize() const { return val.load(std::memory_order_relaxed); }
  inline void Inc(size_t param) {
    (void)val.fetch_add(param, std::memory_order_relaxed);
  }
  inline void Sub(size_t param) {
    (void)val.fetch_sub(param, std::memory_order_relaxed);
  }
  inline void Dec(size_t param) {
    (void)val.fetch_sub(param, std::memory_order_relaxed);
  }
  inline void Init() { val.store(0, std::memory_order_seq_cst); }
  AccSynchedSizeField() : val(0) {}
  ~AccSynchedSizeField() = default;

 private:
  std::atomic<size_t> val;
};

template <class SizeField>
class AllocAccounting {
 public:
  inline size_t GetNetBytes() const { return netBytes.LoadSize(); }
  inline size_t GetNetObjs() const { return netObjs.LoadSize(); }
  inline size_t GetNetObjBytes() const { return netObjBytes.LoadSize(); }
  inline size_t GetNetLargeObjBytes() const {
    return netLargeObjBytes.LoadSize();
  }

  AllocAccounting() {
    netBytes.Init();
    netObjs.Init();
    netObjBytes.Init();
    netLargeObjBytes.Init();
    totalFreedBytes.Init();
    totalFreedObjBytes.Init();
    totalFreedObjs.Init();
    totalAllocdBytes.Init();
    totalAllocdObjs.Init();
    totalAllocdObjBytes.Init();
  }
  ~AllocAccounting() = default;
  inline size_t TotalAllocdBytes() { return totalAllocdBytes.LoadSize(); }
  inline size_t TotalFreedBytes() { return totalFreedBytes.LoadSize(); }
  inline size_t TotalAllocdObjs() { return totalAllocdObjs.LoadSize(); }
  inline size_t TotalFreedObjs() { return totalFreedObjs.LoadSize(); }
  inline void AtAlloc(size_t objSize, size_t internalSize, bool isLarge) {
    netBytes.Inc(internalSize);
    netObjBytes.Inc(objSize);
    netObjs.Inc(1);
    if (UNLIKELY(isLarge)) {
      netLargeObjBytes.Inc(objSize);
    }
  }
  inline void AtFree(size_t objSize, size_t internalSize, bool isLarge) {
    netBytes.Dec(internalSize);
    netObjBytes.Dec(objSize);
    netObjs.Dec(1);
    if (UNLIKELY(isLarge)) {
      netLargeObjBytes.Dec(objSize);
    }
  }
  inline void ResetWindowTotal() {
    totalFreedBytes.Init();
    totalFreedObjBytes.Init();
    totalFreedObjs.Init();
    totalAllocdBytes.Init();
    totalAllocdObjs.Init();
    totalAllocdObjBytes.Init();
  }

 private:
  SizeField netBytes;
  SizeField netObjBytes;
  SizeField netObjs;
  SizeField netLargeObjBytes;  // net bytes excluding overhead

  // these are for total numbers in a time window, caution there is no overflow
  // protection
  SizeField totalAllocdBytes;     // total bytes including overhead
  SizeField totalAllocdObjBytes;  // total bytes excluding overhead
  SizeField totalAllocdObjs;      // total number of objects allocated
  SizeField totalFreedBytes;      // total bytes including overhead
  SizeField totalFreedObjBytes;   // total bytes excluding overhead
  SizeField totalFreedObjs;       // total number of objects freed
};

// the allocator uses a version that does requires atomic instructions, because
// multiple threads could do the same operation concurrently
using SynchedAllocAccounting = AllocAccounting<AccSynchedSizeField>;
// the mutator uses a light weight version that does not require atomic
// instructions
using UnsyncAllocAccounting = AllocAccounting<AccUnSynchedSizeField>;

struct VMHeapParam {
  size_t heapStartSize;
  size_t heapGrowthLimit;
  size_t heapMinFree = {0};
  size_t heapMaxFree = {0};
  float heapTargetUtilization = {0.0};
};
class AllocMutator {
 public:
  // virtual void Init() = 0;
  // virtual void Fini() = 0;
  AllocMutator() = default;

  virtual ~AllocMutator() = default;
  AllocMutator(AllocMutator const &) = delete;
  void operator=(AllocMutator const &x) = delete;
  inline UnsyncAllocAccounting &GetAllocAccount() { return account; }

 public:
  // the mutator uses a light weight version that does not require atomic
  // instructions this is currently not properly instrumented, use the
  // global/atomic version instead
  UnsyncAllocAccounting account;
};  // class AllocMutator

// Allocator abstract class
class Allocator {
 public:
  // For methods that visit objects via callback functions.
  using VisitorFactory = std::function<HeapAliveObjsVisitor()>;

  // returns the total number of objs allocated
  inline size_t AllocatedObjs() const { return account.GetNetObjs(); }

  // returns the total bytes that has been occupied
  // to be specific, this is the sum of internal size of all allocated objects
  inline size_t AllocatedMemory() const { return account.GetNetBytes(); }

  // returns the total size of the objects allocated
  // the difference between requested memory and allocated memory, is that
  // allocated memory sums internal size, whereas requested memory sums raw obj
  // size (no header)
  inline size_t RequestedMemory() const { return account.GetNetObjBytes(); }

  inline SynchedAllocAccounting &GetAllocAccount() { return account; }

  // callback before allocation
  __attribute__((always_inline)) void PreObjAlloc(address_t objAddress,
                                                  size_t objSize) const;

  // callback after allocation
  // objSize is the requested object size
  // internalSize is the size including overhead
  inline void PostObjAlloc(address_t objAddress, size_t objSize,
                           size_t internalSize);

  // callback before free. returns the object size
  template <bool isFast = false>
  __attribute__((always_inline)) size_t PreObjFree(address_t objAddress) const {
    return 0;
  };

  // callback after free
  // internalSize is the bytes occupied by the object including overhead
  template <bool isFast = false>
  __attribute__((always_inline)) void PostObjFree(address_t objAddress,
                                                  size_t objSize,
                                                  size_t internalSize) {}

  virtual void Init(const VMHeapParam &) = 0;

  // Allocate space for a new object of the requested size
  virtual address_t NewObj(size_t size) = 0;

  static void ReleaseResource(address_t obj) {}

  virtual ~Allocator() {}
  Allocator() = default;
  void NewOOMException();

  // Allocation tracking support, set callback
  void SetAllocRecordingCallback(
      std::function<void(address_t, size_t)> allocRecordingCallbackFunc) {
    mAllocRecordingCallbackFunc = allocRecordingCallbackFunc;
  }

 public:
  SynchedAllocAccounting account;

 protected:
  std::atomic<bool> oomeCreated;
  ALLOC_MUTEX_TYPE globalLock;
  // Allocation tracking support, recorder callback
  std::function<void(address_t, size_t)> mAllocRecordingCallbackFunc = nullptr;
};
}  // namespace ROS_GC

#endif
