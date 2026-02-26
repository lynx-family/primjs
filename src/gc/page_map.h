#ifndef SRC_GC_PAGE_MAP_H_
#define SRC_GC_PAGE_MAP_H_

#include "gc/alloc_config.h"
#include "gc/alloc_utils.h"
#include "gc/mem_map.h"
#include "gc/structs.h"

// This file declares a page map and its operations for use in the allocator
namespace ROS_GC {
// Enable this to count the total incs and decs of a page.
#define MRT_RESURRECTION_PROFILE 0

// rename these?
enum PageLabel : uint8_t {
  kPReleased = 0,
  kPFree,
  kPRun,
  kPRunRem,
  kPLargeObj,
  kPLargeObjRem,
  kPSweeping,
  kPSwept,
  kPMax,
};

// This class records the number of un-resurrected finalizable objects in each
// page.
class FinalizableProf {
  friend class PageMap;

 public:
  struct PageEntry {
#if MRT_RESURRECTION_PROFILE == 1
    std::atomic<size_t> incs = {0};  // Number of increments
    std::atomic<size_t> decs = {0};  // Number of decrements
#endif                               // MRT_RESURRECTION_PROFILE
    std::atomic<uint16_t> fins = {
        0};  // Number of finalizable objects not yet resurrected
  };

  void Init(size_t maxMapSize) {
    size_t maxSize = maxMapSize * sizeof(PageEntry);
    maxSize = ALLOCUTIL_PAGE_RND_UP(maxSize);
    MemMap::Option opt = MemMap::kDefaultOptions;
    opt.tag = "rts_alloc_ros_fp";
    opt.reqBase = nullptr;
    opt.reqRange = false;
    memMap = MemMap::MapMemory(maxSize, maxSize, opt);
    entries = static_cast<PageEntry *>(memMap->GetBaseAddr());
    if (UNLIKELY(entries == nullptr)) {
      abort();
      // LOG(FATAL) << "finalizable prof initialisation failed" << std::endl;
    }
  }

  void IncPage(size_t index) {
    PageEntry &entry = GetEntry(index);
#if MRT_RESURRECTION_PROFILE == 1
    entry.incs.fetch_add(1, std::memory_order_relaxed);
#endif  // MRT_RESURRECTION_PROFILE
    entry.fins.fetch_add(1, std::memory_order_relaxed);
  }

  void DecPage(size_t index) {
    PageEntry &entry = GetEntry(index);
#if MRT_RESURRECTION_PROFILE == 1
    entry.decs.fetch_add(1, std::memory_order_relaxed);
#endif  // MRT_RESURRECTION_PROFILE
    entry.fins.fetch_sub(1, std::memory_order_relaxed);
  }

 private:
  MemMap *memMap = nullptr;
  PageEntry *entries = nullptr;

  PageEntry &GetEntry(size_t index) {
#ifdef __MRT_DEBUG
    size_t maxEntries = memMap->GetCurrSize() / sizeof(PageEntry);
    if (index >= maxEntries) {
      abort();
      // LOG(FATAL) << "index overflow when reading the finalizable object
      // record index: " <<
      //   index << " size: " << maxEntries << std::endl;
    }
#endif
    return entries[index];
  }
};

// This is a map from index to type for all pages.
// Also has a finalizable obj recorder.
class PageMap {
 public:
  // the type of page index and page count
  using IntType = size_t;

  PageMap();
  ~PageMap();
  void Init(address_t baseAddr, size_t maxSize, size_t size);
  void PrepareForConcurrentSweep();
  void ClearForConcurrentSweep();

  PageMap(const PageMap &that) = delete;
  PageMap(PageMap &&that) = delete;
  PageMap &operator=(const PageMap &that) = delete;
  PageMap &operator=(PageMap &&that) = delete;

  inline address_t GetBeginAddr() const { return spaceBeginAddr; }
  inline address_t GetEndAddr() const { return spaceEndAddr; }
  inline IntType GetPageIndex(address_t addr) const {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr <= spaceEndAddr),
                   "addr out of bound");
    return ALLOCUTIL_PAGE_BYTE2CNT(addr - spaceBeginAddr);
  }
  inline address_t GetPageAddr(IntType idx) const {
    CheckIndex(idx);
    idx = ROSIMPL_GET_IDX_IN_GROUP(idx);
    return spaceBeginAddr + ALLOCUTIL_PAGE_CNT2BYTE(idx);
  }
  inline IntType GetMapSize() const { return pageMapSize; }
  inline PageLabel GetType(IntType idx) const {
    CheckIndex(idx);
    idx = ROSIMPL_GET_IDX_IN_GROUP(idx);
    return map[idx];
  }
#ifdef FUTURE_OPTIMIZE
  inline ContinuousPageTypes GetTypes(IntType idx) const {
    CheckIndex(idx);
    idx = ROSIMPL_GET_IDX_IN_GROUP(idx);
#if defined(__ARM_NEON)
    return vld1q_u8(reinterpret_cast<const uint8_t *>(map + idx));
#else
    return *(ContinuousPageTypes *)(map + idx);
#endif  // defined(__ARM_NEON)
  }
#endif  // FUTURE_OPTIMIZE
  inline PageLabel GetTypeInConcurrent(IntType idx) const {
    CheckIndex(idx);
    idx = ROSIMPL_GET_IDX_IN_GROUP(idx);
    return mapSnapShot[idx];
  }
  inline PageLabel GetTypeForAddr(address_t addr) const {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    return map[GetPageIndex(addr)];
  }
  inline const PageLabel *GetMap() const {
    return const_cast<PageLabel *>(map);
  }

  inline PageLabel GetTypeAcquire(IntType idx) {
    idx = ROSIMPL_GET_IDX_IN_GROUP(idx);
    PageLabel *p = const_cast<PageLabel *>(&map[idx]);
    std::atomic<PageLabel> &atomicLabel =
        *reinterpret_cast<std::atomic<PageLabel> *>(p);
    return atomicLabel.load(std::memory_order_acquire);
  }
  // atomic is necessary in concurrent-sweep
  inline void SetTypeRelease(IntType idx, PageLabel label) {
    idx = ROSIMPL_GET_IDX_IN_GROUP(idx);
    PageLabel *p = const_cast<PageLabel *>(&map[idx]);
    std::atomic<PageLabel> &atomicLabel =
        *reinterpret_cast<std::atomic<PageLabel> *>(p);
    atomicLabel.store(label, std::memory_order_release);
  }

  inline void SetSweptReleaseInConcurrent(address_t addr) {
    IntType idx = GetPageIndex(addr);
    PageLabel *p = const_cast<PageLabel *>(&mapSnapShot[idx]);
    std::atomic<PageLabel> &atomicLabel =
        *reinterpret_cast<std::atomic<PageLabel> *>(p);
    atomicLabel.store(kPSwept, std::memory_order_release);
  }

  inline bool MatchAddr(address_t addr, PageLabel pageLabel) const {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    return (map[GetPageIndex(addr)] == pageLabel);
  }
  inline bool ContainsAddr(address_t addr) const {
    return (addr >= spaceBeginAddr && addr < spaceEndAddr);
  }

  // update the map size and the end address
  inline void UpdateSize(size_t size) {
    IntType mapSize = ALLOCUTIL_PAGE_BYTE2CNT(size);
    if (mapSize > pageMapSize) {
      pageMapSize = mapSize;
      spaceEndAddr = spaceBeginAddr + size;
    }
  }

  // set the page type of each page in range
  inline void SetRange(IntType idx1, IntType idx2, PageLabel label) {
    idx1 = ROSIMPL_GET_IDX_IN_GROUP(idx1);
    idx2 = ROSIMPL_GET_IDX_IN_GROUP(idx2);
    ROSIMPL_ASSERT(idx1 < idx2, "idx1 < idx2");
    ROSIMPL_ASSERT(idx2 <= maxMapSize, "index out of bound");
    for (IntType i = idx1; i < idx2; ++i) {
      map[i] = label;
    }
  }

  // set the page type of each page in range, also count
  // how many pages are converted free -> released or released ->
  // (free/allocated)
  inline IntType SetRangeAndCount(IntType idx1, IntType idx2, PageLabel label) {
    idx1 = ROSIMPL_GET_IDX_IN_GROUP(idx1);
    idx2 = ROSIMPL_GET_IDX_IN_GROUP(idx2);
    ROSIMPL_ASSERT(idx1 < idx2, "idx1 < idx2");
    ROSIMPL_ASSERT(idx2 <= maxMapSize, "index out of bound");
    bool isToReleased = (label == kPReleased);
    IntType count = 0;
    for (IntType i = idx1; i < idx2; ++i) {
      if (isToReleased && map[i] != kPReleased) {
        ROSIMPL_ASSERT(map[i] == kPFree, "released non-free page");
        ++count;
      } else if (!isToReleased && map[i] == kPReleased) {
        ALLOCUTIL_PREFETCH_WRITE(GetPageAddr(i));
        ++count;
      }
      map[i] = label;
    }
    return count;
  }

  // set the pageCnt pages starting from address addr to "run" type
  inline IntType SetAsRunPage(address_t addr, IntType pageCnt) {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    IntType index = GetPageIndex(addr);
    ROSIMPL_ASSERT(index < pageMapSize, "index out of bound");
    ROSIMPL_ASSERT(map[index] == kPFree || map[index] == kPReleased,
                   "set an occupied page to run");
    IntType count = 0;
    if (map[index] == kPReleased) {
      ALLOCUTIL_PREFETCH_WRITE(addr);
      ++count;
    }
    map[index] = kPRun;
    if (pageCnt > 1) {
      count += SetRangeAndCount(index + 1, index + pageCnt, kPRunRem);
    }
    return count;
  }

  // count the number of pages in a run (starting with a Run page then 0 or more
  // RunRem pages)
  inline IntType RunPageCount(address_t addr) const {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    IntType index = GetPageIndex(addr);
    ROSIMPL_ASSERT(map[index] == kPRun, "not a run page");
    IntType cnt = 1U;
    for (IntType i = index + 1; i < pageMapSize; ++i, ++cnt) {
      if (map[i] != kPRunRem) {
        break;
      }
    }
    return cnt;
  }

  // return the beginning of a run given an address (nb multi-page run)
  inline address_t GetRunStartFromAddr(address_t addr) const {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    IntType index = GetPageIndex(addr);
    IntType runIndex = 0;
    for (IntType i = index; i > 0; --i) {
      if (map[i] == kPRun) {
        runIndex = i;
        break;
      }
    }
    // if we are here it means that the run could be at position 0
    ROSIMPL_ASSERT(map[runIndex] == kPRun, "wrong page type");
    return GetPageAddr(runIndex);
  }

  inline address_t GetLargeObjStartFromAddr(address_t addr) const {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    IntType index = GetPageIndex(addr);
    IntType pageIndex = 0;
    for (IntType i = index; i > 0; --i) {
      if (map[i] == kPLargeObj) {
        pageIndex = i;
        break;
      }
    }
    ROSIMPL_ASSERT(map[pageIndex] == kPLargeObj, "wrong page type");
    return GetPageAddr(pageIndex);
  }

  // set the pageCnt pages starting from address addr to "large obj" type
  inline IntType SetAsLargeObjPage(address_t addr, IntType pageCnt) {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    IntType index = GetPageIndex(addr);
    ROSIMPL_ASSERT(index < pageMapSize, "index out of bound");
    ROSIMPL_ASSERT(map[index] == kPFree || map[index] == kPReleased,
                   "set an occupied page to large obj");
    IntType count = 0;
    if (map[index] == kPReleased) {
      ALLOCUTIL_PREFETCH_WRITE(addr);
      ++count;
    }
    map[index] = kPLargeObj;

    if (pageCnt > 1) {
      count += SetRangeAndCount(index + 1, index + pageCnt, kPLargeObjRem);
    }
    return count;
  }

  // count the number of pages of a large obj
  // (starting with a LargeObj page then 0 or more LargeObjRem pages)
  inline IntType LargeObjPageCount(address_t addr) const {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    IntType index = GetPageIndex(addr);
    ROSIMPL_ASSERT(map[index] == kPLargeObj, "not a large obj page");
    IntType cnt = 1U;
    for (IntType i = index + 1; i < pageMapSize; ++i, ++cnt) {
      if (map[i] != kPLargeObjRem) {
        break;
      }
    }
    return cnt;
  }

  // clear run page (set as free or released)
  inline void ClearRunPage(address_t addr, IntType pageCnt, bool isReleased) {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    IntType index = GetPageIndex(addr);
    PageLabel label = isReleased ? kPReleased : kPFree;
    for (IntType i = index; i < index + pageCnt; ++i) {
      ROSIMPL_ASSERT((map[i] == kPRun || map[i] == kPRunRem),
                     "page type was not correct");
      map[i] = label;
    }
  }

  // clear large obj page (set as free or released)
  inline void ClearLargeObjPage(address_t addr, IntType pageCnt,
                                bool isReleased) {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    IntType index = GetPageIndex(addr);
    PageLabel label = isReleased ? kPReleased : kPFree;
    for (IntType i = index; i < index + pageCnt; ++i) {
      ROSIMPL_ASSERT((map[i] == kPLargeObj || map[i] == kPLargeObjRem),
                     "page type was not correct");
      map[i] = label;
    }
  }

  // return number of pages freed after resetting labels for a large object
  inline IntType ClearLargeObjPageAndCount(address_t addr, bool isReleased) {
    ROSIMPL_ASSERT((addr >= spaceBeginAddr) && (addr < spaceEndAddr),
                   "addr out of bound");
    IntType index = GetPageIndex(addr);
    ROSIMPL_ASSERT(map[index] == kPLargeObj, "page addr in the middle");
    IntType cnt = 1U;
    PageLabel label = isReleased ? kPReleased : kPFree;
    map[index] = label;
    for (IntType i = index + 1; i < pageMapSize; ++i, ++cnt) {
      if (map[i] != kPLargeObjRem) {
        break;
      }
      map[i] = label;
    }
    return cnt;
  }

  IntType GetMaxMapSize() const noexcept { return maxMapSize; }

 private:
  inline void CheckIndex(IntType idx) const {
    ROSIMPL_ASSERT(idx < maxMapSize, "index out of bound");
  }

  // defensive padding, do nothing
  uint64_t padding __attribute__((unused)) = 0;

  // the page map holds some knowledge of the address space
  // they are updated when the page manager is updated
  address_t spaceBeginAddr;
  address_t spaceEndAddr;

  // the total number of pages mapped
  IntType maxMapSize;
  // the current number of pages (the rest must be of "released" type)
  IntType pageMapSize;

  // this mmaps some memory where the page map lives
  // this should be resizable
  MemMap *memMap;
  // this is a map from index to type for all pages. unlike the page manager, it
  // only changes in lock but it can be read out of locks to quickly decide the
  // state of a page, hence volatile.
  PageLabel *map;

  // used in concurrent sweep.
  PageLabel *mapSnapShot{nullptr};
};
}  // namespace ROS_GC

#endif  // SRC_GC_PAGE_MAP_H_
