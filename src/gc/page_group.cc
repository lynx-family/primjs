
#include "gc/page_group.h"

#include "gc/ros_alloc_run.h"
#include "gc/space.h"
#include "quickjs/include/quickjs-inner.h"
#if defined(ANDROID) || defined(__ANDROID__)
#include <sys/syscall.h>
#include <unistd.h>
#endif

namespace ROS_GC {
address_t PageGroup::mark_bitmap_offset =
    (address_t) & ((static_cast<PageGroup *>(0))->mark_bitmap);
address_t PageGroup::page_map_offset =
    (address_t) & ((static_cast<PageGroup *>(0))->page_map);
address_t PageGroup::idx_offset =
    (address_t) & ((static_cast<PageGroup *>(0))->idx);
address_t PageGroup::is_concurrent_marking_offset =
    (address_t) & ((static_cast<PageGroup *>(0))->is_concurrent_marking);
address_t PageGroup::this_offset = 0;
};  // namespace ROS_GC

#ifdef ENABLE_COMPATIBLE_MM
namespace ROS_GC {
#if defined(ANDROID) || defined(__ANDROID__)
pid_t gettid() { return syscall(SYS_gettid); }
#endif

void PageGroup::Init(PageList &bb, PageList::Node *&node, uint8_t *req_beg,
                     int req_size) {
  if (initialized) return;
  auto opt = MemMap::kDefaultOptions;
#if defined(ANDROID) || defined(__ANDROID__)
  space_tag[13] = '\0';
  char id[17];
  snprintf(id, 17, "%d%s%d%s%d", getpid(), "_", gettid(), "_", idx);
  strcat(space_tag, id);
#endif
  opt.tag = space_tag;
  opt.reqBase = req_beg;
#ifndef ROSIMPL_ENABLE_ASSERTS
  opt.protAll = true;
#endif
  if (req_size != 0)
    InitHugeGroup(opt, req_size);
  else
    InitNormalGroup(opt);

  auto size = max_capacity;
  mark_bitmap = new (reinterpret_cast<void *>(end)) ROS_GC::Bitmap(bb, node);
  mark_bitmap->Initialize(max_capacity, beg, size, is_huge);
  initialized = true;

  address_t header = AllocUtilRndDown(beg, kRosDefaultPageGroupSize);
  // this is necessary because this virtual-memory page will be accessed quite
  // frequently, and overall, only a few pages of physical memory will be wasted
  mlock((void *)header, ALLOCUTIL_PAGE_SIZE);
  // fill pagegroup header
  *(address_t *)(mark_bitmap_offset + header) = (address_t)mark_bitmap;

  *(address_t *)(page_map_offset + header) = (address_t)page_map;
  *(int32_t *)(idx_offset + header) = idx;
  *(address_t *)(this_offset + header) = (address_t)this;

  *(bool *)(header + PageGroup::is_concurrent_marking_offset) =
      is_concurrent_marking;

  return;
}

void PageGroup::InitNormalGroup(const MemMap::Option &opt) {
  max_capacity = kRosDefaultPageGroupValidSize;
  mem_map =
      MemMap::CreateAlignedMemory(kRosDefaultPageGroupSize, max_capacity, opt);
  beg =
      reinterpret_cast<address_t>(mem_map->GetBaseAddr()) + ALLOCUTIL_PAGE_SIZE;
  end = beg + max_capacity;
  if (!page_map) page_map = new PageMap();
  auto size = max_capacity;
  page_map->Init(beg, max_capacity, size);
}

void PageGroup::InitHugeGroup(const MemMap::Option &opt, int req_size) {
  is_huge = true;
  max_capacity = req_size;
  mem_map = MemMap::CreateAlignedMemory(
      req_size + ALLOCUTIL_PAGE_SIZE * kPageGroupOverHead, max_capacity, opt);
  beg =
      reinterpret_cast<address_t>(mem_map->GetBaseAddr()) + ALLOCUTIL_PAGE_SIZE;
  end = beg + max_capacity;
  page_map = nullptr;
}

void PageGroups::Init(size_t max_heap_size, size_t group_cnt,
                      uint8_t *req_beg) {
  page_manager.pageCTree.Init(max_heap_size);
  for (size_t i = 0; i < group_cnt; ++i) {
    NewPageGroup();
  }
  return;
}

PageGroup &PageGroups::NewPageGroup(uint8_t *req_beg) {
  ROSIMPL_ASSERT(current_idx < kRosDefaultPageGroupNums,
                 "current page_groups is full");
  auto &cur_group = groups[current_idx];
  cur_group.Init(pageList_, node, req_beg);
  {
    DLOCK_GUARD();
    sorted_groups[cur_group.beg] = current_idx;
  }
  size_t page_idx = ROSIMPL_GET_PAGE_IDX(
      current_idx, cur_group.page_map->GetPageIndex(cur_group.GetBegin()));
  page_manager.AddPages(page_idx,
                        cur_group.GetCurrSize() / ALLOCUTIL_PAGE_SIZE);
  current_idx = cur_group.next_free_idx;
  // TODO: is this really needed?
  std::atomic_thread_fence(std::memory_order_seq_cst);
  return cur_group;
}

PageGroup &PageGroups::NewHugeMem(size_t &req_size, uint8_t *req_beg) {
  ROSIMPL_ASSERT(current_idx < kRosDefaultPageGroupNums,
                 "current page_groups is full");
  auto &cur_group = groups[current_idx];
  cur_group.Init(pageList_, node, req_beg, req_size);
  req_size = cur_group.GetMaxCapacity();
  {
    DLOCK_GUARD();
    sorted_groups[cur_group.beg] = current_idx;
  }
  current_idx = cur_group.next_free_idx;
  std::atomic_thread_fence(std::memory_order_seq_cst);
  return cur_group;
}
}  // namespace ROS_GC
#else
namespace ROS_GC {

void PageGroups::Init(size_t max_heap_size, size_t group_cnt,
                      uint8_t *req_beg) {}

PageGroup &PageGroups::NewPageGroup(uint8_t *req_beg) { return groups[0]; }

PageGroup &PageGroups::NewHugeMem(size_t &req_size, uint8_t *req_beg) {
  return groups[0];
}

}  // namespace ROS_GC
#endif  // ENABLE_COMPATIBLE_MM
