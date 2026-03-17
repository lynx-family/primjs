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

#include "inspector/protocols.h"

#include "gc/trace-gc.h"
#include "inspector/cpuprofiler/tracing_cpu_profiler.h"
#include "inspector/debugger/debugger.h"
#include "inspector/debugger/debugger_breakpoint.h"
#include "inspector/debugger/debugger_callframe.h"
#include "inspector/debugger/debugger_properties.h"
#include "inspector/debugger/debugger_queue.h"
#include "inspector/debugger_inner.h"
#include "inspector/heapprofiler/heapprofiler.h"
#include "inspector/interface.h"
#include "inspector/runtime/runtime.h"

typedef void (*func_ptr)(struct DebuggerParams *);
using debug_function_type =
    std::unordered_map<const char *, func_ptr, hash_func, cmp>;
using debug_step_type =
    std::unordered_map<const char *, uint8_t, hash_func, cmp>;

unsigned int DEKHash(const char *str, unsigned int length) {
  unsigned int hash = length;
  unsigned int i = 0;

  for (i = 0; i < length; ++str, ++i) {
    hash = ((hash << 5) ^ (hash >> 27)) ^ (*str);
  }

  return hash;
}

const debug_function_type &GetDebugFunctionMap() {
  static const debug_function_type debugger_function_map = {
      {"Debugger.getPossibleBreakpoints", HandleGetPossibleBreakpoints},
      {"Debugger.setBreakpointsActive", HandleSetBreakpointActive},
      {"Debugger.setBreakpoint", SetBreakpointByURL},
      {"Debugger.setBreakpointByUrl", SetBreakpointByURL},
      {"Debugger.evaluateOnCallFrame", HandleEvaluateOnCallFrame},
      {"Debugger.removeBreakpoint", HandleRemoveBreakpoint},
      {"Debugger.stepInto", HandleStep},
      {"Debugger.stepOver", HandleStep},
      {"Debugger.stepOut", HandleStep},
      {"Debugger.resume", HandleResume},
      {"Debugger.enable", HandleEnable},
      {"Debugger.stopAtEntry", HandleStopAtEntry},
      {"Debugger.getScriptSource", HandleGetScriptSource},
      {"Debugger.pause", HandlePause},
      {"Debugger.disable", HandleDisable},
      {"Debugger.continueToLocation", HandleContinueToLocation},
      {"Debugger.setAsyncCallStackDepth", HandleSetAsyncCallStackDepth},
      {"Debugger.setVariableValue", HandleSetVariableValue},
      {"Debugger.setPauseOnExceptions", HandleSetPauseOnExceptions},
      {"Debugger.setSkipAllPauses", HandleSkipAllPauses},
      {"Runtime.getProperties", HandleGetProperties},
      {"Runtime.evaluate", HandleEvaluate},
      {"Runtime.callFunctionOn", HandleCallFunctionOn},
      {"Runtime.enable", HandleRuntimeEnable},
      {"Runtime.disable", HandleRuntimeDisable},
      {"Runtime.discardConsoleEntries", HandleDiscardConsoleEntries},
      {"Runtime.compileScript", HandleCompileScript},
      {"Runtime.globalLexicalScopeNames", HandleGlobalLexicalScopeNames},
      {"Runtime.runScript", HandleRunScript},
      {"Runtime.setAsyncCallStackDepth", HandleSetAsyncCallStackDepth},
      {"Runtime.getHeapUsage", HandleRuntimeGetHeapUsage},
      // HeapProfiler begin
      {"HeapProfiler.takeHeapSnapshot", HandleHeapProfilerProtocols},
      // HeapProfiler end
      {"Profiler.setSamplingInterval", HandleSetSamplingInterval},
      {"Profiler.start", HandleProfilerStart},
      {"Profiler.stop", HandleProfilerStop},
      {"Profiler.enable", HandleProfilerEnable},
      {"Profiler.disable", HandleProfilerDisable},
  };
  return debugger_function_map;
}

const debug_step_type &GetDebuggerStepMap() {
  static const debug_step_type debugger_step_map = {
      {"Debugger.stepInto", DEBUGGER_STEP_IN},
      {"Debugger.stepOver", DEBUGGER_STEP},
      {"Debugger.stepOut", DEBUGGER_STEP_OUT}};
  return debugger_step_map;
}

// send protocol responses
QJS_HIDE void SendProtocolResponse(LEPUSContext *ctx, int32_t message_id,
                                   const char *response_message) {
  auto send_response_callback = ctx->rt->debugger_callbacks_.send_response;
  if (send_response_callback) {
    send_response_callback(ctx, message_id, response_message);
  }
}

// send protocol notifications
QJS_HIDE void SendProtocolNotification(LEPUSContext *ctx,
                                       const char *response_message) {
  auto send_notification_callback =
      ctx->rt->debugger_callbacks_.send_notification;
  if (send_notification_callback) {
    send_notification_callback(ctx, response_message);
  }
}

// get protocol messages when vm is running
QJS_HIDE bool GetProtocolMessages(LEPUSContext *ctx) {
  auto get_messages_callback = ctx->rt->debugger_callbacks_.get_messages;
  if (get_messages_callback) {
    get_messages_callback(ctx);
    return true;
  }
  return false;
}

// for shared context qjs debugger: set session enable state
QJS_HIDE void SetSessionEnableState(LEPUSContext *ctx, int32_t view_id,
                                    int32_t protocol_type) {
  auto cb = ctx->rt->debugger_callbacks_.set_session_enable_state;
  if (cb) {
    cb(ctx, view_id, protocol_type);
  }
}

// get session enable state given view id: Debugger, Runtime, etc.
QJS_HIDE void GetSessionEnableState(LEPUSContext *ctx, int32_t view_id,
                                    int32_t protocol_type, bool *ret) {
  auto cb = ctx->rt->debugger_callbacks_.get_session_enable_state;
  if (cb) {
    cb(ctx, view_id, protocol_type, ret);
  } else {
    *ret = true;
  }
}

// for shared context qjs debugger: get session state: enable and paused
QJS_HIDE void GetSessionState(LEPUSContext *ctx, int32_t view_id,
                              bool *is_already_enabled, bool *is_paused) {
  auto cb = ctx->rt->debugger_callbacks_.get_session_state;
  if (cb) {
    cb(ctx, view_id, is_already_enabled, is_paused);
  }
}

// for shared context qjs debugger: send protocol responses with view id
QJS_HIDE void SendProtocolResponseWithViewID(LEPUSContext *ctx,
                                             int32_t message_id,
                                             const char *response_message,
                                             int32_t view_id) {
  auto cb = ctx->rt->debugger_callbacks_.send_response_with_view_id;
  if (cb) {
    cb(ctx, message_id, response_message, view_id);
  }
}

// for shared context qjs debugger: send protocol notifications with view id
QJS_HIDE void SendProtocolNotificationWithViewID(LEPUSContext *ctx,
                                                 const char *response_message,
                                                 int32_t view_id) {
  auto cb = ctx->rt->debugger_callbacks_.send_ntfy_with_view_id;
  if (cb) {
    cb(ctx, response_message, view_id);
  }
}

void DoInspectorCheck(LEPUSContext *ctx) {
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  if (!info) return;
  // if need to pause on next statement, process and return
  if (info->pause_on_next_statement) {
    HandlePauseOnNextStatement(ctx);
    return;
  }

  bool keep_running = true;
  if (info->is_debugger_enabled) {
    keep_running = DebuggerNeedProcess(info, ctx);
  }

  if (keep_running && info->message_queue && GetProtocolMessages(ctx)) {
    ProcessProtocolMessages(ctx->debugger_info);
  }
}

// for shared context qjs debugger: send script parsed event with view id
void SendScriptParsedNotificationWithViewID(LEPUSContext *ctx,
                                            LEPUSScriptSource *script,
                                            int32_t view_id) {
  LEPUSValue script_parsed_params = GetMultiScriptParsedInfo(ctx, script);
  if (!LEPUS_IsUndefined(script_parsed_params)) {
    HandleScope func_scope(ctx, &script_parsed_params, HANDLE_TYPE_LEPUS_VALUE);
    SendNotification(ctx, "Debugger.scriptParsed", script_parsed_params,
                     view_id);
  }
}

// when compile a script success, send scriptparsed notification
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-scriptParsed
void SendScriptParsedNotification(LEPUSContext *ctx,
                                  LEPUSScriptSource *script) {
  LEPUSValue script_parsed_params = GetMultiScriptParsedInfo(ctx, script);
  if (!LEPUS_IsUndefined(script_parsed_params)) {
    HandleScope func_scope(ctx, &script_parsed_params, HANDLE_TYPE_LEPUS_VALUE);
    SendNotification(ctx, "Debugger.scriptParsed", script_parsed_params);
  }
}

// for shared context qjs debugger: send script fail to parse event with view id
void SendScriptFailToParseNotificationWithViewID(LEPUSContext *ctx,
                                                 LEPUSScriptSource *script,
                                                 int32_t view_id) {
  LEPUSValue script_failed_parse_param = GetMultiScriptParsedInfo(ctx, script);
  DebuggerFreeScript(ctx, script);
  if (!LEPUS_IsUndefined(script_failed_parse_param)) {
    HandleScope func_scope(ctx, &script_failed_parse_param,
                           HANDLE_TYPE_LEPUS_VALUE);
    SendNotification(ctx, "Debugger.scriptFailedToParse",
                     script_failed_parse_param, view_id);
  }
}

void SendScriptFailToParseNotification(LEPUSContext *ctx,
                                       LEPUSScriptSource *script) {
  LEPUSValue script_failed_parse_param = GetMultiScriptParsedInfo(ctx, script);
  DebuggerFreeScript(ctx, script);
  if (!LEPUS_IsUndefined(script_failed_parse_param)) {
    HandleScope func_scope(ctx, &script_failed_parse_param,
                           HANDLE_TYPE_LEPUS_VALUE);
    SendNotification(ctx, "Debugger.scriptFailedToParse",
                     script_failed_parse_param);
  }
}

// handle protocols using function map
void HandleProtocols(LEPUSContext *ctx, LEPUSValue message,
                     const char *method) {
  if (!method) return;
  struct DebuggerParams params = {ctx, message, 0};
  auto debugger_step_map = GetDebuggerStepMap();
  auto step_iter = debugger_step_map.find(method);
  if (step_iter != debugger_step_map.end()) {
    params.type = step_iter->second;
  }
  auto debugger_function_map = GetDebugFunctionMap();
  auto func_iter = debugger_function_map.find(method);
  if (func_iter != debugger_function_map.end()) {
    func_iter->second(&params);
  } else {
    LEPUSValue result = LEPUS_NewObject(ctx);
    HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
    if (!LEPUS_IsException(result)) {
      SendResponse(ctx, message, result);
    }
  }
}

// push msg to message queue, and process it
void PushAndProcessProtocolMessages(LEPUSDebuggerInfo *info, const char *msg) {
  struct qjs_queue *debugger_queue = GetDebuggerMessageQueue(info);
  if (debugger_queue) {
    PushBackQueue(debugger_queue, msg);
    ProcessProtocolMessages(info);
  }
}

static bool PauseOnNextStatement(LEPUSContext *ctx, const char *method,
                                 LEPUSValue message,
                                 LEPUSValue message_method) {
  bool res = strcmp(method, "Debugger.pauseOnNextStatement") == 0;
  auto *info = ctx->debugger_info;
  if (res && !info->pause_on_next_statement_reason) {
    info->pause_on_next_statement = true;
    LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");
    LEPUSValue reason = LEPUS_GetPropertyStr(ctx, params, "reason");
    info->pause_on_next_statement_reason =
        const_cast<char *>(LEPUS_ToCString(ctx, reason));
    if (!ctx->rt->gc_enable) {
      LEPUS_FreeValue(ctx, params);
      LEPUS_FreeValue(ctx, reason);
    }
  }
  if (!ctx->rt->gc_enable && res) {
    LEPUS_FreeCString(ctx, method);
    LEPUS_FreeValue(ctx, message_method);
  }
  return res;
}

enum ProcessMessageResult { MESSAGE_NULL, SUCCESS };

static ProcessMessageResult ProcessMessage(LEPUSContext *ctx,
                                           LEPUSStackFrame *sf, qjs_queue *mq,
                                           LEPUSValue message) {
  LEPUSValue message_method = LEPUS_GetPropertyStr(ctx, message, "method");
  const char *method = LEPUS_ToCString(ctx, message_method);
  // handle protocol messages
  if (!method) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, message_method);
    PopFrontQueue(mq);
    return MESSAGE_NULL;
  }
  HandleScope func_scope(ctx, reinterpret_cast<void *>(&method),
                         HANDLE_TYPE_CSTRING);
  bool pause_on_next_statement =
      PauseOnNextStatement(ctx, method, message, message_method);
  PopFrontQueue(mq);
  if (pause_on_next_statement) {
    return SUCCESS;
  }

  // handle protocol messages
  HandleProtocols(ctx, message, method);

  if (!ctx->rt->gc_enable) {
    LEPUS_FreeCString(ctx, method);
    LEPUS_FreeValue(ctx, message_method);
  }
  return SUCCESS;
}

#define process_messages(view_id)                                           \
  auto *mq = GetDebuggerMessageQueue(info);                                 \
  LEPUSContext *ctx = info->ctx;                                            \
  auto *sf = ctx->rt->current_stack_frame;                                  \
  LEPUSValue message = LEPUS_UNDEFINED;                                     \
  HandleScope func_scope(ctx, &message, HANDLE_TYPE_LEPUS_VALUE);           \
  while (!QueueIsEmpty(mq)) {                                               \
    char *message_str = GetFrontQueue(mq);                                  \
    if (message_str) {                                                      \
      message = LEPUS_ParseJSON(ctx, message_str, strlen(message_str), ""); \
      if (view_id != -1) {                                                  \
        LEPUS_SetPropertyStr(ctx, message, "view_id",                       \
                             LEPUS_NewInt32(ctx, view_id));                 \
      }                                                                     \
      auto process_result = ProcessMessage(ctx, sf, mq, message);           \
      if (process_result == MESSAGE_NULL) {                                 \
        continue;                                                           \
      }                                                                     \
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, message);               \
    }                                                                       \
    free(message_str);                                                      \
    message_str = NULL;                                                     \
  }

// for shared context qjs debugger: need to send this view_id to front end
// through sendResponse
void ProcessProtocolMessagesWithViewID(LEPUSDebuggerInfo *info,
                                       int32_t view_id) {
  // get protocol message from message queue
  process_messages(view_id);
}

/**
 * get a protocol from message queue, process it
 * read the protocol head and dispatch to different handler
 */
void ProcessProtocolMessages(LEPUSDebuggerInfo *info) {
  // get protocol message from message queue
  process_messages(-1);
}

/**
 * @brief given result, send response protocols
 * @param message use this message to get message id.
 * @param result response result
 */
void SendResponse(LEPUSContext *ctx, LEPUSValue message, LEPUSValue result) {
  HandleScope func_scope{ctx, &message, HANDLE_TYPE_LEPUS_VALUE};
  func_scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue id = LEPUS_GetPropertyStr(ctx, message, "id");
  int32_t message_id = 0;
  LEPUS_ToInt32(ctx, &message_id, id);
  auto *info = ctx->debugger_info;
  LEPUSValue props[] = {id, result};
  LEPUSObject *p =
      DebuggerCreateObjFromShape(info, info->debugger_obj.response,
                                 sizeof(props) / sizeof(LEPUSValue), props);
  func_scope.PushHandle(p, HANDLE_TYPE_DIR_HEAP_OBJ);
  LEPUSValue response = LEPUS_MKPTR(LEPUS_TAG_OBJECT, p);
  LEPUSValue js_response = LEPUS_ToJSON(ctx, response, 0);
  func_scope.PushHandle(&js_response, HANDLE_TYPE_LEPUS_VALUE);
  const char *response_message = LEPUS_ToCString(ctx, js_response);
  func_scope.PushHandle(reinterpret_cast<void *>(&response_message),
                        HANDLE_TYPE_CSTRING);
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, js_response);
    LEPUS_FreeValue(ctx, response);
  }
  LEPUSValue view_id_val = LEPUS_GetPropertyStr(ctx, message, "view_id");
  int32_t view_id = -1;
  if (!LEPUS_IsUndefined(view_id_val)) {
    LEPUS_ToInt32(ctx, &view_id, view_id_val);
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, view_id_val);
  }
  if (!response_message) {
    return;
  }
  if (view_id != -1) {
    SendProtocolResponseWithViewID(ctx, message_id, response_message, view_id);
  } else {
    SendProtocolResponse(ctx, message_id, response_message);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, response_message);
  return;
}

/**
 * @brief given result, send notification protocols
 * @param method nofitication method
 * @param params nofitication parameters
 */
void SendNotification(LEPUSContext *ctx, const char *method, LEPUSValue params,
                      int32_t view_id) {
  HandleScope func_scope{ctx, &params, HANDLE_TYPE_LEPUS_VALUE};
  auto *info = ctx->debugger_info;
  LEPUSValue str = LEPUS_NewString(ctx, method);
  func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue props[] = {str, params};
  LEPUSObject *p =
      DebuggerCreateObjFromShape(info, info->debugger_obj.notification,
                                 sizeof(props) / sizeof(LEPUSValue), props);
  func_scope.PushHandle(p, HANDLE_TYPE_DIR_HEAP_OBJ);
  LEPUSValue notification = LEPUS_MKPTR(LEPUS_TAG_OBJECT, p);
  LEPUSValue notification_json = LEPUS_ToJSON(ctx, notification, 0);
  func_scope.PushHandle(&notification_json, HANDLE_TYPE_LEPUS_VALUE);
  const char *ntf_msg = LEPUS_ToCString(ctx, notification_json);
  func_scope.PushHandle(reinterpret_cast<void *>(&ntf_msg),
                        HANDLE_TYPE_CSTRING);
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, notification);
    LEPUS_FreeValue(ctx, notification_json);
  }
  if (ntf_msg) {
    if (view_id == -1) {
      SendProtocolNotification(ctx, ntf_msg);
    } else {
      SendProtocolNotificationWithViewID(ctx, ntf_msg, view_id);
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, ntf_msg);
  }
  return;
}

bool CheckEnable(LEPUSContext *ctx, LEPUSValue message, ProtocolType protocol) {
  LEPUSValue view_id_val = LEPUS_GetPropertyStr(ctx, message, "view_id");
  int32_t view_id = -1;
  if (!LEPUS_IsUndefined(view_id_val)) {
    LEPUS_ToInt32(ctx, &view_id, view_id_val);
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, view_id_val);
  }

  bool ret = true;
  if (view_id != -1) {
    GetSessionEnableState(ctx, view_id, static_cast<int32_t>(protocol), &ret);
    return ret;
  }

  LEPUSDebuggerInfo *info = ctx->debugger_info;
  switch (protocol) {
    case DEBUGGER_ENABLE:
    case DEBUGGER_DISABLE:
      ret = info->is_debugger_enabled > 0;
      break;
    case RUNTIME_DISABLE:
    case RUNTIME_ENABLE:
      ret = info->is_runtime_enabled > 0;
      break;
    case PROFILER_ENABLE:
    case PROFILER_DISABLE:
      ret = info->is_profiling_enabled > 0;
      break;
    default:
      break;
  }
  return ret;
}
