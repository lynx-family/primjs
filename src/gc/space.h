#ifndef SRC_GC_SPACE_H_
#define SRC_GC_SPACE_H_

#include <cstdint>
#include <memory>
#include <string>
using namespace std;

#include "gc/alloc_config.h"
#include "gc/cartesian_tree.h"
#include "gc/gc_tracer.h"
#include "gc/mem_map.h"
#include "gc/page_group.h"
#include "gc/page_map.h"

namespace ROS_GC {
class Space;
class SpacePageManager {
 public:
  SpacePageManager(Space &allocSpaceVal, uintptr_t begin)
      : allocSpace(allocSpaceVal), baseAddress(begin) {}
  ~SpacePageManager() = default;
  void SetBaseAddress(uintptr_t baseAddr) { baseAddress = baseAddr; }

  // given size in bytes we return the size normalized to pages (4k)
  inline uint32_t CalcChunkSize(size_t regionSize) const;

  // given index of a region, calculate the page address
  inline uintptr_t GetRegionAddrFromIdx(uint32_t idx) const;

  // given the first page and the size of memory region in bytes, we add
  // it to the set of free chunks
  void AddRegion(uintptr_t regionAddr, size_t regionSize);
  // add contiguous pages of count page_count starting with first_page
  void AddPages(uintptr_t firstPage, uint32_t pageCount, uint32_t pageIdx);
  void AddPages(size_t first_page, size_t pageCount) {
    if (UNLIKELY(!pageCTree.MergeInsert(first_page, pageCount))) {
      abort();
    }
    return;
  }

  // release all free pages back to the system
  void ReleaseAllFreePages(size_t freeBytes, bool isAggressive);
  // return released groups's cnt.
  size_t ReleaseAllFreeGroups();
  void IterateCTree();

  // Given a request size, we split the first chunk and return the
  // address to the first page
  uintptr_t GetChunk(size_t reqSize, uint32_t &idx);

  inline uint32_t CalcPageIdx(uintptr_t pageAddr) const;

  size_t GetLargestChunkSize();

 private:
  friend Space;
  friend PageGroups;
  using TreeType = CartesianTree<uint32_t, uint32_t>;
  Space &allocSpace;
  uintptr_t baseAddress;
  TreeType pageCTree;
};  // end of SpacePageManager

enum UpdateHeapType {
  kParallel = 0,
  kConMark,
  kReMark,
  kConSweep,
  kForbidGC,
  kPolicyChange
};

class Space {
 public:
  // These parameters can be set via methods Space::SetXXX().
  // Currently they are called before Space::Init(). They take
  // the values from the configuration of the virtual machine.
  // Default configuration (please check the corresponding .prop files to
  // confirm): kReleasePageAtFree/kReleasePageAtTrim: set in alloc_config.h heap
  // start size: 8m heap size: 512m heap growth limit: 384m heap min free: 2m
  // heap max free: 8m
  // heap target utilization: 0.75
  // ignore max footprint: see runtime.cc
  //
  // they are not constant..
  // whether to release pages immediately after we free them
  bool releasePageAtFree;
  // whether to release free pages all together at a separate phase we call
  // "trim"
  bool kReleasePageAtTrim;
  // the initial size of the heap
  size_t heapStartSize;
  // the maximum heap size
  size_t heapSize;
  size_t heapGrowthLimit;
  // the minimum size of free pages, unused
  size_t heapMinFree;
  // the maximum size of free pages, used to trigger trim
  size_t heapMaxFree;
  // the following is unused
  // target utilization rate of the heap
  float heapTargetUtilization;

  // 1s interval for trim, to prevent impeding performance
  const uint64_t kMinTrimInterval = 1000;  // ms
  // non-aggressive trim max time
  const uint64_t kMaxTrimTime = 10000;  // us

  uint8_t lastGCType = kConMark;

  bool newGroupNeeded{false};

  // this controls how many free pages we don't release (return to the os)
  inline size_t TargetFreePageSize() const { return heapMaxFree >> 1; }

  inline void SetHeapStartSize(size_t startSize) { heapStartSize = startSize; }
  inline void SetHeapSize(size_t size) {
    size_t heap_size = AllocUtilRndUp(kRosDefaultPageGroupSize, size);
    heapSize = heap_size;
  }
  inline void SetHeapGrowthLimit(size_t growthLimit) {
    heapGrowthLimit = growthLimit;
  }
  inline void SetHeapMinFree(size_t minFree) { heapMinFree = minFree; }
  inline void SetHeapMaxFree(size_t maxFree) { heapMaxFree = maxFree; }
  inline void SetHeapTargetUtilization(float targetUtilization) {
    heapTargetUtilization = targetUtilization;
  }

  GCTracer *GetGCTracer() { return &gcTracer; }

 public:
  string name;     // full name of the space
  string tag;      // tag to identify the memory region in smaps
  bool isManaged;  // whether the space is under the management of RC/GC
  // we do out-of-lock reads to the following fields for gc trigger heuristics
  // as long as this fields are aligned, we don't have to worry about atomicity
  // problems total size of pages allocated
  size_t allocatedPageSize;
  // total size of pages fetched from the kernel
  // 'release' is the action of returning physical memory pages back to the
  // kernel if a page is 'non-released', it means we still occupy the
  // corresponding physical memory
  size_t nonReleasedPageSize;

  // size of memory that can use to allocate rts object
  size_t usedMemSize;
  // size of memory that acquired from OS
  size_t usedHeapSize;
  GCTracer gcTracer;

  friend class SpacePageManager;
  // the page manager manages all of the free pages (including released pages)
  SpacePageManager pageManager;
  PageGroups page_groups;

  // records the last time we trimed
  uint64_t lastTrimTime;
  inline bool IsTrimAllowedAtTheMoment() { return false; }

 public:
  Space(const string &nameVal, const string &tagVal, bool managed);
  virtual ~Space();
  Space(const Space &that) = delete;
  Space(Space &&that) = delete;
  Space &operator=(const Space &that) = delete;
  Space &operator=(Space &&that) = delete;

  void Init(uint8_t *reqStart = nullptr);

  // Name of the space. May vary, for example before/after the Zygote fork.
  const char *GetName() const { return name.c_str(); }

  size_t GetMaxCapacity() const { return heapSize; }

  size_t GetSize() const { return usedHeapSize; }

  size_t GetHeapHeadroom() const {
    const size_t heap_size = heapSize;
    const size_t used_heap_size = usedHeapSize;
    return heap_size > used_heap_size ? heap_size - used_heap_size : 0;
  }

  // Get the size of the allocated pages
  inline size_t GetAllocatedPageSize() const { return allocatedPageSize; }
  // Get the size of the non-released pages
  inline size_t GetNonReleasedPageSize() const { return nonReleasedPageSize; }
  // Get the size of the free pages
  inline size_t GetFreePageSize() const {
    return nonReleasedPageSize - allocatedPageSize;
  }

  inline size_t HeapMaxFreeByUtilization() const {
    // maximum is twice the ideal
    // cap this for the same reason
#ifndef _WIN32
    return std::min(TargetFreePageSizeByUtilization() << 1, heapMaxFree);
#else
    return 0;
#endif
  }

  size_t TargetFreePageSizeByUtilization() const;

  inline void RecordReleasedToNonReleased(size_t pageCount) {
    nonReleasedPageSize += ALLOCUTIL_PAGE_CNT2BYTE(pageCount);
  }

  // returns the number of pages free within the reserved memry space
  size_t GetAvailPageCount() const;

  uintptr_t GetChunk(size_t reqSize, uint32_t &idx);
  size_t GetLargestChunkSize();

  inline bool HasAddress(address_t addr) {
    return page_groups.HasAddress(addr);
  }

  void Extend(size_t deltaSize);
  address_t NewHugeGroup(size_t req_size) {
    if (GetHeapHeadroom() < req_size) {
      return 0;
    }
    PageGroup &group = page_groups.NewHugeMem(req_size);
    usedHeapSize += group.GetMemMapedSize();
    size_t groupMemSize = group.GetMaxCapacity();
    allocatedPageSize += groupMemSize;
    usedMemSize += groupMemSize;
    return group.GetBegin();
  }

  address_t Alloc(size_t reqSize, bool allowExtension, uint32_t &idx,
                  int forceLevel);
  size_t ReleaseFreePages(bool aggressive = false);
  void FreeRegion(address_t addr, size_t pgCnt, uint32_t pageIdx);
  // allocatedPageSize have updated at FreeRegion, so we just update
  // usedHeapSize&usedMemSize
  size_t ReleaseFreeGroups() {
    size_t cnt = pageManager.ReleaseAllFreeGroups();
    usedHeapSize -= (cnt * kRosDefaultPageGroupSize);
    usedMemSize -= (cnt * kRosDefaultPageGroupValidSize);

    // to help decrease heapSize when encounter severe fragmentation
    if (heapSize > kForceDecHeapSizeThreshold * kGCPolicyThreshold && cnt > 0) {
      heapSize -= cnt * kRosDefaultPageGroupSize;
    }
    return cnt;
  }

  void ReleaseHugeMem(PageGroup &group) {
    usedHeapSize -= group.GetMemMapedSize();
    size_t groupMemSize = group.GetMaxCapacity();
    usedMemSize -= groupMemSize;
    allocatedPageSize -= groupMemSize;
    // statistics should be updated before Release-operation, or some memory may
    // be untouched
    page_groups.ReleaseHugeMem(group);
  }

  void AutoAdjustHeapSize(size_t allocSize, size_t allocatedInternalSize);
  void UpdateHeapSizeLimit(uint8_t gc_type, size_t allocSize,
                           size_t allocatedInternalSize,
                           size_t newHeapSize) noexcept;
  void UpdateHeapSizeLimitForBusymode(size_t alloc_size,
                                      size_t allocatedInternalSize) noexcept;

#if defined(ENABLE_DEBUG)
#define CheckHeapSizeChangeTrendForDebug(gc_type)                            \
  bool expectedHeapSizeChangeTrendForDebug = false;                          \
  if (gc_type == kForbidGC) {                                                \
    expectedHeapSizeChangeTrendForDebug = heapSize > originHeapSize;         \
    expectedHeapSizeChangeTrendForDebug |=                                   \
        (originHeapSize == heapGrowthLimit);                                 \
  } else {                                                                   \
    expectedHeapSizeChangeTrendForDebug =                                    \
        heapSize >= kRosDefaultPageGroupSize && heapSize <= heapGrowthLimit; \
  }                                                                          \
  ROSIMPL_ASSERT(expectedHeapSizeChangeTrendForDebug,                        \
                 "unexpected heap size change trend");
#else
#define CheckHeapSizeChangeTrendForDebug(gc_type)
#endif  // defined(ENABLE_DEBUG)
};      // class Space

// given index of a region, calculate the page address
inline uintptr_t SpacePageManager::GetRegionAddrFromIdx(uint32_t idx) const {
  return allocSpace.page_groups.GetPageAddr(idx);
}

inline uint32_t SpacePageManager::CalcPageIdx(uintptr_t pageAddr) const {
  return allocSpace.page_groups.GetPageIdx(pageAddr);
}

}  // namespace ROS_GC

#endif  // SRC_GC_SPACE_H_
