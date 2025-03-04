/*
 * QuickJS Javascript Engine
 *
 * Copyright (c) 2017-2019 Fabrice Bellard
 * Copyright (c) 2017-2019 Charlie Gordon
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INSPECTOR_DEBUGGER_DEBUGGER_H_
#define SRC_INSPECTOR_DEBUGGER_DEBUGGER_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "quickjs/include/quickjs.h"

#ifdef __cplusplus
}
#endif

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "inspector/debugger_inner.h"
#include "quickjs/include/quickjs-inner.h"

// debugger step mode: step over, step in, step out and continue
enum DebuggerStepMode {
  DEBUGGER_STEP = 1,
  DEBUGGER_STEP_IN,
  DEBUGGER_STEP_OUT,
  DEBUGGER_STEP_CONTINUE
};

enum DebuggerStatus {
  JS_DEBUGGER_PAUSED,  // need to pause because step_type
  JS_DEBUGGER_RUN,     // run next pc directly
};

struct DebuggerParams {
  LEPUSContext *ctx;
  LEPUSValue message;
  uint8_t type;
};
typedef struct DebuggerParams DebuggerParams;

// given current pc, return the line, column position of this pc, the script id
void GetDebuggerCurrentLocation(LEPUSContext *ctx, const uint8_t *cur_pc,
                                int32_t &line, int64_t &column,
                                int32_t &script_id);

// return current frame stack depth
uint32_t GetDebuggerStackDepth(LEPUSContext *ctx);

// return if the system need to paused because of breakpoints or stepping
bool DebuggerNeedProcess(LEPUSDebuggerInfo *info, LEPUSContext *ctx);

// handle debugger.enable
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-enable
void HandleEnable(DebuggerParams *);

// handle debugger.getscriptsource
// get script source given a script id
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-getScriptSource
void HandleGetScriptSource(DebuggerParams *);

// handle debugger.pause
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-pause
void HandlePause(DebuggerParams *params);

// handle debugger.stepxx
void HandleStep(DebuggerParams *);

// handle debugger.resume
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-resume
void HandleResume(DebuggerParams *);

// handle setPauseOnexceptions
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-setPauseOnExceptions
void HandleSetPauseOnExceptions(DebuggerParams *);

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-setSkipAllPauses
void HandleSkipAllPauses(DebuggerParams *);

// handle debugger.disable
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-disable
void HandleDisable(DebuggerParams *);

// given the script, return the script info need by Debugger.ScriptParsed
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-scriptParsed
LEPUSValue GetMultiScriptParsedInfo(LEPUSContext *ctx,
                                    LEPUSScriptSource *script);

// stop at first pc
void HandleStopAtEntry(DebuggerParams *debugger_options);

// pause on next statement
void HandlePauseOnNextStatement(LEPUSContext *ctx);

// adjust breakpoint location to the nearest bytecode
void AdjustBreakpoint(LEPUSDebuggerInfo *info, const char *url,
                      const char *hash, LEPUSBreakpoint *bp);

LEPUSValue DebuggerEvaluate(LEPUSContext *ctx, const char *callframe_id,
                            LEPUSValue expression);

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-setAsyncCallStackDepth
void HandleSetAsyncCallStackDepth(DebuggerParams *);

// get location
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#type-Location
LEPUSValue GetLocation(LEPUSContext *ctx, int32_t line, int64_t column,
                       int32_t script_id);

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-setVariableValue
void HandleSetVariableValue(DebuggerParams *);

// send console api called event. if has_rid = true, put rid in the response
// message
void SendConsoleAPICalled(LEPUSContext *ctx, LEPUSValue *msg,
                          bool has_rid = false);

class ExceptionBreakpointScope {
 public:
  ExceptionBreakpointScope(LEPUSDebuggerInfo *info, uint32_t tmp_val) {
    exception_breakpoint_val_ = info->exception_breakpoint;
    info_ = info;
    info->exception_breakpoint = tmp_val;
  }
  ~ExceptionBreakpointScope() {
    info_->exception_breakpoint = exception_breakpoint_val_;
  }

 private:
  LEPUSDebuggerInfo *info_;
  uint8_t exception_breakpoint_val_;
};

class PauseStateScope {
 public:
  explicit PauseStateScope(LEPUSDebuggerInfo *info) {
    info_ = info;
    auto &state = info_->pause_state;
    state.get_properties_array = LEPUS_NewArray(info->ctx);
    state.get_properties_array_len = 0;
  }
  ~PauseStateScope() {
    auto &state = info_->pause_state;
    if (!info_->ctx->gc_enable)
      LEPUS_FreeValue(info_->ctx, state.get_properties_array);
    state.get_properties_array = LEPUS_UNDEFINED;
    state.get_properties_array_len = 0;
  }

 private:
  LEPUSDebuggerInfo *info_;
};

/*
  return value should be freed by caller with LEPUS_FreeCString.
*/
static inline const char *ValueToJsonString(LEPUSContext *ctx, LEPUSValue obj) {
  auto json = LEPUS_ToJSON(ctx, obj, 0);
  auto *str = LEPUS_ToCString(ctx, json);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, json);
  return str;
}
#endif  // SRC_INSPECTOR_DEBUGGER_DEBUGGER_H_
