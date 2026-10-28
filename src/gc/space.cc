/*
 * Copyright (c) [2020] Huawei Technologies Co.,Ltd.All rights reserved.
 *
 * OpenArkCompiler is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan
 * PSL v2. You may obtain a copy of Mulan PSL v2 at:
 *
 *     http://license.coscl.org.cn/MulanPSL2
 *
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY
 * KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
 * NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE. See the
 * Mulan PSL v2 for more details.
 */
#ifdef ENABLE_COMPATIBLE_MM
#include "gc/space.h"

#include <sys/syscall.h>
#include <sys/types.h>

#include <cinttypes>

#include "gc/logger.h"
#include "gc/page_map.h"
#include "gc/ros_allocator.h"

namespace ROS_GC {
using namespace std;
// given the first page and the size of region in bytes, we add it
// to the set
__attribute__((__unused__)) void SpacePageManager::AddRegion(
    uintptr_t regionAddr, size_t regionSize) {
  uint32_t pageCount = CalcChunkSize(regionSize);
  AddPages(regionAddr, pageCount);
}

// add contiguous pages of count page_count starting with first_page
void SpacePageManager::AddPages(uintptr_t firstPage, uint32_t pageCount,
                                uint32_t pageIdx) {
  // add the new entry to the set
  if (UNLIKELY(!pageCTree.MergeInsert(pageIdx, pageCount))) {
    abort();
  }
}

void SpacePageManager::ReleaseAllFreePages(size_t freeBytes,
                                           bool isAggressive) {
  if (pageCTree.Empty()) {
    return;
  }
  TreeType::Iterator it(pageCTree);
  auto next = it.Next();
  size_t totalReleasedBytes = 0U;
  while (next != nullptr) {
    size_t page_idx = next->Idx();
    // control the size of unreleased pages
    uintptr_t releaseBeginAddr = allocSpace.page_groups.GetPageAddr(page_idx);
    size_t releaseBytes = ALLOCUTIL_PAGE_CNT2BYTE(next->Cnt());
    // release
    size_t c = allocSpace.page_groups.SetRangeAndCount(page_idx, next->Cnt(),
                                                       kPReleased);
    if (c) {
      madvise((void *)releaseBeginAddr, releaseBytes, MADV_ARGUMENT);
      totalReleasedBytes += ALLOCUTIL_PAGE_CNT2BYTE(c);
    }
    next = it.Next();
  }
  allocSpace.nonReleasedPageSize -= totalReleasedBytes;
}

void SpacePageManager::IterateCTree() {
  TreeType::Iterator it(pageCTree);
  auto next = it.Next();
  int cnt = 0;
  while (next != nullptr) {
    cnt++;
    size_t page_idx = next->Idx();
    // control the size of unreleased pages
    uintptr_t beginAddr = allocSpace.page_groups.GetPageAddr(page_idx);
    size_t bytes = ALLOCUTIL_PAGE_CNT2BYTE(next->Cnt());
    printf(
        "node_cnt: %d, page_idx: %zu, begin_addr: %p, end_addr: %p, size: %zu "
        "KB\n",
        cnt, page_idx, (void *)beginAddr, (void *)(beginAddr + bytes),
        bytes / 1024);
    next = it.Next();
  }
}

// Given a request size in bytes, we split the first chunk and return the
// address to the first page
uintptr_t SpacePageManager::GetChunk(size_t reqSize, uint32_t &idx) {
  return pageCTree.Find(idx, CalcChunkSize(reqSize)) ? GetRegionAddrFromIdx(idx)
                                                     : 0U;
}

// given size in bytes we return the size normalized to pages (4k)
uint32_t SpacePageManager::CalcChunkSize(size_t regionSize) const {
  return static_cast<uint32_t>(
      ALLOCUTIL_PAGE_BYTE2CNT(ALLOCUTIL_PAGE_RND_UP(regionSize)));
}

// Returns the size of largest chunk currently in the page set.
size_t SpacePageManager::GetLargestChunkSize() {
  return ALLOCUTIL_PAGE_CNT2BYTE(pageCTree.Top());
}

size_t SpacePageManager::ReleaseAllFreeGroups() {
  // this version may offer higher performance, when the tree has too many nodes
  int cnt = 0;
  while (true) {
    uint32_t idx = 0;
    if (!pageCTree.Find(idx, kRosDefaultPageCountPerGroup)) break;
    allocSpace.page_groups.ReleaseMem(idx);
    cnt++;
  }
  return cnt;
}

// Space
Space::Space(const std::string &fullname, const std::string &tagVal,
             bool managed)
    : name(fullname),
      tag(tagVal),
      isManaged(managed),
      allocatedPageSize(0),
      nonReleasedPageSize(0),
      gcTracer(this),
      pageManager(*this, 0),
      page_groups(pageManager),
      lastTrimTime(0) {
  releasePageAtFree = false;
  kReleasePageAtTrim = kRosimplReleasePageAtTrim;
  heapTargetUtilization = kRosimplDefaultHeapTargetUtilization;
}

void Space::Init(uint8_t *reqBegin) {
  size_t group_cnt = AllocUtilRndUp(heapStartSize, kRosDefaultPageGroupSize) /
                     kRosDefaultPageGroupSize;
  page_groups.Init(heapGrowthLimit, group_cnt, reqBegin);
  allocatedPageSize = 0U;
  nonReleasedPageSize = 0U;
  usedHeapSize = group_cnt * kRosDefaultPageGroupSize;
  usedMemSize = group_cnt * kRosDefaultPageGroupValidSize;
  return;
}

// returns the number of pages free within the reserved memory space
size_t Space::GetAvailPageCount() const {
  return ALLOCUTIL_PAGE_BYTE2CNT(GetSize() - allocatedPageSize);
}

uintptr_t Space::GetChunk(size_t reqSize, uint32_t &idx) {
  uintptr_t addr = pageManager.GetChunk(reqSize, idx);
  if (addr != 0) {
    allocatedPageSize += reqSize;
  }
  return addr;
}

size_t Space::GetLargestChunkSize() {
  return pageManager.GetLargestChunkSize();
}

size_t Space::TargetFreePageSizeByUtilization() const {
  size_t allocated = 0;  // stats::gcStats->CurAllocBytes();
  // this should be guaranteed by the option parser
  //__MRT_ASSERT(heapTargetUtilization > 0, "invalid utilization");
  //__MRT_ASSERT(heapTargetUtilization < 1, "invalid utilization");
  size_t targetTotal = static_cast<size_t>(allocated / heapTargetUtilization);
  size_t targetFree =
      std::max(targetTotal, allocatedPageSize) - allocatedPageSize;
  // we want to cap this: for larger heap, assuming usage do not grow that much
  // faster
  return std::min(targetFree, TargetFreePageSize());
}

void Space::Extend(size_t deltaSize) {
  if (GetHeapHeadroom() >= kRosDefaultPageGroupSize) {
    page_groups.NewPageGroup();
    usedHeapSize += kRosDefaultPageGroupSize;
    usedMemSize += kRosDefaultPageGroupValidSize;
  } else {
    newGroupNeeded = true;
  }
  return;
}

address_t Space::Alloc(size_t reqSize, bool allowExtension, uint32_t &idx,
                       size_t rosInternalSize) {
  address_t retAddress = 0U;
  if (usedMemSize - allocatedPageSize >= reqSize) {
    retAddress = GetChunk(reqSize, idx);
    if (retAddress != 0) {
      return retAddress;
    }
  }

  if (allowExtension) {
    Extend(reqSize);
    retAddress = GetChunk(reqSize, idx);
  }
  return retAddress;
}

// TODO(rts): make sure the physical memory of free pages are released under
// these conditions:
// - Full GC.
// - Longer interval.
// release the physical memory of free pages, using madvise()
size_t Space::ReleaseFreePages(bool aggressive) {
  size_t free_bytes = GetFreePageSize();
  // if aggressive, it ignores the threshold and the timer
  if (aggressive ||
      (IsTrimAllowedAtTheMoment() && free_bytes > HeapMaxFreeByUtilization())) {
    pageManager.ReleaseAllFreePages(free_bytes, aggressive);
    // lastTrimTime = timeutils::MilliSeconds();
  }
  // if any page was released, the size must have decreased
  return free_bytes - GetFreePageSize();
}

void Space::FreeRegion(address_t addr, size_t pgCnt, uint32_t pageIdx) {
  size_t memSize = ALLOCUTIL_PAGE_CNT2BYTE(pgCnt);
#if defined(ANDROID) || defined(__ANDROID__) || defined(OS_IOS)
  // todo, this may impact performance when rt instances are too many
  if (pageIdx % kReleasePhysicalMemFactor == 0) {
    madvise((void *)addr, memSize, MADV_ARGUMENT);
  }
#endif
  pageManager.AddPages(addr, static_cast<uint32_t>(pgCnt), pageIdx);
#ifdef DEBUG_RUNLOCK_OWNER
  if (UNLIKELY(!memMap->ProtectMem(addr, memSize, PROT_NONE))) {
    LOG(FATAL) << "failed to mprotect " << std::hex << addr << " of size "
               << std::dec << memSize;
  }
#endif
  allocatedPageSize -= memSize;
}

Space::~Space() {}

// keep heapSize within legal boundaries
void Space::AutoAdjustHeapSize(size_t allocSize, size_t allocatedInternalSize) {
  if (allocSize > 0) {
    const size_t allocation_reserve = SaturatingAdd(allocSize, allocSize / 5);
    heapSize =
        SaturatingAdd(std::max(heapSize, usedHeapSize), allocation_reserve);
  }
  if (newGroupNeeded) {
    heapSize = std::max(heapSize,
                        SaturatingAdd(usedHeapSize, kRosDefaultPageGroupSize));
    newGroupNeeded = false;
  }
  heapSize = std::min(heapGrowthLimit, heapSize);
  heapSize = std::max(heapSize, kRosDefaultPageGroupSize);
}

void Space::UpdateHeapSizeLimitForBusymode(
    size_t alloc_size, size_t allocatedInternalSize) noexcept {
  size_t expand_size =
      (alloc_size == 0) ? kRosDefaultPageGroupSize
                        : AllocUtilRndUp(alloc_size, kRosDefaultPageGroupSize);
  heapSize += expand_size;
  AutoAdjustHeapSize(alloc_size, allocatedInternalSize);
}
void Space::UpdateHeapSizeLimit(uint8_t gc_type, size_t allocSize,
                                size_t allocatedInternalSize,
                                size_t newHeapSize) noexcept {
  __attribute__((__unused__)) size_t originHeapSize = heapSize;

  heapSize = newHeapSize;
  AutoAdjustHeapSize(allocSize, allocatedInternalSize);
  CheckHeapSizeChangeTrendForDebug(gc_type);

  lastGCType = gc_type;
  return;
}

}  // namespace ROS_GC
#endif  // ENABLE_COMPATIBLE_MM
