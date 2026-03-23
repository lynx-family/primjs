#ifndef SRC_GC_ALLOC_UTILS_H_
#define SRC_GC_ALLOC_UTILS_H_

#include <random>

#include "gc/sizes.h"

#ifndef LIKELY
#define LIKELY(x) __builtin_expect(!!(x), 1)
#endif

#ifndef UNLIKELY
#define UNLIKELY(x) __builtin_expect(!!(x), 0)
#endif
namespace ROS_GC {
template <typename T>
constexpr T AllocUtilRndDown(T x, size_t n) {
  return (x & static_cast<size_t>(-n));
}
template <typename T>
constexpr T AllocUtilRndUp(T x, size_t n) {
  return AllocUtilRndDown(x + n - 1, n);
}

#ifndef ALLOCUTIL_PAGE_SIZE
#define ALLOCUTIL_PAGE_SIZE (static_cast<uintptr_t>(0x1000))  // 4K page
constexpr uint32_t kAllocUtilLogPageSize = 12;
#endif  // ALLOCUTIL_PAGE_SIZE

template <typename T>
constexpr T PageGroupRndDown(T x, size_t n) {
  return AllocUtilRndDown(x, n) + ALLOCUTIL_PAGE_SIZE;
}

#define ROSIMPL_GET_GROUP_IDX(idx) (idx >> kRosPageIdxBitsCount)
#define ROSIMPL_GET_IDX_IN_GROUP(idx) (idx & ((1 << kRosPageIdxBitsCount) - 1))
#define ROSIMPL_GET_PAGE_IDX(group_idx, idx_in_group) \
  ((group_idx) << kRosPageIdxBitsCount | idx_in_group)

#define ALLOCUTIL_PAGE_BYTE2CNT(x) ((x) >> kAllocUtilLogPageSize)
#define ALLOCUTIL_PAGE_CNT2BYTE(x) \
  (static_cast<size_t>(x) << kAllocUtilLogPageSize)

#define ALLOCUTIL_PAGE_RND_DOWN(x) \
  ((static_cast<uintptr_t>(x)) & (~(ALLOCUTIL_PAGE_SIZE - 1)))
#define ALLOCUTIL_PAGE_RND_UP(x)                             \
  (((static_cast<uintptr_t>(x)) + ALLOCUTIL_PAGE_SIZE - 1) & \
   (~(ALLOCUTIL_PAGE_SIZE - 1)))

#define ALLOCUTIL_PAGE_ADDR(x) \
  (static_cast<address_t>(x) & (~(ALLOCUTIL_PAGE_SIZE - 1)))

#define ALLOCUTIL_MEM_UNMAP(address, size_in_bytes)                    \
  if (munmap(reinterpret_cast<void *>(address), size_in_bytes) != 0) { \
    perror("munmap failed. Process terminating.");                     \
    abort();                                                           \
  }

#define ALLOCUTIL_MEM_MADVISE(address, size_in_bytes, option)              \
  if (madvise(reinterpret_cast<void *>(address), size_in_bytes, option) != \
      0) {                                                                 \
    perror("madvise failed. Process terminating.");                        \
    abort();                                                               \
  }

constexpr uint32_t kAllocUtilPrefetchWrite = 1;
#define ALLOCUTIL_PREFETCH_WRITE(address)               \
  __builtin_prefetch(reinterpret_cast<void *>(address), \
                     kAllocUtilPrefetchWrite, 0)

template <class IntType>
class AllocUtilRand {
 public:
  AllocUtilRand() = delete;
  AllocUtilRand(IntType randStart, IntType randEnd) {
    std::random_device rd;
    e = std::mt19937(rd());
    dist = std::uniform_int_distribution<IntType>(randStart, randEnd);
  }
  ~AllocUtilRand() = default;
  // return random value between l and u (inclusive), please make sure l <= u
  inline IntType next() { return dist(e); }

 private:
  std::mt19937 e;
  std::uniform_int_distribution<IntType> dist;
};
}  // namespace ROS_GC

#endif  // SRC_GC_ALLOC_UTILS_H_
