// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifdef ENABLE_COMPATIBLE_MM
#include "gc/gc_tracer.h"

#include <algorithm>

#include "gc/collector_ms.h"
#include "gc/logger.h"
#include "gc/ros_allocator.h"

namespace ROS_GC {

void GCTracer::Start(GCEventType type, size_t alloc_size) {
  previousRecord_ = currentRecord_;
  gcStartCount_++;

  bool is_first_gc = previousRecord_.endTime == previousRecord_.startTime;
  currentRecord_.type_ = type;
  currentRecord_.startTime = std::chrono::steady_clock::now();
  originAllocatedInternalSize_ = ros_->GetAllocatedInternalSize();
  currentRecord_.startAllocationInBytes_ = originAllocatedInternalSize_;
  currentAllocSize_ = alloc_size;

  if (!is_first_gc) {
    auto duration = std::chrono::duration<double, std::milli>(
        currentRecord_.startTime - previousRecord_.endTime);
    allocationDurationSinceGc_ += duration.count();
  } else {
    allocationDurationSinceGc_ = 0.1;
  }
  allocationInBytesSinceGc_ = currentRecord_.startAllocationInBytes_ -
                              previousRecord_.endAllocationInBytes_;
  originUsedHeapSize_ = space_->usedHeapSize;
  if (currentRecord_.type_ == GCEventType::kEventParallel) {
    heapSizeConfigured_ = false;
  }
}

void GCTracer::Stop() {
  currentRecord_.endTime = std::chrono::steady_clock::now();
  currentRecord_.endAllocationInBytes_ = ros_->GetAllocatedInternalSize();

  if (allocationInBytesSinceGc_ > 0) {
    allocationRecordBuffer_.Push(allocationInBytesSinceGc_,
                                 allocationDurationSinceGc_);
    allocationSpeedCache_ = 0.0;
  }
  allocationInBytesSinceGc_ = 0;
  allocationDurationSinceGc_ = 0.0;

  double gc_duration = 0.0;
  bool is_parallel = currentRecord_.type_ == GCEventType::kEventParallel;
  if (is_parallel) {
    gc_duration = std::chrono::duration<double, std::milli>(
                      currentRecord_.endTime - currentRecord_.startTime)
                      .count();
    parallelGC_.count++;
    parallelGC_.time += gc_duration;
    heapSizeConfigured_ = originUsedHeapSize_ > space_->usedHeapSize;
    last_para_gc_duration_ = gc_duration;
  } else {
    gc_duration = std::chrono::duration<double, std::milli>(
                      currentSweepingRecord_.endTime - currentRecord_.startTime)
                      .count();
    cmsGC_.count++;
    cmsGC_.time += gc_duration;
  }
  lastAllocatedInternalSize_ = ros_->GetAllocatedInternalSize();
  gcRecordBuffer_.Push(currentRecord_.startAllocationInBytes_, gc_duration);
  survivalRateRecordBuffer_.Push(lastAllocatedInternalSize_,
                                 (double)originAllocatedInternalSize_);
  gcSpeedCache_ = 0.0;
  survivalRateCache_ = 0.0;
  UpdateHeapSizeLimit();
}

void GCTracer::StartCmsGC() { Start(GCEventType::kEventCms); }
void GCTracer::StopCmsGC() {
  if (currentRecord_.type_ == GCEventType::kEventCms) {
    Stop();
  }
}

bool GCTracer::CanTriggerConcurrentMarking() {
  static constexpr int kCmsGCReachLimitCountLimit = 8;
  auto heapSize = space_->heapSize;
  return (heapCompactCounter_ < kHeapCompactThreshold) &&
         (heapSize <= kConcurrentThreshold * kGCPolicyThreshold) &&
         (cmsGCReachLimitCount_ < kCmsGCReachLimitCountLimit);
}

bool GCTracer::TriggerConcurrentMarking() {
  if (!CanTriggerConcurrentMarking()) {
    return false;
  }
  auto heapSize = space_->heapSize;
  auto usedHeapSize = space_->usedHeapSize;
  if ((int64_t)(heapSize - usedHeapSize) < (int64_t)kRosDefaultPageGroupSize) {
    return false;
  }
  constexpr double kSurvivalRateThreshold = 0.93;
  if (SurvivalRateCache() >= kSurvivalRateThreshold) {
    return false;
  }
  auto alloc_speed = AllocationSpeed();
  if (alloc_speed == 0) {
    return true;
  }
  auto marking_speed = CurrentMarkSpeed();
  auto sweeping_speed = CurrentSweepSpeed();

  // auto allocatedInternalSize = lastAllocatedInternalSize_;
  auto alloc_duration = (heapSize - usedHeapSize) / alloc_speed;
  auto mark_duration1 = lastAllocatedInternalSize_ / marking_speed;
  auto mark_duration2 = usedHeapSize / sweeping_speed;

  double remain_size =
      (alloc_duration - mark_duration1 - mark_duration2) * alloc_speed;

  return remain_size < (double)kPageSize;
}

bool GCTracer::TryTriggerConcurrentPhases() {
  if (NeedTriggerConcurrentSweep()) {
    gc_task_type_ = GCTaskType::kDoConSweep;
    return true;
  }
  if (cms_gc_is_running_ || ros_->GetCollector()->IsForbidGC()) {
    return false;
  }
  if (TriggerConcurrentMarking()) {
    gc_task_type_ = GCTaskType::kDoConMark;
    return true;
  }
  return false;
}

size_t GCTracer::CalculateHeapSizeLimit() {
  auto growingFactor = HeapGrowingFactor();
  size_t oldHeapSize = space_->usedHeapSize;
  size_t heapSize = oldHeapSize;

  heapSize *= growingFactor;

  size_t halfToMaxSize =
      (static_cast<size_t>(oldHeapSize) + kGCPolicyThreshold) / 2;
  heapSize = std::min(halfToMaxSize, heapSize);
  heapSize = std::min(space_->heapGrowthLimit, heapSize);
  heapSize = std::max(heapSize, kRosDefaultPageGroupSize);
  return heapSize;
}

void GCTracer::UpdateHeapSizeLimit() {
  bool is_parallel = currentRecord_.type_ == GCEventType::kEventParallel;
  size_t oldHeapSize = space_->heapSize;
  size_t newHeapSize = 0;
  if (is_parallel) {
    newHeapSize = CalculateHeapSizeLimit();
  } else if (!HasLowAllocationRate()) {
    cmsGCReachLimitCount_++;
    return;
  } else {
    newHeapSize = CalculateHeapSizeLimit();
    if (newHeapSize >= oldHeapSize) {
      return;
    }
  }
  cmsGCReachLimitCount_ = 0;
  originHeapSize_ = space_->heapSize;
  heapSizeUpdateCnt_++;
  space_->UpdateHeapSizeLimit(is_parallel ? kParallel : kConSweep,
                              currentAllocSize_, lastAllocatedInternalSize_,
                              newHeapSize);

  if (is_parallel) {
    heapCompactCounter_ = 0;
  } else if (originHeapSize_ < newHeapSize) {
    heapCompactCounter_ += 2;
  } else if (originHeapSize_ == newHeapSize) {
    heapCompactCounter_++;
  }
#ifdef ENABLE_GC_LOG
  Dump();
#endif
}

bool GCTracer::HasLowAllocationRate() {
  auto gc_speed = GetGcSpeed();
  auto alloc_speed = AllocationSpeed();
  if (alloc_speed == 0) return false;
  if (gc_speed == 0) {
    gc_speed = 200000;
  }
  auto mu = gc_speed / (alloc_speed + gc_speed);
  constexpr double kMutatorUtilization = 0.99;
  return mu > kMutatorUtilization;
}

void GCTracer::Dump() {
  std::stringstream stream;
  stream << "----------------------------------" << std::endl;
  stream << "gcStartCount_: " << gcStartCount_ << std::endl;
  stream << "parallelGC_.count: " << parallelGC_.count
         << "  parallelGC_.time: " << parallelGC_.time
         << "ms, avg: " << parallelGC_.time / parallelGC_.count << "ms"
         << std::endl;
  stream << "cmsGC_.count: " << cmsGC_.count << "  cmsGC_.time: " << cmsGC_.time
         << "ms, avg: " << cmsGC_.time / cmsGC_.count << "ms" << std::endl;
  stream << "concurrentMark_.count: " << concurrentMark_.count
         << "  concurrentMark_.time: " << concurrentMark_.time
         << "ms, avg: " << concurrentMark_.time / concurrentMark_.count << "ms"
         << std::endl;
  stream << "concurrentSweep_.count: " << concurrentSweep_.count
         << "  concurrentSweep_.time: " << concurrentSweep_.time
         << "ms, avg: " << concurrentSweep_.time / concurrentSweep_.count
         << "ms" << std::endl;
  stream << "waitMarking_.count: " << waitMarking_.count
         << "  waitMarking_.time: " << waitMarking_.time
         << "us, avg: " << waitMarking_.time / waitMarking_.count << "us"
         << std::endl;
  stream << "waitSweeping_.count: " << waitSweeping_.count
         << "  waitSweeping_.time: " << waitSweeping_.time
         << "us, avg: " << waitSweeping_.time / waitSweeping_.count << "us"
         << std::endl;

  stream << "markRoots_.count: " << markRoots_.count
         << "  markRoots_.time: " << markRoots_.time
         << "us, avg: " << markRoots_.time / markRoots_.count << "us"
         << std::endl;
  stream << "reMarkRoots_.count: " << reMarkRoots_.count
         << "  reMarkRoots_.time: " << reMarkRoots_.time
         << "us, avg: " << reMarkRoots_.time / reMarkRoots_.count << "us"
         << std::endl;
  stream << "finializer_.count: " << finializer_.count
         << "  finializer_.time: " << finializer_.time
         << "us, avg: " << finializer_.time / finializer_.count << "us"
         << std::endl;

  auto allocatedInternalSize = ros_->GetAllocatedInternalSize();
  auto growingFactor = HeapGrowingFactor();
  auto usedMemSize = space_->usedMemSize;
  auto usedHeapSize = space_->usedHeapSize;
  auto heapSize = space_->heapSize;
  auto originHeapSize = originHeapSize_;
  stream << "idx: " << heapSizeUpdateCnt_ << ", ros_log UpdateHeapSizeLimit"
         << " , growing_factor: " << growingFactor
         << " , newHeapSize: " << (double)heapSize / MB
         << "(MB) , origin_heap_size: " << (double)originHeapSize / MB
         << "(MB) , allocatedInternalSize: "
         << (double)allocatedInternalSize / MB
         << "(MB) , usedMemSize:" << (double)usedMemSize / MB
         << "(MB) , usedHeapSize:" << usedHeapSize / MB << "(MB)" << std::endl;
  stream << "----------------------------------" << std::endl;

  LOG(LEVEL_0) << stream.str();
}

void GCTracer::Log(GCEventType type, size_t durationInMs) {
  switch (type) {
    case GCEventType::kWaitMarkingFinish:
      waitMarking_.count++;
      waitMarking_.time += durationInMs;
      break;
    case GCEventType::kWaitSweepingFinish:
      waitSweeping_.count++;
      waitSweeping_.time += durationInMs;
      break;
    case GCEventType::kMarkRoots:
      markRoots_.count++;
      markRoots_.time += durationInMs;
      break;
    case GCEventType::kReMarkRoots:
      reMarkRoots_.count++;
      reMarkRoots_.time += durationInMs;
      break;
    case GCEventType::kDoFinalizer:
      finializer_.count++;
      finializer_.time += durationInMs;
      break;
    default:
      break;
  }
  // #ifdef ENABLE_GC_LOG
  //   Dump();
  // #endif
}

void GCTracer::StartCurrentMarking() {
  currentMarkingRecord_.startTime = std::chrono::steady_clock::now();
  currentMarkingRecord_.endTime = currentMarkingRecord_.startTime;
  concurrent_mark_is_running_ = true;
  cms_gc_is_running_ = true;
  StartCmsGC();
}

void GCTracer::StopCurrentMarking(bool form_mutator) {
  if (!concurrent_mark_is_running_) return;
  if (!form_mutator) {
    triggerConcurrentSweep_ = true;
    return;
  }

  if (currentMarkingRecord_.endTime == currentMarkingRecord_.startTime) {
    currentMarkingRecord_.endTime = std::chrono::steady_clock::now();
  }
  auto gc_duration = std::chrono::duration<double, std::milli>(
      currentMarkingRecord_.endTime - currentMarkingRecord_.startTime);
  auto bytes = ros_->GetAllocatedInternalSize();
  currentMarkingBuffer_.Push(bytes, gc_duration.count());
  concurrent_mark_is_running_ = false;
  triggerConcurrentSweep_ = true;
  concurrentMark_.count++;
  concurrentMark_.time += gc_duration.count();
}

void GCTracer::StartCurrentSweeping() {
  concurrent_sweep_is_running_ = true;
  triggerConcurrentSweep_ = false;
  currentSweepingRecord_.startTime = std::chrono::steady_clock::now();
  currentSweepingRecord_.endTime = currentSweepingRecord_.startTime;
  currentSweepingRecord_.startAllocationInBytes_ =
      ros_->GetAllocatedInternalSize();
  originAllocatedInternalSize_ = currentSweepingRecord_.startAllocationInBytes_;
}

void GCTracer::StopCurrentSweeping(bool form_mutator) {
  if (!concurrent_sweep_is_running_) return;
  if (!form_mutator) {
    cms_gc_is_running_ = false;
    currentSweepingRecord_.endTime = std::chrono::steady_clock::now();
    return;
  }
  if (currentSweepingRecord_.endTime == currentSweepingRecord_.startTime) {
    currentSweepingRecord_.endTime = std::chrono::steady_clock::now();
  }
  concurrent_sweep_is_running_ = false;
  cms_gc_is_running_ = false;
  auto gc_duration = std::chrono::duration<double, std::milli>(
      currentSweepingRecord_.endTime - currentSweepingRecord_.startTime);
  int sweep_bytes = space_->usedHeapSize;
  sweep_bytes = std::max(sweep_bytes, 0);
  currentSweepBuffer_.Push(sweep_bytes, gc_duration.count());
  currentMarkSpeedCache_ = 0.0;
  currentSweepSpeedCache_ = 0.0;
  concurrentSweep_.count++;
  concurrentSweep_.time += gc_duration.count();
}

double GCTracer::HeapGrowingFactor() {
  auto gc_speed = GetGcSpeed();
  auto alloc_speed = AllocationSpeed();
  if (gc_speed == 0 || alloc_speed == 0) return kMinHeapGrowingFactor;

  double ut = kRosimplDefaultHeapTargetUtilization;
  auto ro = gc_speed / alloc_speed;
  double l = ro * (1 - ut);
  double r = ro * (1 - ut) - ut;
  double factor =
      (l < r * kMaxHeapGrowingFactor) ? l / r : kMaxHeapGrowingFactor;
  factor = std::min(factor, kMaxHeapGrowingFactor);
  factor = std::max(factor, kMinHeapGrowingFactor);

  return factor;
}

double GCTracer::AverageSpeed(const RecordBuffer &buffer,
                              const RecordBuffer::ValueType &initial,
                              double timeInMs) {
  RecordBuffer::ValueType sum = buffer.Sum(
      [timeInMs](RecordBuffer::ValueType a, RecordBuffer::ValueType b) {
        if (timeInMs != 0 && a.second >= timeInMs) return a;
        return std::make_pair(a.first + b.first, a.second + b.second);
      },
      initial);
  uint64_t bytes = sum.first;
  double durations = sum.second;
  if (durations == 0.0) return 0;
  double speed = bytes / durations;
  speed = std::min(speed, static_cast<double>(1000 * MB));
  return speed;
}

}  // namespace ROS_GC
#endif  // ENABLE_COMPATIBLE_MM
