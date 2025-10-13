// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_BASE_TIMMER_H
#define PRIMJS_BASE_TIMMER_H

#include <sys/time.h>
#include <sys/times.h>
#include <time.h>

#include "primjs/base/globalDefinitions.h"
#ifdef __APPLE__
#include <mach/mach_time.h>
#endif

namespace base {

class RTSTimmer : public AllStatic {
 private:
#ifdef __APPLE__
  static mach_timebase_info_data_t _timebase_info;
  static uint64_t _max_abstime;
#endif

 public:
  static constexpr int64_t NanosecondsPerMicrosecond = 1000;
  static constexpr int64_t MicrosecondsPerMillisecond = 1000;
  static void clock_init() {
#ifdef __APPLE__
    mach_timebase_info(&_timebase_info);
#endif
  }

  static uint64_t now() {
#ifdef __APPLE__
    uint64_t ticks =
        (mach_absolute_time() * _timebase_info.numer) / _timebase_info.denom;
    if (ticks < _max_abstime) {
      return _max_abstime;
    }
    _max_abstime = ticks;
    return ticks;
#else
    struct timespec tp;
    clock_gettime(CLOCK_MONOTONIC, &tp);
    PRIMJS_long result =
        PRIMJS_long(tp.tv_sec) * NANOSECS_PER_SEC + PRIMJS_long(tp.tv_nsec);
    return result;
#endif
  }
};

}  // namespace base
#endif  // PRIMJS_BASE_TIMMER_H
