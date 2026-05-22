// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <stdlib.h>

#include "quickjs/include/quickjs-inner.h"

#ifndef NO_QUICKJS_COMPILER

namespace {

constexpr int kMaxBinaryOpLevel = 8;

struct JSBinaryOpInfo {
  int level;
  int opcode;
};

BOOL js_parse_get_binary_op_info(int op, int parse_flags,
                                 JSBinaryOpInfo *info) {
  switch (op) {
    case '*':
      info->level = 1;
      info->opcode = OP_mul;
      return TRUE;
    case '/':
      info->level = 1;
      info->opcode = OP_div;
      return TRUE;
    case '%':
      info->level = 1;
      info->opcode = OP_mod;
      return TRUE;
    case '+':
      info->level = 2;
      info->opcode = OP_add;
      return TRUE;
    case '-':
      info->level = 2;
      info->opcode = OP_sub;
      return TRUE;
    case TOK_SHL:
      info->level = 3;
      info->opcode = OP_shl;
      return TRUE;
    case TOK_SAR:
      info->level = 3;
      info->opcode = OP_sar;
      return TRUE;
    case TOK_SHR:
      info->level = 3;
      info->opcode = OP_shr;
      return TRUE;
    case '<':
      info->level = 4;
      info->opcode = OP_lt;
      return TRUE;
    case '>':
      info->level = 4;
      info->opcode = OP_gt;
      return TRUE;
    case TOK_LTE:
      info->level = 4;
      info->opcode = OP_lte;
      return TRUE;
    case TOK_GTE:
      info->level = 4;
      info->opcode = OP_gte;
      return TRUE;
    case TOK_INSTANCEOF:
      info->level = 4;
      info->opcode = OP_instanceof;
      return TRUE;
    case TOK_IN:
      if (!(parse_flags & PF_IN_ACCEPTED)) return FALSE;
      info->level = 4;
      info->opcode = OP_in;
      return TRUE;
    case TOK_EQ:
      info->level = 5;
      info->opcode = OP_eq;
      return TRUE;
    case TOK_NEQ:
      info->level = 5;
      info->opcode = OP_neq;
      return TRUE;
    case TOK_STRICT_EQ:
      info->level = 5;
      info->opcode = OP_strict_eq;
      return TRUE;
    case TOK_STRICT_NEQ:
      info->level = 5;
      info->opcode = OP_strict_neq;
      return TRUE;
    case '&':
      info->level = 6;
      info->opcode = OP_and;
      return TRUE;
    case '^':
      info->level = 7;
      info->opcode = OP_xor;
      return TRUE;
    case '|':
      info->level = 8;
      info->opcode = OP_or;
      return TRUE;
    default:
      return FALSE;
  }
}

int js_parse_new_label(JSParseState *s) {
  return new_label_fd(s->cur_func, -1);
}

}  // namespace

/* allowed parse_flags: PF_ARROW_FUNC, PF_IN_ACCEPTED */
__exception int js_parse_expr_binary(JSParseState *s, int level,
                                     int parse_flags) {
  JSBinaryOpInfo op_stack[kMaxBinaryOpLevel];
  int op_count = 0;

  if (level < 0 || level > kMaxBinaryOpLevel) abort();
  if (level == 0) {
    return js_parse_unary(s, (parse_flags & PF_ARROW_FUNC) | PF_POW_ALLOWED);
  }

  if (js_parse_unary(s, (parse_flags & PF_ARROW_FUNC) | PF_POW_ALLOWED))
    return -1;

  for (;;) {
    JSBinaryOpInfo op_info;
    if (!js_parse_get_binary_op_info(s->token.val, parse_flags, &op_info) ||
        op_info.level > level) {
      break;
    }

    while (op_count > 0 && op_stack[op_count - 1].level <= op_info.level) {
      emit_op(s, op_stack[--op_count].opcode);
    }
    if (op_count >= kMaxBinaryOpLevel) abort();
    op_stack[op_count++] = op_info;

    if (next_token(s)) return -1;
    if (js_parse_unary(s, PF_POW_ALLOWED)) return -1;
  }

  while (op_count > 0) {
    emit_op(s, op_stack[--op_count].opcode);
  }
  return 0;
}

/* allowed parse_flags: PF_ARROW_FUNC, PF_IN_ACCEPTED */
static __exception int js_parse_logical_and_expr(JSParseState *s,
                                                 int parse_flags) {
  int label = -1;
  BOOL has_logical_and = FALSE;

  if (js_parse_expr_binary(s, kMaxBinaryOpLevel, parse_flags)) return -1;

  while (s->token.val == TOK_LAND) {
    if (label < 0) label = js_parse_new_label(s);
    has_logical_and = TRUE;

    if (next_token(s)) return -1;
    emit_op(s, OP_dup);
    emit_goto(s, OP_if_false, label);
    emit_op(s, OP_drop);

    if (js_parse_expr_binary(s, kMaxBinaryOpLevel,
                             parse_flags & ~PF_ARROW_FUNC))
      return -1;
  }

  if (has_logical_and && s->token.val == TOK_DOUBLE_QUESTION_MARK) {
    return js_parse_error(s, "cannot mix ?? with && or ||");
  }
  if (label >= 0) emit_label(s, label);
  return 0;
}

/* allowed parse_flags: PF_ARROW_FUNC, PF_IN_ACCEPTED */
static __exception int js_parse_logical_or_expr(JSParseState *s,
                                                int parse_flags) {
  int label = -1;
  BOOL has_logical_or = FALSE;

  if (js_parse_logical_and_expr(s, parse_flags)) return -1;

  while (s->token.val == TOK_LOR) {
    if (label < 0) label = js_parse_new_label(s);
    has_logical_or = TRUE;

    if (next_token(s)) return -1;
    emit_op(s, OP_dup);
    emit_goto(s, OP_if_true, label);
    emit_op(s, OP_drop);

    if (js_parse_logical_and_expr(s, parse_flags & ~PF_ARROW_FUNC)) return -1;
  }

  if (has_logical_or && s->token.val == TOK_DOUBLE_QUESTION_MARK) {
    return js_parse_error(s, "cannot mix ?? with && or ||");
  }
  if (label >= 0) emit_label(s, label);
  return 0;
}

/* allowed parse_flags: PF_ARROW_FUNC, PF_IN_ACCEPTED */
__exception int js_parse_cond_expr(JSParseState *s, int parse_flags) {
  int label1, label2;

  if (js_parse_logical_or_expr(s, parse_flags)) return -1;
  if (s->token.val == TOK_DOUBLE_QUESTION_MARK) {
    label1 = js_parse_new_label(s);
    for (;;) {
      if (next_token(s)) return -1;

      emit_op(s, OP_dup);
      emit_op(s, OP_is_undefined);
      emit_goto(s, OP_if_false, label1);
      emit_op(s, OP_drop);

      if (js_parse_expr_binary(s, kMaxBinaryOpLevel,
                               parse_flags & ~PF_ARROW_FUNC))
        return -1;
      if (s->token.val != TOK_DOUBLE_QUESTION_MARK) break;
    }
    if (s->token.val == TOK_LAND || s->token.val == TOK_LOR) {
      return js_parse_error(s, "cannot mix ?? with && or ||");
    }
    emit_label(s, label1);
  }
  if (s->token.val == '?') {
    if (next_token(s)) return -1;
    label1 = emit_goto(s, OP_if_false, -1);

    if (js_parse_assign_expr(s, PF_IN_ACCEPTED)) return -1;
    if (js_parse_expect(s, ':')) return -1;

    label2 = emit_goto(s, OP_goto, -1);

    emit_label(s, label1);

    if (js_parse_assign_expr(s, parse_flags & PF_IN_ACCEPTED)) return -1;

    emit_label(s, label2);
  }
  return 0;
}

#endif  // !NO_QUICKJS_COMPILER
