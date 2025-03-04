// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#ifndef TESTING_QUICKJS_COMPILER_TEST_DEBUG_BASE_H_
#define TESTING_QUICKJS_COMPILER_TEST_DEBUG_BASE_H_
#include "inspector/debugger_inner.h"
#ifdef __cplusplus
extern "C" {
#endif
#include <stdint.h>
#include <string.h>

#include "inspector/debugger/debugger_queue.h"
#include "inspector/interface.h"
#include "quickjs/include/quickjs-libc.h"

#ifdef __cplusplus
}
#endif
#include <iostream>
#include <queue>
#include <string>
#include <unordered_map>
#include <vector>

#include "gtest/gtest.h"
#include "inspector/debugger/debugger_callframe.h"

namespace qjs_debug_test {
class QjsDebugQueue {
 public:
  static std::queue<std::string>& GetReceiveMessageQueue() {
    static std::queue<std::string> receive_message_queue_;
    return receive_message_queue_;
  }

  static std::queue<std::string>& GetSendMessageQueue() {
    static std::queue<std::string> send_message_queue_;
    return send_message_queue_;
  }

  static inline std::queue<std::string> runtime_receive_queue_;
};

class QjsEnableMap {
 public:
  static std::unordered_map<int32_t, bool>& GetDebuggerEnableMap() {
    static std::unordered_map<int32_t, bool> debugger_enable_map_;
    return debugger_enable_map_;
  }

  static std::unordered_map<int32_t, bool>& GetRuntimeEnableMap() {
    static std::unordered_map<int32_t, bool> runtime_enable_map_;
    return runtime_enable_map_;
  }
  static std::unordered_map<int32_t, bool>& GetCpuProfilerEnableMap() {
    static std::unordered_map<int32_t, bool> cpuprofiler_enable_map_;
    return cpuprofiler_enable_map_;
  }
};

void RunMessageLoopOnPauseCB1(LEPUSContext* ctx);

void RunMessageLoopOnPauseCBWithResume(LEPUSContext* ctx);

void PauseCBGetProperties(LEPUSContext* ctx);

void PauseCBEvaluate(LEPUSContext* ctx);

void PauseCBGetGlobalProperties(LEPUSContext* ctx);

void PauseCBGetInternalProperties(LEPUSContext* ctx);

void PauseCBGetInternalProperties2(LEPUSContext* ctx);

void PauseCBGetClosureProperties(LEPUSContext* ctx);

void QuitMessageLoopOnPauseCB(LEPUSContext* ctx);

void RunMessageLoopOnPauseCBStepOver(LEPUSContext* ctx);

uint8_t IsRuntimeDevtoolOnCB(LEPUSRuntime* rt);

void ConsoleStackTrace(LEPUSContext* ctx, LEPUSValue* ret);

void SendResponseCB(LEPUSContext* ctx, int32_t message_id, const char* message);

void SendNotificationCB(LEPUSContext* ctx, const char* message);

void InspectorCheckCB(LEPUSContext* ctx);

void DebuggerExceptionCB(LEPUSContext* ctx);

void ConsoleMessageCB(LEPUSContext* ctx, int tag, LEPUSValueConst* argv,
                      int argc);

void SendScriptParsedMessageCB(LEPUSContext* ctx, LEPUSScriptSource* script);

void SendConsoleMessageCB(LEPUSContext* ctx, LEPUSValue* console_msg);

void GetMessagesCB(LEPUSContext* ctx);

void SendScriptFailToParsedMessageCB(LEPUSContext* ctx,
                                     LEPUSScriptSource* script);

bool js_run(LEPUSContext* ctx, const char* filename, LEPUSValue& ret);

void SendResponseWithViewIDCB(LEPUSContext* ctx, int32_t message_id,
                              const char* message, int32_t view_id);

void SendNtfyCBWithViewID(LEPUSContext* ctx, const char* message,
                          int32_t view_id);

void ScriptParsedWithViewIDCB(LEPUSContext* ctx, LEPUSScriptSource* script,
                              int32_t view_id);

void ScriptFailToParseWithViewIDCB(LEPUSContext* ctx, LEPUSScriptSource* script,
                                   int32_t view_id);

void SetSessionEnableMapCB(LEPUSContext* ctx, int32_t view_id,
                           int32_t method_type);

void GetSessionStateCB(LEPUSContext* ctx, int32_t view_id,
                       bool* already_eanbled, bool* is_paused);

void SendConsoleMessageWithRIDCB(LEPUSContext* ctx, LEPUSValue* console_msg);

void GetSessionEnableStateCB(LEPUSContext* ctx, int32_t view_d, int32_t type,
                             bool* ret);

std::vector<void*> GetQJSCallbackFuncs();

void PrepareGetProperties(LEPUSRuntime* rt, int32_t bp_line);

void PushSetBreakpointMessages(int32_t bp_line);

void SendRuntimeNoficationCB(LEPUSContext*, const char*);
}  // namespace qjs_debug_test

#endif  // TESTING_QUICKJS_COMPILER_TEST_DEBUG_BASE_H_
