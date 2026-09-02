// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "gtest/gtest.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs-libc.h"
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif
#include "quickjs/include/quickjs-inner.h"

// Test that malformed bytecode metadata and operands are rejected instead of
// accessing memory outside the decoded function.

class ReadFunctionOverflowTest : public ::testing::Test {
 protected:
  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    ctx_ = LEPUS_NewContext(rt_);
  }

  void TearDown() override {
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  // Compile source to bytecode, returning the serialized buffer.
  // Caller must lepus_free the returned buffer.
  uint8_t* CompileToBytecode(const char* source, size_t* out_len) {
    LEPUSValue val = LEPUS_Eval(ctx_, source, strlen(source), "<test>",
                                LEPUS_EVAL_FLAG_COMPILE_ONLY);
    if (LEPUS_IsException(val)) {
      *out_len = 0;
      return nullptr;
    }
    uint8_t* buf =
        LEPUS_WriteObject(ctx_, out_len, val, LEPUS_WRITE_OBJ_BYTECODE);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    return buf;
  }

  // Encode a uint32_t as LEB128 into buf, return number of bytes written.
  static int EncodeLEB128(uint8_t* buf, uint32_t val) {
    int n = 0;
    do {
      uint8_t byte = val & 0x7f;
      val >>= 7;
      if (val != 0) byte |= 0x80;
      buf[n++] = byte;
    } while (val != 0);
    return n;
  }

  // Find the position of the cpool_count field in serialized bytecode.
  // The format after BC_TAG_FUNCTION_BYTECODE (tag byte) is:
  //   u16 flags
  //   u8 js_mode
  //   leb128 func_name (atom index)
  //   leb128_u16 arg_count
  //   leb128_u16 var_count
  //   leb128_u16 defined_arg_count
  //   leb128_u16 stack_size
  //   leb128_int closure_var_count
  //   leb128_int cpool_count        <-- we want to patch this
  //   leb128_int byte_code_len
  //   leb128_int local_count
  //
  // We locate it by skipping the known fields.
  // Returns offset into the buffer, or -1 on failure.
  static int FindCpoolCountOffset(const uint8_t* buf, size_t buf_len) {
    // Skip version byte (or version + u64 for new format)
    size_t pos = 0;
    if (pos >= buf_len) return -1;
    uint8_t version = buf[pos++];
    if (version == 0x01 + 0x40 || version == 0x41) {
      // new prefix: skip u64
      pos += 8;
    } else if (version != 0x01) {
      return -1;
    }

    // Skip atom table: leb128 count, then atoms
    uint32_t atom_count = 0;
    while (pos < buf_len) {
      uint8_t b = buf[pos++];
      atom_count |= (b & 0x7f) << (7 * 0);
      if (!(b & 0x80)) break;
      // multi-byte leb128
      atom_count = 0;
      pos--;
      int shift = 0;
      do {
        if (pos >= buf_len) return -1;
        b = buf[pos++];
        atom_count |= (uint32_t)(b & 0x7f) << shift;
        shift += 7;
      } while (b & 0x80);
      break;
    }
    // Actually re-do: simpler to just decode leb128 properly
    // Let me restart with a clean leb128 decoder
    return -1;  // placeholder, use the method below
  }

  // Decode one LEB128 value from buf at *pos, advance *pos.
  static uint32_t DecodeLEB128(const uint8_t* buf, size_t buf_len,
                               size_t* pos) {
    uint32_t val = 0;
    int shift = 0;
    while (*pos < buf_len) {
      uint8_t b = buf[(*pos)++];
      val |= (uint32_t)(b & 0x7f) << shift;
      shift += 7;
      if (!(b & 0x80)) break;
    }
    return val;
  }

  // Skip one LEB128 in the buffer.
  static void SkipLEB128(const uint8_t* buf, size_t buf_len, size_t* pos) {
    while (*pos < buf_len) {
      if (!(buf[(*pos)++] & 0x80)) break;
    }
  }

  // Skip a JS_ReadString: leb128 length (bit0=is_wide), then string data.
  static void SkipString(const uint8_t* buf, size_t buf_len, size_t* pos) {
    uint32_t len_field = DecodeLEB128(buf, buf_len, pos);
    uint32_t str_len = len_field >> 1;
    bool is_wide = len_field & 1;
    *pos += is_wide ? str_len * 2 : str_len;
  }

  static LEPUSFunctionBytecode* FindFunctionWithClosureCount(
      LEPUSFunctionBytecode* function, int closure_var_count) {
    if (function->closure_var_count == closure_var_count) return function;
    for (int i = 0; i < function->cpool_count; i++) {
      if (!LEPUS_VALUE_IS_FUNCTION_BYTECODE(function->cpool[i])) continue;
      auto* child = static_cast<LEPUSFunctionBytecode*>(
          LEPUS_VALUE_GET_PTR(function->cpool[i]));
      if (auto* match =
              FindFunctionWithClosureCount(child, closure_var_count)) {
        return match;
      }
    }
    return nullptr;
  }

  LEPUSContext* ctx_;
  LEPUSRuntime* rt_;
};

// Build a crafted bytecode payload with overflowing cpool_count.
// The idea: take a valid serialized bytecode, locate the cpool_count field,
// replace it with a huge value that causes integer overflow when multiplied
// by sizeof(LEPUSValue).
TEST_F(ReadFunctionOverflowTest, CpoolCountOverflowIsRejected) {
  // Compile a minimal function to get valid bytecode structure.
  const char* source = "function f() { return 42; }";
  size_t orig_len = 0;
  uint8_t* orig_buf = CompileToBytecode(source, &orig_len);
  ASSERT_NE(orig_buf, nullptr);
  ASSERT_GT(orig_len, (size_t)10);

  // Parse the bytecode to find cpool_count position.
  size_t pos = 0;

  // 1. Version byte
  uint8_t version = orig_buf[pos++];
  if (version == 0x41) {
    pos += 8;  // skip u64 extended version
  }

  // 2. Atom table: leb128 atom_count, then atom_count strings
  uint32_t atom_count = DecodeLEB128(orig_buf, orig_len, &pos);
  for (uint32_t i = 0; i < atom_count; i++) {
    SkipString(orig_buf, orig_len, &pos);
  }

  // 3. Now at JS_ReadObjectRec: first byte is the tag
  ASSERT_LT(pos, orig_len);
  uint8_t tag = orig_buf[pos++];
  // BC_TAG_FUNCTION_BYTECODE = 13
  ASSERT_EQ(tag, 13);

  // 4. Inside JS_ReadFunction:
  //    u16 flags (2 bytes)
  pos += 2;
  //    u8 js_mode
  pos += 1;
  //    leb128 func_name (atom)
  SkipLEB128(orig_buf, orig_len, &pos);
  //    leb128_u16 arg_count
  SkipLEB128(orig_buf, orig_len, &pos);
  //    leb128_u16 var_count
  SkipLEB128(orig_buf, orig_len, &pos);
  //    leb128_u16 defined_arg_count
  SkipLEB128(orig_buf, orig_len, &pos);
  //    leb128_u16 stack_size
  SkipLEB128(orig_buf, orig_len, &pos);
  //    leb128_int closure_var_count
  SkipLEB128(orig_buf, orig_len, &pos);

  // NOW pos points to cpool_count
  size_t cpool_count_offset = pos;

  // Read original cpool_count to know how many bytes it occupies
  size_t end_pos = pos;
  uint32_t orig_cpool_count = DecodeLEB128(orig_buf, orig_len, &end_pos);
  size_t orig_cpool_field_len = end_pos - cpool_count_offset;
  (void)orig_cpool_count;

  // Craft a new buffer with cpool_count = 0x20000000 (causes overflow:
  // 0x20000000 * 8 = 0x100000000, wraps to 0 in 32-bit).
  uint8_t new_cpool_count_buf[5];
  int new_cpool_field_len = EncodeLEB128(new_cpool_count_buf, 0x20000000);

  size_t new_len =
      orig_len - orig_cpool_field_len + (size_t)new_cpool_field_len;
  uint8_t* crafted_buf = (uint8_t*)malloc(new_len);
  ASSERT_NE(crafted_buf, nullptr);

  // Copy: [0, cpool_count_offset) + new_cpool_count + rest
  memcpy(crafted_buf, orig_buf, cpool_count_offset);
  memcpy(crafted_buf + cpool_count_offset, new_cpool_count_buf,
         new_cpool_field_len);
  memcpy(crafted_buf + cpool_count_offset + new_cpool_field_len,
         orig_buf + cpool_count_offset + orig_cpool_field_len,
         orig_len - cpool_count_offset - orig_cpool_field_len);

  // Try to deserialize — must return exception, NOT crash.
  LEPUSValue result =
      LEPUS_ReadObject(ctx_, crafted_buf, new_len, LEPUS_READ_OBJ_BYTECODE);
  EXPECT_TRUE(LEPUS_IsException(result));

  // Clean up exception state
  if (LEPUS_IsException(result)) {
    LEPUSValue exc = LEPUS_GetException(ctx_);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, exc);
  }

  free(crafted_buf);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, orig_buf);
}

// Test with negative cpool_count (crafted as a signed LEB128 negative value).
TEST_F(ReadFunctionOverflowTest, NegativeCpoolCountIsRejected) {
  const char* source = "function f() { return 1; }";
  size_t orig_len = 0;
  uint8_t* orig_buf = CompileToBytecode(source, &orig_len);
  ASSERT_NE(orig_buf, nullptr);

  size_t pos = 0;
  uint8_t version = orig_buf[pos++];
  if (version == 0x41) pos += 8;

  uint32_t atom_count = DecodeLEB128(orig_buf, orig_len, &pos);
  for (uint32_t i = 0; i < atom_count; i++) {
    SkipString(orig_buf, orig_len, &pos);
  }

  ASSERT_LT(pos, orig_len);
  uint8_t tag = orig_buf[pos++];
  ASSERT_EQ(tag, 13);

  pos += 2;                              // flags
  pos += 1;                              // js_mode
  SkipLEB128(orig_buf, orig_len, &pos);  // func_name
  SkipLEB128(orig_buf, orig_len, &pos);  // arg_count
  SkipLEB128(orig_buf, orig_len, &pos);  // var_count
  SkipLEB128(orig_buf, orig_len, &pos);  // defined_arg_count
  SkipLEB128(orig_buf, orig_len, &pos);  // stack_size
  SkipLEB128(orig_buf, orig_len, &pos);  // closure_var_count

  size_t cpool_count_offset = pos;
  size_t end_pos = pos;
  DecodeLEB128(orig_buf, orig_len, &end_pos);
  size_t orig_cpool_field_len = end_pos - cpool_count_offset;

  // Encode -1 as signed LEB128 (0xFFFFFFFF unsigned = 5 bytes of 0xFF 0xFF
  // 0xFF 0xFF 0x0F)
  uint8_t neg_one_leb128[] = {0xFF, 0xFF, 0xFF, 0xFF, 0x0F};
  int new_field_len = 5;

  size_t new_len = orig_len - orig_cpool_field_len + new_field_len;
  uint8_t* crafted_buf = (uint8_t*)malloc(new_len);
  ASSERT_NE(crafted_buf, nullptr);

  memcpy(crafted_buf, orig_buf, cpool_count_offset);
  memcpy(crafted_buf + cpool_count_offset, neg_one_leb128, new_field_len);
  memcpy(crafted_buf + cpool_count_offset + new_field_len,
         orig_buf + cpool_count_offset + orig_cpool_field_len,
         orig_len - cpool_count_offset - orig_cpool_field_len);

  LEPUSValue result =
      LEPUS_ReadObject(ctx_, crafted_buf, new_len, LEPUS_READ_OBJ_BYTECODE);
  EXPECT_TRUE(LEPUS_IsException(result));

  if (LEPUS_IsException(result)) {
    LEPUSValue exc = LEPUS_GetException(ctx_);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, exc);
  }

  free(crafted_buf);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, orig_buf);
}

// Test with overflowing closure_var_count.
TEST_F(ReadFunctionOverflowTest, ClosureVarCountOverflowIsRejected) {
  // Use a function with a closure to get a closure_var_count field > 0.
  const char* source =
      "(function() { var x = 1; return function() { return x; }; })";
  size_t orig_len = 0;
  uint8_t* orig_buf = CompileToBytecode(source, &orig_len);
  ASSERT_NE(orig_buf, nullptr);

  size_t pos = 0;
  uint8_t version = orig_buf[pos++];
  if (version == 0x41) pos += 8;

  uint32_t atom_count = DecodeLEB128(orig_buf, orig_len, &pos);
  for (uint32_t i = 0; i < atom_count; i++) {
    SkipString(orig_buf, orig_len, &pos);
  }

  ASSERT_LT(pos, orig_len);
  uint8_t tag = orig_buf[pos++];
  ASSERT_EQ(tag, 13);

  pos += 2;                              // flags
  pos += 1;                              // js_mode
  SkipLEB128(orig_buf, orig_len, &pos);  // func_name
  SkipLEB128(orig_buf, orig_len, &pos);  // arg_count
  SkipLEB128(orig_buf, orig_len, &pos);  // var_count
  SkipLEB128(orig_buf, orig_len, &pos);  // defined_arg_count
  SkipLEB128(orig_buf, orig_len, &pos);  // stack_size

  // NOW pos points to closure_var_count
  size_t closure_var_count_offset = pos;
  size_t end_pos = pos;
  DecodeLEB128(orig_buf, orig_len, &end_pos);
  size_t orig_field_len = end_pos - closure_var_count_offset;

  // Encode 0x30000000 (overflow when * sizeof(LEPUSClosureVar))
  uint8_t overflow_leb128[5];
  int new_field_len = EncodeLEB128(overflow_leb128, 0x30000000);

  size_t new_len = orig_len - orig_field_len + new_field_len;
  uint8_t* crafted_buf = (uint8_t*)malloc(new_len);
  ASSERT_NE(crafted_buf, nullptr);

  memcpy(crafted_buf, orig_buf, closure_var_count_offset);
  memcpy(crafted_buf + closure_var_count_offset, overflow_leb128,
         new_field_len);
  memcpy(crafted_buf + closure_var_count_offset + new_field_len,
         orig_buf + closure_var_count_offset + orig_field_len,
         orig_len - closure_var_count_offset - orig_field_len);

  LEPUSValue result =
      LEPUS_ReadObject(ctx_, crafted_buf, new_len, LEPUS_READ_OBJ_BYTECODE);
  EXPECT_TRUE(LEPUS_IsException(result));

  if (LEPUS_IsException(result)) {
    LEPUSValue exc = LEPUS_GetException(ctx_);
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, exc);
  }

  free(crafted_buf);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, orig_buf);
}

TEST_F(ReadFunctionOverflowTest, OutOfRangePutArgIndexFailsAtRuntime) {
  if (LEPUS_IsPrimjsEnabled(rt_)) {
    GTEST_SKIP() << "This test targets the regular QuickJS interpreter";
  }

  const char* source = "(function(a, b, c, d, e) { e = 1; })();";
  LEPUSValue compiled =
      LEPUS_Eval(ctx_, source, strlen(source), "<test>",
                 LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(compiled));
  ASSERT_TRUE(LEPUS_VALUE_IS_FUNCTION_BYTECODE(compiled));

  auto* top =
      static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(compiled));
  LEPUSFunctionBytecode* inner = nullptr;
  for (int i = 0; i < top->cpool_count; i++) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(top->cpool[i])) {
      inner = static_cast<LEPUSFunctionBytecode*>(
          LEPUS_VALUE_GET_PTR(top->cpool[i]));
      break;
    }
  }
  ASSERT_NE(inner, nullptr);
  ASSERT_EQ(inner->arg_count, 5);

  int put_arg_offset = -1;
  for (int pos = 0; pos < inner->byte_code_len;) {
    int op = inner->byte_code_buf[pos];
    ASSERT_LT(op, OP_COUNT);
    int len = short_opcode_info(op).size;
    ASSERT_GT(len, 0);
    ASSERT_LE(pos + len, inner->byte_code_len);
    if (op == OP_put_arg) {
      uint32_t index =
          inner->byte_code_buf[pos + 1] | (inner->byte_code_buf[pos + 2] << 8);
      ASSERT_EQ(index, 4u);
      put_arg_offset = pos;
      break;
    }
    pos += len;
  }
  ASSERT_GE(put_arg_offset, 0);

  inner->byte_code_buf[put_arg_offset + 1] = 0xff;
  inner->byte_code_buf[put_arg_offset + 2] = 0xff;

  LEPUSValue result = LEPUS_EvalFunction(ctx_, compiled, LEPUS_UNDEFINED);
  EXPECT_TRUE(LEPUS_IsException(result));
  if (LEPUS_IsException(result)) {
    LEPUSValue exception = LEPUS_GetException(ctx_);
    const char* message = LEPUS_ToCString(ctx_, exception);
    ASSERT_NE(message, nullptr);
    EXPECT_NE(strstr(message, "invalid argument index"), nullptr);
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeCString(ctx_, message);
      LEPUS_FreeValue(ctx_, exception);
    }
  }
}

TEST_F(ReadFunctionOverflowTest, OutOfRangeGetVarRefIndexFailsAtRuntime) {
  if (LEPUS_IsPrimjsEnabled(rt_)) {
    GTEST_SKIP() << "This test targets the regular QuickJS interpreter";
  }

  const char* source =
      "(function(a, b, c, d, e) {"
      "  return function() { return a + b + c + d + e; };"
      "})(1, 2, 3, 4, 5)();";
  LEPUSValue compiled =
      LEPUS_Eval(ctx_, source, strlen(source), "<test>",
                 LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(compiled));
  ASSERT_TRUE(LEPUS_VALUE_IS_FUNCTION_BYTECODE(compiled));

  auto* top =
      static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(compiled));
  LEPUSFunctionBytecode* inner = FindFunctionWithClosureCount(top, 5);
  ASSERT_NE(inner, nullptr);

  int get_var_ref_offset = -1;
  for (int pos = 0; pos < inner->byte_code_len;) {
    int op = inner->byte_code_buf[pos];
    ASSERT_LT(op, OP_COUNT);
    int len = short_opcode_info(op).size;
    ASSERT_GT(len, 0);
    ASSERT_LE(pos + len, inner->byte_code_len);
    if (op == OP_get_var_ref) {
      uint32_t index =
          inner->byte_code_buf[pos + 1] | (inner->byte_code_buf[pos + 2] << 8);
      if (index == 4) {
        get_var_ref_offset = pos;
        break;
      }
    }
    pos += len;
  }
  ASSERT_GE(get_var_ref_offset, 0);

  inner->byte_code_buf[get_var_ref_offset + 1] = 0xff;
  inner->byte_code_buf[get_var_ref_offset + 2] = 0xff;

  LEPUSValue result = LEPUS_EvalFunction(ctx_, compiled, LEPUS_UNDEFINED);
  EXPECT_TRUE(LEPUS_IsException(result));
  if (LEPUS_IsException(result)) {
    LEPUSValue exception = LEPUS_GetException(ctx_);
    const char* message = LEPUS_ToCString(ctx_, exception);
    ASSERT_NE(message, nullptr);
    EXPECT_NE(strstr(message, "invalid closure variable index"), nullptr);
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeCString(ctx_, message);
      LEPUS_FreeValue(ctx_, exception);
    }
  }
}
