// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "quickjs/include/quickjs-inner.h"
#if !defined(_WIN32)
#include "gc/trace-gc.h"
#include "inspector/cpuprofiler/profile_generator.h"
#include "inspector/cpuprofiler/tracing_cpu_profiler.h"
#include "inspector/debugger/debugger.h"
#include "inspector/interface.h"
#include "inspector/protocols.h"

void HandleProfilerEnable(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSValue message = debugger_options->message;
    LEPUSValue view_id_val = LEPUS_GetPropertyStr(ctx, message, "view_id");
    int32_t view_id = -1;
    if (!LEPUS_IsUndefined(view_id_val)) {
      LEPUS_ToInt32(ctx, &view_id, view_id_val);
      if (!ctx->gc_enable) LEPUS_FreeValue(ctx, view_id_val);
    }

    if (view_id != -1) {
      // set session enable state
      SetSessionEnableState(ctx, view_id, PROFILER_ENABLE);
    }

    LEPUSDebuggerInfo *info = ctx->debugger_info;
    info->is_profiling_enabled += 1;
    LEPUSValue result = LEPUS_NewObject(ctx);
    if (!LEPUS_IsException(result)) {
      HandleScope func_scope{ctx, &result, HANDLE_TYPE_LEPUS_VALUE};
      SendResponse(ctx, message, result);
    }
  }
}

void HandleProfilerDisable(DebuggerParams *profiler_options) {
  LEPUSContext *ctx = profiler_options->ctx;
  if (ctx) {
    LEPUSValue message = profiler_options->message;
    if (!CheckEnable(ctx, message, PROFILER_ENABLE)) return;
    LEPUSValue view_id_val = LEPUS_GetPropertyStr(ctx, message, "view_id");
    int32_t view_id = -1;
    if (!LEPUS_IsUndefined(view_id_val)) {
      LEPUS_ToInt32(ctx, &view_id, view_id_val);
    }

    if (view_id != -1) {
      // set session enable state
      SetSessionEnableState(ctx, view_id, PROFILER_DISABLE);
    }

    LEPUSDebuggerInfo *info = ctx->debugger_info;
    info->is_profiling_enabled -= 1;
    LEPUSValue result = LEPUS_NewObject(ctx);
    if (!LEPUS_IsException(result)) {
      HandleScope func_scope{ctx, &result, HANDLE_TYPE_LEPUS_VALUE};
      SendResponse(ctx, message, result);
    }
  }
}

void HandleSetSamplingInterval(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSValue message = debugger_options->message;
    if (!CheckEnable(ctx, message, PROFILER_ENABLE)) return;
    LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");
    LEPUSValue params_interval = LEPUS_GetPropertyStr(ctx, params, "interval");
    uint32_t interval = 0;
    LEPUS_ToUint32(ctx, &interval, params_interval);
    if (!ctx->gc_enable) LEPUS_FreeValue(ctx, params);
    auto *info = ctx->debugger_info;
    if (info) {
      info->profiler_interval = interval;
    }
    LEPUSValue result = LEPUS_NewObject(ctx);
    if (!LEPUS_IsException(result)) {
      HandleScope func_scope{ctx, &result, HANDLE_TYPE_LEPUS_VALUE};
      SendResponse(ctx, message, result);
    }
  }
}

void HandleProfilerStart(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  LEPUSValue message = debugger_options->message;
  if (!CheckEnable(ctx, message, PROFILER_ENABLE)) return;
  auto *info = ctx->debugger_info;
  if (!info || info->is_profiling_started) return;
  auto cpu_profiler = std::make_shared<primjs::CpuProfiler::CpuProfiler>(ctx);
  info->cpu_profiler = cpu_profiler;
  cpu_profiler->set_sampling_interval(info->profiler_interval);
  cpu_profiler->StartProfiling("");

  LEPUSValue result = LEPUS_NewObject(ctx);
  if (!LEPUS_IsException(result)) {
    HandleScope func_scope{ctx, &result, HANDLE_TYPE_LEPUS_VALUE};
    SendResponse(ctx, message, result);
  }
  return;
}

void HandleProfilerStop(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  LEPUSValue message = debugger_options->message;
  if (!CheckEnable(ctx, message, PROFILER_ENABLE)) {
    auto result = LEPUS_NewObject(ctx);
    HandleScope func_scope{ctx, &result, HANDLE_TYPE_LEPUS_VALUE};
    SendResponse(ctx, message, result);
    return;
  }
  auto &cpu_profiler = ctx->debugger_info->cpu_profiler;
  if (!(cpu_profiler && cpu_profiler->IsProfiling())) return;
  auto profile = cpu_profiler->StopProfiling("");
  auto profile_result = profile->GetCpuProfileContent(ctx);
  if (LEPUS_IsException(profile_result)) {
    cpu_profiler = nullptr;
    printf("Profiler Result Serialize Fail!\n");
    return;
  }
  HandleScope func_scope{ctx, &profile_result, HANDLE_TYPE_LEPUS_VALUE};
  SendResponse(ctx, message, profile_result);
  cpu_profiler = nullptr;
  return;
}

void SetCpuProfilerInterval(LEPUSContext *ctx, int32_t interval) {
  if (!ctx->debugger_info) return;
  ctx->debugger_info->profiler_interval = interval;
  return;
}

void StartCpuProfiler(LEPUSContext *ctx) {
  auto &info = ctx->debugger_info;
  if (!info || info->is_profiling_started) return;
  info->is_profiling_enabled++;
  auto &cpu_profiler = info->cpu_profiler;
  cpu_profiler = std::make_shared<primjs::CpuProfiler::CpuProfiler>(ctx);
  cpu_profiler->set_sampling_interval(info->profiler_interval);
  cpu_profiler->StartProfiling("");
  return;
}

LEPUSValue StopCpuProfiler(LEPUSContext *ctx) {
  auto &info = ctx->debugger_info;
  if (!(info && info->cpu_profiler && info->cpu_profiler->IsProfiling()))
    return LEPUS_UNDEFINED;
  auto &cpu_profiler = info->cpu_profiler;
  auto profile = cpu_profiler->StopProfiling("");
  LEPUSValue profile_result = profile->GetCpuProfileContent(ctx);
  HandleScope func_scope{ctx, &profile_result, HANDLE_TYPE_LEPUS_VALUE};
  LEPUSValue json_str = LEPUS_ToJSON(ctx, profile_result, 0);
  if (!ctx->gc_enable) {
    LEPUS_FreeValue(ctx, profile_result);
  }
  info->is_profiling_enabled--;
  cpu_profiler = nullptr;
  return json_str;
}
#else
typedef struct DebuggerParams DebuggerParams;
#include "inspector/interface.h"
void SetCpuProfilerInterval(LEPUSContext *, int32_t) {}
void StartCpuProfiler(LEPUSContext *) {}
LEPUSValue StopCpuProfiler(LEPUSContext *) { return LEPUS_UNDEFINED; }

void HandleSetSamplingInterval(DebuggerParams *) {}
void HandleProfilerStart(DebuggerParams *) {}
void HandleProfilerEnable(DebuggerParams *) {}
void HandleProfilerDisable(DebuggerParams *) {}
void HandleProfilerStop(DebuggerParams *) {}
#endif
