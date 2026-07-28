// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "gtest/gtest.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs-libc.h"
#include "quickjs/include/quickjs.h"
#include "quickjs/include/quickjs_version.h"
#ifdef __cplusplus
}
#endif
#include "gc/trace-gc.h"

static void js_print(LEPUSContext* ctx, LEPUSValueConst this_val, int argc,
                     LEPUSValueConst* argv, std::string& result) {
  int i;
  const char* str;
  for (i = 0; i < argc; i++) {
    if (i != 0) result += ' ';
    str = LEPUS_ToCString(ctx, argv[i]);
    result += str;
    if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeCString(ctx, str);
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
      if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeCString(ctx, stack);
    }
    if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, val);
  }
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, exception_val);
  return result;
}

#include "quickjs/include/quickjs-inner.h"
namespace primjs_version_test {
class PrimjsVersionTest : public ::testing::Test {
 protected:
  PrimjsVersionTest() = default;
  ~PrimjsVersionTest() override = default;

  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    ctx_ = LEPUS_NewContext(rt_);
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

static LEPUSValue writeAndReadFile(LEPUSContext* ctx) {
  using FileUniquePtr = std::unique_ptr<FILE, decltype(&fclose)>;
  int eval_flags;
  uint8_t* out_buf;
  size_t out_buf_len;
  int flags;
  flags = LEPUS_WRITE_OBJ_BYTECODE;
  eval_flags = LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL;
  ;
  std::string src = R"(
    function f() {
        console.log("success");
    };
    f();
  )";
  LEPUSValue ret =
      LEPUS_Eval(ctx, src.c_str(), src.length(), "test.js", eval_flags);
  out_buf = LEPUS_WriteObject(ctx, &out_buf_len, ret, flags);
  std::string temp_file_path = "./temp.tmp";
  auto file = FileUniquePtr(fopen(temp_file_path.c_str(), "wb"), &fclose);
  size_t bytes_wrote =
      fwrite(out_buf, sizeof(unsigned char), out_buf_len, file.get());
  if (!LEPUS_IsGCMode(ctx)) lepus_free(ctx, out_buf);
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, ret);
  file = FileUniquePtr(fopen(temp_file_path.c_str(), "rb"), &fclose);
  fseek(file.get(), 0, SEEK_END);
  long size = ftell(file.get());
  rewind(file.get());
  std::vector<uint8_t> json(size);
  fread(json.data(), 1, static_cast<size_t>(size), file.get());
  LEPUSValue val =
      LEPUS_EvalBinary(ctx, json.data(), static_cast<size_t>(size), 0);
  return val;
}

static std::vector<uint8_t> writeBytecode(LEPUSContext* ctx) {
  int flags = LEPUS_WRITE_OBJ_BYTECODE;
  int eval_flags = LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL;
  std::string src = R"(
    function f() {
        console.log("success");
    };
    f();
  )";
  LEPUSValue ret =
      LEPUS_Eval(ctx, src.c_str(), src.length(), "test.js", eval_flags);
  if (LEPUS_IsException(ret)) {
    return {};
  }

  size_t out_buf_len = 0;
  uint8_t* out_buf = LEPUS_WriteObject(ctx, &out_buf_len, ret, flags);
  std::vector<uint8_t> bytecode(out_buf, out_buf + out_buf_len);
  if (!LEPUS_IsGCMode(ctx)) {
    lepus_free(ctx, out_buf);
    LEPUS_FreeValue(ctx, ret);
  }
  return bytecode;
}

TEST_F(PrimjsVersionTest, TESTOldToNew) {
  LEPUSValue val;
  val = writeAndReadFile(ctx_);
  ASSERT_FALSE(LEPUS_IsException(val));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
}

TEST_F(PrimjsVersionTest, TESTNewToNew) {
  LEPUSValue val;
  const char* lynx_target_sdk_version = "2.13";
  SetLynxTargetSdkVersion(ctx_, lynx_target_sdk_version);
  val = writeAndReadFile(ctx_);
  ASSERT_FALSE(LEPUS_IsException(val));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
}

TEST_F(PrimjsVersionTest, TESTNewLessBC) {
  LEPUSValue val;
  SetLynxTargetSdkVersion(ctx_, PRIMJS_ADD_VERSION_CODE);
  std::vector<uint8_t> data = writeBytecode(ctx_);
  ASSERT_GE(data.size(), 1 + sizeof(uint64_t));

  uint64_t future_version = LEPUS_GetPrimjsVersion() + 1;
  for (size_t i = 0; i < sizeof(future_version); i++) {
    data[1 + i] = (future_version >> (i * 8)) & 0xff;
  }

  val = LEPUS_EvalBinary(ctx_, data.data(), data.size(), 0);
  ASSERT_TRUE(LEPUS_IsException(val));
  std::string exception_val = js_get_exception_string(ctx_);
  std::cout << exception_val << std::endl;
  ASSERT_EQ(exception_val,
            "InternalError: the binary version is higher than runtime\n");
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
}
}  // namespace primjs_version_test
