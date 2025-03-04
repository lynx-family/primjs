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

#ifndef SRC_INSPECTOR_DEBUGGER_DEBUGGER_CALLFRAME_H_
#define SRC_INSPECTOR_DEBUGGER_DEBUGGER_CALLFRAME_H_

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif

#include "inspector/debugger/debugger.h"

/**
 * @brief call this function to handle "Debugger.evalueateOnCallFrame"
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-evaluateOnCallFrame
void HandleEvaluateOnCallFrame(DebuggerParams *);

// when vm paused, call this function to get callframe stack
LEPUSValue BuildBacktrace(LEPUSContext *ctx, const uint8_t *cur_pc);

// when console.xxx is called, use this function to get stack trace
LEPUSValue BuildConsoleBacktrace(LEPUSContext *ctx, const uint8_t *cur_pc);

#endif  // SRC_INSPECTOR_DEBUGGER_DEBUGGER_CALLFRAME_H_
