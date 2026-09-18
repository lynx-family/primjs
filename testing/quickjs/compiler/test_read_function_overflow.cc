// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>
#include <string>

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

// Test that LEPUS_ReadObject rejects malformed bytecode metadata and operand
// indexes before the bytecode can be executed.

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

  struct SerializedFunctionInfo {
    size_t byte_code_offset;
    uint32_t byte_code_len;
  };

  static bool DecodeLEB128Checked(const uint8_t* buf, size_t buf_len,
                                  size_t* pos, uint32_t* value) {
    uint32_t result = 0;
    int shift = 0;
    while (*pos < buf_len && shift < 35) {
      uint8_t byte = buf[(*pos)++];
      result |= static_cast<uint32_t>(byte & 0x7f) << shift;
      if (!(byte & 0x80)) {
        *value = result;
        return true;
      }
      shift += 7;
    }
    return false;
  }

  static bool SkipStringChecked(const uint8_t* buf, size_t buf_len,
                                size_t* pos) {
    uint32_t len_field;
    if (!DecodeLEB128Checked(buf, buf_len, pos, &len_field)) return false;
    size_t byte_len = static_cast<size_t>(len_field >> 1);
    if (len_field & 1) {
      if (byte_len > SIZE_MAX / 2) return false;
      byte_len *= 2;
    }
    if (byte_len > buf_len - *pos) return false;
    *pos += byte_len;
    return true;
  }

  static bool SkipLEB128Checked(const uint8_t* buf, size_t buf_len,
                                size_t* pos) {
    uint32_t value;
    return DecodeLEB128Checked(buf, buf_len, pos, &value);
  }

  static bool ParseSerializedFunction(const uint8_t* buf, size_t buf_len,
                                      SerializedFunctionInfo* info) {
    size_t pos = 0;
    if (pos >= buf_len) return false;
    uint8_t version = buf[pos++];
    if (version == 0x41) {
      if (buf_len - pos < 8) return false;
      pos += 8;
    }

    uint32_t atom_count;
    if (!DecodeLEB128Checked(buf, buf_len, &pos, &atom_count)) return false;
    for (uint32_t i = 0; i < atom_count; i++) {
      if (!SkipStringChecked(buf, buf_len, &pos)) return false;
    }

    if (pos >= buf_len || buf[pos++] != 13) return false;
    if (buf_len - pos < 3) return false;
    pos += 3;  // flags and js_mode
    if (!SkipLEB128Checked(buf, buf_len, &pos)) return false;  // func_name

    uint32_t arg_count;
    uint32_t var_count;
    uint32_t defined_arg_count;
    uint32_t stack_size;
    uint32_t closure_var_count;
    uint32_t cpool_count;
    uint32_t byte_code_len;
    uint32_t local_count;
    if (!DecodeLEB128Checked(buf, buf_len, &pos, &arg_count) ||
        !DecodeLEB128Checked(buf, buf_len, &pos, &var_count) ||
        !DecodeLEB128Checked(buf, buf_len, &pos, &defined_arg_count) ||
        !DecodeLEB128Checked(buf, buf_len, &pos, &stack_size) ||
        !DecodeLEB128Checked(buf, buf_len, &pos, &closure_var_count) ||
        !DecodeLEB128Checked(buf, buf_len, &pos, &cpool_count) ||
        !DecodeLEB128Checked(buf, buf_len, &pos, &byte_code_len) ||
        !DecodeLEB128Checked(buf, buf_len, &pos, &local_count)) {
      return false;
    }

    for (uint32_t i = 0; i < local_count; i++) {
      if (!SkipLEB128Checked(buf, buf_len, &pos) ||
          !SkipLEB128Checked(buf, buf_len, &pos) ||
          !SkipLEB128Checked(buf, buf_len, &pos) || pos >= buf_len) {
        return false;
      }
      pos++;  // vardef flags
    }
    for (uint32_t i = 0; i < closure_var_count; i++) {
      if (!SkipLEB128Checked(buf, buf_len, &pos) ||
          !SkipLEB128Checked(buf, buf_len, &pos) || pos >= buf_len) {
        return false;
      }
      pos++;  // closure flags
    }
    if (byte_code_len > buf_len - pos) return false;
    info->byte_code_offset = pos;
    info->byte_code_len = byte_code_len;
    return true;
  }

  static size_t FindOpcode(const LEPUSFunctionBytecode* function, int opcode) {
    size_t pos = 0;
    while (pos < static_cast<size_t>(function->byte_code_len)) {
      int current_opcode = function->byte_code_buf[pos];
      if (current_opcode == opcode) return pos;
      size_t opcode_size = short_opcode_info(current_opcode).size;
      if (opcode_size == 0 ||
          opcode_size > static_cast<size_t>(function->byte_code_len) - pos) {
        break;
      }
      pos += opcode_size;
    }
    return SIZE_MAX;
  }

  static LEPUSFunctionBytecode* FindFunctionWithOpcode(
      LEPUSFunctionBytecode* function, int opcode, size_t* opcode_pos) {
    size_t pos = FindOpcode(function, opcode);
    if (pos != SIZE_MAX) {
      *opcode_pos = pos;
      return function;
    }
    for (int i = 0; i < function->cpool_count; i++) {
      if (!LEPUS_VALUE_IS_FUNCTION_BYTECODE(function->cpool[i])) continue;
      auto* child = static_cast<LEPUSFunctionBytecode*>(
          LEPUS_VALUE_GET_PTR(function->cpool[i]));
      LEPUSFunctionBytecode* result =
          FindFunctionWithOpcode(child, opcode, opcode_pos);
      if (result != nullptr) return result;
    }
    return nullptr;
  }

  uint8_t* CompileFunctionWithOpcode(const char* source, int opcode,
                                     size_t* out_len, size_t* opcode_pos) {
    LEPUSValue compiled =
        LEPUS_Eval(ctx_, source, strlen(source), "<test>",
                   LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL);
    if (LEPUS_IsException(compiled) ||
        !LEPUS_VALUE_IS_FUNCTION_BYTECODE(compiled)) {
      *out_len = 0;
      return nullptr;
    }

    auto* top =
        static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(compiled));
    LEPUSFunctionBytecode* function =
        FindFunctionWithOpcode(top, opcode, opcode_pos);
    uint8_t* buf = nullptr;
    if (function != nullptr) {
      LEPUSValue function_value =
          LEPUS_MKPTR(LEPUS_TAG_FUNCTION_BYTECODE, function);
      buf = LEPUS_WriteObject(ctx_, out_len, function_value,
                              LEPUS_WRITE_OBJ_BYTECODE);
    }
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
    return buf;
  }

  void ExpectInvalidOperandIndex(const char* source, int opcode,
                                 size_t operand_offset, size_t operand_size,
                                 const char* expected_error,
                                 int replacement_opcode = -1) {
    size_t serialized_len = 0;
    size_t opcode_pos = SIZE_MAX;
    uint8_t* serialized =
        CompileFunctionWithOpcode(source, opcode, &serialized_len, &opcode_pos);
    ASSERT_NE(serialized, nullptr);
    ASSERT_NE(opcode_pos, SIZE_MAX);

    SerializedFunctionInfo info;
    ASSERT_TRUE(ParseSerializedFunction(serialized, serialized_len, &info));
    ASSERT_LT(opcode_pos + operand_offset + operand_size,
              static_cast<size_t>(info.byte_code_len) + 1);
    size_t serialized_opcode_pos = info.byte_code_offset + opcode_pos;
    ASSERT_EQ(serialized[serialized_opcode_pos], opcode);

    LEPUSValue valid_result = LEPUS_ReadObject(ctx_, serialized, serialized_len,
                                               LEPUS_READ_OBJ_BYTECODE);
    ASSERT_FALSE(LEPUS_IsException(valid_result));
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, valid_result);

    memset(serialized + serialized_opcode_pos + operand_offset, 0xff,
           operand_size);
    if (replacement_opcode >= 0) {
      serialized[serialized_opcode_pos] = replacement_opcode;
    }

    size_t malloc_count_before = 0;
    size_t malloc_size_before = 0;
    if (!ctx_->rt->gc_enable) {
      LEPUS_ThrowSyntaxError(ctx_, "warm up exception cache");
      LEPUSValue warmup_exception = LEPUS_GetException(ctx_);
      const char* warmup_message = LEPUS_ToCString(ctx_, warmup_exception);
      LEPUS_FreeCString(ctx_, warmup_message);
      LEPUS_FreeValue(ctx_, warmup_exception);
      malloc_count_before = ctx_->rt->malloc_state.malloc_count;
      malloc_size_before = ctx_->rt->malloc_state.malloc_size;
    }
    LEPUSValue result = LEPUS_ReadObject(ctx_, serialized, serialized_len,
                                         LEPUS_READ_OBJ_BYTECODE);
    ASSERT_TRUE(LEPUS_IsException(result));
    LEPUSValue exception = LEPUS_GetException(ctx_);
    const char* message = LEPUS_ToCString(ctx_, exception);
    ASSERT_NE(message, nullptr);
    EXPECT_NE(std::string(message).find(expected_error), std::string::npos)
        << message;
    if (!ctx_->rt->gc_enable) {
      LEPUS_FreeCString(ctx_, message);
      LEPUS_FreeValue(ctx_, exception);
      EXPECT_EQ(ctx_->rt->malloc_state.malloc_count, malloc_count_before);
      EXPECT_EQ(ctx_->rt->malloc_state.malloc_size, malloc_size_before);
      lepus_free(ctx_, serialized);
    }
  }

  LEPUSContext* ctx_;
  LEPUSRuntime* rt_;
};

TEST_F(ReadFunctionOverflowTest, LocalOperandIndexIsRejectedDuringDecode) {
  ExpectInvalidOperandIndex("function f() { let a, b, c, d, e; return e; }",
                            OP_get_loc_check, 1, 2, "invalid bytecode index");
}

TEST_F(ReadFunctionOverflowTest, InvalidOpcodeIsRejectedBeforeFormatLookup) {
  ExpectInvalidOperandIndex("function f(value) { return value; }", OP_get_arg0,
                            0, 0, "invalid opcode", OP_invalid);
}

TEST_F(ReadFunctionOverflowTest, TruncatedOperandIsRejectedBeforeIndexRead) {
  ExpectInvalidOperandIndex("function f(value) {}", OP_return_undef, 0, 0,
                            "read after the end of the buffer", OP_get_arg);
}

TEST_F(ReadFunctionOverflowTest, Local8OperandIndexIsRejectedDuringDecode) {
  ExpectInvalidOperandIndex(
      "function f(input) { var a = input, b = input, c = input, d = input, "
      "e = input; return a + b + c + d + e; }",
      OP_get_loc8, 1, 1, "invalid bytecode index");
}

TEST_F(ReadFunctionOverflowTest,
       ImplicitLocalOperandIndexIsRejectedDuringDecode) {
  ExpectInvalidOperandIndex(
      "function f(input) { var value; if (input) value = 1; else value = 2; "
      "return value; }",
      OP_get_loc0, 0, 0, "invalid bytecode index", OP_get_loc3);
}

TEST_F(ReadFunctionOverflowTest, ArgumentOperandIndexIsRejectedDuringDecode) {
  ExpectInvalidOperandIndex("function f(a, b, c, d, e) { return e; }",
                            OP_get_arg, 1, 2, "invalid bytecode index");
}

TEST_F(ReadFunctionOverflowTest,
       ImplicitArgumentOperandIndexIsRejectedDuringDecode) {
  ExpectInvalidOperandIndex("function f(value) { return value; }", OP_get_arg0,
                            0, 0, "invalid bytecode index", OP_get_arg3);
}

TEST_F(ReadFunctionOverflowTest,
       ClosureVariableOperandIndexIsRejectedDuringDecode) {
  ExpectInvalidOperandIndex(
      "function outer() { var a, b, c, d, e; "
      "return function() { return a + b + c + d + e; }; }",
      OP_get_var_ref, 1, 2, "invalid bytecode index");
}

TEST_F(ReadFunctionOverflowTest,
       ImplicitClosureOperandIndexIsRejectedDuringDecode) {
  ExpectInvalidOperandIndex(
      "function outer() { var value = 1; "
      "return function() { return value; }; }",
      OP_get_var_ref0, 0, 0, "invalid bytecode index", OP_get_var_ref3);
}

TEST_F(ReadFunctionOverflowTest,
       CompoundReferenceOperandIndexIsRejectedDuringDecode) {
  ExpectInvalidOperandIndex(
      "function f(object) { var value; ({ value } = object); return value; }",
      OP_make_loc_ref, 5, 2, "invalid bytecode index");
}

TEST_F(ReadFunctionOverflowTest,
       ConstantPoolOperandIndexIsRejectedDuringDecode) {
  ExpectInvalidOperandIndex("function f() { return function() { return 1; }; }",
                            OP_fclosure8, 1, 1, "invalid bytecode index");
}

TEST_F(ReadFunctionOverflowTest,
       LongConstantPoolOperandIndexIsRejectedDuringDecode) {
  std::string source = "function f() { return [";
  for (int i = 0; i < 257; i++) {
    if (i != 0) source += ',';
    source += "function() {}";
  }
  source += "]; }";
  ExpectInvalidOperandIndex(source.c_str(), OP_fclosure, 1, 4,
                            "invalid bytecode index");
}

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
