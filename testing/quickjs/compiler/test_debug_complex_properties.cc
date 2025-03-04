// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <queue>
#include <regex>

#include "inspector/debugger/debugger_breakpoint.h"
#include "inspector/debugger/debugger_properties.h"
#include "inspector/debugger_inner.h"
#include "inspector/runtime/runtime.h"
#include "test_debug_base.h"

namespace qjs_debug_test {

class QjsDebugPropertiesMethods : public ::testing::Test {
 protected:
  QjsDebugPropertiesMethods() = default;
  ~QjsDebugPropertiesMethods() override = default;

  void SetUp() override {
    QjsDebugQueue::GetReceiveMessageQueue() = std::queue<std::string>();
    QjsDebugQueue::GetSendMessageQueue() = std::queue<std::string>();
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

static void PrepareGetInternalProperties2(LEPUSRuntime* rt, int32_t bp_line) {
  PushSetBreakpointMessages(bp_line);
  void* funcs[14] = {reinterpret_cast<void*>(PauseCBGetInternalProperties2),
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

TEST_F(QjsDebugPropertiesMethods, QjsDebugTestStringIterator) {
  const char* buf = R"(function test() {
    var string = "abcd";
    var string_itr = string[Symbol.iterator]();
    console.log("string_itr");
  }
  test();
  )";

  PrepareGetProperties(rt_, 3);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"string\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{\"value\":\"abcd\",\"type\":\"string\"\\}\\},\\{\"name\":\"string_"
      "itr\",\"configurable\":true,\"enumerable\":true,\"writable\":true,"
      "\"value\":\\{\"type\":\"object\",\"objectId\":\".*\",\"className\":"
      "\"StringIterator\",\"description\":\"StringIterator\",\"preview\":\\{"
      "\"overflow\":false,\"type\":\"object\",\"description\":"
      "\"StringIterator\",\"properties\":\\[\\]\\}\\}\\}\\]\\}\\}";

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

TEST_F(QjsDebugPropertiesMethods, QjsDebugTestGenerator) {
  const char* buf = R"(function test() {
    function* makeIterator() {
      yield 1;
      yield 2;
    }
    const it1 = makeIterator();
    console.log(it1);
  }
  test();
  )";
  PrepareGetProperties(rt_, 6);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  std::string properties_pattern =
      "\\{\"id\":48,\"result\":\\{\"result\":\\[\\{\"name\":\"makeIterator\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{\"type\":\"function\",\"objectId\":\".*\",\"className\":"
      "\"GeneratorFunction\",\"description\":\"function\\* makeIterator\\(\\) "
      "\\{\\\\n      yield 1;\\\\n      yield 2;\\\\n    "
      "\\}\"\\}\\},\\{\"name\":"
      "\"it1\",\"configurable\":true,\"enumerable\":true,\"writable\":true,"
      "\"value\":\\{\"subtype\":\"generator\",\"type\":\"object\",\"objectId\":"
      "\".*\",\"className\":\"Generator\",\"description\":\"makeIterator\","
      "\"preview\":\\{\"overflow\":false,\"type\":\"object\",\"subtype\":"
      "\"generator\",\"description\":\"makeIterator\",\"properties\":\\[\\]\\}"
      "\\}\\}\\]\\}\\}";

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

TEST_F(QjsDebugPropertiesMethods, DISABLED_QJSDegbugTestFinalizationRegistry) {
  const char* buf = R"(function test() {
    let foo = {};
    let waitingForCleanup = true;
    const registry = new FinalizationRegistry((heldValue) => {
        waitingForCleanup = false;
        console.log(heldValue);
    });
    registry.register(foo, 42);
    console.log(foo);
  }
  test();
  )";
  PrepareGetProperties(rt_, 8);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  std::string properties_pattern =
      R"(\{"id":48,"result":\{"result":\[\{"name":"foo","configurable":true,"enumerable":true,"writable":true,"value":\{"type":"object","objectId":".*","className":"Object","description":"Object","preview":\{"overflow":false,"type":"object","description":"Object","properties":\[\]\}\}\},\{"name":"waitingForCleanup","configurable":true,"enumerable":true,"writable":true,"value":\{"value":true,"type":"boolean"\}\},\{"name":"registry","configurable":true,"enumerable":true,"writable":true,"value":\{"type":"object","objectId":".*","className":"FinalizationRegistry","description":"FinalizationRegistry","preview":\{"overflow":false,"type":"object","description":"FinalizationRegistry","properties":\[\]\}\}\}\]\}\})";
  std::cout << properties_pattern << std::endl;
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

TEST_F(QjsDebugPropertiesMethods, DISABLED_QJSDebugTestWeakRef) {
  const char* buf = R"(function test() {
    class Counter {
    }
    let counter = new Counter();
    let ref = new WeakRef({});
    console.log(foo);
  }
  test();
  )";

  PrepareGetProperties(rt_, 5);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  std::string properties_pattern =
      R"(\{"id":48,"result":\{"result":\[\{"name":"Counter","configurable":true,"enumerable":true,"writable":true,"value":\{"type":"function","objectId":".*","className":"Function","description":"class Counter \{\\n    \}"\}\},\{"name":"<class_fields_init>","configurable":true,"enumerable":true,"writable":true,"value":\{"type":"undefined"\}\},\{"name":"counter","configurable":true,"enumerable":true,"writable":true,"value":\{"type":"object","objectId":".*","className":"Object","description":"Object","preview":\{"overflow":false,"type":"object","description":"Object","properties":\[\]\}\}\},\{"name":"ref","configurable":true,"enumerable":true,"writable":true,"value":\{"type":"object","objectId":".*","className":"WeakRef","description":"WeakRef","preview":\{"overflow":false,"type":"object","description":"WeakRef","properties":\[\]\}\}\}\]\}\})";

  for (size_t i = 0; i < 8; i++) {
    QjsDebugQueue::GetReceiveMessageQueue().pop();
  }
  std::cout << properties_pattern << std::endl;
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  std::cout << properties_pattern << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

TEST_F(QjsDebugPropertiesMethods, QjsDebugTestGeneratorInternalProperty) {
  const char* buf = R"(function test() {
    function* makeIterator() {
      yield 1;
      yield 2;
    }
    const it1 = makeIterator();
    console.log(it1);
  }
  test();
  )";

  PrepareGetInternalProperties2(rt_, 6);
  LEPUSValue ret = LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                              "test_get_properties.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  std::string properties_pattern =
      "\\{\"id\":49,\"result\":\\{\"result\":\\[\\{\"name\":\"__proto__\","
      "\"configurable\":true,\"enumerable\":false,\"writable\":true,\"value\":"
      "\\{\"type\":\"object\",\"objectId\":\".*\",\"className\":\"Object\","
      "\"description\":\"Object\",\"preview\":\\{\"overflow\":false,\"type\":"
      "\"object\",\"description\":\"Object\",\"properties\":\\[\\]\\}\\}\\}\\],"
      "\"internalProperties\":\\[\\{\"name\":\"\\[\\[GeneratorState\\]\\]\","
      "\"configurable\":true,\"enumerable\":true,\"writable\":true,\"value\":"
      "\\{\"value\":\"suspended\",\"type\":\"string\"\\}\\},\\{\"name\":\"\\["
      "\\[GeneratorFunction\\]\\]\",\"configurable\":true,\"enumerable\":true,"
      "\"writable\":true,\"value\":\\{\"type\":\"function\",\"objectId\":\".*"
      "\",\"className\":\"GeneratorFunction\",\"description\":\"function\\* "
      "makeIterator\\(\\) \\{\\\\n      yield 1;\\\\n      yield 2;\\\\n    "
      "\\}\"\\}\\},\\{\"name\":\"\\[\\[GeneratorLocation\\]\\]\",\"value\":\\{"
      "\"type\":\"object\",\"subtype\":\"internal#location\",\"value\":\\{"
      "\"lineNumber\":1,\"columnNumber\":26,\"scriptId\":\"1\"\\},"
      "\"description\":\"Object\"\\}\\}\\]\\}\\}";
  std::cout << "result : " << QjsDebugQueue::GetReceiveMessageQueue().front()
            << std::endl;
  bool match_res =
      std::regex_match(QjsDebugQueue::GetReceiveMessageQueue().front(),
                       std::regex(properties_pattern));
  ASSERT_TRUE(match_res == true);
}

}  // namespace qjs_debug_test
