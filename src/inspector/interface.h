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

#ifndef SRC_INSPECTOR_INTERFACE_H_
#define SRC_INSPECTOR_INTERFACE_H_
#ifdef __cplusplus
extern "C" {
#endif
typedef struct LEPUSFunctionBytecode LEPUSFunctionBytecode;
// quickjs debugger initialize, initialize LEPUSDebuggerInfo
void QJSDebuggerInitialize(LEPUSContext *ctx);

// free quickjs debugger, free LEPUSDebuggerInfo
void QJSDebuggerFree(LEPUSContext *ctx);

// process protocol message sent here when then paused
void ProcessPausedMessages(LEPUSContext *ctx, const char *message);

// call this funciton for each pc, do inspector check
void DoInspectorCheck(LEPUSContext *ctx);

// send consoleAPICalled notification
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#event-consoleAPICalled
void SendConsoleAPICalledNotification(LEPUSContext *ctx, LEPUSValue *msg);

// send scriptParsed notification
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-scriptParsed
void SendScriptParsedNotification(LEPUSContext *ctx, LEPUSScriptSource *source);

// send scriptFailToParse notification
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-scriptFailedToParse
void SendScriptFailToParseNotification(LEPUSContext *ctx,
                                       LEPUSScriptSource *script);

// push message to message queue, and process it
void PushAndProcessProtocolMessages(LEPUSDebuggerInfo *info, const char *msg);

// call this function to process protocol messages sent by front end
void ProcessProtocolMessages(LEPUSDebuggerInfo *info);

// when an exception happened, call this function to pause when necessary
void HandleDebuggerException(LEPUSContext *ctx);

// push protocol message to mesasge queue
void PushBackQueue(struct qjs_queue *q, const char *content);

// send Debugger.paused event
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-paused
void SendPausedEvent(LEPUSDebuggerInfo *info, const uint8_t *cur_pc,
                     LEPUSValue bp_id, const char *reason);

void *GetDebuggerInfoOpaque(LEPUSDebuggerInfo *info);
void SetDebuggerInfoOpaque(LEPUSDebuggerInfo *info, void *opaque);

struct LEPUSDebuggerInfo *GetDebuggerInfo(LEPUSContext *ctx);

struct qjs_queue *GetDebuggerMessageQueue(struct LEPUSDebuggerInfo *info);

void SetDebuggerSourceCode(LEPUSContext *ctx, char *source_code);

void AddDebuggerScript(LEPUSContext *ctx, char *script_source,
                       int32_t source_len, int32_t end_line_num);
// pause on debugger keyword
void PauseOnDebuggerKeyword(LEPUSDebuggerInfo *info, const uint8_t *cur_pc);

// for lepusNG debugger encode
uint8_t *GetFunctionDebugPC2LineBuf(LEPUSContext *ctx,
                                    LEPUSFunctionBytecode *b);
const char *GetFunctionDebugFileName(LEPUSContext *ctx,
                                     LEPUSFunctionBytecode *b);
uint32_t GetFunctionDebugId(struct LEPUSFunctionBytecode *b);

uint32_t DebuggerGetFuncSize(LEPUSContext *ctx);

void SetFunctionDebugPC2LineBufLen(LEPUSContext *ctx, LEPUSFunctionBytecode *b,
                                   uint8_t *buf, int buf_len);

void SetFunctionDebugFileName(LEPUSContext *ctx, LEPUSFunctionBytecode *b,
                              const char *filename, int len);

const char *GetFunctionName(LEPUSContext *ctx, LEPUSFunctionBytecode *b);

int32_t GetFunctionDebugLineNum(LEPUSContext *ctx,
                                struct LEPUSFunctionBytecode *);

int GetFunctionDebugPC2LineLen(LEPUSContext *ctx, LEPUSFunctionBytecode *b);

LEPUSFunctionBytecode **GetDebuggerAllFunction(LEPUSContext *ctx,
                                               LEPUSValue top_level_function,
                                               uint32_t *use_size);
void SetFunctionDebugLineNum(LEPUSFunctionBytecode *b, int line_number);

void SetFunctionDebugColumnNum(LEPUSFunctionBytecode *b, int64_t column_number);

void SetDebuggerEndLineNum(LEPUSContext *ctx, int32_t end_line_num);

void ComputeLineCol(int64_t line_col_num, int32_t *line, int64_t *column);

int GetFunctionBytecodeLen(LEPUSFunctionBytecode *b);

int32_t GetFunctionDebugSourceLen(LEPUSContext *ctx, LEPUSFunctionBytecode *b);

const char *GetFunctionDebugSource(LEPUSContext *ctx, LEPUSFunctionBytecode *b);

void SetFunctionDebugSource(LEPUSContext *ctx, LEPUSFunctionBytecode *b,
                            const char *source, int32_t source_len);

int64_t GetFunctionDebugColumnNum(LEPUSContext *ctx,
                                  struct LEPUSFunctionBytecode *b);

// for shared context qjs debugger: call this function to process protocol
// messages sent by session with view id
void ProcessProtocolMessagesWithViewID(LEPUSDebuggerInfo *info,
                                       int32_t view_id);

// send scriptParsed notification
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-scriptParsed
// for shared context qjs debugger: send script parsed event with view id
void SendScriptParsedNotificationWithViewID(LEPUSContext *ctx,
                                            LEPUSScriptSource *source,
                                            int32_t view_id);

// for shared context qjs debugger: send script fail to parse event with view id
void SendScriptFailToParseNotificationWithViewID(LEPUSContext *ctx,
                                                 LEPUSScriptSource *script,
                                                 int32_t view_id);

// for shared context qjs debugger: delete qjs debugger script by URL
void DeleteScriptByURL(LEPUSContext *ctx, const char *filename);

// for shared context qjs debugger: send consoleAPICalled event with runtime id
void SendConsoleAPICalledNotificationWithRID(LEPUSContext *ctx,
                                             LEPUSValue *msg);

// delete corresponding console message using runtime id
void DeleteConsoleMessageWithRID(LEPUSContext *ctx, int32_t rid);

// get context id
int32_t GetExecutionContextId(LEPUSContext *ctx);

// generate console stack trace
void GetConsoleStackTrace(LEPUSContext *, LEPUSValue *);

void SetContextConsoleInspect(LEPUSContext *ctx, bool enable);

/*
  return value should be freed by LEPUS_FreeCString;
*/
const char *GetConsoleObject(LEPUSContext *, const char *);

// return an array of int64_t,  should be freed by lepus_free.
int64_t *GetFunctionLineNums(LEPUSContext *, const LEPUSFunctionBytecode *,
                             size_t *);
void SetDebugInfoOutside(LEPUSContext *, bool);
void SetCpuProfilerInterval(LEPUSContext *, int32_t);
void StartCpuProfiler(LEPUSContext *);
LEPUSValue StopCpuProfiler(LEPUSContext *);
LEPUSValue GetFunctionCallerString(LEPUSContext *ctx,
                                   const LEPUSFunctionBytecode *b);

void SetJSDebuggerName(LEPUSContext *ctx, const char *name);
#ifdef __cplusplus
}
#endif
#endif  // SRC_INSPECTOR_INTERFACE_H_
