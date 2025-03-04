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

#ifndef SRC_INSPECTOR_DEBUGGER_DEBUGGER_BREAKPOINT_H_
#define SRC_INSPECTOR_DEBUGGER_DEBUGGER_BREAKPOINT_H_

#include "inspector/debugger/debugger.h"

// handle protocol: Debugger.setBreakpoints. set a breakpoint in the script
void SetBreakpointByURL(DebuggerParams *);

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-getPossibleBreakpoints
void HandleGetPossibleBreakpoints(DebuggerParams *);

// handle protocol: Debugger.setBreakpointActive. make all the breakpoint active
void HandleSetBreakpointActive(DebuggerParams *);

// handle protocol: Debugger.removeBreakpoint. remove a breakpoint by breakpoint
// id
void HandleRemoveBreakpoint(DebuggerParams *);

// when pause because of breakpoints, return Debugger.paused event and
// Debugger.breakpointResolved event
// ref:https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-breakpointResolved
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-paused
void PauseAtBreakpoint(LEPUSDebuggerInfo *info, LEPUSBreakpoint *bp,
                       const uint8_t *cur_pc);

/**
 * @brief check if current position is a breakpoint
 * @param cur_pc current pc
 * @return if current position is a breakpoint, return the breakpoint, else
 * return NULL
 */
LEPUSBreakpoint *CheckBreakpoint(LEPUSDebuggerInfo *, LEPUSContext *ctx,
                                 const uint8_t *cur_pc);

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-continueToLocation
void HandleContinueToLocation(DebuggerParams *);

// delete breakpoint of index bp_index
void DeleteBreakpoint(LEPUSDebuggerInfo *info, uint32_t bp_index);

// if the condition is satisfied
bool SatisfyCondition(LEPUSDebuggerInfo *info, LEPUSContext *ctx,
                      LEPUSBreakpoint *bp);
#endif  // SRC_INSPECTOR_DEBUGGER_DEBUGGER_BREAKPOINT_H_
