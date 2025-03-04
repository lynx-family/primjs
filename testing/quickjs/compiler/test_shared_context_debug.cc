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

static void CheckConsoleMessageLepusID(LEPUSContext* ctx, int32_t true_val) {
  std::string console_message1_str =
      QjsDebugQueue::GetReceiveMessageQueue().front();
  LEPUSValue console_message1 = LEPUS_ParseJSON(
      ctx, console_message1_str.c_str(), console_message1_str.length(), "");
  HandleScope func_scope(ctx, &console_message1, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, console_message1, "params");
  LEPUSValue js_id_val = LEPUS_GetPropertyStr(ctx, params, "runtimeId");
  LEPUSValue is_lepus = LEPUS_GetPropertyStr(ctx, params, "consoleTag");
  int32_t js_id = -1;
  LEPUS_ToInt32(ctx, &js_id, js_id_val);
  std::cout << "output js_id_val: " << js_id << std::endl;
  std::cout << "true js_id_val: " << true_val << std::endl;
  const char* js_flag = LEPUS_ToCString(ctx, is_lepus);
  std::string js_flag_str = std::string(js_flag);
  ASSERT_TRUE(js_flag_str == "lepus");
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, js_flag);
  ASSERT_TRUE(js_id == true_val);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, js_id_val);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, is_lepus);
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

TEST_F(QjsSharedDebugMethods, TESTDeleteConsoleMessageWithRID) {
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
      "function test() {\n lynxConsole.log('runtimeId:1', 'hahaha'); "
      "lynxConsole.log('runtimeId:2','hehehe');\n}\n test();\n";
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

  for (size_t i = 0; i < 5; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  CheckConsoleMessageRID(ctx_, 1);
  CheckConsoleMessageRID(ctx_, 2);
  for (size_t i = 0; i < 2; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  CheckConsoleMessageRID(ctx_, 2);
}

TEST_F(QjsSharedDebugMethods, TESTDeleteConsoleMessageWithGID) {
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
      "function test() {\n lynxConsole.log('groupId:1', 'hahaha'); "
      "lynxConsole.log('groupId:2', 'hehehe');\n}\n test();\n";
  eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_lynxConsole1.js", eval_flags);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  for (size_t i = 0; i < 5; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  CheckConsoleMessageGID(ctx_, "1");
  CheckConsoleMessageGID(ctx_, "2");
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
  CheckConsoleMessageLepusID(ctx_, 1);
  CheckConsoleMessageLepusID(ctx_, 2);
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

TEST_F(QjsSharedDebugMethods, QJSDebugTestOnConsoleMessage) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Runtime.enable\",\"params\":{}}");
  int eval_flags;

  std::string src = R"(
    let array = [0];
    let obj = {
       prop: array
    };
    function test() {
      lynxConsole.log('lepusRuntimeId:1', obj);
      lynxConsole.log('lepusRuntimeId:2', obj);
    }
    test();
  )";
  eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  LEPUSValue ret = LEPUS_Eval(ctx_, src.c_str(), src.length(),
                              "test_lynxConsole1.js", eval_flags);
  HandleScope func_scope{ctx_, &ret, HANDLE_TYPE_LEPUS_VALUE};
  if (!ctx_->rt->gc_enable)
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  std::queue<std::string> tmp_queue;
  QjsDebugQueue::GetReceiveMessageQueue().swap(tmp_queue);
  SetContextConsoleInspect(ctx_, true);
  for (int32_t i = 0; i < 2; ++i) {
    auto message = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    auto message_info =
        LEPUS_ParseJSON(ctx_, message.c_str(), message.size(), "test.js");
    HandleScope block_scope{ctx_, &message_info, HANDLE_TYPE_LEPUS_VALUE};
    LEPUSValue type = LEPUS_GetPropertyStr(ctx_, message_info, "type");
    block_scope.PushHandle(&type, HANDLE_TYPE_LEPUS_VALUE);
    auto* type_str = LEPUS_ToCString(ctx_, type);
    ASSERT_TRUE(!strcmp(type_str, "log"));

    auto args = LEPUS_GetPropertyStr(ctx_, message_info, "args");
    auto value1 = LEPUS_GetPropertyUint32(ctx_, args, 0);
    auto object_id = LEPUS_GetPropertyStr(ctx_, value1, "objectId");
    auto* object_id_str = LEPUS_ToCString(ctx_, object_id);
    block_scope.PushHandle(&object_id_str, HANDLE_TYPE_CSTRING);
    auto* result = GetConsoleObject(ctx_, object_id_str);
    block_scope.PushHandle(&result, HANDLE_TYPE_CSTRING);
    {
      auto prop_value =
          LEPUS_ParseJSON(ctx_, result, strlen(result), "test.js");
      HandleScope block_scope{ctx_, &prop_value, HANDLE_TYPE_LEPUS_VALUE};
      auto prop_value_1 = LEPUS_GetPropertyUint32(ctx_, prop_value, 0);

      auto prop_value_1_name = LEPUS_GetPropertyStr(ctx_, prop_value_1, "name");
      auto* name_str = LEPUS_ToCString(ctx_, prop_value_1_name);
      ASSERT_EQ(std::string(name_str), "prop");

      auto prop_value_1_value =
          LEPUS_GetPropertyStr(ctx_, prop_value_1, "value");
      auto prop_value_object_id =
          LEPUS_GetPropertyStr(ctx_, prop_value_1_value, "objectId");
      auto* prop_value_object_id_str =
          LEPUS_ToCString(ctx_, prop_value_object_id);
      block_scope.PushHandle(&prop_value_object_id_str, HANDLE_TYPE_CSTRING);

      auto* array_result = GetConsoleObject(ctx_, prop_value_object_id_str);
      block_scope.PushHandle(&array_result, HANDLE_TYPE_CSTRING);
      auto array_result_json =
          LEPUS_ParseJSON(ctx_, array_result, strlen(array_result), "test.js");
      block_scope.PushHandle(&array_result_json, HANDLE_TYPE_LEPUS_VALUE);
      ASSERT_EQ(LEPUS_GetLength(ctx_, array_result_json), 3);
      {
        for (uint32_t i = 0; i < 1; ++i) {
          auto obj = LEPUS_GetPropertyUint32(ctx_, array_result_json, 0);
          auto name = LEPUS_GetPropertyStr(ctx_, obj, "name");
          auto str = LEPUS_NewString(ctx_, "0");
          HandleScope block_scope{ctx_, &str, HANDLE_TYPE_LEPUS_VALUE};
          ASSERT_TRUE(LEPUS_StrictEq(ctx_, name, str));
          auto value = LEPUS_GetPropertyStr(ctx_, obj, "value");
          auto type = LEPUS_GetPropertyStr(ctx_, value, "type");
          str = LEPUS_NewString(ctx_, "number");
          block_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
          ASSERT_TRUE(LEPUS_StrictEq(ctx_, type, str));
          auto value_value = LEPUS_GetPropertyStr(ctx_, value, "value");
          ASSERT_TRUE(
              LEPUS_StrictEq(ctx_, value_value, LEPUS_NewInt32(ctx_, 0)));
          if (!ctx_->rt->gc_enable) {
            if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, value);
            if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, obj);
          }
        }
      }
      if (!ctx_->rt->gc_enable) {
        if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, type_str);
        if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, type);
        if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, name_str);
        if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, prop_value_1_name);
        if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, array_result_json);
        if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, array_result);
        if (!ctx_->rt->gc_enable)
          LEPUS_FreeCString(ctx_, prop_value_object_id_str);
        if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, prop_value_object_id);
        if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, prop_value_1_value);

        if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, prop_value_1);
        if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, prop_value);
      }
    }
    if (!ctx_->rt->gc_enable) {
      if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, result);
      if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, object_id_str);
      if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, object_id);
      if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, value1);
      if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, args);
      if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, message_info);
    }

    auto runtime_id_str = QjsDebugQueue::GetReceiveMessageQueue().front();
    auto runtime_id = std::stoi(runtime_id_str);
    ASSERT_TRUE(runtime_id == i + 1);
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  QjsDebugQueue::GetReceiveMessageQueue() = {};
  src = R"(
    test();
  )";
  ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test_lynxConsole1.js",
                   eval_flags);
  ASSERT_TRUE(!LEPUS_IsException(ret));
  ASSERT_TRUE(QjsDebugQueue::GetReceiveMessageQueue().size() == 7);
}
}  // namespace qjs_debug_test
