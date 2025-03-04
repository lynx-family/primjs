// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include <queue>

// #include "inspector/debugger_inner.h"
#include "gtest/gtest.h"
#include "quickjs/include/quickjs-inner.h"

#ifdef __cplusplus
extern "C" {
#endif
#include <string.h>

#include "inspector/debugger/debugger_queue.h"
#include "inspector/interface.h"
#include "quickjs/include/quickjs-libc.h"
#ifdef __cplusplus
}
#endif
#include <memory>
#include <string>

extern LEPUSValue js_array_every(LEPUSContext* ctx, LEPUSValueConst this_val,
                                 int argc, LEPUSValueConst* argv, int special);

static std::string ReadFile(const char* filename) {
  using FileUniquePtr = std::unique_ptr<FILE, decltype(&fclose)>;
  auto file = FileUniquePtr(fopen(filename, "rb"), &fclose);
  fseek(file.get(), 0, SEEK_END);
  size_t size = ftell(file.get());
  rewind(file.get());
  std::string ret;
  ret.resize(size);
  fread(ret.data(), 1, size, file.get());
  return ret;
}

static LEPUSValue Assert(LEPUSContext* ctx, LEPUSValue thisobj, int32_t argc,
                         LEPUSValue* argv) {
  if (LEPUS_ToBool(ctx, argv[0])) {
    return LEPUS_UNDEFINED;
  }
  assert(false);
  return LEPUS_EXCEPTION;
}

static void RegisterAssert(LEPUSContext* ctx) {
  LEPUSValue func = LEPUS_NewCFunction(ctx, Assert, "Assert", 1);
  LEPUSValue global_obj = LEPUS_GetGlobalObject(ctx);

  LEPUS_SetPropertyStr(ctx, global_obj, "Assert", func);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, global_obj);
}

namespace qjs_cpu_profiler_test {

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
};

static void RunMessageLoopOnPauseCBWithResume(LEPUSContext* ctx) {
  std::cout << "pause" << std::endl;
  std::string resume_message =
      "{\"id\":48,\"method\":\"Debugger.resume\",\"params\":{"
      "\"terminateOnResume\":false}}";
  ProcessPausedMessages(ctx, resume_message.c_str());
}

static void QuitMessageLoopOnPauseCB(LEPUSContext* ctx) {
  std::cout << "quit pause" << std::endl;
}

static uint8_t IsRuntimeDevtoolOnCB(LEPUSRuntime* rt) { return 1; }

static void SendResponseCB(LEPUSContext* ctx, int32_t message_id,
                           const char* message) {
  std::cout << "response message: " << message << std::endl;
  QjsDebugQueue::GetReceiveMessageQueue().push(message);
}

static void SendNotificationCB(LEPUSContext* ctx, const char* message) {
  QjsDebugQueue::GetReceiveMessageQueue().push(message);
  std::cout << "notification message: " << message << std::endl;
}

static void InspectorCheckCB(LEPUSContext* ctx) { DoInspectorCheck(ctx); }

static void DebuggerExceptionCB(LEPUSContext* ctx) {
  HandleDebuggerException(ctx);
}

static void ConsoleMessageCB(LEPUSContext* ctx, int tag, LEPUSValueConst* argv,
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

static void SendScriptParsedMessageCB(LEPUSContext* ctx,
                                      LEPUSScriptSource* script) {
  SendScriptParsedNotification(ctx, script);
}

static void SendConsoleMessageCB(LEPUSContext* ctx, LEPUSValue* console_msg) {
  SendConsoleAPICalledNotification(ctx, console_msg);
}

static void GetMessagesCB(LEPUSContext* ctx) {
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

static void SendScriptFailToParsedMessageCB(LEPUSContext* ctx,
                                            LEPUSScriptSource* script) {
  SendScriptFailToParseNotification(ctx, script);
}

class QjsCpuProfilerMethods : public ::testing::Test {
 protected:
  QjsCpuProfilerMethods() = default;
  ~QjsCpuProfilerMethods() override = default;

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
    RegisterQJSDebuggerCallbacks(rt_, reinterpret_cast<void**>(funcs), 14);
    ctx_ = LEPUS_NewContext(rt_);
    RegisterAssert(ctx_);
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

static bool CheckValidProfile(LEPUSContext* ctx, LEPUSValue profile) {
  LEPUSValue real_profile, nodes, startTime, endTime, samples, timeDeltas;
  bool result = false;
  int64_t start_time, end_time, check_time;

  if (LEPUS_VALUE_IS_NOT_OBJECT(profile)) goto ret;
  real_profile = LEPUS_GetPropertyStr(ctx, profile, "profile");
  if (LEPUS_VALUE_IS_NOT_OBJECT(real_profile)) goto ret;
  nodes = LEPUS_GetPropertyStr(ctx, real_profile, "nodes");
  startTime = LEPUS_GetPropertyStr(ctx, real_profile, "startTime");
  endTime = LEPUS_GetPropertyStr(ctx, real_profile, "endTime");
  samples = LEPUS_GetPropertyStr(ctx, real_profile, "samples");
  timeDeltas = LEPUS_GetPropertyStr(ctx, real_profile, "timeDeltas");
  if (!(LEPUS_IsArray(ctx, nodes) && LEPUS_IsArray(ctx, samples) &&
        LEPUS_IsArray(ctx, timeDeltas) && LEPUS_IsNumber(startTime) &&
        LEPUS_IsNumber(endTime)))
    goto ret;

  if (LEPUS_GetLength(ctx, samples) != LEPUS_GetLength(ctx, timeDeltas))
    goto ret;
  start_time = LEPUS_VALUE_GET_INT64(startTime);
  end_time = LEPUS_VALUE_GET_INT64(endTime);
  if (start_time >= end_time) goto ret;

  check_time = start_time;
  for (int32_t i = 0, size = LEPUS_GetLength(ctx, samples); i < size; ++i) {
    auto time_delta = LEPUS_GetPropertyUint32(ctx, timeDeltas, i);
    check_time += LEPUS_VALUE_GET_INT(time_delta);
  }
  if (check_time > end_time) goto ret;
  result = true;
ret:
  if (!ctx->gc_enable) {
    LEPUS_FreeValue(ctx, real_profile);
    LEPUS_FreeValue(ctx, nodes);
    LEPUS_FreeValue(ctx, startTime);
    LEPUS_FreeValue(ctx, endTime);
    LEPUS_FreeValue(ctx, samples);
    LEPUS_FreeValue(ctx, timeDeltas);
  }
  return result;
}

static void js_run_with_source(LEPUSContext* ctx, const char* filename,
                               const char* source) {
  int eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  LEPUSValue ret =
      LEPUS_Eval(ctx, source, strlen(source), filename, eval_flags);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
}

TEST_F(QjsCpuProfilerMethods, QJSDebugTestCPUProfiler) {
  const char* buf = R"(function test() {
    const buffer = new ArrayBuffer(8);
    console.log("end function");
    let a = 1;
    a++;
    console.log(a);
  }
  test();
  )";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Profiler.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Profiler.setSamplingInterval\",\"params\":{"
      "\"interval\":100}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Profiler.start\",\"params\":{}}");
  LEPUSValue ret =
      LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                 "test_quickjs_cpu_profiler.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":3,\"method\":\"Profiler.stop\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":4,\"method\":\"Profiler.disable\",\"params\":{}}");
  js_run_with_source(ctx_, "quickjsTriggerTimer.js",
                     "function test() {console.log('11');} test();");
}

TEST_F(QjsCpuProfilerMethods, QJSDebugTestCPUProfiler2) {
  const char* buf = R"(
    function add() {
      let a = 1;
      a++;
      console.log(a);
    }

    function subtraction() {
      let b = 1;
      b--;
    }

    function test() {
    for(let i = 0; i < 100; i++) {
      add();
      for(let j = 0; j < 100; j++) {
        subtraction();
      }
    }
    }
  test();
  )";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Profiler.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Profiler.setSamplingInterval\",\"params\":{"
      "\"interval\":100}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Profiler.start\",\"params\":{}}");
  LEPUSValue ret =
      LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                 "test_quickjs_cpu_profiler.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":3,\"method\":\"Profiler.stop\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":4,\"method\":\"Profiler.disable\",\"params\":{}}");
  js_run_with_source(ctx_, "quickjsTriggerTimer.js",
                     "let global = 1; function test() {for(let i = 0; i < "
                     "100; i++) {global++;}} test();");
}

TEST_F(QjsCpuProfilerMethods, QJSDebugTestCPUProfiler3) {
  const char* buf = R"(
    function add() {
      let a = 1;
      a++;
      console.log(a);
    }

    function subtraction() {
      let b = 1;
      b--;
    }

    function test() {
    for(let i = 0; i < 100; i++) {
      add();
      for(let j = 0; j < 100; j++) {
        subtraction();
      }
    }
    }
  test();
  )";

  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":0,\"method\":\"Profiler.enable\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":1,\"method\":\"Profiler.start\",\"params\":{}}");
  LEPUSValue ret =
      LEPUS_Eval(ctx_, (const char*)buf, strlen(buf),
                 "test_quickjs_cpu_profiler3.js", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":2,\"method\":\"Profiler.stop\",\"params\":{}}");
  QjsDebugQueue::GetSendMessageQueue().push(
      "{\"id\":3,\"method\":\"Profiler.disable\",\"params\":{}}");
  js_run_with_source(ctx_, "quickjsTriggerTimer.js",
                     "let global =1; function test() {for(let i = 0; i < "
                     "100; i++) {global++;}} test();");
}

TEST_F(QjsCpuProfilerMethods, QJSDebugTestGetAndCopyFuncName) {
  const char* buf = R"determine(
    function add() {
      let a = 1;
      a++;
      console.log(a);
    }
    function 中文() {
      for (let i = 0; i < 100; i++) {
        add();
        for (let j = 0; j < 100; j++) {
          subtraction();
        }
      }
    }

    function subtraction() {
      let b = 1;
      b--;
    }

   var anonymous = (x) => {
    console.log(x);
   };
  )determine";
  constexpr size_t buffer_size = 64;
  char buffer[buffer_size];
  std::string func_name;
  auto ret = LEPUS_Eval(ctx_, buf, strlen(buf), "test_quickjs_cpu_profiler4.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  auto add = LEPUS_GetPropertyStr(ctx_, ctx_->global_obj, "add");
  ASSERT_TRUE(LEPUS_IsFunction(ctx_, add));
  auto* b = JS_GetFunctionBytecode(add);
  func_name = b->func_name == JS_ATOM_NULL
                  ? "anoymous"
                  : JS_AtomGetStr(ctx_, buffer, buffer_size, b->func_name);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, add);
  ASSERT_EQ(std::string(func_name.c_str()), "add");

  auto func = LEPUS_GetPropertyStr(ctx_, ctx_->global_obj, "中文");
  ASSERT_TRUE(LEPUS_IsFunction(ctx_, func));
  b = JS_GetFunctionBytecode(func);
  func_name = b->func_name == JS_ATOM_NULL
                  ? "anoymous"
                  : JS_AtomGetStr(ctx_, buffer, buffer_size, b->func_name);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, func);
  ASSERT_TRUE(std::string(func_name.c_str()) == "中文");

  func = LEPUS_GetPropertyStr(ctx_, ctx_->global_obj, "subtraction");
  ASSERT_TRUE(LEPUS_IsFunction(ctx_, func));
  b = JS_GetFunctionBytecode(func);
  func_name = b->func_name == JS_ATOM_NULL
                  ? "anoymous"
                  : JS_AtomGetStr(ctx_, buffer, buffer_size, b->func_name);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, func);
  ASSERT_TRUE(std::string(func_name.c_str()) == "subtraction");

  func = LEPUS_GetPropertyStr(ctx_, ctx_->global_obj, "anonymous");
  ASSERT_TRUE(LEPUS_IsFunction(ctx_, func));
  b = JS_GetFunctionBytecode(func);
  func_name = b->func_name == JS_ATOM_NULL
                  ? "anoymous"
                  : JS_AtomGetStr(ctx_, buffer, buffer_size, b->func_name);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, func);
  ASSERT_TRUE(std::string(func_name.c_str()) == "anoymous");
  func_name.clear();
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(QjsCpuProfilerMethods, TestProfilerInterface) {
  QJSDebuggerInitialize(ctx_);
  SetCpuProfilerInterval(ctx_, 1000);
  StartCpuProfiler(ctx_);
  StartCpuProfiler(ctx_);
  StartCpuProfiler(ctx_);

  auto js_buffer = ReadFile(TEST_CASE_DIR "unit_test/demo_test.js");
  auto ret =
      LEPUS_Eval(ctx_, js_buffer.c_str(), js_buffer.size(),
                 TEST_CASE_DIR "unit_test/test.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_TRUE(!LEPUS_IsException(ret));
  auto profile = StopCpuProfiler(ctx_);
  ASSERT_TRUE(LEPUS_IsString(profile));
  size_t len;
  const char* cstr = LEPUS_ToCStringLen(ctx_, &len, profile);
  auto json_profile = JS_ParseJSONOPT(ctx_, cstr, len, "");
  ASSERT_TRUE(LEPUS_IsObject(json_profile));
  if (!ctx_->gc_enable) {
    LEPUS_FreeValue(ctx_, ret);
    LEPUS_FreeValue(ctx_, profile);
    LEPUS_FreeValue(ctx_, json_profile);
    LEPUS_FreeCString(ctx_, cstr);
  }
  QJSDebuggerFree(ctx_);
}

TEST_F(QjsCpuProfilerMethods, TestMutiProfiler) {
  struct CpuProfilerTest {
    CpuProfilerTest() {
      auto* rt = LEPUS_NewRuntime();
      ctx_ = LEPUS_NewContext(rt);
      // Simulate the devtool connection
      RegisterAssert(ctx_);
      QJSDebuggerInitialize(ctx_);
    }

    void StartProfiler() {
      // Lynx trace also need init debugger.
      QJSDebuggerInitialize(ctx_);
      StartCpuProfiler(ctx_);
    }

    void EvalFile(const char* filename) {
      auto js_buffer = ReadFile(filename);
      auto ret = LEPUS_Eval(ctx_, js_buffer.c_str(), js_buffer.size(), filename,
                            LEPUS_EVAL_TYPE_GLOBAL);
      ASSERT_TRUE(!LEPUS_IsException(ret));
      if (!ctx_->gc_enable) {
        LEPUS_FreeValue(ctx_, ret);
      }
    }

    void TestStopProfiler() {
      auto profile = StopCpuProfiler(ctx_);
      size_t len = 0;
      ASSERT_TRUE(LEPUS_IsString(profile));
      const char* profile_str = LEPUS_ToCStringLen(ctx_, &len, profile);
      ASSERT_TRUE(profile_str);
      auto profile_json = JS_ParseJSONOPT(ctx_, profile_str, len, "");
      ASSERT_TRUE(LEPUS_IsObject(profile_json));
      ASSERT_TRUE(CheckValidProfile(ctx_, profile_json));

      if (!ctx_->gc_enable) {
        LEPUS_FreeValue(ctx_, profile);
        LEPUS_FreeValue(ctx_, profile_json);
        LEPUS_FreeCString(ctx_, profile_str);
      }
      QJSDebuggerFree(ctx_);
    }

    ~CpuProfilerTest() {
      auto* rt_ = ctx_->rt;
      QJSDebuggerFree(ctx_);
      LEPUS_FreeContext(ctx_);
      LEPUS_FreeRuntime(rt_);
    }
    LEPUSContext* ctx_;
  };
  std::vector<CpuProfilerTest> tests(10);
  for (auto& test : tests) {
    // run start profiler at the same time.
    test.StartProfiler();
  }

  for (auto& test : tests) {
    test.EvalFile(TEST_CASE_DIR "unit_test/demo_test.js");
  }

  for (auto& test : tests) {
    test.TestStopProfiler();
  }
}

TEST_F(QjsCpuProfilerMethods, TestProfilerGetName) {
  std::string src = R"(
    var C = class {
      constructor() {
        this.sttringSet = "";
      }
      get 0b10() {
        std_sleep();
        return "get string";
      }
      set 0b10(param) {
       std_sleep();
        this.sttringSet = param;
      }
    };
    let obj = new C();
    let t = obj[0b10];
    obj[0b10] = "string";
  )";

  LEPUS_SetPropertyStr(
      ctx_, ctx_->global_obj, "std_sleep",
      LEPUS_NewCFunction(
          ctx_,
          [](LEPUSContext* ctx, LEPUSValue thisobj, int32_t argc, LEPUSValue*) {
            sleep(1000);
            return LEPUS_UNDEFINED;
          },
          "std_sleep", 0));

  QJSDebuggerInitialize(ctx_);
  StartCpuProfiler(ctx_);
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  auto profile_res = StopCpuProfiler(ctx_);
  size_t size = 0;
  const char* profile_res_str = LEPUS_ToCStringLen(ctx_, &size, profile_res);
  auto profile_obj = JS_ParseJSONOPT(ctx_, profile_res_str, size, "");

  ASSERT_TRUE(CheckValidProfile(ctx_, profile_obj));
  LEPUSValue profile = LEPUS_GetPropertyStr(ctx_, profile_obj, "profile");
  LEPUSValue nodes = LEPUS_GetPropertyStr(ctx_, profile, "nodes");
  LEPUSValue check_node_func = LEPUS_NewCFunction(
      ctx_,
      [](LEPUSContext* ctx, LEPUSValue this_obj, int32_t argc,
         LEPUSValue* argv) {
        bool ret = false;
        LEPUSValue callFrame = LEPUS_GetPropertyStr(ctx, argv[0], "callFrame");
        LEPUSValue func_name =
            LEPUS_GetPropertyStr(ctx, callFrame, "functionName");
        const char* func_name_str = LEPUS_ToCString(ctx, func_name);
        ret = !strcmp(func_name_str, "2");
        if (!ctx->gc_enable) {
          LEPUS_FreeValue(ctx, callFrame);
          LEPUS_FreeValue(ctx, func_name);
          LEPUS_FreeCString(ctx, func_name_str);
        }
        return LEPUS_NewBool(ctx, ret);
      },
      "check_node_func", 1);

  // special some
  LEPUSValue result = js_array_every(ctx_, LEPUS_UNDEFINED, 1, &nodes, 1);
  ASSERT_TRUE(LEPUS_ToBool(ctx_, result));

  if (!ctx_->gc_enable) {
    LEPUS_FreeValue(ctx_, ret);
    LEPUS_FreeValue(ctx_, profile_res);
    LEPUS_FreeCString(ctx_, profile_res_str);
    LEPUS_FreeValue(ctx_, profile_obj);
    LEPUS_FreeValue(ctx_, profile);
    LEPUS_FreeValue(ctx_, nodes);
    LEPUS_FreeValue(ctx_, check_node_func);
    LEPUS_FreeValue(ctx_, result);
  };

  QJSDebuggerFree(ctx_);
}
}  // namespace qjs_cpu_profiler_test
