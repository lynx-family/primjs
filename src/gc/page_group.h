#ifndef QUICKJS_INCLUDE_PAGE_GROUP_H_
#define QUICKJS_INCLUDE_PAGE_GROUP_H_

#include <memory>
#include <mutex>
#include <new>
#include <unordered_map>

#include "gc/alloc_config.h"
#include "gc/mark_stack.h"
#include "gc/mem_map.h"
#include "gc/mrt_bitmap.h"
#include "gc/page_map.h"
#include "gc/ros_alloc_run.h"
#include "gc/thread_pool.h"

/* pagegroup layout
|---header---|---object---|---BitMap self meta---|---BitMap real memory for
mark|
*/
// header + BitMap self meta + BitMap memory, each of them hold a single page
static int constexpr kPageGroupOverHead = 3;

namespace ROS_GC {
class SpacePageManager;
class PageGroups;

using SortedGroups = std::unordered_map<address_t, int32_t>;

class PageGroup {
 public:
  explicit PageGroup() = default;
  // attention, PageGroup instance will always live with PageGroups.
  // so during the vm running, ~PageGroup will not be executed
  virtual ~PageGroup() {
    if (!initialized) return;
    ReleaseMem();
    return;
  }

  PageGroup(const PageGroup &) = delete;
  PageGroup(PageGroup &&) = delete;
  const PageGroup &operator=(const PageGroup &) = delete;
  const PageGroup &operator=(PageGroup &&) = delete;

  Bitmap *GetBitmap() { return mark_bitmap; }
  size_t GetMemMapedSize() { return mem_map->GetMappedSize(); }
  void ProtectAllMem() { mem_map->ProtectAllMem(); }
  void UnProtectAllMem() { mem_map->UnProtectAllMem(); }
  PageMap *GetPageMap() { return page_map; }
  const PageMap &GetPageMap() const { return *page_map; }
  inline bool IsInitialized() const { return initialized; }
  inline bool IsHugeObj() const { return is_huge; }

  inline auto GetBegin() const { return beg; }
  inline auto GetCurrEnd() const { return end; }
  inline auto GetCurrSize() const { return end - beg; }
  inline size_t GetMaxCapacity() const { return max_capacity; }
  inline int32_t GetGroupIdx() const { return idx; }

  inline void SetConcurrentMark(bool flag) {
    is_concurrent_marking = flag;
    if (IsInitialized()) {
      address_t header = AllocUtilRndDown(beg, kRosDefaultPageGroupSize);
      *(bool *)(header + PageGroup::is_concurrent_marking_offset) = flag;
    }
  }
  inline void ConfigShouldSkipCollect(bool flag) { should_skip_collect = flag; }
  inline bool ShouldSkipCollect() const { return should_skip_collect; }
  void ReleaseMemory() {
    if (!initialized) return;
    ReleaseMem();
  }

 private:
  inline void ReleaseMem() {
    ROSIMPL_ASSERT(initialized, "release unitialized page group.");
    mark_bitmap = nullptr;
    if (!is_huge) {
      GetPageMap()->ClearForConcurrentSweep();
      delete page_map;
      page_map = nullptr;
    } else {
      is_huge = false;
    }
    mem_map->DestroyMemMap(mem_map);
    beg = end = initialized = 0;
  }
  void Init(PageList &bb, PageList::Node *&node, uint8_t *req_beg = nullptr,
            int req_size = 0);
  void InitNormalGroup(const MemMap::Option &opt);
  void InitHugeGroup(const MemMap::Option &opt, int req_size);

  friend PageGroups;
  MemMap *mem_map = nullptr;
  PageMap *page_map = nullptr;
  Bitmap *mark_bitmap = nullptr;
  address_t beg;
  address_t end;
  size_t max_capacity = kRosDefaultPageGroupValidSize;
  int32_t idx = 0;
  size_t next_free_idx = 0;
  bool initialized = false;
  bool is_huge = false;
  bool is_concurrent_marking = false;
  bool should_skip_collect = false;
  std::atomic<bool> isDeleting = false;
#ifdef ROS_DEBUG
 public:
#endif
  static address_t mark_bitmap_offset;
  static address_t page_map_offset;
  static address_t idx_offset;
  // the offset which stores PageGroup pointer
  static address_t this_offset;
  static address_t is_concurrent_marking_offset;

  static constexpr const char *space_name = "ROS memory space";
  char space_tag[30] = "quickjs_heap_";
};

// A contiguous view of the page group slots constructed so far.
template <typename Group>
class PageGroupRange {
 public:
  PageGroupRange(Group *first, size_t size) : first_(first), size_(size) {}
  Group *begin() const { return first_; }
  Group *end() const { return first_ + size_; }
  Group &operator[](size_t idx) const { return first_[idx]; }

 private:
  Group *first_;
  size_t size_;
};

class PageGroups {
 private:
#if defined(ENABLE_DEBUG)
#define CONST_SIGNATURE
#define DLOCK_GUARD() std::lock_guard<std::mutex> guard(group_lock)
#define desired_sorted_groups sorted_groups

  std::mutex group_lock;
#else
#define CONST_SIGNATURE const
#define DLOCK_GUARD(mutex)
#define desired_sorted_groups sorted_groups_snapshot
#endif  // defined(ENABLE_DEBUG)

 public:
  // Allocated for all kRosDefaultPageGroupNums slots when the runtime is
  // created, outside both the managed heap and RosAllocImpl, so memory usage
  // has to count it separately.
  static constexpr size_t kSlotStorageSize =
      sizeof(PageGroup) * kRosDefaultPageGroupNums;

  explicit PageGroups(SpacePageManager &space_man)
      : groups{std::allocator<PageGroup>().allocate(kRosDefaultPageGroupNums)},
        page_manager{space_man} {}
  virtual ~PageGroups() {
    for (PageGroup &group : GetGroupArray()) group.~PageGroup();
    std::allocator<PageGroup>().deallocate(groups, kRosDefaultPageGroupNums);
  }
  PageGroups(const PageGroups &) = delete;
  PageGroups &operator=(const PageGroups &) = delete;

  inline PageGroup &GetGroup(address_t addr) {
    // todo
    // ROSIMPL_ASSERT(ContainsAddr(addr), "don't has addr");
    int32_t idx = GetGroupIdx(addr);
    return groups[idx];
  }

  inline PageMap *GetPageMap(address_t addr) const {
    address_t header = AllocUtilRndDown(addr, kRosDefaultPageGroupSize);
    return *(PageMap **)(header + PageGroup::page_map_offset);
  }

  inline uint32_t GetGroupIdx(address_t addr) const {
    address_t header = AllocUtilRndDown(addr, kRosDefaultPageGroupSize);
    return *(uint32_t *)(header + PageGroup::idx_offset);
  }

  inline size_t GetPageIdxInGroup(address_t addr) CONST_SIGNATURE {
    // todo
    // ROSIMPL_ASSERT(ContainsAddr(addr), "don't has addr");
    return GetPageMap(addr)->GetPageIndex(addr);
  }

  inline uint32_t GetPageIdx(address_t addr) CONST_SIGNATURE {
    // todo
    // ROSIMPL_ASSERT(ContainsAddr(addr), "don't has addr");
    return ROSIMPL_GET_PAGE_IDX(GetGroupIdx(addr),
                                (uint32_t)GetPageMap(addr)->GetPageIndex(addr));
  }

  inline address_t GetPageAddr(size_t idx) const {
    return groups[ROSIMPL_GET_GROUP_IDX(idx)].page_map->GetPageAddr(
        ROSIMPL_GET_IDX_IN_GROUP(idx));
  }

  inline address_t GetPageAddr(size_t group_idx,
                               size_t page_idx_in_group) const {
    return groups[group_idx].page_map->GetPageAddr(page_idx_in_group);
  }

  void Init(size_t heap_size, size_t group_cnt, uint8_t *req_beg = nullptr);

  PageGroup &NewPageGroup(uint8_t *req_beg = nullptr);
  PageGroup &NewHugeMem(size_t &req_size, uint8_t *req_beg = nullptr);

  inline bool HasAddress(address_t addr) CONST_SIGNATURE {
    // TODO: is this really needed?
    std::atomic_thread_fence(std::memory_order_seq_cst);
    DLOCK_GUARD();
    address_t start_addr = PageGroupRndDown(addr, kRosDefaultPageGroupSize);
    auto it = desired_sorted_groups.find(start_addr);
    if (it != desired_sorted_groups.end() &&
        addr < groups[it->second].GetCurrEnd() &&
        addr >= groups[it->second].GetBegin()) {
      return true;
    }
    return false;
  }

  inline bool HasAddressSerious(address_t addr) CONST_SIGNATURE {
    DLOCK_GUARD();
    auto item = desired_sorted_groups.find(addr);
    if (item != desired_sorted_groups.end()) {
      return groups[item->second].IsHugeObj();
    }
    return false;
  }

  inline bool TryToRecordValidObjAddrAndCheckValid(
      RootSet *rootSet, address_t addr) CONST_SIGNATURE {
    DLOCK_GUARD();
    for (const auto &group : desired_sorted_groups) {
      const auto groupId = group.second;
      auto beg = groups[groupId].GetBegin();
      auto end = groups[groupId].GetCurrEnd();
      if (!(addr >= beg && addr < end)) continue;
      if (groups[groupId].IsHugeObj()) {
        rootSet->push_back(beg);
        return false;
      }
      return true;
    }
    return false;
  }

  void CopySortedGroups() {
    // sorted_groups_snapshot = sorted_groups;
  }
  void ClearSortedGroupsSnapshot() {
    // sorted_groups_snapshot.clear();
  }

  inline address_t FindGroupStartAddr(address_t addr) const {
    return PageGroupRndDown(addr, kRosDefaultPageGroupSize);
  }

  inline bool ReleaseMem(size_t page_idx) {
    auto &rel_group = groups[ROSIMPL_GET_GROUP_IDX(page_idx)];
    {
      DLOCK_GUARD();
      sorted_groups.erase(rel_group.beg);
    }
    rel_group.ReleaseMem();
    rel_group.next_free_idx = current_idx;
    current_idx = rel_group.idx;
    return true;
  }

  inline bool ReleaseHugeMem(PageGroup &group) {
    {
      DLOCK_GUARD();
      sorted_groups.erase(group.beg);
    }
    group.ReleaseMem();
    group.next_free_idx = current_idx;
    current_idx = group.idx;
    return true;
  }

  inline PageMap *GetPageMapById(size_t group_idx) {
    return groups[group_idx].page_map;
  }

  inline Bitmap *GetBitMap(size_t group_idx) {
    return groups[group_idx].mark_bitmap;
  }

  static inline Bitmap *GetBitMapFromAddr(address_t addr) {
    address_t header = AllocUtilRndDown(addr, kRosDefaultPageGroupSize);
    return *(Bitmap **)(header + PageGroup::mark_bitmap_offset);
  }

  static inline bool GetIsConcurrentMarkingFromAddr(address_t addr) {
    address_t header = AllocUtilRndDown(addr, kRosDefaultPageGroupSize);
    return *(bool *)(header + PageGroup::is_concurrent_marking_offset);
  }

  inline size_t SetRangeAndCount(size_t idx1, size_t page_cnt,
                                 PageLabel label) {
    auto g_idx = ROSIMPL_GET_GROUP_IDX(idx1);
    idx1 = ROSIMPL_GET_IDX_IN_GROUP(idx1);
    return groups[g_idx].page_map->SetRangeAndCount(idx1, idx1 + page_cnt,
                                                    label);
  }

  inline size_t SetAsRunPage(size_t page_idx, address_t page_addr,
                             size_t page_cnt) {
    return groups[ROSIMPL_GET_GROUP_IDX(page_idx)].page_map->SetAsRunPage(
        page_addr, page_cnt);
  }

  inline bool ContainsAddr(address_t addr) CONST_SIGNATURE {
    return HasAddress(addr);
  }
  PageLabel GetTypeForAddr(address_t addr) CONST_SIGNATURE {
    ROSIMPL_ASSERT(ContainsAddr(addr), "don't has addr");
    return GetPageMap(addr)->GetTypeForAddr(addr);
  }
  PageLabel GetTypeForAddr(address_t addr, size_t group_idx) const {
    return groups[group_idx].page_map->GetTypeForAddr(addr);
  }
  address_t GetRunStartFromAddr(address_t addr) const {
    return GetPageMap(addr)->GetRunStartFromAddr(addr);
  }
  address_t GetrunStartFromAddr(address_t addr, size_t idx) const {
    return groups[idx].page_map->GetRunStartFromAddr(addr);
  }
  address_t GetLargeObjStartFromAddr(address_t addr, size_t idx) const {
    return groups[idx].page_map->GetLargeObjStartFromAddr(addr);
  }

  size_t SetAsLargeObjPage(size_t page_idx, address_t page_addr, size_t pgcnt) {
    return groups[ROSIMPL_GET_GROUP_IDX(page_idx)].page_map->SetAsLargeObjPage(
        page_addr, pgcnt);
  }
  void ClearRunPage(address_t addr, size_t page_cnt, bool is_release) {
    GetGroup(addr).page_map->ClearRunPage(addr, page_cnt, is_release);
    return;
  }

  size_t ClearLargeObjPageAndCount(address_t addr, bool is_release) {
    return GetGroup(addr).page_map->ClearLargeObjPageAndCount(addr, is_release);
  }

  PageGroupRange<PageGroup> GetGroupArray() {
    return {groups, constructed_count_};
  }
  PageGroupRange<const PageGroup> GetGroupArray() const {
    return {groups, constructed_count_};
  }
  auto &GetGroupByIdx(int32_t index) { return groups[index]; }
  inline size_t GetGroupsNum() const { return constructed_count_; }

  // Also applies to groups constructed later, so that a group created during
  // concurrent marking does not miss the write barrier.
  void SetConcurrentMarkForAll(bool flag) {
    concurrent_marking_ = flag;
    for (PageGroup &group : GetGroupArray()) group.SetConcurrentMark(flag);
  }

  inline PageList &GetPageList() { return pageList_; }
  inline PageList::Node *GetPageListNode() { return node; }

  inline void ResetPageListIfNeeded() {
    GetPageList().ResetIfNeeded();
    node = nullptr;
  }
  inline void RetireNode() {
    GetPageList().RetireNode(node);
    node = nullptr;
  }

 private:
  friend class PageGroup;

  // Slots are constructed on first use so that creating a runtime does not
  // touch the metadata of all kRosDefaultPageGroupNums groups. The free list
  // only ever points to a constructed slot or to the next unconstructed one.
  PageGroup &EnsureConstructed(size_t idx) {
    ROSIMPL_ASSERT(idx <= constructed_count_,
                   "page group slots must be constructed in order");
    if (idx == constructed_count_) {
      PageGroup *group = new (&groups[idx]) PageGroup();
      group->idx = static_cast<int32_t>(idx);
      group->next_free_idx = idx + 1;
      group->SetConcurrentMark(concurrent_marking_);
      ++constructed_count_;
    }
    return groups[idx];
  }

  size_t current_idx = 0;
  PageGroup *groups;
  size_t constructed_count_ = 0;
  bool concurrent_marking_ = false;
  SortedGroups sorted_groups;
  SortedGroups sorted_groups_snapshot;
  SpacePageManager &page_manager;
  PageList pageList_;
  PageList::Node *node = nullptr;
};

}  // namespace ROS_GC
#endif  // QUICKJS_INCLUDE_PAGE_GROUP_H_
