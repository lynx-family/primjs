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

#ifndef SRC_INSPECTOR_DEBUGGER_DEBUGGER_PROPERTIES_H_
#define SRC_INSPECTOR_DEBUGGER_DEBUGGER_PROPERTIES_H_

#include "inspector/debugger/debugger.h"

typedef LEPUSValue (*GetPropertyCallback)(LEPUSContext *ctx,
                                          LEPUSValue property_name,
                                          LEPUSValue &property_value,
                                          int writeable, int configurable,
                                          int enumerable);

typedef LEPUSValue (*GetEntryCallback)(LEPUSContext *ctx,
                                       LEPUSValue &entry_value,
                                       int32_t writeable, int32_t configurable,
                                       int32_t enumerable);
/**
 * @brief handle "Runtime.getProperties" protocol
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-getProperties
void HandleGetProperties(DebuggerParams *);

LEPUSValue GetSideEffectResult(LEPUSContext *ctx);

// Gets the value of an object property
LEPUSValue GetRemoteObject(LEPUSContext *ctx, LEPUSValue &property_value,
                           int32_t need_preview, int32_t return_by_value);

// generate unique object id for obj
LEPUSValue GenerateUniqueObjId(LEPUSContext *ctx, LEPUSValue obj);

LEPUSValue GetExceptionDescription(LEPUSContext *ctx, LEPUSValue exception);

#endif  // SRC_INSPECTOR_DEBUGGER_DEBUGGER_PROPERTIES_H_
