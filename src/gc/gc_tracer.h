// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_GC_GC_TRACER_H_
#define SRC_GC_GC_TRACER_H_

#include <chrono>
#include <cstdint>
#include <utility>

#include "gc/alloc_config.h"

namespace ROS_GC {

class Space;
class RosAllocImpl;

class RecordBuffer {
 public:
  static constexpr int kSize = 10;
  typedef std::pair<uint64_t, double> ValueType;

  RecordBuffer() { Reset(); }

  void Reset() { start_ = count_ = 0; }
  int Count() const { return count_; }

  template <typename Callback>
  ValueType Sum(Callback callback, const ValueType &initial) const {
    int j = start_ + count_ - 1;
    if (j >= kSize) j -= kSize;
    ValueType result = initial;
    for (int i = 0; i < count_; i++) {
      result = callback(result, elements_[j]);
      if (--j == -1) j += kSize;
    }
    return result;
  }

  void Push(uint64_t bytes, double duration) {
    if (count_ == kSize) {
      elements_[start_++] = std::make_pair(bytes, duration);
      if (start_ == kSize) start_ = 0;
    } else {
      elements_[count_++] = std::make_pair(bytes, duration);
    }
  }

 private:
  ValueType elements_[kSize];
  int start_;
  int count_;
};

enum GCEventType {
  kNonGC = 0,
  kEventParallel,
  kEventCms,

  kWaitMarkingFinish,
  kWaitSweepingFinish,
  kMarkRoots,
  kReMarkRoots,
  kDoFinalizer,
};

struct GCRecord {
  GCEventType type_{GCEventType::kNonGC};
  std::chrono::time_point<std::chrono::steady_clock> startTime{};
  std::chrono::time_point<std::chrono::steady_clock> endTime{};
  size_t startAllocationInBytes_{0};
  size_t endAllocationInBytes_{0};
};

struct GCCounter {
  size_t count{0};
  size_t time{0};
};

enum GCTaskType {
  kNoTask,  // do nothing
  kNoGC,
  kDoConSweep,  // do Con-Sweep
  kDoConMark,   // check ros internalSize to trigger gc
  kParallelGC,
};

class GCTracer {
 public:
  GCTracer(Space *space) : space_(space) {}
  ~GCTracer() = default;

  void Start(GCEventType type, size_t alloc_size = 0);
  void Stop();

  double HeapGrowingFactor();

  void SetAllocator(RosAllocImpl *ros) { ros_ = ros; }

  double GetGcSpeed() {
    if (gcSpeedCache_ != 0.0) {
      return gcSpeedCache_;
    }
    auto init = std::make_pair(0ULL, 0.0);
    gcSpeedCache_ = AverageSpeed(gcRecordBuffer_, init, 0);
    return gcSpeedCache_;
  }
  double AllocationSpeed() {
    if (allocationSpeedCache_ != 0.0) {
      return allocationSpeedCache_;
    }
    auto init = std::make_pair(0ULL, 0.0);
    allocationSpeedCache_ = AverageSpeed(allocationRecordBuffer_, init, 0);
    return allocationSpeedCache_;
  }

  size_t GetGCCount() { return parallelGC_.count; }

  size_t GetGCDuration() { return last_para_gc_duration_; }

  void StartCurrentMarking();
  void StopCurrentMarking(bool form_mutator);
  void StartCurrentSweeping();
  void StopCurrentSweeping(bool form_mutator);

  void StartCmsGC();
  void StopCmsGC();

  bool TryTriggerConcurrentPhases();
  bool TriggerConcurrentMarking();
  bool HasLowAllocationRate();

  GCTaskType FetchGCTaskType() {
    auto old = gc_task_type_;
    gc_task_type_ = GCTaskType::kNoTask;
    return old;
  }
  void SetNoGC() { gc_task_type_ = GCTaskType::kNoGC; }
  void SetGCTaskType(GCTaskType type) { gc_task_type_ = type; }
  bool NeedTriggerConcurrentSweep() {
    auto old = triggerConcurrentSweep_;
    triggerConcurrentSweep_ = false;
    return old;
  }

  double CurrentMarkingSpeed() {
    auto init = std::make_pair(0ULL, 0.0);
    return AverageSpeed(currentMarkingBuffer_, init, 0);
  }
  double CurrentSweepingSpeed() {
    auto init = std::make_pair(0ULL, 0.0);
    return AverageSpeed(currentSweepBuffer_, init, 0);
  }

  double SurvivalRate() {
    auto init = std::make_pair(0ULL, 0.0);
    return AverageSpeed(survivalRateRecordBuffer_, init, 0);
  }
  double SurvivalRateCache() {
    if (survivalRateCache_ != 0.0) {
      return survivalRateCache_;
    }
    survivalRateCache_ = SurvivalRate();
    if (survivalRateCache_ == 0.0) {
      survivalRateCache_ = 0.95;
    }
    return survivalRateCache_;
  }

  double CurrentMarkSpeed() {
    if (currentMarkSpeedCache_ != 0.0) {
      return currentMarkSpeedCache_;
    }
    currentMarkSpeedCache_ = CurrentMarkingSpeed();
    if (currentMarkSpeedCache_ == 0.0) {
      currentMarkSpeedCache_ = 20000;
    }
    return currentMarkSpeedCache_;
  }
  double CurrentSweepSpeed() {
    if (currentSweepSpeedCache_ != 0.0) {
      return currentSweepSpeedCache_;
    }
    currentSweepSpeedCache_ = CurrentSweepingSpeed();
    if (currentSweepSpeedCache_ == 0.0) {
      currentSweepSpeedCache_ = 20000;
    }
    return currentSweepSpeedCache_;
  }
  void UpdateHeapSizeLimit();
  size_t CalculateHeapSizeLimit();

  void Log(GCEventType type, size_t durationInMs);
  void Dump();

 private:
  double AverageSpeed(const RecordBuffer &buffer,
                      const RecordBuffer::ValueType &initial, double timeInMs);
  bool CanTriggerConcurrentMarking();

  Space *space_{nullptr};
  RosAllocImpl *ros_{nullptr};

  GCRecord currentRecord_;
  GCRecord previousRecord_;
  GCRecord currentMarkingRecord_;
  GCRecord currentSweepingRecord_;
  size_t allocationInBytesSinceGc_{0};
  double allocationDurationSinceGc_{0.0};
  double currentMarkSpeedCache_{0.0};
  double currentSweepSpeedCache_{0.0};
  double allocationSpeedCache_{0.0};
  double gcSpeedCache_{0.0};
  double survivalRateCache_{0.0};
  size_t gcStartCount_{0};

  bool triggerConcurrentSweep_{false};
  bool concurrent_sweep_is_running_{false};
  bool concurrent_mark_is_running_{false};
  bool cms_gc_is_running_{false};

  RecordBuffer allocationRecordBuffer_;
  RecordBuffer gcRecordBuffer_;
  RecordBuffer currentMarkingBuffer_;
  RecordBuffer currentSweepBuffer_;
  RecordBuffer survivalRateRecordBuffer_;

  size_t heapSizeUpdateCnt_{0};
  size_t originHeapSize_{0};
  size_t originUsedHeapSize_{0};
  size_t originAllocatedInternalSize_{0};
  size_t lastAllocatedInternalSize_{0};
  size_t currentAllocSize_{0};
  bool heapSizeConfigured_{false};
  int heapCompactCounter_{0};
  int cmsGCReachLimitCount_{0};

  GCCounter parallelGC_{0, 0};
  GCCounter concurrentMark_{0, 0};
  GCCounter concurrentSweep_{0, 0};
  GCCounter cmsGC_{0, 0};
  GCCounter markRoots_{0, 0};
  GCCounter reMarkRoots_{0, 0};
  GCCounter finializer_{0, 0};
  GCCounter waitMarking_{0, 0};
  GCCounter waitSweeping_{0, 0};
  GCTaskType gc_task_type_{kNoTask};
  size_t last_para_gc_duration_{0};
};

class GCTraceScope {
 public:
  GCTraceScope(GCTracer *tracer, GCEventType type, size_t alloc_size)
      : tracer_(tracer) {
    tracer_->Start(type, alloc_size);
  }
  ~GCTraceScope() { tracer_->Stop(); }

 private:
  GCTracer *tracer_;
};

class GCLoggerScope {
 public:
  GCLoggerScope(GCTracer *tracer, GCEventType type)
      : tracer_(tracer), type_(type) {
    startTime_ = std::chrono::steady_clock::now();
  }
  ~GCLoggerScope() {
    auto endTime = std::chrono::steady_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(
        endTime - startTime_);
    tracer_->Log(type_, duration.count());
  }

 private:
  GCTracer *tracer_;
  GCEventType type_{};
  std::chrono::time_point<std::chrono::steady_clock> startTime_{};
};

#define SCOPED_GC_LOG_EVENT(type) \
  GCLoggerScope tracer_logger_(ros->GetGCTracer(), type)

}  // namespace ROS_GC
#endif  // SRC_GC_GC_TRACER_H_
