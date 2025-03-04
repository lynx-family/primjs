// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#if !defined(_WIN32)
#ifndef SRC_INSPECTOR_CPUPROFILER_PROFILER_TIME_H_
#define SRC_INSPECTOR_CPUPROFILER_PROFILER_TIME_H_
#include <assert.h>
#ifdef OS_IOS
#include <mach/mach.h>
#include <mach/mach_time.h>
#endif
#include <time.h>

class TimeTicks {
 public:
  static constexpr int64_t kMillisecondsPerSecond = 1000;
  static constexpr int64_t kMicrosecondsPerMillisecond = 1000;
  static constexpr int64_t kNanosecondsPerMicrosecond = 1000;
  static constexpr int64_t kMicrosecondsPerSecond =
      kMicrosecondsPerMillisecond * kMillisecondsPerSecond;
  static constexpr int64_t kNanosecondsPerSecond =
      kNanosecondsPerMicrosecond * kMicrosecondsPerSecond;

  constexpr TimeTicks() = default;
  // This method never returns a null TimeTicks
  static uint64_t Now() {
    int64_t ticks;
#ifdef OS_IOS
    static struct mach_timebase_info info;
    if (info.denom == 0) {
      kern_return_t result = mach_timebase_info(&info);
      assert(result == KERN_SUCCESS);
    }
    ticks = (mach_absolute_time() * (info.numer / info.denom) /
             kNanosecondsPerMicrosecond);
#elif defined(OS_ANDROID)
    struct timespec ts;
    if (clock_gettime(CLOCK_BOOTTIME, &ts) != 0) {
      ticks = 0;
    } else {
      ticks = static_cast<int64_t>(ts.tv_sec) * kMicrosecondsPerSecond +
              ts.tv_nsec / kNanosecondsPerMicrosecond;
    }
#else
    struct timespec ts;
    if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0) {
      ticks = 0;
    } else {
      ticks = static_cast<int64_t>(ts.tv_sec) * kMicrosecondsPerSecond +
              ts.tv_nsec / kNanosecondsPerMicrosecond;
    }
#endif
    return ticks + 1;
  }
};

#endif
#endif  // SRC_INSPECTOR_CPUPROFILER_PROFILER_TIME_H_
