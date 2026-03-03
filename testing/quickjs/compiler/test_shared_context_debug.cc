// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "gc/trace-gc.h"
#include "inspector/protocols.h"
#include "test_debug_base.h"

namespace qjs_debug_test {
class QjsSharedDebugMethods : public ::testing::Test {
 protected:
  QjsSharedDebugMethods() = default;
  ~QjsSharedDebugMethods() override = default;

  void SetUp() override {
    QjsDebugQueue::GetReceiveMessageQueue() = std::queue<std::string>();
    QjsDebugQueue::GetSendMessageQueue() = std::queue<std::string>();
    rt_ = LEPUS_NewRuntime();
    auto funcs = GetQJSCallbackFuncs();
    RegisterQJSDebuggerCallbacks(rt_, funcs.data(), funcs.size());
    ctx_ = LEPUS_NewContext(rt_);
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

static void CheckConsoleMessageGID(LEPUSContext* ctx, std::string true_val) {
  std::string console_message1_str =
      QjsDebugQueue::GetReceiveMessageQueue().front();
  LEPUSValue console_message1 = LEPUS_ParseJSON(
      ctx, console_message1_str.c_str(), console_message1_str.length(), "");
  HandleScope func_scope(ctx, &console_message1, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, console_message1, "params");
  LEPUSValue gid_val = LEPUS_GetPropertyStr(ctx, params, "groupId");
  const char* gid_str = LEPUS_ToCString(ctx, gid_val);
  std::string gid_string(gid_str);
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, gid_str);
  std::cout << "output gid_val: " << gid_str << std::endl;
  std::cout << "true gid_val: " << true_val << std::endl;
  ASSERT_TRUE(gid_string == true_val);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, gid_val);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, console_message1);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params);
  QjsDebugQueue::GetReceiveMessageQueue().pop();
}

static void CheckConsoleMessageRID(LEPUSContext* ctx, int32_t true_val) {
  std::string console_message1_str =
      QjsDebugQueue::GetReceiveMessageQueue().front();
  LEPUSValue console_message1 = LEPUS_ParseJSON(
      ctx, console_message1_str.c_str(), console_message1_str.length(), "");
  HandleScope func_scope(ctx, &console_message1, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, console_message1, "params");
  LEPUSValue rid_val = LEPUS_GetPropertyStr(ctx, params, "runtimeId");
  int32_t rid = -1;
  LEPUS_ToInt32(ctx, &rid, rid_val);
  std::cout << "output rid_val: " << rid << std::endl;
  std::cout << "true rid_val: " << true_val << std::endl;
  ASSERT_TRUE(rid == true_val);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, rid_val);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, console_message1);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params);
  QjsDebugQueue::GetReceiveMessageQueue().pop();
}

TEST_F(QjsSharedDebugMethods, TESTScriptViewID) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");

  int eval_flags;
  eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  const char* buf = "function test() {} \ntest();\n";
  LEPUSValue ret = LEPUS_Eval(ctx_, buf, strlen(buf), "trigger.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  buf = "function test() {\n let a = 1;\n}\n test();\n";
  ret = LEPUS_Eval(ctx_, buf, strlen(buf), "file://view1/app-service.js",
                   eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  for (size_t i = 0; i < 4; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  std::string view_id_str = QjsDebugQueue::GetReceiveMessageQueue().front();
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  ASSERT_TRUE(view_id_str == "view id: 1");
}

TEST_F(QjsSharedDebugMethods, TESTDeleteConsoleMessageWithLepusID) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Runtime.enable\",\"params\":{}}");

  int eval_flags;
  const char* buf =
      "function test() {\n lynxConsole.log('lepusRuntimeId:1', 'hahaha'); "
      "lynxConsole.log('lepusRuntimeId:2', 'hehehe');\n}\n test();\n";
  eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_lynxConsole1.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  for (size_t i = 0; i < 5; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
}

TEST_F(QjsSharedDebugMethods, QJSDebugTestCheckEnable) {
  const char* filename = TEST_CASE_DIR "qjs_debug_test/qjs_debug_test1.js";
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}, \"view_id\":2}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}, \"view_id\": 2}");
  LEPUSValue val;
  bool res = js_run(ctx_, filename, val);
  if (!res) {
    ASSERT_TRUE(false);
  }
  LEPUSValue message = LEPUS_NewObject(ctx_);
  HandleScope func_scope(ctx_, &message, HANDLE_TYPE_LEPUS_VALUE);
  DebuggerSetPropertyStr(ctx_, message, "view_id", LEPUS_NewInt32(ctx_, 2));
  res = CheckEnable(ctx_, message, DEBUGGER_ENABLE);
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Debugger.disable\",\"params\":{}, "
      "\"view_id\":2}");
  const char* buf = "function test() {}; test();\n";
  LEPUSValue ret = LEPUS_Eval(ctx_, buf, strlen(buf), "trigger_debugger.js",
                              LEPUS_EVAL_TYPE_GLOBAL);
  res = CheckEnable(ctx_, message, DEBUGGER_ENABLE);
  if (!ctx_->rt->gc_enable) {
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, message);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  }
  ASSERT_TRUE(res == false);
}
}  // namespace qjs_debug_test
