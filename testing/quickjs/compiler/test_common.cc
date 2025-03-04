// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <iostream>
#include <thread>

#include "gtest/gtest.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs-libc.h"
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

#ifndef countof
#define countof(x) (sizeof(x) / sizeof((x)[0]))
#endif

int32_t typed_array_is_detached(LEPUSContext*, LEPUSObject*);
double set_date_fields(double[], int);

namespace common_qjs_test {
LEPUSValue js_deep_copy(LEPUSContext* ctx, LEPUSValueConst this_val, int argc,
                        LEPUSValueConst* argv) {
  size_t psize;
  uint8_t* buf;
  if (argc == 0) return LEPUS_UNDEFINED;
  if (argc > 1) {
    LEPUS_ThrowSyntaxError(ctx, "transfer is not supported!");
    return LEPUS_EXCEPTION;
  }
  buf = LEPUS_WriteObject(ctx, &psize, argv[0], LEPUS_WRITE_OBJ_BYTECODE);
  LEPUSValue val = LEPUS_ReadObject(ctx, buf, psize, LEPUS_READ_OBJ_BYTECODE);
  if (!ctx->rt->gc_enable) lepus_free(ctx, buf);
  return val;
}

static const LEPUSCFunctionListEntry func_list[] = {
    LEPUS_CFUNC_DEF("structuredClone", 1, js_deep_copy)};

static void RegisterAssert(LEPUSContext* ctx);

class CommonQjsTest : public ::testing::Test {
 protected:
  CommonQjsTest() = default;
  ~CommonQjsTest() override = default;

  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    ctx_ = LEPUS_NewContext(rt_);
    LEPUSValue global = LEPUS_GetGlobalObject(ctx_);

    LEPUS_SetPropertyFunctionList(ctx_, global, func_list, countof(func_list));
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, global);
    RegisterAssert(ctx_);
    lepus_std_add_helpers(ctx_, 0, NULL);
  }

  void TearDown() override {
    lepus_std_free_handlers(rt_);
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  LEPUSContext* ctx_;
  LEPUSRuntime* rt_;
};

static void js_print(LEPUSContext* ctx, LEPUSValueConst this_val, int argc,
                     LEPUSValueConst* argv, std::string& result) {
  int i;
  const char* str;
  for (i = 0; i < argc; i++) {
    if (i != 0) result += ' ';
    str = LEPUS_ToCString(ctx, argv[i]);
    result += str;
    if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, str);
  }
  result += "\n";
}

static std::string js_get_exception_string(LEPUSContext* ctx) {
  std::string result = "";
  LEPUSValue exception_val, val;
  const char* stack;
  uint8_t is_error;

  exception_val = LEPUS_GetException(ctx);
  HandleScope func_scope(ctx, &exception_val, HANDLE_TYPE_LEPUS_VALUE);
  is_error = LEPUS_IsError(ctx, exception_val);
  if (!is_error) result += "Throw: ";

  js_print(ctx, LEPUS_NULL, 1, (LEPUSValueConst*)&exception_val, result);
  if (is_error) {
    val = LEPUS_GetPropertyStr(ctx, exception_val, "stack");
    if (!LEPUS_IsUndefined(val)) {
      stack = LEPUS_ToCString(ctx, val);
      result += stack;
      // result += "\n";
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, stack);
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, val);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, exception_val);
  return result;
}

static std::string js_dump_unhandled_rejection(LEPUSContext* ctx) {
  std::string result = "";
  int count = 0;
  while (LEPUS_MoveUnhandledRejectionToException(ctx)) {
    result += js_get_exception_string(ctx);
    count++;
  }
  // if (count == 0) return result;
  return result;
}

static bool js_run(LEPUSContext* ctx, const char* filename, LEPUSValue& ret) {
  uint8_t* buf;
  int eval_flags;
  size_t buf_len;
  buf = lepus_load_file(ctx, &buf_len, filename);
  if (!buf) {
    ret = LEPUS_UNDEFINED;
    return false;
  }
  eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  ret = LEPUS_Eval(ctx, (const char*)buf, buf_len, filename, eval_flags);
  free(buf);
  return true;
}
#ifdef ENABLE_BUILTIN_SERIALIZE
TEST_F(CommonQjsTest, StructuredCloneTest) {
  const char* filename = TEST_CASE_DIR "common_test/structuredCloneTest.js";
  LEPUSValue val;
  bool res = js_run(ctx_, filename, val);
  if (res) {
    std::string result = "";
    if (LEPUS_IsException(val)) {
      result += js_get_exception_string(ctx_);
    }
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);

    lepus_std_loop(ctx_);
    result += js_dump_unhandled_rejection(ctx_);
    ASSERT_TRUE(result == "");
  } else {
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    ASSERT_TRUE(false);
  }
}
#endif
TEST_F(CommonQjsTest, WStringTest) {
  const char* buf = "testWstring";
  uint16_t* wbuf = (uint16_t*)malloc(24);
  for (int i = 0; i < 12; ++i) {
    wbuf[i] = buf[i];
  }
  LEPUSValue wstr = LEPUS_NewWString(ctx_, wbuf, 12);
  HandleScope func_scope(ctx_, &wstr, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue str = LEPUS_NewString(ctx_, buf);
  func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue str1 = LEPUS_ToWString(ctx_, str);
  func_scope.PushHandle(&str1, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue str2 = LEPUS_ToWString(ctx_, wstr);
  func_scope.PushHandle(&str2, HANDLE_TYPE_LEPUS_VALUE);
  const char* str1_s = LEPUS_ToCString(ctx_, str1);
  func_scope.PushHandle(&str1_s, HANDLE_TYPE_CSTRING);
  const char* str2_s = LEPUS_ToCString(ctx_, str2);
  ASSERT_TRUE(!strcmp(str1_s, str2_s));
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, str1_s);
  if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, str2_s);
  const uint16_t* tmp = LEPUS_GetStringChars(ctx_, str1);
  for (int i = 0; i < 11; ++i) {
    ASSERT_TRUE(tmp[i] == buf[i]);
  }
  ASSERT_TRUE(LEPUS_GetStringLength(ctx_, str2) == 12);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, wstr);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, str1);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, str2);

  free(wbuf);
}

TEST_F(CommonQjsTest, WStringRejection) {
  const char* filename = TEST_CASE_DIR "common_test/wchar_rejection.js";
  LEPUSValue val;
  bool res = js_run(ctx_, filename, val);
  if (res) {
    std::string result = "";
    if (LEPUS_IsException(val)) {
      result += js_get_exception_string(ctx_);
    }
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);

    lepus_std_loop(ctx_);
    result += js_dump_unhandled_rejection(ctx_);
    std::string excepted = R"(Error: 测试©å˙ç˙√π˜∂
    at <eval> ()" TEST_CASE_DIR R"(common_test/wchar_rejection.js:4:30))";
    ASSERT_TRUE(result.find(excepted) != std::wstring::npos);
  } else {
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    ASSERT_TRUE(false);
  }
}

TEST_F(CommonQjsTest, DISABLED_libcTest) {
  const char* str =
      "import * as std from 'std';\n"
      "import * as os from 'os';\n"
      "globalThis.std = std;\n"
      "globalThis.os = os;\n";
  lepus_init_module_os(ctx_, "os");
  LEPUSValue init_compile =
      LEPUS_Eval(ctx_, str, strlen(str), "<input>",
                 LEPUS_EVAL_TYPE_MODULE | LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(init_compile));
  LEPUSValue global_object = LEPUS_GetGlobalObject(ctx_);
  LEPUSValue init_run = LEPUS_EvalFunction(ctx_, init_compile, global_object);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, global_object);
  ASSERT_FALSE(LEPUS_IsException(init_run));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, init_run);

  std::string hello_world = "Hello World";
  std::string test_val = "globalThis.std.printf('" + hello_world + "');";
  LEPUSValue result =
      LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  int32_t len;
  int to_int_32;
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }
  ASSERT_EQ(hello_world.length(), len);

  test_val =
      R"(globalThis.std.printf("%.f %3d %c%% %*s end\n",3.2,1024,'s',10,"test");)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(globalThis.std.loadScript(")" TEST_CASE_DIR
             R"(unit_test/async_stack_trace_test.js");)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(globalThis.std.evalScript("console.log('testeval');");)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(globalThis.std.loadScript(")" TEST_CASE_DIR
             R"(unit_test/json_parse.js");)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);

  // test_val = R"(globalThis.std.exit(0);)";
  // result =
  //     LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  // if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
  //   lepus_std_dump_error(ctx_);
  //   ASSERT_EQ(1, LEPUS_ToInt32(ctx_, &len, result));
  // }

  test_val = R"(console.log(globalThis.std.getenv("PATH"));)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(globalThis.std.gc();)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(std.puts(new globalThis.std.Error(1).toString());)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(file=std.open(")" TEST_CASE_DIR R"(unit_test/demo_test.js","r");
                file.getline();
                buf=file.getline();
                file.flush();
                file.close();
                eval(buf);)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(file=os.open(")" TEST_CASE_DIR R"(unit_test/demo_test.js","r");
                buf= new ArrayBuffer(100);
                len=os.read(file,buf,0,100);)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val =
      R"(os.signal(os.SIGABRT,()=>{console.log("sigabrt");});
                )";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(file=std.open(")" TEST_CASE_DIR R"(unit_test/demo_test.js","r");
                buf=file.readAsString();
                file.close();
                eval(buf);)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(file=std.tmpfile();
             file.puts("console.log(1);");
             file.seek(0);
             buf=file.getline();
             eval(buf);
             Assert(file.tell()==15);)";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(0, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(console.log(std.urlGet("127.0.0.1").toString()))";
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if ((to_int_32 = LEPUS_ToInt32(ctx_, &len, result)) != 0) {
    lepus_std_dump_error(ctx_);
    ASSERT_EQ(-1, LEPUS_ToInt32(ctx_, &len, result));
  }

  test_val = R"(os.setTimeout(
    ()=>{console.log("timeout for 2sec");},2000);)";
  time_t clk = time(NULL);
  result = LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, result);
  lepus_std_loop(ctx_);
  ASSERT_EQ(true, (time(NULL) - clk) > 1);

  test_val = R"(handler=os.setTimeout(
    ()=>{console.log("timeout for 2sec");},2000);
  os.clearTimeout(handler);)";
  clk = time(NULL);
  LEPUS_Eval(ctx_, test_val.c_str(), test_val.length(), "test", 0);
  lepus_std_loop(ctx_);
  ASSERT_EQ(true, (time(NULL) - clk) < 1);
}

TEST_F(CommonQjsTest, LocalVariablesTest) {
  const char* filename = TEST_CASE_DIR "unit_test/local_variables.js";
  LEPUSValue val;
  bool res = js_run(ctx_, filename, val);
  if (res) {
    std::string result = "";
    if (LEPUS_IsException(val)) {
      result += js_get_exception_string(ctx_);
    }
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);

    lepus_std_loop(ctx_);
    result += js_dump_unhandled_rejection(ctx_);
    ASSERT_TRUE(result == "InternalError: too many local variables\n");
  } else {
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    ASSERT_TRUE(false);
  }
}

TEST_F(CommonQjsTest, TypeArraySetValue) {
  std::string src = R"(
   "use strict"
    let obj = new Uint8Array(10);
    obj[11] = 100;
  )";

  LEPUSValue ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  ASSERT_TRUE(!LEPUS_IsException(ret));

  src = R"(
    obj.set([1, 2, 3, 4], 10);
  )";
  ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  ASSERT_TRUE(LEPUS_IsException(ret));
}

static LEPUSValue StructuredClone(LEPUSContext* ctx, LEPUSValue this_obj,
                                  int32_t argc, LEPUSValue* argv) {
  assert(argc >= 1);
  return LEPUS_DeepCopy(ctx, argv[0]);
}

static void JS_AddStructuredClone(LEPUSContext* ctx) {
  LEPUSValue structuredClone =
      LEPUS_NewCFunction(ctx, StructuredClone, "structuredClone", 1);
  JSAtom prop = LEPUS_NewAtom(ctx, "structuredClone");
  LEPUS_SetGlobalVar(ctx, prop, structuredClone, 0);
  if (!ctx->rt->gc_enable) LEPUS_FreeAtom(ctx, prop);
}

TEST_F(CommonQjsTest, StructuredClone) {
  JS_AddStructuredClone(ctx_);
  const std::string_view filename =
      TEST_CASE_DIR "structuredClone/structuredClone.js";

  LEPUSValue val;
  bool res = js_run(ctx_, filename.data(), val);
  ASSERT_TRUE(res);
  ASSERT_TRUE(!LEPUS_IsException(val));
}

extern LEPUSValue js_dtoa(LEPUSContext* ctx, double d, int radix, int n_digits,
                          int flags);

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

TEST_F(CommonQjsTest, js_dtoa) {
  std::string src = R"(

    function f(x, f) {
        return x.toExponential(f);
    }

    class TestCase {
        constructor(input, digit, expected) {
            this.input = input;
            this.digit = digit;
            this.expected = expected;
        }
    };

    let testcases = [
        new TestCase(123456, 2, "1.23e+5"),
        new TestCase(123456, undefined, "1.23456e+5"),
    ];

    for (let i = 0; i < testcases.length; ++i) {
        Assert(f(testcases[i].input, testcases[i].digit) == testcases[i].expected);
    }


  )";
  RegisterAssert(ctx_);

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  ASSERT_TRUE(!LEPUS_IsException(ret));
}

TEST_F(CommonQjsTest, js_move_array_buffer) {
  std::string src = R"(
    let buffer = new ArrayBuffer(1024);
    let typedarray = new Uint32Array(buffer);
    for (let i = 0; i < 1024 / 4; i++) {
      typedarray[i] = i;
    }
  )";

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js", 0);
  ASSERT_FALSE(LEPUS_IsException(ret));

  JSAtom prop = LEPUS_NewAtom(ctx_, "buffer");
  auto buffer = LEPUS_GetGlobalVar(ctx_, prop, 0);
  if (!ctx_->rt->gc_enable) LEPUS_FreeAtom(ctx_, prop);
  size_t size = 0;
  uint8_t* buffer_data = LEPUS_MoveArrayBuffer(ctx_, &size, buffer);

  ASSERT_TRUE(size == 1024);
  ASSERT_TRUE(buffer_data);

  auto* data_32 = reinterpret_cast<int32_t*>(buffer_data);

  for (uint32_t i = 0; i < size / sizeof(uint32_t); ++i) {
    ASSERT_EQ(data_32[i], i);
  }

  prop = LEPUS_NewAtom(ctx_, "typedarray");
  auto typedarray = LEPUS_GetGlobalVar(ctx_, prop, 0);
  if (!ctx_->rt->gc_enable) LEPUS_FreeAtom(ctx_, prop);

  ASSERT_TRUE(typed_array_is_detached(ctx_, LEPUS_VALUE_GET_OBJ(typedarray)));

  ASSERT_EQ(LEPUS_GetArrayBuffer(ctx_, &size, buffer), nullptr);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, buffer);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, typedarray);

  src = R"(
      buffer = undefined;
      typearray = undefined;
    )";

  ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js", 0);

  for (uint32_t i = 0; i < size / sizeof(uint32_t); ++i) {
    ASSERT_EQ(data_32[i], i);

    data_32[i] = 2 * i;
    ASSERT_EQ(data_32[i], 2 * i);
  }
  if (!ctx_->rt->gc_enable) lepus_free_rt(rt_, data_32);
}

TEST_F(CommonQjsTest, Regexp$Test) {
  std::string src = R"(
    var re = /(\w+)\s(\w+)/;
    var str = 'John Smith';
    str.replace(re, '$2, $1'); // "Smith, John"
    Assert(RegExp.$1 == 'John'); // "John"
    Assert(RegExp.$2 == 'Smith'); // "Smith"

    Assert(RegExp['$&'] == 'John Smith')

    // Match "quick brown" followed by "jumps", ignoring characters in between
    // Remember "brown" and "jumps"
    // Ignore case
    re = /quick\s(?<color>brown)/gi;
    const result = re.exec('The Quick Brown Fox Jumps Over The Lazy Dog');
    // Assert(result)
    Assert(RegExp['$&'] == 'Quick Brown')
    Assert(RegExp.$1 == 'Brown')
    Assert(RegExp.$2 == '')
    Assert(RegExp.$3 == "")
    Assert(RegExp.$4 === '')
    Assert(RegExp.$5 == '')
    Assert(RegExp.$6 == '')
    Assert(RegExp.$9 == '')


    re = /([abc]hi)/g;
    str = 'chi there bhi';

    Assert(re.exec(str) != null);
    Assert(RegExp['$&'] == 'chi');     // "hi"re = /hi/g;
    Assert(RegExp.$1 == 'chi')
    Assert(re.exec(str) != null);
    Assert(RegExp['$&'] == 'bhi');     // "hi"re = /hi/g;
    Assert(RegExp.$1 == 'bhi')

    re = /[abc]hi/g;

    re.exec(str)
    Assert(RegExp["$&"] == 'chi')
    Assert(RegExp.$1 == '')
  )";

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js", 0);
  ASSERT_TRUE(!LEPUS_IsException(ret));

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(CommonQjsTest, ArrayPrototypeUnshift) {
  std::string src = R"(
    var foo = function (v) {
      for (let r = 0; r < 10000; r++) {
          v.unshift(1);
      }
    };
    var t = [];
    var res = foo(t);
    Assert(t.length == 10000);
  )";

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);

  ASSERT_TRUE(!LEPUS_IsException(ret));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(CommonQjsTest, UnConsistentStackSize) {
  std::string src = R"(
    function* f() {
        try {
          this.foo = yield 123;
            console.log(this.foo)
        } finally {
            console.log(1);
        }
    };


    var gen_obj=f();
    console.log(gen_obj.next(5).value);
    console.log(gen_obj.next(5));
    console.log(gen_obj.next());
    console.log(gen_obj.next());
  )";

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_TRUE(!LEPUS_IsException(ret));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}
TEST_F(CommonQjsTest, js_op_dec_loc) {
  std::string src = R"(
    function test() {
      var i = true;
      i = false;
      var b = 1+1;
      --i;
      console.log("i: ", i);
      Assert(i == -1);
    }

    test();

  )";

  RegisterAssert(ctx_);

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  std::string result = "";

  if (LEPUS_IsException(ret)) {
    result += js_get_exception_string(ctx_);
  }

  std::cout << "result: " << result << std::endl;

  ASSERT_TRUE(!LEPUS_IsException(ret));
}

TEST_F(CommonQjsTest, js_add_overflow) {
  std::string src = R"(
    function test() {
      const a = -1763627344;
      const b = -2068185088;
      const c = 2068185088;
      const d = a + b;
      const e = a - c;
      Assert(d == -3831812432);
      Assert(e == -3831812432);


      const a1 = 1256387435;
      const a2 = -1949564928;
      const a3 = 1949564928;
      Assert(a1 + a2 == -693177493)
      Assert(a1 - a3 == -693177493)
    }

    test();

  )";

  RegisterAssert(ctx_);

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  std::string result = "";

  if (LEPUS_IsException(ret)) {
    result += js_get_exception_string(ctx_);
  }

  std::cout << "result: " << result << std::endl;

  ASSERT_TRUE(!LEPUS_IsException(ret));
}

TEST_F(CommonQjsTest, js_op_dec_loc_exception) {
  std::string src = R"(
    function test() {
      var i = 1;
      i = {
        valueOf() {
          return {};
        },
        toString() {
          return {};
        }
      };
      var b = 1+1;
      --i;
      console.log("i: ", i);
    }

    test();
  )";
  std::string error_msg =
      "TypeError: toPrimitive\n    at test (test:13:9)\n    at <eval> "
      "(test:17:11)\n";

  RegisterAssert(ctx_);

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  std::string result = "";

  if (LEPUS_IsException(ret)) {
    result += js_get_exception_string(ctx_);
  }

  std::cout << "result: " << result << std::endl;

  ASSERT_TRUE(LEPUS_IsException(ret));
  ASSERT_TRUE(!strcmp(result.c_str(), error_msg.c_str()));
}

TEST_F(CommonQjsTest, js_op_inc_loc_exception) {
  std::string src = R"(
    function test() {
      var i = 1;
      i = {
        valueOf() {
          return {};
        },
        toString() {
          return {};
        }
      };
      var b = 1+1;
      ++i;
      console.log("i: ", i);
    }

    test();
  )";
  std::string error_msg =
      "TypeError: toPrimitive\n    at test (test:13:9)\n    at <eval> "
      "(test:17:11)\n";

  RegisterAssert(ctx_);

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  std::string result = "";

  if (LEPUS_IsException(ret)) {
    result += js_get_exception_string(ctx_);
  }

  std::cout << "result: " << result << std::endl;

  ASSERT_TRUE(LEPUS_IsException(ret));
  ASSERT_TRUE(!strcmp(result.c_str(), error_msg.c_str()));
}

TEST_F(CommonQjsTest, js_op_put_loc_check) {
  std::string src = R"(
    function test() {
      x = 1;
      let x = 10;
    }

    test();
  )";
  std::string error_msg =
      "ReferenceError: lexical variable is not initialized\n    at test "
      "(test:3:12)\n    at <eval> (test:7:11)\n";

  RegisterAssert(ctx_);

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  std::string result = "";

  if (LEPUS_IsException(ret)) {
    result += js_get_exception_string(ctx_);
  }

  std::cout << "result: " << result << std::endl;

  ASSERT_TRUE(LEPUS_IsException(ret));
  ASSERT_TRUE(!strcmp(result.c_str(), error_msg.c_str()));
}

TEST_F(CommonQjsTest, js_op_put_var_exception) {
  std::string src = R"(
    const obj = {};

    Object.defineProperty(this, 'obj', {
      value: 'initial value',
      writable: false
    });

    obj = 'new value';
  )";
  std::string error_msg =
      "TypeError: 'obj' is read-only\n    at <eval> (test:9:22)\n";

  RegisterAssert(ctx_);

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  std::string result = "";

  if (LEPUS_IsException(ret)) {
    result += js_get_exception_string(ctx_);
  }

  std::cout << "result: " << result << std::endl;

  ASSERT_TRUE(LEPUS_IsException(ret));
  ASSERT_TRUE(!strcmp(result.c_str(), error_msg.c_str()));
}

TEST_F(CommonQjsTest, js_map_get) {
  std::string src = R"(
    var App = class {
      constructor() {
        this.map = /* @__PURE__ */ new Map();
        this.testMaps();
      }
      testMap(name) {
        let hash = 0;
        for (let i = 0; i < name.length; i++) {
          hash = name.charCodeAt(i) + (hash << 6) + (hash << 16) - hash;
        }
        hash = Math.abs(hash) % 4294967295;
        console.log(`hash number is ${hash}`);
        this.map.set(hash, name);
        const buffer = new Uint32Array(100);
        buffer[0] = hash;
        let hash2 = buffer[0];
        Assert(hash == hash2);
        console.log(`hash2 get ${this.map.get(hash2)} ${this.map.get(hash)}`);
        Assert(this.map.get(hash2) === this.map.get(hash));
      }
      testMaps() {
        this.testMap("black");
        this.testMap("black1");
        this.testMap("123123213");
        this.testMap("asdddafsaf");
        this.testMap("blafasaasck1");
        this.testMap("fasfafa");
        this.testMap("blacasdadak1");
        this.testMap("Wheel231");
        this.testMap("Wheel231123");
        this.testMap("Wheel2_sdadsa");
        this.testMap("Car12313_");
      }
    };
    let app = new App();
  )";

  RegisterAssert(ctx_);

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  std::string result = "";

  if (LEPUS_IsException(ret)) {
    result += js_get_exception_string(ctx_);
  }

  std::cout << "result: " << result << std::endl;

  ASSERT_TRUE(!LEPUS_IsException(ret));
}

TEST_F(CommonQjsTest, binary_op) {
  std::string src = R"(
    var a = 2147483647;
    var b = 2147483648;
    var c = -2147483649;
    var d = a + c;
    var e = b + c;
    var f = 2147483649;
    var g = f - a;
    var h = f - b;
    var hash1 = 779917409 % 4294967295;
    var hash2 = 4143284306 % 4294967295;
    var i = 4294967294 / 2;
  )";
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js", 0);
  ASSERT_TRUE(!LEPUS_IsException(ret));
  auto global = LEPUS_GetGlobalObject(ctx_);
  auto d = LEPUS_GetPropertyStr(ctx_, global, "d");
  auto e = LEPUS_GetPropertyStr(ctx_, global, "e");
  auto g = LEPUS_GetPropertyStr(ctx_, global, "g");
  auto h = LEPUS_GetPropertyStr(ctx_, global, "h");
  auto hash1 = LEPUS_GetPropertyStr(ctx_, global, "hash1");
  auto hash2 = LEPUS_GetPropertyStr(ctx_, global, "hash2");
  auto i = LEPUS_GetPropertyStr(ctx_, global, "i");
  ASSERT_TRUE(LEPUS_VALUE_IS_INT(d));
  ASSERT_TRUE(LEPUS_VALUE_GET_INT(d) == -2);
  ASSERT_TRUE(LEPUS_VALUE_IS_FLOAT64(e));
  ASSERT_TRUE(LEPUS_VALUE_GET_FLOAT64(e) == -1);
  ASSERT_TRUE(LEPUS_VALUE_IS_INT(g));
  ASSERT_TRUE(LEPUS_VALUE_GET_INT(g) == 2);
  ASSERT_TRUE(LEPUS_VALUE_IS_FLOAT64(h));
  ASSERT_TRUE(LEPUS_VALUE_GET_FLOAT64(h) == 1);
  ASSERT_TRUE(LEPUS_VALUE_IS_INT(hash1));
  ASSERT_TRUE(LEPUS_VALUE_IS_FLOAT64(hash2));
  ASSERT_TRUE(LEPUS_VALUE_IS_INT(i));
  ASSERT_TRUE(LEPUS_VALUE_GET_INT(i) == 2147483647);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, global);
  return;
}

TEST_F(CommonQjsTest, get_date_string) {
  std::string src = R"(
    var givenDate = new Date(951753599000);
    var localString = givenDate.toLocaleString();
    Assert(localString === "02/28/2000, 11:59:59 PM");
  )";

  RegisterAssert(ctx_);

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test", 0);

  std::string result = "";

  if (LEPUS_IsException(ret)) {
    result += js_get_exception_string(ctx_);
  }

  std::cout << "result: " << result << std::endl;

  ASSERT_TRUE(!LEPUS_IsException(ret));
}

TEST_F(CommonQjsTest, object_async_key) {
  std::string src = R"(
    function test(async) {
      let obj = {
        async
      };
      console.log(JSON.stringify(obj));
    }
    test(2);
)";
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js", 0);
  if (LEPUS_IsException(ret)) {
    std::string result;
    result += js_get_exception_string(ctx_);
    std::cout << "result: " << result << std::endl;
  }

  ASSERT_TRUE(!LEPUS_IsException(ret));
}

TEST_F(CommonQjsTest, object_async_key_failed) {
  std::string src = R"(
    function test(arg) {
      let obj = {
        async
      };
      console.log(JSON.stringify(obj));
    }
    test(2);
  )";
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js", 0);

  ASSERT_TRUE(LEPUS_IsException(ret));
}

TEST_F(CommonQjsTest, object_async_keys) {
  std::string src = R"(
    var obj = {};
    function test(async) {
       obj = { async, prop: "helloworld" };
      console.log(JSON.stringify(obj));
    }
    test(2);
  )";
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js", 0);
  ASSERT_TRUE(!LEPUS_IsException(ret));
  auto global = LEPUS_GetGlobalObject(ctx_);
  auto obj = LEPUS_GetPropertyStr(ctx_, global, "obj");
  auto async = LEPUS_GetPropertyStr(ctx_, obj, "async");
  ASSERT_TRUE(LEPUS_VALUE_GET_INT(async) == 2);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, async);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, obj);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, global);
  return;
}

TEST_F(CommonQjsTest, NewObjectFastPath) {
  std::vector<const char*> keys = {"prop0", "prop1", "prop2",
                                   "prop3", "prop4", "prop5"};

  std::vector<LEPUSValue> args = {
      LEPUS_NewString(ctx_, "prop0"), LEPUS_NewString(ctx_, "prop1"),
      LEPUS_NewString(ctx_, "prop2"), LEPUS_NewString(ctx_, "prop3"),
      LEPUS_NewString(ctx_, "prop4"), LEPUS_NewString(ctx_, "prop5")};

  auto new_obj =
      LEPUS_NewObjectWithArgs(ctx_, keys.size(), keys.data(), args.data());

  ASSERT_TRUE(LEPUS_VALUE_IS_OBJECT(new_obj));
  ASSERT_EQ(static_cast<size_t>(LEPUS_GetLength(ctx_, new_obj)), keys.size());
  for (const auto& key : keys) {
    auto prop = LEPUS_GetPropertyStr(ctx_, new_obj, key);
    auto* str = LEPUS_ToCString(ctx_, prop);
    ASSERT_TRUE(!strcmp(key, str));
    if (!ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, str);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, prop);
  }

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, new_obj);
}

TEST_F(CommonQjsTest, NewArrayFastPath) {
  LEPUSValue val0 = LEPUS_NewString(ctx_, "prop0");
  HandleScope func_scope(ctx_, &val0, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue val1 = LEPUS_NewString(ctx_, "prop1");
  func_scope.PushHandle(&val1, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue val2 = LEPUS_NewString(ctx_, "prop2");
  func_scope.PushHandle(&val2, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue val3 = LEPUS_NewString(ctx_, "prop3");
  func_scope.PushHandle(&val3, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue val4 = LEPUS_NewString(ctx_, "prop4");
  func_scope.PushHandle(&val4, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue val5 = LEPUS_NewString(ctx_, "prop5");
  func_scope.PushHandle(&val5, HANDLE_TYPE_LEPUS_VALUE);
  std::vector<LEPUSValue> args = {val0, val1, val2, val3, val4, val5};

  auto new_arr = LEPUS_NewArrayWithArgs(ctx_, args.size(), args.data());
  func_scope.PushHandle(&new_arr, HANDLE_TYPE_LEPUS_VALUE);

  ASSERT_TRUE(LEPUS_VALUE_IS_OBJECT(new_arr));
  ASSERT_TRUE(LEPUS_IsArray(ctx_, new_arr));
  ASSERT_EQ(static_cast<size_t>(LEPUS_GetLength(ctx_, new_arr)), args.size());

  for (size_t i = 0; i < args.size(); ++i) {
    auto ele = LEPUS_GetPropertyUint32(ctx_, new_arr, i);
    ASSERT_TRUE(LEPUS_VALUE_GET_STRING(args[i]) == LEPUS_VALUE_GET_STRING(ele));
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ele);
  }

  LEPUSValue str = LEPUS_NewString(ctx_, "prop6");
  func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);

  LEPUS_SetPropertyUint32(ctx_, new_arr, 6, str);
  ASSERT_TRUE(LEPUS_GetLength(ctx_, new_arr) == 7);

  for (size_t i = 0; i < args.size(); ++i) {
    auto ele = LEPUS_GetPropertyUint32(ctx_, new_arr, i);
    ASSERT_TRUE(LEPUS_VALUE_GET_STRING(args[i]) == LEPUS_VALUE_GET_STRING(ele));
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ele);
  }

  LEPUS_SetPropertyUint32(ctx_, new_arr, 100, LEPUS_NewString(ctx_, "prop7"));

  ASSERT_TRUE(LEPUS_GetLength(ctx_, new_arr) == 101);
  for (size_t i = 0; i < args.size(); ++i) {
    auto ele = LEPUS_GetPropertyUint32(ctx_, new_arr, i);
    ASSERT_TRUE(LEPUS_VALUE_GET_STRING(args[i]) == LEPUS_VALUE_GET_STRING(ele));
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ele);
  }

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, new_arr);
}

TEST_F(CommonQjsTest, TestGetUtf8StrFast) {
  std::string str1 = "hello world";
  auto str1_js = LEPUS_NewString(ctx_, str1.c_str());
  ASSERT_TRUE(LEPUS_VALUE_IS_STRING(str1_js));
  auto* utf8_str = LEPUS_GetStringUtf8(ctx_, LEPUS_VALUE_GET_STRING(str1_js));
  ASSERT_TRUE(utf8_str);
  ASSERT_TRUE(!strcmp(utf8_str, str1.c_str()));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, str1_js);
}

TEST_F(CommonQjsTest, TestGetUtf16StrFast) {
  std::string str1 = "你好世界";
  auto str1_js = LEPUS_NewString(ctx_, str1.c_str());
  ASSERT_TRUE(LEPUS_VALUE_IS_STRING(str1_js));
  auto* utf8_str = LEPUS_GetStringUtf8(ctx_, LEPUS_VALUE_GET_STRING(str1_js));
  ASSERT_FALSE(utf8_str);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, str1_js);
}

TEST_F(CommonQjsTest, TestRegexpSplitStr) {
  std::string src = R"(
    let ret = (/\.|\[(\d+)\]/)[Symbol.split]("a.b.[1]")
  )";

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js", 0);
  HandleScope func_scope(ctx_, &ret, HANDLE_TYPE_LEPUS_VALUE);

  ASSERT_TRUE(!LEPUS_IsException(ret));
  auto atom = LEPUS_NewAtom(ctx_, "ret");
  func_scope.PushLEPUSAtom(atom);
  auto ret_value = LEPUS_GetGlobalVar(ctx_, atom, false);
  LEPUSObject* obj = LEPUS_VALUE_GET_OBJ(ret_value);
  void* prop = obj->prop;
  auto ret_array_1 = LEPUS_GetPropertyUint32(ctx_, ret_value, 1);
  ASSERT_TRUE(LEPUS_IsUndefined(ret_array_1));
  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeAtom(ctx_, atom);
    LEPUS_FreeValue(ctx_, ret_value);
    LEPUS_FreeValue(ctx_, ret);
  }
}

TEST_F(CommonQjsTest, TestIsArrayStackOverflow) {
  std::string src = R"(// poc.js
    for (var r = new Proxy([], {}), y = 0; y < 1131072; y++) r = new Proxy(r, {});
    Array.isArray(r);
  )";
  LEPUS_SetMemoryLimit(rt_, 0x40000UL);
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_TRUE(LEPUS_IsException(ret));
}

TEST_F(CommonQjsTest, TestCopyMaxIntProps) {
  if (LEPUS_IsGCMode(ctx_)) {
    return;
  }
  std::string src = R"(function placeholder() {}
    function main() {
      function v1(v2, v3) {}
      const v5 = [v1, v1, v1];
      const v8 = new Int8Array(2147483647);
      v8[v5] = 834287175;
      const v13 = {
        ...v8,
      };
    }
    main();
  )";

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_TRUE(LEPUS_IsException(ret));

  auto exception_str = js_get_exception_string(ctx_);
  ASSERT_EQ(exception_str, R"(RangeError: Too many properties to enumerate
    at main (test.js:8:12)
    at <eval> (test.js:11:11)
)");
}

TEST_F(CommonQjsTest, ForInIteratorNpe) {
  std::string src = R"(function foo() {
    
    function Bar() {
    }
    
    class Apple extends Bar {
        constructor(a) {
            (() => {
            	for (const i in this) {}
                eval(a);
                return 0;
            })();
        }
    }
    const y = new Apple();
    return y;
}

let x = new Promise(foo);)";
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(ret));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(CommonQjsTest, DISABLED_TestStdUrl) {
  std::string src = R"(
    import * as std from "std";
  )";
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test_std_geturl.js",
                        LEPUS_EVAL_TYPE_MODULE);
  ASSERT_FALSE(LEPUS_IsException(ret));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(CommonQjsTest, TypedArrayLastIndexofOOB) {
  std::string src = R"(
    a = new Int8Array(1);
    let idx = -2.22045e-17;
    Assert(a.lastIndexOf(1, idx) == -1);
  )";
  RegisterAssert(ctx_);
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(ret));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(CommonQjsTest, TypedArraySliceMemOverlap) {
  std::string src = R"(
    var ab = new Int8Array(20).buffer;
    var ta = new Int8Array(ab, 0, 10);
    ta.constructor = {
      [Symbol.species]: function (len) {
        return new Int8Array(ab, 1, len);
      },
    };
    var tb = ta.slice();
  )";

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(ret));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(CommonQjsTest, TestDateUtc) {
  double fields[] = {1970, 0, 213503982336, 0, 0, 0, -18446744073709552000.0};
  auto ret = set_date_fields(fields, 0);
  ASSERT_EQ(ret, 34447360);
}

TEST_F(CommonQjsTest, TestOsSetTimeOut) {
  auto global = LEPUS_GetGlobalObject(ctx_);
  LEPUSValue val = LEPUS_NewCFunction(
      ctx_,
      [](LEPUSContext* ctx, LEPUSValue, int32_t, LEPUSValue*) {
        LEPUS_RunGC(LEPUS_GetRuntime(ctx));
        return LEPUS_UNDEFINED;
      },
      "__triger_gc__", 0);
  HandleScope func_scope(ctx_, &val, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyStr(ctx_, global, "__triger_gc__", val);
  lepus_init_module_os(ctx_, "os");
  std::string src = R"(
    import * as os from "os";
    globalThis.os = os;
    globalThis.test = () => {
      const g = {
        a: null,
        b: null,
      };

      function fun1() {
        var obj1 = {
          timeout: null,
          ref: null,
        };

        obj1.timeout = os.setTimeout(function () {
          console.log("ok!");
        }, 3000);

        var obj2 = {
          str: "123",
          ref: null,
        };
        g.a = obj1;
        g.b = obj2;
      }

      function fun2() {
        g.a.ref = g.b;
        g.b.ref = g.a;
        g.a = null;
        g.b = null;
      }
      fun1();
      fun2();

      __triger_gc__();
    };
    globalThis.test();

  )";
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                        LEPUS_EVAL_TYPE_MODULE);
  ASSERT_FALSE(LEPUS_IsException(ret));
  if (!ctx_->gc_enable) {
    LEPUS_FreeValue(ctx_, global);
    LEPUS_FreeValue(ctx_, ret);
  }
}

TEST_F(CommonQjsTest, TestDefineFunctionProp) {
  std::string func_name = "test_func";
  auto func_obj = LEPUS_NewCFunction(
      ctx_,
      [](LEPUSContext*, LEPUSValue, int32_t, LEPUSValue*) {
        return LEPUS_UNDEFINED;
      },
      func_name.c_str(), 2);
  ASSERT_TRUE(LEPUS_IsFunction(ctx_, func_obj));
  auto name = LEPUS_GetProperty(ctx_, func_obj, JS_ATOM_name);
  const char* name_str = LEPUS_ToCString(ctx_, name);
  ASSERT_EQ(std::string(name_str), func_name);
  auto length = LEPUS_GetProperty(ctx_, func_obj, JS_ATOM_length);
  ASSERT_EQ(LEPUS_VALUE_GET_INT(length), 2);
  if (!ctx_->gc_enable) {
    LEPUS_FreeValue(ctx_, func_obj);
    LEPUS_FreeValue(ctx_, name);
    LEPUS_FreeCString(ctx_, name_str);
  }
}

TEST_F(CommonQjsTest, TestClosureProp) {
  std::string src = R"(
    var inner;
    function outter() {
      let t = 100;
      function* inner_closure(a, b, c) {
        console.log(t);
        yield a;
      }
      inner = inner_closure;
    }
    outter();
  )";

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_TRUE(!LEPUS_IsException(ret));
  auto inner = LEPUS_GetPropertyStr(ctx_, ctx_->global_obj, "inner");
  ASSERT_TRUE(LEPUS_IsFunction(ctx_, inner));
  auto name = LEPUS_GetProperty(ctx_, inner, JS_ATOM_name);
  const char* name_str = LEPUS_ToCString(ctx_, name);
  auto length = LEPUS_GetProperty(ctx_, inner, JS_ATOM_length);
  auto prototype = LEPUS_GetProperty(ctx_, inner, JS_ATOM_prototype);
  ASSERT_TRUE(LEPUS_VALUE_IS_OBJECT(prototype));
  auto prototype_proto = LEPUS_GetPrototype(ctx_, prototype);
  ASSERT_EQ(std::string(name_str), "inner_closure");
  ASSERT_EQ(LEPUS_VALUE_GET_INT(length), 3);
  ASSERT_EQ(LEPUS_VALUE_GET_OBJ(prototype_proto),
            LEPUS_VALUE_GET_OBJ(ctx_->class_proto[JS_CLASS_GENERATOR]));
  if (!ctx_->gc_enable) {
    LEPUS_FreeValue(ctx_, ret);
    LEPUS_FreeCString(ctx_, name_str);
    LEPUS_FreeValue(ctx_, inner);
    LEPUS_FreeValue(ctx_, name);
    LEPUS_FreeValue(ctx_, length);
    LEPUS_FreeValue(ctx_, prototype);
  }
}

TEST_F(CommonQjsTest, TestSetFunctionFilename) {
  if (ctx_->gc_enable) {
    return;
  }
  std::string test_filename = TEST_CASE_DIR "unit_test/demo_test.js";
  std::string new_filename = "newfilename_test.js";
  JSAtom filename_atom = LEPUS_NewAtom(ctx_, new_filename.c_str());
  size_t buf_len;
  uint8_t* buf = lepus_load_file(ctx_, &buf_len, test_filename.c_str());
  ASSERT_TRUE(buf);
  auto func = LEPUS_Eval(ctx_, reinterpret_cast<const char*>(buf), buf_len,
                         test_filename.c_str(), LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_TRUE(LEPUS_VALUE_IS_FUNCTION_BYTECODE(func));
  LEPUS_SetFuncFileName(ctx_, func, new_filename.c_str());
  auto ret = LEPUS_EvalFunction(ctx_, func, LEPUS_UNDEFINED);
  ASSERT_TRUE(!LEPUS_IsException(ret));
  list_head* el;
  list_for_each(el, &ctx_->rt->obj_list) {
    LEPUSObject* p = list_entry(el, LEPUSObject, link);
    if (lepus_class_has_bytecode(p->class_id)) {
      ASSERT_EQ(p->u.func.function_bytecode->debug.filename, filename_atom);
    }
  }
  LEPUS_FreeAtom(ctx_, filename_atom);
  lepus_free(ctx_, buf);
}

TEST_F(CommonQjsTest, StringToNumber) {
  std::string src = R"(
    Assert(Number("") == 0);
    Assert(Number("0") == 0);
    Assert(isNaN(Number("0x")));
    Assert(isNaN(Number("a")));
    Assert(isNaN(Number("+")));
    Assert(isNaN(Number("-")));
    
    Assert(isNaN(parseInt("")));
    Assert(parseInt("0") == 0);
    Assert(isNaN(parseInt("0x")));
    Assert(isNaN(parseInt("+")));
    Assert(isNaN(parseInt("-")));
    Assert(isNaN(parseInt("a")));
  )";
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);

  ASSERT_TRUE(!LEPUS_IsException(ret));
}

TEST_F(CommonQjsTest, FinalizationRegistryTest) {
  std::string src = R"(
   globalThis.obj = { data: "example" };

    globalThis.finalizationRegistry = new FinalizationRegistry((heldValue) => {
      console.log("Object has been garbage collected:", heldValue);
    });

    finalizationRegistry.register(obj, "some value");
  )";

  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_TRUE(!LEPUS_IsException(ret));
  if (!LEPUS_IsGCMode(ctx_)) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(CommonQjsTest, WeakRefTest) {
  std::string src = R"(
    globalThis.obj = { data: "example" };
    globalThis.wearef = new WeakRef(obj);
  )";
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_TRUE(!LEPUS_IsException(ret));
  if (!LEPUS_IsGCMode(ctx_)) LEPUS_FreeValue(ctx_, ret);
}

TEST_F(CommonQjsTest, NewclassID) {
  auto lama = [&](LEPUSRuntime* rt) {
    LEPUSClassID last_id = 0;
    for (int32_t i = 0; i < 100; ++i) {
      LEPUSClassID id = 0;
      id = LEPUS_NewClassID(&id);
      ASSERT_TRUE(id > last_id);
      last_id = id;
    }
  };
  std::thread t1(lama, rt_);
  std::thread t2(lama, rt_);
  t1.join();
  t2.join();
}

TEST_F(CommonQjsTest, NotAFunctionException) {
  struct TestCase {
    std::string src;
    std::string expected;
  } cases[] = {{"results(arr)", "results is not a function"},
               {"arr.findLast(function (kvalue) {results.push(kvalue)})",
                "arr.findLast is not a function"},
               {"arr.length(results)", "arr.length is not a function"},
               {"arr[2](results)", "arr[2] is not a function"},
               {"const Car = 1; new Car()", "Car is not a function"},
               {"String.notAFunction`primjs{results}`",
                "String.notAFunction is not a function"},
               {R"(class TestCase {
                    constructor(input, digit, expected) {
                      this.input = input;
                      this.digit = digit;
                      this.expected = expected;
                      results();
                    }
                  }
                let testcases = [
                  new TestCase(123456, 2, "1.23e+5"),
                  new TestCase(123456, undefined, "1.23456e+5"),
                ];)",
                "results is not a function"}};

  std::string src = R"(var arr = ["Shoes", "Car", "Bike"]; var results = [];)";
  auto ret = LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                        LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx_->gc_enable) LEPUS_FreeValue(ctx_, ret);
  for (const auto& test : cases) {
    ret = LEPUS_Eval(ctx_, test.src.c_str(), test.src.size(), "test.js",
                     LEPUS_EVAL_TYPE_GLOBAL);
    ASSERT_TRUE(LEPUS_IsException(ret));
    auto exception_val = LEPUS_GetException(ctx_);
    HandleScope block_scope{ctx_, &exception_val, HANDLE_TYPE_LEPUS_VALUE};
    auto msg_val = LEPUS_ToString(ctx_, exception_val);
    block_scope.PushHandle(&msg_val, HANDLE_TYPE_LEPUS_VALUE);
    const char* c_str = LEPUS_ToCString(ctx_, msg_val);
    std::string str(c_str);
    ASSERT_TRUE(str.find(test.expected) != std::string::npos);
    if (!ctx_->gc_enable) {
      LEPUS_FreeValue(ctx_, exception_val);
      LEPUS_FreeValue(ctx_, msg_val);
      LEPUS_FreeCString(ctx_, c_str);
    }
  }
}

}  // namespace common_qjs_test
