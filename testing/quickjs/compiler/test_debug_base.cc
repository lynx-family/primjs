// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "test_debug_base.h"

#include <unordered_map>

#include "gc/collector.h"
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

#undef QJSCallBackName
namespace qjs_debug_test {
#define QJSCallBackName(V)                \
  V(0, RunMessageLoopOnPauseCBWithResume) \
  V(1, QuitMessageLoopOnPauseCB)          \
  V(2, GetMessagesCB)                     \
  V(3, SendResponseCB)                    \
  V(4, SendNotificationCB)                \
  V(5, NULL)                              \
  V(6, DebuggerExceptionCB)               \
  V(7, InspectorCheckCB)                  \
  V(8, ConsoleMessageCB)                  \
  V(9, SendScriptParsedMessageCB)         \
  V(10, SendConsoleMessageCB)             \
  V(11, SendScriptFailToParsedMessageCB)  \
  V(12, NULL)                             \
  V(13, IsRuntimeDevtoolOnCB)             \
  V(14, SendResponseWithViewIDCB)         \
  V(15, SendNtfyCBWithViewID)             \
  V(16, ScriptParsedWithViewIDCB)         \
  V(17, ScriptFailToParseWithViewIDCB)    \
  V(18, SetSessionEnableMapCB)            \
  V(19, GetSessionStateCB)                \
  V(20, SendConsoleMessageWithRIDCB)      \
  V(21, GetSessionEnableStateCB)          \
  V(22, NULL)                             \
  V(23, OnConsoleMessageCB)

void RunMessageLoopOnPauseCB1(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string msg1 =
      "{\"id\":56,\"method\":\"Debugger.evaluateOnCallFrame\",\"params\":{"
      "\"callFrameId\":\"0\",\"expression\":\"a\",\"objectGroup\":\"popover\","
      "\"includeCommandLineAPI\":false,\"silent\":true,\"returnByValue\":false,"
      "\"generatePreview\":false}}";
  std::string msg2 =
      "{\"id\":48,\"method\":\"Debugger.resume\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, msg1.c_str());
  ProcessPausedMessages(ctx, msg2.c_str());
}

void RunMessageLoopOnPauseCBWithResume(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string resume_message =
      "{\"id\":48,\"method\":\"Debugger.resume\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, resume_message.c_str());
}

void PauseCBGetGlobalProperties(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string getproperties_message1 =
      "{\"id\":48,\"method\":\"Runtime.getProperties\",\"params\":{"
      "\"objectId\":\"scope:0\", \"ownProperties\": true, "
      "\"accessorPropertiesOnly\":false, \"generatePreview\": true}}";
  std::string resume_message =
      "{\"id\":49,\"method\":\"Debugger.resume\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, getproperties_message1.c_str());
  ProcessPausedMessages(ctx, resume_message.c_str());
}

void PauseCBGetProperties(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string getproperties_message1 =
      "{\"id\":48,\"method\":\"Runtime.getProperties\",\"params\":{"
      "\"objectId\":\"scope:1\", \"ownProperties\": true, "
      "\"accessorPropertiesOnly\":false, \"generatePreview\": true}}";
  std::string resume_message =
      "{\"id\":49,\"method\":\"Debugger.resume\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, getproperties_message1.c_str());
  ProcessPausedMessages(ctx, resume_message.c_str());
}

void PauseCBEvaluate(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string evaluate_msg1 =
      "{\"id\":48,\"method\":\"Runtime.evaluateOnCallframe\",\"params\":{"
      "\"expression\":\"c\", \"includeCommandLineAPI\": true, \"callFrameId\": "
      "\"0\","
      "\"throwOnSideEffect\":true}}";
  std::string resume_message =
      "{\"id\":49,\"method\":\"Debugger.resume\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, evaluate_msg1.c_str());
  ProcessPausedMessages(ctx, resume_message.c_str());
}

static void PauseInternalProperties(LEPUSContext* ctx) {
  std::string local_string = QjsDebugQueue::GetReceiveMessageQueue().front();
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  LEPUSValue local_string_val =
      LEPUS_ParseJSON(ctx, local_string.c_str(), local_string.length(), "");
  HandleScope func_scope(ctx, &local_string_val, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue result = LEPUS_GetPropertyStr(ctx, local_string_val, "result");
  LEPUSValue array_result = LEPUS_GetPropertyStr(ctx, result, "result");
  LEPUSValue array1 = LEPUS_GetPropertyUint32(ctx, array_result, 1);
  LEPUSValue array1_val = LEPUS_GetPropertyStr(ctx, array1, "value");
  LEPUSValue obj_id_val = LEPUS_GetPropertyStr(ctx, array1_val, "objectId");
  const char* obj_id = LEPUS_ToCString(ctx, obj_id_val);
  std::string getproperties_message2_1 =
      "{\"id\":49,\"method\":\"Runtime.getProperties\",\"params\":{"
      "\"objectId\":\"";
  std::string getproperties_message2_2 = std::string(obj_id);
  std::string getproperties_message2_3 =
      "\",\"ownProperties\": true, "
      "\"accessorPropertiesOnly\":false, \"generatePreview\": true}}";

  std::string getproperties_message2 = getproperties_message2_1 +
                                       getproperties_message2_2 +
                                       getproperties_message2_3;
  ProcessPausedMessages(ctx, getproperties_message2.c_str());

  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, local_string_val);
    LEPUS_FreeValue(ctx, result);
    LEPUS_FreeValue(ctx, array_result);
    LEPUS_FreeValue(ctx, array1);
    LEPUS_FreeValue(ctx, array1_val);
    LEPUS_FreeValue(ctx, obj_id_val);
    LEPUS_FreeCString(ctx, obj_id);
  }
  std::string resume_message =
      "{\"id\":50,\"method\":\"Debugger.resume\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, resume_message.c_str());
}

void PauseCBGetInternalProperties2(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string getproperties_message1 =
      "{\"id\":48,\"method\":\"Runtime.getProperties\",\"params\":{"
      "\"objectId\":\"scope:1\", \"ownProperties\": true, "
      "\"accessorPropertiesOnly\":false, \"generatePreview\": true}}";
  ProcessPausedMessages(ctx, getproperties_message1.c_str());

  for (size_t i = 0; i < 8; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  PauseInternalProperties(ctx);
}

void PauseCBGetInternalProperties(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string getproperties_message1 =
      "{\"id\":48,\"method\":\"Runtime.getProperties\",\"params\":{"
      "\"objectId\":\"scope:1\", \"ownProperties\": true, "
      "\"accessorPropertiesOnly\":false, \"generatePreview\": true}}";
  ProcessPausedMessages(ctx, getproperties_message1.c_str());

  for (size_t i = 0; i < 10; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  PauseInternalProperties(ctx);
}

void PauseCBGetClosureProperties(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string getproperties_message1 =
      "{\"id\":48,\"method\":\"Runtime.getProperties\",\"params\":{"
      "\"objectId\":\"scope:2\", \"ownProperties\": true, "
      "\"accessorPropertiesOnly\":false, \"generatePreview\": true}}";
  std::string resume_message =
      "{\"id\":49,\"method\":\"Debugger.resume\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, getproperties_message1.c_str());
  ProcessPausedMessages(ctx, resume_message.c_str());
}
void QuitMessageLoopOnPauseCB(LEPUSContext* ctx) {
  std::cout << "quit pause" << std::endl;
}

void RunMessageLoopOnPauseCBStepOver(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string step_over =
      "{\"id\":48,\"method\":\"Debugger.stepOver\",\"params\":{\"skipList\":[]}"
      "}";
  ProcessPausedMessages(ctx, step_over.c_str());
}

uint8_t IsRuntimeDevtoolOnCB(LEPUSRuntime* rt) { return 1; }

void ConsoleStackTrace(LEPUSContext* ctx, LEPUSValue* ret) {
  LEPUSValue callframes =
      BuildConsoleBacktrace(ctx, ctx->debugger_info->debugger_current_pc);
  HandleScope func_scope(ctx, &callframes, HANDLE_TYPE_LEPUS_VALUE);
  DebuggerSetPropertyStr(ctx, *ret, "callFrames", callframes);
}

void SendResponseCB(LEPUSContext* ctx, int32_t message_id,
                    const char* message) {
  std::cout << "response message: " << message << std::endl;
  QjsDebugQueue::GetReceiveMessageQueue().push(message);
}

static bool IsRuntimeMethod(LEPUSContext* ctx, const std::string& src) {
  auto json = LEPUS_ParseJSON(ctx, src.c_str(), src.size(), "");
  bool ret = false;
  if (LEPUS_IsObject(json)) {
    auto method = LEPUS_GetPropertyStr(ctx, json, "method");
    if (LEPUS_IsString(method)) {
      auto* method_str = LEPUS_ToCString(ctx, method);
      std::string str(method_str);
      if (!ctx->gc_enable) LEPUS_FreeCString(ctx, method_str);
      ret = (str.compare(0, 8, "Runtime.") == 0);
    }
    if (!ctx->gc_enable) LEPUS_FreeValue(ctx, method);
  }
  if (!ctx->gc_enable) LEPUS_FreeValue(ctx, json);
  return ret;
}

void SendNotificationCB(LEPUSContext* ctx, const char* message) {
  QjsDebugQueue::GetReceiveMessageQueue().push(message);
  if (IsRuntimeMethod(ctx, message)) {
    QjsDebugQueue::runtime_receive_queue_.push(message);
  }
  std::cout << "notification message: " << message << std::endl;
}

void InspectorCheckCB(LEPUSContext* ctx) {
  DoInspectorCheck(ctx);
  return;
}

void DebuggerExceptionCB(LEPUSContext* ctx) { HandleDebuggerException(ctx); }

void ConsoleMessageCB(LEPUSContext* ctx, int tag, LEPUSValueConst* argv,
                      int argc) {
  int i;
  const char* str;

  for (i = 0; i < argc; i++) {
    if (i != 0) putchar(' ');
    str = LEPUS_ToCString(ctx, argv[i]);
    if (!str) return;
    fputs(str, stdout);
    if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, str);
  }
  putchar('\n');
}

void SendScriptParsedMessageCB(LEPUSContext* ctx, LEPUSScriptSource* script) {
  SendScriptParsedNotification(ctx, script);
}

void SendConsoleMessageCB(LEPUSContext* ctx, LEPUSValue* console_msg) {
  SendConsoleAPICalledNotification(ctx, console_msg);
}

void GetMessagesCB(LEPUSContext* ctx) {
  LEPUSDebuggerInfo* info = ctx->debugger_info;
  if (info) {
    while (!QjsDebugQueue::GetSendMessageQueue().empty()) {
      std::string m = QjsDebugQueue::GetSendMessageQueue().front();
      if (m.length()) {
        PushBackQueue(GetDebuggerMessageQueue(info), m.c_str());
      }
      QjsDebugQueue::GetSendMessageQueue().pop();
      ProcessProtocolMessages(info);
    }
  }
}

void SendScriptFailToParsedMessageCB(LEPUSContext* ctx,
                                     LEPUSScriptSource* script) {
  SendScriptFailToParseNotification(ctx, script);
}

bool js_run(LEPUSContext* ctx, const char* filename, LEPUSValue& ret) {
  uint8_t* buf;
  int eval_flags;
  size_t buf_len;
  buf = lepus_load_file(ctx, &buf_len, filename);
  if (!buf) {
    ret = LEPUS_UNDEFINED;
    return false;
  }
  // const char* buf = "function test() {\n let a = 1;
  // console.log('haha');\n}\n\n test();\n";
  eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  ret = LEPUS_Eval(ctx, (const char*)buf, buf_len, filename, eval_flags);
  free(buf);
  return true;
}

void SendResponseWithViewIDCB(LEPUSContext* ctx, int32_t message_id,
                              const char* message, int32_t view_id) {
  std::string view_id_str = std::to_string(view_id);
  QjsDebugQueue::GetReceiveMessageQueue().push(message);
  QjsDebugQueue::GetReceiveMessageQueue().push("view id: " + view_id_str);
  std::cout << "response message: " << message
            << " with view id: " << view_id_str << std::endl;
}

void SendNtfyCBWithViewID(LEPUSContext* ctx, const char* message,
                          int32_t view_id) {
  std::string view_id_str = std::to_string(view_id);
  QjsDebugQueue::GetReceiveMessageQueue().push(message);
  QjsDebugQueue::GetReceiveMessageQueue().push("view id: " + view_id_str);
  std::cout << "notification message: " << message
            << " with view id: " << view_id_str << std::endl;
}

void ScriptParsedWithViewIDCB(LEPUSContext* ctx, LEPUSScriptSource* script,
                              int32_t view_id) {
  SendScriptParsedNotificationWithViewID(ctx, script, view_id);
}

void ScriptFailToParseWithViewIDCB(LEPUSContext* ctx, LEPUSScriptSource* script,
                                   int32_t view_id) {
  SendScriptFailToParseNotificationWithViewID(ctx, script, view_id);
}

void SetSessionEnableMapCB(LEPUSContext* ctx, int32_t view_id,
                           int32_t method_type) {
  if (view_id != -1) {
    switch (method_type) {
      case 0: {
        // Debugger.enable
        QjsEnableMap::GetDebuggerEnableMap()[view_id] = true;
        break;
      }
      case 1: {
        // Debugger.disable
        QjsEnableMap::GetDebuggerEnableMap()[view_id] = false;
        break;
      }
      case 2: {
        // Runtime.enable
        QjsEnableMap::GetRuntimeEnableMap()[view_id] = true;
        break;
      }
      case 3: {
        // Runtime.disable
        QjsEnableMap::GetRuntimeEnableMap()[view_id] = false;
        break;
      }
      case 4: {
        // Profiler.enable
        QjsEnableMap::GetCpuProfilerEnableMap()[view_id] = true;
        break;
      }
      case 5: {
        // Profiler.disable
        QjsEnableMap::GetCpuProfilerEnableMap()[view_id] = false;
        break;
      }
      default: {
        break;
      }
    }
  }
}

void GetSessionStateCB(LEPUSContext* ctx, int32_t view_id,
                       bool* already_eanbled, bool* is_paused) {}

void GetSessionEnableStateCB(LEPUSContext* ctx, int32_t view_id, int32_t type,
                             bool* ret) {
  if (view_id == -1) {
    *ret = true;
  } else {
    switch (type) {
      case 0:
      case 1: {
        // Debugger
        *ret = QjsEnableMap::GetDebuggerEnableMap()[view_id];
        break;
      }
      case 2:
      case 3: {
        // Runtime
        *ret = QjsEnableMap::GetRuntimeEnableMap()[view_id];
        break;
      }
      case 4:
      case 5: {
        *ret = QjsEnableMap::GetCpuProfilerEnableMap()[view_id];
        break;
      }
    }
  }
}

void SendConsoleMessageWithRIDCB(LEPUSContext* ctx, LEPUSValue* console_msg) {
  SendConsoleAPICalledNotificationWithRID(ctx, console_msg);
}

static void OnConsoleMessageCB(LEPUSContext* ctx, LEPUSValue console_msg,
                               int32_t runtime_id) {
  auto* json_str = ValueToJsonString(ctx, console_msg);
  QjsDebugQueue::GetReceiveMessageQueue().push(json_str);
  QjsDebugQueue::GetReceiveMessageQueue().push(std::to_string(runtime_id));
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, json_str);
  return;
}

std::vector<void*> GetQJSCallbackFuncs() {
  std::vector<void*> funcs;
#define Callback(index, callback_name) reinterpret_cast<void*>(callback_name),
  funcs = {QJSCallBackName(Callback)};
#undef CallbackName
  return funcs;
}

void PushSetBreakpointMessages(int32_t bp_line) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Debugger.setBreakpointsActive\",\"params\":{"
      "\"active\":true}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":3,\"method\":\"Debugger.setBreakpointByUrl\",\"params\":{"
      "\"lineNumber\":" +
      std::to_string(bp_line) +
      ", \"url\":\"test_get_properties.js\",\"columnNumber\":0,"
      "\"condition\":\"\"}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
}

void PrepareGetProperties(LEPUSRuntime* rt, int32_t bp_line) {
  PushSetBreakpointMessages(bp_line);
  void* funcs[14] = {reinterpret_cast<void*>(PauseCBGetProperties),
                     reinterpret_cast<void*>(QuitMessageLoopOnPauseCB),
                     reinterpret_cast<void*>(GetMessagesCB),
                     reinterpret_cast<void*>(SendResponseCB),
                     reinterpret_cast<void*>(SendNotificationCB),
                     nullptr,
                     reinterpret_cast<void*>(DebuggerExceptionCB),
                     reinterpret_cast<void*>(InspectorCheckCB),
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     reinterpret_cast<void*>(SendScriptParsedMessageCB),
                     reinterpret_cast<void*>(SendConsoleMessageCB),
                     reinterpret_cast<void*>(SendScriptFailToParsedMessageCB),
                     nullptr,
                     reinterpret_cast<void*>(IsRuntimeDevtoolOnCB)};
  RegisterQJSDebuggerCallbacks(rt, reinterpret_cast<void**>(funcs), 14);
}

void SendRuntimeNoficationCB(LEPUSContext* ctx, const char* message) {
  QjsDebugQueue::runtime_receive_queue_.push(message);
  return;
}
}  // namespace qjs_debug_test
