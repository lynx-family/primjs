// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "test_debug_base.h"

namespace qjs_debug_test {
class QjsSharedDebugFlag : public ::testing::Test {
 protected:
  QjsSharedDebugFlag() = default;
  ~QjsSharedDebugFlag() override = default;

  void SetUp() override {
    QjsDebugQueue::GetReceiveMessageQueue() = std::queue<std::string>();
    QjsDebugQueue::GetSendMessageQueue() = std::queue<std::string>();
    rt_ = LEPUS_NewRuntime();
    auto funcs = GetQJSCallbackFuncs();
    ctx_ = LEPUS_NewContext(rt_);
    PrepareQJSDebuggerForSharedContext(ctx_, funcs.data(), funcs.size(), true);
    PrepareQJSDebuggerForSharedContext(ctx_, funcs.data(), funcs.size(), true);
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

TEST_F(QjsSharedDebugFlag, TESTParseScriptFlag) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");

  int eval_flags;
  const char* buf =
      "function test() {\n lynxConsole.log('lynx_runtimeId:1, hahaha'); "
      "lynxConsole.log('lynx_runtimeId:2,hehehe');\n}\n test();\n";
  eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_lynxConsole.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  DeleteConsoleMessageWithRID(ctx_, 1);
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Runtime.enable\",\"params\":{}}");
  buf = "function test() {} \n test();";
  ret = LEPUS_Eval(ctx_, buf, strlen(buf), "trigger_debugger.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}
}  // namespace qjs_debug_test
