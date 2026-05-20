// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "gc/trace-gc.h"
#include "inspector/protocols.h"
#include "quickjs/include/quickjs-inner.h"
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

// Test: After DeleteScriptByURL, bytecodes remain in bytecode_list with null
// script pointers, and subsequent breakpoint operations do not crash (UAF fix).
TEST_F(QjsSharedDebugMethods, TESTBreakpointAfterScriptDeletion) {
  // Step 1: Enable debugger
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");

  // Step 2: Eval a script to create bytecodes linked to a script source
  int eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  const char* buf = "function foo() {\n  let x = 1;\n  return x;\n}\nfoo();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "script_to_delete.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Drain debugger enable response and scriptParsed notifications
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Step 3: Verify bytecode_list is not empty and has script pointers
  auto* info = GetDebuggerInfo(ctx_);
  ASSERT_TRUE(info != nullptr);
  bool found_script_before = false;
  struct list_head* el;
  list_for_each(el, &info->bytecode_list) {
    LEPUSFunctionBytecode* b = list_entry(el, LEPUSFunctionBytecode, link);
    if (b->script != nullptr) {
      found_script_before = true;
      break;
    }
  }
  ASSERT_TRUE(found_script_before);

  // Step 4: Delete the script by URL — this should nullify b->script but keep
  // bytecodes in the list
  DeleteScriptByURL(ctx_, "script_to_delete.js");

  // Step 5: Verify bytecodes with that script now have null script pointers
  // but are still in the bytecode_list
  bool has_null_script = false;
  int bytecode_count = 0;
  list_for_each(el, &info->bytecode_list) {
    LEPUSFunctionBytecode* b = list_entry(el, LEPUSFunctionBytecode, link);
    bytecode_count++;
    if (b->script == nullptr) {
      has_null_script = true;
    }
  }
  ASSERT_TRUE(bytecode_count > 0);
  ASSERT_TRUE(has_null_script);

  // Step 6: Eval a new script and set a breakpoint — this exercises
  // NotInCurrentFunc iterating over bytecodes with null script (UAF scenario)
  const char* buf2 = "function bar() {\n  let y = 2;\n  return y;\n}\nbar();\n";
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.setBreakpointByUrl\",\"params\":{"
      "\"lineNumber\":2,\"url\":\"new_script.js\","
      "\"columnNumber\":0,\"condition\":\"\"}}");
  ret = LEPUS_Eval(ctx_, buf2, strlen(buf2), "new_script.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Step 7: Verify no crash occurred and we got a valid response
  bool found_breakpoint_response = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    if (msg.find("\"id\":1") != std::string::npos &&
        msg.find("breakpointId") != std::string::npos) {
      found_breakpoint_response = true;
    }
  }
  ASSERT_TRUE(found_breakpoint_response);

  // Cleanup: disable debugger
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Debugger.disable\",\"params\":{}}");
  const char* buf3 = "function trigger() {}; trigger();\n";
  LEPUSValue ret3 =
      LEPUS_Eval(ctx_, buf3, strlen(buf3), "trigger_debugger.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret3);
}

// Test: After DeleteScriptByURL, calling Debugger.getPossibleBreakpoints should
// safely skip bytecodes with null script pointers and return valid locations
// only for the target script.
TEST_F(QjsSharedDebugMethods, TESTGetPossibleBreakpointsAfterScriptDeletion) {
  // Step 1: Enable debugger
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");

  // Step 2: Eval a script that will be deleted later
  int eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  const char* buf = "function foo() {\n  let x = 1;\n  return x;\n}\nfoo();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "script_to_delete2.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Drain all pending messages
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Step 3: Delete the script — nullifies b->script for associated bytecodes
  DeleteScriptByURL(ctx_, "script_to_delete2.js");

  // Step 4: Eval a new script (will get a new script_id)
  const char* buf2 = "function bar() {\n  let y = 2;\n  return y;\n}\nbar();\n";
  ret = LEPUS_Eval(ctx_, buf2, strlen(buf2), "new_script2.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Find the script_id of the new script from scriptParsed notification
  std::string new_script_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    if (msg.find("Debugger.scriptParsed") != std::string::npos &&
        msg.find("new_script2.js") != std::string::npos) {
      // Extract scriptId from the message
      LEPUSValue parsed = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
      HandleScope func_scope(ctx_, &parsed, HANDLE_TYPE_LEPUS_VALUE);
      LEPUSValue params = LEPUS_GetPropertyStr(ctx_, parsed, "params");
      LEPUSValue sid = LEPUS_GetPropertyStr(ctx_, params, "scriptId");
      const char* sid_str = LEPUS_ToCString(ctx_, sid);
      new_script_id = sid_str;
      if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, sid_str);
      if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, sid);
      if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, params);
      if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, parsed);
      break;
    }
  }
  ASSERT_FALSE(new_script_id.empty());

  // Drain remaining messages
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Step 5: Call getPossibleBreakpoints on the new script — this iterates
  // over all bytecodes including those with null script (from deleted script)
  std::string get_bp_msg =
      "{\"id\":2,\"method\":\"Debugger.getPossibleBreakpoints\",\"params\":{"
      "\"start\":{\"scriptId\":\"" +
      new_script_id +
      "\",\"lineNumber\":0,\"columnNumber\":0},"
      "\"end\":{\"scriptId\":\"" +
      new_script_id + "\",\"lineNumber\":5,\"columnNumber\":0}}}";
  QjsDebugQueue::GetSendMessageQueue().push(get_bp_msg);

  // Trigger message processing
  const char* buf3 = "function trigger() {}; trigger();\n";
  LEPUSValue ret3 =
      LEPUS_Eval(ctx_, buf3, strlen(buf3), "trigger_bp.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret3);

  // Step 6: Verify we got a valid response with locations array (no crash)
  bool found_response = false;
  bool has_locations = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    if (msg.find("\"id\":2") != std::string::npos &&
        msg.find("locations") != std::string::npos) {
      found_response = true;
      // Verify locations are for the correct script
      has_locations = msg.find("\"scriptId\":\"" + new_script_id + "\"") !=
                      std::string::npos;
    }
  }
  ASSERT_TRUE(found_response);
  ASSERT_TRUE(has_locations);

  // Cleanup: disable debugger
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Debugger.disable\",\"params\":{}}");
  const char* buf4 = "function trigger2() {}; trigger2();\n";
  LEPUSValue ret4 =
      LEPUS_Eval(ctx_, buf4, strlen(buf4), "trigger_debugger.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret4);
}

}  // namespace qjs_debug_test
