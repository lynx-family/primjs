// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INSPECTOR_CPUPROFILER_TRACING_CPU_PROFILER_H_
#define SRC_INSPECTOR_CPUPROFILER_TRACING_CPU_PROFILER_H_

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif
#include "inspector/cpuprofiler/cpu_profiler.h"

typedef struct DebuggerParams DebuggerParams;
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Profiler/#method-setSamplingInterval
void HandleSetSamplingInterval(DebuggerParams *);
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Profiler/#method-start
void HandleProfilerStart(DebuggerParams *);
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Profiler/#method-enable
void HandleProfilerEnable(DebuggerParams *);
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Profiler/#method-disable
void HandleProfilerDisable(DebuggerParams *);
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Profiler/#method-stop
void HandleProfilerStop(DebuggerParams *);
#endif  // SRC_INSPECTOR_CPUPROFILER_TRACING_CPU_PROFILER_H_
