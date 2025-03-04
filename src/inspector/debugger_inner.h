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

#ifndef SRC_INSPECTOR_DEBUGGER_INNER_H_
#define SRC_INSPECTOR_DEBUGGER_INNER_H_

#include "inspector/debugger_struct.h"

typedef struct JSProperty JSProperty;
typedef struct JSShape JSShape;
typedef struct JSVarDef JSVarDef;

void GetPossibleBreakpointsByScriptId(LEPUSContext *ctx, int32_t script_id,
                                      int64_t start_line, int64_t start_col,
                                      int64_t end_line, int64_t end_col,
                                      LEPUSValue locations);

void GetCurrentLocation(LEPUSContext *ctx, struct LEPUSStackFrame *frame,
                        const uint8_t *cur_pc, int32_t &line, int64_t &column,
                        int32_t &script_id);

LEPUSScriptSource *GetScriptByIndex(LEPUSContext *ctx, int32_t script_index);

const char *GetScriptSourceByScriptId(LEPUSContext *ctx, int32_t script_id);

LEPUSScriptSource *GetScriptByScriptURL(LEPUSContext *ctx,
                                        const char *filename);

LEPUSScriptSource *GetScriptByHash(LEPUSContext *ctx, const char *hash);

struct JSRegExp *js_get_regexp(LEPUSContext *ctx, LEPUSValueConst obj,
                               int throw_error);
struct JSString *GetRegExpPattern(struct JSRegExp *re);

LEPUSValue get_date_string(LEPUSContext *ctx, LEPUSValueConst this_val,
                           int argc, LEPUSValueConst *argv, int magic);
LEPUSValue get_date_string_GC(LEPUSContext *, LEPUSValue, int32_t,
                              LEPUSValueConst *, int);

#define QJSDebuggerClassIdDecl(V) \
  V(Map)                          \
  V(Set)                          \
  V(Date)                         \
  V(WeakMap)                      \
  V(WeakSet)                      \
  V(Proxy)                        \
  V(Generator)                    \
  V(GeneratorFunction)            \
  V(Promise)                      \
  V(WeakRef)                      \
  V(FinalizationRegistry)         \
  V(ArrayIterator)                \
  V(StringIterator)               \
  V(SetIterator)                  \
  V(MapIterator)                  \
  V(RegExpStringIterator)         \
  V(AsyncFunction)                \
  V(AsyncGenerator)               \
  V(AsyncGeneratorFunction)       \
  V(AsyncFunctionResolve)         \
  V(AsyncFunctionReject)          \
  V(AsyncFromSyncIterator)        \
  V(PromiseResolveFunction)       \
  V(PromiseRejectFunction)

#define DebuggerTypeDecl(name) uint8_t Is##name(LEPUSContext *, LEPUSValue);
QJSDebuggerClassIdDecl(DebuggerTypeDecl)
#undef DebuggerTypeDecl

    LEPUSValue
    js_map_get_size(LEPUSContext *ctx, LEPUSValueConst this_val, int magic);
LEPUSValue js_map_get_size_GC(LEPUSContext *, LEPUSValueConst, int);

uint8_t IsGenerator(LEPUSContext *ctx, LEPUSValue value);

LEPUSValue GetGeneratorFuncName(LEPUSContext *ctx, LEPUSValue obj);

LEPUSValue GetGeneratorState(LEPUSContext *ctx, LEPUSValue obj);

LEPUSValue GetGeneratorFunction(LEPUSContext *ctx, LEPUSValue obj);

uint8_t IsGeneratorFunction(LEPUSContext *ctx, LEPUSValue value);

const char *GetScriptURLByScriptId(LEPUSContext *ctx, int32_t script_id);

LEPUSValue js_typed_array_get_byteLength(LEPUSContext *ctx,
                                         LEPUSValueConst this_val,
                                         int is_dataview);

LEPUSValue JS_EvalFunctionWithThisObj(LEPUSContext *ctx, LEPUSValue func_obj,
                                      LEPUSValueConst this_obj, int argc,
                                      LEPUSValue *argv);

LEPUSValue js_function_proto_fileName(LEPUSContext *ctx,
                                      LEPUSValueConst this_val);
LEPUSValue js_function_proto_fileName_GC(LEPUSContext *, LEPUSValueConst);

LEPUSValue js_function_toString(LEPUSContext *ctx, LEPUSValueConst this_val,
                                int argc, LEPUSValueConst *argv);

LEPUSValue js_function_toString_GC(LEPUSContext *ctx, LEPUSValueConst this_val,
                                   int argc, LEPUSValueConst *argv);
int32_t GetScriptIdByFunctionBytecode(LEPUSContext *ctx,
                                      struct LEPUSFunctionBytecode *b);

struct LEPUSFunctionBytecode *GetFunctionBytecodeByScriptId(LEPUSContext *ctx,
                                                            int32_t script_id);

int32_t GetClosureSize(LEPUSContext *ctx, int32_t stack_index);

LEPUSValue GetFrameClosureVariables(LEPUSContext *ctx, int32_t stack_index,
                                    int32_t closure_level);
LEPUSContext *GetContextByContextId(LEPUSRuntime *rt, int32_t id);

QJS_HIDE int js_is_regexp(LEPUSContext *ctx, LEPUSValueConst obj);
QJS_HIDE int js_is_regexp_GC(LEPUSContext *, LEPUSValueConst);

void DebuggerFreeScript(LEPUSContext *ctx, LEPUSScriptSource *script);

LEPUSValue GetDebuggerObjectGroup(LEPUSDebuggerInfo *info);
// given the stack depth, return the local variables
LEPUSValue GetLocalVariables(LEPUSContext *ctx, int32_t stack_index);

// quickjs debugger evaluation
LEPUSValue DebuggerEval(LEPUSContext *ctx, LEPUSValueConst this_obj,
                        struct LEPUSStackFrame *sf, const char *input,
                        size_t input_len, const char *filename, int32_t flags,
                        int32_t scope_idx);

// call this function to get protocol messages sent by front end
bool GetProtocolMessages(LEPUSContext *ctx);

// make virtual machine continue running
void QuitMessageLoopOnPause(LEPUSContext *ctx);

// send response message to front end
void SendProtocolResponse(LEPUSContext *ctx, int message_id,
                          const char *response_message);
// send notification message to front end
void SendProtocolNotification(LEPUSContext *ctx, const char *response_message);

// for shared context qjs debugger: send response message to front end with view
// id
void SendProtocolResponseWithViewID(LEPUSContext *ctx, int message_id,
                                    const char *response_message,
                                    int32_t view_id);

// for shared context qjs debugger: send notification message to front end with
// view id
void SendProtocolNotificationWithViewID(LEPUSContext *ctx,
                                        const char *response_message,
                                        int32_t view_id);

// for shared context qjs debugger: set session with view_id enable state
void SetSessionEnableState(LEPUSContext *ctx, int32_t view_id,
                           int32_t protocol_type);

// for shared context qjs debugger: get session with view_id state of enable and
// paused
void GetSessionState(LEPUSContext *ctx, int32_t view_id,
                     bool *is_already_enabled, bool *is_paused);

// for shared context qjs debugger: get session enable state for Debugger,
// Runtime, Profiler, etc
void GetSessionEnableState(LEPUSContext *ctx, int32_t view_id, int32_t type,
                           bool *ret);

LEPUSValue DebuggerGetPromiseProperties(LEPUSContext *ctx, LEPUSValue val);

LEPUSValue DebuggerGetProxyProperties(LEPUSContext *ctx, LEPUSValue val);

void DebuggerSetPropertyStr(LEPUSContext *ctx, LEPUSValueConst this_obj,
                            const char *prop, LEPUSValue val);
LEPUSObject *DebuggerCreateObjFromShape(LEPUSDebuggerInfo *info, LEPUSValue obj,
                                        int32_t, LEPUSValue *);

LEPUSValue DebuggerDupException(LEPUSContext *ctx);

QJS_HIDE void SetDebuggerStepStatement(LEPUSDebuggerInfo *info,
                                       LEPUSContext *ctx,
                                       const uint8_t *cur_pc);

QJS_HIDE const uint8_t *FindBreakpointBytecode(LEPUSContext *ctx,
                                               LEPUSBreakpoint *bp);
QJS_HIDE LEPUSValue js_symbol_toString(LEPUSContext *, LEPUSValue, int32_t,
                                       LEPUSValue *);
QJS_HIDE LEPUSValue js_symbol_toString_GC(LEPUSContext *, LEPUSValue, int32_t,
                                          LEPUSValue *);
QJS_HIDE void DebuggerParseScript(LEPUSContext *ctx, const char *input,
                                  size_t input_len, struct JSFunctionDef *fd,
                                  const char *filename, int32_t end_line_num,
                                  int32_t err);
QJS_HIDE void AdjustBreakpoints(LEPUSContext *ctx, LEPUSScriptSource *script);

QJS_HIDE void DebuggerSetFunctionBytecodeScript(LEPUSContext *ctx,
                                                struct JSFunctionDef *fd,
                                                LEPUSFunctionBytecode *b);
QJS_HIDE char *DebuggerSetScriptHash(LEPUSContext *ctx, const char *src,
                                     int32_t id);
QJS_HIDE void AddFunctionBytecode(LEPUSContext *ctx, LEPUSValue obj,
                                  LEPUSFunctionBytecode **&list,
                                  uint32_t *use_size, uint32_t &total_size);
QJS_HIDE void DecreaseBpNum(LEPUSContext *ctx, LEPUSFunctionBytecode *b);
QJS_HIDE void RegisterLynxConsole(LEPUSContext *ctx);

class PCScope {
 public:
  explicit PCScope(LEPUSContext *ctx);

  ~PCScope();

 private:
  LEPUSContext *ctx_;
  const uint8_t *pc_;
};

#endif  // SRC_INSPECTOR_DEBUGGER_INNER_H_
