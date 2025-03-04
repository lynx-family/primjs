// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <queue>

#include "inspector/debugger/debugger_properties.h"
#include "inspector/debugger_inner.h"
#include "test_debug_base.h"

namespace qjs_debug_test {
void RunMessageLoopOnPauseCBWithStep(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string set_message =
      R"({"id":10,"method":"Debugger.setVariableValue",)"
      R"("params":{"scopeNumber":0,"variableName":"a","newValue":{"value":2},"callFrameId":"0"}})";
  ProcessPausedMessages(ctx, set_message.c_str());
  std::string resume_message =
      "{\"id\":48,\"method\":\"Debugger.stepInto\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, resume_message.c_str());
  resume_message =
      "{\"id\":48,\"method\":\"Debugger.stepOver\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, resume_message.c_str());
  resume_message =
      "{\"id\":48,\"method\":\"Debugger.stepOut\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, resume_message.c_str());
}
class QjsDebugStep : public ::testing::Test {
 protected:
  QjsDebugStep() = default;
  ~QjsDebugStep() override = default;

  void SetUp() override {
    QjsDebugQueue::GetReceiveMessageQueue() = std::queue<std::string>();
    QjsDebugQueue::GetSendMessageQueue() = std::queue<std::string>();
    rt_ = LEPUS_NewRuntime();
    void* funcs[14] = {reinterpret_cast<void*>(RunMessageLoopOnPauseCBWithStep),
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
    ctx_ = LEPUS_NewContext(rt_);
    PrepareQJSDebuggerDefer(ctx_, reinterpret_cast<void**>(funcs), 14);
    QJSDebuggerInitialize(ctx_);
  }

  void TearDown() override {
    auto info = GetDebuggerInfo(ctx_);
    auto* mq = GetDebuggerMessageQueue(info);
    while (!QueueIsEmpty(mq)) {
      char* message_str = GetFrontQueue(mq);
      free(message_str);
      message_str = NULL;
    }
    QJSDebuggerFree(ctx_);
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  LEPUSContext* ctx_;
  LEPUSRuntime* rt_;
};

TEST_F(QjsDebugStep, QJSDebugTestStep) {
  const char* buf = R"(let res=0;
try{
    let a=1;
             //TODO:delete this empty line, the test **should** also works too.
    if(a==1)throw "pause failed";
  }catch(e)
  {
    res=1;
  }
  console.log("res=",res);)";
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":0,"method":"Debugger.enable","params":{"maxScriptsCacheSize":100000000}})");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.setBreakpointsActive\",\"params\":{"
      "\"active\":true}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":2,"method":"Debugger.setBreakpointByUrl","params":{"lineNumber":3,"url":"test_pause.js","columnNumber":0,"condition":""}})");
  QjsDebugQueue::GetSendMessageQueue().push(R"(
    {"id":3,"method":"Runtime.enable","param":{}}
  )");

  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_pause.js", LEPUS_EVAL_TYPE_GLOBAL);
  std::string message;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    message = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::string expect_message =
      R"([{"value":"res=","type":"string"},{"description":"0","value":0,"type":"number"}])";

  ASSERT_TRUE(message.find(expect_message) != std::string::npos);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

}  // namespace qjs_debug_test
