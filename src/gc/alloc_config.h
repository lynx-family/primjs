#ifndef SRC_GC_ALLOC_CONFIG_H_
#define SRC_GC_ALLOC_CONFIG_H_

#include <cassert>

#include "gc/alloc_utils.h"

#ifdef ROS_DEBUG
#define ROSIMPL_MEMSET_AT_FREE (true)
#endif

namespace ROS_GC {

static constexpr uint32_t kPageSize = 16384;
static constexpr uint32_t kRemarkRetryThreshold = 3;

struct RunConfigType {
  const uint8_t
      numCaches;  // this kind of run at most has this many caches, deprecated
  const uint8_t numPagesPerRun;  // pages per run
  const uint32_t size;           // slot size of this kind of run
};
class RunConfig {
 public:
  // this class only has static member, so its constructor and destructors are
  // useless.
  RunConfig() = delete;
  RunConfig(const RunConfig &) = delete;
  RunConfig(RunConfig &&) = delete;
  RunConfig &operator=(const RunConfig &) = delete;
  RunConfig &operator=(RunConfig &&) = delete;
  ~RunConfig() = delete;
  // REMEMBER TO CHANGE THIS WHEN YOU ADD/REMOVE CONFIGS
  static const uint32_t kRunConfigs = 57;

  // this supports a maximum of (kMaxRunConfigs * 8 byte) run
  // we need to extend this if we want to config multiple-page run
  // for 16KB page with max slot size 8064, we need kMaxRunConfigs >= 1008
  static const uint32_t kMaxRunConfigs = 1008;
  // change this when add/remove configs
  // this stores a config for each kind of run (represented by an index)
  static const RunConfigType kCfgs[kRunConfigs];
  // this map maps a size ((size >> 3 - 1) to be precise) to a run config
  // this map takes 4 * kMaxRunConfigs == 4032 bytes (~4KB)
  static const uint32_t size2idx[kMaxRunConfigs];
};
}  // namespace ROS_GC

// assume(size <= (kCfgs[N_RUN_CONFIGS - 1].size << 3))
#define ROSIMPL_RUN_IDX(size) RunConfig::size2idx[((size) >> 3) - 1]
// this is a short cut of ROSIMPL_RUN_IDX, only works under certain configs, see
// kCfgs def
#define ROSIMPL_RUN_SIZE(idx) (RunConfig::kCfgs[(idx)].size)

#define ROSIMPL_N_CACHE_RUNS(idx) (RunConfig::kCfgs[(idx)].numCaches)
#define ROSIMPL_N_PAGES_PER_RUN(idx) (RunConfig::kCfgs[(idx)].numPagesPerRun)

const int kRosimplDefaultPagePerRun = 1;
const int kRosimplDefaultMaxCacheRun = 8;  // unused

// Heap configuration section --------------------------------------------------
#define ROSIMPL_DEFAULT_MAX_SPACE (1ul << 29)  // 512MB
#define ROSIMPL_DEFAULT_MAX_PAGES \
  (ROSIMPL_DEFAULT_MAX_SPACE >> kAllocUtilLogPageSize)

const bool kRosimplReleasePageAtTrim = true;

#define ROSIMPL_DEFAULT_HEAP_START_SIZE (1 << 23)  // 8m
#define ROSIMPL_DEFAULT_HEAP_SIZE ROSIMPL_DEFAULT_MAX_SPACE
#define ROSIMPL_DEFAULT_HEAP_GROWTH_LIMIT ROSIMPL_DEFAULT_HEAP_SIZE
// we trigger grow exactly when we run out of free pages
// changing this number won't add other triggers, so don't expect this to do
// what ART is doing
#define ROSIMPL_DEFAULT_HEAP_MIN_FREE (0U)
#define ROSIMPL_DEFAULT_HEAP_MAX_FREE (1 << 23)            // 8m
const double kRosimplDefaultHeapTargetUtilization = 0.95;  // ART 0.75
const bool kRosimplDefaultIgnoreMaxFootprint = false;

namespace ROS_GC {
// this configuration means that the maximum heap is (1 <<
// kRosPageGroupBitsCount * kRosDefaultPageGroupSize)
constexpr size_t kRosDefaultPageGroupSize = 0x80000UL;  // 512KB
constexpr size_t kRosPageGroupBitsCount = 14;

constexpr size_t kMaxHeap =
    (1 << kRosPageGroupBitsCount) * kRosDefaultPageGroupSize;

constexpr size_t kGCPolicyThreshold =
    (1 << 11) * kRosDefaultPageGroupSize;  // (1 << 11) * 512KB = 1GB, for GC
                                           // policy decisions
constexpr size_t kRosPageIdxBitsCount = 32 - kRosPageGroupBitsCount;
constexpr size_t kRosDefaultPageGroupNums = 1 << kRosPageGroupBitsCount;
constexpr size_t kBitMapSize = ROS_GC::AllocUtilRndUp(
    kRosDefaultPageGroupSize / 8 / 16, ALLOCUTIL_PAGE_SIZE);
constexpr size_t kRosDefaultPageGroupValidSize =
    kRosDefaultPageGroupSize - kBitMapSize - ALLOCUTIL_PAGE_SIZE -
    ALLOCUTIL_PAGE_SIZE;
constexpr size_t kRosDefaultPageCountPerGroup =
    kRosDefaultPageGroupValidSize / ALLOCUTIL_PAGE_SIZE;

constexpr size_t kROSAllocLargeSize = 8064;
constexpr size_t kROSAllocHugeSize = kRosDefaultPageGroupValidSize;

// markstack init number
constexpr size_t kMarkStackReserveCount = 64;

constexpr size_t kTriggerIntervalSec = 4;
constexpr size_t kGlobalTriggerCnt = 0;
constexpr size_t kMemInSuppressionMode =
    64 * 1024 * 1024;  // 0x10000000UL; // 256MB

#if defined(__ANDROID__) || defined(OS_IOS)
constexpr float kConcurrentThreshold = 0.7;
static constexpr int kHeapCompactThreshold = 128;
#else
constexpr float kConcurrentThreshold = 0.8;
static constexpr int kHeapCompactThreshold = 512;
#endif

// max size of work stack for a single mark task.
static constexpr size_t kMaxMarkTaskSize = 256;

// todo, profiling to confirm threadnumber(std::thread::hardware_concurrency() /
// 2) - 1;
constexpr size_t kThreadNumber = 2;
constexpr size_t kRestrictedThreadHeapThreshold = 32 * 1024 * 1024;

constexpr size_t kThreadPoolShrinkThresh = 5;

constexpr size_t kStackAlignment = 8;
constexpr float kForceDecHeapSizeThreshold = 0.6;

};  // namespace ROS_GC

constexpr size_t kAllocAlign = 8;
constexpr size_t MB = 1024 * 1024;

constexpr size_t kNonFullRunCollectNumber = 256;
#if defined(__ANDROID__) || defined(OS_IOS)
constexpr float kConSweepHeapModifyFactor = 0.4;
// this represents 1/kReleasePhysicalMemFactor freed pages should release
// physical memory
constexpr int kReleasePhysicalMemFactor = 2;
// ros will release physical memory more aggressive when live runtime instances
// count reach this threshold
constexpr int kRuntimeCntThreshold = 20;
constexpr size_t kConSweepHeapModifyThreshold = 16 * MB;

constexpr float freedMemoryFactorArray[] = {2, 3, 3.2, 3.5};
constexpr float memoryIncrementFactorArray[] = {1.3, 1.5, 1.6, 1.8};
constexpr size_t FootPrintGradeArray[] = {512 * MB, 128 * MB, 32 * MB};
constexpr float kConMarkMemIncFactor = 0.8;
constexpr float kConSweepMemIncFactor = 0.6;
#else
constexpr float freedMemoryFactorArray[] = {2, 3, 3.2, 3.5};
constexpr float memoryIncrementFactorArray[] = {1.3, 1.5, 1.8, 2};
constexpr size_t FootPrintGradeArray[] = {512 * MB, 128 * MB, 64 * MB};

constexpr float kConSweepHeapModifyFactor = 0.8;
constexpr size_t kConSweepHeapModifyThreshold = 128 * MB;

constexpr float kConMarkMemIncFactor = 0.9;
constexpr float kConSweepMemIncFactor = 0.75;
#endif

constexpr double kMinHeapGrowingFactor = 1.1;
constexpr double kMaxHeapGrowingFactor = 2.5;

constexpr size_t FootPrintGradeCnt =
    sizeof(FootPrintGradeArray) / sizeof(FootPrintGradeArray[0]);
#define ROSIMPL_HEADER_ALLOC_SIZE (ROS_GC::kHeaderSize)

static_assert((ROSIMPL_HEADER_ALLOC_SIZE) % kAllocAlign == 0,
              "obj header size must be aligned");

static_assert(ROS_GC::kROSAllocLargeSize >= ROSIMPL_HEADER_ALLOC_SIZE,
              "large size too small");
static_assert(ROS_GC::kROSAllocHugeSize >= ROSIMPL_HEADER_ALLOC_SIZE,
              "huge size too small");

#define ROSIMPL_GET_OBJ_FROM_ADDR(addr) ((addr))
#define ROSIMPL_GET_ADDR_FROM_OBJ(objAddr) ((objAddr))

#ifdef ROS_DEBUG
#define ROSIMPL_DEBUG(func) (func)
#else
#define ROSIMPL_DEBUG(func)
#endif  // ROS_DEBUG

#define ROSIMPL_DUNUSED(x) x __attribute__((unused))
#define ROSIMPL_ASSERT(p, msg) (assert(p))

#endif  // SRC_GC_ALLOC_CONFIG_H_
