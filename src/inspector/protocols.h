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

#ifndef SRC_INSPECTOR_PROTOCOLS_H_
#define SRC_INSPECTOR_PROTOCOLS_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "quickjs/include/quickjs.h"

#ifdef __cplusplus
}
#endif

#include <cstring>
#include <string>
#include <unordered_map>
typedef struct DebuggerParams DebuggerParams;

typedef enum ProtocolType {
  DEBUGGER_ENABLE,
  DEBUGGER_DISABLE,
  RUNTIME_ENABLE,
  RUNTIME_DISABLE,
  PROFILER_ENABLE,
  PROFILER_DISABLE,
  OTHER,
} ProtocolType;

// compare function and hash function for const char*
unsigned int DEKHash(const char *str, unsigned int length);
struct cmp {
  bool operator()(const char *s1, const char *s2) const {
    return !strcmp(s1, s2);
  }
};

struct hash_func {
  size_t operator()(const char *arg) const { return DEKHash(arg, strlen(arg)); }
};

// send protocol response to fontend
void SendResponse(LEPUSContext *ctx, LEPUSValue message, LEPUSValue result);

// send protocol notification to frontend
void SendNotification(LEPUSContext *ctx, const char *method, LEPUSValue params,
                      int32_t view_id = -1);

// check if the xxx.enable is already processing
bool CheckEnable(LEPUSContext *ctx, LEPUSValue message, ProtocolType protocol);

#endif  // SRC_INSPECTOR_PROTOCOLS_H_
