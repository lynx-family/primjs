#include <cstdint>

#include "gc/page_group.h"
#include "gc/sizes.h"
#ifdef ENABLE_COMPATIBLE_MM
#include <cassert>
#include <cinttypes>
#include <cstddef>

#include "gc/alloc_config.h"
#include "gc/collector.h"
#include "gc/collector_ms.h"
#include "gc/gc_tracer.h"
#include "gc/logger.h"
#include "gc/mrt_bitmap.h"
#if CONMARK_CHECKER_ENABLE
#include <set>
#include <sstream>
#endif

#if defined(ANDROID) || defined(__ANDROID__)
#include <sys/syscall.h>
#include <unistd.h>
#endif

namespace ROS_GC {
namespace {
// Small queue implementation, for prefetching.
#define MRT_MAX_PREFETCH_QUEUE_SIZE_LOG 5UL
#define MRT_MAX_PREFETCH_QUEUE_SIZE (1UL << MRT_MAX_PREFETCH_QUEUE_SIZE_LOG)
}  // namespace

class PrefetchQueue {
 public:
  explicit PrefetchQueue(size_t d) : elems{}, distance(d), tail(0), head(0) {}
  ~PrefetchQueue() {}
  inline void Add(address_t objaddr) {
    size_t t = tail;
    elems[t] = objaddr;
    tail = (t + 1) & (MRT_MAX_PREFETCH_QUEUE_SIZE - 1UL);

    __builtin_prefetch(reinterpret_cast<void *>(objaddr), 0, kPrefetchLocality);
  }

  inline address_t Remove() {
    size_t h = head;
    address_t objaddr = elems[h];
    head = (h + 1) & (MRT_MAX_PREFETCH_QUEUE_SIZE - 1UL);

    return objaddr;
  }

  inline size_t Length() const {
    return (tail - head) & (MRT_MAX_PREFETCH_QUEUE_SIZE - 1UL);
  }

  inline bool Empty() const { return head == tail; }

  inline bool Full() const { return Length() == distance; }

 private:
  static constexpr int kPrefetchLocality = 3;
  address_t elems[MRT_MAX_PREFETCH_QUEUE_SIZE];
  size_t distance;
  size_t tail;
  size_t head;
};  // End of small queue implementation

void MarkSweepCollector::ParallelScanMark() {
  auto threadPool = GetThreadPool();
  threadPool->AddTask(new (std::nothrow) MplLambdaTask([this](size_t workerID) {
    visitor->ScanStack(marking.GetWorkStack(workerID));
    marking.Execute(workerID);
  }));

  threadPool->AddTask(new (std::nothrow) MplLambdaTask([this](size_t workerID) {
    visitor->ScanHandles(marking.GetWorkStack(workerID));
    marking.Execute(workerID);
  }));

  threadPool->AddTask(new (std::nothrow) MplLambdaTask([this](size_t workerID) {
    visitor->ScanContext(marking.GetWorkStack(workerID), false);
    marking.Execute(workerID);
  }));

  threadPool->AddTask(new (std::nothrow) MplLambdaTask([this](size_t workerID) {
    visitor->ScanRuntime(marking.GetWorkStack(workerID), true, false);
    marking.Execute(workerID);
  }));
  marking.AddMarkTask(true);
}

void MarkSweepCollector::ParallelCollectRoots(bool isFinalRemark) {
  auto threadPool = GetThreadPool();
  threadPool->AddTask(new (std::nothrow)
                          MplLambdaTask([this, isFinalRemark](size_t workerID) {
                            visitor->ScanStack(marking.GetWorkStack(workerID));
                            if (isFinalRemark) {
                              marking.Execute(workerID);
                            }
                          }));

  if (visitor->GetAsyncStackSize() > 0) {
    threadPool->AddTask(new (std::nothrow) MplLambdaTask(
        [this, isFinalRemark](size_t workerID) {
          visitor->ScanAsyncStack(marking.GetWorkStack(workerID));
          if (isFinalRemark) {
            marking.Execute(workerID);
          }
        }));
  }

  threadPool->AddTask(
      new (std::nothrow) MplLambdaTask([this, isFinalRemark](size_t workerID) {
        visitor->ScanHandles(marking.GetWorkStack(workerID));
        visitor->ScanContext(marking.GetWorkStack(workerID), isFinalRemark);
        if (isFinalRemark) {
          marking.Execute(workerID);
        }
      }));

  threadPool->AddTask(new (
      std::nothrow) MplLambdaTask([this, isFinalRemark](size_t workerID) {
    visitor->ScanRuntime(marking.GetWorkStack(workerID), isFinalRemark, true);
    if (isFinalRemark) {
      marking.Execute(workerID);
    }
  }));
  workerThreadPool->Start();
  if (isFinalRemark) {
    visitor->ScanShapeArray(marking.GetWorkStack(0));
    marking.GetWorkStack(0).RetireNode();
  }

  workerThreadPool->WaitFinish(true);
}

void MarkSweepCollector::MarkPrologue(size_t threadCount) {
  marking.Prologue();
}

bool MarkSweepCollector::SweepLocalRunsAndHuges(
    std::function<bool(address_t, Bitmap *)> &sweeper) {
  ros->SweepLocalRuns(sweeper);
  return ros->SweepHugeObjs(sweeper);
}

void MarkSweepCollector::ConcurrentSweep() {
  CheckLastPhaseForDebug(kReMarkPhaseForDebug);
  UpdatePhaseForDebug(kConSweepPhaseForDebug);
  if (UNLIKELY(!ros->ConcurrentSweep(*GetThreadPool()))) {
    abort();
  }
}

static pid_t gettid() {
#if defined(ANDROID) || defined(__ANDROID__)
  return syscall(SYS_gettid);
#else
  return 0;
#endif
}

void MarkSweepCollector::CreateThreadPool() {
  char id[17];
  snprintf(id, 17, "%s%d", "_", gettid());
  workerThreadPool = new (std::nothrow) MplThreadPool(id, kThreadNumber, 0);
  if (workerThreadPool == nullptr) {
    abort();
  }
  threadPoolCount++;
  marking.Init(workerThreadPool);
}

void MarkSweepCollector::DestroyThreadPool() {
  if (workerThreadPool) {
    delete workerThreadPool;
    workerThreadPool = nullptr;
    threadPoolCount--;
  }
}

void MarkSweepCollector::DestroyVisitorAndFinalizer() {
  if (visitor) {
    delete visitor;
    visitor = nullptr;
  }
  if (finalizer) {
    delete finalizer;
    finalizer = nullptr;
  }
}

bool MarkSweepCollector::TryConcurrentPhases(size_t alloc_size, int &eager) {
  auto gc_task = ros->GetGCTracer()->FetchGCTaskType();
  if (gc_task == GCTaskType::kDoConSweep) {
    if (TriggerConcurrentSweep(alloc_size)) {
      return true;
    }
  } else if (gc_task == GCTaskType::kDoConMark) {
    // concurrent condition
    if (TriggerConcurrentMarking(alloc_size, eager)) {
      return true;
    }
  } else if (gc_task == GCTaskType::kNoGC) {
    // no gc task, just return true
    return true;
  }
  return EnureConcurrentIsCompleted();
}

void MarkSweepCollector::TryTriggerConcurrentPhases(size_t alloc_size) {
  bool in_busy_mode = ros->InGCPauseSuppressionMode();
  if (in_busy_mode || IsForbidGC()) {
    return;
  }
  if (!ros->GetEnableConcurrent()) {
    return;
  }
  if (ros->GetConcurrentMarkState() && ros->GetConMarkFinishedState()) {
    TriggerConcurrentSweep(alloc_size);
  } else if (ros->GetConcurrentSweepState() &&
             ros->GetConSweepFinishedState()) {
    EnsureConcurrentSweepIsFinished();
  }
}

bool MarkSweepCollector::TriggerConcurrentSweep(size_t alloc_size) {
  if (TryEnsureConcurrentMarkIsFinished()) {
    DoFinalizerPhase(true);
    ConcurrentSweepPhase(alloc_size);
    return true;
  }
  return false;
}

bool MarkSweepCollector::TriggerConcurrentMarking(size_t alloc_size,
                                                  int &eager) {
  TriggerConcurrentSweep(alloc_size);
  EnsureConcurrentSweepIsFinished();
  if (eager < kEagerLiteParallel) {
    ConcurrentMarkPhase(alloc_size);
    return true;
  }
  return false;
}

void MarkSweepCollector::PostFinalRemarkTask() {
  SCOPED_GC_LOG_EVENT(GCEventType::kReMarkRoots);
  PageGroups &groups = ros->GetPageGroups();
  groups.RetireNode();
  marking.PostTask();

  ParallelCollectRoots(true);
  marking.AddMarkTask(true);

  workerThreadPool->Start();
}

void MarkSweepCollector::FastTerminateConMarkPhase() {
  if (!ros->GetConcurrentMarkState()) return;
  // clear notifyfunc before draining taskpool.
  // or the gc worker thread will get remark oops repeatly(empty)
  if (workerThreadPool) workerThreadPool->SetNotifyFunc(nullptr);
  workerThreadPool->WaitFinish(true);
  ResetBitmap();
  marking.Epilogue();
  ConMarkEpilogue();
  ros->GetGCTracer()->StopCmsGC();
}

#if CONMARK_CHECKER_ENABLE

bool MarkSweepCollector::CheckMark(CheckGCWorkStack &workStack, bool flag) {
  bool ret = true;
  std::set<address_t> st;
  std::unordered_map<address_t, address_t> relation;
  const size_t prefetchDistance = 16;
  PrefetchQueue pq(prefetchDistance);
  for (;;) {
    // Prefetch as much as possible.
    while (!pq.Full() && !workStack.empty()) {
      address_t objaddr = workStack.GetWorkStack().back();
      if (objaddr) pq.Add(objaddr);
      workStack.GetWorkStack().pop_back();
    }
    // End if pq is empty.  This implies that workStack is also empty.
    if (pq.Empty()) {
      break;
    }
    address_t objaddr = pq.Remove();
    bool shouldSkipMark = ros->MarkObject(objaddr - kHeaderSize);
    int obj_cnt = 0;
    if (!shouldSkipMark) {
      address_t cur_obj = objaddr;
      obj_cnt++;

      LOG(LEVEL_1) << "ros, MarkObject: " << (void *)cur_obj;
      std::stringstream stream;
      stream << "missingObj, ";
      constexpr int mmax = 5;
      int count = 0;
      while (cur_obj != 0 && count < mmax) {
        count++;
        stream << (void *)(cur_obj)
               << "\t,alloctag:" << get_alloc_tag((void *)cur_obj);
        if (get_alloc_tag((void *)cur_obj) == ALLOC_TAG_LEPUSObject) {
          stream << " class_id: " << ((LEPUSObject *)cur_obj)->class_id << ", "
                 << "|";
        }
        stream << " <- ";
        cur_obj = relation[cur_obj];
      }
      LOG(ERROR) << "check_cnt_obj: " << obj_cnt << " " << stream.str();
      // *(int*)(0xdead) = 0;

      ret = false;
      if (auto parentObj = relation[objaddr]) {
        void *alignAddr = (void *)ALLOCUTIL_PAGE_ADDR(parentObj);
        mprotect(alignAddr, ALLOCUTIL_PAGE_SIZE * 2, PROT_READ);
        *(int *)(parentObj) = 0;
      } else {
        *(int *)(0xdead) = 0;
      }
    }

    if (st.find(objaddr) == st.end()) {
      if (flag) {
        CheckGCWorkStack tmp(ros->GetPageGroups().GetPageList());
        int alloc_tag = get_alloc_tag((void *)objaddr);
        marking.VisitEntry(alloc_tag, (void *)objaddr, tmp);
        for (auto it : tmp.GetWorkStack()) {
          workStack.push_back(it);
          relation[it] = objaddr;
        }
        st.insert(objaddr);
      } else {
        CheckGCWorkStack tmp(ros->GetPageGroups().GetPageList());
        int alloc_tag = get_alloc_tag((void *)objaddr);
        marking.VisitEntry(alloc_tag, (void *)objaddr, tmp);
        for (auto it : tmp.GetWorkStack()) {
          workStack.push_back(it);
          relation[it] = objaddr;
        }
        st.insert(objaddr);
      }
    }
  }
  workStack.GetWorkStack().clear();
  return ret;
}

void MarkSweepCollector::CheckConMark() {
  CheckGCWorkStack rootSet(ros->GetPageGroups().GetPageList());
  rootSet.SetRuntime(ros->GetRuntime());

  visitor->ScanShapeArray(rootSet);
  CheckMark(rootSet);

  visitor->ScanContext(rootSet, false);
  CheckMark(rootSet, true);

  visitor->ScanRuntime(rootSet, true, false);
  CheckMark(rootSet);

  visitor->ScanStack(rootSet);
  CheckMark(rootSet);

  visitor->ScanAsyncStack(rootSet);
  CheckMark(rootSet);

  visitor->ScanHandles(rootSet);
  CheckMark(rootSet);
}
#endif  // CONMARK_CHECKER_ENABLE

bool MarkSweepCollector::TryEnsureConcurrentMarkIsFinished() {
  DCHECK_ROS_IS_VALID();
  if (!ros->GetConcurrentMarkState()) return false;

  DCHECK_THREAD_POOL_IS_VALID();
  SCOPED_LOGGER(__func__);
  TRACE_EVENT("PRIMJS_TryEnsureConcurrentMarkIsFinished");
  SCOPED_GC_LOG_EVENT(GCEventType::kWaitMarkingFinish);

  visitor->doParallelScan = true;

  // clear notifyfunc before draining taskpool.
  // or the gc worker thread will get remark oops repeatly(empty)
  workerThreadPool->SetNotifyFunc(nullptr);

  PostFinalRemarkTask();

  CheckLastPhaseForDebug(kReMarkPhaseForDebug);
  UpdatePhaseForDebug(kReMarkPhaseForDebug);

  workerThreadPool->WaitFinish(true);

  ConMarkEpilogue();
  visitor->doParallelScan = false;
  LOG(LEVEL_1) << "ros, concurrent GC mark finished";
  return true;
}
atomic<int> MarkSweepCollector::threadPoolCount = 0;
void MarkSweepCollector::ConMarkEpilogue() {
  ros->ConMarkEpilogue();
  struct list_head *el, *el1;
  list_for_each_safe(el, el1, &visitor->rt_->context_list) {
    LEPUSContext *ctx = list_entry(el, LEPUSContext, link);
    ctx->con_mark_state = false;
  }
  visitor->rt_->con_mark_state = false;
}

void MarkSweepCollector::ConMarkPrologue(size_t threadCount) {
  MarkPrologue(threadCount);
  ros->ConMarkPrologue();
  // todo, pack with a new api
  struct list_head *el, *el1;
  list_for_each_safe(el, el1, &visitor->rt_->context_list) {
    LEPUSContext *ctx = list_entry(el, LEPUSContext, link);
    ctx->con_mark_state = true;
  }
  visitor->rt_->con_mark_state = true;
}

void MarkSweepCollector::ConcurrentSweepPhase(size_t alloc_size) {
  LOG(LEVEL_1) << "ros, concurrent-sweep running";
  SCOPED_LOGGER(__func__);
  TRACE_EVENT("PRIMJS_ConcurrentSweepPhase");

  // concurrent-sweep step1
  ros->ConSweepPrologue();

  std::function<bool(address_t, Bitmap *)> sweeper =
      [this](address_t addr, Bitmap *markBitmap) {
        return CheckAndPrepareSweep(addr, markBitmap);
      };

  SweepLocalRunsAndHuges(sweeper);
  // concurrent-sweep step2
  workerThreadPool->SetNotifyFunc([this](size_t) {
    ros->SetConSweepFinishedState(true);
    ros->GetGCTracer()->StopCurrentSweeping(false);
  });
  // concurrent-sweep step3
  ConcurrentSweep();

  lastGCIsConcurrent = true;
}

bool MarkSweepCollector::EnsureConcurrentSweepIsFinished() {
  SCOPED_LOGGER(__func__);
  TRACE_EVENT("PRIMJS_EnsureConcurrentSweepIsFinished");

  if (!ros->GetConcurrentSweepState()) return false;

  SCOPED_GC_LOG_EVENT(GCEventType::kWaitSweepingFinish);
  workerThreadPool->SetNotifyFunc(nullptr);
  // todo, should consider allcation speed to shorten this time
  if (workerThreadPool && !workerThreadPool->IsStopped()) {
    workerThreadPool->WaitFinish(true, nullptr);
  }

  ros->ConSweepEpilogue();
  ResetBitmap();
  ros->DisableMarkNewObj();
  ros->GetGCTracer()->StopCmsGC();
  return true;
}

void MarkSweepCollector::OnlyUpdateHeapSize(size_t alloc_size) {
  if (ros->GetConMarkFinishedState()) {
    FastTerminateConMarkPhase();
  }
  ros->UpdateHeapSizeLimitForBusymode(alloc_size);
}

void MarkSweepCollector::RunFullCollection(size_t alloc_size, int eager,
                                           bool forceParallel) {
  SCOPED_LOGGER(__func__);
  TRACE_EVENT("PRIMJS_RunFullCollection");
  lastTriggerTime = clock();
  bool in_busy_mode = ros->InGCPauseSuppressionMode();

  if (in_busy_mode || IsForbidGC()) {
    OnlyUpdateHeapSize(alloc_size);
    return;
  }

  PrepareThreadPoolIfNeeded();
  CreateVisitorIfNeeded();
  ros->gc_cnt++;

#ifdef ROS_FORCE_GC
  if (ros->gc_cnt % 1000 == 0) {
    LOG(LEVEL_0) << "RunFullCollection, cnt: " << ros->gc_cnt
                 << " is_concurrent: " << ros->GetEnableConcurrent();
  }
#endif

  if (ros->GetEnableConcurrent()) {
    if (forceParallel) {
      EnureConcurrentIsCompleted();
    } else if (TryConcurrentPhases(alloc_size, eager))
      return;
  }

  // Run mark-and-sweep gc.
  {
    GCTraceScope traceScope(ros->GetGCTracer(), GCEventType::kEventParallel,
                            alloc_size);
    ParallelMarkAndSweep();
    // releaes mark bitmap memory after GC.
    ResetBitmap();
    ros->ReleaseEmptyLocalruns();
    ros->ReleasePageGroups();
    // parallel will also compact pss metrics
    ros->ReleaseFreePages(true);
    JS_UpdateGCInfo(ros->GetRuntime(), 0, true);
  }
  lastGCIsConcurrent = false;
}

void MarkSweepCollector::DoOnlyFinalizer() {
  finalizer->DoGlobalFinalizer();

  auto rt = ros->GetRuntime();
  for (auto it = rt->finalizerSet->begin(); it != rt->finalizerSet->end();
       it++) {
    auto val = *it;
    finalizer->DoFinalizer2(val);
  }
  rt->finalizerSet->clear();

  if (rt->obj_finalizer_recoder) {
    auto &set = *rt->obj_finalizer_recoder;
    for (auto it = set.begin(); it != set.end(); ++it) {
      LEPUSObject *obj = *it;
      if (JS_OBJECT_IS_OUTER(obj)) {
        finalizer->JSObjectOnlyFinalizer(obj);
      }
    }
    rt->obj_finalizer_recoder->clear();
  }

  if (rt->fr_data_finalizer_recoder) {
    rt->fr_data_finalizer_recoder->clear();
  }
}

void MarkSweepCollector::RunFinalCollection() {
  TRACE_EVENT("PRIMJS_RunFinalCollection");
  DoOnlyFinalizer();
  DestroyThreadPool();
}

bool MarkSweepCollector::EnureConcurrentIsCompleted() {
  TriggerConcurrentSweep(0);
  return EnsureConcurrentSweepIsFinished();
}

void MarkSweepCollector::ScanStackNormal(RootSet *rootSet, address_t obj) {
  if (ros->AccurateIsValidObjAddr(obj)) {
    rootSet->push_back(obj);
    LOG(LEVEL_1) << "ros, stack roots: " << (void *)(obj);
  }
}

MarkSweepCollector::~MarkSweepCollector() {
  if (destroyThreadpool) DestroyThreadPool();
  DestroyVisitorAndFinalizer();
}

void MarkSweepCollector::Init(const VMCollectorParam &vmCollectorParam) {
  createNewThreadPool = vmCollectorParam.createNewThreadPool;
  destroyThreadpool = vmCollectorParam.destroyThreadpool;
}

void __attribute__((no_sanitize("address")))
MarkSweepCollector::ScanStack(RootSet *rootSet, uint8_t *frame_pointer,
                              uint8_t *stack_top) {
  ROSIMPL_ASSERT(
      reinterpret_cast<uintptr_t>(frame_pointer) % kStackAlignment == 0,
      "frame pointer is not 8 bytes aligned");
  ROSIMPL_ASSERT(reinterpret_cast<uintptr_t>(stack_top) % kStackAlignment == 0,
                 "stack top is not 8 bytes aligned");
  for (uint8_t *cursor = frame_pointer; cursor < stack_top;
       cursor += kStackAlignment) {
    address_t addr = *reinterpret_cast<address_t *>(cursor);
    ScanStackAddr(rootSet, addr);
  }
}

void MarkSweepCollector::ScanStackAddr(RootSet *rootSet, address_t addr) {
  if (!enableStackScanExtend)
    ScanStackNormal(rootSet, addr);
  else
    ros->TryToRecordValidObjAddr(rootSet, addr);
}

// stop the world parallel mark & sweep.
void MarkSweepCollector::ParallelMarkAndSweep() {
  LOG(LEVEL_1) << "ros, parallel GC running";
  CheckLastPhaseForDebug(kInvalidPhaseForDebug | kConSweepPhaseForDebug |
                         kParallelPhaseForDebug);
  UpdatePhaseForDebug(kParallelPhaseForDebug);

  visitor->doParallelScan = true;
  ParallelMarkPhase();
  DoFinalizerPhase(false);
  ParallelSweepPhase();
  visitor->doParallelScan = false;

  LOG(LEVEL_1) << "ros, parallel GC finished";
  return;
}

void MarkSweepCollector::PrepareThreadPoolIfNeeded() {
  if (workerThreadPoolReady && workerThreadPool) return;
  if (createNewThreadPool) DestroyThreadPool();
  if (!workerThreadPool) CreateThreadPool();
  workerThreadPoolReady = true;
}

void MarkSweepCollector::CreateVisitorIfNeeded() {
  if (!visitor) visitor = new Visitor(ros->GetRuntime(), finalizer);
}

void MarkSweepCollector::CreateFinalizer() {
  finalizer = new Finalizer(ros->GetRuntime());
}

void MarkSweepCollector::ConcurrentMark(int taskNum) {
  SCOPED_GC_LOG_EVENT(GCEventType::kMarkRoots);
  DCHECK_THREAD_POOL_IS_VALID();
  ros->SetWorkerThreadPoolInMainThread(workerThreadPool);

  visitor->ScanShapeArray(marking.GetWorkStack(0));
  marking.GetWorkStack(0).RetireNode();

  marking.AddMarkTask(false);

  CheckLastPhaseForDebug(kInvalidPhaseForDebug | kParallelPhaseForDebug |
                         kConSweepPhaseForDebug);
  UpdatePhaseForDebug(kConMarkPhaseForDebug);

  workerThreadPool->Start();
}

void MarkSweepCollector::ConcurrentMarkPhase(size_t alloc_size) {
  DCHECK_ROS_IS_VALID();
  DCHECK_THREAD_POOL_IS_VALID();

  LOG(LEVEL_1) << "ros, concurrent-mark running";
  TRACE_EVENT("PRIMJS_ConcurrentMarkPhase");

  const size_t threadCount = workerThreadPool->GetMaxThreadNum() + 1;
  ConMarkPrologue(threadCount);
  visitor->doParallelScan = true;

  ParallelCollectRoots(false);
  visitor->doParallelScan = false;

  // `SetNotifyFunc` should init before ConcurrentMark, and after any threadpool
  // operation.
  workerThreadPool->SetNotifyFunc([this](size_t) {
    ros->SetConMarkFinishedState(true);
    ros->GetGCTracer()->StopCurrentMarking(false);
  });

  ConcurrentMark(threadCount);
}

void MarkSweepCollector::ParallelMarkPhase() {
  SCOPED_LOGGER(__func__);
  TRACE_EVENT("PRIMJS_ParallelMarkPhase");

  MplThreadPool *threadPool = GetThreadPool();
  const size_t threadCount = threadPool->GetMaxThreadNum() + 1;
  {
    MarkPrologue(threadCount);
    ros->MarkPrologue();

    threadPool->Start();
    ros->SetWorkerThreadPoolInMainThread(threadPool);
    ParallelScanMark();
    threadPool->WaitFinish(true, nullptr);

    // MarkEpilogue(/*isParallel=*/true);
    ros->MarkEpilogue();
  }

  LOG(LEVEL_1) << "Mark finished";
}

void MarkSweepCollector::FinalizerPrologue(bool is_concurrent_gc) {
  forbid_gc++;
  ros->EnableMarkNewObj();
}

void MarkSweepCollector::FinalizerEpilogue(bool is_concurrent_gc) {
  forbid_gc--;
  if (!is_concurrent_gc) {
    ros->DisableMarkNewObj();
  }
  marking.Epilogue();
}

const int Value_RefCounted = 19;
void MarkSweepCollector::DoFinalizerPhase(bool is_concurrent_gc) {
  SCOPED_LOGGER(__func__);
  TRACE_EVENT("PRIMJS_DoFinalizerPhase");
  SCOPED_GC_LOG_EVENT(GCEventType::kDoFinalizer);

  FinalizerPrologue(is_concurrent_gc);
  if (!is_concurrent_gc) {
    finalizer->JSShapeArrayFinalizer();
  }

  finalizer->DoGlobalFinalizer();
  DoOuterObjFinalizer();

  if (visitor->HasObjsDuringFinalizer()) {
    workerThreadPool->Start();
    ros->GetPageGroups().RetireNode();
    marking.PostTask();
    workerThreadPool->WaitFinish(true);
    visitor->ReleaseFinalizerObj();
  }

#ifdef ENABLE_QUICKJS_DEBUGGER
  workerThreadPool->Start();
  workerThreadPool->AddTask(new (std::nothrow) MplLambdaTask(
      [this](size_t workerID) { finalizer->BytecodeListFinalizer(); }));
  workerThreadPool->WaitFinish(true);
#endif

  GCWorkStack &markStack = marking.GetWorkStack(0);
  for (auto it = visitor->rt_->finalizerSet->begin();
       it != visitor->rt_->finalizerSet->end();) {
    auto val = *it;
    if (!ros->IsObjectMarked((address_t)(val)-kHeaderSize)) {
      it = visitor->rt_->finalizerSet->erase(it);
      visitor->DoFinalizer(val);
    } else {
      if (get_alloc_tag(val) == ALLOC_TAG_LEPUSLepusRef &&
          reinterpret_cast<LEPUSLepusRef *>(val)->tag == Value_RefCounted) {
        visitor->VisitLEPUSLepusRef((void *)(val), markStack);
      }
      it++;
    }
  }
  if (!markStack.empty()) {
    workerThreadPool->Start();
    markStack.RetireNode();
    workerThreadPool->WaitFinish(true);
  }

  if (is_concurrent_gc) visitor->rt_->async_obj_recoder->clear();

#if CONMARK_CHECKER_ENABLE
  {
    visitor->doParallelScan = true;
    CheckConMark();
    visitor->doParallelScan = false;
  }
#endif  // CONMARK_CHECKER_ENABLE
  FinalizerEpilogue(is_concurrent_gc);
}

void MarkSweepCollector::DoOuterObjFinalizer() {
  SCOPED_LOGGER(__func__);
  TRACE_EVENT("PRIMJS_DoOuterObjFinalizer");

#define FINALIZER_HANDLER(recorder, func)                       \
  if (rt->recorder) {                                           \
    auto &set = *rt->recorder;                                  \
    for (auto it = set.begin(); it != set.end();) {             \
      auto val = *it;                                           \
      if (!ros->IsObjectMarked((address_t)(val)-kHeaderSize)) { \
        it = set.erase(it);                                     \
        finalizer->func(val);                                   \
      } else {                                                  \
        it++;                                                   \
      }                                                         \
    }                                                           \
  }

  auto rt = ros->GetRuntime();
  FINALIZER_HANDLER(obj_finalizer_recoder, JSObjectFinalizer)
  FINALIZER_HANDLER(fr_data_finalizer_recoder,
                    FinalizationRegistryDataFinalizer)
#undef FINALIZER_HANDLER
}

void MarkSweepCollector::ParallelSweepPhase() {
  SCOPED_LOGGER(__func__);
  TRACE_EVENT("PRIMJS_ParallelSweepPhase");

  if (UNLIKELY(!ros->ParallelFreeAllIf(*GetThreadPool()))) {
    abort();
  }
}
}  // namespace ROS_GC
#if CONMARK_CHECKER_ENABLE
void CheckGCWorkStack::push_back(address_t ele) {
  if (ele == 0) {
    return;
  }
  auto obj_addr = ele - ROS_GC::kHeaderSize;
  ROS_GC::Bitmap *bit_map = ROS_GC::PageGroups::GetBitMapFromAddr(obj_addr);
  if (!bit_map->IsObjectMarked(obj_addr)) {
    *((address_t *)0xdeadbeef) = obj_addr;
  }
  // 1. shoule be marked
  // 2. should not be collected
  // 3. should be accessible
  ori_stack_.push_back(ele);
}
#endif
#endif  // ENABLE_COMPATIBLE_MM
