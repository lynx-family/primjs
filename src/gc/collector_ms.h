#ifndef SRC_GC_COLLECTOR_MS_H_
#define SRC_GC_COLLECTOR_MS_H_

#include "gc/gc_marking.h"

struct LEPUSContext;

namespace ROS_GC {
class MarkTask;
class ConcurrentMarkTask;
struct VMCollectorParam {
  bool createNewThreadPool{false};
  bool destroyThreadpool{true};
};

using RootSets = std::vector<RootSet>;

class MarkSweepCollector {
  friend MarkTask;

 public:
  MarkSweepCollector(RosAllocImpl *allocator) : marking(allocator) {
    ros = allocator;
    visitor = nullptr;
    CreateFinalizer();
    forbid_gc = 0;
    lastTriggerTime = clock();
  }

  ~MarkSweepCollector();

  void Init(const VMCollectorParam &vmCollectorParam);
  bool ConditionalFreeThreadPool() {
    bool shouldFree = threadPoolCount > kThreadPoolShrinkThresh;
    if (shouldFree) {
      DestroyThreadPool();
    }
    return shouldFree;
  }

  inline bool IsGarbage(address_t objAddr) {
    return !ros->IsObjectMarked(objAddr);
  }

  inline void KeepAlive(address_t objAddr) { ros->MarkObject(objAddr); }

  inline bool IsGarbage(address_t objAddr, Bitmap *markBitmap) {
    return !markBitmap->IsObjectMarked(objAddr);
  }
  bool CheckAndPrepareSweep(address_t addr, Bitmap *markBitmap) {
    return (IsGarbage(addr, markBitmap));
  }

  void RunFullCollection(size_t alloc_size = 0, int eager = kEagerLevelMin,
                         bool forceParallel = false);
  void RunFinalCollection();
  void DoOnlyFinalizer();
  void OnlyUpdateHeapSize(size_t alloc_size);

  bool EnureConcurrentIsCompleted();

  inline void ResetBitmap() {
    auto &groups = ros->GetPageGroups().GetGroupArray();
    for (PageGroup &group : groups) {
      if (group.IsInitialized()) group.GetBitmap()->ResetBitmap();
    }
  }
  /*static */ MplThreadPool *GetThreadPool() { return workerThreadPool; }
  void ScanStack(RootSet *, uint8_t *frame_pointer, uint8_t *stack_top);
  void ScanStackAddr(RootSet *, address_t addr);
  void DoFinalizerPhase(bool is_concurrent_gc = false);
  void DoOuterObjFinalizer();

  RosAllocImpl *GetRosAllocator() { return ros; }
  Visitor *GetVisitor() { return visitor; }

  void SetForbidGC() { forbid_gc++; }
  void ResetForbidGC() { forbid_gc--; }
  bool IsForbidGC() const { return forbid_gc > 0; }
  clock_t GetLastTriggerTime() { return lastTriggerTime; }
  bool TriggerConcurrentSweep(size_t alloc_size);
  bool TriggerConcurrentMarking(size_t alloc_size, int &eager);
  void TryTriggerConcurrentPhases(size_t alloc_size);

 private:
#define DCHECK_ROS_IS_VALID() ROSIMPL_ASSERT(ros, "ros is null")
#define DCHECK_THREAD_POOL_IS_VALID() \
  ROSIMPL_ASSERT(workerThreadPool, "Worker thread pool is null")

  /*static thread_local */ MplThreadPool *workerThreadPool = nullptr;

  RosAllocImpl *ros{nullptr};
  bool lastGCIsConcurrent = false;
  bool enableStackScanExtend{false};
  bool createNewThreadPool{false};
  bool destroyThreadpool{true};
  bool workerThreadPoolReady{false};
  static atomic<int> threadPoolCount;

  GCMarking marking;

  // common phases.
  void ResurrectionPhase(bool isConcurrent);
  void PrepareThreadPoolIfNeeded();
  void CreateVisitorIfNeeded();
  void CreateFinalizer();
  void DumpAfterGC();
  void ResurrectionCleanup();
  void MarkPrologue(size_t threadCount);
  void ScanStackNormal(RootSet *rootSet, address_t obj);

  // parallel phases.
  void ParallelMarkAndSweep();
  void ParallelMarkPhase();
  void ParallelScanMark();
  void ParallelCollectRoots(bool isFinalRemark);
  void ParallelSweepPhase();
  bool SweepLocalRunsAndHuges(
      std::function<bool(address_t, Bitmap *)> &sweeper);
  inline WorkStack NewWorkStack() {
    constexpr size_t kWorkStackInitCapacity = 65536UL;
    WorkStack workStack;
    workStack.reserve(kWorkStackInitCapacity);
    return workStack;
  }

  // concurrent phases.
  bool TryConcurrentPhases(size_t alloc_size, int &eager);
  bool TryEnsureConcurrentMarkIsFinished();
  void FastTerminateConMarkPhase();
  void PostFinalRemarkTask();
  void ConMarkPrologue(size_t threadCount);
  void ConMarkEpilogue();
  void FinalizerPrologue(bool is_concurrent_gc);
  void FinalizerEpilogue(bool is_concurrent_gc);
  void ConcurrentMarkPhase(size_t alloc_size);
  void ConcurrentMark(int taskNum);
  void ConcurrentSweep();
  void ConcurrentSweepPhase(size_t alloc_size);
  bool EnsureConcurrentSweepIsFinished();

#if CONMARK_CHECKER_ENABLE
  void CheckConMark();
  bool CheckMark(CheckGCWorkStack &workStack, bool flag = false);
#endif  // CONMARK_CHECKER_ENABLE

  // thread pool.
  void CreateThreadPool();
  void DestroyThreadPool();
  void DestroyVisitorAndFinalizer();

  static inline void Enqueue(address_t objAddr, WorkStack &workStack) {
    workStack.push_back(objAddr);
  }

#if defined(ENABLE_DEBUG)
 private:
#define CheckLastPhaseForDebug(expectedLastPhase) \
  ROSIMPL_ASSERT(phaseForDebug &(expectedLastPhase), "unexpected last phase");
#define UpdatePhaseForDebug(phase)  \
  CheckIsValidPhaseForDebug(phase); \
  phaseForDebug = phase;

  enum PhaseForDebug {
    kInvalidPhaseForDebug = 1,
    kParallelPhaseForDebug = 2,
    kConMarkPhaseForDebug = 4,
    kReMarkPhaseForDebug = 8,
    kConSweepPhaseForDebug = 16,
    kMaxPhaseForDebug = kConSweepPhaseForDebug
  };

  void CheckIsValidPhaseForDebug(PhaseForDebug phase) {
    bool isValid = phase > kInvalidPhaseForDebug && phase <= kMaxPhaseForDebug;
    ROSIMPL_ASSERT(isValid, "not a valid phaseForDebug");
  }

  PhaseForDebug phaseForDebug{kInvalidPhaseForDebug};
#else
#define CheckLastPhaseForDebug(expectedLastPhase)
#define UpdatePhaseForDebug(phase)
#endif  // defined(ENABLE_DEBUG)
  Visitor *visitor;
  Finalizer *finalizer;
  int forbid_gc;
  clock_t lastTriggerTime;
};
}  // namespace ROS_GC

#endif
