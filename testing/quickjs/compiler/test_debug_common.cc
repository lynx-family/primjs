// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <queue>
#include <regex>

#include "gc/trace-gc.h"
#include "inspector/debugger/debugger_breakpoint.h"
#include "inspector/debugger/debugger_properties.h"
#include "inspector/debugger_inner.h"
#include "inspector/interface.h"
#include "inspector/runtime/runtime.h"
#include "quickjs/include/quickjs-inner.h"
#include "test_debug_base.h"

LEPUSValue js_closure(LEPUSContext* ctx, LEPUSValue bfunc,
                      struct JSVarRef** cur_var_refs, LEPUSStackFrame* sf);
bool IsBreakpointEqual(LEPUSContext* ctx, LEPUSBreakpoint* a, int32_t script_id,
                       const char* script_url, int32_t line_number,
                       int64_t column_number, LEPUSValue condition_b);
LEPUSBreakpoint* AddBreakpoint(LEPUSDebuggerInfo* info, const char* url,
                               const char* hash, int32_t line_number,
                               int64_t column_number, int32_t script_id,
                               const char* condition,
                               uint8_t specific_location);
char* FindDebuggerMagicContent(LEPUSContext* ctx, char* source,
                               char* search_name, uint8_t multi_line);

LEPUSValue GetAnonFunc(LEPUSFunctionBytecode* b);

namespace qjs_debug_test {

class QjsDebugMethods : public ::testing::Test {
 protected:
  QjsDebugMethods() = default;
  ~QjsDebugMethods() override = default;

  void SetUp() override {
    QjsDebugQueue::GetReceiveMessageQueue() = std::queue<std::string>();
    QjsDebugQueue::GetSendMessageQueue() = std::queue<std::string>();
    QjsDebugQueue::runtime_receive_queue_ = {};
    rt_ = LEPUS_NewRuntime();
    ctx_ = LEPUS_NewContext(rt_);
    auto funcs = GetQJSCallbackFuncs();
    PrepareQJSDebuggerDefer(ctx_, funcs.data(), funcs.size());
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

static void EvalScriptExpectNoException(LEPUSContext* ctx,
                                        const std::string& src,
                                        const char* filename) {
  LEPUSValue ret = LEPUS_Eval(ctx, src.c_str(), src.size(), filename,
                              LEPUS_EVAL_TYPE_GLOBAL);
  if (LEPUS_IsException(ret)) {
    lepus_std_dump_error(ctx);
    ASSERT_FALSE(LEPUS_IsException(ret));
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
}

static bool EvalScriptToBoolExpectNoException(LEPUSContext* ctx,
                                              const std::string& src,
                                              const char* filename) {
  LEPUSValue ret = LEPUS_Eval(ctx, src.c_str(), src.size(), filename,
                              LEPUS_EVAL_TYPE_GLOBAL);
  if (LEPUS_IsException(ret)) {
    lepus_std_dump_error(ctx);
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
    ADD_FAILURE() << "script threw exception: " << filename;
    return false;
  }
  int32_t result = LEPUS_ToBool(ctx, ret);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  if (result < 0) {
    ADD_FAILURE() << "script bool coercion failed: " << filename;
    return false;
  }
  return result != 0;
}

static void ProcessQueuedProtocolMessages(LEPUSContext* ctx) {
  GetMessagesCB(ctx);
}

static std::string GetJsonString(LEPUSContext* ctx, LEPUSValue value) {
  const char* c_str = LEPUS_ToCString(ctx, value);
  if (!c_str) {
    return "";
  }
  std::string result(c_str);
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, c_str);
  return result;
}

static std::string GetJsonMethod(LEPUSContext* ctx,
                                 const std::string& message) {
  LEPUSValue json = LEPUS_ParseJSON(ctx, message.c_str(), message.length(), "");
  if (!LEPUS_IsObject(json)) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, json);
    return "";
  }
  LEPUSValue method = LEPUS_GetPropertyStr(ctx, json, "method");
  std::string result;
  if (LEPUS_IsString(method)) {
    result = GetJsonString(ctx, method);
  }
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, method);
    LEPUS_FreeValue(ctx, json);
  }
  return result;
}

static bool ConsoleNotificationHasMarker(LEPUSContext* ctx,
                                         const std::string& message,
                                         const std::string& marker) {
  LEPUSValue json = LEPUS_ParseJSON(ctx, message.c_str(), message.length(), "");
  if (!LEPUS_IsObject(json)) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, json);
    return false;
  }
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, json, "params");
  LEPUSValue args = LEPUS_IsObject(params)
                        ? LEPUS_GetPropertyStr(ctx, params, "args")
                        : LEPUS_UNDEFINED;
  LEPUSValue arg0 = LEPUS_IsObject(args) ? LEPUS_GetPropertyUint32(ctx, args, 0)
                                         : LEPUS_UNDEFINED;
  LEPUSValue value = LEPUS_IsObject(arg0)
                         ? LEPUS_GetPropertyStr(ctx, arg0, "value")
                         : LEPUS_UNDEFINED;
  bool matched = LEPUS_IsString(value) && GetJsonString(ctx, value) == marker;
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, value);
    LEPUS_FreeValue(ctx, arg0);
    LEPUS_FreeValue(ctx, args);
    LEPUS_FreeValue(ctx, params);
    LEPUS_FreeValue(ctx, json);
  }
  return matched;
}

static std::string PopConsoleNotificationByMarker(LEPUSContext* ctx,
                                                  const std::string& marker) {
  while (!QjsDebugQueue::runtime_receive_queue_.empty()) {
    std::string message = QjsDebugQueue::runtime_receive_queue_.front();
    QjsDebugQueue::runtime_receive_queue_.pop();
    if (GetJsonMethod(ctx, message) == "Runtime.consoleAPICalled" &&
        ConsoleNotificationHasMarker(ctx, message, marker)) {
      return message;
    }
  }
  ADD_FAILURE() << "missing Runtime.consoleAPICalled for marker: " << marker;
  return "";
}

static std::string ExtractConsoleArgObjectId(LEPUSContext* ctx,
                                             const std::string& message,
                                             uint32_t arg_index) {
  LEPUSValue json = LEPUS_ParseJSON(ctx, message.c_str(), message.length(), "");
  if (!LEPUS_IsObject(json)) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, json);
    return "";
  }
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, json, "params");
  LEPUSValue args = LEPUS_IsObject(params)
                        ? LEPUS_GetPropertyStr(ctx, params, "args")
                        : LEPUS_UNDEFINED;
  LEPUSValue arg = LEPUS_IsObject(args)
                       ? LEPUS_GetPropertyUint32(ctx, args, arg_index)
                       : LEPUS_UNDEFINED;
  LEPUSValue object_id = LEPUS_IsObject(arg)
                             ? LEPUS_GetPropertyStr(ctx, arg, "objectId")
                             : LEPUS_UNDEFINED;
  std::string result;
  if (LEPUS_IsString(object_id)) {
    result = GetJsonString(ctx, object_id);
  }
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, object_id);
    LEPUS_FreeValue(ctx, arg);
    LEPUS_FreeValue(ctx, args);
    LEPUS_FreeValue(ctx, params);
    LEPUS_FreeValue(ctx, json);
  }
  return result;
}

static void SendRuntimeGetProperties(LEPUSContext* ctx, int request_id,
                                     const std::string& object_id) {
  std::string request =
      std::string("{\"id\":") + std::to_string(request_id) +
      ",\"method\":\"Runtime.getProperties\",\"params\":{\"objectId\":\"" +
      object_id +
      "\",\"ownProperties\":true,\"accessorPropertiesOnly\":false,"
      "\"generatePreview\":true}}";
  QjsDebugQueue::GetSendMessageQueue().push(request);
  ProcessQueuedProtocolMessages(ctx);
}

static std::string PopResponseById(LEPUSContext* ctx, int request_id) {
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string message = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json =
        LEPUS_ParseJSON(ctx, message.c_str(), message.length(), "");
    if (LEPUS_IsObject(json)) {
      LEPUSValue id = LEPUS_GetPropertyStr(ctx, json, "id");
      int32_t current_id = -1;
      bool matched = LEPUS_IsNumber(id) &&
                     LEPUS_ToInt32(ctx, &current_id, id) == 0 &&
                     current_id == request_id;
      if (!ctx->rt->gc_enable) {
        LEPUS_FreeValue(ctx, id);
        LEPUS_FreeValue(ctx, json);
      }
      if (matched) {
        return message;
      }
      continue;
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, json);
  }
  ADD_FAILURE() << "missing response for id=" << request_id;
  return "";
}

static LEPUSValue GetPropertiesResultArray(LEPUSContext* ctx,
                                           const std::string& response) {
  LEPUSValue json =
      LEPUS_ParseJSON(ctx, response.c_str(), response.length(), "");
  LEPUSValue result_array = LEPUS_UNDEFINED;
  if (LEPUS_IsObject(json)) {
    LEPUSValue result = LEPUS_GetPropertyStr(ctx, json, "result");
    if (LEPUS_IsObject(result)) {
      LEPUSValue array = LEPUS_GetPropertyStr(ctx, result, "result");
      if (LEPUS_IsObject(array)) {
        result_array = LEPUS_DupValue(ctx, array);
      }
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, array);
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, result);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, json);
  return result_array;
}

static LEPUSValue FindPropertyRemoteObjectByName(LEPUSContext* ctx,
                                                 LEPUSValue properties_array,
                                                 const std::string& name) {
  if (!LEPUS_IsObject(properties_array)) {
    return LEPUS_UNDEFINED;
  }
  uint32_t length = LEPUS_GetLength(ctx, properties_array);
  for (uint32_t i = 0; i < length; ++i) {
    LEPUSValue descriptor = LEPUS_GetPropertyUint32(ctx, properties_array, i);
    LEPUSValue property_name =
        LEPUS_IsObject(descriptor)
            ? LEPUS_GetPropertyStr(ctx, descriptor, "name")
            : LEPUS_UNDEFINED;
    bool matched = LEPUS_IsString(property_name) &&
                   GetJsonString(ctx, property_name) == name;
    if (matched) {
      LEPUSValue value = LEPUS_GetPropertyStr(ctx, descriptor, "value");
      LEPUSValue result = LEPUS_DupValue(ctx, value);
      if (!ctx->rt->gc_enable) {
        LEPUS_FreeValue(ctx, value);
        LEPUS_FreeValue(ctx, property_name);
        LEPUS_FreeValue(ctx, descriptor);
      }
      return result;
    }
    if (!ctx->rt->gc_enable) {
      LEPUS_FreeValue(ctx, property_name);
      LEPUS_FreeValue(ctx, descriptor);
    }
  }
  return LEPUS_UNDEFINED;
}

static std::string ExtractRemoteObjectObjectId(LEPUSContext* ctx,
                                               LEPUSValue remote_object) {
  if (!LEPUS_IsObject(remote_object)) {
    return "";
  }
  LEPUSValue object_id = LEPUS_GetPropertyStr(ctx, remote_object, "objectId");
  std::string result;
  if (LEPUS_IsString(object_id)) {
    result = GetJsonString(ctx, object_id);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, object_id);
  return result;
}

static std::string ExtractRemoteObjectStringValue(LEPUSContext* ctx,
                                                  LEPUSValue remote_object) {
  if (!LEPUS_IsObject(remote_object)) {
    return "";
  }
  LEPUSValue value = LEPUS_GetPropertyStr(ctx, remote_object, "value");
  std::string result;
  if (LEPUS_IsString(value)) {
    result = GetJsonString(ctx, value);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, value);
  return result;
}

static int32_t ExtractRemoteObjectIntValue(LEPUSContext* ctx,
                                           LEPUSValue remote_object) {
  if (!LEPUS_IsObject(remote_object)) {
    return -1;
  }
  LEPUSValue value = LEPUS_GetPropertyStr(ctx, remote_object, "value");
  int32_t result = -1;
  if (LEPUS_IsNumber(value)) {
    LEPUS_ToInt32(ctx, &result, value);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, value);
  return result;
}

struct TestConsoleObjectIdInfo {
  bool valid{false};
  uint32_t message_slot{0};
  uint32_t generation{0};
  bool is_child{false};
  uint32_t index{0};
};

static TestConsoleObjectIdInfo ParseConsoleObjectIdForTest(
    const std::string& object_id) {
  std::smatch match;
  static const std::regex kRootPattern(R"(^console:(\d+):(\d+):(\d+)$)");
  static const std::regex kChildPattern(R"(^console:(\d+):(\d+):child:(\d+)$)");

  if (std::regex_match(object_id, match, kRootPattern)) {
    return {true, static_cast<uint32_t>(std::stoul(match[1].str())),
            static_cast<uint32_t>(std::stoul(match[2].str())), false,
            static_cast<uint32_t>(std::stoul(match[3].str()))};
  }
  if (std::regex_match(object_id, match, kChildPattern)) {
    return {true, static_cast<uint32_t>(std::stoul(match[1].str())),
            static_cast<uint32_t>(std::stoul(match[2].str())), true,
            static_cast<uint32_t>(std::stoul(match[3].str()))};
  }
  return {};
}

static void PrepareGetInternalProperties(LEPUSRuntime* rt, int32_t bp_line) {
  PushSetBreakpointMessages(bp_line);
  void* funcs[14] = {reinterpret_cast<void*>(PauseCBGetInternalProperties),
                     reinterpret_cast<void*>(QuitMessageLoopOnPauseCB),
                     reinterpret_cast<void*>(GetMessagesCB),
                     reinterpret_cast<void*>(SendResponseCB),
                     reinterpret_cast<void*>(SendNotificationCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(IsRuntimeDevtoolOnCB)};
  RegisterQJSDebuggerCallbacks(rt, reinterpret_cast<void**>(funcs), 14);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetScriptSource) {
  const char* filename = TEST_CASE_DIR "qjs_debug_test/qjs_debug_test1.js";

  LEPUSValue val = LEPUS_UNDEFINED;
  HandleScope func_scope(ctx_, &val, HANDLE_TYPE_LEPUS_VALUE);

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Debugger.disable\",\"params\":{}}");

  bool res = js_run(ctx_, filename, val);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
  if (!res) {
    ASSERT_TRUE(false);
  }
  std::string script_parsed =
      R"({"method":"Debugger.scriptParsed","params":{"scriptId":"1","url":")" TEST_CASE_DIR
      R"(qjs_debug_test/qjs_debug_test1.js","hasSourceURL":true,"startLine":0,"endLine":14,"startColumn":0,"endColumn":0,"executionContextId":0,"hash":"8858373725189169767","length":312,"scriptLanguage":"JavaScript","sourceMapURL":""}})";
  std::string debugger_enable_res = R"({"id":0,"result":{"debuggerId":"-1"}})";
  std::string get_script_source_res =
      R"({"id":1,"result":{"scriptSource":"// Copyright 2024 The Lynx Authors. All rights reserved.\n// Licensed under the Apache License Version 2.0 that can be found in the\n// LICENSE file in the root directory of this source tree.\n\nfunction test() {\n    let a = 1;\n    console.log(\"hello\");\n    a = a + 1;\n    console.log(a);\n    return true;\n}\n\ntest();"}})";
  ASSERT_TRUE(QjsDebugQueue::GetReceiveMessageQueue().front() ==
              debugger_enable_res);
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  ASSERT_EQ(QjsDebugQueue::GetReceiveMessageQueue().front(), script_parsed);
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  ASSERT_TRUE(QjsDebugQueue::GetReceiveMessageQueue().front() ==
              get_script_source_res);
}

TEST_F(QjsDebugMethods, QJSDebugTestBreakpoint) {
  const char* filename = TEST_CASE_DIR "qjs_debug_test/qjs_debug_test1.js";
  LEPUSValue val = LEPUS_UNDEFINED;
  HandleScope func_scope(ctx_, &val, HANDLE_TYPE_LEPUS_VALUE);

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
      "{\"id\":3,\"method\":\"Debugger.getPossibleBreakpoints\",\"params\":{"
      "\"start\":{\"scriptId\":\"1\",\"lineNumber\":4,\"columnNumber\":0},"
      "\"end\":{\"scriptId\":\"1\",\"lineNumber\":5,\"columnNumber\":0},"
      "\"restrictToFunction\":false}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":4,\"method\":\"Debugger.setBreakpointByUrl\",\"params\":{"
      "\"lineNumber\":4,\"url\":\"" TEST_CASE_DIR
      "qjs_debug_test/"
      "qjs_debug_test1.js\",\"columnNumber\":0,\"condition\":\"\"}}");

  bool res = js_run(ctx_, filename, val);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
  if (!res) {
    ASSERT_TRUE(false);
  }

  for (size_t i = 0; i < 5; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::string bp_res =
      R"({"id":4,"result":{"breakpointId":"1:4:0:)" TEST_CASE_DIR
      R"(qjs_debug_test/qjs_debug_test1.js","locations":[{"lineNumber":4,"columnNumber":16,"scriptId":"1"}]}})";
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  ASSERT_TRUE(QjsDebugQueue::GetReceiveMessageQueue().front() == bp_res);
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Debugger.disable\",\"params\":{}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret1 = LEPUS_Eval(ctx_, buf, strlen(buf), "trigger_debugger.js",
                               LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret1);
}

TEST_F(QjsDebugMethods, QJSDebugTestBreakpoint2) {
  const char* buf = R"(function test(a, b) {
    var num = a + b;
    return num;
  }

  test(1, 2);
  )";

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
      "{\"id\":3,\"method\":\"Debugger.getPossibleBreakpoints\",\"params\":{"
      "\"start\":{\"scriptId\":\"1\",\"lineNumber\":2,\"columnNumber\":0},"
      "\"end\":{\"scriptId\":\"1\",\"lineNumber\":3,\"columnNumber\":0},"
      "\"restrictToFunction\":false}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":4,\"method\":\"Debugger.setBreakpointByUrl\",\"params\":{"
      "\"lineNumber\":2,\"url\":\"test_return_breakpoints.js\","
      "\"columnNumber\":0,\"condition\":\"\"}}");

  LEPUSValue res =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_return_breakpoints.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, res);

  for (size_t i = 0; i < 5; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::string bp_res =
      R"({"id":4,"result":{"breakpointId":"1:2:0:test_return_breakpoints.js","locations":[{"lineNumber":2,"columnNumber":4,"scriptId":"1"}]}})";
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  ASSERT_TRUE(QjsDebugQueue::GetReceiveMessageQueue().front() == bp_res);
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Debugger.disable\",\"params\":{}}");
  const char* buf1 = "function trigger() {}; trigger();\n";
  LEPUSValue ret1 = LEPUS_Eval(ctx_, buf1, strlen(buf1), "trigger_debugger.js",
                               LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret1);
}

TEST_F(QjsDebugMethods, QJSDebugTestBreakpoint3) {
  const char* buf = R"(
    var obj = {
        a: 1,
        b: "test",
        c: true
    };
  )";

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
      "{\"id\":3,\"method\":\"Debugger.getPossibleBreakpoints\",\"params\":{"
      "\"start\":{\"scriptId\":\"1\",\"lineNumber\":4,\"columnNumber\":0},"
      "\"end\":{\"scriptId\":\"1\",\"lineNumber\":5,\"columnNumber\":0},"
      "\"restrictToFunction\":false}}");

  LEPUSValue res = LEPUS_Eval(ctx_, buf, strlen(buf), "test_breakpoint3.js",
                              LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, res);

  for (size_t i = 0; i < 4; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::string bp_res = R"({"id":3,"result":{"locations":[]}})";
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  ASSERT_TRUE(QjsDebugQueue::GetReceiveMessageQueue().front() == bp_res);
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Debugger.disable\",\"params\":{}}");
  const char* buf1 = "function trigger() {}; trigger();\n";
  LEPUSValue ret1 = LEPUS_Eval(ctx_, buf1, strlen(buf1), "trigger_debugger.js",
                               LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret1);
}

TEST_F(QjsDebugMethods, QJSDebugTestEvaluateOnCallFrame) {
  void* funcs[14] = {reinterpret_cast<void*>(RunMessageLoopOnPauseCB1),
                     reinterpret_cast<void*>(QuitMessageLoopOnPauseCB),
                     reinterpret_cast<void*>(GetMessagesCB),
                     reinterpret_cast<void*>(SendResponseCB),
                     reinterpret_cast<void*>(SendNotificationCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(IsRuntimeDevtoolOnCB)};
  RegisterQJSDebuggerCallbacks(rt_, reinterpret_cast<void**>(funcs), 14);

  const char* filename = TEST_CASE_DIR "qjs_debug_test/qjs_debug_test1.js";

  LEPUSValue val = LEPUS_UNDEFINED;
  HandleScope func_scope(ctx_, &val, HANDLE_TYPE_LEPUS_VALUE);

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
      "{\"id\":3,\"method\":\"Debugger.getPossibleBreakpoints\",\"params\":{"
      "\"start\":{\"scriptId\":\"1\",\"lineNumber\":8,\"columnNumber\":0},"
      "\"end\":{\"scriptId\":\"1\",\"lineNumber\":9,\"columnNumber\":0},"
      "\"restrictToFunction\":false}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":4,\"method\":\"Debugger.setBreakpointByUrl\",\"params\":{"
      "\"lineNumber\":8,\"url\":\"" TEST_CASE_DIR
      "qjs_debug_test/"
      "qjs_debug_test1.js\",\"columnNumber\":0,\"condition\":\"\"}}");

  bool res = js_run(ctx_, filename, val);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
  if (!res) {
    ASSERT_TRUE(false);
  }

  for (size_t i = 0; i < 7; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::string eval_res =
      R"({"id":56,"result":{"result":{"description":"2","value":2,"type":"number"}}})";
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  ASSERT_TRUE(QjsDebugQueue::GetReceiveMessageQueue().front() == eval_res);
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Debugger.disable\",\"params\":{}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret1 = LEPUS_Eval(ctx_, buf, strlen(buf), "trigger_debugger.js",
                               LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret1);
}

static void js_check_get_possible_breakpoints(
    LEPUSContext* ctx, int32_t script_id, int64_t start_line, int64_t start_col,
    int64_t end_line, int64_t end_col, const std::string& gt) {
  LEPUSValue locations = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &locations, HANDLE_TYPE_LEPUS_VALUE);
  GetPossibleBreakpointsByScriptId(ctx, script_id, start_line, start_col,
                                   end_line, end_col, locations);
  LEPUSValue locations_val = LEPUS_ToJSON(ctx, locations, 0);
  func_scope.PushHandle(&locations_val, HANDLE_TYPE_LEPUS_VALUE);
  const char* locations_str = LEPUS_ToCString(ctx, locations_val);
  std::cout << "result: " << locations_str << std::endl;
  ASSERT_TRUE(std::string(locations_str) == gt);
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, locations_str);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, locations_val);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, locations);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPossibleBreakpoints) {
  const char* filename = TEST_CASE_DIR "qjs_debug_test/qjs_debug_test1.js";
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");
  LEPUSValue val = LEPUS_UNDEFINED;
  HandleScope func_scope(ctx_, &val, HANDLE_TYPE_LEPUS_VALUE);
  bool res = js_run(ctx_, filename, val);
  if (!res) {
    ASSERT_TRUE(false);
  }

  std::string possible_breakpoints =
      R"({"0":{"scriptId":"1","lineNumber":6,"columnNumber":4},"1":{"scriptId":"1","lineNumber":6,"columnNumber":12},"2":{"scriptId":"1","lineNumber":6,"columnNumber":16},"3":{"scriptId":"1","lineNumber":6,"columnNumber":24}})";
  js_check_get_possible_breakpoints(ctx_, 1, 6, 0, 7, 0, possible_breakpoints);
  std::string possible_breakpoints2 =
      R"({"0":{"scriptId":"1","lineNumber":9,"columnNumber":4},"1":{"scriptId":"1","lineNumber":9,"columnNumber":15}})";
  js_check_get_possible_breakpoints(ctx_, 1, 9, 0, 10, 0,
                                    possible_breakpoints2);

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Debugger.disable\",\"params\":{}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret1 = LEPUS_Eval(ctx_, buf, strlen(buf), "trigger_debugger.js",
                               LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret1);
}

TEST_F(QjsDebugMethods, QJSDebugTestExceptionDescription) {
  const char* buf = "function test() {let a = 1; a()}; test();";
  int eval_flags;
  eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_exception.js", eval_flags);
  LEPUSValue exception = LEPUS_GetException(ctx_);
  HandleScope func_scope(ctx_, &exception, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue exception_desc = GetExceptionDescription(ctx_, exception);
  func_scope.PushHandle(&exception_desc, HANDLE_TYPE_LEPUS_VALUE);
  const char* exception_str = LEPUS_ToCString(ctx_, exception_desc);
  std::cout << exception_str << std::endl;
  std::string true_res =
      "TypeError: a is not a function    at test (test_exception.js:1:32)\n    "
      "at "
      "<eval> (test_exception.js:1:41)\n";
  std::cout << true_res << std::endl;

  ASSERT_TRUE(true_res == exception_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, exception_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, exception_desc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, exception);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

static void PrepareGetClosureProperties(LEPUSRuntime* rt, int32_t bp_line) {
  PushSetBreakpointMessages(bp_line);
  void* funcs[14] = {reinterpret_cast<void*>(PauseCBGetClosureProperties),
                     reinterpret_cast<void*>(QuitMessageLoopOnPauseCB),
                     reinterpret_cast<void*>(GetMessagesCB),
                     reinterpret_cast<void*>(SendResponseCB),
                     reinterpret_cast<void*>(SendNotificationCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(IsRuntimeDevtoolOnCB)};
  RegisterQJSDebuggerCallbacks(rt, reinterpret_cast<void**>(funcs), 14);
}

static void PrepareForEvaluateOnPause(LEPUSRuntime* rt) {
  void* funcs[14] = {reinterpret_cast<void*>(PauseCBEvaluate),
                     reinterpret_cast<void*>(QuitMessageLoopOnPauseCB),
                     reinterpret_cast<void*>(GetMessagesCB),
                     reinterpret_cast<void*>(SendResponseCB),
                     reinterpret_cast<void*>(SendNotificationCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(IsRuntimeDevtoolOnCB)};
  RegisterQJSDebuggerCallbacks(rt, reinterpret_cast<void**>(funcs), 14);
}

static void PrepareGetGlobalProperties(LEPUSRuntime* rt, int32_t bp_line) {
  PushSetBreakpointMessages(bp_line);
  void* funcs[14] = {reinterpret_cast<void*>(PauseCBGetGlobalProperties),
                     reinterpret_cast<void*>(QuitMessageLoopOnPauseCB),
                     reinterpret_cast<void*>(GetMessagesCB),
                     reinterpret_cast<void*>(SendResponseCB),
                     reinterpret_cast<void*>(SendNotificationCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(IsRuntimeDevtoolOnCB)};
  RegisterQJSDebuggerCallbacks(rt, reinterpret_cast<void**>(funcs), 14);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetProperties) {
  const char* buf = R"(function test() {
    let obj = {
      a: 1,
      b: "test",
      c: true
    } 
    console.log(obj);
    let num = 2;
    return num;
  }

  test();
  )";

  PrepareGetProperties(rt_, 8);

  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      R"(\{"id":48,"result":\{"result":\[\{"name":"obj","configurable":true,"enumerable":true,"writable":true,"value":\{"type":"object","objectId":".*","className":"Object","description":"Object","preview":\{"overflow":false,"type":"object","description":"Object","properties":\[\{"description":"1","value":1,"type":"number","name":"a"\},\{"value":"test","type":"string","name":"b"\},\{"value":true,"type":"boolean","name":"c"\}\]\}\}\},\{"name":"num","configurable":true,"enumerable":true,"writable":true,"value":\{"description":"2","value":2,"type":"number"\}\}\]\}\})";

  for (size_t i = 0; i < 9; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGlobalProperties) {
  const char* buf = R"(const add = (function () {
  let obj = {
    a: 1,
    b: "test",
    c: true
  } 
  return function () {
    obj.a += 1; 
    return obj
  }
})();

add();
  )";

  PrepareGetGlobalProperties(rt_, 8);

  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  ASSERT_TRUE(true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetClosureProperties) {
  const char* buf = R"(const add = (function () {
  let obj = {
    a: 1,
    b: "test",
    c: true
  } 
  return function () {
    obj.a += 1; 
    return obj
  }
})();

add();
  )";

  PrepareGetClosureProperties(rt_, 8);

  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      R"(\{"id":48,"result":\{"result":\[\{"name":"obj","configurable":true,"enumerable":true,"writable":true,"value":\{"type":"object","objectId":".*","className":"Object","description":"Object","preview":\{"overflow":false,"type":"object","description":"Object","properties":\[\{"description":"2","value":2,"type":"number","name":"a"\},\{"value":"test","type":"string","name":"b"\},\{"value":true,"type":"boolean","name":"c"\}\]\}\}\}\]\}\})";

  std::string properties_gt =
      R"({"id":48,"result":{"result":[{"name":"obj","configurable":true,"enumerable":true,"writable":true,"value":{"type":"object","objectId":"10","className":"Object","description":"Object","preview":{"overflow":false,"type":"object","description":"Object","properties":[{"description":"2","value":2,"type":"number","name":"a"},{"value":"test","type":"string","name":"b"},{"value":true,"type":"boolean","name":"c"}]}}}]}})";
  for (size_t i = 0; i < 8; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetRemoteObjectNum) {
  LEPUSValue num1 = LEPUS_NewInt32(ctx_, 100);
  LEPUSValue num1_obj = GetRemoteObject(ctx_, num1, true, true);  // free num1
  HandleScope func_scope(ctx_, &num1_obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue num1_json = LEPUS_ToJSON(ctx_, num1_obj, 0);
  func_scope.PushHandle(&num1_json, HANDLE_TYPE_LEPUS_VALUE);
  const char* num1_str = LEPUS_ToCString(ctx_, num1_json);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, num1_obj);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, num1_json);
  std::string num1_gt = R"({"description":"100","value":100,"type":"number"})";
  std::cout << num1_str << std::endl;
  ASSERT_TRUE(num1_gt == num1_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, num1_str);

  LEPUSValue num2 = LEPUS_NewFloat64(ctx_, 1.234);
  LEPUSValue num2_obj = GetRemoteObject(ctx_, num2, true, true);  // free num2
  func_scope.PushHandle(&num2_obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue num2_json = LEPUS_ToJSON(ctx_, num2_obj, 0);
  func_scope.PushHandle(&num2_json, HANDLE_TYPE_LEPUS_VALUE);
  const char* num2_str = LEPUS_ToCString(ctx_, num2_json);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, num2_obj);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, num2_json);
  std::string num2_gt =
      R"({"description":"1.234","value":1.234,"type":"number"})";
  std::cout << num2_str << std::endl;
  ASSERT_TRUE(num2_gt == num2_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, num2_str);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetRemoteObjectBool) {
  LEPUSValue bool_val = LEPUS_NewBool(ctx_, true);
  LEPUSValue bool_val_obj =
      GetRemoteObject(ctx_, bool_val, true, true);  // free bool_val
  HandleScope func_scope(ctx_, &bool_val_obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue bool_val_json = LEPUS_ToJSON(ctx_, bool_val_obj, 0);
  func_scope.PushHandle(&bool_val_json, HANDLE_TYPE_LEPUS_VALUE);
  const char* bool_val_str = LEPUS_ToCString(ctx_, bool_val_json);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, bool_val_obj);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, bool_val_json);
  std::string bool_val_gt = R"({"value":true,"type":"boolean"})";
  std::cout << bool_val_str << std::endl;
  ASSERT_TRUE(bool_val_gt == bool_val_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, bool_val_str);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetRemoteObjectString) {
  LEPUSValue string = LEPUS_NewString(ctx_, "test_string");
  HandleScope func_scope(ctx_, &string, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue string_obj =
      GetRemoteObject(ctx_, string, true, true);  // free string
  func_scope.PushHandle(&string_obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue string_json = LEPUS_ToJSON(ctx_, string_obj, 0);
  func_scope.PushHandle(&string_json, HANDLE_TYPE_LEPUS_VALUE);
  const char* string_str = LEPUS_ToCString(ctx_, string_json);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, string_obj);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, string_json);
  std::string string_gt = R"({"value":"test_string","type":"string"})";
  std::cout << string_str << std::endl;
  ASSERT_TRUE(string_gt == string_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, string_str);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetRemoteObjectObj) {
  LEPUSValue obj = LEPUS_NewObject(ctx_);
  HandleScope func_scope(ctx_, &obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyStr(ctx_, obj, "a", LEPUS_NewInt32(ctx_, 1));
  LEPUSValue str = LEPUS_NewString(ctx_, "test");
  func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyStr(ctx_, obj, "b", str);
  LEPUSValue obj_obj = GetRemoteObject(ctx_, obj, true, true);  // free obj
  func_scope.PushHandle(&obj_obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue obj_json = LEPUS_ToJSON(ctx_, obj_obj, 0);
  func_scope.PushHandle(&obj_json, HANDLE_TYPE_LEPUS_VALUE);
  const char* obj_str = LEPUS_ToCString(ctx_, obj_json);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, obj_obj);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, obj_json);
  uint64_t obj_ptr = (uint64_t)(LEPUS_VALUE_GET_OBJ(obj));
  std::string object_id = std::to_string(obj_ptr);
  std::string obj_gt_part1 =
      R"({"value":{"a":1,"b":"test"},"type":"object","objectId":")";
  std::string obj_gt_part2 = std::to_string(obj_ptr);
  std::string obj_gt_part3 =
      R"(","className":"Object","description":"Object","preview":{"overflow":false,"type":"object","description":"Object","properties":[{"description":"1","value":1,"type":"number","name":"a"},{"value":"test","type":"string","name":"b"}]}})";
  std::string obj_gt = obj_gt_part1 + obj_gt_part2 + obj_gt_part3;
  uint64_t obj_id = 0;
  LEPUSValue obj2 = GetObjFromObjectId(ctx_, object_id.c_str(), &obj_id);
  uint64_t obj_ptr2 = (uint64_t)LEPUS_VALUE_GET_OBJ(obj2);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, obj2);
  ASSERT_TRUE(obj_ptr2 == obj_ptr);
  ASSERT_TRUE(obj_gt == std::string(obj_str));
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, obj_str);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetRemoteObject) {
  LEPUSValue string = LEPUS_NewString(ctx_, "test_string");
  HandleScope func_scope(ctx_, &string, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue string_obj =
      GetRemoteObject(ctx_, string, true, true);  // free string
  func_scope.PushHandle(&string_obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue string_json = LEPUS_ToJSON(ctx_, string_obj, 0);
  func_scope.PushHandle(&string_json, HANDLE_TYPE_LEPUS_VALUE);
  const char* string_str = LEPUS_ToCString(ctx_, string_json);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, string_obj);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, string_json);
  std::string string_gt = R"({"value":"test_string","type":"string"})";
  std::cout << string_str << std::endl;
  ASSERT_TRUE(string_gt == string_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, string_str);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetRemoteArray) {
  LEPUSValue array = LEPUS_NewArray(ctx_);
  HandleScope func_scope(ctx_, &array, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyUint32(ctx_, array, 0, LEPUS_NewInt32(ctx_, 1));
  LEPUSValue str = LEPUS_NewString(ctx_, "test");
  func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyUint32(ctx_, array, 1, str);
  LEPUSValue array_obj =
      GetRemoteObject(ctx_, array, true, true);  // free array
  func_scope.PushHandle(&array_obj, HANDLE_TYPE_LEPUS_VALUE);
  uint64_t array_ptr = (uint64_t)(LEPUS_VALUE_GET_OBJ(array));
  std::cout << "array_ptr: " << array_ptr << std::endl;
  LEPUSValue array_json = LEPUS_ToJSON(ctx_, array_obj, 0);
  func_scope.PushHandle(&array_json, HANDLE_TYPE_LEPUS_VALUE);
  const char* array_str = LEPUS_ToCString(ctx_, array_json);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, array_obj);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, array_json);
  std::string array_gt =
      "{\"subtype\":\"array\",\"value\":[1,\"test\"],\"type\":\"object\","
      "\"objectId\":\"" +
      std::to_string(array_ptr) +
      "\",\"className\":\"Array\",\"description\":"
      "\"Array(2)\",\"preview\":{\"overflow\":false,\"type\":\"object\","
      "\"subtype\":\"array\",\"description\":\"Array(2)\",\"properties\":[{"
      "\"description\":\"1\",\"value\":1,\"type\":\"number\",\"name\":\"0\"},{"
      "\"value\":\"test\",\"type\":\"string\",\"name\":\"1\"},{\"description\":"
      "\"2\",\"value\":2,\"type\":\"number\",\"name\":\"length\"}]}}";
  std::cout << array_str << std::endl;
  ASSERT_TRUE(array_gt == array_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, array_str);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetRemoteFunction) {
  const char* buf = "function test() {let a = 1;} test();";
  LEPUSValue ret = LEPUS_Eval(
      ctx_, (const char*)buf, strlen(buf), "test_getproperty_function.js",
      LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL);
  HandleScope func_scope(ctx_, &ret, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue func = js_closure(ctx_, ret, NULL, NULL);
  func_scope.PushHandle(&func, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue func_obj = GetRemoteObject(ctx_, func, true, true);  // free func
  func_scope.PushHandle(&func_obj, HANDLE_TYPE_LEPUS_VALUE);
  uint64_t func_ptr = (uint64_t)(LEPUS_VALUE_GET_OBJ(func));
  LEPUSValue func_json = LEPUS_ToJSON(ctx_, func_obj, 0);
  func_scope.PushHandle(&func_json, HANDLE_TYPE_LEPUS_VALUE);
  const char* func_str = LEPUS_ToCString(ctx_, func_json);
  std::cout << func_str << std::endl;
  std::string func_gt1 = R"({"type":"function","objectId":")";
  std::string func_gt2 = std::to_string(func_ptr);
  std::string func_gt3 =
      R"(","className":"Function","description":"function test() {let a = 1;} test();"})";
  std::string func_gt = func_gt1 + func_gt2 + func_gt3;
  ASSERT_TRUE(func_gt == func_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, func_json);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, func_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, func_obj);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPropertiesRegExpAndDate) {
  const char* buf = R"(function test() {
    let reg_exp = new RegExp(/[A-Z]/g);
    let date = new Date('1995-12-17T03:24:00');
    console.log(reg_exp);
    console.log(date);
    return;
  }
  test();
  )";

  PrepareGetProperties(rt_, 5);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"reg_exp\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"subtype\":\"regexp\",\"type\":\"object\",\"objectId\":\".*\","
      "\"className\":\"Regexp\",\"description\":\"\\[A\\-Z\\]\",\"preview\":\\{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"regexp\","
      "\"description\":\"\\[A\\-Z\\]\",\"properties\":\\[\\{\"description\":"
      "\"0\","
      "\"value\":0,\"type\":\"number\",\"name\":\"lastIndex\"\\}\\]\\}\\}\\},"
      "\\{\"name\":"
      "\"date\",\"configurable\":true,\"enumerable\":true,\"writable\":true,"
      "\"value\":\\{\"subtype\":\"date\",\"type\":\"object\",\"objectId\":\".*"
      "\","
      "\"className\":\"Date\",\"description\":\".*"
      "\",\"preview\":\\{\"overflow\":false,\"type\":\"object\","
      "\"subtype\":\"date\",\"description\":\".*\",\"properties\":\\[\\]\\}\\}"
      "\\}\\]\\}\\}";

  std::string properties_gt =
      "{\"id\":48,\"result\":{\"result\":[{\"name\":\"reg_exp\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":{"
      "\"subtype\":\"regexp\",\"type\":\"object\",\"objectId\":\"10\","
      "\"className\":\"Regexp\",\"description\":\"[A-Z]\",\"preview\":{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"regexp\","
      "\"description\":\"[A-Z]\",\"properties\":[{\"description\":\"0\","
      "\"value\":0,\"type\":\"number\",\"name\":\"lastIndex\"}]}}},{\"name\":"
      "\"date\",\"configurable\":true,\"enumerable\":true,\"writable\":true,"
      "\"value\":{\"subtype\":\"date\",\"type\":\"object\",\"objectId\":\"11\","
      "\"className\":\"Date\",\"description\":\"Sun Dec 17 1995 03:24:00 "
      "GMT+0800\",\"preview\":{\"overflow\":false,\"type\":\"object\","
      "\"subtype\":\"date\",\"description\":\"Sun Dec 17 1995 03:24:00 "
      "GMT+0800\",\"properties\":[]}}}]}}";

  for (size_t i = 0; i < 10; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetRemoteObjectError) {
  const char* buf = "let f=()=>{return Error();};f();";
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_error.js", LEPUS_EVAL_TYPE_GLOBAL);
  HandleScope func_scope(ctx_, &ret, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue ret_obj = GetRemoteObject(ctx_, ret, true, true);  // free num1
  func_scope.PushHandle(&ret_obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue ret_json = LEPUS_ToJSON(ctx_, ret_obj, 0);
  func_scope.PushHandle(&ret_json, HANDLE_TYPE_LEPUS_VALUE);
  const char* ret_str = LEPUS_ToCString(ctx_, ret_json);
  std::string ret_string = ret_str;
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret_obj);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret_json);
  std::string ret_gt =
      R"(Error    at f (test_error.js:1:26)\n    at <eval> (test_error.js:1:32)\n)";
  std::cout << ret_str << std::endl;
  ASSERT_TRUE(ret_string.find(ret_gt) != std::string::npos);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, ret_str);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPropertiesMap) {
  const char* buf = R"(function test() {
    let my_map = new Map();
    my_map.set("test", "和键'test'关联的值");
    my_map.set("test2", "和键'test2'关联的值");
    console.log(my_map);

    const wm1 = new WeakMap();
    let john = {name: "John"};
    wm1.set(john, "...");
    console.log(wm1);
    return;
  }
  test();
  )";

  PrepareGetProperties(rt_, 10);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"my_map\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"subtype\":\"map\",\"type\":\"object\",\"objectId\":\".*\","
      "\"className\":\"Map\",\"description\":\"Map\\(2\\)\",\"preview\":\\{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"map\","
      "\"description\":\"Map\\(2\\)\",\"entries\":\\[\\{\"key\":\\{\"type\":"
      "\"string\","
      "\"description\":\"test\",\"overflow\":false,\"properties\":\\[\\]\\},"
      "\"value\":\\{\"type\":\"string\",\"description\":\"和键'test'关联的值\","
      "\"overflow\":false,\"properties\":\\[\\]\\}\\},\\{\"key\":\\{\"type\":"
      "\"string\","
      "\"description\":\"test2\",\"overflow\":false,\"properties\":\\[\\]\\},"
      "\"value\":\\{\"type\":\"string\",\"description\":\"和键'test2'"
      "关联的值\","
      "\"overflow\":false,\"properties\":\\[\\]\\}\\}\\]\\}\\}\\},\\{\"name\":"
      "\"wm1\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"subtype\":\"weakmap\",\"type\":\"object\",\"objectId\":\".*\","
      "\"className\":\"WeakMap\",\"description\":\"WeakMap\\(1\\)\","
      "\"preview\":\\{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"weakmap\","
      "\"description\":\"WeakMap\\(1\\)\",\"entries\":\\[\\{\"key\":\\{"
      "\"type\":"
      "\"object\",\"description\":\"Object\",\"overflow\":false,\"properties\":"
      "\\[\\]\\},\"value\":\\{\"type\":\"string\",\"description\":\"\\.\\.\\."
      "\",\"overflow\":"
      "false,\"properties\":\\[\\]\\}\\}\\]\\}\\}\\},\\{\"name\":\"john\","
      "\"configurable\":true,"
      "\"enumerable\":true,\"writable\":true,\"value\":\\{\"type\":\"object\","
      "\"objectId\":\".*\",\"className\":\"Object\",\"description\":\"Object\","
      "\"preview\":\\{\"overflow\":false,\"type\":\"object\",\"description\":"
      "\"Object\",\"properties\":\\[\\{\"value\":\"John\",\"type\":\"string\","
      "\"name\":\"name\"\\}\\]\\}\\}\\}\\]\\}\\}";

  std::string properties_pattern2 =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"my_map\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"subtype\":\"map\",\"type\":\"object\",\"objectId\":\".*\","
      "\"className\":\"Map\",\"description\":\"Map\\(2\\)\",\"preview\":\\{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"map\","
      "\"description\":\"Map\\(2\\)\",\"entries\":\\[\\{\"key\":\\{\"type\":"
      "\"string\","
      "\"description\":\"test2\",\"overflow\":false,\"properties\":\\[\\]\\},"
      "\"value\":\\{\"type\":\"string\",\"description\":\"和键'test2'"
      "关联的值\","
      "\"overflow\":false,\"properties\":\\[\\]\\}\\},\\{\"key\":\\{\"type\":"
      "\"string\","
      "\"description\":\"test\",\"overflow\":false,\"properties\":\\[\\]\\},"
      "\"value\":\\{\"type\":\"string\",\"description\":\"和键'test'"
      "关联的值\","
      "\"overflow\":false,\"properties\":\\[\\]\\}\\}\\]\\}\\}\\},\\{\"name\":"
      "\"wm1\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"subtype\":\"weakmap\",\"type\":\"object\",\"objectId\":\".*\","
      "\"className\":\"WeakMap\",\"description\":\"WeakMap\\(1\\)\","
      "\"preview\":\\{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"weakmap\","
      "\"description\":\"WeakMap\\(1\\)\",\"entries\":\\[\\{\"key\":\\{"
      "\"type\":"
      "\"object\",\"description\":\"Object\",\"overflow\":false,\"properties\":"
      "\\[\\]\\},\"value\":\\{\"type\":\"string\",\"description\":\"\\.\\.\\."
      "\",\"overflow\":"
      "false,\"properties\":\\[\\]\\}\\}\\]\\}\\}\\},\\{\"name\":\"john\","
      "\"configurable\":true,"
      "\"enumerable\":true,\"writable\":true,\"value\":\\{\"type\":\"object\","
      "\"objectId\":\".*\",\"className\":\"Object\",\"description\":\"Object\","
      "\"preview\":\\{\"overflow\":false,\"type\":\"object\",\"description\":"
      "\"Object\",\"properties\":\\[\\{\"value\":\"John\",\"type\":\"string\","
      "\"name\":\"name\"\\}\\]\\}\\}\\}\\]\\}\\}";

  for (size_t i = 0; i < 10; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  std::cout << properties_pattern << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern)) ||
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern2));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPropertiesPromiseReject) {
  const char* buf = R"(function test() {
    const isItDoneYet = new Promise((resolve, reject) => {
    if (done) {
      const workDone = '这是创建的东西'
      resolve(workDone)
    } else {
      const why = '仍然在处理其他事情'
      reject(why)
    }
    })
    console.log("end function");
    return;
  }
  test();
  )";

  PrepareGetProperties(rt_, 11);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"isItDoneYet\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"subtype\":\"promise\",\"type\":\"object\",\"objectId\":\".*\","
      "\"className\":\"Promise\",\"description\":\"Promise\",\"preview\":\\{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"promise\","
      "\"description\":\"Promise\",\"properties\":\\[\\{\"name\":\"\\[\\["
      "PromiseState\\]\\]"
      "\",\"value\":\\{\"value\":\"rejected\",\"type\":\"string\"\\}\\},\\{"
      "\"name\":\"\\["
      "\\[PromiseResult\\]\\]\",\"value\":\\{\"subtype\":\"error\",\"type\":"
      "\"object\","
      "\"objectId\":\".*\",\"className\":\"ReferenceError: done is not "
      "defined\",\"description\":\"ReferenceError: done is not defined    at "
      "\\<anonymous\\> \\(test_get_properties.js:3:9\\)\\\\n    at Promise "
      "\\(native\\)\\\\n   "
      " at test \\(test_get_properties.js:11:5\\)\\\\n    at \\<eval\\> "
      "\\(test_get_properties.js:14:9\\)\\\\n\"\\}\\}\\]\\}\\}\\}\\]\\}\\}";

  std::string properties_gt =
      "{\"id\":48,\"result\":{\"result\":[{\"name\":\"isItDoneYet\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":{"
      "\"subtype\":\"promise\",\"type\":\"object\",\"objectId\":\"10\","
      "\"className\":\"Promise\",\"description\":\"Promise\",\"preview\":{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"promise\","
      "\"description\":\"Promise\",\"properties\":[{\"name\":\"[[PromiseState]]"
      "\",\"value\":{\"value\":\"rejected\",\"type\":\"string\"}},{\"name\":\"["
      "[PromiseResult]]\",\"value\":{\"subtype\":\"error\",\"type\":\"object\","
      "\"objectId\":\"11\",\"className\":\"ReferenceError: done is not "
      "defined\",\"description\":\"ReferenceError: done is not defined    at "
      "<anonymous> (test_get_properties.js:3:9)\\n    at Promise (native)\\n   "
      " at test (test_get_properties.js:11:5)\\n    at <eval> "
      "(test_get_properties.js:14:9)\\n\"}}]}}}]}}";

  for (size_t i = 0; i < 9; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPropertiesPromiseFulfill) {
  const char* buf = R"(function test() {
    const done = true;
    const isItDoneYet = new Promise((resolve, reject) => {
    if (done) {
      const workDone = '这是创建的东西'
      resolve(workDone)
    } else {
      const why = '仍然在处理其他事情'
      reject(why)
    }
    })
    console.log("end function");
    return;
  }
  test();
  )";

  PrepareGetProperties(rt_, 12);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"done\","
      "\"configurable\":"
      "true,\"enumerable\":true,\"writable\":true,\"value\":\\{\"value\":true,"
      "\"type\":\"boolean\"\\}\\},\\{\"name\":\"isItDoneYet\",\"configurable\":"
      "true,"
      "\"enumerable\":true,\"writable\":true,\"value\":\\{\"subtype\":"
      "\"promise\",\"type\":\"object\",\"objectId\":\".*\",\"className\":"
      "\"Promise\",\"description\":\"Promise\",\"preview\":\\{\"overflow\":"
      "false,"
      "\"type\":\"object\",\"subtype\":\"promise\",\"description\":\"Promise\","
      "\"properties\":\\[\\{\"name\":\"\\[\\[PromiseState\\]\\]\",\"value\":\\{"
      "\"value\":"
      "\"fulfilled\",\"type\":\"string\"\\}\\},\\{\"name\":\"\\[\\["
      "PromiseResult\\]\\]\","
      "\"value\":\\{\"value\":\"这是创建的东西\",\"type\":\"string\"\\}\\}\\]"
      "\\}\\}\\}\\]\\}\\}";

  std::string properties_gt =
      "{\"id\":48,\"result\":{\"result\":[{\"name\":\"done\",\"configurable\":"
      "true,\"enumerable\":true,\"writable\":true,\"value\":{\"value\":true,"
      "\"type\":\"boolean\"}},{\"name\":\"isItDoneYet\",\"configurable\":true,"
      "\"enumerable\":true,\"writable\":true,\"value\":{\"subtype\":"
      "\"promise\",\"type\":\"object\",\"objectId\":\"10\",\"className\":"
      "\"Promise\",\"description\":\"Promise\",\"preview\":{\"overflow\":false,"
      "\"type\":\"object\",\"subtype\":\"promise\",\"description\":\"Promise\","
      "\"properties\":[{\"name\":\"[[PromiseState]]\",\"value\":{\"value\":"
      "\"fulfilled\",\"type\":\"string\"}},{\"name\":\"[[PromiseResult]]\","
      "\"value\":{\"value\":\"这是创建的东西\",\"type\":\"string\"}}]}}}]}}";

  for (size_t i = 0; i < 9; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPropertiesProxy) {
  const char* buf = R"(function test() {
    const handler = {
      get: function(obj, prop) {
          return prop in obj ? obj[prop] : 37;
      }
    };

    const p = new Proxy({}, handler);
    console.log(p);
    console.log("end function");
    return;
  }

  test();
  )";

  PrepareGetProperties(rt_, 10);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"handler\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"type\":\"object\",\"objectId\":\".*\",\"className\":\"Object\","
      "\"description\":\"Object\",\"preview\":\\{\"overflow\":false,\"type\":"
      "\"object\",\"description\":\"Object\",\"properties\":\\[\\{\"type\":"
      "\"function\",\"name\":\"get\",\"value\":\\{\"type\":\"function\","
      "\"objectId\":\".*\",\"className\":\"Function\",\"description\":"
      "\"function\\(obj, prop\\) \\{\\\\n          return prop in obj \\? "
      "obj\\[prop\\] : 37;\\\\n      \\}\"\\}\\}\\]\\}\\}\\},\\{\"name\":"
      "\"p\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"subtype\":\"proxy\",\"type\":\"object\",\"objectId\":\".*\","
      "\"className\":\"Proxy\",\"description\":\"Proxy\",\"preview\":\\{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"proxy\","
      "\"description\":\"Proxy\",\"properties\":\\[\\]\\}\\}\\}\\]\\}\\}";

  for (size_t i = 0; i < 10; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetInternalPropertiesProxy) {
  const char* buf = R"(function test() {
    const handler = {
      get: function(obj, prop) {
          return prop in obj ? obj[prop] : 37;
      }
    };

    const p = new Proxy({}, handler);
    console.log(p);
    console.log("end function");
    return;
  }

  test();
  )";

  PrepareGetInternalProperties(rt_, 10);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      "\\{\"id\":49,\"result\":\\{\"result\":\\[\\{\"name\":\"__proto__\","
      "\"configurable\":true,\"enumerable\":false,\"writable\":true,\"value\":"
      "\\{\"type\":\"object\",\"objectId\":\".*\",\"className\":\"Object\","
      "\"description\":\"Object\",\"preview\":\\{\"overflow\":false,\"type\":"
      "\"object\",\"description\":\"Object\",\"properties\":\\[\\{\"type\":"
      "\"function\",\"name\":\"toString\","
      "\"value\":\\{\"type\":\"function\",\"objectId\":\".*\",\"className\":"
      "\"Function\",\"description\":\"function toString\\(\\) \\{\\\\n    "
      "\\[native code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":"
      "\"toLocaleString\",\"value\":\\{\"type\":\"function\",\"objectId\":\".*"
      "\",\"className\":\"Function\",\"description\":\"function "
      "toLocaleString\\(\\) \\{\\\\n    \\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":\"valueOf\","
      "\"value\":\\{\"type\":\"function\",\"objectId\":\".*\",\"className\":"
      "\"Function\",\"description\":\"function valueOf\\(\\) \\{\\\\n    "
      "\\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":"
      "\"hasOwnProperty\",\"value\":\\{\"type\":\"function\",\"objectId\":\".*"
      "\",\"className\":\"Function\",\"description\":\"function "
      "hasOwnProperty\\(\\) \\{\\\\n    \\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":"
      "\"isPrototypeOf\",\"value\":\\{\"type\":\"function\",\"objectId\":\".*"
      "\",\"className\":\"Function\",\"description\":\"function "
      "isPrototypeOf\\(\\) \\{\\\\n    \\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":"
      "\"propertyIsEnumerable\",\"value\":\\{\"type\":\"function\","
      "\"objectId\":\".*\",\"className\":\"Function\",\"description\":"
      "\"function propertyIsEnumerable\\(\\) \\{\\\\n    \\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":\"get\","
      "\"value\":\\{\"type\":\"function\",\"objectId\":\".*\",\"className\":"
      "\"Function\",\"description\":\"function get __proto__\\(\\) \\{\\\\n    "
      "\\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":\"set\","
      "\"value\":\\{\"type\":\"function\",\"objectId\":\".*\",\"className\":"
      "\"Function\",\"description\":\"function set __proto__\\(\\) \\{\\\\n    "
      "\\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":\"__"
      "defineGetter__\",\"value\":\\{\"type\":\"function\",\"objectId\":\".*\","
      "\"className\":\"Function\",\"description\":\"function "
      "__defineGetter__\\(\\) \\{\\\\n    \\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":\"__"
      "defineSetter__\",\"value\":\\{\"type\":\"function\",\"objectId\":\".*\","
      "\"className\":\"Function\",\"description\":\"function "
      "__defineSetter__\\(\\) \\{\\\\n    \\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":\"__"
      "lookupGetter__\",\"value\":\\{\"type\":\"function\",\"objectId\":\".*\","
      "\"className\":\"Function\",\"description\":\"function "
      "__lookupGetter__\\(\\) \\{\\\\n    \\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":\"__"
      "lookupSetter__\",\"value\":\\{\"type\":\"function\",\"objectId\":\".*\","
      "\"className\":\"Function\",\"description\":\"function "
      "__lookupSetter__\\(\\) \\{\\\\n    \\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":"
      "\"function\",\"name\":\"constructor\",\"value\":\\{\"type\":"
      "\"function\",\"objectId\":\".*\",\"className\":\"Function\","
      "\"description\":\"function Object\\(\\) \\{\\\\n    \\[native "
      "code\\]\\\\n\\}\"\\}\\}\\]\\}\\}\\}\\],\"internalProperties\":\\[\\{"
      "\"name\":\"\\[\\[Handler\\]\\]\",\"value\":\\{\"type\":\"object\","
      "\"objectId\":\".*\",\"className\":\"Object\",\"description\":"
      "\"Object\"\\}\\},\\{\"name\":\"\\[\\[Target\\]\\]\",\"value\":\\{"
      "\"type\":\"object\",\"objectId\":\".*\",\"className\":\"Object\","
      "\"description\":\"Object\"\\}\\},\\{\"name\":\"\\[\\[IsRevoked\\]\\]\","
      "\"value\":\\{\"value\":false,\"type\":\"boolean\"\\}\\}\\]\\}\\}";

  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPropertiesTypedArray) {
  const char* buf = R"(function test() {
    const typedArray1 = new Int8Array(8);
    console.log("end function");
    return;
  }
  test();
  )";

  PrepareGetProperties(rt_, 3);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"typedArray1\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"subtype\":\"typedarray\",\"type\":\"object\",\"objectId\":\".*\","
      "\"className\":\"Int8Array\",\"description\":\"Int8Array\\(0\\)\","
      "\"preview\":\\{\"overflow\":false,\"type\":\"object\",\"subtype\":"
      "\"typedarray\",\"description\":\"Int8Array\\(0\\)\",\"properties\":\\["
      "\\{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"0\"\\},"
      "\\{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"1\"\\},"
      "\\{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"2\"\\},"
      "\\{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"3\"\\},"
      "\\{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"4\"\\},"
      "\\{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"5\"\\},"
      "\\{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"6\"\\},"
      "\\{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"7\"\\}"
      "\\]\\}\\}"
      "\\}\\]\\}\\}";

  std::string properties_gt =
      "{\"id\":48,\"result\":{\"result\":[{\"name\":\"typedArray1\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":{"
      "\"subtype\":\"typedarray\",\"type\":\"object\",\"objectId\":\"10\","
      "\"className\":\"Int8Array\",\"description\":\"Int8Array(0)\","
      "\"preview\":{\"overflow\":false,\"type\":\"object\",\"subtype\":"
      "\"typedarray\",\"description\":\"Int8Array(0)\",\"properties\":[{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"0\"},{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"1\"},{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"2\"},{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"3\"},{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"4\"},{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"5\"},{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"6\"},{"
      "\"description\":\"0\",\"value\":0,\"type\":\"number\",\"name\":\"7\"}]}}"
      "}]}}";

  for (size_t i = 0; i < 9; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;

  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPropertiesArrayBuffer) {
  const char* buf = R"(function test() {
    const buffer = new ArrayBuffer(8);
    console.log("end function");
    return;
  }
  test();
  )";

  PrepareGetProperties(rt_, 3);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"buffer\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"subtype\":\"arraybuffer\",\"type\":\"object\",\"objectId\":\".*\","
      "\"className\":\"ArrayBuffer\",\"description\":\"ArrayBuffer\\(8\\)\","
      "\"preview\":\\{\"overflow\":false,\"type\":\"object\",\"subtype\":"
      "\"arraybuffer\",\"description\":\"ArrayBuffer\\(8\\)\",\"properties\":"
      "\\[\\]\\}\\}\\}\\]"
      "\\}\\}";

  std::string properties_gt =
      "{\"id\":48,\"result\":{\"result\":[{\"name\":\"buffer\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":{"
      "\"subtype\":\"arraybuffer\",\"type\":\"object\",\"objectId\":\"10\","
      "\"className\":\"ArrayBuffer\",\"description\":\"ArrayBuffer(8)\","
      "\"preview\":{\"overflow\":false,\"type\":\"object\",\"subtype\":"
      "\"arraybuffer\",\"description\":\"ArrayBuffer(8)\",\"properties\":[]}}}]"
      "}}";

  for (size_t i = 0; i < 9; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;

  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPropertiesDataView) {
  const char* buf = R"(function test() {
    const buffer = new ArrayBuffer(16);
    const view = new DataView(buffer,12,4);
    console.log("end function");
    return;
  }
  test();
  )";

  PrepareGetProperties(rt_, 4);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"buffer\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"subtype\":\"arraybuffer\",\"type\":\"object\",\"objectId\":\".*\","
      "\"className\":\"ArrayBuffer\",\"description\":\"ArrayBuffer\\(16\\)\","
      "\"preview\":\\{\"overflow\":false,\"type\":\"object\",\"subtype\":"
      "\"arraybuffer\",\"description\":\"ArrayBuffer\\(16\\)\",\"properties\":"
      "\\[\\]\\}\\}\\}"
      ",\\{\"name\":\"view\",\"configurable\":true,\"enumerable\":true,"
      "\"writable\":true,\"value\":\\{\"subtype\":\"dataview\",\"type\":"
      "\"object\",\"objectId\":\".*\",\"className\":\"DataView\","
      "\"description\":\"DataView\\(4\\)\",\"preview\":\\{\"overflow\":false,"
      "\"type\":\"object\",\"subtype\":\"dataview\",\"description\":"
      "\"DataView\\("
      "4\\)\",\"properties\":\\[\\]\\}\\}\\}\\]\\}\\}";

  std::string properties_gt =
      "{\"id\":48,\"result\":{\"result\":[{\"name\":\"buffer\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":{"
      "\"subtype\":\"arraybuffer\",\"type\":\"object\",\"objectId\":\"10\","
      "\"className\":\"ArrayBuffer\",\"description\":\"ArrayBuffer(16)\","
      "\"preview\":{\"overflow\":false,\"type\":\"object\",\"subtype\":"
      "\"arraybuffer\",\"description\":\"ArrayBuffer(16)\",\"properties\":[]}}}"
      ",{\"name\":\"view\",\"configurable\":true,\"enumerable\":true,"
      "\"writable\":true,\"value\":{\"subtype\":\"dataview\",\"type\":"
      "\"object\",\"objectId\":\"11\",\"className\":\"DataView\","
      "\"description\":\"DataView(4)\",\"preview\":{\"overflow\":false,"
      "\"type\":\"object\",\"subtype\":\"dataview\",\"description\":\"DataView("
      "4)\",\"properties\":[]}}}]}}";

  for (size_t i = 0; i < 9; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;

  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPropertiesSymbol) {
  const char* buf = R"(function test() {
    const uniqueSymbol = Symbol('<key>');
    const sharedSymbol = Symbol.for('<key>');
    console.log("end function");
    return;
  }
  test();
  )";

  PrepareGetProperties(rt_, 4);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_gt =
      "{\"id\":48,\"result\":{\"result\":[{\"name\":\"uniqueSymbol\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":{"
      "\"description\":\"Symbol(<key>)\",\"type\":\"symbol\"}},{\"name\":"
      "\"sharedSymbol\",\"configurable\":true,\"enumerable\":true,\"writable\":"
      "true,\"value\":{\"description\":\"Symbol(<key>)\",\"type\":\"symbol\"}}]"
      "}}";

  for (size_t i = 0; i < 9; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;

  ASSERT_TRUE(QjsDebugQueue::GetReceiveMessageQueue().front() == properties_gt);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetPropertiesGenerator) {
  const char* buf = R"(function test() {
    function* makeRangeIterator(start = 0, end = Infinity, step = 1) {
      for (let i = start; i < end; i += step) {
        yield i;
      }
    }
    var gen = makeRangeIterator(1,10,2);
    console.log("end function");
    return;
  }
  test();
  )";

  PrepareGetProperties(rt_, 8);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":"
      "\"makeRangeIterator\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{"
      "\"type\":\"function\",\"objectId\":\".*\",\"className\":"
      "\"GeneratorFunction\",\"description\":\"function\\* "
      "makeRangeIterator\\(start = 0, end = Infinity, step = 1\\) \\{\\\\n     "
      " for "
      "\\(let i = start; i < end; i \\+= step\\) \\{\\\\n        yield i;\\\\n "
      "     \\}\\\\n   "
      " \\}\"\\}\\},\\{\"name\":\"gen\",\"configurable\":true,\"enumerable\":"
      "true,"
      "\"writable\":true,\"value\":\\{\"subtype\":\"generator\",\"type\":"
      "\"object\",\"objectId\":\".*\",\"className\":\"Generator\","
      "\"description\":\"makeRangeIterator\",\"preview\":\\{\"overflow\":false,"
      "\"type\":\"object\",\"subtype\":\"generator\",\"description\":"
      "\"makeRangeIterator\",\"properties\":\\[\\]\\}\\}\\}\\]\\}"
      "\\}";

  for (size_t i = 0; i < 9; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;

  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, QJSDebugTestConsole) {
  const char* buf = R"(function test() {
    console.log("log");
    console.info("info");
    console.debug("debug");
    console.error("error");
    console.warn("warning");
    console.alog("log");
    console.profile("");
    console.profileEnd("");
    console.report("log");
  }
  test();
  )";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":2,"method":"Runtime.enable","params":{"view_id":1}})");

  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_console.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string properties_gt = "";

  for (size_t i = 0; i < 5; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  const char* tag_table_test[] = {"log", "info", "debug", "error", "warning",
                                  "log", "",     "",      "log"};
  LEPUSValue val = LEPUS_UNDEFINED;
  HandleScope func_scope(ctx_, &val, HANDLE_TYPE_LEPUS_VALUE);
  for (size_t i = 0; i < 9; i++) {
    std::string message = QjsDebugQueue::GetReceiveMessageQueue().front();
    val = LEPUS_ParseJSON(ctx_, message.c_str(), message.length(), "");
    LEPUSValue params = LEPUS_GetPropertyStr(ctx_, val, "params");
    LEPUSValue args = LEPUS_GetPropertyStr(ctx_, params, "args");
    LEPUSValue args1 = LEPUS_GetPropertyUint32(ctx_, args, 0);
    LEPUSValue value = LEPUS_GetPropertyStr(ctx_, args1, "value");
    const char* value_str = LEPUS_ToCString(ctx_, value);
    if (*tag_table_test[i] != '\0') {
      std::string value_string(value_str);
      std::cout << "result: " << value_string << std::endl;
      std::cout << "gt: " << tag_table_test[i] << std::endl;
      ASSERT_TRUE(value_string == tag_table_test[i]);
      QjsDebugQueue::GetReceiveMessageQueue().pop();
    }
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, params);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, args);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, args1);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, value);
    if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, value_str);
  }
}

TEST_F(QjsDebugMethods, QJSDebugTestEmptyURL) {
  const char* buf = R"(function test() {
    function* makeRangeIterator(start = 0, end = Infinity, step = 1) {
      for (let i = start; i < end; i += step) {
        yield i;
      }
    }
    var gen = makeRangeIterator(1,10,2);
    console.log("end function");
  }
  test();
  )";

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
      "{\"id\":3,\"method\":\"Debugger.getPossibleBreakpoints\",\"params\":{"
      "\"start\":{\"scriptId\":\"1\",\"lineNumber\":4,\"columnNumber\":0},"
      "\"end\":{\"scriptId\":\"1\",\"lineNumber\":5,\"columnNumber\":0},"
      "\"restrictToFunction\":false}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":4,\"method\":\"Debugger.setBreakpointByUrl\",\"params\":{"
      "\"lineNumber\":4,\"columnNumber\":0,\"condition\":\"\"}}");

  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf), "",
                              LEPUS_EVAL_TYPE_GLOBAL);

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(QjsDebugMethods, QJSDebugTestEmptyURL2) {
  const char* buf = R"(function test() {
    function* makeRangeIterator(start = 0, end = Infinity, step = 1) {
      for (let i = start; i < end; i += step) {
        yield i;
      }
    }
    var gen = makeRangeIterator(1,10,2);
    console.log("end function");
  }
  test();
  )";

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
      "{\"id\":3,\"method\":\"Debugger.getPossibleBreakpoints\",\"params\":{"
      "\"start\":{\"scriptId\":\"1\",\"lineNumber\":4,\"columnNumber\":0},"
      "\"end\":{\"scriptId\":\"1\",\"lineNumber\":5,\"columnNumber\":0},"
      "\"restrictToFunction\":false}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":4,\"method\":\"Debugger.setBreakpointByUrl\",\"params\":{"
      "\"lineNumber\":4,\"columnNumber\":0,\"condition\":\"\" , \"scriptId\": "
      "\"1\"}}");

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":5,\"method\":\"Debugger.setBreakpointByUrl\",\"params\":{"
      "\"lineNumber\":4,\"columnNumber\":0,\"condition\":\"\", \"scriptId\": "
      "\"1\"}}");
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf), "",
                              LEPUS_EVAL_TYPE_GLOBAL);

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(QjsDebugMethods, TestGetScriptByScriptURL) {
  GetScriptByScriptURL(ctx_, GetScriptURLByScriptId(ctx_, -1));
}

TEST_F(QjsDebugMethods, TestStopAtEntryStepOverByInstruction) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}, \"view_id\":2}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}, \"view_id\": 2}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2, "
      "\"method\":\"Debugger.stopAtEntry\",\"params\":{"
      "\"stepOverByInstruction\": true}, \"view_id\": 2}");

  const char* buf = R"(function test() {
    console.log("hahaha");
    let a = 1;
    console.log(a++);
  }
  test();
  )";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_step_over_by_instruction.js",
                 LEPUS_EVAL_TYPE_GLOBAL);

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(QjsDebugMethods, TestStopAtEntryWithoutStepOverByInstruction) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}, \"view_id\":2}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}, \"view_id\": 2}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2, \"method\":\"Debugger.stopAtEntry\", \"view_id\": 2}");

  const char* buf = R"(function test() {
    console.log("hahaha");
    let a = 1;
    console.log(a++);
  }
  test();
  )";
  LEPUSValue ret = LEPUS_Eval(ctx_, buf, strlen(buf),
                              "test_without_step_over_by_instruction.js",
                              LEPUS_EVAL_TYPE_GLOBAL);

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(QjsDebugMethods, TestBreakpointsEqual) {
  auto info = GetDebuggerInfo(ctx_);
  LEPUSBreakpoint* new_breakpoint =
      AddBreakpoint(info, "test_breakpoint.js", NULL, 12, 0, 1, "", 0);
  LEPUSValue condition = LEPUS_NULL;
  bool res = IsBreakpointEqual(ctx_, new_breakpoint, 1, "test_breakpoint.js",
                               12, 0, condition);
  ASSERT_TRUE(res == true);

  res = IsBreakpointEqual(ctx_, new_breakpoint, -1, "test_breakpoint.js", 12, 0,
                          LEPUS_NULL);
  ASSERT_TRUE(res == false);

  res = IsBreakpointEqual(ctx_, new_breakpoint, 1, "test_breakpoint.js", 1, 0,
                          LEPUS_NULL);
  ASSERT_TRUE(res == false);

  res = IsBreakpointEqual(ctx_, new_breakpoint, 1, "test_breakpoint.js", 12, 2,
                          LEPUS_NULL);
  ASSERT_TRUE(res == false);

  condition = LEPUS_NewString(ctx_, "a == 1");
  res = IsBreakpointEqual(ctx_, new_breakpoint, 1, "test_breakpoint.js", 12, 2,
                          condition);
  ASSERT_TRUE(res == false);

  LEPUSBreakpoint* new_breakpoint2 =
      AddBreakpoint(info, "test_breakpoint2.js", NULL, 12, 0, 1, "a == 1", 0);
  res = IsBreakpointEqual(ctx_, new_breakpoint2, 1, "test_breakpoint2.js", 12,
                          0, condition);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, condition);
  ASSERT_TRUE(res == true);

  int32_t bp_num = info->breakpoints_num;
  for (int32_t i = 0; i < bp_num; i++) {
    DeleteBreakpoint(info, i);
  }
}

TEST_F(QjsDebugMethods, TestCallFunctionOn) {
  const char* buf = R"(
    console.log("hahaha");
    let global_a = {
      one: 1,
      two: 2,
      three: [1,2,3],
      four: true
    };
    console.log(global_a);
  )";
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");

  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_call_function_on.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Runtime.compileScript\",\"params\":{"
      "\"expression\":\"global_a\", \"sourceURL\": \"\", \"persistScript\": "
      "false, \"executionContextId\": 0}}");

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":3,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"global_a\", \"includeCommandLineAPI\": true, "
      "\"generatePreview\": true, \"useGesture\": false, "
      "\"throwOnSideEffect\":true, \"disableBreaks\":true}}");

  const char* trigger1 = "function trigger() {}; trigger();\n";
  LEPUSValue ret1 = LEPUS_Eval(ctx_, trigger1, strlen(trigger1),
                               "trigger_debugger.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret1);

  for (size_t i = 0; i < 5; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::string evaluate_result = QjsDebugQueue::GetReceiveMessageQueue().front();
  QjsDebugQueue::GetReceiveMessageQueue().pop();

  LEPUSValue evaluate_val = LEPUS_ParseJSON(ctx_, evaluate_result.c_str(),
                                            evaluate_result.length(), "");
  HandleScope func_scope(ctx_, &evaluate_val, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue res1 = LEPUS_GetPropertyStr(ctx_, evaluate_val, "result");
  LEPUSValue res2 = LEPUS_GetPropertyStr(ctx_, res1, "result");
  LEPUSValue obj_id = LEPUS_GetPropertyStr(ctx_, res2, "objectId");
  const char* obj_id_str = LEPUS_ToCString(ctx_, obj_id);

  std::string declaration =
      "function i(t){let e;e=\\\"string\\\"===t?new "
      "String(\\\"\\\"):\\\"number\\\"===t?new "
      "Number(0):\\\"bigint\\\"===t?Object(BigInt(0)):\\\"boolean\\\"===t?new "
      "Boolean(!1):this;const s=[];try{for(let "
      "i=e;i;i=Object.getPrototypeOf(i)){if((\\\"array\\\"===t||"
      "\\\"typedarray\\\"===t)&&i===e&&i.length>9999)continue;const "
      "n={items:[],title:void 0,__proto__:null};try{\\\"object\\\"==typeof "
      "i&&Object.prototype.hasOwnProperty.call(i,\\\"constructor\\\")&&i."
      "constructor&&i.constructor.name&&(n.title=i.constructor.name)}catch(t){}"
      "s[s.length]=n;const "
      "o=Object.getOwnPropertyNames(i),r=Array.isArray(i);for(let "
      "t=0;t<o.length&&n.items.length<1e4;++t)r&&/^[0-9]/"
      ".test(o[t])||(n.items[n.items.length]=o[t])}}catch(t){}return s}";
  std::string call_function_on_msg =
      "{\"id\":5,\"method\":\"Runtime.callFunctionOn\",\"params\":{"
      "\"functionDeclaration\":\"" +
      declaration +
      "\", \"returnByValue\": true, \"slient\": true, \"arguments\": [{}], "
      "\"objectId\":\"" +
      std::string(obj_id_str) + "\"}}";

  std::cout << "function declaration: " << call_function_on_msg << std::endl;
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, evaluate_val);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, res1);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, res2);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, obj_id);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, obj_id_str);

  QjsDebugQueue::GetSendMessageQueue().push(call_function_on_msg);

  const char* trigger2 = "function trigger2() {}; trigger2();\n";
  LEPUSValue ret2 = LEPUS_Eval(ctx_, trigger2, strlen(trigger2),
                               "trigger_debugger2.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret2);
  std::string gt =
      "{\"id\":5,\"result\":{\"result\":{\"subtype\":\"array\",\"value\":[{"
      "\"items\":[\"one\",\"two\",\"three\",\"four\"]},{\"items\":["
      "\"constructor\",\"toString\",\"toLocaleString\",\"valueOf\","
      "\"hasOwnProperty\",\"isPrototypeOf\",\"propertyIsEnumerable\",\"__proto_"
      "_\",\"__defineGetter__\",\"__defineSetter__\",\"__lookupGetter__\",\"__"
      "lookupSetter__\"],\"title\":\"Object\"}],\"type\":\"object\","
      "\"objectId\":\"4509364992\",\"className\":\"Array\",\"description\":"
      "\"Array(2)\"}}}";
  std::string pattern =
      "\\{\"id\":5,\"result\":\\{\"result\":\\{\"subtype\":\"array\",\"value\":"
      "\\[\\{\"items\":\\[\"one\",\"two\",\"three\",\"four\"\\]\\},\\{"
      "\"items\":\\[\"toString\",\"toLocaleString\","
      "\"valueOf\",\"hasOwnProperty\",\"isPrototypeOf\","
      "\"propertyIsEnumerable\",\"__proto__\",\"__defineGetter__\",\"__"
      "defineSetter__\",\"__lookupGetter__\",\"__lookupSetter__\","
      "\"constructor\"\\],\"title\":"
      "\"Object\"\\}\\],\"type\":\"object\",\"objectId\":\".*\",\"className\":"
      "\"Array\",\"description\":\"Array\\(2\\)\"\\}\\}\\}";
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  std::cout << "test zy: " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  bool match_res = std::regex_match(
      QjsDebugQueue::GetReceiveMessageQueue().front(), std::regex(pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, TestRuntime) {
  const char* buf = R"(let res=0;
try{
    let a=1;
    if(a==1)throw "pause failed";
  }catch(e)
  {
    res=1;
  })";
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":0,"method":"Runtime.disable"})");
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":1,"method":"Runtime.enable","params":{"view_id":1}})");
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":2,"method":"Runtime.discardConsoleEntries"})");
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":3,"method":"Runtime.evaluate","params":{"expression":"console.log(Promise);throw 'qwq';"}})");
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":4,"method":"Runtime.compileScript","params":{"expression":"function f(){return 1;}","sourceURL":"temp.js","persistScript":false}})");
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":5,"method":"Runtime.callFunctionOn","params":{"functionDeclaration":"()=>{console.log('test')}"}})");
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":6,"method":"Runtime.globalLexicalScopeNames"})");

  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_pause.js", LEPUS_EVAL_TYPE_GLOBAL);

  std::string message;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    message = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::string expect_message =
      R"({"id":3,"result":{"result":{"value":"qwq","type":"string"}}})";
  ASSERT_TRUE(message.find(expect_message) != std::string::npos);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  QjsDebugQueue::GetSendMessageQueue().push(
      R"({"id":7,"method":"Runtime.runScript","params":{"scriptId":1,"silent":true}})");
  const char* buf1 = "function trigger(){}; trigger();\n";
  ret = LEPUS_Eval(ctx_, buf1, strlen(buf1), "trigger_debuger.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(QjsDebugMethods, TestPauseOnException) {
  const char* buf = R"(
    let a = 1;
    a();
  )";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Debugger.setPauseOnExceptions\",\"params\":{"
      "\"state\":\"all\"}}");
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_pause_on_exception.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  for (size_t i = 0; i < 4; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  std::cout << "result: " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  std::string gt_pattern =
      "\\{\"method\":\"Debugger.paused\",\"params\":\\{\"callFrames\":\\[\\{"
      "\"callFrameId\":\"0\",\"functionName\":\"<eval>\",\"url\":\"test_pause_"
      "on_exception.js\",\"location\":\\{\"scriptId\":\"1\",\"lineNumber\":2,"
      "\"columnNumber\":7\\},\"scopeChain\":\\[\\{\"type\":\"local\","
      "\"object\":\\{\"type\":\"object\",\"objectId\":\"scope:1\"\\}\\},\\{"
      "\"type\":"
      "\"global\",\"object\":\\{\"type\":\"object\",\"objectId\":\"scope:0\"\\}"
      "\\}\\]"
      ",\"this\":\\{\"type\":\"object\",\"className\":\"object\","
      "\"description\":\"Global\",\"objectId\":\".*\"\\}\\}\\],\"reason\":"
      "\"exception\",\"data\":\\{\"subtype\":\"error\",\"type\":\"object\","
      "\"objectId\":\".*\",\"className\":\"TypeError: a is not a "
      "function\",\"description\":\"TypeError: a is not a function    at "
      "<eval> "
      "\\(test_pause_on_exception.js:3:8\\)\\\\n\"\\}\\}\\}";
  bool match_res = std::regex_match(
      QjsDebugQueue::GetReceiveMessageQueue().front(), std::regex(gt_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, TestPauseOnException2) {
  const char* buf = R"(
    let a = 1;
    a();
  )";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Debugger.setPauseOnExceptions\",\"params\":{"
      "\"state\":\"all\"}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":3,\"method\":\"Debugger.setBreakpointsActive\",\"params\":{"
      "\"active\":true}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":4,\"method\":\"Debugger.setBreakpointByUrl\",\"params\":{"
      "\"lineNumber\":1,\"url\":\"test_pause_on_exception2.js\","
      "\"columnNumber\":0,\"condition\":\"\"}}");

  PrepareForEvaluateOnPause(rt_);
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_pause_on_exception2.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(QjsDebugMethods, QJSDebugTestGetFunctionName) {
  const char* buf = "(function() {let a = 1; a()})();";
  int eval_flags;
  eval_flags = LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL;
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_function.js", eval_flags);
  LEPUSFunctionBytecode* b =
      static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(ret));
  LEPUSValue func_obj = GetAnonFunc(b);
  if (!LEPUS_IsUndefined(func_obj)) {
    const char* name = GetFunctionName(
        ctx_,
        static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(func_obj)));
    ASSERT_TRUE(!name);
  }
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(QjsDebugMethods, TestGetExceptionDetails) {
  const char* buf = R"(
    console.log("hahaha");
    let global_a = {
      one: 1,
      two: 2,
      three: [1,2,3],
      four: true
    };
    console.log(global_a);
  )";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Debugger.getScriptSource\",\"params\":{"
      "\"scriptId\":1}}");
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_get_exception_details.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":3,\"method\":\"Runtime.compileScript\",\"params\":{"
      "\"expression\":\"var test_failt_to_parse = ;\", \"sourceURL\": \"\", "
      "\"persistScript\": "
      "false, \"executionContextId\": 0}}");

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":4,\"method\":\"Runtime.disable\",\"params\":{}}");
  const char* trigger1 = "function trigger() {}; trigger();\n";
  LEPUSValue ret1 = LEPUS_Eval(ctx_, trigger1, strlen(trigger1),
                               "trigger_debugger.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret1);

  for (size_t i = 0; i < 8; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  std::string exception_pattern =
      "\\{\"id\":3,\"result\":\\{\"exceptionDetails\":\\{\"lineNumber\":0,"
      "\"columnNumber\":0,\"exceptionId\":0,\"exception\":\\{\"subtype\":"
      "\"error\",\"type\":\"object\",\"objectId\":\".*\",\"className\":"
      "\"SyntaxError: unexpected token in expression: "
      "\\';\\'\",\"description\":\"SyntaxError: unexpected token in "
      "expression: \\';\\'    at :1:27\\\\n    at <eval> "
      "\\(trigger_debugger.js:1:0\\)\\\\n\"\\},\"text\":\"uncaught\","
      "\"executionContextId\":0\\}\\}\\}";

  std::cout << "result: " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(exception_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugMethods, TestFailToParse) {
  const char* buf = R"(
    console.log("hahaha");
    let global_a = {
      one: 1,
      two: ,
      three: [1,2,3],
      four: true
    };
    console.log(global_a);
  )";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* trigger = "function trigger() {}; trigger();\n";
  LEPUSValue ret1 = LEPUS_Eval(ctx_, trigger, strlen(trigger),
                               "trigger_debugger.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret1);

  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_get_exception_details.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  for (size_t i = 0; i < 4; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  std::string gt =
      "{\"method\":\"Debugger.scriptFailedToParse\",\"params\":{\"scriptId\":"
      "\"2\",\"url\":\"test_get_exception_details.js\",\"hasSourceURL\":true,"
      "\"startLine\":0,\"endLine\":6,\"startColumn\":0,\"endColumn\":0,"
      "\"executionContextId\":0,\"hash\":\"2487389810742368029\",\"length\":"
      "151,\"scriptLanguage\":\"JavaScript\",\"sourceMapURL\":\"\"}}";
  std::cout << "result: " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  ASSERT_TRUE(QjsDebugQueue::GetReceiveMessageQueue().front() == gt);
}

TEST_F(QjsDebugMethods, TestFindDebuggerMagicContentWithEmptySource) {
  char* source_map_url =
      FindDebuggerMagicContent(ctx_, nullptr, (char*)"sourceMappingURL", 0);

  ASSERT_TRUE(source_map_url == nullptr);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, source_map_url);

  char* source_url =
      FindDebuggerMagicContent(ctx_, nullptr, (char*)"sourceURL", 0);
  ASSERT_TRUE(source_url == nullptr);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, source_url);
}

TEST_F(QjsDebugMethods, TestFindDebuggerMagicContent) {
  std::string source =
      "test js.map"
      "// # sourceURL=error.js\n"
      "//# sourceURL=test_source_url.js\n"
      "// # sourceMappingURL=error.js.map"
      "//# sourceMappingURL=7778.4f4d5141.js.map";

  char* source_map_url = FindDebuggerMagicContent(ctx_, (char*)source.c_str(),
                                                  (char*)"sourceMappingURL", 0);
  std::string source_map_str(source_map_url);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, source_map_url);
  std::cout << "sourceMappingURL: " << source_map_str << std::endl;
  ASSERT_TRUE(source_map_str == "7778.4f4d5141.js.map");

  char* source_url = FindDebuggerMagicContent(ctx_, (char*)source.c_str(),
                                              (char*)"sourceURL", 0);
  std::string source_url_str(source_url);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, source_url);
  std::cout << "sourceURL: " << source_url_str << std::endl;
  ASSERT_TRUE(source_url_str == "test_source_url.js");
}

static std::string ExtractMagicContentResult(LEPUSContext* ctx,
                                             const std::string& source,
                                             const char* search_name,
                                             uint8_t multi_line) {
  char* result =
      FindDebuggerMagicContent(ctx, const_cast<char*>(source.c_str()),
                               const_cast<char*>(search_name), multi_line);
  std::string result_str = result ? result : "";
  if (!ctx->rt->gc_enable) lepus_free(ctx, result);
  return result_str;
}

TEST_F(QjsDebugMethods, TestFindDebuggerMagicContentTrimWhitespaceAndNewline) {
  std::string source =
      "const value = 1;\n"
      "//# sourceMappingURL=   trimmed.js.map   \n"
      "const value2 = 2;\n";

  ASSERT_EQ(ExtractMagicContentResult(ctx_, source, "sourceMappingURL", 0),
            "trimmed.js.map");
}

TEST_F(QjsDebugMethods, TestFindDebuggerMagicContentRejectQuotedOrSpacedValue) {
  std::string quoted_source =
      "//# sourceMappingURL='quoted.js.map'\n"
      "//# sourceURL=test_source_url.js\n";
  ASSERT_EQ(
      ExtractMagicContentResult(ctx_, quoted_source, "sourceMappingURL", 0),
      "");

  std::string spaced_source =
      "//# sourceMappingURL=bad value.js.map\n"
      "//# sourceURL=test_source_url.js\n";
  ASSERT_EQ(
      ExtractMagicContentResult(ctx_, spaced_source, "sourceMappingURL", 0),
      "");
}

TEST_F(QjsDebugMethods, TestFindDebuggerMagicContentSupportsMultiLineComment) {
  std::string source =
      "/*# sourceMappingURL=multi_line.js.map */\n"
      "function test() { return 1; }\n";

  ASSERT_EQ(ExtractMagicContentResult(ctx_, source, "sourceMappingURL", 1),
            "multi_line.js.map");
}

TEST_F(QjsDebugMethods, TestFindDebuggerMagicContentPrefersLastValidDirective) {
  std::string source =
      "//# sourceMappingURL=first.js.map\n"
      "//# sourceMappingURL=second.js.map\n"
      "//# sourceURL=final.js\n";

  ASSERT_EQ(ExtractMagicContentResult(ctx_, source, "sourceMappingURL", 0),
            "second.js.map");
  ASSERT_EQ(ExtractMagicContentResult(ctx_, source, "sourceURL", 0),
            "final.js");
}

TEST_F(QjsDebugMethods,
       TestFindDebuggerMagicContentReturnsNullForInvalidDirective) {
  std::string missing_equal = "//# sourceMappingURL\n";
  char* no_equal =
      FindDebuggerMagicContent(ctx_, const_cast<char*>(missing_equal.c_str()),
                               (char*)"sourceMappingURL", 0);
  ASSERT_EQ(no_equal, nullptr);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, no_equal);

  std::string not_comment = "sourceMappingURL=not-comment.js.map\n";
  char* no_comment =
      FindDebuggerMagicContent(ctx_, const_cast<char*>(not_comment.c_str()),
                               (char*)"sourceMappingURL", 0);
  ASSERT_EQ(no_comment, nullptr);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, no_comment);
}

TEST_F(QjsDebugMethods, TestFindDebuggerMagicContentHandlesLargeInput) {
  std::string large_prefix(1 << 20, 'a');
  std::string long_map_url = "bundle.js.map?token=" + std::string(4096, 'x');
  std::string source = large_prefix + "\n//# sourceMappingURL=" + long_map_url;

  ASSERT_EQ(ExtractMagicContentResult(ctx_, source, "sourceMappingURL", 0),
            long_map_url);
}

static void CheckStatementPause(LEPUSContext* ctx, int32_t line_number_gt,
                                int64_t column_number_gt,
                                const std::string& paused_mes = "") {
  std::string msg = paused_mes;
  if (msg.empty()) {
    msg = QjsDebugQueue::GetReceiveMessageQueue().front();
  }
  LEPUSValue val = LEPUS_ParseJSON(ctx, msg.c_str(), msg.length(), "");
  HandleScope func_scope(ctx, &val, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue method = LEPUS_GetPropertyStr(ctx, val, "params");
  LEPUSValue callframes = LEPUS_GetPropertyStr(ctx, method, "callFrames");
  LEPUSValue callframe = LEPUS_GetPropertyUint32(ctx, callframes, 0);
  LEPUSValue location = LEPUS_GetPropertyStr(ctx, callframe, "location");
  LEPUSValue line_number_val =
      LEPUS_GetPropertyStr(ctx, location, "lineNumber");
  LEPUSValue column_number_val =
      LEPUS_GetPropertyStr(ctx, location, "columnNumber");
  int32_t line_number = 0;
  int64_t column_number = 0;
  LEPUS_ToInt32(ctx, &line_number, line_number_val);
  LEPUS_ToInt64(ctx, &column_number, column_number_val);
  std::cout << "column_number: " << column_number << " gt: " << column_number_gt
            << std::endl;
  std::cout << "line_number: " << line_number << " gt: " << line_number_gt
            << std::endl;
  ASSERT_TRUE(line_number == line_number_gt);
  ASSERT_TRUE(column_number == column_number_gt);
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  QjsDebugQueue::GetReceiveMessageQueue().pop();

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, location);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, callframe);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, callframes);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, method);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, val);
}

TEST_F(QjsDebugMethods, TestStepStatement) {
  void* funcs[14] = {reinterpret_cast<void*>(RunMessageLoopOnPauseCBStepOver),
                     reinterpret_cast<void*>(QuitMessageLoopOnPauseCB),
                     reinterpret_cast<void*>(GetMessagesCB),
                     reinterpret_cast<void*>(SendResponseCB),
                     reinterpret_cast<void*>(SendNotificationCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(IsRuntimeDevtoolOnCB)};
  RegisterQJSDebuggerCallbacks(rt_, reinterpret_cast<void**>(funcs), 14);

  const char* buf = R"(var a = 1; var b = 2; var c = 3; var d = {a: 1};)";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2, "
      "\"method\":\"Debugger.stopAtEntry\",\"params\":{}}");
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_step_statement.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  for (size_t i = 0; i < 4; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  CheckStatementPause(ctx_, 0, 0);
  CheckStatementPause(ctx_, 0, 17);
  CheckStatementPause(ctx_, 0, 28);
  CheckStatementPause(ctx_, 0, 45);
}

TEST_F(QjsDebugMethods, TestStepStatement2) {
  void* funcs[14] = {reinterpret_cast<void*>(RunMessageLoopOnPauseCBStepOver),
                     reinterpret_cast<void*>(QuitMessageLoopOnPauseCB),
                     reinterpret_cast<void*>(GetMessagesCB),
                     reinterpret_cast<void*>(SendResponseCB),
                     reinterpret_cast<void*>(SendNotificationCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(IsRuntimeDevtoolOnCB)};
  RegisterQJSDebuggerCallbacks(rt_, reinterpret_cast<void**>(funcs), 14);

  const char* buf = R"(
      var a = 1;
      debugger;
      var b = 2; var c = 3; var d = {a: 1};)";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Debugger.setBreakpointsActive\",\"params\":{"
      "\"active\":true}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":3, "
      "\"method\":\"Debugger.stopAtEntry\",\"params\":{}}");
  LEPUSValue ret =
      LEPUS_Eval(ctx_, (const char*)buf, strlen(buf), "test_step_statement2.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  for (size_t i = 0; i < 5; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  CheckStatementPause(ctx_, 0, 0);
  CheckStatementPause(ctx_, 1, 12);
  CheckStatementPause(ctx_, 2, 6);
  CheckStatementPause(ctx_, 3, 6);
  CheckStatementPause(ctx_, 3, 23);
  CheckStatementPause(ctx_, 3, 40);
  CheckStatementPause(ctx_, 3, 43);
}

TEST_F(QjsDebugMethods, TestDiscardConsoleEntries) {
  const char* buf = R"(function test() {
    console.log("test1");
    console.log("test2");
    console.log("test3");
  }
  test();
  )";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  LEPUSValue ret =
      LEPUS_Eval(ctx_, (const char*)buf, strlen(buf), "test_console_discard.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":3,\"method\":\"Runtime.discardConsoleEntries\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":4,\"method\":\"Runtime.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");

  const char* trigger = R"(function test2() {
    console.log("test2_1");
    console.log("test2_2");
    console.log("test2_3");
    }
    test2();
  )";

  LEPUSValue ret1 = LEPUS_Eval(ctx_, trigger, strlen(trigger),
                               "trigger_debugger.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret1);
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":5,\"method\":\"Debugger.disable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":6,\"method\":\"Runtime.disable\",\"params\":{}}");
  const char* trigger1 = "function trigger() {}; trigger();\n";
  LEPUSValue ret2 = LEPUS_Eval(ctx_, trigger1, strlen(trigger1),
                               "trigger_debugger.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret2);

  uint32_t console_msg_size = 0;
  LEPUSValue val = LEPUS_UNDEFINED;
  HandleScope func_scope(ctx_, &val, HANDLE_TYPE_LEPUS_VALUE);
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    std::cout << "msg: " << msg << std::endl;
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    val = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    LEPUSValue method = LEPUS_GetPropertyStr(ctx_, val, "method");
    if (!LEPUS_IsUndefined(method)) {
      const char* method_name = LEPUS_ToCString(ctx_, method);
      if (std::string(method_name) == "Runtime.consoleAPICalled") {
        console_msg_size++;
      }
      if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, method_name);
    }
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, method);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
  }
  std::cout << "size: " << console_msg_size << std::endl;
  ASSERT_TRUE(console_msg_size == 6);
}

TEST_F(QjsDebugMethods, TestConsoleStackTrace) {
  void* funcs[23] = {reinterpret_cast<void*>(RunMessageLoopOnPauseCBStepOver),
                     reinterpret_cast<void*>(QuitMessageLoopOnPauseCB),
                     reinterpret_cast<void*>(GetMessagesCB),
                     reinterpret_cast<void*>(SendResponseCB),
                     reinterpret_cast<void*>(SendNotificationCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(IsRuntimeDevtoolOnCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(ConsoleStackTrace)};
  RegisterQJSDebuggerCallbacks(rt_, reinterpret_cast<void**>(funcs), 23);

  const char* buf = R"(var a = 1; var b = 2;
                      var c = 3; var d = {a: 1};
                      function test() {
                          console.log("hahaha in test");
                      }
                      test();
                      console.log("hahaha in eval");
                      )";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  LEPUSValue ret =
      LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                 "test_console_stacktrace.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  for (size_t i = 0; i < 4; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  std::string info1 = QjsDebugQueue::GetReceiveMessageQueue().front();
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  std::string info2 = QjsDebugQueue::GetReceiveMessageQueue().front();
  QjsDebugQueue::GetReceiveMessageQueue().pop();

  LEPUSValue console_response1 =
      LEPUS_ParseJSON(ctx_, info1.c_str(), info1.length(), "");
  HandleScope func_scope(ctx_, &console_response1, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue params = LEPUS_GetPropertyStr(ctx_, console_response1, "params");
  LEPUSValue stack_trace = LEPUS_GetPropertyStr(ctx_, params, "stackTrace");
  LEPUSValue stack_trace_val = LEPUS_ToJSON(ctx_, stack_trace, 0);
  func_scope.PushHandle(&stack_trace_val, HANDLE_TYPE_LEPUS_VALUE);
  const char* stack_trace_str = LEPUS_ToCString(ctx_, stack_trace_val);
  std::string true1 =
      R"({"callFrames":[{"functionName":"test","url":"test_console_stacktrace.js","columnNumber":55,"lineNumber":3,"scriptId":"1"},{"functionName":"<eval>","url":"test_console_stacktrace.js","columnNumber":28,"lineNumber":5,"scriptId":"1"}]})";
  ASSERT_TRUE(stack_trace_str == true1);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, console_response1);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, params);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, stack_trace);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, stack_trace_val);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, stack_trace_str);

  LEPUSValue console_response2 =
      LEPUS_ParseJSON(ctx_, info2.c_str(), info2.length(), "");
  func_scope.PushHandle(&console_response2, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue params2 = LEPUS_GetPropertyStr(ctx_, console_response2, "params");
  LEPUSValue stack_trace2 = LEPUS_GetPropertyStr(ctx_, params2, "stackTrace");
  LEPUSValue stack_trace_val2 = LEPUS_ToJSON(ctx_, stack_trace2, 0);
  func_scope.PushHandle(&stack_trace_val2, HANDLE_TYPE_LEPUS_VALUE);
  const char* stack_trace_str2 = LEPUS_ToCString(ctx_, stack_trace_val2);
  std::string true2 =
      R"({"callFrames":[{"functionName":"<eval>","url":"test_console_stacktrace.js","columnNumber":51,"lineNumber":6,"scriptId":"1"}]})";
  ASSERT_TRUE(stack_trace_str2 == true2);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, console_response2);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, params2);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, stack_trace2);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, stack_trace_val2);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, stack_trace_str2);
}

TEST_F(QjsDebugMethods, TestConsoleAPICalled) {
  std::string src = R"(
    function test() {
        console.log("test1");
        console.log("test2");
        console.log("test3");
      }
    test();
)";

  auto ret =
      LEPUS_Eval(ctx_, src.c_str(), src.size(),
                 "test_console_api_callbacked.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_EQ(QjsDebugQueue::runtime_receive_queue_.size(), 0);
  if (!ctx_->gc_enable) LEPUS_FreeValue(ctx_, ret);
  std::queue<std::string> tmp;
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  src = "test()";
  QjsDebugQueue::runtime_receive_queue_.swap(tmp);
  ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->gc_enable) LEPUS_FreeValue(ctx_, ret);
  ASSERT_GT(QjsDebugQueue::runtime_receive_queue_.size(), 0);
  QjsDebugQueue::runtime_receive_queue_.pop();
  while (!QjsDebugQueue::runtime_receive_queue_.empty()) {
    auto front = QjsDebugQueue::runtime_receive_queue_.front();
    ASSERT_TRUE(front.find("Runtime.consoleAPICalled") != std::string::npos);
    QjsDebugQueue::runtime_receive_queue_.pop();
  }
}

TEST_F(QjsDebugMethods, TestConsoleReplayObjectIdGetProperties) {
  std::string src = R"(
    function emitReplayConsole() {
      console.log("replay-marker", {
        kind: "root",
        child: {
          level: 1,
          grand: { leaf: 42 }
        }
      });
    }
    emitReplayConsole();
  )";
  EvalScriptExpectNoException(ctx_, src, "test_console_replay_object_id.js");
  ASSERT_TRUE(QjsDebugQueue::runtime_receive_queue_.empty());

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":100,\"method\":\"Runtime.enable\",\"params\":{}}");
  ProcessQueuedProtocolMessages(ctx_);

  std::string console_notification =
      PopConsoleNotificationByMarker(ctx_, "replay-marker");
  std::string root_object_id =
      ExtractConsoleArgObjectId(ctx_, console_notification, 1);
  ASSERT_FALSE(root_object_id.empty());

  SendRuntimeGetProperties(ctx_, 101, root_object_id);
  std::string root_response = PopResponseById(ctx_, 101);
  LEPUSValue root_properties = GetPropertiesResultArray(ctx_, root_response);
  ASSERT_TRUE(LEPUS_IsObject(root_properties));

  LEPUSValue kind_value =
      FindPropertyRemoteObjectByName(ctx_, root_properties, "kind");
  ASSERT_TRUE(LEPUS_IsObject(kind_value));
  ASSERT_EQ(ExtractRemoteObjectStringValue(ctx_, kind_value), "root");

  LEPUSValue child_value =
      FindPropertyRemoteObjectByName(ctx_, root_properties, "child");
  ASSERT_TRUE(LEPUS_IsObject(child_value));
  std::string child_object_id = ExtractRemoteObjectObjectId(ctx_, child_value);
  ASSERT_FALSE(child_object_id.empty());

  SendRuntimeGetProperties(ctx_, 102, child_object_id);
  std::string child_response = PopResponseById(ctx_, 102);
  LEPUSValue child_properties = GetPropertiesResultArray(ctx_, child_response);
  ASSERT_TRUE(LEPUS_IsObject(child_properties));

  LEPUSValue level_value =
      FindPropertyRemoteObjectByName(ctx_, child_properties, "level");
  ASSERT_TRUE(LEPUS_IsObject(level_value));
  ASSERT_EQ(ExtractRemoteObjectIntValue(ctx_, level_value), 1);

  LEPUSValue grand_value =
      FindPropertyRemoteObjectByName(ctx_, child_properties, "grand");
  ASSERT_TRUE(LEPUS_IsObject(grand_value));
  std::string grand_object_id = ExtractRemoteObjectObjectId(ctx_, grand_value);
  ASSERT_FALSE(grand_object_id.empty());

  SendRuntimeGetProperties(ctx_, 103, grand_object_id);
  std::string grand_response = PopResponseById(ctx_, 103);
  LEPUSValue grand_properties = GetPropertiesResultArray(ctx_, grand_response);
  ASSERT_TRUE(LEPUS_IsObject(grand_properties));

  LEPUSValue leaf_value =
      FindPropertyRemoteObjectByName(ctx_, grand_properties, "leaf");
  ASSERT_TRUE(LEPUS_IsObject(leaf_value));
  ASSERT_EQ(ExtractRemoteObjectIntValue(ctx_, leaf_value), 42);

  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, leaf_value);
    LEPUS_FreeValue(ctx_, grand_properties);
    LEPUS_FreeValue(ctx_, grand_value);
    LEPUS_FreeValue(ctx_, level_value);
    LEPUS_FreeValue(ctx_, child_properties);
    LEPUS_FreeValue(ctx_, child_value);
    LEPUS_FreeValue(ctx_, kind_value);
    LEPUS_FreeValue(ctx_, root_properties);
  }
}

TEST_F(QjsDebugMethods,
       TestConsoleDerivedObjectIdStableAcrossRepeatedExpansion) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":110,\"method\":\"Runtime.enable\",\"params\":{}}");
  ProcessQueuedProtocolMessages(ctx_);

  std::string src = R"(
    console.log("dedupe-marker", {
      child: {
        level: 1,
        grand: { leaf: 42 }
      }
    });
  )";
  EvalScriptExpectNoException(ctx_, src, "test_console_dedupe_object_id.js");

  std::string console_notification =
      PopConsoleNotificationByMarker(ctx_, "dedupe-marker");
  std::string root_object_id =
      ExtractConsoleArgObjectId(ctx_, console_notification, 1);
  ASSERT_FALSE(root_object_id.empty());

  SendRuntimeGetProperties(ctx_, 111, root_object_id);
  std::string first_root_response = PopResponseById(ctx_, 111);
  LEPUSValue first_root_properties =
      GetPropertiesResultArray(ctx_, first_root_response);
  ASSERT_TRUE(LEPUS_IsObject(first_root_properties));

  LEPUSValue first_child_value =
      FindPropertyRemoteObjectByName(ctx_, first_root_properties, "child");
  ASSERT_TRUE(LEPUS_IsObject(first_child_value));
  std::string first_child_object_id =
      ExtractRemoteObjectObjectId(ctx_, first_child_value);
  ASSERT_FALSE(first_child_object_id.empty());

  SendRuntimeGetProperties(ctx_, 112, root_object_id);
  std::string second_root_response = PopResponseById(ctx_, 112);
  LEPUSValue second_root_properties =
      GetPropertiesResultArray(ctx_, second_root_response);
  ASSERT_TRUE(LEPUS_IsObject(second_root_properties));

  LEPUSValue second_child_value =
      FindPropertyRemoteObjectByName(ctx_, second_root_properties, "child");
  ASSERT_TRUE(LEPUS_IsObject(second_child_value));
  std::string second_child_object_id =
      ExtractRemoteObjectObjectId(ctx_, second_child_value);
  ASSERT_FALSE(second_child_object_id.empty());
  ASSERT_EQ(first_child_object_id, second_child_object_id);

  SendRuntimeGetProperties(ctx_, 113, first_child_object_id);
  std::string first_child_response = PopResponseById(ctx_, 113);
  LEPUSValue first_child_properties =
      GetPropertiesResultArray(ctx_, first_child_response);
  ASSERT_TRUE(LEPUS_IsObject(first_child_properties));

  LEPUSValue first_level_value =
      FindPropertyRemoteObjectByName(ctx_, first_child_properties, "level");
  ASSERT_TRUE(LEPUS_IsObject(first_level_value));
  ASSERT_EQ(ExtractRemoteObjectIntValue(ctx_, first_level_value), 1);

  LEPUSValue first_grand_value =
      FindPropertyRemoteObjectByName(ctx_, first_child_properties, "grand");
  ASSERT_TRUE(LEPUS_IsObject(first_grand_value));
  std::string first_grand_object_id =
      ExtractRemoteObjectObjectId(ctx_, first_grand_value);
  ASSERT_FALSE(first_grand_object_id.empty());

  SendRuntimeGetProperties(ctx_, 114, second_child_object_id);
  std::string second_child_response = PopResponseById(ctx_, 114);
  LEPUSValue second_child_properties =
      GetPropertiesResultArray(ctx_, second_child_response);
  ASSERT_TRUE(LEPUS_IsObject(second_child_properties));

  LEPUSValue second_level_value =
      FindPropertyRemoteObjectByName(ctx_, second_child_properties, "level");
  ASSERT_TRUE(LEPUS_IsObject(second_level_value));
  ASSERT_EQ(ExtractRemoteObjectIntValue(ctx_, second_level_value), 1);

  LEPUSValue second_grand_value =
      FindPropertyRemoteObjectByName(ctx_, second_child_properties, "grand");
  ASSERT_TRUE(LEPUS_IsObject(second_grand_value));
  std::string second_grand_object_id =
      ExtractRemoteObjectObjectId(ctx_, second_grand_value);
  ASSERT_FALSE(second_grand_object_id.empty());
  ASSERT_EQ(first_grand_object_id, second_grand_object_id);

  SendRuntimeGetProperties(ctx_, 115, first_grand_object_id);
  std::string grand_response = PopResponseById(ctx_, 115);
  LEPUSValue grand_properties = GetPropertiesResultArray(ctx_, grand_response);
  ASSERT_TRUE(LEPUS_IsObject(grand_properties));

  LEPUSValue leaf_value =
      FindPropertyRemoteObjectByName(ctx_, grand_properties, "leaf");
  ASSERT_TRUE(LEPUS_IsObject(leaf_value));
  ASSERT_EQ(ExtractRemoteObjectIntValue(ctx_, leaf_value), 42);

  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, leaf_value);
    LEPUS_FreeValue(ctx_, grand_properties);
    LEPUS_FreeValue(ctx_, second_grand_value);
    LEPUS_FreeValue(ctx_, second_level_value);
    LEPUS_FreeValue(ctx_, second_child_properties);
    LEPUS_FreeValue(ctx_, first_grand_value);
    LEPUS_FreeValue(ctx_, first_level_value);
    LEPUS_FreeValue(ctx_, first_child_properties);
    LEPUS_FreeValue(ctx_, second_child_value);
    LEPUS_FreeValue(ctx_, second_root_properties);
    LEPUS_FreeValue(ctx_, first_child_value);
    LEPUS_FreeValue(ctx_, first_root_properties);
  }
}

TEST_F(QjsDebugMethods, TestConsoleAliasPropertiesShareDerivedObjectId) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":116,\"method\":\"Runtime.enable\",\"params\":{}}");
  ProcessQueuedProtocolMessages(ctx_);

  std::string src = R"(
    const shared = { value: 7, nested: { label: "shared" } };
    console.log("alias-marker", {
      first: shared,
      second: shared,
    });
  )";
  EvalScriptExpectNoException(ctx_, src, "test_console_alias_object_id.js");

  std::string console_notification =
      PopConsoleNotificationByMarker(ctx_, "alias-marker");
  std::string root_object_id =
      ExtractConsoleArgObjectId(ctx_, console_notification, 1);
  ASSERT_FALSE(root_object_id.empty());

  SendRuntimeGetProperties(ctx_, 117, root_object_id);
  std::string root_response = PopResponseById(ctx_, 117);
  LEPUSValue root_properties = GetPropertiesResultArray(ctx_, root_response);
  ASSERT_TRUE(LEPUS_IsObject(root_properties));

  LEPUSValue first_value =
      FindPropertyRemoteObjectByName(ctx_, root_properties, "first");
  LEPUSValue second_value =
      FindPropertyRemoteObjectByName(ctx_, root_properties, "second");
  ASSERT_TRUE(LEPUS_IsObject(first_value));
  ASSERT_TRUE(LEPUS_IsObject(second_value));

  std::string first_object_id = ExtractRemoteObjectObjectId(ctx_, first_value);
  std::string second_object_id =
      ExtractRemoteObjectObjectId(ctx_, second_value);
  ASSERT_FALSE(first_object_id.empty());
  ASSERT_EQ(first_object_id, second_object_id);

  SendRuntimeGetProperties(ctx_, 118, first_object_id);
  std::string alias_response = PopResponseById(ctx_, 118);
  LEPUSValue alias_properties = GetPropertiesResultArray(ctx_, alias_response);
  ASSERT_TRUE(LEPUS_IsObject(alias_properties));

  LEPUSValue shared_value =
      FindPropertyRemoteObjectByName(ctx_, alias_properties, "value");
  ASSERT_TRUE(LEPUS_IsObject(shared_value));
  ASSERT_EQ(ExtractRemoteObjectIntValue(ctx_, shared_value), 7);

  LEPUSValue nested_value =
      FindPropertyRemoteObjectByName(ctx_, alias_properties, "nested");
  ASSERT_TRUE(LEPUS_IsObject(nested_value));
  std::string nested_object_id =
      ExtractRemoteObjectObjectId(ctx_, nested_value);
  ASSERT_FALSE(nested_object_id.empty());

  SendRuntimeGetProperties(ctx_, 119, second_object_id);
  std::string alias_response_again = PopResponseById(ctx_, 119);
  LEPUSValue alias_properties_again =
      GetPropertiesResultArray(ctx_, alias_response_again);
  ASSERT_TRUE(LEPUS_IsObject(alias_properties_again));

  LEPUSValue nested_value_again =
      FindPropertyRemoteObjectByName(ctx_, alias_properties_again, "nested");
  ASSERT_TRUE(LEPUS_IsObject(nested_value_again));
  std::string nested_object_id_again =
      ExtractRemoteObjectObjectId(ctx_, nested_value_again);
  ASSERT_FALSE(nested_object_id_again.empty());
  ASSERT_EQ(nested_object_id, nested_object_id_again);

  SendRuntimeGetProperties(ctx_, 120, nested_object_id);
  std::string nested_response = PopResponseById(ctx_, 120);
  LEPUSValue nested_properties =
      GetPropertiesResultArray(ctx_, nested_response);
  ASSERT_TRUE(LEPUS_IsObject(nested_properties));

  LEPUSValue label_value =
      FindPropertyRemoteObjectByName(ctx_, nested_properties, "label");
  ASSERT_TRUE(LEPUS_IsObject(label_value));
  ASSERT_EQ(ExtractRemoteObjectStringValue(ctx_, label_value), "shared");

  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, label_value);
    LEPUS_FreeValue(ctx_, nested_properties);
    LEPUS_FreeValue(ctx_, nested_value_again);
    LEPUS_FreeValue(ctx_, alias_properties_again);
    LEPUS_FreeValue(ctx_, nested_value);
    LEPUS_FreeValue(ctx_, shared_value);
    LEPUS_FreeValue(ctx_, alias_properties);
    LEPUS_FreeValue(ctx_, second_value);
    LEPUS_FreeValue(ctx_, first_value);
    LEPUS_FreeValue(ctx_, root_properties);
  }
}

TEST_F(QjsDebugMethods, TestConsoleObjectIdEncodesMessageSlotAndGeneration) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":120,\"method\":\"Runtime.enable\",\"params\":{}}");
  ProcessQueuedProtocolMessages(ctx_);

  std::string src = R"(
    console.log("slot-marker-0", { order: 0 });
    console.log("slot-marker-1", { order: 1, child: { value: 11 } });
    console.log("slot-marker-2", { order: 2 });
  )";
  EvalScriptExpectNoException(ctx_, src, "test_console_slot_generation.js");

  std::string notification0 =
      PopConsoleNotificationByMarker(ctx_, "slot-marker-0");
  std::string notification1 =
      PopConsoleNotificationByMarker(ctx_, "slot-marker-1");
  std::string notification2 =
      PopConsoleNotificationByMarker(ctx_, "slot-marker-2");

  std::string object_id0 = ExtractConsoleArgObjectId(ctx_, notification0, 1);
  std::string object_id1 = ExtractConsoleArgObjectId(ctx_, notification1, 1);
  std::string object_id2 = ExtractConsoleArgObjectId(ctx_, notification2, 1);
  TestConsoleObjectIdInfo info0 = ParseConsoleObjectIdForTest(object_id0);
  TestConsoleObjectIdInfo info1 = ParseConsoleObjectIdForTest(object_id1);
  TestConsoleObjectIdInfo info2 = ParseConsoleObjectIdForTest(object_id2);

  ASSERT_TRUE(info0.valid);
  ASSERT_TRUE(info1.valid);
  ASSERT_TRUE(info2.valid);
  ASSERT_FALSE(info0.is_child);
  ASSERT_FALSE(info1.is_child);
  ASSERT_FALSE(info2.is_child);
  ASSERT_EQ(info0.message_slot, 0u);
  ASSERT_EQ(info1.message_slot, 1u);
  ASSERT_EQ(info2.message_slot, 2u);
  ASSERT_EQ(info0.generation, 0u);
  ASSERT_EQ(info1.generation, 0u);
  ASSERT_EQ(info2.generation, 0u);
  ASSERT_EQ(info0.index, 1u);
  ASSERT_EQ(info1.index, 1u);
  ASSERT_EQ(info2.index, 1u);

  SendRuntimeGetProperties(ctx_, 121, object_id1);
  std::string root_response = PopResponseById(ctx_, 121);
  LEPUSValue root_properties = GetPropertiesResultArray(ctx_, root_response);
  ASSERT_TRUE(LEPUS_IsObject(root_properties));
  LEPUSValue child_value =
      FindPropertyRemoteObjectByName(ctx_, root_properties, "child");
  ASSERT_TRUE(LEPUS_IsObject(child_value));
  std::string child_object_id = ExtractRemoteObjectObjectId(ctx_, child_value);
  TestConsoleObjectIdInfo child_info =
      ParseConsoleObjectIdForTest(child_object_id);
  ASSERT_TRUE(child_info.valid);
  ASSERT_TRUE(child_info.is_child);
  ASSERT_EQ(child_info.message_slot, info1.message_slot);
  ASSERT_EQ(child_info.generation, info1.generation);

  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, child_value);
    LEPUS_FreeValue(ctx_, root_properties);
  }
}

TEST_F(QjsDebugMethods, TestConsoleObjectIdGenerationBumpsWhenSlotReused) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":130,\"method\":\"Runtime.enable\",\"params\":{}}");
  ProcessQueuedProtocolMessages(ctx_);

  std::string src = R"(
    for (let i = 0; i <= 1000; ++i) {
      console.log("generation-marker-" + i, {
        order: i,
        child: { value: i }
      });
    }
  )";
  EvalScriptExpectNoException(ctx_, src, "test_console_generation_reuse.js");

  std::string stale_notification =
      PopConsoleNotificationByMarker(ctx_, "generation-marker-0");
  std::string reused_notification =
      PopConsoleNotificationByMarker(ctx_, "generation-marker-1000");

  std::string stale_object_id =
      ExtractConsoleArgObjectId(ctx_, stale_notification, 1);
  std::string reused_object_id =
      ExtractConsoleArgObjectId(ctx_, reused_notification, 1);
  TestConsoleObjectIdInfo stale_info =
      ParseConsoleObjectIdForTest(stale_object_id);
  TestConsoleObjectIdInfo reused_info =
      ParseConsoleObjectIdForTest(reused_object_id);

  ASSERT_TRUE(stale_info.valid);
  ASSERT_TRUE(reused_info.valid);
  ASSERT_FALSE(stale_info.is_child);
  ASSERT_FALSE(reused_info.is_child);
  ASSERT_EQ(stale_info.message_slot, reused_info.message_slot);
  ASSERT_EQ(stale_info.message_slot, 0u);
  ASSERT_EQ(stale_info.generation, 0u);
  ASSERT_EQ(reused_info.generation, stale_info.generation + 1);
  ASSERT_EQ(stale_info.index, 1u);
  ASSERT_EQ(reused_info.index, 1u);

  SendRuntimeGetProperties(ctx_, 131, stale_object_id);
  std::string stale_response = PopResponseById(ctx_, 131);
  LEPUSValue stale_properties = GetPropertiesResultArray(ctx_, stale_response);
  ASSERT_TRUE(LEPUS_IsObject(stale_properties));
  ASSERT_EQ(LEPUS_GetLength(ctx_, stale_properties), 0);

  SendRuntimeGetProperties(ctx_, 132, reused_object_id);
  std::string reused_response = PopResponseById(ctx_, 132);
  LEPUSValue reused_properties =
      GetPropertiesResultArray(ctx_, reused_response);
  ASSERT_TRUE(LEPUS_IsObject(reused_properties));
  LEPUSValue order_value =
      FindPropertyRemoteObjectByName(ctx_, reused_properties, "order");
  ASSERT_TRUE(LEPUS_IsObject(order_value));
  ASSERT_EQ(ExtractRemoteObjectIntValue(ctx_, order_value), 1000);

  LEPUSValue child_value =
      FindPropertyRemoteObjectByName(ctx_, reused_properties, "child");
  ASSERT_TRUE(LEPUS_IsObject(child_value));
  std::string child_object_id = ExtractRemoteObjectObjectId(ctx_, child_value);
  TestConsoleObjectIdInfo child_info =
      ParseConsoleObjectIdForTest(child_object_id);
  ASSERT_TRUE(child_info.valid);
  ASSERT_TRUE(child_info.is_child);
  ASSERT_EQ(child_info.message_slot, reused_info.message_slot);
  ASSERT_EQ(child_info.generation, reused_info.generation);

  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, child_value);
    LEPUS_FreeValue(ctx_, order_value);
    LEPUS_FreeValue(ctx_, reused_properties);
    LEPUS_FreeValue(ctx_, stale_properties);
  }
}

TEST_F(QjsDebugMethods, TestConsoleObjectIdInvalidAfterMessageOverflow) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":200,\"method\":\"Runtime.enable\",\"params\":{}}");
  ProcessQueuedProtocolMessages(ctx_);

  std::string stale_src = R"(
    console.log("stale-marker", {
      kind: "stale",
      child: { value: 1 }
    });
  )";
  EvalScriptExpectNoException(ctx_, stale_src,
                              "test_console_overflow_stale.js");

  std::string stale_notification =
      PopConsoleNotificationByMarker(ctx_, "stale-marker");
  std::string stale_root_object_id =
      ExtractConsoleArgObjectId(ctx_, stale_notification, 1);
  ASSERT_FALSE(stale_root_object_id.empty());

  SendRuntimeGetProperties(ctx_, 201, stale_root_object_id);
  std::string stale_root_response = PopResponseById(ctx_, 201);
  LEPUSValue stale_root_properties =
      GetPropertiesResultArray(ctx_, stale_root_response);
  ASSERT_TRUE(LEPUS_IsObject(stale_root_properties));
  LEPUSValue stale_child_value =
      FindPropertyRemoteObjectByName(ctx_, stale_root_properties, "child");
  ASSERT_TRUE(LEPUS_IsObject(stale_child_value));
  std::string stale_child_object_id =
      ExtractRemoteObjectObjectId(ctx_, stale_child_value);
  ASSERT_FALSE(stale_child_object_id.empty());

  std::string overflow_src = R"(
    for (let i = 0; i < 1000; ++i) {
      console.log("filler-" + i);
    }
    console.log("fresh-marker", {
      kind: "fresh",
      child: { value: 2 }
    });
  )";
  EvalScriptExpectNoException(ctx_, overflow_src,
                              "test_console_overflow_fresh.js");

  std::string fresh_notification =
      PopConsoleNotificationByMarker(ctx_, "fresh-marker");
  std::string fresh_root_object_id =
      ExtractConsoleArgObjectId(ctx_, fresh_notification, 1);
  ASSERT_FALSE(fresh_root_object_id.empty());

  SendRuntimeGetProperties(ctx_, 202, stale_root_object_id);
  std::string expired_root_response = PopResponseById(ctx_, 202);
  LEPUSValue expired_root_properties =
      GetPropertiesResultArray(ctx_, expired_root_response);
  ASSERT_TRUE(LEPUS_IsObject(expired_root_properties));
  ASSERT_EQ(LEPUS_GetLength(ctx_, expired_root_properties), 0);

  SendRuntimeGetProperties(ctx_, 203, stale_child_object_id);
  std::string expired_child_response = PopResponseById(ctx_, 203);
  LEPUSValue expired_child_properties =
      GetPropertiesResultArray(ctx_, expired_child_response);
  ASSERT_TRUE(LEPUS_IsObject(expired_child_properties));
  ASSERT_EQ(LEPUS_GetLength(ctx_, expired_child_properties), 0);

  SendRuntimeGetProperties(ctx_, 204, fresh_root_object_id);
  std::string fresh_root_response = PopResponseById(ctx_, 204);
  LEPUSValue fresh_root_properties =
      GetPropertiesResultArray(ctx_, fresh_root_response);
  ASSERT_TRUE(LEPUS_IsObject(fresh_root_properties));

  LEPUSValue fresh_kind_value =
      FindPropertyRemoteObjectByName(ctx_, fresh_root_properties, "kind");
  ASSERT_TRUE(LEPUS_IsObject(fresh_kind_value));
  ASSERT_EQ(ExtractRemoteObjectStringValue(ctx_, fresh_kind_value), "fresh");

  LEPUSValue fresh_child_value =
      FindPropertyRemoteObjectByName(ctx_, fresh_root_properties, "child");
  ASSERT_TRUE(LEPUS_IsObject(fresh_child_value));
  std::string fresh_child_object_id =
      ExtractRemoteObjectObjectId(ctx_, fresh_child_value);
  ASSERT_FALSE(fresh_child_object_id.empty());

  SendRuntimeGetProperties(ctx_, 205, fresh_child_object_id);
  std::string fresh_child_response = PopResponseById(ctx_, 205);
  LEPUSValue fresh_child_properties =
      GetPropertiesResultArray(ctx_, fresh_child_response);
  ASSERT_TRUE(LEPUS_IsObject(fresh_child_properties));

  LEPUSValue fresh_value =
      FindPropertyRemoteObjectByName(ctx_, fresh_child_properties, "value");
  ASSERT_TRUE(LEPUS_IsObject(fresh_value));
  ASSERT_EQ(ExtractRemoteObjectIntValue(ctx_, fresh_value), 2);

  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, fresh_value);
    LEPUS_FreeValue(ctx_, fresh_child_properties);
    LEPUS_FreeValue(ctx_, fresh_child_value);
    LEPUS_FreeValue(ctx_, fresh_kind_value);
    LEPUS_FreeValue(ctx_, fresh_root_properties);
    LEPUS_FreeValue(ctx_, expired_child_properties);
    LEPUS_FreeValue(ctx_, expired_root_properties);
    LEPUS_FreeValue(ctx_, stale_child_value);
    LEPUS_FreeValue(ctx_, stale_root_properties);
  }
}

TEST_F(QjsDebugMethods, TestExpiredConsoleMessageCollectedAfterForcedGC) {
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":300,\"method\":\"Runtime.enable\",\"params\":{}}");
  ProcessQueuedProtocolMessages(ctx_);

  std::string overflow_src = R"(
    globalThis.__consoleGcState = {
      rootFinalized: 0,
      childFinalized: 0,
    };
    globalThis.__consoleGcRegistry = new FinalizationRegistry((heldValue) => {
      if (heldValue === "root") {
        globalThis.__consoleGcState.rootFinalized++;
      } else if (heldValue === "child") {
        globalThis.__consoleGcState.childFinalized++;
      }
    });
    globalThis.__consoleGcRootRefs = [];
    globalThis.__consoleGcChildRefs = [];

    for (let i = 0; i < 1005; ++i) {
      let child = { value: i };
      let root = {
        kind: "batch",
        index: i,
        child,
      };
      globalThis.__consoleGcRootRefs.push(new WeakRef(root));
      globalThis.__consoleGcChildRefs.push(new WeakRef(child));
      globalThis.__consoleGcRegistry.register(root, "root");
      globalThis.__consoleGcRegistry.register(child, "child");
      console.log("gc-batch-marker-" + i, root);
    }
  )";
  EvalScriptExpectNoException(ctx_, overflow_src,
                              "test_console_gc_overflow.js");

  std::string stale_notification =
      PopConsoleNotificationByMarker(ctx_, "gc-batch-marker-0");
  std::string stale_root_object_id =
      ExtractConsoleArgObjectId(ctx_, stale_notification, 1);
  ASSERT_FALSE(stale_root_object_id.empty());

  std::string fresh_notification =
      PopConsoleNotificationByMarker(ctx_, "gc-batch-marker-5");
  std::string fresh_root_object_id =
      ExtractConsoleArgObjectId(ctx_, fresh_notification, 1);
  ASSERT_FALSE(fresh_root_object_id.empty());

  SendRuntimeGetProperties(ctx_, 302, stale_root_object_id);
  std::string expired_root_response = PopResponseById(ctx_, 302);
  LEPUSValue expired_root_properties =
      GetPropertiesResultArray(ctx_, expired_root_response);
  ASSERT_TRUE(LEPUS_IsObject(expired_root_properties));
  ASSERT_EQ(LEPUS_GetLength(ctx_, expired_root_properties), 0);

  LEPUS_RunGC(rt_);
  LEPUS_RunGC(rt_);
  ASSERT_TRUE(
      EvalScriptToBoolExpectNoException(ctx_,
                                        R"(
        (() => {
          for (let i = 0; i < 5; ++i) {
            if (globalThis.__consoleGcRootRefs[i].deref() !== undefined) {
              return false;
            }
            if (globalThis.__consoleGcChildRefs[i].deref() !== undefined) {
              return false;
            }
          }
          if (globalThis.__consoleGcState.rootFinalized !== 5) {
            return false;
          }
          if (globalThis.__consoleGcState.childFinalized !== 5) {
            return false;
          }
          if (globalThis.__consoleGcRootRefs[5].deref() === undefined) {
            return false;
          }
          if (globalThis.__consoleGcChildRefs[5].deref() === undefined) {
            return false;
          }
          if (globalThis.__consoleGcRootRefs[1004].deref() === undefined) {
            return false;
          }
          if (globalThis.__consoleGcChildRefs[1004].deref() === undefined) {
            return false;
          }
          return true;
        })()
      )",
                                        "test_console_gc_after_expire.js"));

  SendRuntimeGetProperties(ctx_, 304, fresh_root_object_id);
  std::string fresh_root_response = PopResponseById(ctx_, 304);
  LEPUSValue fresh_root_properties =
      GetPropertiesResultArray(ctx_, fresh_root_response);
  ASSERT_TRUE(LEPUS_IsObject(fresh_root_properties));
  LEPUSValue fresh_kind_value =
      FindPropertyRemoteObjectByName(ctx_, fresh_root_properties, "kind");
  ASSERT_TRUE(LEPUS_IsObject(fresh_kind_value));
  ASSERT_EQ(ExtractRemoteObjectStringValue(ctx_, fresh_kind_value), "batch");

  LEPUSValue fresh_index_value =
      FindPropertyRemoteObjectByName(ctx_, fresh_root_properties, "index");
  ASSERT_TRUE(LEPUS_IsObject(fresh_index_value));
  ASSERT_EQ(ExtractRemoteObjectIntValue(ctx_, fresh_index_value), 5);

  LEPUSValue fresh_child_value =
      FindPropertyRemoteObjectByName(ctx_, fresh_root_properties, "child");
  ASSERT_TRUE(LEPUS_IsObject(fresh_child_value));
  std::string fresh_child_object_id =
      ExtractRemoteObjectObjectId(ctx_, fresh_child_value);
  ASSERT_FALSE(fresh_child_object_id.empty());

  SendRuntimeGetProperties(ctx_, 305, fresh_child_object_id);
  std::string fresh_child_response = PopResponseById(ctx_, 305);
  LEPUSValue fresh_child_properties =
      GetPropertiesResultArray(ctx_, fresh_child_response);
  ASSERT_TRUE(LEPUS_IsObject(fresh_child_properties));
  LEPUSValue fresh_child_inner_value =
      FindPropertyRemoteObjectByName(ctx_, fresh_child_properties, "value");
  ASSERT_TRUE(LEPUS_IsObject(fresh_child_inner_value));
  ASSERT_EQ(ExtractRemoteObjectIntValue(ctx_, fresh_child_inner_value), 5);

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":306,\"method\":\"Runtime.discardConsoleEntries\"}");
  ProcessQueuedProtocolMessages(ctx_);
  EvalScriptExpectNoException(ctx_,
                              R"(
                                globalThis.__consoleGcRegistry = undefined;
                                globalThis.__consoleGcRootRefs = undefined;
                                globalThis.__consoleGcChildRefs = undefined;
                                globalThis.__consoleGcState = undefined;
                              )",
                              "test_console_gc_cleanup.js");
  LEPUS_RunGC(rt_);
  LEPUS_RunGC(rt_);

  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, fresh_child_inner_value);
    LEPUS_FreeValue(ctx_, fresh_child_properties);
    LEPUS_FreeValue(ctx_, fresh_child_value);
    LEPUS_FreeValue(ctx_, fresh_index_value);
    LEPUS_FreeValue(ctx_, fresh_kind_value);
    LEPUS_FreeValue(ctx_, fresh_root_properties);
    LEPUS_FreeValue(ctx_, expired_root_properties);
  }
}

TEST_F(QjsDebugMethods, TestPauseOnNextStatement) {
  auto funcs = GetQJSCallbackFuncs();
  RegisterQJSDebuggerCallbacks(rt_, funcs.data(), funcs.size());

  std::string debugger_enable =
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}";
  std::string pause_on_next_statement_1 =
      "{\"id\":0, \"method\":\"Debugger.pauseOnNextStatement\", \"params\":{"
      "\"reason\":\"testReason\"}}";
  std::string pause_on_next_statement_2 =
      "{\"id\":0, \"method\":\"Debugger.pauseOnNextStatement\"}";

  QjsDebugQueue::GetSendMessageQueue().push(debugger_enable);
  QjsDebugQueue::GetSendMessageQueue().push(pause_on_next_statement_1);

  // Must process messages before calling LEPUS_Eval.
  auto info = GetDebuggerInfo(ctx_);
  ProcessProtocolMessagesWithViewID(info, 1);

  const char* buf = R"(function test() {
    let a = 1;
    console.log(a++);
  }
  test();
  )";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "test_pause_on_next_statement_1.js",
                 LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  for (size_t i = 0; i < 2; i++) {
    // Pop response of Debugger.enable and Debugger.scriptParsed.
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  // Get Debugger.paused message.
  std::string paused_msg = QjsDebugQueue::GetReceiveMessageQueue().front();

  // Check pause.
  CheckStatementPause(ctx_, 0, 16, paused_msg);

  // Check reason.
  {
    LEPUSValue json =
        LEPUS_ParseJSON(ctx_, paused_msg.c_str(), paused_msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue params = LEPUS_GetPropertyStr(ctx_, json, "params");
    LEPUSValue paused_reason = LEPUS_GetPropertyStr(ctx_, params, "reason");
    const char* paused_reason_str = LEPUS_ToCString(ctx_, paused_reason);
    ASSERT_TRUE(std::string(paused_reason_str) == "testReason");
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeCString(ctx_, paused_reason_str);
      LEPUS_FreeValue(ctx_, paused_reason);
      LEPUS_FreeValue(ctx_, params);
      LEPUS_FreeValue(ctx_, json);
    }
  }

  // Send Debugger.pauseOnNextStatement and call LEPUS_Eval again.
  // Check if it can pause again.
  QjsDebugQueue::GetSendMessageQueue().push(pause_on_next_statement_2);
  ProcessProtocolMessagesWithViewID(info, 1);
  ret = LEPUS_Eval(ctx_, buf, strlen(buf), "test_pause_on_next_statement_2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Pop Debugger.scriptParsed.
  QjsDebugQueue::GetReceiveMessageQueue().pop();

  // Get Debugger.paused message.
  paused_msg = QjsDebugQueue::GetReceiveMessageQueue().front();

  // Check pause.
  CheckStatementPause(ctx_, 0, 16, paused_msg);

  // Check reason.
  {
    LEPUSValue json =
        LEPUS_ParseJSON(ctx_, paused_msg.c_str(), paused_msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue params = LEPUS_GetPropertyStr(ctx_, json, "params");
    LEPUSValue paused_reason = LEPUS_GetPropertyStr(ctx_, params, "reason");
    const char* paused_reason_str = LEPUS_ToCString(ctx_, paused_reason);
    // Default reason is "stopAtEntry".
    ASSERT_TRUE(std::string(paused_reason_str) == "stopAtEntry");
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeCString(ctx_, paused_reason_str);
      LEPUS_FreeValue(ctx_, paused_reason);
      LEPUS_FreeValue(ctx_, params);
      LEPUS_FreeValue(ctx_, json);
    }
  }
}

TEST_F(QjsDebugMethods, TestScriptUrl) {
  auto funcs = GetQJSCallbackFuncs();
  RegisterQJSDebuggerCallbacks(rt_, funcs.data(), funcs.size());

  std::string debugger_enable =
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}";
  const char* source1 = R"(function test() {
    let a = 1;
    console.log(a++);
  }
  test();
  //# sourceURL=test_source_url.js
  )";
  const char* source2 = R"(function test() {
    let a = 1;
    console.log(a++);
  }
  test();
  //# sourceURL=source1.js
  )";

  // Test case 1: Check URL when filename is specified
  QjsDebugQueue::GetSendMessageQueue().push(debugger_enable);
  LEPUSValue ret = LEPUS_Eval(ctx_, source1, strlen(source1), "source1.js",
                              LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  // Pop response of Debugger.enable
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  std::string script_parsed_msg =
      QjsDebugQueue::GetReceiveMessageQueue().front();
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  {
    LEPUSValue json = LEPUS_ParseJSON(ctx_, script_parsed_msg.c_str(),
                                      script_parsed_msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue params = LEPUS_GetPropertyStr(ctx_, json, "params");
    LEPUSValue url = LEPUS_GetPropertyStr(ctx_, params, "url");
    const char* url_str = LEPUS_ToCString(ctx_, url);
    ASSERT_EQ(std::string(url_str), "source1.js");
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeCString(ctx_, url_str);
      LEPUS_FreeValue(ctx_, url);
      LEPUS_FreeValue(ctx_, params);
      LEPUS_FreeValue(ctx_, json);
    }
  }

  // Test case 2: Check URL when no filename is specified, but sourceURL is
  // present in the script
  ret = LEPUS_Eval(ctx_, source1, strlen(source1), "", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  script_parsed_msg = QjsDebugQueue::GetReceiveMessageQueue().front();
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  {
    LEPUSValue json = LEPUS_ParseJSON(ctx_, script_parsed_msg.c_str(),
                                      script_parsed_msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue params = LEPUS_GetPropertyStr(ctx_, json, "params");
    LEPUSValue url = LEPUS_GetPropertyStr(ctx_, params, "url");
    const char* url_str = LEPUS_ToCString(ctx_, url);
    ASSERT_EQ(std::string(url_str), "test_source_url.js");
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeCString(ctx_, url_str);
      LEPUS_FreeValue(ctx_, url);
      LEPUS_FreeValue(ctx_, params);
      LEPUS_FreeValue(ctx_, json);
    }
  }

  // Test case 3: Check URL when filename is specified as a parameter and
  // sourceURL is present in the script; filename should take precedence
  ret = LEPUS_Eval(ctx_, source2, strlen(source2), "source2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  script_parsed_msg = QjsDebugQueue::GetReceiveMessageQueue().front();
  QjsDebugQueue::GetReceiveMessageQueue().pop();
  {
    LEPUSValue json = LEPUS_ParseJSON(ctx_, script_parsed_msg.c_str(),
                                      script_parsed_msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue params = LEPUS_GetPropertyStr(ctx_, json, "params");
    LEPUSValue url = LEPUS_GetPropertyStr(ctx_, params, "url");
    const char* url_str = LEPUS_ToCString(ctx_, url);
    ASSERT_EQ(std::string(url_str), "source2.js");
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeCString(ctx_, url_str);
      LEPUS_FreeValue(ctx_, url);
      LEPUS_FreeValue(ctx_, params);
      LEPUS_FreeValue(ctx_, json);
    }
  }
}

// Tests for Runtime.releaseObjectGroup and Runtime.releaseObject
// These tests verify the object group lifecycle: objects created during
// Runtime.evaluate with an objectGroup param go into the group registry,
// and can be released via Runtime.releaseObjectGroup or Runtime.releaseObject.

TEST_F(QjsDebugMethods, TestReleaseObjectGroup) {
  // Enable Runtime and Debugger
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Drain setup messages
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Evaluate an expression with objectGroup "testGroup"
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({a:1, b:2})\","
      "\"objectGroup\":\"testGroup\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify group was created and has objects
  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  ASSERT_TRUE(info->object_group_lengths.count("testGroup") > 0);
  ASSERT_TRUE(info->object_group_lengths["testGroup"] > 0);

  // running_state should not have grown (object went to group)
  uint32_t running_len_before = info->running_state.get_properties_array_len;

  // Drain messages
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Release the object group
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":11,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"testGroup\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify group is gone
  ASSERT_TRUE(info->object_group_lengths.count("testGroup") == 0);

  // Verify running_state was not affected
  ASSERT_EQ(info->running_state.get_properties_array_len, running_len_before);
}

TEST_F(QjsDebugMethods, TestReleaseObjectGroupMultipleGroups) {
  // Enable Runtime and Debugger
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Create two groups
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({x:1})\","
      "\"objectGroup\":\"groupA\"}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":11,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({y:2})\","
      "\"objectGroup\":\"groupB\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  ASSERT_TRUE(info->object_group_lengths.count("groupA") > 0);
  ASSERT_TRUE(info->object_group_lengths.count("groupB") > 0);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Release only groupA
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":12,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"groupA\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // groupA gone, groupB still present
  ASSERT_TRUE(info->object_group_lengths.count("groupA") == 0);
  ASSERT_TRUE(info->object_group_lengths.count("groupB") > 0);
  ASSERT_TRUE(info->object_group_lengths["groupB"] > 0);
}

TEST_F(QjsDebugMethods, TestReleaseObject) {
  // Enable Runtime and Debugger
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Evaluate with objectGroup to get a known objectId
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({releaseMe:true})\","
      "\"objectGroup\":\"releaseTest\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Find the objectId from the response
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        // Extract result.result.objectId
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }

  ASSERT_FALSE(object_id.empty());

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  ASSERT_TRUE(info->object_group_lengths.count("releaseTest") > 0);
  uint32_t group_len_before = info->object_group_lengths["releaseTest"];
  ASSERT_TRUE(group_len_before > 0);

  // Release the specific object by objectId
  std::string release_msg =
      "{\"id\":11,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"" +
      object_id + "\"}}";
  QjsDebugQueue::GetSendMessageQueue().push(release_msg);
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // The group still exists (just one slot nullified), but we got a response
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 11) {
        // Verify we got a successful response (has "result" key)
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        ASSERT_TRUE(LEPUS_IsObject(result));
        if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, result);
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }

  // Since this was the only object in the group, the group should be
  // cleaned up entirely (deleted from registry when ids_set becomes empty).
  ASSERT_EQ(info->object_group_lengths.count("releaseTest"), 0u);
  ASSERT_EQ(info->object_group_ids.count("releaseTest"), 0u);

  // The group property should no longer exist in the registry
  LEPUSValue group_array =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "releaseTest");
  ASSERT_TRUE(LEPUS_IsUndefined(group_array));
  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, group_array);
  }

  // The objectId should be removed from the reverse mapping
  uint64_t obj_ptr = strtoull(object_id.c_str(), nullptr, 10);
  ASSERT_EQ(info->object_id_to_groups.count(obj_ptr), 0u);
}

TEST_F(QjsDebugMethods, TestObjectGroupRoutingToRunningState) {
  // Verify that objects without objectGroup still go to running_state
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  uint32_t running_len_before = info->running_state.get_properties_array_len;

  // Evaluate WITHOUT objectGroup — should go to running_state
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({noGroup:true})\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // running_state should have grown
  ASSERT_TRUE(info->running_state.get_properties_array_len >
              running_len_before);

  // No new groups should have been created
  ASSERT_TRUE(info->object_group_lengths.empty());
}

TEST_F(QjsDebugMethods, TestReleaseObjectGroupNonexistent) {
  // Releasing a non-existent group should not crash
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Release a group that was never created
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"nonexistent\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Should get a response without crashing
  bool got_response = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) got_response = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_TRUE(got_response);
}

TEST_F(QjsDebugMethods, TestReleaseObjectWithConsoleObjectId) {
  // Console object IDs (format "console:...") should not be affected by
  // releaseObject — it should just return success without modifying anything
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Try to release a console-format objectId — should not crash
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"console:0:1:0\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Should get a response without crashing
  bool got_response = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) got_response = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_TRUE(got_response);
}

TEST_F(QjsDebugMethods, TestCallFunctionOnObjectGroup) {
  // Enable Runtime and Debugger
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  uint32_t running_len_before = info->running_state.get_properties_array_len;

  // First evaluate to get an objectId to use as thisObj for callFunctionOn
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({val:42})\","
      "\"objectGroup\":\"setupGroup\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Extract objectId from response
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  // Now call callFunctionOn with objectGroup "callGroup"
  std::string call_msg =
      "{\"id\":20,\"method\":\"Runtime.callFunctionOn\",\"params\":{"
      "\"functionDeclaration\":\"function() { return {derived:true}; }\","
      "\"objectId\":\"" +
      object_id +
      "\","
      "\"objectGroup\":\"callGroup\"}}";
  QjsDebugQueue::GetSendMessageQueue().push(call_msg);
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify "callGroup" was created
  ASSERT_TRUE(info->object_group_lengths.count("callGroup") > 0);
  ASSERT_TRUE(info->object_group_lengths["callGroup"] > 0);

  // Drain messages
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Release the callGroup
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":21,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"callGroup\"}}");
  const char* trigger3 = "function t3() {}; t3();\n";
  ret = LEPUS_Eval(ctx_, trigger3, strlen(trigger3), "trigger3.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify callGroup is gone
  ASSERT_TRUE(info->object_group_lengths.count("callGroup") == 0);
}

TEST_F(QjsDebugMethods, TestCallFunctionOnWithoutObjectGroup) {
  // Verify backward compatibility: callFunctionOn without objectGroup
  // still routes objects to running_state
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  uint32_t running_len_before = info->running_state.get_properties_array_len;

  // callFunctionOn without objectGroup
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.callFunctionOn\",\"params\":{"
      "\"functionDeclaration\":\"function() { return {noGroup:true}; }\","
      "\"executionContextId\":1}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // running_state should have grown (no group means fallback to running_state)
  ASSERT_TRUE(info->running_state.get_properties_array_len >
              running_len_before);

  // No object groups should have been created
  ASSERT_TRUE(info->object_group_lengths.count("") == 0);
}

// --- Group Inheritance Tests ---
// Verify that Runtime.getProperties on an objectId belonging to a group
// causes sub-objects to inherit the same group (V8 behavior).

TEST_F(QjsDebugMethods, TestGetPropertiesGroupInheritance) {
  // Enable Runtime and Debugger
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  uint32_t running_len_before = info->running_state.get_properties_array_len;

  // Evaluate an object with nested properties, using objectGroup "inherit"
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({nested: {child: 42}, arr: [1,2,3]})\","
      "\"objectGroup\":\"inherit\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify group was created
  ASSERT_TRUE(info->object_group_lengths.count("inherit") > 0);
  uint32_t group_len_after_eval = info->object_group_lengths["inherit"];
  ASSERT_TRUE(group_len_after_eval > 0);

  // Extract objectId from evaluate response
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  // Verify parent objectId is in the reverse mapping
  uint64_t parent_ptr = strtoull(object_id.c_str(), nullptr, 10);
  ASSERT_TRUE(info->object_id_to_groups.count(parent_ptr) > 0);
  ASSERT_TRUE(info->object_id_to_groups[parent_ptr].count("inherit") > 0);

  // Now call getProperties on the parent — sub-objects should inherit "inherit"
  SendRuntimeGetProperties(ctx_, 11, object_id);
  std::string props_response = PopResponseById(ctx_, 11);
  ASSERT_FALSE(props_response.empty());

  // Group length should have grown (sub-objects added to same group)
  ASSERT_TRUE(info->object_group_lengths["inherit"] > group_len_after_eval);

  // running_state should NOT have grown (sub-objects went to group, not there)
  ASSERT_EQ(info->running_state.get_properties_array_len, running_len_before);

  // Verify sub-objects are also in the reverse mapping with same group
  bool found_sub_object = false;
  for (auto& [ptr, groups] : info->object_id_to_groups) {
    if (ptr != parent_ptr && groups.count("inherit") > 0) {
      found_sub_object = true;
      break;
    }
  }
  ASSERT_TRUE(found_sub_object);
}

TEST_F(QjsDebugMethods, TestGetPropertiesReleaseGroupFreesSubObjects) {
  // Verify that releaseObjectGroup releases both parent and all sub-objects
  // created via getProperties inheritance.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);

  // Evaluate with objectGroup "releaseInherit"
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({sub: {deep: {val: 999}}})\","
      "\"objectGroup\":\"releaseInherit\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Extract objectId
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  // Call getProperties to create sub-objects in the same group
  SendRuntimeGetProperties(ctx_, 11, object_id);
  PopResponseById(ctx_, 11);

  // Verify group grew and reverse mapping has entries
  ASSERT_TRUE(info->object_group_lengths["releaseInherit"] > 1);
  size_t reverse_map_count = 0;
  for (auto& [ptr, groups] : info->object_id_to_groups) {
    if (groups.count("releaseInherit") > 0) reverse_map_count++;
  }
  ASSERT_TRUE(reverse_map_count > 1);  // parent + at least one sub-object

  // Now releaseObjectGroup — should wipe everything
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":12,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"releaseInherit\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify group is completely gone
  ASSERT_EQ(info->object_group_lengths.count("releaseInherit"), 0u);

  // Verify reverse mapping is cleaned up (no entries for this group)
  for (auto& [ptr, groups] : info->object_id_to_groups) {
    ASSERT_EQ(groups.count("releaseInherit"), 0u);
  }
}

TEST_F(QjsDebugMethods, TestGetPropertiesWithoutGroupGoesToRunningState) {
  // Verify that getProperties on an object NOT in any group
  // still routes sub-objects to running_state (backward compatibility).
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);

  // Evaluate WITHOUT objectGroup
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({noGroup: {inner: 1}})\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Extract objectId from response
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  // Object should NOT be in any reverse mapping (no group was set)
  uint64_t parent_ptr = strtoull(object_id.c_str(), nullptr, 10);
  ASSERT_EQ(info->object_id_to_groups.count(parent_ptr), 0u);

  // Record running_state length before getProperties
  uint32_t running_len_before = info->running_state.get_properties_array_len;

  // Call getProperties — sub-objects should go to running_state
  SendRuntimeGetProperties(ctx_, 11, object_id);
  PopResponseById(ctx_, 11);

  // running_state should have grown
  ASSERT_TRUE(info->running_state.get_properties_array_len >
              running_len_before);
}

TEST_F(QjsDebugMethods, TestReleaseObjectRemovesReverseMapping) {
  // Verify that releaseObject on a parent also cleans up the reverse mapping.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);

  // Evaluate with objectGroup "reverseTest"
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({reverseMapTest: true})\","
      "\"objectGroup\":\"reverseTest\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Extract objectId
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  // Verify the object is in reverse mapping
  uint64_t parent_ptr = strtoull(object_id.c_str(), nullptr, 10);
  ASSERT_TRUE(info->object_id_to_groups.count(parent_ptr) > 0);
  ASSERT_TRUE(info->object_id_to_groups[parent_ptr].count("reverseTest") > 0);

  // Release the specific object
  std::string release_msg =
      "{\"id\":11,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"" +
      object_id + "\"}}";
  QjsDebugQueue::GetSendMessageQueue().push(release_msg);
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Drain response
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Verify the object is removed from reverse mapping
  ASSERT_EQ(info->object_id_to_groups.count(parent_ptr), 0u);
}

TEST_F(QjsDebugMethods, TestGetPropertiesDeepInheritance) {
  // Verify group inheritance works across multiple levels of getProperties:
  // evaluate -> getProperties(parent) -> getProperties(child)
  // All objects at every level should be in the same group.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);

  // Evaluate deeply nested object
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({level1: {level2: {level3: {val: 1}}}})\","
      "\"objectGroup\":\"deepGroup\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Extract root objectId
  std::string root_object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) root_object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(root_object_id.empty());

  uint32_t group_len_after_eval = info->object_group_lengths["deepGroup"];

  // getProperties on root (level 0 -> level 1 sub-objects)
  SendRuntimeGetProperties(ctx_, 11, root_object_id);
  std::string props_response = PopResponseById(ctx_, 11);
  ASSERT_FALSE(props_response.empty());

  uint32_t group_len_after_level1 = info->object_group_lengths["deepGroup"];
  ASSERT_TRUE(group_len_after_level1 > group_len_after_eval);

  // Extract a sub-object objectId (the "level1" property value)
  LEPUSValue result_array = GetPropertiesResultArray(ctx_, props_response);
  HandleScope scope(ctx_, &result_array, HANDLE_TYPE_LEPUS_VALUE);
  std::string child_object_id;
  if (LEPUS_IsObject(result_array)) {
    uint32_t len = LEPUS_GetLength(ctx_, result_array);
    for (uint32_t i = 0; i < len; i++) {
      LEPUSValue prop = LEPUS_GetPropertyUint32(ctx_, result_array, i);
      LEPUSValue val = LEPUS_GetPropertyStr(ctx_, prop, "value");
      if (LEPUS_IsObject(val)) {
        LEPUSValue oid_val = LEPUS_GetPropertyStr(ctx_, val, "objectId");
        if (LEPUS_IsString(oid_val)) {
          const char* oid_str = LEPUS_ToCString(ctx_, oid_val);
          if (oid_str && child_object_id.empty()) {
            child_object_id = oid_str;
          }
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid_str);
        }
        if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, oid_val);
      }
      if (!ctx_->rt->gc_enable) {
        LEPUS_FreeValue(ctx_, val);
        LEPUS_FreeValue(ctx_, prop);
      }
      if (!child_object_id.empty()) break;
    }
  }
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, result_array);

  ASSERT_FALSE(child_object_id.empty());

  // Verify child is in the same group's reverse mapping
  uint64_t child_ptr = strtoull(child_object_id.c_str(), nullptr, 10);
  ASSERT_TRUE(info->object_id_to_groups.count(child_ptr) > 0);
  ASSERT_TRUE(info->object_id_to_groups[child_ptr].count("deepGroup") > 0);

  // getProperties on the child (level 1 -> level 2 sub-objects)
  SendRuntimeGetProperties(ctx_, 12, child_object_id);
  PopResponseById(ctx_, 12);

  // Group should have grown further
  ASSERT_TRUE(info->object_group_lengths["deepGroup"] > group_len_after_level1);

  // Release entire group — everything should be cleaned
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":13,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"deepGroup\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  ASSERT_EQ(info->object_group_lengths.count("deepGroup"), 0u);
  for (auto& [ptr, groups] : info->object_id_to_groups) {
    ASSERT_EQ(groups.count("deepGroup"), 0u);
  }
}

TEST_F(QjsDebugMethods, TestReleaseObjectWithInvalidObjectId) {
  // Verify that releaseObject with non-numeric objectId does not crash
  // or produce garbage pointer values (Issue 1: digit validation).
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);

  // Create an object in a group so we can verify it is NOT affected
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({sentinel: 1})\","
      "\"objectGroup\":\"invalidIdTest\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Snapshot state before invalid release attempts
  uint32_t group_len_before = info->object_group_lengths["invalidIdTest"];
  size_t reverse_map_size_before = info->object_id_to_groups.size();
  ASSERT_TRUE(group_len_before > 0);

  // Try releasing with various invalid objectId formats
  // 1) Contains letters
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":11,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"abc123\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // 2) Contains special characters
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":12,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"123-456\"}}");
  const char* trigger3 = "function t3() {}; t3();\n";
  ret = LEPUS_Eval(ctx_, trigger3, strlen(trigger3), "trigger3.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // 3) Contains dots
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":13,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"12.34\"}}");
  const char* trigger4 = "function t4() {}; t4();\n";
  ret = LEPUS_Eval(ctx_, trigger4, strlen(trigger4), "trigger4.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Drain all responses
  bool got_response_11 = false, got_response_12 = false,
       got_response_13 = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 11) got_response_11 = true;
      if (id == 12) got_response_12 = true;
      if (id == 13) got_response_13 = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }

  // All should have received successful responses (no crash)
  ASSERT_TRUE(got_response_11);
  ASSERT_TRUE(got_response_12);
  ASSERT_TRUE(got_response_13);

  // Verify state was NOT modified by invalid objectIds
  ASSERT_EQ(info->object_group_lengths["invalidIdTest"], group_len_before);
  ASSERT_EQ(info->object_id_to_groups.size(), reverse_map_size_before);
}

TEST_F(QjsDebugMethods, TestReleaseObjectSyncsObjectGroupIds) {
  // Verify that releaseObject properly removes the object from
  // object_group_ids vector (Issue 2: data consistency).
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);

  // Create two objects in the same group
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({first: 1})\","
      "\"objectGroup\":\"syncTest\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string first_object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) first_object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(first_object_id.empty());

  // Create second object in same group
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":20,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({second: 2})\","
      "\"objectGroup\":\"syncTest\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string second_object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 20) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) second_object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(second_object_id.empty());

  // Parse pointer values
  uint64_t first_ptr = strtoull(first_object_id.c_str(), nullptr, 10);
  uint64_t second_ptr = strtoull(second_object_id.c_str(), nullptr, 10);

  // Both should be in reverse mapping and object_group_ids
  ASSERT_EQ(info->object_id_to_groups.count(first_ptr), 1u);
  ASSERT_EQ(info->object_id_to_groups.count(second_ptr), 1u);
  auto& ids_vec = info->object_group_ids["syncTest"];
  ASSERT_EQ(ids_vec.count(first_ptr), 1u);
  ASSERT_EQ(ids_vec.count(second_ptr), 1u);
  size_t ids_vec_size_before = ids_vec.size();

  // Release the first object
  std::string release_msg =
      "{\"id\":30,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"" +
      first_object_id + "\"}}";
  QjsDebugQueue::GetSendMessageQueue().push(release_msg);
  const char* trigger3 = "function t3() {}; t3();\n";
  ret = LEPUS_Eval(ctx_, trigger3, strlen(trigger3), "trigger3.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Verify: first_ptr removed from both object_id_to_groups AND
  // object_group_ids
  ASSERT_EQ(info->object_id_to_groups.count(first_ptr), 0u);
  auto& ids_vec_after = info->object_group_ids["syncTest"];
  ASSERT_EQ(ids_vec_after.count(first_ptr), 0u);
  // second_ptr should still be present
  ASSERT_EQ(info->object_id_to_groups.count(second_ptr), 1u);
  ASSERT_EQ(ids_vec_after.count(second_ptr), 1u);
  // Set should have shrunk by 1
  ASSERT_EQ(ids_vec_after.size(), ids_vec_size_before - 1);
}

TEST_F(QjsDebugMethods, TestReleaseObjectThenGroupCleansUpCompletely) {
  // Verify that releasing individual objects, then releasing the group,
  // leaves no stale entries in any data structure.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);

  // Create object in group
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({combo: true})\","
      "\"objectGroup\":\"comboTest\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  uint64_t obj_ptr = strtoull(object_id.c_str(), nullptr, 10);

  // Release the object individually first
  std::string release_msg =
      "{\"id\":11,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"" +
      object_id + "\"}}";
  QjsDebugQueue::GetSendMessageQueue().push(release_msg);
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Object is removed from reverse mapping, and since it was the only object
  // in this group, the group itself should be cleaned up automatically.
  ASSERT_EQ(info->object_id_to_groups.count(obj_ptr), 0u);
  ASSERT_EQ(info->object_group_lengths.count("comboTest"), 0u);
  ASSERT_EQ(info->object_group_ids.count("comboTest"), 0u);

  // Now release the entire group
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":12,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"comboTest\"}}");
  const char* trigger3 = "function t3() {}; t3();\n";
  ret = LEPUS_Eval(ctx_, trigger3, strlen(trigger3), "trigger3.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Everything should be cleaned: no crash, no stale entries
  ASSERT_EQ(info->object_group_lengths.count("comboTest"), 0u);
  ASSERT_EQ(info->object_group_ids.count("comboTest"), 0u);
  for (auto& [ptr, groups] : info->object_id_to_groups) {
    ASSERT_EQ(groups.count("comboTest"), 0u);
  }
}

TEST_F(QjsDebugMethods, TestReleaseObjectWithEmptyObjectId) {
  // Verify that releaseObject with empty objectId does not crash.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Empty objectId
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Should get a response without crash
  bool got_response = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) got_response = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_TRUE(got_response);
}

TEST_F(QjsDebugMethods, TestReleaseObjectGroupPreservesOtherGroupInheritance) {
  // Verify that when the same object is assigned to two groups (groupA then
  // groupB), releasing groupA does NOT destroy groupB's reverse mapping
  // (object_id_to_groups should still contain groupB for inheritance).
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Create a global object that we can reference from both groups
  const char* setup_obj = "var sharedObj = {shared: true};\n";
  ret = LEPUS_Eval(ctx_, setup_obj, strlen(setup_obj), "shared.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Evaluate sharedObj with groupA
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"sharedObj\","
      "\"objectGroup\":\"groupA\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  std::string shared_object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) shared_object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(shared_object_id.empty());

  // Evaluate same sharedObj with groupB — this adds groupB to
  // object_id_to_groups
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":11,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"sharedObj\","
      "\"objectGroup\":\"groupB\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Parse pointer value
  uint64_t shared_ptr = strtoull(shared_object_id.c_str(), nullptr, 10);

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);

  // Verify: object is in both groups' object_group_ids
  ASSERT_EQ(info->object_group_ids["groupA"].count(shared_ptr), 1u);
  ASSERT_EQ(info->object_group_ids["groupB"].count(shared_ptr), 1u);
  // Reverse mapping should contain both groups
  ASSERT_TRUE(info->object_id_to_groups[shared_ptr].count("groupA") > 0);
  ASSERT_TRUE(info->object_id_to_groups[shared_ptr].count("groupB") > 0);

  // Release groupA
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":12,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"groupA\"}}");
  const char* trigger3 = "function t3() {}; t3();\n";
  ret = LEPUS_Eval(ctx_, trigger3, strlen(trigger3), "trigger3.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // groupA is gone
  ASSERT_EQ(info->object_group_ids.count("groupA"), 0u);
  ASSERT_EQ(info->object_group_lengths.count("groupA"), 0u);

  // Key assertion: reverse mapping still contains groupB (groupA removed)
  auto it = info->object_id_to_groups.find(shared_ptr);
  ASSERT_NE(it, info->object_id_to_groups.end());
  ASSERT_TRUE(it->second.count("groupB") > 0);
  ASSERT_EQ(it->second.count("groupA"), 0u);

  // groupB still has the object
  ASSERT_EQ(info->object_group_ids["groupB"].count(shared_ptr), 1u);
}

TEST_F(QjsDebugMethods, TestReleaseObjectGroupWithMissingParam) {
  // Verify that releaseObjectGroup without objectGroup param (undefined)
  // does not crash and returns a valid response.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Create an object in a group first so we can verify it's untouched
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({safe: true})\","
      "\"objectGroup\":\"safeGroup\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  ASSERT_TRUE(info->object_group_lengths.count("safeGroup") > 0);
  uint32_t safe_len_before = info->object_group_lengths["safeGroup"];

  // 1) Missing objectGroup entirely (no "objectGroup" key in params)
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":20,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // 2) objectGroup is null
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":21,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":null}}");
  const char* trigger3 = "function t3() {}; t3();\n";
  ret = LEPUS_Eval(ctx_, trigger3, strlen(trigger3), "trigger3.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // 3) objectGroup is a number (not a string)
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":22,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":12345}}");
  const char* trigger4 = "function t4() {}; t4();\n";
  ret = LEPUS_Eval(ctx_, trigger4, strlen(trigger4), "trigger4.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Drain all responses
  bool got_20 = false, got_21 = false, got_22 = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 20) got_20 = true;
      if (id == 21) got_21 = true;
      if (id == 22) got_22 = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }

  // All should have received responses without crash
  ASSERT_TRUE(got_20);
  ASSERT_TRUE(got_21);
  ASSERT_TRUE(got_22);

  // Existing group should be completely untouched
  ASSERT_EQ(info->object_group_lengths["safeGroup"], safe_len_before);
}

TEST_F(QjsDebugMethods, TestReleaseObjectFromRunningState) {
  // Verify that releaseObject works for objects NOT in any group
  // (those stored in running_state.get_properties_array).
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  uint32_t running_len_before = info->running_state.get_properties_array_len;

  // Evaluate WITHOUT objectGroup — object goes to running_state
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({runningObj: 42})\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // running_state should have grown
  ASSERT_GT(info->running_state.get_properties_array_len, running_len_before);

  // Extract objectId from response
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  // Object should NOT be in any group's reverse mapping
  uint64_t obj_ptr = strtoull(object_id.c_str(), nullptr, 10);
  ASSERT_EQ(info->object_id_to_groups.count(obj_ptr), 0u);

  // Release the object — should hit running_state fallback path
  std::string release_msg =
      "{\"id\":11,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"" +
      object_id + "\"}}";
  QjsDebugQueue::GetSendMessageQueue().push(release_msg);
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify response received without crash
  bool got_response = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 11) got_response = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_TRUE(got_response);

  // Verify the object was released — ReleaseObjectFromArray trims trailing
  // undefined slots, so the array length should have shrunk back.
  ASSERT_LE(info->running_state.get_properties_array_len, running_len_before);
}

TEST_F(QjsDebugMethods, TestEvaluateWithNonStringObjectGroup) {
  // Verify that evaluate with non-string objectGroup (null, number)
  // does NOT create a bogus group — objects should go to running_state.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  uint32_t running_len_before = info->running_state.get_properties_array_len;
  size_t group_count_before = info->object_group_lengths.size();

  // 1) objectGroup is null
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({nullGroup: 1})\","
      "\"objectGroup\":null}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // 2) objectGroup is a number
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":11,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({numGroup: 2})\","
      "\"objectGroup\":999}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // No new groups should have been created
  ASSERT_EQ(info->object_group_lengths.size(), group_count_before);

  // Objects should have gone to running_state instead
  ASSERT_GT(info->running_state.get_properties_array_len, running_len_before);
}

TEST_F(QjsDebugMethods, TestReleaseObjectClearsAllDuplicateSlots) {
  // Verify that when the same object is evaluated multiple times into the same
  // group (creating multiple DupValue'd slots), releaseObject clears ALL of
  // them — not just the first match.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf =
      "var dupObj = {dup: true};\n"
      "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);

  // Evaluate the SAME object twice with the same objectGroup.
  // Each evaluation will DupValue the object into the group's array.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"dupObj\","
      "\"objectGroup\":\"dupGroup\"}}");
  const char* trigger1 = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger1, strlen(trigger1), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":11,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"dupObj\","
      "\"objectGroup\":\"dupGroup\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Extract objectId from first response
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10 && object_id.empty()) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  // The group should have at least 2 entries (same object registered twice)
  ASSERT_GE(info->object_group_lengths["dupGroup"], 2u);

  // Parse the pointer value
  uint64_t obj_ptr = strtoull(object_id.c_str(), nullptr, 10);

  // Count how many slots in the group array hold our object BEFORE release
  LEPUSValue group_array_before =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "dupGroup");
  uint32_t array_len = LEPUS_GetLength(ctx_, group_array_before);
  uint32_t match_count_before = 0;
  for (uint32_t i = 0; i < array_len; i++) {
    LEPUSValue elem = LEPUS_GetPropertyUint32(ctx_, group_array_before, i);
    if (LEPUS_IsObject(elem)) {
      LEPUSObject* p = LEPUS_VALUE_GET_OBJ(elem);
      if ((uint64_t)p == obj_ptr) match_count_before++;
    }
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, elem);
  }
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, group_array_before);
  ASSERT_GE(match_count_before, 2u);

  // Release the single object — should clear ALL duplicate slots
  std::string release_msg =
      "{\"id\":20,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"" +
      object_id + "\"}}";
  QjsDebugQueue::GetSendMessageQueue().push(release_msg);
  const char* trigger3 = "function t3() {}; t3();\n";
  ret = LEPUS_Eval(ctx_, trigger3, strlen(trigger3), "trigger3.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Drain response
  bool got_response = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 20) got_response = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_TRUE(got_response);

  // Verify ALL slots with this object are now UNDEFINED
  LEPUSValue group_array_after =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "dupGroup");
  uint32_t match_count_after = 0;
  // The group array may still exist (other objects could be in it)
  if (LEPUS_IsArray(ctx_, group_array_after)) {
    uint32_t len_after = LEPUS_GetLength(ctx_, group_array_after);
    for (uint32_t i = 0; i < len_after; i++) {
      LEPUSValue elem = LEPUS_GetPropertyUint32(ctx_, group_array_after, i);
      if (LEPUS_IsObject(elem)) {
        LEPUSObject* p = LEPUS_VALUE_GET_OBJ(elem);
        if ((uint64_t)p == obj_ptr) match_count_after++;
      }
      if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, elem);
    }
  }
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, group_array_after);

  // No remaining references to the object in the group array
  ASSERT_EQ(match_count_after, 0u);

  // Reverse mapping should be cleaned up
  ASSERT_EQ(info->object_id_to_groups.count(obj_ptr), 0u);
}

TEST_F(QjsDebugMethods, TestReleaseObjectWithScopeObjectId) {
  // Verify that releaseObject with "scope:" prefix objectId is correctly
  // filtered and does not crash or modify any state.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  uint32_t running_len_before = info->running_state.get_properties_array_len;
  size_t groups_before = info->object_group_lengths.size();

  // Try to release scope-format objectIds — should not crash
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"scope:0\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":11,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"scope:1\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Should get responses without crashing
  bool got_response_10 = false, got_response_11 = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) got_response_10 = true;
      if (id == 11) got_response_11 = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_TRUE(got_response_10);
  ASSERT_TRUE(got_response_11);

  // Verify no state was modified
  ASSERT_EQ(info->running_state.get_properties_array_len, running_len_before);
  ASSERT_EQ(info->object_group_lengths.size(), groups_before);
}

TEST_F(QjsDebugMethods, TestEvaluateWithEmptyStringObjectGroup) {
  // Verify that evaluate with objectGroup="" routes objects to running_state,
  // not a new group.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  uint32_t running_len_before = info->running_state.get_properties_array_len;
  size_t groups_before = info->object_group_lengths.size();

  // Evaluate with empty string objectGroup
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({emptyGroup:1})\","
      "\"objectGroup\":\"\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify running_state grew (object went to running_state, not a group)
  ASSERT_GT(info->running_state.get_properties_array_len, running_len_before);

  // Verify no new group was created (including no "" group)
  ASSERT_EQ(info->object_group_lengths.size(), groups_before);
  ASSERT_EQ(info->object_group_lengths.count(""), 0u);
}

// Pause callback for TestPausedStateOverridesObjectGroup:
// Sends Runtime.evaluate with objectGroup during pause, then resumes.
static void PauseCBEvaluateWithObjectGroup(LEPUSContext* ctx) {
  std::string evaluate_msg =
      "{\"id\":50,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({pausedObj:1})\","
      "\"objectGroup\":\"pauseGroup\"}}";
  std::string resume_message =
      "{\"id\":51,\"method\":\"Debugger.resume\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, evaluate_msg.c_str());
  ProcessPausedMessages(ctx, resume_message.c_str());
}

TEST_F(QjsDebugMethods, TestPausedStateOverridesObjectGroup) {
  // Verify that when paused, evaluate with objectGroup stores objects in
  // pause_state (not the object group), because GenerateUniqueObjId checks
  // pause_state.get_properties_array FIRST.

  // Register custom callbacks with our pause handler
  void* funcs[14] = {reinterpret_cast<void*>(PauseCBEvaluateWithObjectGroup),
                     reinterpret_cast<void*>(QuitMessageLoopOnPauseCB),
                     reinterpret_cast<void*>(GetMessagesCB),
                     reinterpret_cast<void*>(SendResponseCB),
                     reinterpret_cast<void*>(SendNotificationCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     nullptr,
                     nullptr,
                     nullptr,
                     nullptr,
                     reinterpret_cast<void*>(IsRuntimeDevtoolOnCB)};
  RegisterQJSDebuggerCallbacks(rt_, reinterpret_cast<void**>(funcs), 14);

  // Enable Debugger + Runtime and set breakpoint
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Debugger.setBreakpointsActive\",\"params\":{"
      "\"active\":true}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":3,\"method\":\"Debugger.setBreakpointByUrl\",\"params\":{"
      "\"lineNumber\":2,\"url\":\"test_pause_group.js\","
      "\"columnNumber\":0,\"condition\":\"\"}}");

  // Eval code that hits the breakpoint at line 2.
  // During pause, PauseCBEvaluateWithObjectGroup will execute
  // Runtime.evaluate with objectGroup="pauseGroup", then resume.
  const char* src = R"(function testPauseGroup() {
  let x = 1;
  return x;
}
testPauseGroup();
)";
  LEPUSValue ret = LEPUS_Eval(ctx_, src, strlen(src), "test_pause_group.js",
                              LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // After pause+resume cycle, verify "pauseGroup" was NOT created.
  // Objects went to pause_state which was cleaned up by PauseStateScope RAII.
  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  ASSERT_EQ(info->object_group_lengths.count("pauseGroup"), 0u);
  ASSERT_EQ(info->object_group_ids.count("pauseGroup"), 0u);

  // Verify we got the evaluate response (id=50)
  bool got_eval_response = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 50) got_eval_response = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_TRUE(got_eval_response);
}

TEST_F(QjsDebugMethods, TestReleaseObjectGroupWithEmptyString) {
  // Verify that releaseObjectGroup with objectGroup="" (empty string)
  // does not crash, returns a response, and does not modify any state.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Create an object in a real group so we can verify it's untouched
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({realGroup: 1})\","
      "\"objectGroup\":\"realGroup\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  ASSERT_TRUE(info->object_group_lengths.count("realGroup") > 0);
  uint32_t real_len_before = info->object_group_lengths["realGroup"];
  size_t groups_before = info->object_group_lengths.size();

  // Call releaseObjectGroup with empty string
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":20,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify we got a response
  bool got_response = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 20) got_response = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_TRUE(got_response);

  // Existing group should be completely untouched
  ASSERT_EQ(info->object_group_lengths["realGroup"], real_len_before);
  ASSERT_EQ(info->object_group_lengths.size(), groups_before);
}

TEST_F(QjsDebugMethods, TestReleaseObjectFromMultipleGroups) {
  // Verify that when the same object is registered in multiple groups
  // (via repeated evaluate with different objectGroup), releaseObject
  // cleans it up from ALL groups.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf =
      "var sharedObj = {multi: true};\n"
      "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Evaluate the same object under groupA
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"sharedObj\","
      "\"objectGroup\":\"groupA\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Evaluate the same object under groupB
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":11,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"sharedObj\","
      "\"objectGroup\":\"groupB\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Extract objectId from one of the evaluate responses
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10 && object_id.empty()) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  // Parse pointer value
  uint64_t obj_ptr = strtoull(object_id.c_str(), nullptr, 10);
  ASSERT_NE(obj_ptr, 0u);

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);

  // Verify the object is tracked in both groups
  ASSERT_TRUE(info->object_group_ids.count("groupA") > 0);
  ASSERT_TRUE(info->object_group_ids.count("groupB") > 0);
  ASSERT_TRUE(info->object_group_ids["groupA"].count(obj_ptr) > 0);
  ASSERT_TRUE(info->object_group_ids["groupB"].count(obj_ptr) > 0);

  // Release the object by objectId — should remove from ALL groups
  std::string release_msg =
      "{\"id\":20,\"method\":\"Runtime.releaseObject\",\"params\":{"
      "\"objectId\":\"" +
      object_id + "\"}}";
  QjsDebugQueue::GetSendMessageQueue().push(release_msg);
  const char* trigger3 = "function t3() {}; t3();\n";
  ret = LEPUS_Eval(ctx_, trigger3, strlen(trigger3), "trigger3.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Drain response
  bool got_response = false;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 20) got_response = true;
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_TRUE(got_response);

  // Verify the object is removed from reverse mapping
  ASSERT_EQ(info->object_id_to_groups.count(obj_ptr), 0u);

  // Verify the object is removed from both groups' ID sets.
  // If a group becomes empty after removal, it should be fully cleaned up.
  if (info->object_group_ids.count("groupA")) {
    ASSERT_EQ(info->object_group_ids["groupA"].count(obj_ptr), 0u);
  }
  if (info->object_group_ids.count("groupB")) {
    ASSERT_EQ(info->object_group_ids["groupB"].count(obj_ptr), 0u);
  }

  // Verify the object slot is nullified in both group arrays
  LEPUSValue group_a_array =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "groupA");
  if (LEPUS_IsArray(ctx_, group_a_array)) {
    uint32_t len = LEPUS_GetLength(ctx_, group_a_array);
    for (uint32_t i = 0; i < len; i++) {
      LEPUSValue elem = LEPUS_GetPropertyUint32(ctx_, group_a_array, i);
      if (LEPUS_IsObject(elem)) {
        LEPUSObject* p = LEPUS_VALUE_GET_OBJ(elem);
        ASSERT_NE((uint64_t)p, obj_ptr);
      }
      if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, elem);
    }
  }
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, group_a_array);

  LEPUSValue group_b_array =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "groupB");
  if (LEPUS_IsArray(ctx_, group_b_array)) {
    uint32_t len = LEPUS_GetLength(ctx_, group_b_array);
    for (uint32_t i = 0; i < len; i++) {
      LEPUSValue elem = LEPUS_GetPropertyUint32(ctx_, group_b_array, i);
      if (LEPUS_IsObject(elem)) {
        LEPUSObject* p = LEPUS_VALUE_GET_OBJ(elem);
        ASSERT_NE((uint64_t)p, obj_ptr);
      }
      if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, elem);
    }
  }
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, group_b_array);
}

// --- GC Root Set Tests for object_group_registry ---
// These tests verify that object_group_registry is properly marked as a GC root
// so objects stored in it survive garbage collection cycles.

TEST_F(QjsDebugMethods, TestObjectGroupRegistrySurvivesGC) {
  // Verify that objects in object_group_registry survive GC cycles.
  // Without the fix in collector.cc (PushObjLEPUSValue for
  // object_group_registry), these objects would be collected.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Evaluate an expression with objectGroup to store objects in registry
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({gcTestProp: 'alive', nested: {inner: 42}})\","
      "\"objectGroup\":\"gcGroup\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify group was created
  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  ASSERT_TRUE(info->object_group_lengths.count("gcGroup") > 0);
  ASSERT_TRUE(info->object_group_lengths["gcGroup"] > 0);

  // Extract objectId from response
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  // Run GC multiple times to ensure collection pressure
  LEPUS_RunGC(rt_);
  LEPUS_RunGC(rt_);
  LEPUS_RunGC(rt_);

  // Verify the registry object itself is still valid
  ASSERT_TRUE(LEPUS_IsObject(info->object_group_registry));

  // Verify group array is still accessible in the registry
  LEPUSValue group_array =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "gcGroup");
  ASSERT_TRUE(LEPUS_IsArray(ctx_, group_array));
  uint32_t len = LEPUS_GetLength(ctx_, group_array);
  ASSERT_TRUE(len > 0);

  // Verify the stored object is still alive (not collected)
  LEPUSValue elem = LEPUS_GetPropertyUint32(ctx_, group_array, 0);
  ASSERT_TRUE(LEPUS_IsObject(elem));

  // Access a property on the stored object to confirm it's not corrupted
  LEPUSValue prop = LEPUS_GetPropertyStr(ctx_, elem, "gcTestProp");
  ASSERT_TRUE(LEPUS_IsString(prop));
  const char* prop_str = LEPUS_ToCString(ctx_, prop);
  ASSERT_STREQ(prop_str, "alive");
  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeCString(ctx_, prop_str);
    LEPUS_FreeValue(ctx_, prop);
    LEPUS_FreeValue(ctx_, elem);
    LEPUS_FreeValue(ctx_, group_array);
  }

  // Verify getProperties still works on the object after GC
  SendRuntimeGetProperties(ctx_, 20, object_id);
  std::string props_response = PopResponseById(ctx_, 20);
  ASSERT_FALSE(props_response.empty());
}

TEST_F(QjsDebugMethods, TestObjectGroupRegistryMultipleGroupsSurviveGC) {
  // Verify multiple groups with multiple objects all survive GC.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Create multiple objects across two groups
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({gcA1: 'val1'})\","
      "\"objectGroup\":\"gcGroupA\"}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":11,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({gcA2: 'val2'})\","
      "\"objectGroup\":\"gcGroupA\"}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":12,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({gcB1: 'val3'})\","
      "\"objectGroup\":\"gcGroupB\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  ASSERT_TRUE(info->object_group_lengths.count("gcGroupA") > 0);
  ASSERT_TRUE(info->object_group_lengths.count("gcGroupB") > 0);
  uint32_t groupA_len = info->object_group_lengths["gcGroupA"];
  uint32_t groupB_len = info->object_group_lengths["gcGroupB"];
  ASSERT_TRUE(groupA_len >= 2);
  ASSERT_TRUE(groupB_len >= 1);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Run GC aggressively
  LEPUS_RunGC(rt_);
  LEPUS_RunGC(rt_);
  LEPUS_RunGC(rt_);

  // Verify both groups still exist and have correct lengths
  ASSERT_TRUE(info->object_group_lengths.count("gcGroupA") > 0);
  ASSERT_TRUE(info->object_group_lengths.count("gcGroupB") > 0);
  ASSERT_EQ(info->object_group_lengths["gcGroupA"], groupA_len);
  ASSERT_EQ(info->object_group_lengths["gcGroupB"], groupB_len);

  // Verify objects in gcGroupA are still alive (order may vary due to
  // recursive message processing, so check both elements order-independently)
  LEPUSValue group_a_array =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "gcGroupA");
  ASSERT_TRUE(LEPUS_IsArray(ctx_, group_a_array));
  LEPUSValue elem0 = LEPUS_GetPropertyUint32(ctx_, group_a_array, 0);
  LEPUSValue elem1 = LEPUS_GetPropertyUint32(ctx_, group_a_array, 1);
  ASSERT_TRUE(LEPUS_IsObject(elem0));
  ASSERT_TRUE(LEPUS_IsObject(elem1));
  // One element has "gcA1" and the other has "gcA2" (order not guaranteed)
  LEPUSValue prop_a1_on_0 = LEPUS_GetPropertyStr(ctx_, elem0, "gcA1");
  LEPUSValue prop_a1_on_1 = LEPUS_GetPropertyStr(ctx_, elem1, "gcA1");
  ASSERT_TRUE(LEPUS_IsString(prop_a1_on_0) || LEPUS_IsString(prop_a1_on_1));
  LEPUSValue prop_a2_on_0 = LEPUS_GetPropertyStr(ctx_, elem0, "gcA2");
  LEPUSValue prop_a2_on_1 = LEPUS_GetPropertyStr(ctx_, elem1, "gcA2");
  ASSERT_TRUE(LEPUS_IsString(prop_a2_on_0) || LEPUS_IsString(prop_a2_on_1));
  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, prop_a1_on_0);
    LEPUS_FreeValue(ctx_, prop_a1_on_1);
    LEPUS_FreeValue(ctx_, prop_a2_on_0);
    LEPUS_FreeValue(ctx_, prop_a2_on_1);
    LEPUS_FreeValue(ctx_, elem0);
    LEPUS_FreeValue(ctx_, elem1);
    LEPUS_FreeValue(ctx_, group_a_array);
  }

  // Verify objects in gcGroupB are still alive
  LEPUSValue group_b_array =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "gcGroupB");
  ASSERT_TRUE(LEPUS_IsArray(ctx_, group_b_array));
  LEPUSValue elem_b0 = LEPUS_GetPropertyUint32(ctx_, group_b_array, 0);
  ASSERT_TRUE(LEPUS_IsObject(elem_b0));
  LEPUSValue prop_b0 = LEPUS_GetPropertyStr(ctx_, elem_b0, "gcB1");
  ASSERT_TRUE(LEPUS_IsString(prop_b0));
  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, prop_b0);
    LEPUS_FreeValue(ctx_, elem_b0);
    LEPUS_FreeValue(ctx_, group_b_array);
  }

  // Release groupA, run GC, verify groupB still survives
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":20,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"gcGroupA\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  LEPUS_RunGC(rt_);
  LEPUS_RunGC(rt_);

  // groupA should be gone
  ASSERT_EQ(info->object_group_lengths.count("gcGroupA"), 0u);

  // groupB should still be alive
  ASSERT_TRUE(info->object_group_lengths.count("gcGroupB") > 0);
  LEPUSValue group_b_after =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "gcGroupB");
  ASSERT_TRUE(LEPUS_IsArray(ctx_, group_b_after));
  LEPUSValue elem_b_after = LEPUS_GetPropertyUint32(ctx_, group_b_after, 0);
  ASSERT_TRUE(LEPUS_IsObject(elem_b_after));
  LEPUSValue prop_b_after = LEPUS_GetPropertyStr(ctx_, elem_b_after, "gcB1");
  ASSERT_TRUE(LEPUS_IsString(prop_b_after));
  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeValue(ctx_, prop_b_after);
    LEPUS_FreeValue(ctx_, elem_b_after);
    LEPUS_FreeValue(ctx_, group_b_after);
  }
}

TEST_F(QjsDebugMethods, TestObjectGroupInheritanceSurvivesGC) {
  // Verify that sub-objects created via getProperties group inheritance
  // also survive GC when stored in the group registry.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Evaluate a deeply nested object with group
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({level1: {level2: {deepVal: 999}}})\","
      "\"objectGroup\":\"gcInherit\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Extract objectId
  std::string object_id;
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    std::string msg = QjsDebugQueue::GetReceiveMessageQueue().front();
    QjsDebugQueue::GetReceiveMessageQueue().pop();
    LEPUSValue json = LEPUS_ParseJSON(ctx_, msg.c_str(), msg.length(), "");
    HandleScope func_scope(ctx_, &json, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue id_val = LEPUS_GetPropertyStr(ctx_, json, "id");
    if (!LEPUS_IsUndefined(id_val)) {
      int32_t id = 0;
      LEPUS_ToInt32(ctx_, &id, id_val);
      if (id == 10) {
        LEPUSValue result = LEPUS_GetPropertyStr(ctx_, json, "result");
        LEPUSValue inner_result = LEPUS_GetPropertyStr(ctx_, result, "result");
        LEPUSValue obj_id_val =
            LEPUS_GetPropertyStr(ctx_, inner_result, "objectId");
        if (LEPUS_IsString(obj_id_val)) {
          const char* oid = LEPUS_ToCString(ctx_, obj_id_val);
          if (oid) object_id = oid;
          if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, oid);
        }
        if (!ctx_->rt->gc_enable) {
          LEPUS_FreeValue(ctx_, obj_id_val);
          LEPUS_FreeValue(ctx_, inner_result);
          LEPUS_FreeValue(ctx_, result);
        }
      }
    }
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeValue(ctx_, id_val);
      LEPUS_FreeValue(ctx_, json);
    }
  }
  ASSERT_FALSE(object_id.empty());

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  uint32_t group_len_before_props = info->object_group_lengths["gcInherit"];

  // Call getProperties to trigger group inheritance for sub-objects
  SendRuntimeGetProperties(ctx_, 11, object_id);
  std::string props_response = PopResponseById(ctx_, 11);
  ASSERT_FALSE(props_response.empty());

  // Group should have grown due to inheritance
  uint32_t group_len_after_props = info->object_group_lengths["gcInherit"];
  ASSERT_TRUE(group_len_after_props > group_len_before_props);

  // Run GC aggressively
  LEPUS_RunGC(rt_);
  LEPUS_RunGC(rt_);
  LEPUS_RunGC(rt_);

  // Verify registry and group are still intact
  ASSERT_TRUE(LEPUS_IsObject(info->object_group_registry));
  LEPUSValue group_array =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "gcInherit");
  ASSERT_TRUE(LEPUS_IsArray(ctx_, group_array));
  uint32_t len_after_gc = LEPUS_GetLength(ctx_, group_array);
  ASSERT_EQ(len_after_gc, group_len_after_props);

  // Verify all objects in the group array are still valid
  for (uint32_t i = 0; i < len_after_gc; i++) {
    LEPUSValue elem = LEPUS_GetPropertyUint32(ctx_, group_array, i);
    ASSERT_TRUE(LEPUS_IsObject(elem));
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, elem);
  }
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, group_array);

  // Verify getProperties still works on the parent after GC
  SendRuntimeGetProperties(ctx_, 12, object_id);
  std::string props_response2 = PopResponseById(ctx_, 12);
  ASSERT_FALSE(props_response2.empty());
}

TEST_F(QjsDebugMethods, TestObjectGroupRegistryGCThenRelease) {
  // Verify that GC followed by releaseObjectGroup works correctly —
  // the release should still clean up properly after GC has run.
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Create objects in a group
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({gcRelease: 'test'})\","
      "\"objectGroup\":\"gcReleaseGroup\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "trigger1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  ASSERT_TRUE(info->object_group_lengths.count("gcReleaseGroup") > 0);

  while (!QjsDebugQueue::GetReceiveMessageQueue().empty()) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }

  // Run GC first
  LEPUS_RunGC(rt_);
  LEPUS_RunGC(rt_);

  // Now release the group — this should not crash or cause UAF
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":20,\"method\":\"Runtime.releaseObjectGroup\",\"params\":{"
      "\"objectGroup\":\"gcReleaseGroup\"}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "trigger2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify group was cleaned up
  ASSERT_EQ(info->object_group_lengths.count("gcReleaseGroup"), 0u);
  ASSERT_EQ(info->object_group_ids.count("gcReleaseGroup"), 0u);

  // Registry should still be valid
  ASSERT_TRUE(LEPUS_IsObject(info->object_group_registry));

  // Run GC again — should not crash
  LEPUS_RunGC(rt_);
}

TEST_F(QjsDebugMethods, TestRuntimeDisableClearsObjectGroupState) {
  // Enable Runtime and Debugger
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Runtime.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Debugger.enable\",\"params\":{"
      "\"maxScriptsCacheSize\":100000000}}");
  const char* buf = "function trigger() {}; trigger();\n";
  LEPUSValue ret =
      LEPUS_Eval(ctx_, buf, strlen(buf), "setup.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty())
    QjsDebugQueue::GetReceiveMessageQueue().pop();

  // Create objects in two groups
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":10,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({x:1})\",\"objectGroup\":\"groupA\"}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":11,\"method\":\"Runtime.evaluate\",\"params\":{"
      "\"expression\":\"({y:2})\",\"objectGroup\":\"groupB\"}}");
  const char* trigger = "function t1() {}; t1();\n";
  ret = LEPUS_Eval(ctx_, trigger, strlen(trigger), "t1.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify groups exist
  LEPUSDebuggerInfo* info = GetDebuggerInfo(ctx_);
  ASSERT_TRUE(info->object_group_lengths.count("groupA") > 0);
  ASSERT_TRUE(info->object_group_lengths.count("groupB") > 0);
  ASSERT_FALSE(info->object_id_to_groups.empty());
  ASSERT_FALSE(info->object_group_ids.empty());

  // Drain messages
  while (!QjsDebugQueue::GetReceiveMessageQueue().empty())
    QjsDebugQueue::GetReceiveMessageQueue().pop();

  // Send Runtime.disable
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":20,\"method\":\"Runtime.disable\",\"params\":{}}");
  const char* trigger2 = "function t2() {}; t2();\n";
  ret = LEPUS_Eval(ctx_, trigger2, strlen(trigger2), "t2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Verify all object_group state is cleared
  ASSERT_TRUE(info->object_group_lengths.empty());
  ASSERT_TRUE(info->object_id_to_groups.empty());
  ASSERT_TRUE(info->object_group_ids.empty());
  ASSERT_TRUE(info->current_object_groups.empty());

  // Verify registry is a fresh empty object (no properties from old groups)
  LEPUSValue group_a =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "groupA");
  ASSERT_TRUE(LEPUS_IsUndefined(group_a));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, group_a);

  LEPUSValue group_b =
      LEPUS_GetPropertyStr(ctx_, info->object_group_registry, "groupB");
  ASSERT_TRUE(LEPUS_IsUndefined(group_b));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, group_b);
}

}  // namespace qjs_debug_test
