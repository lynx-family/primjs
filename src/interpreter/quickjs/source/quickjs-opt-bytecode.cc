// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifdef ENABLE_LEPUSNG_BYTECODE_OPT

/*
 * QuickJS Bytecode Optimizer - Post-compilation optimization passes
 *
 * This file implements the extended bytecode optimization pipeline that runs
 * during resolve_labels() in quickjs.cc. These passes aim to reduce bytecode
 * size (and thus memory/startup cost) for bundled JavaScript files.
 *
 * === Optimization Pipeline Execution Order ===
 *
 * PRE-PASS (before main bytecode emission loop in resolve_labels):
 *   1. opt_prescan_tdz_dse       - Scan original bytecode to identify which
 *                                  variables are DSE/TDZ-eligible
 *   2. opt_reorder_local_vars    - Remap local var indices by access frequency
 *                                  (hot vars → short-encoded indices 0-3)
 *   3. opt_reorder_closure_vars  - Same for closure variables (var_ref)
 *   4. opt_reorder_cpool         - Remap constant pool so hot entries fit in
 *                                  push_const8 (1-byte index)
 *
 * POST-PASS (after main bytecode emission loop completes):
 *   5. opt_dead_slu_elim        - Remove dead set_loc_uninitialized (→ NOP)
 *   6. opt_post_peephole        - Short-range 2-3 instruction patterns (→ NOP
 * gaps)
 *   7. opt_dead_value_elim      - Result-unused drop elimination (→ NOP gaps)
 *   8. opt_goto_chain_follow     - Goto-to-return/throw chain following
 *   9. opt_branch_inversion    - if_xxx + goto → if_inv (branch inversion)
 *  10. opt_final_dce           - Dead code elimination (→ NOP gaps)
 *  11. opt_nop_strip           - Compact bytecode by removing all NOP gaps
 *  12. opt_jump_shrink          - Shrink wide jumps to short encoding (defined
 * in quickjs.cc)
 *
 * Ordering Constraints:
 *   - Passes 5-10 preserve label addresses (NOP-fill only).
 *   - Passes 11-12 change bytecode offsets and must run last.
 *   - Order 6 → 7 → 8 → 9 → 10 maximizes cascading optimizations.
 */

#include "quickjs/include/quickjs-opt-bytecode.h"

#include <stdarg.h>
#include <string.h>

/* ========================================================================
 * Common bytecode operation inline helpers
 * ======================================================================== */

/* Skip OP_line_num directives, return next valid opcode, update *pos and
 * *out_line */
static inline int next_valid_op(const uint8_t *buf, int len, int *pos,
                                int64_t *out_line) {
  while (*pos < len) {
    int op = buf[*pos];
    int op_len = opcode_info[op].size;
    if (*pos + op_len > len) return -1;
    if (op == OP_line_num) {
      if (out_line) *out_line = get_u64(buf + *pos + 1);
      *pos += op_len;
    } else {
      return op;
    }
  }
  return -1;
}

/* Read opcode immediates (call after op has been read, pos points to imm field)
 */
static inline uint8_t read_imm_u8(const uint8_t *buf, int pos) {
  return buf[pos];
}
static inline uint16_t read_imm_u16(const uint8_t *buf, int pos) {
  return get_u16(buf + pos);
}
static inline uint32_t read_imm_u32(const uint8_t *buf, int pos) {
  return get_u32(buf + pos);
}

/* Emit opcode with immediates to DynBuf */
static inline void emit_op(DynBuf *db, int op) { dbuf_putc(db, op); }
static inline void emit_op_u8(DynBuf *db, int op, uint8_t imm) {
  dbuf_putc(db, op);
  dbuf_putc(db, imm);
}
static inline void emit_op_u16(DynBuf *db, int op, uint16_t imm) {
  dbuf_putc(db, op);
  dbuf_put_u16(db, imm);
}
static inline void emit_op_u32(DynBuf *db, int op, uint32_t imm) {
  dbuf_putc(db, op);
  dbuf_put_u32(db, imm);
}

static inline void nop_full_instruction(LEPUSContext *ctx, DynBuf *bc_out,
                                        int pos) {
  uint8_t op = bc_out->buf[pos];
  const JSOpCode *oi = &short_opcode_info(op);
  int sz = oi->size;
  if (sz <= 0) return;

  switch (oi->fmt) {
    case OP_FMT_atom:
    case OP_FMT_atom_u8:
    case OP_FMT_atom_u16:
    case OP_FMT_atom_label_u8:
    case OP_FMT_atom_label_u16:
      if (!ctx->gc_enable) LEPUS_FreeAtom(ctx, get_u32(bc_out->buf + pos + 1));
      break;
    default:
      break;
  }

  for (int k = 0; k < sz; k++) bc_out->buf[pos + k] = OP_nop;
}

static inline int32_t int32_arithmetic_shift_right(int32_t val, int shift) {
  shift &= 31;
  if (shift == 0) return val;
  uint32_t bits = (uint32_t)val;
  uint32_t shifted = bits >> shift;
  if (val < 0) shifted |= ~((uint32_t)-1 >> shift);
  return (int32_t)shifted;
}

/* ========================================================================
 * Public API implementations (optimization-specific)
 * ======================================================================== */

void lepusng_run_bytecode_post_pipeline(LEPUSContext *ctx, JSFunctionDef *s,
                                        DynBuf *bc_out) {
  opt_post_peephole(ctx, s, bc_out);
  opt_dead_value_elim(ctx, s, bc_out);
  opt_goto_chain_follow(ctx, s, bc_out);
  opt_branch_inversion(ctx, s, bc_out);
  opt_final_dce(ctx, s, bc_out);
  opt_nop_strip(ctx, s, bc_out);
#if SHORT_OPCODES
  opt_jump_shrink(ctx, s, bc_out, true);
#endif
}

/* ========================================================================
 * PRE-PASS: TDZ/DSE Pre-scan
 * ========================================================================
 *
 * Scans the original (unoptimized) bytecode to classify local variables:
 * - loc_permanently_init[i] = 1 if var i has ≤1 set_loc_uninitialized
 *   (meaning once initialized it can never re-enter TDZ)
 * - loc_perm_written[i] = 1 if var i is permanently_init AND was already
 *   initialized at function entry (no TDZ check ever needed)
 * - var_is_read[i] = 1 if var i is ever read (get_loc/get_loc_check/etc.)
 *   Variables that are never read are dead store elimination candidates.
 */
/* Pre-scan: identify local variables that can never re-enter TDZ
   (0 or 1 set_loc_uninitialized), and track which variables are ever read
   (for dead store elimination).  Writes outputs into opt_ctx. */
void opt_prescan_tdz_dse(BytecodeOptCtx *opt_ctx, const uint8_t *bc_buf,
                         int bc_len) {
  LEPUSContext *ctx = opt_ctx->ctx;
  JSFunctionDef *s = opt_ctx->s;
  const uint8_t *loc_initialized = opt_ctx->loc_initialized;
  int pos, i;
  uint8_t *tdz_count = static_cast<uint8_t *>(
      lepus_mallocz(ctx, s->var_count, ALLOC_TAG_WITHOUT_PTR));
  if (unlikely(!tdz_count)) {
    opt_ctx->loc_permanently_init = NULL;
    opt_ctx->loc_perm_written = NULL;
    opt_ctx->var_is_read = NULL;
    return;
  }
  uint8_t *var_is_read = static_cast<uint8_t *>(
      lepus_mallocz(ctx, s->var_count, ALLOC_TAG_WITHOUT_PTR));
  if (unlikely(!var_is_read)) {
    lepus_free(ctx, tdz_count);
    opt_ctx->loc_permanently_init = NULL;
    opt_ctx->loc_perm_written = NULL;
    opt_ctx->var_is_read = NULL;
    return;
  }

  for (pos = 0; pos < bc_len;) {
    int scan_op = bc_buf[pos];
    int scan_size = opcode_info[scan_op].size;
    if (scan_size <= 0) break;
    if (scan_op == OP_set_loc_uninitialized) {
      int idx = get_u16(bc_buf + pos + 1);
      if (idx < s->var_count) {
        if (tdz_count[idx] < 255) tdz_count[idx]++;
      }
    }
    /* DSE: track which variables are ever read.
       put_loc_check and put_loc_check_init read the TDZ state
       (JS_UNINITIALIZED flag) before writing, so they count as reads. */
    if (scan_op == OP_get_loc || scan_op == OP_get_loc_check ||
        scan_op == OP_put_loc_check || scan_op == OP_put_loc_check_init) {
      int idx = get_u16(bc_buf + pos + 1);
      if (idx < s->var_count) var_is_read[idx] = 1;
    }
    if (scan_op == OP_get_loc8) {
      int idx = bc_buf[pos + 1];
      if (idx < s->var_count) var_is_read[idx] = 1;
    }
    if (scan_op >= OP_get_loc0 && scan_op <= OP_get_loc3) {
      int idx = scan_op - OP_get_loc0;
      if (idx < s->var_count) var_is_read[idx] = 1;
    }
    /* OP_make_loc_ref reads (and creates a reference to) a local variable. */
    if (scan_op == OP_make_loc_ref) {
      int idx = get_u16(bc_buf + pos + 5);
      if (idx < s->var_count) var_is_read[idx] = 1;
    }
    pos += scan_size;
  }
  /* Safety exclusions for DSE: mark variables that must not be eliminated */
  for (i = 0; i < s->var_count; i++) {
    if (s->vars[i].is_captured)
      var_is_read[i] = 1; /* closures read via var_ref */
  }
  if (s->var_object_idx >= 0) var_is_read[s->var_object_idx] = 1;
  if (s->arg_var_object_idx >= 0) var_is_read[s->arg_var_object_idx] = 1;
  if (s->this_var_idx >= 0) var_is_read[s->this_var_idx] = 1;
  if (s->arguments_var_idx >= 0) var_is_read[s->arguments_var_idx] = 1;
  if (s->new_target_var_idx >= 0) var_is_read[s->new_target_var_idx] = 1;
  if (s->home_object_var_idx >= 0) var_is_read[s->home_object_var_idx] = 1;
  if (s->this_active_func_var_idx >= 0)
    var_is_read[s->this_active_func_var_idx] = 1;
  if (s->func_var_idx >= 0) var_is_read[s->func_var_idx] = 1;
  if (s->has_eval_call) memset(var_is_read, 1, s->var_count);

  /* Variables with at most one TDZ entry can never re-enter TDZ */
  uint8_t *loc_permanently_init = static_cast<uint8_t *>(
      lepus_mallocz(ctx, s->var_count, ALLOC_TAG_WITHOUT_PTR));
  if (!loc_permanently_init) {
    lepus_free(ctx, tdz_count);
    lepus_free(ctx, var_is_read);
    opt_ctx->loc_permanently_init = NULL;
    opt_ctx->loc_perm_written = NULL;
    opt_ctx->var_is_read = NULL;
    return;
  }
  uint8_t *loc_perm_written = static_cast<uint8_t *>(
      lepus_mallocz(ctx, s->var_count, ALLOC_TAG_WITHOUT_PTR));
  if (!loc_perm_written) {
    lepus_free(ctx, tdz_count);
    lepus_free(ctx, var_is_read);
    lepus_free(ctx, loc_permanently_init);
    opt_ctx->loc_permanently_init = NULL;
    opt_ctx->loc_perm_written = NULL;
    opt_ctx->var_is_read = NULL;
    return;
  }
  for (i = 0; i < s->var_count; i++) {
    if (tdz_count[i] <= 1) loc_permanently_init[i] = 1;
  }
  /* Variables already initialized at function entry are permanently written */
  for (i = 0; i < s->var_count; i++) {
    if (loc_permanently_init[i] && loc_initialized[i]) loc_perm_written[i] = 1;
  }
  lepus_free(ctx, tdz_count);

  opt_ctx->loc_permanently_init = loc_permanently_init;
  opt_ctx->loc_perm_written = loc_perm_written;
  opt_ctx->var_is_read = var_is_read;
}

/* Build a remap array that reorders indices by descending access frequency.
   Uses Shell sort with Knuth's gap sequence. Returns a newly allocated
   remap array (caller must free), or NULL if remap would be identity
   or on allocation failure. */
static int *build_freq_remap(LEPUSContext *ctx, const uint16_t *freq,
                             int count) {
  int i;
  int *sort_indices = static_cast<int *>(
      lepus_malloc(ctx, count * sizeof(int), ALLOC_TAG_WITHOUT_PTR));
  if (!sort_indices) return NULL;

  for (i = 0; i < count; i++) sort_indices[i] = i;

  /* Shell sort with Knuth's gap sequence: ..., 121, 40, 13, 4, 1 */
  int gap = 1;
  while (gap < count / 3) gap = gap * 3 + 1;
  for (; gap >= 1; gap /= 3) {
    for (i = gap; i < count; i++) {
      int key = sort_indices[i];
      uint16_t key_count = freq[key];
      int j = i - gap;
      while (j >= 0 && freq[sort_indices[j]] < key_count) {
        sort_indices[j + gap] = sort_indices[j];
        j -= gap;
      }
      sort_indices[j + gap] = key;
    }
  }

  int *remap = static_cast<int *>(
      lepus_malloc(ctx, count * sizeof(int), ALLOC_TAG_WITHOUT_PTR));
  if (!remap) {
    lepus_free(ctx, sort_indices);
    return NULL;
  }

  for (i = 0; i < count; i++) remap[sort_indices[i]] = i;

  /* Check if remap is identity */
  BOOL is_identity = TRUE;
  for (i = 0; i < count; i++) {
    if (remap[i] != i) {
      is_identity = FALSE;
      break;
    }
  }

  lepus_free(ctx, sort_indices);

  if (is_identity) {
    lepus_free(ctx, remap);
    return NULL;
  }
  return remap;
}

/* Local variable index reordering: assign the lowest indices (shortest
   bytecode encoding) to the most frequently accessed variables.
   Index 0-3 = 1 byte, 4-255 = 2 bytes, 256+ = 3 bytes. */
void opt_reorder_local_vars(BytecodeOptCtx *opt_ctx, const uint8_t *bc_buf,
                            int bc_len) {
  LEPUSContext *ctx = opt_ctx->ctx;
  JSFunctionDef *s = opt_ctx->s;
  uint8_t *var_is_read = opt_ctx->var_is_read;
  uint8_t *loc_permanently_init = opt_ctx->loc_permanently_init;
  uint8_t *loc_perm_written = opt_ctx->loc_perm_written;
  uint8_t *loc_initialized = opt_ctx->loc_initialized;
  int pos, i;
  int *loc_remap = NULL;

  uint16_t *var_access_count = static_cast<uint16_t *>(lepus_mallocz(
      ctx, s->var_count * sizeof(uint16_t), ALLOC_TAG_WITHOUT_PTR));
  if (!var_access_count) return;

  /* Count accesses in bytecode */
  for (pos = 0; pos < bc_len;) {
    int scan_op = bc_buf[pos];
    int scan_size = opcode_info[scan_op].size;
    if (scan_size <= 0) break;
    if (scan_op == OP_get_loc || scan_op == OP_put_loc ||
        scan_op == OP_set_loc || scan_op == OP_get_loc_check ||
        scan_op == OP_put_loc_check || scan_op == OP_put_loc_check_init ||
        scan_op == OP_set_loc_uninitialized || scan_op == OP_close_loc) {
      int idx = get_u16(bc_buf + pos + 1);
      if (idx < s->var_count && var_access_count[idx] < 65535)
        var_access_count[idx]++;
    }
    if (scan_op == OP_make_loc_ref) {
      int idx = get_u16(bc_buf + pos + 5);
      if (idx < s->var_count && var_access_count[idx] < 65535)
        var_access_count[idx]++;
    }
    pos += scan_size;
  }
  /* Count preamble-generated accesses */
  if (s->home_object_var_idx >= 0) var_access_count[s->home_object_var_idx]++;
  if (s->this_active_func_var_idx >= 0)
    var_access_count[s->this_active_func_var_idx]++;
  if (s->new_target_var_idx >= 0) var_access_count[s->new_target_var_idx]++;
  if (s->this_var_idx >= 0) var_access_count[s->this_var_idx]++;
  if (s->arguments_var_idx >= 0) var_access_count[s->arguments_var_idx]++;
  if (s->func_var_idx >= 0) var_access_count[s->func_var_idx]++;
  if (s->var_object_idx >= 0) var_access_count[s->var_object_idx] += 2;
  if (s->arg_var_object_idx >= 0) var_access_count[s->arg_var_object_idx]++;

  loc_remap = build_freq_remap(ctx, var_access_count, s->var_count);
  lepus_free(ctx, var_access_count);

  if (!loc_remap) return;

  /* Allocate all needed memory upfront to avoid inconsistent state on OOM */
  JSVarDef *new_vars = static_cast<JSVarDef *>(lepus_malloc(
      ctx, s->var_count * sizeof(JSVarDef), ALLOC_TAG_WITHOUT_PTR));
  if (!new_vars) {
    lepus_free(ctx, loc_remap);
    return;
  }
  uint8_t *remap_tmp = static_cast<uint8_t *>(
      lepus_mallocz(ctx, s->var_count, ALLOC_TAG_WITHOUT_PTR));
  if (!remap_tmp) {
    lepus_free(ctx, new_vars);
    lepus_free(ctx, loc_remap);
    return;
  }

  /* Remap tracking arrays */
  if (var_is_read) {
    for (i = 0; i < s->var_count; i++) remap_tmp[loc_remap[i]] = var_is_read[i];
    memcpy(var_is_read, remap_tmp, s->var_count);
  }
  if (loc_permanently_init) {
    memset(remap_tmp, 0, s->var_count);
    for (i = 0; i < s->var_count; i++)
      remap_tmp[loc_remap[i]] = loc_permanently_init[i];
    memcpy(loc_permanently_init, remap_tmp, s->var_count);
  }
  if (loc_perm_written) {
    memset(remap_tmp, 0, s->var_count);
    for (i = 0; i < s->var_count; i++)
      remap_tmp[loc_remap[i]] = loc_perm_written[i];
    memcpy(loc_perm_written, remap_tmp, s->var_count);
  }
  /* Remap loc_initialized (uses remap_tmp to avoid extra allocation;
     remap_tmp was pre-allocated above, ensuring atomicity with all
     other remap operations — no OOM possible at this point) */
  if (loc_initialized) {
    memset(remap_tmp, 0, s->var_count);
    for (i = 0; i < s->var_count; i++)
      remap_tmp[loc_remap[i]] = loc_initialized[i];
    memcpy(loc_initialized, remap_tmp, s->var_count);
  }
  lepus_free(ctx, remap_tmp);

  /* Physically reorder fd->vars array */
  for (i = 0; i < s->var_count; i++) {
    new_vars[loc_remap[i]] = s->vars[i];
    new_vars[loc_remap[i]].scope_next =
        (s->vars[i].scope_next >= 0) ? loc_remap[s->vars[i].scope_next] : -1;
  }
  memcpy(s->vars, new_vars, s->var_count * sizeof(JSVarDef));
  lepus_free(ctx, new_vars);
  /* Update scope.first for all scopes */
  for (i = 0; i < s->scope_count; i++) {
    if (s->scopes[i].first >= 0)
      s->scopes[i].first = loc_remap[s->scopes[i].first];
  }

  /* Update special variable indices */
#define REMAP_VAR_IDX(idx)                    \
  do {                                        \
    if ((idx) >= 0) (idx) = loc_remap[(idx)]; \
  } while (0)
  REMAP_VAR_IDX(s->home_object_var_idx);
  REMAP_VAR_IDX(s->this_active_func_var_idx);
  REMAP_VAR_IDX(s->new_target_var_idx);
  REMAP_VAR_IDX(s->this_var_idx);
  REMAP_VAR_IDX(s->arguments_var_idx);
  REMAP_VAR_IDX(s->func_var_idx);
  REMAP_VAR_IDX(s->var_object_idx);
  REMAP_VAR_IDX(s->arg_var_object_idx);
  REMAP_VAR_IDX(s->eval_ret_idx);
#undef REMAP_VAR_IDX

  /* Rewrite bc_buf operands in-place */
  uint8_t *bc_buf_w = s->byte_code.buf;
  for (pos = 0; pos < bc_len;) {
    int rewrite_op = bc_buf[pos];
    int rewrite_size = opcode_info[rewrite_op].size;
    if (rewrite_size <= 0) break;
    if (rewrite_op == OP_get_loc || rewrite_op == OP_put_loc ||
        rewrite_op == OP_set_loc || rewrite_op == OP_get_loc_check ||
        rewrite_op == OP_put_loc_check || rewrite_op == OP_put_loc_check_init ||
        rewrite_op == OP_set_loc_uninitialized || rewrite_op == OP_close_loc) {
      int old_idx = get_u16(bc_buf + pos + 1);
      if (old_idx < s->var_count)
        put_u16(bc_buf_w + pos + 1, loc_remap[old_idx]);
    }
    if (rewrite_op == OP_make_loc_ref) {
      int old_idx = get_u16(bc_buf + pos + 5);
      if (old_idx < s->var_count)
        put_u16(bc_buf_w + pos + 5, loc_remap[old_idx]);
    }
    pos += rewrite_size;
  }

  /* Update child function closure_var entries */
  for (i = 0; i < (int)s->cpool_count; i++) {
    if (LEPUS_VALUE_GET_TAG(s->cpool[i]) != LEPUS_TAG_FUNCTION_BYTECODE)
      continue;
    LEPUSFunctionBytecode *child_b =
        (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(s->cpool[i]);
    for (int j = 0; j < child_b->closure_var_count; j++) {
      LEPUSClosureVar *cv = &child_b->closure_var[j];
      if (cv->is_local && !cv->is_arg) {
        int old_idx = cv->var_idx;
        if (old_idx < s->var_count) cv->var_idx = loc_remap[old_idx];
      }
    }
  }

  lepus_free(ctx, loc_remap);
}

/* Closure variable (var_ref) index reordering: assign the lowest indices
   (shortest bytecode encoding) to the most frequently accessed closure
   variables. Index 0-3 = 1 byte, 4+ = 3 bytes. */
void opt_reorder_closure_vars(BytecodeOptCtx *opt_ctx, const uint8_t *bc_buf,
                              int bc_len) {
  LEPUSContext *ctx = opt_ctx->ctx;
  JSFunctionDef *s = opt_ctx->s;
  uint8_t *var_ref_initialized = opt_ctx->var_ref_initialized;
  int pos, i;
  int *cvr_remap = NULL;

  uint16_t *cvr_access_count = static_cast<uint16_t *>(lepus_mallocz(
      ctx, s->closure_var_count * sizeof(uint16_t), ALLOC_TAG_WITHOUT_PTR));
  if (!cvr_access_count) return;

  /* Count accesses in bytecode */
  for (pos = 0; pos < bc_len;) {
    int scan_op = bc_buf[pos];
    int scan_size = opcode_info[scan_op].size;
    if (scan_size <= 0) break;
    if (scan_op == OP_get_var_ref || scan_op == OP_put_var_ref ||
        scan_op == OP_set_var_ref || scan_op == OP_get_var_ref_check ||
        scan_op == OP_put_var_ref_check ||
        scan_op == OP_put_var_ref_check_init) {
      int idx = get_u16(bc_buf + pos + 1);
      if (idx < s->closure_var_count && cvr_access_count[idx] < 65535)
        cvr_access_count[idx]++;
    }
    if (scan_op == OP_make_var_ref_ref) {
      int idx = get_u16(bc_buf + pos + 5);
      if (idx < s->closure_var_count && cvr_access_count[idx] < 65535)
        cvr_access_count[idx]++;
    }
    pos += scan_size;
  }

  cvr_remap = build_freq_remap(ctx, cvr_access_count, s->closure_var_count);
  lepus_free(ctx, cvr_access_count);

  if (!cvr_remap) return;

  /* Allocate all needed memory upfront to avoid inconsistent state on OOM */
  LEPUSClosureVar *new_cvars = static_cast<LEPUSClosureVar *>(
      lepus_malloc(ctx, s->closure_var_count * sizeof(LEPUSClosureVar),
                   ALLOC_TAG_WITHOUT_PTR));
  if (!new_cvars) {
    lepus_free(ctx, cvr_remap);
    return;
  }
  uint8_t *cvr_remap_tmp = NULL;
  if (var_ref_initialized) {
    cvr_remap_tmp = static_cast<uint8_t *>(
        lepus_mallocz(ctx, s->closure_var_count, ALLOC_TAG_WITHOUT_PTR));
    if (!cvr_remap_tmp) {
      lepus_free(ctx, new_cvars);
      lepus_free(ctx, cvr_remap);
      return;
    }
  }

  /* Remap var_ref_initialized tracking array */
  if (var_ref_initialized && cvr_remap_tmp) {
    for (i = 0; i < s->closure_var_count; i++)
      cvr_remap_tmp[cvr_remap[i]] = var_ref_initialized[i];
    memcpy(var_ref_initialized, cvr_remap_tmp, s->closure_var_count);
    lepus_free(ctx, cvr_remap_tmp);
  }

  /* Physically reorder s->closure_var[] array */
  for (i = 0; i < s->closure_var_count; i++)
    new_cvars[cvr_remap[i]] = s->closure_var[i];
  memcpy(s->closure_var, new_cvars,
         s->closure_var_count * sizeof(LEPUSClosureVar));
  lepus_free(ctx, new_cvars);

  /* Rewrite bc_buf operands in-place */
  uint8_t *bc_buf_w = s->byte_code.buf;
  for (pos = 0; pos < bc_len;) {
    int rewrite_op = bc_buf[pos];
    int rewrite_size = opcode_info[rewrite_op].size;
    if (rewrite_size <= 0) break;
    if (rewrite_op == OP_get_var_ref || rewrite_op == OP_put_var_ref ||
        rewrite_op == OP_set_var_ref || rewrite_op == OP_get_var_ref_check ||
        rewrite_op == OP_put_var_ref_check ||
        rewrite_op == OP_put_var_ref_check_init) {
      int old_idx = get_u16(bc_buf + pos + 1);
      if (old_idx < s->closure_var_count)
        put_u16(bc_buf_w + pos + 1, cvr_remap[old_idx]);
    }
    if (rewrite_op == OP_make_var_ref_ref) {
      int old_idx = get_u16(bc_buf + pos + 5);
      if (old_idx < s->closure_var_count)
        put_u16(bc_buf_w + pos + 5, cvr_remap[old_idx]);
    }
    pos += rewrite_size;
  }

  /* Update child function closure_var entries where is_local == false */
  for (i = 0; i < (int)s->cpool_count; i++) {
    if (LEPUS_VALUE_GET_TAG(s->cpool[i]) != LEPUS_TAG_FUNCTION_BYTECODE)
      continue;
    LEPUSFunctionBytecode *child_b =
        (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(s->cpool[i]);
    for (int j = 0; j < child_b->closure_var_count; j++) {
      LEPUSClosureVar *cv = &child_b->closure_var[j];
      if (!cv->is_local) {
        int old_idx = cv->var_idx;
        if (old_idx < s->closure_var_count) cv->var_idx = cvr_remap[old_idx];
      }
    }
  }

  /* Update module import/export entries that index into closure vars */
  if (s->module) {
    for (i = 0; i < s->module->import_entries_count; i++) {
      int old_idx = s->module->import_entries[i].var_idx;
      if (old_idx < s->closure_var_count)
        s->module->import_entries[i].var_idx = cvr_remap[old_idx];
    }
    for (i = 0; i < s->module->export_entries_count; i++) {
      JSExportEntry *me = &s->module->export_entries[i];
      if (me->export_type == JS_EXPORT_TYPE_LOCAL) {
        int old_idx = me->u.local.var_idx;
        if (old_idx < s->closure_var_count)
          me->u.local.var_idx = cvr_remap[old_idx];
      }
    }
  }

  lepus_free(ctx, cvr_remap);
}

/* Constant pool index reordering: for functions with >256 cpool entries,
   move the most frequently accessed entries to indices 0-255 to enable
   push_const8 (2 bytes) instead of push_const (5 bytes). */
void opt_reorder_cpool(BytecodeOptCtx *opt_ctx, const uint8_t *bc_buf,
                       int bc_len) {
  LEPUSContext *ctx = opt_ctx->ctx;
  JSFunctionDef *s = opt_ctx->s;
  int pos, i;
  int *cpool_remap = NULL;

  uint16_t *cpool_access_count = static_cast<uint16_t *>(lepus_mallocz(
      ctx, s->cpool_count * sizeof(uint16_t), ALLOC_TAG_WITHOUT_PTR));
  if (!cpool_access_count) return;

  for (pos = 0; pos < bc_len;) {
    int scan_op = bc_buf[pos];
    int scan_size = opcode_info[scan_op].size;
    if (scan_size <= 0) break;
    if (scan_op == OP_push_const || scan_op == OP_fclosure) {
      int idx = get_u32(bc_buf + pos + 1);
      if (idx < (int)s->cpool_count && cpool_access_count[idx] < 65535)
        cpool_access_count[idx]++;
    }
    pos += scan_size;
  }

  cpool_remap = build_freq_remap(ctx, cpool_access_count, (int)s->cpool_count);
  lepus_free(ctx, cpool_access_count);

  if (cpool_remap) {
    /* Allocate new cpool upfront to avoid inconsistent state on OOM */
    LEPUSValue *new_cpool = static_cast<LEPUSValue *>(lepus_malloc(
        ctx, s->cpool_count * sizeof(LEPUSValue), ALLOC_TAG_WITHOUT_PTR));
    if (!new_cpool) {
      lepus_free(ctx, cpool_remap);
      return;
    }
    /* Physically reorder s->cpool[] */
    for (i = 0; i < (int)s->cpool_count; i++)
      new_cpool[cpool_remap[i]] = s->cpool[i];
    memcpy(s->cpool, new_cpool, s->cpool_count * sizeof(LEPUSValue));
    lepus_free(ctx, new_cpool);

    /* Rewrite bc_buf operands */
    uint8_t *bc_buf_w = s->byte_code.buf;
    for (pos = 0; pos < bc_len;) {
      int rewrite_op = bc_buf[pos];
      int rewrite_size = opcode_info[rewrite_op].size;
      if (rewrite_size <= 0) break;
      if (rewrite_op == OP_push_const || rewrite_op == OP_fclosure) {
        int old_idx = get_u32(bc_buf + pos + 1);
        if (old_idx < (int)s->cpool_count)
          put_u32(bc_buf_w + pos + 1, cpool_remap[old_idx]);
      }
      pos += rewrite_size;
    }

    lepus_free(ctx, cpool_remap);
  }
}

/* ========================================================================
 * TDZ STATE MANAGEMENT: Label State Merge
 * ========================================================================
 *
 * Called when a label is reached during bytecode emission.  Merges the
 * current initialization state (loc_initialized / var_ref_initialized) with
 * the saved states from incoming forward branches.
 *
 * For forward-only labels (all refs are forward branches):
 *   loc_initialized[i] &= label_init_state[label][i]  (intersection)
 *
 * For labels with backward edges (loops):
 *   Reset loc_initialized to 0 (conservative), but preserve vars that are
 *   permanently initialized (written once before any backward edge).
 *
 * Also frees the per-label state array after merging.
 *
 * Updates *before_first_backward_label: set to FALSE when this label has
 * backward references (i.e. it's a loop header).
 * ======================================================================== */
void opt_tdz_merge_label_state(
    BytecodeOptCtx *opt_ctx, int label, int ref_count, uint8_t *loc_initialized,
    uint8_t *var_ref_initialized, uint8_t ***label_init_state,
    uint8_t ***label_var_ref_init_state, int *label_fwd_refs, int var_count,
    int closure_var_count, BOOL *before_first_backward_label) {
  LEPUSContext *ctx = opt_ctx->ctx;

  if (loc_initialized && ref_count > 0) {
    /* Detect backward-edge labels (loops) */
    if (label_fwd_refs && label_fwd_refs[label] < ref_count)
      *before_first_backward_label = FALSE;

    if (*label_init_state && (*label_init_state)[label] && label_fwd_refs &&
        label_fwd_refs[label] == ref_count) {
      /* All refs are forward: intersect saved branch states with
         fall-through state (loc_initialized) */
      int i;
      for (i = 0; i < var_count; i++)
        loc_initialized[i] &= (*label_init_state)[label][i];
    } else {
      if (opt_ctx->loc_perm_written) {
        /* Preserve initialization for single-TDZ vars that were
           written in the initial basic block — they can never
           become uninitialized again. */
        int i;
        for (i = 0; i < var_count; i++) {
          if (!opt_ctx->loc_perm_written[i]) loc_initialized[i] = 0;
        }
      } else {
        memset(loc_initialized, 0, var_count);
      }
    }
  }
  if (loc_initialized && *label_init_state && (*label_init_state)[label]) {
    lepus_free(ctx, (*label_init_state)[label]);
    (*label_init_state)[label] = NULL;
  }

  /* Closure var tracking: same intersection logic */
  if (var_ref_initialized && ref_count > 0) {
    if (*label_var_ref_init_state && (*label_var_ref_init_state)[label] &&
        label_fwd_refs && label_fwd_refs[label] == ref_count) {
      int i;
      for (i = 0; i < closure_var_count; i++)
        var_ref_initialized[i] &= (*label_var_ref_init_state)[label][i];
    } else {
      memset(var_ref_initialized, 0, closure_var_count);
    }
  }
  if (var_ref_initialized && *label_var_ref_init_state &&
      (*label_var_ref_init_state)[label]) {
    lepus_free(ctx, (*label_var_ref_init_state)[label]);
    (*label_var_ref_init_state)[label] = NULL;
  }
}

/* ========================================================================
 * TDZ STATE MANAGEMENT: Branch State Save
 * ========================================================================
 *
 * Called when a forward branch is emitted (goto/if_true/if_false to a
 * label that hasn't been reached yet, i.e. ls->addr == -1).
 *
 * Saves the current loc_initialized / var_ref_initialized state into
 * label_init_state[label] so that when the label is later reached, we can
 * intersect all incoming branch states.
 *
 * First forward branch: copy current state into newly allocated array.
 * Subsequent forward branches: intersect (AND) current state with saved.
 *
 * Also increments label_fwd_refs[label] to track the count of forward
 * references (used to detect whether all refs are forward-only).
 * ======================================================================== */
void opt_tdz_save_branch_state(BytecodeOptCtx *opt_ctx, int label,
                               uint8_t *loc_initialized,
                               uint8_t *var_ref_initialized,
                               uint8_t ***label_init_state,
                               uint8_t ***label_var_ref_init_state,
                               int *label_fwd_refs, int var_count,
                               int closure_var_count) {
  LEPUSContext *ctx = opt_ctx->ctx;

  if (loc_initialized && *label_init_state) {
    label_fwd_refs[label]++;
    if ((*label_init_state)[label] == NULL) {
      (*label_init_state)[label] = static_cast<uint8_t *>(
          lepus_mallocz(ctx, var_count, ALLOC_TAG_WITHOUT_PTR));
      if ((*label_init_state)[label])
        memcpy((*label_init_state)[label], loc_initialized, var_count);
    } else {
      int i;
      for (i = 0; i < var_count; i++)
        (*label_init_state)[label][i] &= loc_initialized[i];
    }
  }

  if (var_ref_initialized && *label_var_ref_init_state) {
    if (!loc_initialized) label_fwd_refs[label]++;
    if ((*label_var_ref_init_state)[label] == NULL) {
      (*label_var_ref_init_state)[label] = static_cast<uint8_t *>(
          lepus_mallocz(ctx, closure_var_count, ALLOC_TAG_WITHOUT_PTR));
      if ((*label_var_ref_init_state)[label])
        memcpy((*label_var_ref_init_state)[label], var_ref_initialized,
               closure_var_count);
    } else {
      int i;
      for (i = 0; i < closure_var_count; i++)
        (*label_var_ref_init_state)[label][i] &= var_ref_initialized[i];
    }
  }
}

/* ========================================================================
 * PREAMBLE OPTIMIZATION: this-variable emit
 * ========================================================================
 *
 * Pattern:
 *   push_this
 *   put_loc(this_var)          # preamble: store 'this' into local var
 *   ... (line_num / other SLU instructions)
 *   get_loc(this_var)          # first real instruction reads 'this' back
 *
 *   ===> becomes:
 *
 *   push_this
 *   set_loc(this_var)          # preamble: store + keep value on stack
 *   ... (line_num / other SLU instructions)
 *   [skipped: get_loc(this_var)]  # redundant load eliminated
 *
 * Why: many non-derived-class constructors and methods begin with a
 * get_loc(this_var) to access `this`.  The preamble's put_loc stores the
 * value into the local and pops it from the stack; the subsequent get_loc
 * pushes it right back.  Replacing put_loc with set_loc keeps the value on
 * the stack, allowing the first get_loc to be skipped entirely.  This saves
 * 1-3 bytes (size of get_loc encoding) per function plus a runtime load.
 *
 * Implementation: scans forward from bc_buf[0], skipping OP_line_num and
 * set_loc_uninitialized for OTHER variables (not this_var), to find the
 * first "real" instruction.  If it is get_loc(this_var) or
 * get_loc_check(this_var), emits set_loc instead of put_loc and returns
 * the position of that get_loc so the caller's main emission loop can
 * skip it.  Otherwise emits put_loc and returns -1 (no skip needed).
 *
 * Only called when LEPUSNG_OPT_ENABLED() is true.
 */

/* Local helper: emit a short-form put_loc/set_loc opcode, mirroring
   put_short_code in quickjs.cc (which is static and not accessible here).
   Only supports the two ops needed by the preamble optimization. */
static void opt_put_short_loc(DynBuf *bc_out, int op, int idx) {
#if SHORT_OPCODES
  if (idx < 4) {
    if (op == OP_put_loc) {
      dbuf_putc(bc_out, OP_put_loc0 + idx);
      return;
    }
    if (op == OP_set_loc) {
      dbuf_putc(bc_out, OP_set_loc0 + idx);
      return;
    }
  }
  if (idx < 256) {
    if (op == OP_put_loc) {
      dbuf_putc(bc_out, OP_put_loc8);
      dbuf_putc(bc_out, idx);
      return;
    }
    if (op == OP_set_loc) {
      dbuf_putc(bc_out, OP_set_loc8);
      dbuf_putc(bc_out, idx);
      return;
    }
  }
#endif
  dbuf_putc(bc_out, op);
  dbuf_put_u16(bc_out, idx);
}

int opt_preamble_emit_this(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out,
                           const uint8_t *bc_buf, int bc_len) {
  (void)ctx;
  /* Peek past line_num and set_loc_uninitialized (for OTHER vars) to find
     the first real instruction. */
  int peek = 0;
  while (peek + 1 < bc_len) {
    if (bc_buf[peek] == OP_line_num &&
        peek + (int)opcode_info[OP_line_num].size <= bc_len) {
      peek += opcode_info[OP_line_num].size;
    } else if (bc_buf[peek] == OP_set_loc_uninitialized && peek + 3 <= bc_len &&
               get_u16(bc_buf + peek + 1) != (uint16_t)s->this_var_idx) {
      peek += opcode_info[OP_set_loc_uninitialized].size;
    } else {
      break;
    }
  }
  if (peek + 3 <= bc_len &&
      (bc_buf[peek] == OP_get_loc || bc_buf[peek] == OP_get_loc_check) &&
      get_u16(bc_buf + peek + 1) == (uint16_t)s->this_var_idx) {
    opt_put_short_loc(bc_out, OP_set_loc, s->this_var_idx);
    return peek;
  }
  opt_put_short_loc(bc_out, OP_put_loc, s->this_var_idx);
  return -1;
}

/* ========================================================================
 * CONSTANT FOLDING HELPERS (pure computation)
 * ======================================================================== */

/* Binary integer constant folding.
   Pattern: const_left + const_right + binary_op → const_result
   Returns TRUE if foldable, with result in *out_result.
   Handles overflow, div-by-zero, and JS-specific edge cases. */
BOOL opt_const_fold_try_binary(int op, int32_t left, int32_t right,
                               int32_t *out_result) {
  int32_t result = 0;
  BOOL folded = TRUE;
  switch (op) {
    case OP_add: {
      int64_t r = (int64_t)left + (int64_t)right;
      if (r != (int32_t)r) {
        folded = FALSE;
        break;
      }
      result = (int32_t)r;
      break;
    }
    case OP_sub: {
      int64_t r = (int64_t)left - (int64_t)right;
      if (r != (int32_t)r) {
        folded = FALSE;
        break;
      }
      result = (int32_t)r;
      break;
    }
    case OP_mul: {
      int64_t r = (int64_t)left * (int64_t)right;
      if (r != (int32_t)r) {
        folded = FALSE;
        break;
      }
      /* -0 case: 0 * negative or negative * 0 produces -0 in JS */
      if (r == 0 && (left < 0 || right < 0)) {
        folded = FALSE;
        break;
      }
      result = (int32_t)r;
      break;
    }
    case OP_div:
      if (right == 0) {
        folded = FALSE;
        break;
      }
      if (left == INT32_MIN && right == -1) {
        folded = FALSE;
        break;
      }
      if (left % right != 0) {
        folded = FALSE;
        break;
      }
      if (left == 0 && right < 0) {
        folded = FALSE;
        break;
      }
      result = left / right;
      break;
    case OP_mod:
      if (right == 0) {
        folded = FALSE;
        break;
      }
      if (left == INT32_MIN && right == -1) {
        folded = FALSE;
        break;
      }
      {
        int32_t mod_result = left % right;
        if (mod_result == 0 && left < 0) {
          folded = FALSE;
          break;
        }
        result = mod_result;
      }
      break;
    case OP_and:
      result = left & right;
      break;
    case OP_or:
      result = left | right;
      break;
    case OP_xor:
      result = left ^ right;
      break;
    case OP_shl: {
      uint32_t r = (uint32_t)left << (right & 31);
      result = (int32_t)r;
      break;
    }
    case OP_sar:
      result = int32_arithmetic_shift_right(left, right);
      break;
    case OP_shr: {
      uint32_t r = (uint32_t)left >> (right & 31);
      if (r > INT32_MAX) {
        folded = FALSE;
        break;
      }
      result = (int32_t)r;
      break;
    }
    default:
      folded = FALSE;
      break;
  }
  if (folded) *out_result = result;
  return folded;
}

/* Comparison constant folding.
   Pattern: const_left + const_right + compare_op → boolean result
   Returns TRUE if foldable, with 0/1 result in *out_result.
   Guard: strict equality with boolean operand cannot be folded
   because true === 1 is false in JS (no type coercion). */
BOOL opt_const_fold_try_compare(int op, int32_t left, int32_t right,
                                int is_bool1, int is_bool2,
                                int32_t *out_result) {
  if ((op == OP_strict_eq || op == OP_strict_neq) && (is_bool1 || is_bool2)) {
    return FALSE;
  }
  BOOL cmp_result;
  switch (op) {
    case OP_lt:
      cmp_result = (left < right);
      break;
    case OP_lte:
      cmp_result = (left <= right);
      break;
    case OP_gt:
      cmp_result = (left > right);
      break;
    case OP_gte:
      cmp_result = (left >= right);
      break;
    case OP_eq:
    case OP_strict_eq:
      cmp_result = (left == right);
      break;
    case OP_neq:
    case OP_strict_neq:
      cmp_result = (left != right);
      break;
    default:
      return FALSE;
  }
  *out_result = cmp_result ? 1 : 0;
  return TRUE;
}

/* Unary integer constant folding.
   Pattern: const_val + unary_op → const_result
   Returns TRUE if foldable, with result in *out_result.
   OP_neg: fails for INT32_MIN (overflow) and 0 (-0 is float)
   OP_not: always foldable (bitwise complement) */
BOOL opt_const_fold_try_unary(int op, int32_t val, int32_t *out_result) {
  switch (op) {
    case OP_neg:
      if (val == INT32_MIN || val == 0) /* -INT32_MIN overflows; -0 is float */
        return FALSE;
      *out_result = -val;
      return TRUE;
    case OP_not:
      *out_result = ~val;
      return TRUE;
    default:
      return FALSE;
  }
}

/* Update the two-slot constant fold tracker after one instruction is emitted.
   Scans the instruction starting at cf_emit_start in bc_out_buf. If it's a
   constant integer push, shift into the tracker (pos1 = old pos2, pos2 = new
   push). Otherwise reset both slots to -1 (unknown value on stack). Does
   nothing when cf_emitted_size <= 0 (instruction was fully eliminated). */
void opt_const_fold_update_tracker(const uint8_t *bc_out_buf, int cf_emit_start,
                                   int cf_emitted_size, int *cf_pos1,
                                   int *cf_pos2, int32_t *cf_val1,
                                   int32_t *cf_val2, int *cf_is_bool1,
                                   int *cf_is_bool2) {
  if (cf_emitted_size <= 0)
    return; /* instruction eliminated: keep tracker unchanged */

  uint8_t cf_op = bc_out_buf[cf_emit_start];
  BOOL is_const_push = FALSE;
  int is_bool = 0;
  int32_t cf_val = 0;

#if SHORT_OPCODES
  if (cf_op >= OP_push_minus1 && cf_op <= OP_push_7) {
    is_const_push = TRUE;
    cf_val = cf_op - OP_push_0;
  } else if (cf_op == OP_push_i8 && cf_emitted_size >= 2) {
    is_const_push = TRUE;
    cf_val = (int8_t)bc_out_buf[cf_emit_start + 1];
  } else if (cf_op == OP_push_i16 && cf_emitted_size >= 3) {
    is_const_push = TRUE;
    cf_val = (int16_t)get_u16(bc_out_buf + cf_emit_start + 1);
  } else
#endif
      if (cf_op == OP_push_i32 && cf_emitted_size >= 5) {
    is_const_push = TRUE;
    cf_val = (int32_t)get_u32(bc_out_buf + cf_emit_start + 1);
  } else if (cf_op == OP_push_true) {
    is_const_push = TRUE;
    cf_val = 1;
    is_bool = 1;
  } else if (cf_op == OP_push_false) {
    is_const_push = TRUE;
    cf_val = 0;
    is_bool = 1;
  }

  if (is_const_push) {
    *cf_pos1 = *cf_pos2;
    *cf_val1 = *cf_val2;
    *cf_is_bool1 = *cf_is_bool2;
    *cf_pos2 = cf_emit_start;
    *cf_val2 = cf_val;
    *cf_is_bool2 = is_bool;
  } else {
    *cf_pos1 = -1;
    *cf_pos2 = -1;
  }
}

/* Downgrade closure var_ref_check opcodes in a child function's bytecode
   when the parent's backing local is already initialized.
   For each closure variable that is a local (not arg) lexical variable
   and whose parent local is already initialized, replace:
     get_var_ref_check(n) → get_var_ref(n)
     put_var_ref_check(n) → put_var_ref(n)
   Safe because the variable is guaranteed to be initialized, so no
   TDZ check is needed when accessing it through the closure. */
void opt_downgrade_closure_var_ref_check(JSFunctionDef *parent_s,
                                         LEPUSFunctionBytecode *child_b,
                                         const uint8_t *loc_initialized) {
  if (child_b->read_only_bytecode) return;
  for (int ci = 0; ci < child_b->closure_var_count; ci++) {
    LEPUSClosureVar *cv = &child_b->closure_var[ci];
    if (!cv->is_local || cv->is_arg || !cv->is_lexical) continue;
    if (cv->var_idx >= parent_s->var_count) continue;
    if (!loc_initialized[cv->var_idx]) continue;
    uint8_t *cb = child_b->byte_code_buf;
    int cb_len = child_b->byte_code_len;
    for (int cp = 0; cp < cb_len;) {
      int cop = cb[cp];
      int csz = short_opcode_info(cop).size;
      if (csz <= 0) break;
      if (cop == OP_get_var_ref_check && cp + 2 < cb_len &&
          get_u16(cb + cp + 1) == (uint16_t)ci) {
        cb[cp] = OP_get_var_ref;
      } else if (cop == OP_put_var_ref_check && cp + 2 < cb_len &&
                 get_u16(cb + cp + 1) == (uint16_t)ci) {
        cb[cp] = OP_put_var_ref;
      }
      cp += csz;
    }
  }
}

/* ========================================================================
 * POST-PASS: Dead SLU Elimination (opt_dead_slu_elim)
 * ========================================================================
 *
 * During the main emission loop, every set_loc_uninitialized instruction is
 * recorded in an SLURecord array. After TDZ downgrade eliminates all
 * get_loc_check/put_loc_check for a variable, the corresponding SLU becomes
 * dead (no runtime TDZ enforcement needed). This pass NOPs those dead SLUs.
 */
/* Post-pass: eliminate dead set_loc_uninitialized instructions.
   A SLU is dead if no get_loc_check/put_loc_check for that variable remains
   in bc_out (meaning all TDZ checks were successfully downgraded). */
void opt_dead_slu_elim(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out,
                       const SLURecord *slu_records, int slu_pos_count) {
  if (slu_pos_count <= 0 || s->var_count <= 0) return;
  uint8_t *var_still_has_check = static_cast<uint8_t *>(
      lepus_mallocz(ctx, s->var_count, ALLOC_TAG_WITHOUT_PTR));
  if (!var_still_has_check) return;
  /* Scan bc_out for remaining get_loc_check or put_loc_check */
  for (int p = 0; p < (int)bc_out->size;) {
    int scan_op = bc_out->buf[p];
    int scan_sz = short_opcode_info(scan_op).size;
    if (scan_sz <= 0) break;
    if (scan_op == OP_get_loc_check || scan_op == OP_put_loc_check ||
        scan_op == OP_put_loc_check_init) {
      int vidx = get_u16(bc_out->buf + p + 1);
      if (vidx < s->var_count) var_still_has_check[vidx] = 1;
    }
    p += scan_sz;
  }
  /* Patch dead SLUs to nops */
  for (int si = 0; si < slu_pos_count; si++) {
    int slu_var = slu_records[si].var_idx;
    int slu_pos = slu_records[si].bc_out_pos;
    if (slu_var < s->var_count && !var_still_has_check[slu_var] &&
        !s->vars[slu_var].is_captured) {
      bc_out->buf[slu_pos] = OP_nop;
      bc_out->buf[slu_pos + 1] = OP_nop;
      bc_out->buf[slu_pos + 2] = OP_nop;
    }
  }
  lepus_free(ctx, var_still_has_check);
}

/* ========================================================================
 * POST-PASS: Post-pass Peephole (opt_post_peephole)
 * ========================================================================
 *
 * Applies peephole patterns on the final bc_out that the main emission loop
 * cannot catch because:
 * - They span label boundaries (the main loop resets state at labels)
 * - They are created by SLU elimination (SLU→NOP creates new patterns)
 * - They require knowledge of jump targets (branch inversion)
 *
 * Patterns include:
 * - put_loc(n) + get_loc(n) → set_loc(n) (across nops)
 * - Result-unused drop elimination for pure operations
 * - Goto-to-return/throw chain following (up to 10 hops)
 * - Branch inversion: if_xxx(skip) + goto(L) → if_inv(L) + nops
 * - Nullish/short-circuit result-unused patterns
 */
/* Post-pass peephole: optimize patterns in bc_out that the main loop
   couldn't catch (broken by labels or created by SLU elimination).
   Includes: short-range peephole patterns, result-unused drop elimination,
   goto-to-return/throw chain following, and branch inversion. */
void opt_post_peephole(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out) {
  LabelSlot *label_slots = s->label_slots;
  /* Post-pass peephole: optimize patterns in bc_out that the main loop
     couldn't catch (broken by labels or created by SLU elimination).
     Transforms are NOP-padded; the NOP strip below handles compaction. */
  if (OPTIMIZE && bc_out->size > 0) {
    /* Build bitmap of live label target addresses */
    uint8_t *is_label_target = static_cast<uint8_t *>(
        lepus_mallocz(ctx, bc_out->size, ALLOC_TAG_WITHOUT_PTR));
    if (is_label_target) {
      for (int j = 0; j < s->label_count; j++) {
        if (label_slots[j].ref_count > 0 && label_slots[j].addr >= 0 &&
            label_slots[j].addr < (int)bc_out->size)
          is_label_target[label_slots[j].addr] = 1;
      }

      for (int p = 0; p < (int)bc_out->size;) {
        int scan_op = bc_out->buf[p];
        int sz = short_opcode_info(scan_op).size;
        if (sz <= 0) break;
        int next_p = p + sz;

        /* nr: next non-NOP instruction position (skip NOP gaps) */
        int nr = next_p;
        while (nr < (int)bc_out->size && bc_out->buf[nr] == OP_nop &&
               !is_label_target[nr])
          nr++;

        /* Pattern 1: put_loc8(n) get_loc8(n) → set_loc8(n) + nop nop */
        if (scan_op == OP_put_loc8 && nr + 2 <= (int)bc_out->size &&
            bc_out->buf[nr] == OP_get_loc8 &&
            bc_out->buf[p + 1] == bc_out->buf[nr + 1] && !is_label_target[nr]) {
          bc_out->buf[p] = OP_set_loc8;
          bc_out->buf[nr] = OP_nop;
          bc_out->buf[nr + 1] = OP_nop;
          /* Don't advance p — cascade with set_loc8+get_loc8→dup (pattern 12)
           */
          continue;
        }

        /* Pattern 2: put_loc0..3 get_loc0..3 (same idx) → set_loc0..3 + nop */
        if (scan_op >= OP_put_loc0 && scan_op <= OP_put_loc3 &&
            nr < (int)bc_out->size &&
            bc_out->buf[nr] ==
                (uint8_t)(OP_get_loc0 + (scan_op - OP_put_loc0)) &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_set_loc0 + (scan_op - OP_put_loc0);
          bc_out->buf[nr] = OP_nop;
          /* Don't advance p — cascade with set_loc0..3+get_loc0..3→dup (14b) */
          continue;
        }

        /* Pattern 2b: put_arg0..3 get_arg0..3 (same idx) → set_arg0..3 + nop */
        if (scan_op >= OP_put_arg0 && scan_op <= OP_put_arg3 &&
            nr < (int)bc_out->size &&
            bc_out->buf[nr] ==
                (uint8_t)(OP_get_arg0 + (scan_op - OP_put_arg0)) &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_set_arg0 + (scan_op - OP_put_arg0);
          bc_out->buf[nr] = OP_nop;
          /* Don't advance p — cascade with set_arg0..3+get_arg0..3→dup (14c) */
          continue;
        }

        /* Pattern 3: get_loc8(n) drop → nop nop nop */
        if (scan_op == OP_get_loc8 && nr < (int)bc_out->size &&
            bc_out->buf[nr] == OP_drop && !is_label_target[p] &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[p + 1] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 4: get_loc0..3 drop → nop nop */
        if (scan_op >= OP_get_loc0 && scan_op <= OP_get_loc3 &&
            nr < (int)bc_out->size && bc_out->buf[nr] == OP_drop &&
            !is_label_target[p] && !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 4b: get_arg0..3 drop → nop nop */
        if (scan_op >= OP_get_arg0 && scan_op <= OP_get_arg3 &&
            nr < (int)bc_out->size && bc_out->buf[nr] == OP_drop &&
            !is_label_target[p] && !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 4c: get_var_ref0..3 drop → nop nop */
        if (scan_op >= OP_get_var_ref0 && scan_op <= OP_get_var_ref3 &&
            nr < (int)bc_out->size && bc_out->buf[nr] == OP_drop &&
            !is_label_target[p] && !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 5: set_loc8(n) drop → put_loc8(n) + nop */
        if (scan_op == OP_set_loc8 && nr < (int)bc_out->size &&
            bc_out->buf[nr] == OP_drop && !is_label_target[nr]) {
          bc_out->buf[p] = OP_put_loc8;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 6: set_loc0..3 drop → put_loc0..3 + nop */
        if (scan_op >= OP_set_loc0 && scan_op <= OP_set_loc3 &&
            nr < (int)bc_out->size && bc_out->buf[nr] == OP_drop &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_put_loc0 + (scan_op - OP_set_loc0);
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 6b: set_arg0..3 drop → put_arg0..3 + nop */
        if (scan_op >= OP_set_arg0 && scan_op <= OP_set_arg3 &&
            nr < (int)bc_out->size && bc_out->buf[nr] == OP_drop &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_put_arg0 + (scan_op - OP_set_arg0);
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 6c: set_var_ref0..3 drop → put_var_ref0..3 + nop */
        if (scan_op >= OP_set_var_ref0 && scan_op <= OP_set_var_ref3 &&
            nr < (int)bc_out->size && bc_out->buf[nr] == OP_drop &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_put_var_ref0 + (scan_op - OP_set_var_ref0);
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 7: push_i8(v) drop → nop nop nop */
        if (scan_op == OP_push_i8 && nr < (int)bc_out->size &&
            bc_out->buf[nr] == OP_drop && !is_label_target[p] &&
            !is_label_target[p + 1] && !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[p + 1] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 8: 1-byte side-effect-free push + drop → nop nop */
        if (nr < (int)bc_out->size && bc_out->buf[nr] == OP_drop &&
            !is_label_target[p] && !is_label_target[nr] && sz == 1 &&
            ((scan_op >= OP_push_minus1 && scan_op <= OP_push_7) ||
             scan_op == OP_undefined || scan_op == OP_null ||
             scan_op == OP_push_true || scan_op == OP_push_false ||
             scan_op == OP_push_empty_string)) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 10: dup put_loc0..3 → set_loc0..3 */
        if (scan_op == OP_dup && nr < (int)bc_out->size &&
            bc_out->buf[nr] >= OP_put_loc0 && bc_out->buf[nr] <= OP_put_loc3 &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_set_loc0 + (bc_out->buf[nr] - OP_put_loc0);
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 10b: dup put_arg0..3 → set_arg0..3 */
        if (scan_op == OP_dup && nr < (int)bc_out->size &&
            bc_out->buf[nr] >= OP_put_arg0 && bc_out->buf[nr] <= OP_put_arg3 &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_set_arg0 + (bc_out->buf[nr] - OP_put_arg0);
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 10c: dup put_var_ref0..3 → set_var_ref0..3 */
        if (scan_op == OP_dup && nr < (int)bc_out->size &&
            bc_out->buf[nr] >= OP_put_var_ref0 &&
            bc_out->buf[nr] <= OP_put_var_ref3 && !is_label_target[nr]) {
          bc_out->buf[p] =
              OP_set_var_ref0 + (bc_out->buf[nr] - OP_put_var_ref0);
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern: dup get_field(a) → get_field2(a) + nop
           get_field2 is defined as: obj → obj value (same as dup + get_field)
         */
        if (scan_op == OP_dup && nr + 5 <= (int)bc_out->size &&
            bc_out->buf[nr] == OP_get_field && !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[nr] = OP_get_field2;
          p = nr + 5;
          continue;
        }

        /* Pattern 11: get_loc8(n) get_loc8(n) → get_loc8(n) dup + nop */
        if (scan_op == OP_get_loc8 && nr + 2 <= (int)bc_out->size &&
            bc_out->buf[nr] == OP_get_loc8 &&
            bc_out->buf[p + 1] == bc_out->buf[nr + 1] && !is_label_target[nr]) {
          bc_out->buf[nr] = OP_dup;
          bc_out->buf[nr + 1] = OP_nop;
          p = nr + 2;
          continue;
        }

        /* Pattern 12: set_loc8(n) get_loc8(n) → set_loc8(n) dup + nop */
        if (scan_op == OP_set_loc8 && nr + 2 <= (int)bc_out->size &&
            bc_out->buf[nr] == OP_get_loc8 &&
            bc_out->buf[p + 1] == bc_out->buf[nr + 1] && !is_label_target[nr]) {
          bc_out->buf[nr] = OP_dup;
          bc_out->buf[nr + 1] = OP_nop;
          p = nr + 2;
          continue;
        }

        /* Pattern 14: put_var_ref0..3 get_var_ref0..3 (same) → set_var_ref0..3
         * + nop */
        if (scan_op >= OP_put_var_ref0 && scan_op <= OP_put_var_ref3 &&
            nr < (int)bc_out->size &&
            bc_out->buf[nr] ==
                (uint8_t)(OP_get_var_ref0 + (scan_op - OP_put_var_ref0)) &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_set_var_ref0 + (scan_op - OP_put_var_ref0);
          bc_out->buf[nr] = OP_nop;
          /* Don't advance p — cascade with set+get→dup pattern below */
          continue;
        }

        /* Pattern 14b: set_loc0..3 get_loc0..3 (same) → set_loc0..3 dup + nop
         */
        if (scan_op >= OP_set_loc0 && scan_op <= OP_set_loc3 &&
            nr < (int)bc_out->size &&
            bc_out->buf[nr] ==
                (uint8_t)(OP_get_loc0 + (scan_op - OP_set_loc0)) &&
            !is_label_target[nr]) {
          bc_out->buf[nr] = OP_dup;
          p = nr + 1;
          continue;
        }

        /* Pattern 14c: set_arg0..3 get_arg0..3 (same) → set_arg0..3 dup + nop
         */
        if (scan_op >= OP_set_arg0 && scan_op <= OP_set_arg3 &&
            nr < (int)bc_out->size &&
            bc_out->buf[nr] ==
                (uint8_t)(OP_get_arg0 + (scan_op - OP_set_arg0)) &&
            !is_label_target[nr]) {
          bc_out->buf[nr] = OP_dup;
          p = nr + 1;
          continue;
        }

        /* Pattern 14d: set_var_ref0..3 get_var_ref0..3 (same) → set_var_ref0..3
         * dup + nop */
        if (scan_op >= OP_set_var_ref0 && scan_op <= OP_set_var_ref3 &&
            nr < (int)bc_out->size &&
            bc_out->buf[nr] ==
                (uint8_t)(OP_get_var_ref0 + (scan_op - OP_set_var_ref0)) &&
            !is_label_target[nr]) {
          bc_out->buf[nr] = OP_dup;
          p = nr + 1;
          continue;
        }

        /* Pattern 15: get_arg0..3 drop → nop nop */
        if (scan_op >= OP_get_arg0 && scan_op <= OP_get_arg3 &&
            nr < (int)bc_out->size && bc_out->buf[nr] == OP_drop &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 16: get_var_ref0..3 drop → nop nop */
        if (scan_op >= OP_get_var_ref0 && scan_op <= OP_get_var_ref3 &&
            nr < (int)bc_out->size && bc_out->buf[nr] == OP_drop &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 20c: dup put_loc8(n) → set_loc8(n) + nop
           Note: when nr == p+1 (no NOP gap), buf[nr] aliases buf[p+1],
           so we must save loc_idx before overwriting. */
        if (scan_op == OP_dup && nr + 2 <= (int)bc_out->size &&
            bc_out->buf[nr] == OP_put_loc8 && !is_label_target[nr]) {
          uint8_t loc_idx = bc_out->buf[nr + 1];
          bc_out->buf[p] = OP_set_loc8;
          bc_out->buf[p + 1] = loc_idx;
          if (nr > p + 1) bc_out->buf[nr] = OP_nop;
          bc_out->buf[nr + 1] = OP_nop;
          /* Don't advance p — allow cascading with set+get patterns */
          continue;
        }

        /* Pattern 21: push_const8(n) drop → nop nop nop */
        if (scan_op == OP_push_const8 && nr < (int)bc_out->size &&
            bc_out->buf[nr] == OP_drop && !is_label_target[p + 1] &&
            !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[p + 1] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 22: push_i16(v) drop → nop nop nop nop */
        if (scan_op == OP_push_i16 && nr < (int)bc_out->size &&
            bc_out->buf[nr] == OP_drop && !is_label_target[p + 1] &&
            !is_label_target[p + 2] && !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[p + 1] = OP_nop;
          bc_out->buf[p + 2] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 23: dup drop → nop nop (identity operation) */
        if (scan_op == OP_dup && nr < (int)bc_out->size &&
            bc_out->buf[nr] == OP_drop && !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 24: swap swap → nop nop (identity operation) */
        if (scan_op == OP_swap && nr < (int)bc_out->size &&
            bc_out->buf[nr] == OP_swap && !is_label_target[nr]) {
          bc_out->buf[p] = OP_nop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 25: swap nip → drop + nop
           a b → swap → b a → nip(free sp[-2]=b, keep a) → a
           same as: a b → drop(free b) → a */
        if (scan_op == OP_swap && nr < (int)bc_out->size &&
            bc_out->buf[nr] == OP_nip && !is_label_target[nr]) {
          bc_out->buf[p] = OP_drop;
          bc_out->buf[nr] = OP_nop;
          p = nr + 1;
          continue;
        }

        /* Pattern 28: undefined return → return_undef + nop */
        if (scan_op == OP_undefined) {
          if (nr < (int)bc_out->size && bc_out->buf[nr] == OP_return &&
              !is_label_target[nr]) {
            bc_out->buf[p] = OP_return_undef;
            bc_out->buf[nr] = OP_nop;
            p = nr + 1;
            continue;
          }
          /* Pattern 30: undefined strict_eq → is_undefined + nop */
          if (nr < (int)bc_out->size && bc_out->buf[nr] == OP_strict_eq &&
              !is_label_target[nr]) {
            bc_out->buf[p] = OP_is_undefined;
            bc_out->buf[nr] = OP_nop;
            p = nr + 1;
            continue;
          }
        }

        /* Pattern 29: null strict_eq → is_null + nop */
        if (scan_op == OP_null) {
          if (nr < (int)bc_out->size && bc_out->buf[nr] == OP_strict_eq &&
              !is_label_target[nr]) {
            bc_out->buf[p] = OP_is_null;
            bc_out->buf[nr] = OP_nop;
            p = nr + 1;
            continue;
          }
        }

        p = next_p;
      }
      lepus_free(ctx, is_label_target);
    }
  }
}

/* ========================================================================
 * POST-PASS: Dead Value Elimination (opt_dead_value_elim)
 * ========================================================================
 *
 * When ALL jumps to a label L (where L: drop) match one of these patterns,
 * we can eliminate dead value production and move L past the drop:
 * Pattern A: dup if_false/if_true(L) drop — short-circuit result unused
 *   → NOP dup and post-conditional drop (saves 2 bytes per jump)
 * Pattern B: <const/pure-read> goto/goto8/goto16(L) — dead value before goto
 *   → NOP the value-producing instruction (saves 1-5 bytes per goto)
 * Pattern A keeps drop@L, Pattern B also keeps drop@L (both are compatible).
 * For Pattern B we need to verify the fall-through to L is safe (terminated).
 */
void opt_dead_value_elim(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out) {
  LabelSlot *label_slots = s->label_slots;
  if (OPTIMIZE && bc_out->size > 0) {
    uint8_t *is_lt = static_cast<uint8_t *>(
        lepus_mallocz(ctx, bc_out->size, ALLOC_TAG_WITHOUT_PTR));
    uint8_t *is_istart = static_cast<uint8_t *>(
        lepus_mallocz(ctx, bc_out->size, ALLOC_TAG_WITHOUT_PTR));
    if (is_lt && is_istart) {
      for (int j = 0; j < s->label_count; j++) {
        if (label_slots[j].ref_count > 0 && label_slots[j].addr >= 0 &&
            label_slots[j].addr < (int)bc_out->size)
          is_lt[label_slots[j].addr] = 1;
      }
      /* Build instruction-start bitmap */
      for (int p = 0; p < (int)bc_out->size;) {
        is_istart[p] = 1;
        int sz = short_opcode_info(bc_out->buf[p]).size;
        if (sz <= 0) break;
        p += sz;
      }

      for (int lbl = 0; lbl < s->label_count; lbl++) {
        int L = label_slots[lbl].addr;
        if (L < 0 || L >= (int)bc_out->size) continue;
        if (L + 1 > (int)bc_out->size) continue;
        if (bc_out->buf[L] != OP_drop) continue;
        if (label_slots[lbl].ref_count <= 0) continue;

        /* Check that ALL jump_slots targeting this label match A or B */
        int all_match = 1;
        int match_count = 0;
        for (int j = 0; j < s->jump_count; j++) {
          JumpSlot *jp = &s->jump_slots[j];
          if (jp->label != lbl || jp->size == 0) continue;

          if (jp->op == OP_if_false8 || jp->op == OP_if_true8 ||
              jp->op == OP_if_false || jp->op == OP_if_true) {
            /* Pattern A: dup if_x(L) drop */
            int if_pos = jp->pos - 1;
            if (if_pos < 1) {
              all_match = 0;
              break;
            }
            int dup_pos = -1;
            for (int k = if_pos - 1; k >= 0; k--) {
              if (!is_istart[k]) continue;
              if (bc_out->buf[k] == OP_nop && !is_lt[k]) continue;
              if (bc_out->buf[k] == OP_dup) dup_pos = k;
              break;
            }
            if (dup_pos < 0) {
              all_match = 0;
              break;
            }
            int drop_pos = -1;
            for (int k = jp->pos + jp->size; k < (int)bc_out->size; k++) {
              if (bc_out->buf[k] == OP_nop && !is_lt[k]) continue;
              if (bc_out->buf[k] == OP_drop && !is_lt[k]) drop_pos = k;
              break;
            }
            if (drop_pos < 0) {
              all_match = 0;
              break;
            }
          } else if (jp->op == OP_goto8 || jp->op == OP_goto16 ||
                     jp->op == OP_goto) {
            /* Pattern B: find value-producing instruction before goto */
            int goto_pos = jp->pos - 1;
            if (goto_pos < 1) {
              all_match = 0;
              break;
            }
            int found = 0;
            for (int k = goto_pos - 1; k >= 0; k--) {
              if (!is_istart[k]) continue;
              if (bc_out->buf[k] == OP_nop && !is_lt[k]) continue;
              uint8_t op_at = bc_out->buf[k];
              int op_sz = short_opcode_info(op_at).size;
              if (op_sz <= 0) break;
              int end_pos = k + op_sz;
              /* Verify instruction ends at goto (possibly with nops between) */
              int valid_end = 1;
              for (int m = end_pos; m < goto_pos; m++) {
                if (bc_out->buf[m] != OP_nop || is_lt[m]) {
                  valid_end = 0;
                  break;
                }
              }
              if (!valid_end || end_pos > goto_pos) break;
              if (is_lt[k]) break;
              /* Accept: constants, pure reads */
              if (op_at == OP_undefined || op_at == OP_null ||
                  op_at == OP_push_false || op_at == OP_push_true ||
                  (op_at >= OP_push_minus1 && op_at <= OP_push_7) ||
                  op_at == OP_push_i8 || op_at == OP_push_i16 ||
                  op_at == OP_push_i32 || op_at == OP_push_atom_value ||
                  op_at == OP_push_const || op_at == OP_push_const8 ||
                  op_at == OP_push_empty_string ||
                  (op_at >= OP_get_loc0 && op_at <= OP_get_loc3) ||
                  op_at == OP_get_loc8 ||
                  (op_at >= OP_get_arg0 && op_at <= OP_get_arg3) ||
                  (op_at >= OP_get_var_ref0 && op_at <= OP_get_var_ref3) ||
                  op_at == OP_get_loc || op_at == OP_get_arg ||
                  op_at == OP_get_var_ref || op_at == OP_dup)
                found = 1;
              break;
            }
            if (!found) {
              all_match = 0;
              break;
            }
          } else {
            all_match = 0;
            break;
          }
          match_count++;
        }

        if (!all_match || match_count == 0) continue;
        if (match_count != label_slots[lbl].ref_count) continue;

        /* Verify no fall-through to the drop label: find the last
           instruction before L (skipping nops without labels). If it's
           not a terminator (goto/return/throw), there's fall-through
           and we can't safely eliminate the drop. */
        {
          int before = -1;
          for (int k = L - 1; k >= 0; k--) {
            if (!is_istart[k]) continue;
            if (bc_out->buf[k] == OP_nop && !is_lt[k]) continue;
            before = k;
            break;
          }
          if (before >= 0) {
            uint8_t before_op = bc_out->buf[before];
            int before_sz = short_opcode_info(before_op).size;
            /* Check if the instruction before L ends exactly at L
               (with only nops/labels in between) */
            int end_before = before + before_sz;
            int valid_gap = 1;
            for (int m = end_before; m < L; m++) {
              if (bc_out->buf[m] != OP_nop || is_lt[m]) {
                valid_gap = 0;
                break;
              }
            }
            if (!valid_gap) {
              /* A live label exists between 'before' and L.  Code
                 jumping to that label could fall through to L's drop.
                 Conservatively skip this optimization. */
              continue;
            }
            if (end_before <= L) {
              /* Instruction before L falls through to L.
                 Only safe if it's a terminator (no fall-through). */
              if (before_op != OP_goto && before_op != OP_goto8 &&
                  before_op != OP_goto16 && before_op != OP_return &&
                  before_op != OP_return_undef && before_op != OP_throw) {
                continue; /* has fall-through with live value, skip */
              }
            }
          }
        }

        /* Apply: NOP dead bytes for each jump pattern */
        for (int j = 0; j < s->jump_count; j++) {
          JumpSlot *jp = &s->jump_slots[j];
          if (jp->label != lbl || jp->size == 0) continue;
          if (jp->op == OP_if_false8 || jp->op == OP_if_true8 ||
              jp->op == OP_if_false || jp->op == OP_if_true) {
            /* Pattern A: NOP dup and post-conditional drop */
            int if_pos = jp->pos - 1;
            for (int k = if_pos - 1; k >= 0; k--) {
              if (!is_istart[k]) continue;
              if (bc_out->buf[k] == OP_nop && !is_lt[k]) continue;
              bc_out->buf[k] = OP_nop;
              break;
            }
            for (int k = jp->pos + jp->size; k < (int)bc_out->size; k++) {
              if (bc_out->buf[k] == OP_nop && !is_lt[k]) continue;
              bc_out->buf[k] = OP_nop;
              break;
            }
          } else {
            /* Pattern B: NOP the value-producing instruction before goto */
            int goto_pos = jp->pos - 1;
            for (int k = goto_pos - 1; k >= 0; k--) {
              if (!is_istart[k]) continue;
              if (bc_out->buf[k] == OP_nop && !is_lt[k]) continue;
              nop_full_instruction(ctx, bc_out, k);
              break;
            }
          }
        }
        label_slots[lbl].addr = L + 1;
      }

      lepus_free(ctx, is_istart);
      lepus_free(ctx, is_lt);
    } else {
      if (is_lt) lepus_free(ctx, is_lt);
      if (is_istart) lepus_free(ctx, is_istart);
    }
  }
}

/* ========================================================================
 * POST-PASS: Goto Chain Following (opt_goto_chain_follow)
 * ========================================================================
 *
 * Replace goto/goto8/goto16(L) with a terminator when L (possibly via a
 * chain of intermediate gotos) targets a return/return_undef/throw
 * instruction. Chain follows up to 10 hops with cycle detection.
 * Instruction size is preserved (goto operand bytes become NOPs), so
 * label addresses stay stable.
 */
void opt_goto_chain_follow(LEPUSContext *ctx, JSFunctionDef *s,
                           DynBuf *bc_out) {
  LabelSlot *label_slots = s->label_slots;
  if (OPTIMIZE && bc_out->size > 0) {
    /* Build pos → jump_slot index map for O(1) lookup */
    int *pos_to_jp = static_cast<int *>(lepus_malloc(
        ctx, (bc_out->size + 1) * sizeof(int), ALLOC_TAG_WITHOUT_PTR));
    if (!pos_to_jp) return;
    memset(pos_to_jp, -1, (bc_out->size + 1) * sizeof(int));
    for (int k = 0; k < s->jump_count; k++) {
      if (s->jump_slots[k].size > 0 && s->jump_slots[k].pos < (int)bc_out->size)
        pos_to_jp[s->jump_slots[k].pos] = k;
    }

    for (int j = 0; j < s->jump_count; j++) {
      JumpSlot *jp = &s->jump_slots[j];
      if (jp->size == 0) continue;
      if (jp->op != OP_goto && jp->op != OP_goto8 && jp->op != OP_goto16)
        continue;
      /* Follow goto chain looking for a terminal instruction */
      int cur_label = jp->label;
      uint8_t terminal_op = 0;
      for (int depth = 0; depth < 10; depth++) {
        int L = label_slots[cur_label].addr;
        if (L < 0 || L >= (int)bc_out->size) break;
        int tgt = L;
        while (tgt < (int)bc_out->size && bc_out->buf[tgt] == OP_nop) tgt++;
        if (tgt >= (int)bc_out->size) break;
        uint8_t target_op = bc_out->buf[tgt];
        if (target_op == OP_return || target_op == OP_return_undef ||
            target_op == OP_throw) {
          terminal_op = target_op;
          break;
        }
        if (target_op != OP_goto && target_op != OP_goto8 &&
            target_op != OP_goto16)
          break;
        /* Find the intermediate goto's jump_slot via pos map */
        int tgt_offset_pos = tgt + 1;
        JumpSlot *jp_tgt = NULL;
        if (tgt_offset_pos < (int)bc_out->size &&
            pos_to_jp[tgt_offset_pos] >= 0)
          jp_tgt = &s->jump_slots[pos_to_jp[tgt_offset_pos]];
        if (!jp_tgt) break;
        if (jp_tgt->label == cur_label) break; /* cycle detection */
        cur_label = jp_tgt->label;
      }
      if (terminal_op) {
        int goto_pos = jp->pos - 1;
        bc_out->buf[goto_pos] = terminal_op;
        for (int k = jp->pos; k < (int)(jp->pos + jp->size); k++)
          bc_out->buf[k] = OP_nop;
        pos_to_jp[jp->pos] = -1;
        jp->size = 0;
        jp->op = OP_nop;
        label_slots[jp->label].ref_count--;
      }
    }
    lepus_free(ctx, pos_to_jp);
  }
}

/* ========================================================================
 * POST-PASS: Branch Inversion (opt_branch_inversion)
 * ========================================================================
 *
 * Two kinds of branch inversion:
 * 1) if_xxx(skip) goto_yyy(L) → if_inv(L) + NOPs
 *    Handles all combinations of if_false8/if_true8/if_false/if_true with
 *    goto8/goto16/goto. The inverted if takes the goto's target label and
 *    the goto bytes become NOPs.
 * 2) lnot + if_xxx → if_inv (scanner-based, short-range pattern)
 *    lnot if_false → if_true, lnot if_true → if_false (and 8-bit variants).
 */
void opt_branch_inversion(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out) {
  LabelSlot *label_slots = s->label_slots;
  if (!OPTIMIZE || bc_out->size == 0) return;

  /* Build pos → jump_slot index map for O(1) lookup */
  int *pos_to_jp = static_cast<int *>(lepus_malloc(
      ctx, (bc_out->size + 1) * sizeof(int), ALLOC_TAG_WITHOUT_PTR));
  if (!pos_to_jp) return;
  memset(pos_to_jp, -1, (bc_out->size + 1) * sizeof(int));
  for (int k = 0; k < s->jump_count; k++) {
    if (s->jump_slots[k].size > 0 && s->jump_slots[k].pos < (int)bc_out->size)
      pos_to_jp[s->jump_slots[k].pos] = k;
  }

  /* Helper: find jump_slot whose pos matches (instr_pos + 1) */
  auto find_jump_slot = [s, pos_to_jp, bc_out](int instr_pos) -> JumpSlot * {
    int target_pos = instr_pos + 1;
    if (target_pos >= (int)bc_out->size) return NULL;
    int idx = pos_to_jp[target_pos];
    return idx >= 0 ? &s->jump_slots[idx] : NULL;
  };

  /* Part 1: Scanner-based lnot + if inversion (short-range patterns) */
  {
    uint8_t *is_label_target = static_cast<uint8_t *>(
        lepus_mallocz(ctx, bc_out->size, ALLOC_TAG_WITHOUT_PTR));
    if (is_label_target) {
      for (int j = 0; j < s->label_count; j++) {
        if (label_slots[j].ref_count > 0 && label_slots[j].addr >= 0 &&
            label_slots[j].addr < (int)bc_out->size)
          is_label_target[label_slots[j].addr] = 1;
      }

      for (int p = 0; p < (int)bc_out->size;) {
        int scan_op = bc_out->buf[p];
        int sz = short_opcode_info(scan_op).size;
        if (sz <= 0) break;
        int next_p = p + sz;

        /* nr: next non-NOP instruction position (skip NOP gaps) */
        int nr = next_p;
        while (nr < (int)bc_out->size && bc_out->buf[nr] == OP_nop &&
               !is_label_target[nr])
          nr++;

        if (scan_op == OP_lnot) {
          /* lnot if_false → if_true + nop */
          if (nr + 5 <= (int)bc_out->size && bc_out->buf[nr] == OP_if_false &&
              !is_label_target[nr]) {
            bc_out->buf[p] = OP_nop;
            bc_out->buf[nr] = OP_if_true;
            JumpSlot *jp = find_jump_slot(nr);
            if (jp) jp->op = OP_if_true;
            p = nr + 5;
            continue;
          }
          /* lnot if_true → if_false + nop */
          if (nr + 5 <= (int)bc_out->size && bc_out->buf[nr] == OP_if_true &&
              !is_label_target[nr]) {
            bc_out->buf[p] = OP_nop;
            bc_out->buf[nr] = OP_if_false;
            JumpSlot *jp = find_jump_slot(nr);
            if (jp) jp->op = OP_if_false;
            p = nr + 5;
            continue;
          }
          /* lnot if_false8 → if_true8 + nop */
          if (nr + 2 <= (int)bc_out->size && bc_out->buf[nr] == OP_if_false8 &&
              !is_label_target[nr]) {
            bc_out->buf[p] = OP_nop;
            bc_out->buf[nr] = OP_if_true8;
            JumpSlot *jp = find_jump_slot(nr);
            if (jp) jp->op = OP_if_true8;
            p = nr + 2;
            continue;
          }
          /* lnot if_true8 → if_false8 + nop */
          if (nr + 2 <= (int)bc_out->size && bc_out->buf[nr] == OP_if_true8 &&
              !is_label_target[nr]) {
            bc_out->buf[p] = OP_nop;
            bc_out->buf[nr] = OP_if_false8;
            JumpSlot *jp = find_jump_slot(nr);
            if (jp) jp->op = OP_if_false8;
            p = nr + 2;
            continue;
          }
        }

        p = next_p;
      }
      lepus_free(ctx, is_label_target);
    }
  }

  /* Part 2: jump_slot-based if+goto inversion */
  {
    for (int j = 0; j < s->jump_count; j++) {
      JumpSlot *jp_if = &s->jump_slots[j];
      if (jp_if->size == 0) continue;
      int if_is_8bit;
      if (jp_if->op == OP_if_false8 || jp_if->op == OP_if_true8)
        if_is_8bit = 1;
      else if (jp_if->op == OP_if_false || jp_if->op == OP_if_true)
        if_is_8bit = 0;
      else
        continue;
      int if_opcode_pos = jp_if->pos - 1;
      int if_instr_size = 1 + jp_if->size; /* 2 for 8-bit, 5 for 32-bit */
      int goto_opcode_pos = if_opcode_pos + if_instr_size;
      if (goto_opcode_pos >= (int)bc_out->size) continue;
      uint8_t goto_op = bc_out->buf[goto_opcode_pos];
      int goto_size = 0;
      if (goto_op == OP_goto8)
        goto_size = 2;
      else if (goto_op == OP_goto16)
        goto_size = 3;
      else if (goto_op == OP_goto)
        goto_size = 5;
      if (!goto_size) continue;
      /* Verify the if's target is exactly past the goto */
      int if_label_addr = label_slots[jp_if->label].addr;
      if (if_label_addr != goto_opcode_pos + goto_size) continue;
      /* Find the goto's jump_slot */
      int goto_offset_pos = goto_opcode_pos + 1;
      JumpSlot *jp_goto = NULL;
      if (goto_offset_pos < (int)bc_out->size &&
          pos_to_jp[goto_offset_pos] >= 0)
        jp_goto = &s->jump_slots[pos_to_jp[goto_offset_pos]];
      if (!jp_goto) continue;
      int goto_label_addr = label_slots[jp_goto->label].addr;
      /* Determine new if opcode and check offset fits.
         Note: the raw offset byte in bc_out is left stale here — it will be
         rewritten by opt_nop_strip which recomputes all jump offsets from
         label_slots[].addr. No pass between here and opt_nop_strip reads
         raw bytecode offsets (they use jump_slot/label_slot metadata). */
      if (if_is_8bit) {
        /* Keep as 8-bit if, check offset fits in int8 */
        int new_diff = goto_label_addr - jp_if->pos;
        if (new_diff < -128 || new_diff > 127) continue;
        uint8_t new_op =
            (jp_if->op == OP_if_false8) ? OP_if_true8 : OP_if_false8;
        bc_out->buf[if_opcode_pos] = new_op;
        for (int k = 0; k < goto_size; k++)
          bc_out->buf[goto_opcode_pos + k] = OP_nop;
        jp_if->op = new_op;
      } else {
        /* 32-bit if: invert and retarget to goto's label. Offset always fits.
         */
        uint8_t new_op = (jp_if->op == OP_if_false) ? OP_if_true : OP_if_false;
        bc_out->buf[if_opcode_pos] = new_op;
        for (int k = 0; k < goto_size; k++)
          bc_out->buf[goto_opcode_pos + k] = OP_nop;
        jp_if->op = new_op;
      }
      int old_label = jp_if->label;
      jp_if->label = jp_goto->label;
      pos_to_jp[jp_goto->pos] = -1;
      jp_goto->size = 0;
      jp_goto->op = OP_nop;
      label_slots[old_label].ref_count--;
    }
  }
  lepus_free(ctx, pos_to_jp);
}

/* ========================================================================
 * POST-PASS: Dead Code Elimination (opt_final_dce)
 * ========================================================================
 *
 * Operates on the fully-emitted bc_out buffer. Performs multiple sub-passes:
 * 1) Unreachable code after terminators (return/throw/goto) → NOP
 * 2) set_xxx [nop*] drop → put_xxx [nop*] nop (dead result elimination)
 * 3) pure_op [nop*] drop → all nops (dead value elimination)
 * 4) Consecutive identical reads → dup (redundant load elimination)
 * Also: goto-to-return conversion and undefined+return → return_undef.
 */
/* Post-pass peephole on final bytecode:
   1) Unreachable code elimination after return/return_undef/throw
   2) set_xxx [nop*] drop -> put_xxx [nop*] nop  (drop consumed by set->put)
   3) pure_op [nop*] drop -> all nops  (dead value elimination)
   4) consecutive identical read -> dup  (redundant load elimination)
   Also includes goto-to-return second pass and undefined+return->return_undef.
 */

/* Convert a set_xxx opcode to the corresponding put_xxx opcode.
   Returns 0 if the opcode is not a set operation. */
static inline uint8_t set_op_to_put_op(uint8_t op) {
  if (op >= OP_set_arg0 && op <= OP_set_arg3)
    return OP_put_arg0 + (op - OP_set_arg0);
  if (op >= OP_set_loc0 && op <= OP_set_loc3)
    return OP_put_loc0 + (op - OP_set_loc0);
  if (op >= OP_set_var_ref0 && op <= OP_set_var_ref3)
    return OP_put_var_ref0 + (op - OP_set_var_ref0);
  if (op == OP_set_loc8) return OP_put_loc8;
  if (op == OP_set_loc) return OP_put_loc;
  if (op == OP_set_arg) return OP_put_arg;
  if (op == OP_set_var_ref) return OP_put_var_ref;
  return 0;
}

/* Returns true if op is a pure read/push with no side effects:
   reading the result and immediately dropping it is a no-op. */
static inline int is_pure_op(uint8_t op) {
  return (op >= OP_get_loc0 && op <= OP_get_loc3) || op == OP_get_loc8 ||
         (op >= OP_get_arg0 && op <= OP_get_arg3) ||
         (op >= OP_get_var_ref0 && op <= OP_get_var_ref3) || op == OP_get_loc ||
         op == OP_get_arg || op == OP_get_var_ref || op == OP_dup ||
         op == OP_push_this || op == OP_object || op == OP_undefined ||
         op == OP_null || op == OP_push_false || op == OP_push_true ||
         (op >= OP_push_minus1 && op <= OP_push_7) || op == OP_push_i8 ||
         op == OP_push_i16 || op == OP_push_i32 || op == OP_push_atom_value ||
         op == OP_push_const || op == OP_push_const8 ||
         op == OP_push_empty_string;
}

/* Shared context for DCE sub-passes. */
struct DceCtx {
  LEPUSContext *ctx;
  JSFunctionDef *s;
  DynBuf *bc_out;
  uint8_t *is_label_target; /* all label positions (including ref_count==0) */
  uint8_t *is_live_label_target; /* only labels with ref_count > 0 */
  int *pos_to_jp; /* optional jump-slot lookup by operand position */
};

static void dce_kill_jump_slots_in_range(DceCtx *dce, int start, int end) {
  JSFunctionDef *s = dce->s;
  LabelSlot *label_slots = s->label_slots;

  if (dce->pos_to_jp) {
    for (int pos = start; pos < end; pos++) {
      int jj = dce->pos_to_jp[pos];
      if (jj < 0) continue;
      JumpSlot *jp = &s->jump_slots[jj];
      if (jp->size > 0 && jp->pos == pos) {
        label_slots[jp->label].ref_count--;
        jp->size = 0;
        jp->op = OP_nop;
        jp->pos = -1;
      }
      dce->pos_to_jp[pos] = -1;
    }
    return;
  }

  for (int jj = 0; jj < s->jump_count; jj++) {
    JumpSlot *jp = &s->jump_slots[jj];
    if (jp->size > 0 && jp->pos >= start && jp->pos < end) {
      label_slots[jp->label].ref_count--;
      jp->size = 0;
      jp->op = OP_nop;
      jp->pos = -1;
    }
  }
}

/* (1) Unreachable code elimination: NOP out instructions after
   return/return_undef/throw/goto until the next label target.
   Also kill any jump_slots in the dead region. */
static void dce_unreachable_code(DceCtx *dce) {
  DynBuf *bc_out = dce->bc_out;
  LEPUSContext *ctx = dce->ctx;
  JSFunctionDef *s = dce->s;
  uint8_t *is_label_target = dce->is_label_target;

  for (int p = 0; p < (int)bc_out->size;) {
    uint8_t op2 = bc_out->buf[p];
    int sz = short_opcode_info(op2).size;
    if (sz <= 0) break;
    if (op2 == OP_return || op2 == OP_return_undef || op2 == OP_throw ||
        op2 == OP_goto8 || op2 == OP_goto16 || op2 == OP_goto) {
      int q = p + sz;
      while (q < (int)bc_out->size && !is_label_target[q]) {
        int qsz = short_opcode_info(bc_out->buf[q]).size;
        if (qsz <= 0) break;
        /* Kill jump_slots whose offset operand falls in this dead instruction.
           Besides goto/if, atom_label_u8 opcodes such as OP_with_get_var also
           register jump slots, with the label operand at q + 5. */
        dce_kill_jump_slots_in_range(dce, q + 1, q + qsz);
        nop_full_instruction(ctx, bc_out, q);
        q += qsz;
      }
      p = q;
    } else {
      p += sz;
    }
  }
}

/* Rebuild is_live_label_target bitmap from current label ref_counts. */
static void dce_rebuild_live_labels(DceCtx *dce) {
  DynBuf *bc_out = dce->bc_out;
  JSFunctionDef *s = dce->s;
  LabelSlot *label_slots = s->label_slots;
  uint8_t *is_live_label_target = dce->is_live_label_target;

  if (is_live_label_target == dce->is_label_target)
    return; /* fallback mode, can't rebuild */
  memset(is_live_label_target, 0, bc_out->size);
  for (int j = 0; j < s->label_count; j++) {
    if (label_slots[j].addr >= 0 && label_slots[j].addr < (int)bc_out->size &&
        label_slots[j].ref_count > 0)
      is_live_label_target[label_slots[j].addr] = 1;
  }
}

/* (1.3) Goto-to-return: if a goto targets a label whose first non-NOP
   instruction is return_undef (or return), replace goto with that return. */
static void dce_goto_to_return(DceCtx *dce) {
  DynBuf *bc_out = dce->bc_out;
  JSFunctionDef *s = dce->s;
  LabelSlot *label_slots = s->label_slots;

  for (int j = 0; j < s->jump_count; j++) {
    JumpSlot *jp = &s->jump_slots[j];
    if (jp->size == 0) continue;
    uint8_t jop = bc_out->buf[jp->pos - 1];
    if (jop != OP_goto8 && jop != OP_goto16 && jop != OP_goto) continue;
    int label_addr = label_slots[jp->label].addr;
    if (label_addr < 0 || label_addr >= (int)bc_out->size) continue;
    /* Find first non-NOP at label target */
    int tgt = label_addr;
    while (tgt < (int)bc_out->size && bc_out->buf[tgt] == OP_nop) tgt++;
    if (tgt >= (int)bc_out->size) continue;
    uint8_t tgt_op = bc_out->buf[tgt];
    if (tgt_op == OP_return_undef || tgt_op == OP_return) {
      int goto_start = jp->pos - 1;
      int goto_size = 1 + jp->size;
      bc_out->buf[goto_start] = tgt_op;
      for (int k = 1; k < goto_size; k++) bc_out->buf[goto_start + k] = OP_nop;
      label_slots[jp->label].ref_count--;
      jp->size = 0;
      jp->op = OP_nop;
    }
  }
}

/* (1.4) undefined [nop*] return → return_undef [nop*] nop */
static void dce_undefined_return(DceCtx *dce) {
  DynBuf *bc_out = dce->bc_out;
  uint8_t *is_live_label_target = dce->is_live_label_target;

  for (int p = 0; p < (int)bc_out->size;) {
    uint8_t opc = bc_out->buf[p];
    int sz2 = short_opcode_info(opc).size;
    if (sz2 <= 0) break;
    if (opc == OP_undefined && !is_live_label_target[p]) {
      int q = p + 1;
      while (q < (int)bc_out->size && bc_out->buf[q] == OP_nop &&
             !is_live_label_target[q])
        q++;
      if (q < (int)bc_out->size && bc_out->buf[q] == OP_return &&
          !is_live_label_target[q]) {
        bc_out->buf[p] = OP_return_undef;
        bc_out->buf[q] = OP_nop;
      }
    }
    p += sz2;
  }
}

/* (1.5) All-paths set+drop elimination:
   For each OP_drop that is a label target, if EVERY path reaching it
   ends with "set_xxx", convert set_xxx → put_xxx and NOP the drop. */
static void dce_all_paths_set_drop(DceCtx *dce) {
  LEPUSContext *ctx = dce->ctx;
  DynBuf *bc_out = dce->bc_out;
  JSFunctionDef *s = dce->s;
  LabelSlot *label_slots = s->label_slots;
  uint8_t *is_live_label_target = dce->is_live_label_target;

  /* prev_real_pos[p] = start position of the nearest preceding non-NOP
     instruction, or -1 if none exists.  Used to quickly find the fallthrough
     predecessor of a given instruction while skipping over NOP padding. */
  int *prev_real_pos = static_cast<int *>(
      lepus_mallocz(ctx, bc_out->size * sizeof(int), ALLOC_TAG_WITHOUT_PTR));
  if (!prev_real_pos) return;

  int last_real = -1;
  for (int p = 0; p < (int)bc_out->size;) {
    uint8_t opc = bc_out->buf[p];
    int sz2 = short_opcode_info(opc).size;
    if (sz2 <= 0) break;
    prev_real_pos[p] = last_real;
    if (opc != OP_nop) last_real = p;
    p += sz2;
  }

  uint8_t *is_drop_label = static_cast<uint8_t *>(
      lepus_mallocz(ctx, bc_out->size, ALLOC_TAG_WITHOUT_PTR));
  if (!is_drop_label) {
    lepus_free(ctx, prev_real_pos);
    return;
  }

  /* Mark positions where a drop has at least one live label */
  for (int j = 0; j < s->label_count; j++) {
    int addr = label_slots[j].addr;
    if (addr >= 0 && addr < (int)bc_out->size && bc_out->buf[addr] == OP_drop &&
        label_slots[j].ref_count > 0)
      is_drop_label[addr] = 1;
  }

  /* For each position with a labeled drop */
  for (int addr = 0; addr < (int)bc_out->size; addr++) {
    if (!is_drop_label[addr]) continue;

    int all_ok = 1;
    int path_count = 0;

    /* Check fallthrough path: the preceding non-NOP instruction must be
       either a terminator (no fallthrough) or a set_xxx that is not itself
       a jump target (so its stack state is guaranteed). */
    int fb = prev_real_pos[addr];
    if (fb >= 0) {
      uint8_t fb_op = bc_out->buf[fb];
      if (fb_op == OP_goto || fb_op == OP_goto8 || fb_op == OP_goto16 ||
          fb_op == OP_return || fb_op == OP_return_undef || fb_op == OP_throw) {
        /* No fallthrough */
      } else if ((fb_op >= OP_set_arg0 && fb_op <= OP_set_arg3) ||
                 (fb_op >= OP_set_loc0 && fb_op <= OP_set_loc3) ||
                 (fb_op >= OP_set_var_ref0 && fb_op <= OP_set_var_ref3) ||
                 fb_op == OP_set_loc8 || fb_op == OP_set_loc ||
                 fb_op == OP_set_arg || fb_op == OP_set_var_ref) {
        if (!is_live_label_target[fb]) {
          path_count++;
        } else {
          /* set_xxx is itself a jump target — other paths may arrive here
             with unknown stack state, so we can't guarantee the TOS value
             came from this set_xxx. Bail out. */
          all_ok = 0;
        }
      } else {
        all_ok = 0;
      }
    }

    if (!all_ok) continue;

    /* Check ALL jump_slots that resolve to this address */
    for (int k = 0; k < s->jump_count && all_ok; k++) {
      if (s->jump_slots[k].size == 0) continue;
      int target_label = s->jump_slots[k].label;
      if (label_slots[target_label].addr != addr) continue;

      int goto_pos = s->jump_slots[k].pos - 1;
      uint8_t goto_op = bc_out->buf[goto_pos];
      if (goto_op != OP_goto && goto_op != OP_goto8 && goto_op != OP_goto16) {
        all_ok = 0;
        break;
      }
      int gb = prev_real_pos[goto_pos];
      if (gb < 0) {
        all_ok = 0;
        break;
      }
      uint8_t gb_op = bc_out->buf[gb];
      if ((gb_op >= OP_set_arg0 && gb_op <= OP_set_arg3) ||
          (gb_op >= OP_set_loc0 && gb_op <= OP_set_loc3) ||
          (gb_op >= OP_set_var_ref0 && gb_op <= OP_set_var_ref3) ||
          gb_op == OP_set_loc8 || gb_op == OP_set_loc || gb_op == OP_set_arg ||
          gb_op == OP_set_var_ref) {
        if (!is_live_label_target[gb]) {
          path_count++;
        } else {
          all_ok = 0;
        }
      } else {
        all_ok = 0;
      }
    }

    if (!all_ok || path_count == 0) continue;

    /* All paths verified! Convert set_xxx → put_xxx, NOP the drop */
    if (fb >= 0) {
      uint8_t fb_op = bc_out->buf[fb];
      if (fb_op != OP_goto && fb_op != OP_goto8 && fb_op != OP_goto16 &&
          fb_op != OP_return && fb_op != OP_return_undef && fb_op != OP_throw) {
        uint8_t put_op2 = set_op_to_put_op(fb_op);
        if (put_op2) bc_out->buf[fb] = put_op2;
      }
    }

    for (int k = 0; k < s->jump_count; k++) {
      if (s->jump_slots[k].size == 0) continue;
      if (label_slots[s->jump_slots[k].label].addr != addr) continue;
      int goto_pos = s->jump_slots[k].pos - 1;
      int gb = prev_real_pos[goto_pos];
      if (gb < 0) continue;
      uint8_t gb_op = bc_out->buf[gb];
      uint8_t put_op2 = set_op_to_put_op(gb_op);
      if (put_op2) bc_out->buf[gb] = put_op2;
    }

    bc_out->buf[addr] = OP_nop;
  }

  lepus_free(ctx, is_drop_label);
  lepus_free(ctx, prev_real_pos);
}

/* (2-4) Main peephole loop: set+drop→put, pure+drop→nop, put+get→dup,
   set+get→dup, consecutive read→dup. */
static void dce_peephole(DceCtx *dce) {
  DynBuf *bc_out = dce->bc_out;
  LEPUSContext *ctx = dce->ctx;
  uint8_t *is_live_label_target = dce->is_live_label_target;

  for (int p = 0; p < (int)bc_out->size;) {
    uint8_t op2 = bc_out->buf[p];
    int sz = short_opcode_info(op2).size;
    if (sz <= 0) break;

    /* put_loc8/put_loc/put_arg/put_var_ref(X) [nop*] get_xxx(X) → dup
     * put_xxx(X) */
    {
      uint8_t get_op2 = 0;
      int operand_sz = 0;
      if (op2 == OP_put_loc8) {
        get_op2 = OP_get_loc8;
        operand_sz = 1;
      } else if (op2 == OP_put_loc) {
        get_op2 = OP_get_loc;
        operand_sz = 2;
      } else if (op2 == OP_put_arg) {
        get_op2 = OP_get_arg;
        operand_sz = 2;
      } else if (op2 == OP_put_var_ref) {
        get_op2 = OP_get_var_ref;
        operand_sz = 2;
      }
      if (get_op2 && !is_live_label_target[p]) {
        int put_sz = 1 + operand_sz;
        int next = p + put_sz;
        while (next < (int)bc_out->size && bc_out->buf[next] == OP_nop &&
               !is_live_label_target[next])
          next++;
        if (next + put_sz <= (int)bc_out->size && !is_live_label_target[next] &&
            bc_out->buf[next] == get_op2) {
          int same = 1;
          for (int k = 1; k <= operand_sz; k++) {
            if (bc_out->buf[p + k] != bc_out->buf[next + k]) {
              same = 0;
              break;
            }
          }
          if (same) {
            uint8_t saved[2];
            for (int k = 0; k < operand_sz; k++)
              saved[k] = bc_out->buf[p + 1 + k];
            bc_out->buf[p] = OP_dup;
            bc_out->buf[p + 1] = op2;
            for (int k = 0; k < operand_sz; k++)
              bc_out->buf[p + 2 + k] = saved[k];
            for (int k = p + 2 + operand_sz; k < next + put_sz; k++)
              bc_out->buf[k] = OP_nop;
            p = next + put_sz;
            continue;
          }
        }
      }
    }

    /* set_xxx(X) [nop*] get_xxx(X) → set_xxx(X) [nop*] dup */
    {
      uint8_t get_op2 = 0;
      int operand_sz = 0;
      if (op2 == OP_set_loc8) {
        get_op2 = OP_get_loc8;
        operand_sz = 1;
      } else if (op2 == OP_set_loc) {
        get_op2 = OP_get_loc;
        operand_sz = 2;
      } else if (op2 == OP_set_arg) {
        get_op2 = OP_get_arg;
        operand_sz = 2;
      } else if (op2 == OP_set_var_ref) {
        get_op2 = OP_get_var_ref;
        operand_sz = 2;
      }
      if (get_op2 && !is_live_label_target[p]) {
        int set_sz = 1 + operand_sz;
        int next = p + set_sz;
        while (next < (int)bc_out->size && bc_out->buf[next] == OP_nop &&
               !is_live_label_target[next])
          next++;
        if (next + set_sz <= (int)bc_out->size && !is_live_label_target[next] &&
            bc_out->buf[next] == get_op2) {
          int same = 1;
          for (int k = 1; k <= operand_sz; k++) {
            if (bc_out->buf[p + k] != bc_out->buf[next + k]) {
              same = 0;
              break;
            }
          }
          if (same) {
            bc_out->buf[next] = OP_dup;
            for (int k = 1; k < set_sz; k++) bc_out->buf[next + k] = OP_nop;
            p = next + 1;
            continue;
          }
        }
      }
    }

    /* set_xxx [nop*] drop → put_xxx [nop*] nop */
    uint8_t put_op = 0;
    if (op2 >= OP_set_arg0 && op2 <= OP_set_arg3)
      put_op = OP_put_arg0 + (op2 - OP_set_arg0);
    else if (op2 >= OP_set_loc0 && op2 <= OP_set_loc3)
      put_op = OP_put_loc0 + (op2 - OP_set_loc0);
    else if (op2 == OP_set_loc8)
      put_op = OP_put_loc8;
    else if (op2 == OP_set_loc)
      put_op = OP_put_loc;
    else if (op2 == OP_set_arg)
      put_op = OP_put_arg;
    else if (op2 == OP_set_var_ref)
      put_op = OP_put_var_ref;
    else if (op2 >= OP_set_var_ref0 && op2 <= OP_set_var_ref3)
      put_op = OP_put_var_ref0 + (op2 - OP_set_var_ref0);

    if (put_op) {
      int drop_pos = p + sz;
      while (drop_pos < (int)bc_out->size && bc_out->buf[drop_pos] == OP_nop &&
             !is_live_label_target[drop_pos])
        drop_pos++;
      if (drop_pos < (int)bc_out->size && bc_out->buf[drop_pos] == OP_drop &&
          !is_live_label_target[drop_pos]) {
        bc_out->buf[p] = put_op;
        bc_out->buf[drop_pos] = OP_nop;
        continue;
      }
    }

    /* Dead read/push elimination: pure_op [nop*] drop → all nops */
    int is_pure_read = is_pure_op(op2);

    if (is_pure_read && !is_live_label_target[p]) {
      int drop_pos = p + sz;
      while (drop_pos < (int)bc_out->size && bc_out->buf[drop_pos] == OP_nop &&
             !is_live_label_target[drop_pos])
        drop_pos++;
      if (drop_pos < (int)bc_out->size && bc_out->buf[drop_pos] == OP_drop &&
          !is_live_label_target[drop_pos]) {
        nop_full_instruction(ctx, bc_out, p);
        bc_out->buf[drop_pos] = OP_nop;
        p = drop_pos + 1;
        continue;
      }
    }

    /* Consecutive identical read → dup */
    if (is_pure_read && sz >= 2 && !is_live_label_target[p]) {
      int next = p + sz;
      while (next < (int)bc_out->size && bc_out->buf[next] == OP_nop &&
             !is_live_label_target[next])
        next++;
      if (next + sz <= (int)bc_out->size && !is_live_label_target[next]) {
        int same = 1;
        for (int k = 0; k < sz; k++) {
          if (bc_out->buf[next + k] != bc_out->buf[p + k]) {
            same = 0;
            break;
          }
        }
        if (same) {
          bc_out->buf[next] = OP_dup;
          for (int k = 1; k < sz; k++) bc_out->buf[next + k] = OP_nop;
          p = next + 1;
          continue;
        }
      }
    }

    p += sz;
  }
}

/* Post-pass peephole on final bytecode:
   1) Unreachable code elimination after return/return_undef/throw
   2) set_xxx [nop*] drop → put_xxx [nop*] nop  (drop consumed by set→put)
   3) pure_op [nop*] drop → all nops  (dead value elimination)
   4) consecutive identical read → dup  (redundant load elimination) */
void opt_final_dce(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out) {
  if (!OPTIMIZE || bc_out->size == 0) return;

  LabelSlot *label_slots = s->label_slots;
  uint8_t *is_label_target = static_cast<uint8_t *>(
      lepus_mallocz(ctx, bc_out->size, ALLOC_TAG_WITHOUT_PTR));
  if (!is_label_target) return;

  /* Mark ALL label positions (including ref_count==0) for step 1. */
  for (int j = 0; j < s->label_count; j++) {
    if (label_slots[j].addr >= 0 && label_slots[j].addr < (int)bc_out->size)
      is_label_target[label_slots[j].addr] = 1;
  }

  DceCtx dce;
  dce.ctx = ctx;
  dce.s = s;
  dce.bc_out = bc_out;
  dce.is_label_target = is_label_target;
  dce.is_live_label_target = NULL;
  dce.pos_to_jp = NULL;
  if (s->jump_count > 0)
    dce.pos_to_jp = static_cast<int *>(
        lepus_malloc(ctx, bc_out->size * sizeof(int), ALLOC_TAG_WITHOUT_PTR));
  if (dce.pos_to_jp) {
    BOOL has_duplicate_jump_pos = FALSE;
    memset(dce.pos_to_jp, -1, bc_out->size * sizeof(int));
    for (int j = 0; j < s->jump_count; j++) {
      JumpSlot *jp = &s->jump_slots[j];
      if (jp->size > 0 && jp->pos >= 0 && jp->pos < (int)bc_out->size) {
        if (dce.pos_to_jp[jp->pos] >= 0) {
          has_duplicate_jump_pos = TRUE;
          break;
        }
        dce.pos_to_jp[jp->pos] = j;
      }
    }
    if (has_duplicate_jump_pos) {
      lepus_free(ctx, dce.pos_to_jp);
      dce.pos_to_jp = NULL;
    }
  }

  /* (1) Unreachable code elimination */
  dce_unreachable_code(&dce);

  /* Build "live label" bitmap (only labels with ref_count > 0) */
  uint8_t *is_live_label_target = static_cast<uint8_t *>(
      lepus_mallocz(ctx, bc_out->size, ALLOC_TAG_WITHOUT_PTR));
  if (is_live_label_target) {
    for (int j = 0; j < s->label_count; j++) {
      if (label_slots[j].addr >= 0 && label_slots[j].addr < (int)bc_out->size &&
          label_slots[j].ref_count > 0)
        is_live_label_target[label_slots[j].addr] = 1;
    }
  } else {
    is_live_label_target = is_label_target; /* fallback: conservative */
  }
  dce.is_live_label_target = is_live_label_target;

  /* (1.3) Goto-to-return */
  dce_goto_to_return(&dce);

  /* Rebuild is_live_label_target after goto-to-return may have decremented refs
   */
  dce_rebuild_live_labels(&dce);

  /* (1.4) undefined + return → return_undef */
  dce_undefined_return(&dce);

  /* (1.5) All-paths set+drop elimination */
  dce_all_paths_set_drop(&dce);

  /* (2-4) Main peephole loop */
  dce_peephole(&dce);

  if (is_live_label_target != is_label_target)
    lepus_free(ctx, is_live_label_target);
  if (dce.pos_to_jp) lepus_free(ctx, dce.pos_to_jp);
  lepus_free(ctx, is_label_target);
}

/* ========================================================================
 * POST-PASS: NOP Strip (opt_nop_strip)
 * ========================================================================
 *
 * After all optimization passes produce NOP gaps, this pass compacts the
 * bytecode by removing all NOP instructions and adjusting every position-
 * dependent reference: label addresses, jump slot positions, line number PCs,
 * and caller position slots. Uses an offset_map[] to track cumulative
 * bytes removed at each position.
 */
/* Post-pass: strip nop instructions from bc_out and adjust all position
   references (label addresses, jump positions, line numbers, caller PCs). */
void opt_nop_strip(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out) {
  if (bc_out->size == 0) return;
  int *offset_map = static_cast<int *>(lepus_mallocz(
      ctx, (bc_out->size + 1) * sizeof(int), ALLOC_TAG_WITHOUT_PTR));
  if (!offset_map) return;
  int removed = 0;
  for (int p = 0; p < (int)bc_out->size;) {
    int scan_op = bc_out->buf[p];
    int sz = short_opcode_info(scan_op).size;
    if (sz <= 0) break;
    if (scan_op == OP_nop) {
      offset_map[p] = removed;
      removed++;
      p += 1;
    } else {
      for (int k = 0; k < sz; k++) offset_map[p + k] = removed;
      p += sz;
    }
  }
  offset_map[bc_out->size] = removed;

  if (removed > 0) {
    /* Compact bc_out in place */
    int dst = 0;
    for (int p = 0; p < (int)bc_out->size;) {
      int scan_op = bc_out->buf[p];
      int sz = short_opcode_info(scan_op).size;
      if (sz <= 0) break;
      if (scan_op != OP_nop) {
        memmove(bc_out->buf + dst, bc_out->buf + p, sz);
        dst += sz;
      }
      p += sz;
    }
    bc_out->size = dst;

    /* Adjust label addresses */
    for (int j = 0; j < s->label_count; j++) {
      if (s->label_slots[j].addr >= 0)
        s->label_slots[j].addr -= offset_map[s->label_slots[j].addr];
    }
    /* Adjust jump positions */
    for (int j = 0; j < s->jump_count; j++) {
      if (s->jump_slots[j].pos >= 0)
        s->jump_slots[j].pos -= offset_map[s->jump_slots[j].pos];
    }
    /* Adjust line number PCs */
    for (int j = 0; j < s->line_number_count; j++)
      s->line_number_slots[j].pc -= offset_map[s->line_number_slots[j].pc];
    /* Adjust caller PCs */
    for (int j = 0; j < s->caller_count; j++)
      s->caller_slots[j].pc -= offset_map[s->caller_slots[j].pc];
    /* Rewrite jump offsets in bc_out (distances may have changed) */
    for (int j = 0; j < s->jump_count; j++) {
      int diff =
          s->label_slots[s->jump_slots[j].label].addr - s->jump_slots[j].pos;
      switch (s->jump_slots[j].size) {
        case 1:
          put_u8(bc_out->buf + s->jump_slots[j].pos, diff);
          break;
        case 2:
          put_u16(bc_out->buf + s->jump_slots[j].pos, diff);
          break;
        case 4:
          put_u32(bc_out->buf + s->jump_slots[j].pos, diff);
          break;
      }
    }
  }
  lepus_free(ctx, offset_map);
}

/* ========================================================================
 * Inline TDZ Scan Helper
 * Determines if a set_loc_uninitialized can be eliminated by proving the
 * variable is always written before being read within the basic block.
 *
 * Scans forward from scan_start within a single basic block. Stops (returns
 * FALSE) at any control flow instruction (if_xxx, goto, label, return, throw,
 * catch, gosub, ret) because we cannot guarantee ALL paths write the variable
 * before reading it across control flow boundaries.
 * ======================================================================== */

BOOL opt_tdz_inline_can_eliminate(JSFunctionDef *s, const uint8_t *bc_buf,
                                  int bc_len, int scan_start, int idx) {
  int scan_pos = scan_start;
  int scan_end = bc_len;

  while (scan_pos < scan_end) {
    int scan_op = next_valid_op(bc_buf, scan_end, &scan_pos, NULL);
    if (scan_op < 0) break;
    int scan_len = opcode_info[scan_op].size;
    /* Found write to our variable: marker is dead */
    if ((scan_op == OP_put_loc || scan_op == OP_set_loc) &&
        get_u16(bc_buf + scan_pos + 1) == idx) {
      return TRUE;
    }
    /* Found TDZ-checking access of our variable: marker is needed.
       put_loc_check and put_loc_check_init both read the TDZ state
       before writing, so the set_loc_uninitialized is required. */
    if ((scan_op == OP_get_loc_check || scan_op == OP_put_loc_check ||
         scan_op == OP_put_loc_check_init) &&
        get_u16(bc_buf + scan_pos + 1) == idx) {
      return FALSE;
    }
    /* Control flow / basic block boundary: stop scanning.
       We only analyze within a single basic block because proving all paths
       write the variable before read across branches is complex and
       error-prone. */
    if (scan_op == OP_if_true || scan_op == OP_if_false || scan_op == OP_goto ||
        scan_op == OP_label || scan_op == OP_return ||
        scan_op == OP_return_undef || scan_op == OP_throw ||
        scan_op == OP_ret || scan_op == OP_catch || scan_op == OP_gosub) {
      return FALSE;
    }
    scan_pos += scan_len;
  }
  return FALSE;
}

/* ========================================================================
 * LepusNG peephole optimization helpers (only enabled when LEPUSNG_OPT on)
 * Migrated from quickjs.cc to keep main compiler file clean
 * ======================================================================== */

/* Try to inline a "push + return" pattern at a goto target.
   When the goto target is: <side-effect-free push> return (or return_undef),
   emit the push and return directly at the goto site, eliminating the
   runtime branch.  Only considers push instructions with short encoding
   so the inlined code is not larger than the original goto.
   Returns TRUE if the optimization was applied (caller should break out
   of the switch and skip normal goto emission).
   Updates *out_pos_next, *out_line_num, loc_initialized, and
   var_ref_initialized to reflect the state after the inlined return and dead
   code skip. */
BOOL goto_inline_push_return(LEPUSContext *ctx, JSFunctionDef *s,
                             uint32_t label, const uint8_t *bc_buf, int bc_len,
                             DynBuf *bc_out, int *out_pos_next,
                             int64_t *out_line_num, int pos_next,
                             int64_t line_num, uint8_t *loc_initialized,
                             uint8_t *var_ref_initialized) {
  int tgt_pos = s->label_slots[label].pos2;
  int tgt_op;

  /* Skip OP_label / OP_line_num at target */
  for (;;) {
    if (tgt_pos >= bc_len) return FALSE;
    tgt_op = bc_buf[tgt_pos];
    if (tgt_op != OP_label && tgt_op != OP_line_num) break;
    tgt_pos += opcode_info[tgt_op].size;
  }

  int tgt_size = opcode_info[tgt_op].size;
  int after_pos = tgt_pos + tgt_size;
  int after_op;

  /* Skip OP_label / OP_line_num after the instruction */
  for (;;) {
    if (after_pos >= bc_len) return FALSE;
    after_op = bc_buf[after_pos];
    if (after_op != OP_label && after_op != OP_line_num) break;
    after_pos += opcode_info[after_op].size;
  }

  if (after_op != OP_return && after_op != OP_return_undef) return FALSE;

  int do_inline = 0;
  switch (tgt_op) {
    case OP_undefined:
    case OP_null:
    case OP_push_false:
    case OP_push_true:
    case OP_push_empty_string:
      do_inline = 1;
      break;
    case OP_push_i32: {
      int32_t v = (int32_t)get_u32(bc_buf + tgt_pos + 1);
      if (v >= -1 && v <= 127) do_inline = 1;
      break;
    }
    case OP_get_loc:
    case OP_get_arg:
    case OP_get_var_ref: {
      int idx = get_u16(bc_buf + tgt_pos + 1);
      if (idx < 4)
        do_inline = 1;
      else if (tgt_op == OP_get_loc && idx < 256)
        do_inline = 1;
      break;
    }
    default:
      break;
  }

  if (!do_inline) return FALSE;

  update_label(s, label, -1);
  add_pc2line_info(s, bc_out->size, line_num);
  switch (tgt_op) {
    case OP_undefined:
    case OP_null:
    case OP_push_false:
    case OP_push_true:
    case OP_push_empty_string:
      dbuf_putc(bc_out, tgt_op);
      break;
    case OP_push_i32:
      push_short_int(bc_out, (int32_t)get_u32(bc_buf + tgt_pos + 1));
      break;
    case OP_get_loc:
    case OP_get_arg:
    case OP_get_var_ref:
      put_short_code(bc_out, tgt_op, get_u16(bc_buf + tgt_pos + 1));
      break;
    default:
      break;
  }
  dbuf_putc(bc_out, after_op);
  *out_pos_next = skip_dead_code(s, bc_buf, bc_len, pos_next, out_line_num);
  if (loc_initialized) memset(loc_initialized, 1, s->var_count);
  if (var_ref_initialized) memset(var_ref_initialized, 1, s->closure_var_count);
  return TRUE;
}

/* ========================================================================
 * ESBUILD NULLISH/OPTIONAL CHAINING PATTERN OPTIMIZATION
 * ========================================================================
 *
 * Pattern (standard variant):
 *   put_loc(m) null strict_neq if_false(L1)
 *   get_loc(m) undefined strict_neq if_false(L2)
 *     where L1 == L2
 *     → set_loc(m) null eq if_true(L1)
 *
 * Also handles:
 *   - strict_eq / if_true variant (inverted condition)
 *   - "void 0" variant: get_loc(m) push_i32 drop undefined ...
 *
 * This is the core pattern emitted by esbuild for optional chaining and
 * nullish coalescing.  Two comparisons (null + undefined) are folded into
 * a single null equality comparison, reducing 8 instructions to 4.
 *
 * Returns TRUE if the pattern matched and the optimized code was emitted.
 * On success, *out_end_pos is set past the matched instructions,
 * *out_label is the target label, and *out_line_num is the line number.
 * The caller should set op=OP_if_true, label=*out_label and goto has_label.
 * ======================================================================== */
BOOL try_esbuild_nullish_opt(JSFunctionDef *s, DynBuf *bc_out, CodeContext *cc,
                             int start_pos, uint8_t *loc_initialized,
                             int base_op, int base_idx, int *out_end_pos,
                             int *out_label, int64_t *out_line_num) {
  int m, L1, mid_pos;

  /* Try both strict_neq/if_false and strict_eq/if_true variants */
  if (!(code_match(cc, start_pos, OP_put_loc, -1, OP_null, OP_strict_neq,
                   OP_if_false, -1) ||
        code_match(cc, start_pos, OP_put_loc, -1, OP_null, OP_strict_eq,
                   OP_if_true, -1))) {
    return FALSE;
  }
  m = cc->idx;
  L1 = cc->label;
  mid_pos = cc->pos;

  /* Standard variant: get_loc(m) undefined strict_neq if_false(L2) */
  if ((code_match(cc, mid_pos, OP_get_loc, m, OP_undefined, OP_strict_neq,
                  OP_if_false, -1) ||
       code_match(cc, mid_pos, OP_get_loc, m, OP_undefined, OP_strict_eq,
                  OP_if_true, -1)) &&
      (int)cc->label == L1) {
    goto match_found;
  }

  /* Void 0 variant: get_loc(m) push_i32 drop undefined strict_neq if_false(L2)
   */
  if ((code_match(cc, mid_pos, OP_get_loc, m, OP_push_i32, OP_drop,
                  OP_undefined, OP_strict_neq, OP_if_false, -1) ||
       code_match(cc, mid_pos, OP_get_loc, m, OP_push_i32, OP_drop,
                  OP_undefined, OP_strict_eq, OP_if_true, -1)) &&
      (int)cc->label == L1) {
    goto match_found;
  }

  return FALSE;

match_found:
  if (cc->line_num >= 0) *out_line_num = cc->line_num;
  update_label(s, L1, -1);
  add_pc2line_info(s, bc_out->size, *out_line_num);
  /* Emit base opcode (e.g. get_arg/get_var_ref) if provided */
  if (base_op >= 0) {
    put_short_code(bc_out, base_op, base_idx);
  }
  put_short_code(bc_out, OP_set_loc, m);
  if (loc_initialized && m < s->var_count) loc_initialized[m] = 1;
  dbuf_putc(bc_out, OP_null);
  dbuf_putc(bc_out, OP_eq);
  *out_end_pos = cc->pos;
  *out_label = L1;
  return TRUE;
}

/* Fold dup + const + strict_eq + branch when const is always equal to itself.
   Pattern: dup <const_op> strict_eq [if_true|if_false](L)
   where <const_op> is the same constant value already on stack (null or
   undefined). Since x == x is always true for these constants, the branch is
   always taken. Emits the constant to bc_out and returns via output params:
     *out_branch_label >= 0 → goto this label (always taken)
     *out_branch_label < 0  → never taken (label ref already decremented)
   Returns TRUE if pattern matched. */
BOOL fold_dup_const_strict_eq_branch(CodeContext *cc, int pos_next,
                                     int const_op, JSFunctionDef *s,
                                     DynBuf *bc_out, int64_t line_num,
                                     int *out_pos_next, int64_t *out_line_num,
                                     int *out_branch_label) {
  if (!code_match(cc, pos_next, OP_dup, const_op, OP_strict_eq,
                  M2(OP_if_true, OP_if_false), -1))
    return FALSE;
  if (cc->line_num >= 0) line_num = cc->line_num;
  add_pc2line_info(s, bc_out->size, line_num);
  dbuf_putc(bc_out, const_op);
  *out_pos_next = cc->pos;
  *out_line_num = line_num;
  if (cc->op == OP_if_true) {
    /* always true → always taken */
    *out_branch_label = cc->label;
  } else {
    /* always true, but if_false → never taken */
    update_label(s, cc->label, -1);
    *out_branch_label = -1;
  }
  return TRUE;
}

/* Mark a local variable as initialized.  Also tracks permanent initialization
   for single-TDZ vars written before the first backward-edge label, allowing
   later passes to skip TDZ markers entirely. */
void mark_loc_written(uint8_t *loc_initialized, BytecodeOptCtx *opt_ctx,
                      BOOL before_first_backward_label, int idx,
                      int var_count) {
  if (loc_initialized && idx < var_count) loc_initialized[idx] = 1;
  if (before_first_backward_label && opt_ctx->loc_perm_written &&
      idx < var_count && opt_ctx->loc_permanently_init[idx])
    opt_ctx->loc_perm_written[idx] = 1;
}

/* Try to downgrade a put_loc_check / put_loc_check_init to put_loc / set_loc.
   Pattern (after downgrade): put_loc(n) get_loc_check(n)?/get_loc(n)? drop?
   Scans for:
     - get_loc_check(n)/get_loc(n) + drop → emit put_loc(n) (both consumed)
     - get_loc_check(n)/get_loc(n)        → emit set_loc(n) (value stays)
     - neither                             → emit put_loc(n) (just downgrade)
   Returns TRUE if downgraded (already emitted the result, caller should break).
   If mark_perm_init is TRUE, also marks loc_perm_written for pre-label init. */
BOOL try_downgrade_put_loc_check(CodeContext *cc, int pos_next, int idx,
                                 JSFunctionDef *s, DynBuf *bc_out,
                                 int64_t line_num, uint8_t *loc_initialized,
                                 BytecodeOptCtx *opt_ctx,
                                 BOOL before_first_backward_label,
                                 BOOL mark_perm_init, int *out_pos_next,
                                 int64_t *out_line_num) {
  BOOL track_perm = mark_perm_init && before_first_backward_label;
  /* put_loc(n) + get_loc_check(n)/get_loc(n) + drop → put_loc(n) */
  if (code_match(cc, pos_next, M2(OP_get_loc_check, OP_get_loc), idx, OP_drop,
                 -1)) {
    if (cc->line_num >= 0) line_num = cc->line_num;
    add_pc2line_info(s, bc_out->size, line_num);
    put_short_code(bc_out, OP_put_loc, idx);
    *out_pos_next = cc->pos;
    *out_line_num = line_num;
    mark_loc_written(loc_initialized, opt_ctx, track_perm, idx, s->var_count);
    return TRUE;
  }
  /* put_loc(n) + get_loc_check(n)/get_loc(n) → set_loc(n) */
  if (code_match(cc, pos_next, M2(OP_get_loc_check, OP_get_loc), idx, -1)) {
    if (cc->line_num >= 0) line_num = cc->line_num;
    add_pc2line_info(s, bc_out->size, line_num);
    put_short_code(bc_out, OP_set_loc, idx);
    *out_pos_next = cc->pos;
    *out_line_num = line_num;
    mark_loc_written(loc_initialized, opt_ctx, track_perm, idx, s->var_count);
    return TRUE;
  }
  /* Just downgrade to put_loc(n) */
  add_pc2line_info(s, bc_out->size, line_num);
  put_short_code(bc_out, OP_put_loc, idx);
  *out_pos_next = pos_next;
  *out_line_num = line_num;
  mark_loc_written(loc_initialized, opt_ctx, track_perm, idx, s->var_count);
  return TRUE;
}

/* Fold a unary op (OP_lnot / OP_not / OP_neg) applied to a known integer
   constant. Emits the folded result to bc_out and returns TRUE if folded. For
   OP_lnot: emits push_true / push_false (based on val == 0) For OP_not:  emits
   push_i32(~val) For OP_neg:  emits push_i32(-val), guarded against INT32_MIN
   and 0 Caller provides the integer constant value and the unary opcode. */
BOOL try_fold_unary_on_int_const(CodeContext *cc, int pos_next, int unary_op,
                                 int32_t val, JSFunctionDef *s, DynBuf *bc_out,
                                 int64_t line_num, int *out_pos_next,
                                 int64_t *out_line_num) {
  if (!code_match(cc, pos_next, unary_op, -1)) return FALSE;
  if (cc->line_num >= 0) line_num = cc->line_num;
  add_pc2line_info(s, bc_out->size, line_num);
  switch (unary_op) {
    case OP_lnot:
      dbuf_putc(bc_out, val == 0 ? OP_push_true : OP_push_false);
      break;
    case OP_not:
      push_short_int(bc_out, ~val);
      break;
    case OP_neg:
      if (val == INT32_MIN || val == 0) return FALSE;
      push_short_int(bc_out, -val);
      break;
    default:
      return FALSE;
  }
  *out_pos_next = cc->pos;
  *out_line_num = line_num;
  return TRUE;
}

/* Scan forward from start_pos for a chain of drops (and line_num markers)
   followed by OP_return_undef.  Drops before return_undef are redundant
   because frame teardown frees all stack values.
   Stops at any label (join point where stack depth may differ).
   Returns the position of the return_undef if found, or -1 if not found. */
int scan_drop_chain_before_return_undef(const uint8_t *bc_buf, int bc_len,
                                        int start_pos) {
  int scan = start_pos;
  while (scan < bc_len) {
    int scan_op = bc_buf[scan];
    if (scan_op == OP_drop) {
      scan += 1;
      continue;
    }
    if (scan_op == OP_line_num) {
      scan += opcode_info[OP_line_num].size;
      continue;
    }
    break;
  }
  if (scan < bc_len && bc_buf[scan] == OP_return_undef) return scan;
  return -1;
}

/* Record a set_loc_uninitialized position for post-pass dead SLU elimination.
   Grows the slu_records array as needed. */
void record_slu_position(LEPUSContext *ctx, BytecodeOptCtx *opt_ctx,
                         int bc_out_pos, int var_idx) {
  if (opt_ctx->slu_pos_count >= opt_ctx->slu_pos_size) {
    int new_size = opt_ctx->slu_pos_size ? opt_ctx->slu_pos_size * 2 : 32;
    SLURecord *tmp = static_cast<SLURecord *>(
        lepus_realloc(ctx, opt_ctx->slu_records, new_size * sizeof(SLURecord),
                      ALLOC_TAG_WITHOUT_PTR));
    if (tmp) {
      opt_ctx->slu_records = tmp;
      opt_ctx->slu_pos_size = new_size;
    }
  }
  if (opt_ctx->slu_pos_count < opt_ctx->slu_pos_size) {
    opt_ctx->slu_records[opt_ctx->slu_pos_count].bc_out_pos = bc_out_pos;
    opt_ctx->slu_records[opt_ctx->slu_pos_count].var_idx = var_idx;
    opt_ctx->slu_pos_count++;
  }
}

/* Fold dup put_loc_check(n)/put_var_ref_check(n) drop →
   put_loc_check(n)/put_var_ref_check(n). The dup+drop is redundant.  Also
   performs DSE: if the variable is never read, replace the whole sequence with
   a single drop.  Marks the variable as initialized. Returns TRUE if the
   pattern was matched and emitted (caller should break). */
BOOL try_dup_put_check_drop(CodeContext *cc, int pos_next, JSFunctionDef *s,
                            DynBuf *bc_out, int64_t line_num,
                            uint8_t *loc_initialized,
                            uint8_t *var_ref_initialized,
                            BytecodeOptCtx *opt_ctx,
                            BOOL before_first_backward_label, int *out_pos_next,
                            int64_t *out_line_num) {
  if (!code_match(cc, pos_next,
                  M4(OP_put_loc_check, OP_put_loc_check_init,
                     OP_put_var_ref_check, OP_put_var_ref_check_init),
                  -1, -1))
    return FALSE;
  int plc_op = cc->op;
  int plc_idx = cc->idx;
  if (!code_match(cc, cc->pos, OP_drop, -1)) return FALSE;
  if (cc->line_num >= 0) line_num = cc->line_num;
  *out_pos_next = cc->pos;
  /* DSE: if this local is never read, eliminate the dead store */
  if ((plc_op == OP_put_loc_check || plc_op == OP_put_loc_check_init) &&
      opt_ctx->var_is_read && plc_idx < s->var_count &&
      !opt_ctx->var_is_read[plc_idx]) {
    add_pc2line_info(s, bc_out->size, line_num);
    dbuf_putc(bc_out, OP_drop);
    *out_line_num = line_num;
    return TRUE;
  }
  add_pc2line_info(s, bc_out->size, line_num);
  dbuf_putc(bc_out, plc_op);
  dbuf_put_u16(bc_out, plc_idx);
  /* Mark local as initialized */
  if (plc_op == OP_put_loc_check || plc_op == OP_put_loc_check_init)
    mark_loc_written(loc_initialized, opt_ctx, before_first_backward_label,
                     plc_idx, s->var_count);
  /* Mark closure var as initialized */
  if ((plc_op == OP_put_var_ref_check || plc_op == OP_put_var_ref_check_init) &&
      var_ref_initialized && plc_idx < s->closure_var_count)
    var_ref_initialized[plc_idx] = 1;
  *out_line_num = line_num;
  return TRUE;
}

/* Pattern: undefined/void-0 goto(L) where L targets OP_return/OP_return_undef.
   Folds to return_undef (undefined is already on stack but discarded by
   return). After emitting return_undef, skips dead code after the goto and
   resets initialized-state tracking to "all initialized" (control flow
   terminates). Returns TRUE if folded (caller should break). */
BOOL try_fold_undefined_goto_return(CodeContext *cc, int pos_next,
                                    JSFunctionDef *s, DynBuf *bc_out,
                                    const uint8_t *bc_buf, int bc_len,
                                    int64_t line_num, uint8_t *loc_initialized,
                                    uint8_t *var_ref_initialized,
                                    int *out_pos_next, int64_t *out_line_num) {
  if (!code_match(cc, pos_next, OP_goto, -1)) return FALSE;
  int64_t line1 = -1;
  int orig_label = cc->label;
  int target_op;
  int target_label = find_jump_target(s, cc->label, &target_op, &line1);
  if (target_op != OP_return && target_op != OP_return_undef) {
    /* find_jump_target shifted ref_count from orig_label to target_label; undo
     * it */
    update_label(s, target_label, -1);
    update_label(s, orig_label, +1);
    return FALSE;
  }
  if (cc->line_num >= 0) line_num = cc->line_num;
  update_label(s, target_label, -1);
  add_pc2line_info(s, bc_out->size, line_num);
  dbuf_putc(bc_out, OP_return_undef);
  int p = cc->pos;
  p = skip_dead_code(s, bc_buf, bc_len, p, &line_num);
  if (loc_initialized) memset(loc_initialized, 1, s->var_count);
  if (var_ref_initialized) memset(var_ref_initialized, 1, s->closure_var_count);
  *out_pos_next = p;
  *out_line_num = line_num;
  return TRUE;
}

/* Fold <const> strict_neq patterns for null/undefined checks (standalone, i.e.
   not already matched by the SHORT_OPCODES if_X variants):
     const strict_neq if_false(l) → is_const if_true(l)   (lnot folded into
   branch) const strict_neq if_true(l)  → is_const if_false(l) const strict_neq
   → is_const lnot where const_op is OP_null/OP_undefined and is_op is
   OP_is_null/OP_is_undefined. Returns TRUE if matched; caller should break/goto
   has_label accordingly. */
BOOL try_const_strict_neq_standalone(CodeContext *cc, int pos_next, int is_op,
                                     JSFunctionDef *s, DynBuf *bc_out,
                                     int64_t line_num, int *out_op,
                                     int *out_label, int *out_pos_next,
                                     int64_t *out_line_num,
                                     BOOL *out_has_label) {
  if (!code_match(cc, pos_next, OP_strict_neq, -1)) return FALSE;
  if (cc->line_num >= 0) line_num = cc->line_num;
  int neq_end = cc->pos;
  if (code_match(cc, neq_end, M2(OP_if_false, OP_if_true), -1)) {
    /* strict_neq + branch → is_const + inverted branch (lnot folded in) */
    if (cc->line_num >= 0) line_num = cc->line_num;
    add_pc2line_info(s, bc_out->size, line_num);
    dbuf_putc(bc_out, is_op);
    *out_pos_next = cc->pos;
    *out_label = cc->label;
    *out_op = cc->op ^ OP_if_false ^ OP_if_true;
    *out_has_label = TRUE;
    *out_line_num = line_num;
    return TRUE;
  }
  /* standalone strict_neq → is_const lnot */
  add_pc2line_info(s, bc_out->size, line_num);
  dbuf_putc(bc_out, is_op);
  dbuf_putc(bc_out, OP_lnot);
  *out_pos_next = neq_end;
  *out_has_label = FALSE;
  *out_line_num = line_num;
  return TRUE;
}

/* Try to fold lnot + branch patterns:
     lnot lnot if_X(l) → if_X(l)     (double negation identity)
     lnot if_false(l)  → if_true(l)   (branch inversion)
     lnot if_true(l)   → if_false(l)
   Returns TRUE if matched, with out_op/out_label set to the new branch.
   Consumes 1-2 lnot instructions + the branch instruction. */
BOOL try_lnot_branch_invert(CodeContext *cc, int pos_next, int *out_op,
                            int *out_label, int *out_pos_next,
                            int64_t *out_line_num) {
  int pos = pos_next;
  int64_t line = -1;
  int lnot_count = 0;
  /* Consume 0, 1, or 2 lnots (0 = no match, just check branch) */
  while (lnot_count < 2 && code_match(cc, pos, OP_lnot, -1)) {
    if (cc->line_num >= 0) line = cc->line_num;
    pos = cc->pos;
    lnot_count++;
  }
  if (lnot_count == 0) return FALSE;
  /* Check for branch instruction */
  if (!code_match(cc, pos, M2(OP_if_false, OP_if_true), -1)) return FALSE;
  if (cc->line_num >= 0) line = cc->line_num;
  *out_label = cc->label;
  *out_op =
      (lnot_count % 2 == 0) ? cc->op : (cc->op ^ OP_if_false ^ OP_if_true);
  *out_pos_next = cc->pos;
  *out_line_num = line >= 0 ? line : *out_line_num;
  return TRUE;
}

/* Consume a cascade of lnot instructions starting at start_pos.
   Applies each lnot to initial_truthy (0 or 1).
   Returns TRUE if any lnot was consumed, with:
     *out_final_val: final boolean value after all lnots
     *out_skip_bytes: total bytes consumed
     *out_line_num: line number of the last consumed lnot (if >= 0)
   Returns FALSE if no lnot at start_pos (nothing changed). */
BOOL try_consume_lnot_cascade(CodeContext *cc, int start_pos,
                              int initial_truthy, int *out_final_val,
                              int *out_skip_bytes, int64_t *out_line_num) {
  int val = initial_truthy;
  int pos = start_pos;
  BOOL found = FALSE;
  while (code_match(cc, pos, OP_lnot, -1)) {
    if (cc->line_num >= 0) *out_line_num = cc->line_num;
    val = !val;
    pos = cc->pos;
    found = TRUE;
  }
  if (!found) return FALSE;
  *out_final_val = val;
  *out_skip_bytes = pos - start_pos;
  return TRUE;
}

/* High-level helper: fold a known truthy constant + lnot cascade + optional
   branch. Handles emission and label bookkeeping internally. Returns TRUE if
   folded, with: *out_pos_next, *out_line_num: updated position and line
     *out_branch_label: >= 0 means branch always taken (goto this label)
                        < 0 means either no branch (emitted push_bool) or never
   taken For never-taken branches: calls update_label(s, label, -1) internally.
   For no-branch lnot cascade: emits push_true/push_false to bc_out. */
BOOL fold_const_truthy(CodeContext *cc, int pos_next, int initial_truthy,
                       JSFunctionDef *s, DynBuf *bc_out, int64_t line_num,
                       int *out_pos_next, int64_t *out_line_num,
                       int *out_branch_label) {
  int final_val, skip_bytes;
  int64_t fold_line = -1;
  *out_branch_label = -1;
  if (!try_consume_lnot_cascade(cc, pos_next, initial_truthy, &final_val,
                                &skip_bytes, &fold_line))
    return FALSE;
  if (fold_line >= 0) line_num = fold_line;
  pos_next += skip_bytes;
  /* Check for optional branch instruction */
  if (code_match(cc, pos_next, M2(OP_if_false, OP_if_true), -1)) {
    int branch_is_true = (cc->op == OP_if_true);
    if (cc->line_num >= 0) line_num = cc->line_num;
    pos_next = cc->pos;
    if (final_val == branch_is_true) {
      /* always taken */
      *out_branch_label = cc->label;
    } else {
      /* never taken — decrement label ref */
      update_label(s, cc->label, -1);
    }
    *out_pos_next = pos_next;
    *out_line_num = line_num;
    return TRUE;
  }
  /* No branch: emit push_true/push_false */
  add_pc2line_info(s, bc_out->size, line_num);
  dbuf_putc(bc_out, final_val ? OP_push_true : OP_push_false);
  *out_pos_next = pos_next;
  *out_line_num = line_num;
  return TRUE;
}

/* Eliminate set_loc_uninitialized(n) when immediately followed by a
   side-effect-free instruction and put_loc(n)/set_loc(n).
   The TDZ window is empty — no get_loc_check(n) can fire between
   uninitialization and the write, so the TDZ marker is dead.
   Also checks the extended forward-scan case (opt_tdz_inline_can_eliminate).
   Returns TRUE if the SLU should be eliminated (caller should break). */
BOOL try_eliminate_slu_dead(CodeContext *cc, int pos_next, int idx,
                            JSFunctionDef *s, const uint8_t *bc_buf,
                            int bc_len) {
  /* Immediate patterns: <const-or-pure-read> put_loc(n)/set_loc(n) */
  if (code_match(cc, pos_next, OP_undefined, M2(OP_put_loc, OP_set_loc), idx,
                 -1) ||
      code_match(cc, pos_next, OP_null, M2(OP_put_loc, OP_set_loc), idx, -1) ||
      code_match(cc, pos_next, OP_push_i32, M2(OP_put_loc, OP_set_loc), idx,
                 -1) ||
      code_match(cc, pos_next, OP_push_atom_value, M2(OP_put_loc, OP_set_loc),
                 idx, -1) ||
      code_match(cc, pos_next, OP_get_arg, -1, M2(OP_put_loc, OP_set_loc), idx,
                 -1) ||
      code_match(cc, pos_next, OP_get_loc, -1, M2(OP_put_loc, OP_set_loc), idx,
                 -1) ||
      code_match(cc, pos_next, OP_get_var_ref, -1, M2(OP_put_loc, OP_set_loc),
                 idx, -1) ||
      code_match(cc, pos_next, OP_push_0, M2(OP_put_loc, OP_set_loc), idx,
                 -1) ||
      code_match(cc, pos_next, OP_push_1, M2(OP_put_loc, OP_set_loc), idx,
                 -1) ||
      code_match(cc, pos_next, OP_push_empty_string, M2(OP_put_loc, OP_set_loc),
                 idx, -1) ||
      (code_match(cc, pos_next, OP_get_var, M2(OP_put_loc, OP_set_loc), idx,
                  -1) &&
       cc->atom == JS_ATOM_undefined)) {
    return TRUE;
  }
  /* Extended scan: search forward within the basic block for a write.
     Only safe when the variable is NOT captured (closure could observe TDZ). */
  if (idx < s->var_count && !s->vars[idx].is_captured) {
    if (opt_tdz_inline_can_eliminate(s, bc_buf, bc_len, pos_next, idx))
      return TRUE;
  }
  return FALSE;
}

/* Try to constant-fold lnot when the operand is a tracked integer constant.
   Three cases:
     1. lnot lnot if_X(l) → rewind, set *out_val = (const != 0), goto
   has_constant_test
     2. lnot if_X(l)      → rewind, set *out_val = (const == 0), goto
   has_constant_test
     3. lnot (standalone) → rewind, emit push_true/push_false, caller breaks
   Returns:
     0 = no match
     1 = matched case 1 or 2 (caller sets val = *out_val and goto
   has_constant_test) 2 = matched case 3 (already emitted, caller should break)
   On match, resets const_fold tracker and updates cf_emit_start, pos_next,
   line_num. */
int try_fold_lnot_on_const(CodeContext *cc, int pos_next, int32_t const_val,
                           JSFunctionDef *s, DynBuf *bc_out, int cf_pos2,
                           int *cf_emit_start, int *out_cf_pos1,
                           int *out_cf_pos2, int64_t line_num, int32_t *out_val,
                           int *out_pos_next, int64_t *out_line_num) {
  if (cf_pos2 < 0) return 0;
  /* Case 1: lnot lnot if_X(l) → constant branch test (double negation) */
  if (code_match(cc, pos_next, OP_lnot, M2(OP_if_false, OP_if_true), -1)) {
    if (cc->line_num >= 0) line_num = cc->line_num;
    bc_out->size = cf_pos2;
    *cf_emit_start = bc_out->size;
    *out_cf_pos1 = -1;
    *out_cf_pos2 = -1;
    *out_val = (const_val != 0);
    *out_pos_next = cc->pos;
    *out_line_num = line_num;
    return 1;
  }
  /* Case 2: lnot if_X(l) → constant branch test */
  if (code_match(cc, pos_next, M2(OP_if_false, OP_if_true), -1)) {
    if (cc->line_num >= 0) line_num = cc->line_num;
    bc_out->size = cf_pos2;
    *cf_emit_start = bc_out->size;
    *out_cf_pos1 = -1;
    *out_cf_pos2 = -1;
    *out_val = (const_val == 0);
    *out_pos_next = cc->pos;
    *out_line_num = line_num;
    return 1;
  }
  /* Case 3: standalone lnot → push_true/push_false */
  bc_out->size = cf_pos2;
  add_pc2line_info(s, bc_out->size, line_num);
  dbuf_putc(bc_out, const_val ? OP_push_false : OP_push_true);
  *out_cf_pos1 = -1;
  *out_cf_pos2 = -1;
  *cf_emit_start = bc_out->size;
  *out_pos_next = pos_next;
  *out_line_num = line_num;
  return 2;
}

/* Pattern: dup put_var(a) drop → put_var(a)
   The dup+drop is redundant (value already consumed by put_var).
   Returns TRUE if matched (caller should break). */
BOOL try_dup_put_var_drop(CodeContext *cc, int pos_next, JSFunctionDef *s,
                          DynBuf *bc_out, int64_t line_num, int *out_pos_next,
                          int64_t *out_line_num) {
  if (!code_match(cc, pos_next, OP_put_var, OP_drop, -1)) return FALSE;
  if (cc->line_num >= 0) line_num = cc->line_num;
  add_pc2line_info(s, bc_out->size, line_num);
  dbuf_putc(bc_out, OP_put_var);
  dbuf_put_u32(bc_out, cc->atom);
  *out_pos_next = cc->pos;
  *out_line_num = line_num;
  return TRUE;
}

/* Downgrade get_loc_check(n) to get_loc(n) when variable n is provably
   initialized.  Also handles dead load: get_loc_check(n) drop → nothing.
   Returns:
     0 = no match (get_loc_check cannot be optimized at this position)
     1 = matched dead load (get_loc_check drop, nothing emitted, caller breaks)
     2 = matched downgrade (get_loc emitted, caller breaks) */
int try_downgrade_get_loc_check(CodeContext *cc, int pos_next, int idx,
                                JSFunctionDef *s, DynBuf *bc_out,
                                uint8_t *loc_initialized, int64_t line_num,
                                int *out_pos_next, int64_t *out_line_num) {
  if (!loc_initialized || idx >= s->var_count || !loc_initialized[idx])
    return 0;
  /* Dead load: get_loc_check(n) drop → nothing */
  if (code_match(cc, pos_next, OP_drop, -1)) {
    if (cc->line_num >= 0) line_num = cc->line_num;
    *out_pos_next = cc->pos;
    *out_line_num = line_num;
    return 1;
  }
  /* Downgrade to get_loc(n) */
  add_pc2line_info(s, bc_out->size, line_num);
  put_short_code(bc_out, OP_get_loc, idx);
  *out_pos_next = pos_next;
  *out_line_num = line_num;
  return 2;
}

/* Downgrade put_var_ref_check(n) to put_var_ref(n) when the closure variable
   is provably initialized.  Always marks the variable as initialized regardless
   of downgrade.
   Returns TRUE if downgraded (caller should break). */
BOOL try_downgrade_put_var_ref_check(CodeContext *cc, int pos_next, int idx,
                                     JSFunctionDef *s, DynBuf *bc_out,
                                     uint8_t *var_ref_initialized,
                                     int64_t line_num, int *out_pos_next,
                                     int64_t *out_line_num) {
  if (var_ref_initialized && idx < s->closure_var_count &&
      var_ref_initialized[idx]) {
    add_pc2line_info(s, bc_out->size, line_num);
    put_short_code(bc_out, OP_put_var_ref, idx);
    *out_pos_next = pos_next;
    *out_line_num = line_num;
    return TRUE;
  }
  if (var_ref_initialized && idx < s->closure_var_count)
    var_ref_initialized[idx] = 1;
  return FALSE;
}

/* Downgrade get_var_ref_check(n) to get_var_ref(n) when the closure variable
   is provably initialized.
   Returns TRUE if downgraded (caller should break). */
BOOL try_downgrade_get_var_ref_check(CodeContext *cc, int pos_next, int idx,
                                     JSFunctionDef *s, DynBuf *bc_out,
                                     uint8_t *var_ref_initialized,
                                     int64_t line_num, int *out_pos_next,
                                     int64_t *out_line_num) {
  if (!var_ref_initialized || idx >= s->closure_var_count ||
      !var_ref_initialized[idx])
    return FALSE;
  add_pc2line_info(s, bc_out->size, line_num);
  put_short_code(bc_out, OP_get_var_ref, idx);
  *out_pos_next = pos_next;
  *out_line_num = line_num;
  return TRUE;
}

/* After a put_loc_check(n) that we are NOT downgrading, fold redundant
   get_loc_check(n) patterns that follow immediately.  At runtime the write
   already succeeded (or threw), so the subsequent TDZ check is guaranteed
   to pass.
   Patterns:
     put_loc_check(n) get_loc_check(n) drop → put_loc_check(n) (dead read)
     put_loc_check(n) get_loc_check(n)      → set_loc(n)        (write+read)
   Returns:
     0 = no match (caller should emit put_loc_check via no_change)
     1 = matched dead-read pattern (caller should goto no_change)
     2 = matched set_loc pattern (set_loc already emitted, caller should break)
 */
int try_fold_put_check_peephole(CodeContext *cc, int pos_next, int idx,
                                JSFunctionDef *s, DynBuf *bc_out,
                                int64_t line_num, int *out_pos_next,
                                int64_t *out_line_num) {
  /* put_loc_check(n) get_loc_check(n) drop → put_loc_check(n) */
  if (code_match(cc, pos_next, OP_get_loc_check, idx, OP_drop, -1)) {
    if (cc->line_num >= 0) line_num = cc->line_num;
    *out_pos_next = cc->pos;
    *out_line_num = line_num;
    return 1;
  }
  /* put_loc_check(n) get_loc_check(n) → set_loc(n) */
  if (code_match(cc, pos_next, OP_get_loc_check, idx, -1)) {
    if (cc->line_num >= 0) line_num = cc->line_num;
    add_pc2line_info(s, bc_out->size, line_num);
    put_short_code(bc_out, OP_set_loc, idx);
    *out_pos_next = cc->pos;
    *out_line_num = line_num;
    return 2;
  }
  return 0;
}

/* Full handler for OP_put_loc_check / OP_put_loc_check_init in optimize mode.
   Applies all applicable optimizations in order:
     1. DSE: if local is never read, emit drop (consume value, skip store)
     2. put_loc_check_init → put_loc when provably uninitialized (first const
   write)
     3. put_loc_check → put_loc when provably initialized (TDZ check dead)
     4. Mark local as initialized
     5. Fold redundant get_loc_check(n) immediately after the write
   Returns:
     0 = no optimization applied (caller falls through to mark+no_change)
     1 = DSE emitted drop (caller breaks)
     2 = downgraded to put_loc/set_loc (caller breaks)
     3 = peephole matched dead read (caller goto no_change)
     4 = peephole matched set_loc (caller breaks) */
int try_handle_put_loc_check(CodeContext *cc, int op, int pos_next, int idx,
                             JSFunctionDef *s, DynBuf *bc_out,
                             uint8_t *loc_initialized, BytecodeOptCtx *opt_ctx,
                             BOOL before_first_backward_label, int64_t line_num,
                             int *out_pos_next, int64_t *out_line_num) {
  /* DSE: if this local is never read, replace with drop */
  if (opt_ctx->var_is_read && idx < s->var_count &&
      !opt_ctx->var_is_read[idx]) {
    add_pc2line_info(s, bc_out->size, line_num);
    dbuf_putc(bc_out, OP_drop);
    return 1;
  }

  /* Downgrade put_loc_check_init(n) to put_loc(n) when the variable is
     provably NOT initialized — the "already initialized?" check cannot fire.
     NOT safe for captured variables: a closure can observe TDZ state.
     NOT safe for this_var in derived class constructors: the check detects
     double super() calls (this already initialized → ReferenceError). */
  if (op == OP_put_loc_check_init && loc_initialized && idx < s->var_count &&
      !loc_initialized[idx] && !s->vars[idx].is_captured &&
      !(idx == s->this_var_idx && s->is_derived_class_constructor)) {
    try_downgrade_put_loc_check(
        cc, pos_next, idx, s, bc_out, line_num, loc_initialized, opt_ctx,
        before_first_backward_label, TRUE, out_pos_next, out_line_num);
    return 2;
  }

  /* Downgrade put_loc_check(n) to put_loc(n) when variable is provably
     initialized — TDZ check cannot fire. NOT for put_loc_check_init. */
  if (op == OP_put_loc_check && loc_initialized && idx < s->var_count &&
      loc_initialized[idx]) {
    try_downgrade_put_loc_check(
        cc, pos_next, idx, s, bc_out, line_num, loc_initialized, opt_ctx,
        before_first_backward_label, FALSE, out_pos_next, out_line_num);
    return 2;
  }

  /* Mark as initialized (first write in this block) */
  mark_loc_written(loc_initialized, opt_ctx, before_first_backward_label, idx,
                   s->var_count);

  /* Fold redundant get_loc_check(n) immediately after the write */
  int rv = try_fold_put_check_peephole(cc, pos_next, idx, s, bc_out, line_num,
                                       out_pos_next, out_line_num);
  if (rv == 1) return 3;
  if (rv == 2) return 4;
  return 0;
}

/* Try to eliminate a set_loc_uninitialized (SLU / TDZ marker) instruction.
   Patterns:
     1. DSE: local is never read anywhere → skip the marker entirely
     2. Adjacent-write: next write to same local comes before any possible read
   Returns TRUE if the SLU was eliminated (caller should break, no emit). */
BOOL try_eliminate_slu(CodeContext *cc, int pos_next, int idx, JSFunctionDef *s,
                       const uint8_t *bc_buf, int bc_len,
                       BytecodeOptCtx *opt_ctx) {
  /* DSE: if this local is never read, skip TDZ marker entirely */
  if (opt_ctx->var_is_read && idx < s->var_count && !opt_ctx->var_is_read[idx])
    return TRUE;
  /* Adjacent-write elimination: next write guaranteed before any read */
  return try_eliminate_slu_dead(cc, pos_next, idx, s, bc_buf, bc_len);
}

/* ========================================================================
 * Hook function implementations for resolve_labels()
 * ======================================================================== */

BOOL lepusng_opt_resolve_labels_init(BytecodeOptCtx *opt_ctx, LEPUSContext *ctx,
                                     JSFunctionDef *s, const uint8_t *bc_buf,
                                     int bc_len, DynBuf *bc_out) {
  memset(opt_ctx, 0, sizeof(*opt_ctx));
  opt_ctx->s = s;
  opt_ctx->ctx = ctx;
  opt_ctx->before_first_backward_label = TRUE;
  opt_ctx->preamble_skip_pos = -1;
  opt_ctx->const_fold_pos1 = -1;
  opt_ctx->const_fold_pos2 = -1;

  if (!OPTIMIZE || !ctx->is_lepusng || !ctx->opt_lepusng_package_size)
    return FALSE;

  if (s->var_count > 0) {
    opt_ctx->loc_initialized = static_cast<uint8_t *>(
        lepus_mallocz(ctx, s->var_count, ALLOC_TAG_WITHOUT_PTR));
    if (!opt_ctx->loc_initialized) return FALSE;
    if (s->label_count > 0) {
      opt_ctx->label_init_state = static_cast<uint8_t **>(lepus_mallocz(
          ctx, s->label_count * sizeof(uint8_t *), ALLOC_TAG_WITHOUT_PTR));
      opt_ctx->label_fwd_refs = static_cast<int *>(lepus_mallocz(
          ctx, s->label_count * sizeof(int), ALLOC_TAG_WITHOUT_PTR));
      if (opt_ctx->label_init_state && !opt_ctx->label_fwd_refs) {
        lepus_free(ctx, opt_ctx->label_init_state);
        opt_ctx->label_init_state = NULL;
      }
    }
  }
  if (s->closure_var_count > 0) {
    opt_ctx->var_ref_initialized = static_cast<uint8_t *>(
        lepus_mallocz(ctx, s->closure_var_count, ALLOC_TAG_WITHOUT_PTR));
    if (opt_ctx->var_ref_initialized && s->label_count > 0) {
      opt_ctx->label_var_ref_init_state = static_cast<uint8_t **>(lepus_mallocz(
          ctx, s->label_count * sizeof(uint8_t *), ALLOC_TAG_WITHOUT_PTR));
      if (!opt_ctx->label_fwd_refs)
        opt_ctx->label_fwd_refs = static_cast<int *>(lepus_mallocz(
            ctx, s->label_count * sizeof(int), ALLOC_TAG_WITHOUT_PTR));
      if (opt_ctx->label_var_ref_init_state && !opt_ctx->label_fwd_refs) {
        lepus_free(ctx, opt_ctx->label_var_ref_init_state);
        opt_ctx->label_var_ref_init_state = NULL;
      }
    }
  }

  /* Mark preamble-initialized locals so get_loc_check can be downgraded */
  if (opt_ctx->loc_initialized) {
    if (s->this_var_idx >= 0 && !s->is_derived_class_constructor &&
        s->this_var_idx < s->var_count)
      opt_ctx->loc_initialized[s->this_var_idx] = 1;
    if (s->arguments_var_idx >= 0 && s->arguments_var_idx < s->var_count)
      opt_ctx->loc_initialized[s->arguments_var_idx] = 1;
    if (s->new_target_var_idx >= 0 && s->new_target_var_idx < s->var_count)
      opt_ctx->loc_initialized[s->new_target_var_idx] = 1;
    if (s->func_var_idx >= 0 && s->func_var_idx < s->var_count)
      opt_ctx->loc_initialized[s->func_var_idx] = 1;
    if (s->home_object_var_idx >= 0 && s->home_object_var_idx < s->var_count)
      opt_ctx->loc_initialized[s->home_object_var_idx] = 1;
    if (s->this_active_func_var_idx >= 0 &&
        s->this_active_func_var_idx < s->var_count)
      opt_ctx->loc_initialized[s->this_active_func_var_idx] = 1;
  }

  if (s->var_count > 0 && opt_ctx->loc_initialized)
    opt_prescan_tdz_dse(opt_ctx, bc_buf, bc_len);

  if (s->var_count > 4 && !s->has_eval_call && s->this_var_idx < 0 &&
      s->new_target_var_idx < 0 && s->home_object_var_idx < 0 &&
      s->this_active_func_var_idx < 0 && s->arguments_var_idx < 0 &&
      s->func_var_idx < 0 && s->var_object_idx < 0 && s->arg_var_object_idx < 0)
    opt_reorder_local_vars(opt_ctx, bc_buf, bc_len);

  if (s->closure_var_count > 4 && !s->has_eval_call)
    opt_reorder_closure_vars(opt_ctx, bc_buf, bc_len);

  if (s->cpool_count > 256) opt_reorder_cpool(opt_ctx, bc_buf, bc_len);

  return TRUE;
}

void lepusng_opt_resolve_labels_finish(BytecodeOptCtx *opt_ctx, DynBuf *bc_out,
                                       BOOL run_post_pipeline) {
  LEPUSContext *ctx = opt_ctx->ctx;
  JSFunctionDef *s = opt_ctx->s;

  /* Run dead SLU elimination first (uses SLU records collected during emission)
   */
  if (run_post_pipeline) {
    opt_dead_slu_elim(ctx, s, bc_out, opt_ctx->slu_records,
                      opt_ctx->slu_pos_count);
  }

  /* Free all owned arrays */
  if (opt_ctx->loc_permanently_init)
    lepus_free(ctx, opt_ctx->loc_permanently_init);
  if (opt_ctx->loc_perm_written) lepus_free(ctx, opt_ctx->loc_perm_written);
  if (opt_ctx->var_is_read) lepus_free(ctx, opt_ctx->var_is_read);
  if (opt_ctx->slu_records) lepus_free(ctx, opt_ctx->slu_records);
  if (opt_ctx->loc_initialized) lepus_free(ctx, opt_ctx->loc_initialized);
  if (opt_ctx->var_ref_initialized)
    lepus_free(ctx, opt_ctx->var_ref_initialized);
  if (opt_ctx->label_init_state) {
    for (int i = 0; i < s->label_count; i++) {
      if (opt_ctx->label_init_state[i])
        lepus_free(ctx, opt_ctx->label_init_state[i]);
    }
    lepus_free(ctx, opt_ctx->label_init_state);
  }
  if (opt_ctx->label_var_ref_init_state) {
    for (int i = 0; i < s->label_count; i++) {
      if (opt_ctx->label_var_ref_init_state[i])
        lepus_free(ctx, opt_ctx->label_var_ref_init_state[i]);
    }
    lepus_free(ctx, opt_ctx->label_var_ref_init_state);
  }
  if (opt_ctx->label_fwd_refs) lepus_free(ctx, opt_ctx->label_fwd_refs);

  /* Run remaining post-pipeline passes after freeing intermediate data */
  if (run_post_pipeline) {
    lepusng_run_bytecode_post_pipeline(ctx, s, bc_out);
  }
}

void lepusng_opt_on_label(BytecodeOptCtx *opt_ctx, int label, LabelSlot *ls) {
  /* Merge TDZ initialization state at label targets */
  if (opt_ctx->loc_initialized || opt_ctx->var_ref_initialized) {
    opt_tdz_merge_label_state(
        opt_ctx, label, ls->ref_count, opt_ctx->loc_initialized,
        opt_ctx->var_ref_initialized, &opt_ctx->label_init_state,
        &opt_ctx->label_var_ref_init_state, opt_ctx->label_fwd_refs,
        opt_ctx->s->var_count, opt_ctx->s->closure_var_count,
        &opt_ctx->before_first_backward_label);
  }
  /* Reset constant fold tracker at jump targets — different
     execution paths may push different constants */
  if (ls->ref_count > 0) {
    opt_ctx->const_fold_pos1 = -1;
    opt_ctx->const_fold_pos2 = -1;
  }
}

void lepusng_opt_on_return_throw(BytecodeOptCtx *opt_ctx) {
  JSFunctionDef *s = opt_ctx->s;
  /* After return/throw, fall-through is dead — set all to 1
     so it acts as identity in intersection at subsequent labels */
  if (opt_ctx->loc_initialized)
    memset(opt_ctx->loc_initialized, 1, s->var_count);
  if (opt_ctx->var_ref_initialized)
    memset(opt_ctx->var_ref_initialized, 1, s->closure_var_count);
}

void lepusng_opt_on_goto_redirected(BytecodeOptCtx *opt_ctx) {
  lepusng_opt_on_return_throw(opt_ctx);
}

BOOL lepusng_opt_try_goto_inline_push_return(
    BytecodeOptCtx *opt_ctx, int target_label, const uint8_t *bc_buf,
    int bc_len, DynBuf *bc_out, int *pos_next, int64_t *line_num,
    int fallthrough_pos, int64_t current_line) {
  return goto_inline_push_return(
      opt_ctx->ctx, opt_ctx->s, target_label, bc_buf, bc_len, bc_out, pos_next,
      line_num, fallthrough_pos, current_line, opt_ctx->loc_initialized,
      opt_ctx->var_ref_initialized);
}

void lepusng_opt_on_branch(BytecodeOptCtx *opt_ctx, int op, int label,
                           LabelSlot *ls) {
  JSFunctionDef *s = opt_ctx->s;
  /* Save TDZ initialization state for forward branches */
  if (ls->addr == -1 &&
      (opt_ctx->loc_initialized || opt_ctx->var_ref_initialized)) {
    opt_tdz_save_branch_state(
        opt_ctx, label, opt_ctx->loc_initialized, opt_ctx->var_ref_initialized,
        &opt_ctx->label_init_state, &opt_ctx->label_var_ref_init_state,
        opt_ctx->label_fwd_refs, s->var_count, s->closure_var_count);
  }
  /* After unconditional goto, fall-through is dead — set all to 1
     so it acts as identity in intersection at the target label */
  if (op == OP_goto && opt_ctx->loc_initialized) {
    memset(opt_ctx->loc_initialized, 1, s->var_count);
  }
  if (op == OP_goto && opt_ctx->var_ref_initialized) {
    memset(opt_ctx->var_ref_initialized, 1, s->closure_var_count);
  }
}

void lepusng_opt_on_loc_written(BytecodeOptCtx *opt_ctx, int var_idx) {
  mark_loc_written(opt_ctx->loc_initialized, opt_ctx,
                   opt_ctx->before_first_backward_label, var_idx,
                   opt_ctx->s->var_count);
}

void lepusng_opt_on_emit_slu(BytecodeOptCtx *opt_ctx, int bc_out_pos,
                             int var_idx) {
  record_slu_position(opt_ctx->ctx, opt_ctx, bc_out_pos, var_idx);
}

BOOL lepusng_opt_try_downgrade_get_loc_check(BytecodeOptCtx *opt_ctx, int idx) {
  return opt_ctx->loc_initialized && idx < opt_ctx->s->var_count &&
         opt_ctx->loc_initialized[idx];
}

BOOL lepusng_opt_try_downgrade_get_var_ref_check(BytecodeOptCtx *opt_ctx,
                                                 int idx) {
  return opt_ctx->var_ref_initialized && idx < opt_ctx->s->closure_var_count &&
         opt_ctx->var_ref_initialized[idx];
}

void lepusng_opt_after_emit(BytecodeOptCtx *opt_ctx, DynBuf *bc_out,
                            int cf_emit_start) {
  opt_const_fold_update_tracker(
      bc_out->buf, cf_emit_start, bc_out->size - cf_emit_start,
      &opt_ctx->const_fold_pos1, &opt_ctx->const_fold_pos2,
      &opt_ctx->const_fold_val1, &opt_ctx->const_fold_val2,
      &opt_ctx->const_fold_is_bool1, &opt_ctx->const_fold_is_bool2);
}

LepusOptResult lepusng_opt_dispatch_opcode(
    LEPUSContext *ctx, JSFunctionDef *s, CodeContext *cc, const uint8_t *bc_buf,
    int bc_len, DynBuf *bc_out, LabelSlot *label_slots, int pos, int *pos_next,
    int op, int64_t *line_num, BytecodeOptCtx *opt_ctx, int *cf_emit_start,
    int *const_fold_pos1, int *const_fold_pos2, int32_t *const_fold_val1,
    int32_t *const_fold_val2, int *const_fold_is_bool1,
    int *const_fold_is_bool2, uint8_t **loc_initialized,
    uint8_t **var_ref_initialized, BOOL *before_first_backward_label,
    int *out_op, int *out_label, int *out_val, BOOL *out_has_val) {
  (void)label_slots;
  (void)pos;
  /* Local aliases to match variable names in quickjs.cc, zero-copy migration */
  int64_t &line_num_ref = *line_num;
  int &pos_next_ref = *pos_next;
  int &cf_emit_start_ref = *cf_emit_start;
  int &const_fold_pos1_ref = *const_fold_pos1;
  int &const_fold_pos2_ref = *const_fold_pos2;
  int32_t &const_fold_val1_ref = *const_fold_val1;
  int32_t &const_fold_val2_ref = *const_fold_val2;
  int &const_fold_is_bool1_ref = *const_fold_is_bool1;
  int &const_fold_is_bool2_ref = *const_fold_is_bool2;
  uint8_t *&loc_initialized_ref = *loc_initialized;
  uint8_t *&var_ref_initialized_ref = *var_ref_initialized;
  BOOL &before_first_backward_label_ref = *before_first_backward_label;
  int &out_op_ref = *out_op;
  int &out_label_ref = *out_label;
  int &out_val_ref = *out_val;
  BOOL &out_has_val_ref = *out_has_val;
  (void)ctx;
  (void)bc_len;

  switch (op) {
    case OP_put_loc_check:
    case OP_put_loc_check_init: {
      int idx = get_u16(bc_buf + pos + 1);
      int rv;
      int64_t new_line = line_num_ref;
      rv = try_handle_put_loc_check(cc, op, pos_next_ref, idx, s, bc_out,
                                    loc_initialized_ref, opt_ctx,
                                    before_first_backward_label_ref,
                                    line_num_ref, &pos_next_ref, &new_line);
      line_num_ref = new_line;
      if (rv == 1 || rv == 2 || rv == 4) {
        return LEPUS_OPT_BREAK;
      }
      /* Mark local as initialized after write */
      if (loc_initialized_ref) {
        if (idx < s->var_count) loc_initialized_ref[idx] = 1;
        if (before_first_backward_label_ref && opt_ctx->loc_perm_written &&
            idx < s->var_count && opt_ctx->loc_permanently_init[idx])
          opt_ctx->loc_perm_written[idx] = 1;
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_get_loc_check: {
      int idx = get_u16(bc_buf + pos + 1);
      int rv;
      int64_t new_line = line_num_ref;
      rv = try_downgrade_get_loc_check(cc, pos_next_ref, idx, s, bc_out,
                                       loc_initialized_ref, line_num_ref,
                                       &pos_next_ref, &new_line);
      line_num_ref = new_line;
      if (rv == 1 || rv == 2) {
        return LEPUS_OPT_BREAK;
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_put_var_ref_check: {
      int idx = get_u16(bc_buf + pos + 1);
      int64_t new_line = line_num_ref;
      if (try_downgrade_put_var_ref_check(cc, pos_next_ref, idx, s, bc_out,
                                          var_ref_initialized_ref, line_num_ref,
                                          &pos_next_ref, &new_line)) {
        line_num_ref = new_line;
        return LEPUS_OPT_BREAK;
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_put_var_ref_check_init: {
      /* Mark closure variable as initialized for subsequent reads.
         Do NOT downgrade put_var_ref_check_init (it checks for const
         reassignment — opposite semantics). */
      if (var_ref_initialized_ref) {
        int idx = get_u16(bc_buf + pos + 1);
        if (idx < s->closure_var_count) var_ref_initialized_ref[idx] = 1;
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_get_var_ref_check: {
      int idx = get_u16(bc_buf + pos + 1);
      int64_t new_line = line_num_ref;
      if (try_downgrade_get_var_ref_check(cc, pos_next_ref, idx, s, bc_out,
                                          var_ref_initialized_ref, line_num_ref,
                                          &pos_next_ref, &new_line)) {
        line_num_ref = new_line;
        return LEPUS_OPT_BREAK;
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_set_loc_uninitialized: {
      int idx = get_u16(bc_buf + pos + 1);
      if (try_eliminate_slu(cc, pos_next_ref, idx, s, bc_buf, bc_len, opt_ctx))
        return LEPUS_OPT_BREAK;

      /* Clear initialized state for this local */
      if (loc_initialized_ref && idx < s->var_count)
        loc_initialized_ref[idx] = 0;
      /* Record SLU position for post-pass dead SLU elimination */
      record_slu_position(opt_ctx->ctx, opt_ctx, bc_out->size, idx);
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_lnot: {
      /* Constant fold: if operand is a known integer constant, fold lnot
         at compile time. Combined with branch eliminates push+lnot+branch. */
      if (const_fold_pos2_ref >= 0) {
        int fold_rv;
        int32_t fold_val;
        int fold_pos;
        int64_t fold_line = line_num_ref;
        fold_rv = try_fold_lnot_on_const(
            cc, pos_next_ref, const_fold_val2_ref, s, bc_out,
            const_fold_pos2_ref, &cf_emit_start_ref, &const_fold_pos1_ref,
            &const_fold_pos2_ref, line_num_ref, &fold_val, &fold_pos,
            &fold_line);
        if (fold_rv == 1) {
          line_num_ref = fold_line;
          pos_next_ref = fold_pos;
          out_val_ref = fold_val;
          out_has_val_ref = TRUE;
          /* Return unhandled to let native has_constant_test path run */
          return LEPUS_OPT_UNHANDLED;
        }
        if (fold_rv == 2) {
          line_num_ref = fold_line;
          pos_next_ref = fold_pos;
          return LEPUS_OPT_BREAK;
        }
      }
      /* lnot + branch inversion / double negation identity:
         lnot lnot if_X(l) → if_X(l)   |   lnot if_false/true(l) →
         if_true/false(l) */
      {
        int new_op, new_label, new_pos;
        int64_t new_line = line_num_ref;
        if (try_lnot_branch_invert(cc, pos_next_ref, &new_op, &new_label,
                                   &new_pos, &new_line)) {
          line_num_ref = new_line;
          pos_next_ref = new_pos;
          out_op_ref = new_op;
          out_label_ref = new_label;
          return LEPUS_OPT_UNHANDLED;
        }
      }
      return LEPUS_OPT_UNHANDLED;
    }

    /* Constant folding for integer binary operations */
    case OP_add:
    case OP_sub:
    case OP_mul:
    case OP_div:
    case OP_mod:
    case OP_and:
    case OP_or:
    case OP_xor:
    case OP_shl:
    case OP_sar:
    case OP_shr: {
      if (const_fold_pos1_ref >= 0 && const_fold_pos2_ref >= 0) {
        int32_t result;
        if (opt_const_fold_try_binary(op, const_fold_val1_ref,
                                      const_fold_val2_ref, &result)) {
          /* Rewind bc_out to remove both constant pushes */
          bc_out->size = const_fold_pos1_ref;
          /* Emit folded result */
          add_pc2line_info(s, bc_out->size, line_num_ref);
          push_short_int(bc_out, result);
          /* Update tracker: result is now the last const push */
          const_fold_pos2_ref = const_fold_pos1_ref;
          const_fold_val2_ref = result;
          const_fold_is_bool2_ref = 0; /* arithmetic result is integer */
          const_fold_pos1_ref = -1;
          return LEPUS_OPT_BREAK;
        }
      }
      return LEPUS_OPT_UNHANDLED;
    }

    /* Constant folding for integer comparison operations */
    case OP_lt:
    case OP_lte:
    case OP_gt:
    case OP_gte:
    case OP_eq:
    case OP_neq:
    case OP_strict_eq:
    case OP_strict_neq: {
      if (const_fold_pos1_ref >= 0 && const_fold_pos2_ref >= 0) {
        int32_t cmp_result;
        if (opt_const_fold_try_compare(op, const_fold_val1_ref,
                                       const_fold_val2_ref,
                                       const_fold_is_bool1_ref,
                                       const_fold_is_bool2_ref, &cmp_result)) {
          /* Rewind bc_out to remove both constant pushes */
          bc_out->size = const_fold_pos1_ref;
          /* Emit boolean result */
          add_pc2line_info(s, bc_out->size, line_num_ref);
          dbuf_putc(bc_out, cmp_result ? OP_push_true : OP_push_false);
          /* Reset tracker — result is boolean, not trackable integer */
          const_fold_pos1_ref = -1;
          const_fold_pos2_ref = -1;
          return LEPUS_OPT_BREAK;
        }
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_get_var: {
      /* get_var undefined -> OP_undefined, then apply all OP_undefined
         peephole patterns (is_undefined, always-taken branch, etc.).
         Safe because: (1) OP_with_get_var is used for 'with' blocks,
         so OP_get_var means global access; (2) global 'undefined' is
         non-writable and non-configurable since ES5. */
      JSAtom atom = get_u32(bc_buf + pos + 1);
      if (atom == JS_ATOM_undefined) {
        if (!ctx->gc_enable) LEPUS_FreeAtom(ctx, atom);
        /* Transform to OP_undefined and let native processing run */
        out_op_ref = OP_undefined;
        return LEPUS_OPT_UNHANDLED;
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_swap: {
      /* transformation: swap drop -> nip (remove second-to-top) */
      if (code_match(cc, pos_next_ref, OP_drop, -1)) {
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        add_pc2line_info(s, bc_out->size, line_num_ref);
        dbuf_putc(bc_out, OP_nip);
        pos_next_ref = cc->pos;
        return LEPUS_OPT_BREAK;
      }
      return LEPUS_OPT_UNHANDLED;
    }

    /* Unary constant folding: neg, not */
    case OP_neg:
    case OP_not: {
      if (const_fold_pos2_ref >= 0) {
        int32_t result;
        if (opt_const_fold_try_unary(op, const_fold_val2_ref, &result)) {
          int fold_start = const_fold_pos2_ref;
          bc_out->size = fold_start;
          add_pc2line_info(s, bc_out->size, line_num_ref);
          push_short_int(bc_out, result);
          const_fold_pos2_ref = fold_start;
          const_fold_val2_ref = result;
          return LEPUS_OPT_BREAK;
        }
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_push_atom_value: {
      JSAtom atom = get_u32(bc_buf + pos + 1);
      /* Transformation: push_atom_value(a) get_array_el -> get_field(a)
                         push_atom_value(a) get_array_el2 -> get_field2(a)
         Only for non-integer atoms (identifier property names). */
      if (!__JS_AtomIsTaggedInt(atom) &&
          code_match(cc, pos_next_ref, M2(OP_get_array_el, OP_get_array_el2),
                     -1)) {
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        pos_next_ref = cc->pos;
        add_pc2line_info(s, bc_out->size, line_num_ref);
        dbuf_putc(bc_out,
                  cc->op == OP_get_array_el ? OP_get_field : OP_get_field2);
        dbuf_put_u32(bc_out, atom);
        return LEPUS_OPT_BREAK;
      }
      /* String constant condition folding:
         empty string is falsy, non-empty string is truthy.
         push_atom_value(str) lnot → push_true/push_false
         push_atom_value(str) if_false/if_true → constant test */
      if (!__JS_AtomIsTaggedInt(atom)) {
        int str_truthy = (atom != JS_ATOM_empty_string);
        int fold_label;
        if (fold_const_truthy(cc, pos_next_ref, str_truthy, s, bc_out,
                              line_num_ref, &pos_next_ref, &line_num_ref,
                              &fold_label)) {
          if (!ctx->gc_enable) LEPUS_FreeAtom(ctx, atom);
          if (fold_label >= 0) {
            out_op_ref = OP_goto;
            out_label_ref = fold_label;
            return LEPUS_OPT_UNHANDLED;
          }
          return LEPUS_OPT_BREAK;
        }
        if (str_truthy != 0 &&
            code_match(cc, pos_next_ref, M2(OP_if_false, OP_if_true), -1)) {
          if (!ctx->gc_enable) LEPUS_FreeAtom(ctx, atom);
          out_val_ref = str_truthy;
          out_has_val_ref = TRUE;
          return LEPUS_OPT_UNHANDLED;
        }
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_undefined: {
      /* remove push/drop pairs generated by the parser */
      if (code_match(cc, pos_next_ref, OP_drop, -1)) {
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        pos_next_ref = cc->pos;
        return LEPUS_OPT_BREAK;
      }
      /* return; return_undef; → return */
      if (code_match(cc, pos_next_ref, OP_return_undef, -1) ||
          code_match(cc, pos_next_ref, OP_return, -1)) {
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        add_pc2line_info(s, bc_out->size, line_num_ref);
        dbuf_putc(bc_out, OP_return_undef);
        pos_next_ref = cc->pos;
        return LEPUS_OPT_BREAK;
      }
      /* undefined goto(L) where L→return/return_undef → return_undef
         5 bytes: undefined(1)+goto(2-5) → return_undef(1) */
      if (try_fold_undefined_goto_return(
              cc, pos_next_ref, s, bc_out, bc_buf, bc_len, line_num_ref,
              loc_initialized_ref, var_ref_initialized_ref, &pos_next_ref,
              &line_num_ref)) {
        return LEPUS_OPT_BREAK;
      }
      /* undefined strict_neq standalone fold */
      {
        int new_op, new_label, new_pos;
        int64_t new_line = line_num_ref;
        BOOL has_label;
        if (try_const_strict_neq_standalone(
                cc, pos_next_ref, OP_is_undefined, s, bc_out, line_num_ref,
                &new_op, &new_label, &new_pos, &new_line, &has_label)) {
          line_num_ref = new_line;
          pos_next_ref = new_pos;
          if (has_label) {
            out_op_ref = new_op;
            out_label_ref = new_label;
            return LEPUS_OPT_UNHANDLED;
          }
          return LEPUS_OPT_BREAK;
        }
      }
      /* undefined dup undefined strict_eq if_true(l) -> undefined goto(l) */
      {
        int fold_label;
        if (fold_dup_const_strict_eq_branch(cc, pos_next_ref, OP_undefined, s,
                                            bc_out, line_num_ref, &pos_next_ref,
                                            &line_num_ref, &fold_label)) {
          if (fold_label >= 0) {
            out_op_ref = OP_goto;
            out_label_ref = fold_label;
            return LEPUS_OPT_UNHANDLED;
          }
          return LEPUS_OPT_BREAK;
        }
      }
      /* undefined is falsy: fold undefined + lnot cascade + optional branch */
      {
        int fold_label;
        if (fold_const_truthy(cc, pos_next_ref, 0, s, bc_out, line_num_ref,
                              &pos_next_ref, &line_num_ref, &fold_label)) {
          if (fold_label >= 0) {
            out_op_ref = OP_goto;
            out_label_ref = fold_label;
            return LEPUS_OPT_UNHANDLED;
          }
          return LEPUS_OPT_BREAK;
        }
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_drop: {
      /* Remove drops before return_undef: frame teardown frees all
         remaining stack values, so explicit drops are redundant. */
      int ret_pos =
          scan_drop_chain_before_return_undef(bc_buf, bc_len, pos_next_ref);
      if (ret_pos >= 0) {
        pos_next_ref = ret_pos; /* skip to return_undef, emitted next iter */
        return LEPUS_OPT_BREAK;
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_null: {
#if SHORT_OPCODES
      /* null strict_neq standalone fold */
      {
        int new_op, new_label, new_pos;
        int64_t new_line = line_num_ref;
        BOOL has_label;
        if (try_const_strict_neq_standalone(
                cc, pos_next_ref, OP_is_null, s, bc_out, line_num_ref, &new_op,
                &new_label, &new_pos, &new_line, &has_label)) {
          line_num_ref = new_line;
          pos_next_ref = new_pos;
          if (has_label) {
            out_op_ref = new_op;
            out_label_ref = new_label;
            return LEPUS_OPT_UNHANDLED;
          }
          return LEPUS_OPT_BREAK;
        }
      }
      /* null dup null strict_eq if_true(l) -> null goto(l) */
      {
        int fold_label;
        if (fold_dup_const_strict_eq_branch(cc, pos_next_ref, OP_null, s,
                                            bc_out, line_num_ref, &pos_next_ref,
                                            &line_num_ref, &fold_label)) {
          if (fold_label >= 0) {
            out_op_ref = OP_goto;
            out_label_ref = fold_label;
            return LEPUS_OPT_UNHANDLED;
          }
          return LEPUS_OPT_BREAK;
        }
      }
#endif
      /* null is falsy: fold null + lnot cascade + optional branch */
      {
        int fold_label;
        if (fold_const_truthy(cc, pos_next_ref, 0, s, bc_out, line_num_ref,
                              &pos_next_ref, &line_num_ref, &fold_label)) {
          if (fold_label >= 0) {
            out_op_ref = OP_goto;
            out_label_ref = fold_label;
            return LEPUS_OPT_UNHANDLED;
          }
          return LEPUS_OPT_BREAK;
        }
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_push_true:
    case OP_push_false: {
      int const_val = (op == OP_push_true);
      /* Fold cascading lnot + optional branch on known boolean value */
      int fold_label;
      if (fold_const_truthy(cc, pos_next_ref, const_val, s, bc_out,
                            line_num_ref, &pos_next_ref, &line_num_ref,
                            &fold_label)) {
        if (fold_label >= 0) {
          out_op_ref = OP_goto;
          out_label_ref = fold_label;
          return LEPUS_OPT_UNHANDLED;
        }
        return LEPUS_OPT_BREAK;
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_push_i32: {
      int32_t val = get_i32(bc_buf + pos + 1);
      /* Fold unary ops on integer constants: lnot, not */
      if (try_fold_unary_on_int_const(cc, pos_next_ref, OP_lnot, val, s, bc_out,
                                      line_num_ref, &pos_next_ref,
                                      &line_num_ref))
        return LEPUS_OPT_BREAK;
      if (try_fold_unary_on_int_const(cc, pos_next_ref, OP_not, val, s, bc_out,
                                      line_num_ref, &pos_next_ref,
                                      &line_num_ref))
        return LEPUS_OPT_BREAK;
      return LEPUS_OPT_UNHANDLED;
    }

#if SHORT_OPCODES
    case OP_push_const: {
      int idx = get_u32(bc_buf + pos + 1);
      /* remove push_const/drop pairs (no side effects) */
      if (code_match(cc, pos_next_ref, OP_drop, -1)) {
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        pos_next_ref = cc->pos;
        return LEPUS_OPT_BREAK;
      }
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_fclosure: {
      int idx = get_u32(bc_buf + pos + 1);
      /* Closure var_ref_check elimination: if the parent local backing
         a closure var is already initialized at this point, downgrade
         get_var_ref_check/put_var_ref_check in the child bytecode. */
      if (loc_initialized_ref && idx < s->cpool_count &&
          LEPUS_VALUE_GET_TAG(s->cpool[idx]) == LEPUS_TAG_FUNCTION_BYTECODE) {
        LEPUSFunctionBytecode *child_b =
            (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(s->cpool[idx]);
        opt_downgrade_closure_var_ref_check(s, child_b, loc_initialized_ref);
      }
      return LEPUS_OPT_UNHANDLED;
    }
#endif

    case OP_dup: {
      /* Esbuild nullish coalescing / optional chaining pattern (generic):
         [value already on stack] dup put_loc(m) null strict_neq if_false(L1)
           get_loc(m) undefined strict_neq if_false(L2)
         where L1 == L2  →  [value] set_loc(m) null eq if_true(L1)
         This catches get_var, get_field, etc. that don't have their own handler
       */
      {
        int end_pos, matched_label;
        int64_t matched_line = line_num_ref;
        if (try_esbuild_nullish_opt(s, bc_out, cc, pos_next_ref,
                                    loc_initialized_ref, -1, 0, &end_pos,
                                    &matched_label, &matched_line)) {
          line_num_ref = matched_line;
          pos_next_ref = end_pos;
          out_op_ref = OP_if_true;
          out_label_ref = matched_label;
          return LEPUS_OPT_UNHANDLED;
        }
      }
      /* Transformation: dup put_x(n) -> set_x(n) */
      {
        int new_pos_next;
        int64_t line2;
        int op1 = match_dup_put_pattern(cc, pos_next_ref, &new_pos_next,
                                        &line_num_ref, &line2);
        if (op1 >= 0) {
          pos_next_ref = new_pos_next;
          /* DSE: if this local is never read, eliminate the dead store */
          if ((op1 == OP_put_loc || op1 == OP_set_loc) &&
              opt_ctx->var_is_read && cc->idx < s->var_count &&
              !opt_ctx->var_is_read[cc->idx]) {
            if (op1 == OP_put_loc) {
              /* dup put_loc(n) drop -> drop (consume value, skip dead store) */
              add_pc2line_info(s, bc_out->size, line_num_ref);
              dbuf_putc(bc_out, OP_drop);
            }
            /* else: dup set_loc(n) -> noop (value stays on stack) */
            return LEPUS_OPT_BREAK;
          }
          add_pc2line_info(s, bc_out->size, line_num_ref);
          put_short_code(bc_out, op1, cc->idx);
          /* Mark local as initialized if writing to a loc */
          if ((op1 == OP_put_loc || op1 == OP_set_loc) && loc_initialized_ref &&
              cc->idx < s->var_count)
            loc_initialized_ref[cc->idx] = 1;
          if (line2 >= 0) line_num_ref = line2;
          return LEPUS_OPT_BREAK;
        }
      }
      /* Transformation: dup put_var(a) drop -> put_var(a) */
      {
        int64_t new_line = line_num_ref;
        if (try_dup_put_var_drop(cc, pos_next_ref, s, bc_out, line_num_ref,
                                 &pos_next_ref, &new_line)) {
          line_num_ref = new_line;
          return LEPUS_OPT_BREAK;
        }
      }
      /* Transformation: dup put_loc_check(n) drop -> put_loc_check(n)
                        dup put_var_ref_check(n) drop -> put_var_ref_check(n) */
      if (try_dup_put_check_drop(cc, pos_next_ref, s, bc_out, line_num_ref,
                                 loc_initialized_ref, var_ref_initialized_ref,
                                 opt_ctx, before_first_backward_label_ref,
                                 &pos_next_ref, &line_num_ref)) {
        return LEPUS_OPT_BREAK;
      }
      /* No optimizations matched: emit original opcode */
      return LEPUS_OPT_NO_CHANGE;
    }

    case OP_get_loc: {
      int idx = get_u16(bc_buf + pos + 1);
      /* Dead load: get_loc(n) drop -> nothing (no side effects) */
      if (code_match(cc, pos_next_ref, OP_drop, -1)) {
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        pos_next_ref = cc->pos;
        return LEPUS_OPT_BREAK;
      }
      /* transformation: get_loc(n) get_loc(n) -> get_loc(n) dup
         (saves 1-2 bytes when idx >= 4) */
      if (code_match(cc, pos_next_ref, OP_get_loc, idx, -1)) {
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        add_pc2line_info(s, bc_out->size, line_num_ref);
        put_short_code(bc_out, op, idx);
        dbuf_putc(bc_out, OP_dup);
        pos_next_ref = cc->pos;
        return LEPUS_OPT_BREAK;
      }
      /* No LepusNG optimizations matched: run native QuickJS processing */
      return LEPUS_OPT_UNHANDLED;
    }

#if SHORT_OPCODES
    case OP_get_arg:
    case OP_get_var_ref: {
      int idx = get_u16(bc_buf + pos + 1);
      /* remove get_arg(n)/get_var_ref(n) drop - no side effects */
      if (code_match(cc, pos_next_ref, OP_drop, -1)) {
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        pos_next_ref = cc->pos;
        return LEPUS_OPT_BREAK;
      }
      /* Esbuild nullish coalescing / optional chaining pattern:
         get_arg(n) dup put_loc(m) null strict_neq if_false(L1)
           get_loc(m) undefined strict_neq if_false(L2)
         where L1 == L2  →  get_arg(n) set_loc(m) null eq if_true(L1) */
      if (code_match(cc, pos_next_ref, OP_dup, OP_put_loc, -1, OP_null, -1, -1,
                     -1)) {
        /* dup found; rest of pattern (put_loc + null + branch + ...)
           starts one instruction past pos_next */
        int dup_end = cc->pos - 1; /* position after OP_dup, before put_loc */
        int end_pos, matched_label;
        int64_t matched_line = line_num_ref;
        if (try_esbuild_nullish_opt(s, bc_out, cc, dup_end, loc_initialized_ref,
                                    op, idx, &end_pos, &matched_label,
                                    &matched_line)) {
          line_num_ref = matched_line;
          pos_next_ref = end_pos;
          out_op_ref = OP_if_true;
          out_label_ref = matched_label;
          return LEPUS_OPT_UNHANDLED;
        }
      }
      /* Transformation: get_arg(n) get_arg(n) -> get_arg(n) dup
                         get_var_ref(n) get_var_ref(n) -> get_var_ref(n) dup
         (saves 1-2 bytes, no side effects for these pure reads) */
      if (code_match(cc, pos_next_ref, op, idx, -1)) {
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        add_pc2line_info(s, bc_out->size, line_num_ref);
        put_short_code(bc_out, op, idx);
        dbuf_putc(bc_out, OP_dup);
        pos_next_ref = cc->pos;
        return LEPUS_OPT_BREAK;
      }
      /* No LepusNG optimizations matched: run native QuickJS processing */
      return LEPUS_OPT_UNHANDLED;
    }
#endif

    case OP_put_loc:
    case OP_put_arg:
    case OP_put_var_ref: {
      int idx = get_u16(bc_buf + pos + 1);
      /* DSE: if this local is never read, replace put_loc with drop */
      if (op == OP_put_loc && opt_ctx->var_is_read && idx < s->var_count &&
          !opt_ctx->var_is_read[idx]) {
        add_pc2line_info(s, bc_out->size, line_num_ref);
        dbuf_putc(bc_out, OP_drop);
        return LEPUS_OPT_BREAK;
      }
      /* Mark local as initialized for get_loc_check downgrade */
      if (op == OP_put_loc && loc_initialized_ref && idx < s->var_count)
        mark_loc_written(loc_initialized_ref, opt_ctx,
                         before_first_backward_label_ref, idx, s->var_count);
      /* Extended: put_x(n) get_x(n) drop -> put_x(n)
         Also: put_loc(n) get_loc_check(n) drop -> put_loc(n)
         The get+drop is redundant since put already consumed the value */
      if (code_match(cc, pos_next_ref, op - 1, idx, OP_drop, -1) ||
          (op == OP_put_loc &&
           code_match(cc, pos_next_ref, OP_get_loc_check, idx, OP_drop, -1))) {
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        add_pc2line_info(s, bc_out->size, line_num_ref);
        put_short_code(bc_out, op, idx);
        pos_next_ref = cc->pos;
        return LEPUS_OPT_BREAK;
      }
      /* Extended: put_loc(n) get_loc_check(n) -> set_loc(n)
         After put_loc, local is initialized so check is unnecessary. */
      if (op == OP_put_loc &&
          code_match(cc, pos_next_ref, OP_get_loc_check, idx, -1)) {
        add_pc2line_info(s, bc_out->size, line_num_ref);
        if (cc->line_num >= 0) line_num_ref = cc->line_num;
        put_short_code(bc_out, op + 1, idx);
        pos_next_ref = cc->pos;
        return LEPUS_OPT_BREAK;
      }
      /* No LepusNG optimizations matched: run native QuickJS processing */
      return LEPUS_OPT_UNHANDLED;
    }

    case OP_typeof: {
#if SHORT_OPCODES
      /* transform typeof(s) != "<type>" into is_<type> lnot */
      JSAtom atom;
      int op2 = -1;
      if (code_match(cc, pos_next_ref, OP_push_atom_value, -1)) {
        atom = cc->atom;
        if (atom == JS_ATOM_undefined) {
          op2 = OP_is_undefined;
        } else if (atom == JS_ATOM_function) {
          op2 = OP_is_function;
        }
        if (op2 >= 0) {
          int pos_after_atom = cc->pos;
          if (code_match(cc, pos_after_atom, OP_strict_neq, -1)) {
            int pos_after_strict_neq = cc->pos;
            if (!code_match(cc, pos_after_strict_neq,
                            M2(OP_if_false, OP_if_true), -1)) {
              if (cc->line_num >= 0) line_num_ref = cc->line_num;
              add_pc2line_info(s, bc_out->size, line_num_ref);
              dbuf_putc(bc_out, op2);
              dbuf_putc(bc_out, OP_lnot);
              if (!ctx->gc_enable) LEPUS_FreeAtom(ctx, atom);
              pos_next_ref = pos_after_strict_neq;
              return LEPUS_OPT_BREAK;
            }
          }
        }
      }
#endif
      /* No LepusNG optimizations matched: run native processing */
      return LEPUS_OPT_UNHANDLED;
    }

    default:
      return LEPUS_OPT_UNHANDLED;
  }
}

#endif /* ENABLE_LEPUSNG_BYTECODE_OPT */
