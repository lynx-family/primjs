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
                       int32_t line_number, int64_t column_number,
                       LEPUSValue condition_b);
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
    void* funcs[14] = {
        reinterpret_cast<void*>(RunMessageLoopOnPauseCBWithResume),
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

static void PrepareGetInternalProperties(LEPUSRuntime* rt, int32_t bp_line) {
  PushSetBreakpointMessages(bp_line);
  void* funcs[14] = {reinterpret_cast<void*>(PauseCBGetInternalProperties),
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
                     reinterpret_cast<void*>(DebuggerExceptionCB),
                     reinterpret_cast<void*>(InspectorCheckCB),
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     reinterpret_cast<void*>(SendScriptParsedMessageCB),
                     reinterpret_cast<void*>(SendConsoleMessageCB),
                     reinterpret_cast<void*>(SendScriptFailToParsedMessageCB),
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

static void PrepareForEvaluateOnPause(LEPUSRuntime* rt) {
  void* funcs[14] = {reinterpret_cast<void*>(PauseCBEvaluate),
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

static void PrepareGetGlobalProperties(LEPUSRuntime* rt, int32_t bp_line) {
  PushSetBreakpointMessages(bp_line);
  void* funcs[14] = {reinterpret_cast<void*>(PauseCBGetGlobalProperties),
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

  std::string properties_gt =
      "{\"id\":48,\"result\":{\"result\":[{\"name\":\"my_map\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":{"
      "\"subtype\":\"map\",\"type\":\"object\",\"objectId\":\"10\","
      "\"className\":\"Map\",\"description\":\"Map(2)\",\"preview\":{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"map\","
      "\"description\":\"Map(2)\",\"entries\":[{\"key\":{\"type\":\"string\","
      "\"description\":\"test\",\"overflow\":false,\"properties\":[]},"
      "\"value\":{\"type\":\"string\",\"description\":\"和键'test'关联的值\","
      "\"overflow\":false,\"properties\":[]}},{\"key\":{\"type\":\"string\","
      "\"description\":\"test2\",\"overflow\":false,\"properties\":[]},"
      "\"value\":{\"type\":\"string\",\"description\":\"和键'test2'关联的值\","
      "\"overflow\":false,\"properties\":[]}}]}}},{\"name\":\"wm1\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":{"
      "\"subtype\":\"weakmap\",\"type\":\"object\",\"objectId\":\"11\","
      "\"className\":\"WeakMap\",\"description\":\"WeakMap(1)\",\"preview\":{"
      "\"overflow\":false,\"type\":\"object\",\"subtype\":\"weakmap\","
      "\"description\":\"WeakMap(1)\",\"entries\":[{\"key\":{\"type\":"
      "\"object\",\"description\":\"Object\",\"overflow\":false,\"properties\":"
      "[]},\"value\":{\"type\":\"string\",\"description\":\"...\",\"overflow\":"
      "false,\"properties\":[]}}]}}},{\"name\":\"john\",\"configurable\":true,"
      "\"enumerable\":true,\"writable\":true,\"value\":{\"type\":\"object\","
      "\"objectId\":\"12\",\"className\":\"Object\",\"description\":\"Object\","
      "\"preview\":{\"overflow\":false,\"type\":\"object\",\"description\":"
      "\"Object\",\"properties\":[{\"value\":\"John\",\"type\":\"string\","
      "\"name\":\"name\"}]}}}]}}";

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
      "\"function\",\"name\":\"constructor\",\"value\":\\{\"type\":"
      "\"function\",\"objectId\":\".*\",\"className\":\"Function\","
      "\"description\":\"function Object\\(\\) \\{\\\\n    \\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":\"toString\","
      "\"value\":\\{\"type\":\"function\",\"objectId\":\".*\",\"className\":"
      "\"Function\",\"description\":\"function toString\\(\\) \\{\\\\n    "
      "\\[native "
      "code\\]\\\\n\\}\"\\}\\},\\{\"type\":\"function\",\"name\":"
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
    console.time("");
    console.timeEnd("timeEnd");
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

  const char* tag_table_test[] = {"log",     "info", "debug",  "error",
                                  "warning", "log",  "",       "",
                                  "log",     "",     "timeEnd"};
  LEPUSValue val = LEPUS_UNDEFINED;
  HandleScope func_scope(ctx_, &val, HANDLE_TYPE_LEPUS_VALUE);
  for (size_t i = 0; i < 11; i++) {
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
  bool res = IsBreakpointEqual(ctx_, new_breakpoint, 1, 12, 0, condition);
  ASSERT_TRUE(res == true);

  res = IsBreakpointEqual(ctx_, new_breakpoint, -1, 12, 0, LEPUS_NULL);
  ASSERT_TRUE(res == false);

  res = IsBreakpointEqual(ctx_, new_breakpoint, 1, 1, 0, LEPUS_NULL);
  ASSERT_TRUE(res == false);

  res = IsBreakpointEqual(ctx_, new_breakpoint, 1, 12, 2, LEPUS_NULL);
  ASSERT_TRUE(res == false);

  condition = LEPUS_NewString(ctx_, "a == 1");
  res = IsBreakpointEqual(ctx_, new_breakpoint, 1, 12, 2, condition);
  ASSERT_TRUE(res == false);

  LEPUSBreakpoint* new_breakpoint2 =
      AddBreakpoint(info, "test_breakpoint2.js", NULL, 12, 0, 1, "a == 1", 0);
  res = IsBreakpointEqual(ctx_, new_breakpoint2, 1, 12, 0, condition);
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
      "\"items\":\\[\"constructor\",\"toString\",\"toLocaleString\","
      "\"valueOf\",\"hasOwnProperty\",\"isPrototypeOf\","
      "\"propertyIsEnumerable\",\"__proto__\",\"__defineGetter__\",\"__"
      "defineSetter__\",\"__lookupGetter__\",\"__lookupSetter__\"\\],\"title\":"
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

TEST_F(QjsDebugMethods, TestFindDebuggerMagicContent) {
  std::string source =
      "test js.map //## source sourceURL\n"
      "//# sourceMappingURL=7778.4f4d5141.js.map";
  char* result = FindDebuggerMagicContent(ctx_, (char*)source.c_str(),
                                          (char*)"sourceMappingURL", 0);
  std::string result_str(result);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, result);
  std::cout << "result: " << result_str << std::endl;
  ASSERT_TRUE(result_str == "7778.4f4d5141.js.map");
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
                     reinterpret_cast<void*>(DebuggerExceptionCB),
                     reinterpret_cast<void*>(InspectorCheckCB),
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     reinterpret_cast<void*>(SendScriptParsedMessageCB),
                     reinterpret_cast<void*>(SendConsoleMessageCB),
                     reinterpret_cast<void*>(SendScriptFailToParsedMessageCB),
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
  CheckStatementPause(ctx_, 0, 42);
}

TEST_F(QjsDebugMethods, TestStepStatement2) {
  void* funcs[14] = {reinterpret_cast<void*>(RunMessageLoopOnPauseCBStepOver),
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
  CheckStatementPause(ctx_, 3, 37);
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
                     reinterpret_cast<void*>(DebuggerExceptionCB),
                     reinterpret_cast<void*>(InspectorCheckCB),
                     reinterpret_cast<void*>(ConsoleMessageCB),
                     reinterpret_cast<void*>(SendScriptParsedMessageCB),
                     reinterpret_cast<void*>(SendConsoleMessageCB),
                     reinterpret_cast<void*>(SendScriptFailToParsedMessageCB),
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

TEST_F(QjsDebugMethods, TestPauseOnNextStatement) {
  void* funcs[14] = {reinterpret_cast<void*>(RunMessageLoopOnPauseCBWithResume),
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
  RegisterQJSDebuggerCallbacks(rt_, reinterpret_cast<void**>(funcs), 14);

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

}  // namespace qjs_debug_test
