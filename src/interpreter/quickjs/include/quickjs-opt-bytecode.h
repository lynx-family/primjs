// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_OPT_BYTECODE_H_
#define SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_OPT_BYTECODE_H_

#include "quickjs/include/quickjs-inner.h"

/* ========================================================================
 * Public LepusNG optimization API
 * ======================================================================== */

/* Unified optimization enable check: runtime flag + compile-time OPTIMIZE */
#ifdef ENABLE_LEPUSNG_BYTECODE_OPT
#define LEPUSNG_OPT_ENABLED() (OPTIMIZE && lepusng_bytecode_opt)
#else
#define LEPUSNG_OPT_ENABLED() (0)
#endif

/* Mark a local variable as captured by closure (for optimization analysis) */
static inline void lepusng_mark_local_captured(JSFunctionDef *fd, int idx) {
  if (idx >= 0 && idx < fd->var_count) {
    fd->vars[idx].is_captured = 1;
  }
}

#ifdef ENABLE_LEPUSNG_BYTECODE_OPT
/* Run post-compilation bytecode optimization passes (after main emission loop)
 */
void lepusng_run_bytecode_post_pipeline(LEPUSContext *ctx, JSFunctionDef *s,
                                        DynBuf *bc_out);
#else
static inline void lepusng_run_bytecode_post_pipeline(LEPUSContext *ctx,
                                                      JSFunctionDef *s,
                                                      DynBuf *bc_out) {}
#endif

#ifdef ENABLE_LEPUSNG_BYTECODE_OPT

/*
 * QuickJS Extended Bytecode Optimization Passes
 *
 * This header declares the optimization functions that implement the extended
 * bytecode optimization pipeline, invoked from resolve_labels() in quickjs.cc.
 *
 * The pipeline runs in three phases:
 *
 * Phase 1 — PRE-PASS (operates on bc_buf, before main emission loop):
 *   P1. opt_prescan_tdz_dse       — Identify TDZ/DSE-eligible variables
 *   P2. opt_reorder_local_vars    — Frequency-based local variable index
 * remapping P3. opt_reorder_closure_vars  — Frequency-based closure variable
 * remapping P4. opt_reorder_cpool         — Frequency-based constant pool
 * remapping
 *
 * Phase 2 — Main emission (bc_buf → bc_out)
 *   (Emission-time peephole optimizations run inline during this phase,
 *    including fold_const_truthy which folds constant truthiness + lnot
 *    cascades + conditional branches. These are not numbered passes.)
 *
 * Phase 3 — POST-PASS (operates on bc_out, after main emission loop):
 *   P5. opt_dead_slu_elim        — Remove dead set_loc_uninitialized (→ NOP)
 *   P6. opt_post_peephole          — Short-range 2-3 instruction patterns (→
 * NOP gaps) P7. opt_dead_value_elim       — Result-unused drop elimination (→
 * NOP gaps) P8. opt_goto_chain_follow        — Goto-to-return/throw chain
 * following P9. opt_branch_inversion     — if_xxx + goto → if_not_xxx inversion
 *   P10. opt_final_dce             — Dead code elimination (unreachable + dead
 * values) P11. opt_nop_strip           — Compact bytecode (remove all NOP gaps)
 *   P12. opt_jump_shrink           — Shrink wide jumps to short encoding
 * (defined in quickjs.cc)
 *
 * =========================================================================
 * Pass Dependencies & Label Stability
 * =========================================================================
 *
 *  Pass                          | Inputs                           | Outputs /
 * Effects                         | Order Constraint              | Label
 * Stable?
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P1 opt_prescan_tdz_dse    | bc_buf, loc_initialized        |
 * loc_permanently_init, loc_perm_written,   | must run FIRST              | n/a
 * (pre-pass) |                                  | var_is_read (new alloc) |
 * (before any reorder)        | |                                  | read-only
 * on bc_buf and s                |                             |
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P2 opt_reorder_local_vars   | bc_buf, var_is_read,             | remapped
 * arrays + s->vars[],              | after P1                    | n/a
 * (pre-pass) | loc_permanently_init,             | s->scopes[], special var
 * indices,      |                             | | loc_perm_written, | bc_buf
 * operands, child closure_vars       |                             | |
 * loc_initialized                  |                                         |
 * |
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P3 opt_reorder_closure_vars | bc_buf, var_ref_initialized     | remapped
 * var_ref_initialized +            | independent of P2             | n/a
 * (pre-pass) |                                  | s->closure_var[], bc_buf
 * operands,         |                             | | | child closure_vars,
 * module entries         |                             |
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P4 opt_reorder_cpool      | bc_buf, s->cpool              | reordered
 * s->cpool + bc_buf cpool operands  | independent                   | n/a
 * (pre-pass)
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P5 opt_dead_slu_elim     | bc_out, slu_records,          | dead SLUs
 * replaced with NOP                | first post-pass             | yes (NOP
 * fill) | TDZ-check variables                | | (before peephole)            |
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P6 opt_post_peephole        | bc_out, is_label_target        | 2-3
 * instruction pattern optimizations,         | after P5                  | yes
 * (NOP fill) |                                  | NOP-filled gaps | (SLU elim
 * creates new       | |                                  | |  adjacent
 * patterns)         |
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P7 opt_dead_value_elim       | bc_out, jump_slots, label_slots|
 * result-unused drop elim,                | after P6                  | yes
 * (NOP fill) |                                  | pure_op + drop → NOP | (needs
 * peephole patterns)   |
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P8 opt_goto_chain_follow     | bc_out, jump_slots, label_slots   |
 * goto→return/throw chain replacement         | after P7                  | yes
 * (same instr size) |                                  | | (fewer intermediate
 * gotos  | |                                  | |  after dead value elim) |
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P9 opt_branch_inversion       | bc_out, jump_slots, label_slots| if_xxx +
 * goto → if_not_xxx          | after P8                  | yes (NOP fill) | |
 * lnot + if → if_not                     | (fewer gotos → more      | | | |
 * inversion opportunities) |
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P10 opt_final_dce           | bc_out, jump_slots, label_slots | unreachable
 * code elim,                  | after all label-stable       | yes (NOP fill)
 *                              |                                  |
 * set+drop→put, redundant load elim,       | passes (P5–P9)            | | |
 * goto→return 2nd pass                      |                             |
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P11 opt_nop_strip          | bc_out (with NOP gaps)          | compacted
 * bc_out, all labels/               | LAST among label-stable   | NO — changes
 * offsets |                                  | jumps/line_numbers remapped |
 * passes                      |
 * -------------------------------+----------------------------------+-----------------------------------------+-----------------------------+------------
 *  P12 opt_jump_shrink        | compacted bc_out (no NOP)         | goto32 →
 * goto16 → goto8 shrink         | after P11                 | NO — changes
 * offsets |                                  | (iterates until convergence) |
 * (must use final offsets) |
 *
 * Key invariants:
 *   - Passes P5–P10 preserve label addresses (NOP-fill only).
 *   - Passes P11–P12 change bytecode offsets and must run last.
 *   - P5–P10 are all independent in output ordering *among themselves*
 *     but P6 → P7 → P8 → P9 → P10 maximizes cascading optimizations.
 */

/* Record of a set_loc_uninitialized (SLU) instruction position in bc_out.
   Used to track SLU positions during bytecode emission so they can be
   eliminated in the post-pass if no TDZ checks remain for that variable. */
struct SLURecord {
  int bc_out_pos; /* byte offset in bc_out where the SLU was emitted */
  int var_idx;    /* local variable index this SLU initializes */
};

/* Optimization pipeline context — carries all data that flows across the
   pre-pass / main emission / post-pass boundary. Using a single context
   struct makes the data flow explicit and reduces parameter count on
   pre-pass functions. Arrays marked [owned] are freed in resolve_labels
   fail path; [borrowed] pointers are owned by resolve_labels locals. */
typedef struct BytecodeOptCtx {
  /* Pre-pass outputs [owned] — allocated by opt_prescan_tdz_dse */
  uint8_t *loc_permanently_init; /* var i has ≤1 set_loc_uninitialized */
  uint8_t *loc_perm_written;     /* var i is written before first label */
  uint8_t *var_is_read;          /* var i is ever read */

  /* SLU records [owned] — filled during main emission, used by dead_slu_elim */
  SLURecord *slu_records;
  int slu_pos_count;
  int slu_pos_size;

  /* TDZ tracking state [owned] */
  uint8_t *loc_initialized;     /* current TDZ state per local var */
  uint8_t *var_ref_initialized; /* current TDZ state per closure var */
  uint8_t **label_init_state;   /* per-label saved init state for locals */
  uint8_t **label_var_ref_init_state; /* per-label saved init state for closure
                                         vars */
  int *label_fwd_refs;              /* count of forward references per label */
  BOOL before_first_backward_label; /* before first backward-edge label */

  /* Constant folding tracking state */
  int const_fold_pos1, const_fold_pos2;         /* positions in bc_out */
  int32_t const_fold_val1, const_fold_val2;     /* constant values */
  int const_fold_is_bool1, const_fold_is_bool2; /* boolean flags */

  int preamble_skip_pos; /* position in bc_buf to skip (get_loc folded) */

  /* Borrowed references [not owned] */
  JSFunctionDef *s;
  LEPUSContext *ctx;
} BytecodeOptCtx;

/* Initialize optimization context, run all pre-passes, and mark
   preamble-initialized locals. Returns TRUE if optimization is enabled for this
   function. */
BOOL lepusng_opt_resolve_labels_init(BytecodeOptCtx *opt_ctx, LEPUSContext *ctx,
                                     JSFunctionDef *s, const uint8_t *bc_buf,
                                     int bc_len, DynBuf *bc_out);

/* Clean up optimization context: free all owned arrays. If run_post_pipeline is
   TRUE, runs the full post-compilation optimization pipeline before cleanup. */
void lepusng_opt_resolve_labels_finish(BytecodeOptCtx *opt_ctx, DynBuf *bc_out,
                                       BOOL run_post_pipeline);

/* Hook called when reaching an OP_label during emission. Handles TDZ state
   merging and constant fold tracker reset. */
void lepusng_opt_on_label(BytecodeOptCtx *opt_ctx, int label, LabelSlot *ls);

/* Hook called after emitting OP_return/OP_throw. Marks fall-through code as
   dead for TDZ tracking. */
void lepusng_opt_on_return_throw(BytecodeOptCtx *opt_ctx);

/* Hook called after redirecting a goto directly to return/throw. Marks
   fall-through code as dead for TDZ tracking. */
void lepusng_opt_on_goto_redirected(BytecodeOptCtx *opt_ctx);

/* Try to inline a single side-effect-free push + return after a goto. Returns
   TRUE if inlining succeeded and code was emitted. */
BOOL lepusng_opt_try_goto_inline_push_return(
    BytecodeOptCtx *opt_ctx, int target_label, const uint8_t *bc_buf,
    int bc_len, DynBuf *bc_out, int *pos_next, int64_t *line_num,
    int fallthrough_pos, int64_t current_line);

/* Hook called when emitting a branch (goto/if_true/if_false/gosub/catch).
   Saves TDZ state for forward branches and marks fall-through as dead for
   unconditional gotos. */
void lepusng_opt_on_branch(BytecodeOptCtx *opt_ctx, int op, int label,
                           LabelSlot *ls);

/* Hook called after emitting an instruction that writes to a local variable.
   Updates TDZ initialized state. */
void lepusng_opt_on_loc_written(BytecodeOptCtx *opt_ctx, int var_idx);

/* Hook called after emitting set_loc_uninitialized. Records the SLU position
   for later dead elimination. */
void lepusng_opt_on_emit_slu(BytecodeOptCtx *opt_ctx, int bc_out_pos,
                             int var_idx);

/* Hook called when processing get_loc_check. If the variable is provably
   initialized, downgrades to plain get_loc (returns TRUE). */
BOOL lepusng_opt_try_downgrade_get_loc_check(BytecodeOptCtx *opt_ctx, int idx);

/* Hook called when processing get_var_ref_check. If the closure var is
   provably initialized, downgrades to plain get_var_ref (returns TRUE). */
BOOL lepusng_opt_try_downgrade_get_var_ref_check(BytecodeOptCtx *opt_ctx,
                                                 int idx);

/* Hook called after emitting any instruction, updates constant fold tracker. */
void lepusng_opt_after_emit(BytecodeOptCtx *opt_ctx, DynBuf *bc_out,
                            int cf_emit_start);

/* Unified opcode dispatch result codes */
typedef enum {
  LEPUS_OPT_UNHANDLED =
      0,           /* Opcode not handled by optimizer, run native processing */
  LEPUS_OPT_BREAK, /* Opcode fully handled, break out of switch (instruction
                      emitted) */
  LEPUS_OPT_NO_CHANGE /* Opcode fully handled, emit raw bytes via no_change path
                       */
} LepusOptResult;

/* Main unified opcode dispatch: runs all peephole optimizations for opcodes
   that don't require native label relocation processing. Returns result code
   indicating how the caller should proceed. All output state changes are
   returned via pointer parameters. */
LepusOptResult lepusng_opt_dispatch_opcode(
    LEPUSContext *ctx, JSFunctionDef *s, CodeContext *cc, const uint8_t *bc_buf,
    int bc_len, DynBuf *bc_out, LabelSlot *label_slots, int pos, int *pos_next,
    int op, int64_t *line_num, BytecodeOptCtx *opt_ctx, int *cf_emit_start,
    int *const_fold_pos1, int *const_fold_pos2, int32_t *const_fold_val1,
    int32_t *const_fold_val2, int *const_fold_is_bool1,
    int *const_fold_is_bool2, uint8_t **loc_initialized,
    uint8_t **var_ref_initialized, BOOL *before_first_backward_label,
    int *out_op, int *out_label, int *out_val, BOOL *out_has_val);

/* ========================================================================
 * PRE-PASS FUNCTIONS
 * ======================================================================== */

/* Emit 'this' variable initialization in the function preamble.
   Peeks at the start of bc_buf: if the first real instruction is
   get_loc/get_loc_check(this_var_idx), emits set_loc instead of put_loc
   to keep the value on the stack, and returns the position of that get_loc
   so the caller can skip it during the main emission loop.
   Returns -1 if no skip is needed (put_loc was emitted).
   Caller must guard with OPTIMIZE && lepusng_bytecode_opt. */
int opt_preamble_emit_this(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out,
                           const uint8_t *bc_buf, int bc_len);

/* Pre-scan bytecode to identify:
   - Variables that can never re-enter TDZ (have at most one
   set_loc_uninitialized)
   - Variables that are written before the first label (permanently written)
   - Variables that are never read (dead store candidates)
   Writes results into opt_ctx: loc_permanently_init, loc_perm_written,
   var_is_read. Caller must free via opt_ctx cleanup. */
void opt_prescan_tdz_dse(BytecodeOptCtx *opt_ctx, const uint8_t *bc_buf,
                         int bc_len);

/* Reorder local variable indices by access frequency.
   Variables with the highest access counts get the lowest indices (0-3 use
   1-byte encoding, 4-255 use 2-byte, 256+ use 3-byte). Rewrites all local
   variable references in bc_buf in-place and rearranges s->vars[].
   Uses var_is_read, loc_permanently_init, loc_perm_written from opt_ctx,
   and remaps loc_initialized (borrowed) in-place. */
void opt_reorder_local_vars(BytecodeOptCtx *opt_ctx, const uint8_t *bc_buf,
                            int bc_len);

/* Reorder closure variable (var_ref) indices by access frequency.
   Closure vars with highest access counts get indices 0-3 (1-byte encoding).
   Rewrites all closure variable references in bc_buf in-place.
   Uses var_ref_initialized from opt_ctx (borrowed, remapped in-place). */
void opt_reorder_closure_vars(BytecodeOptCtx *opt_ctx, const uint8_t *bc_buf,
                              int bc_len);

/* Reorder constant pool indices for functions with >256 cpool entries.
   Moves the most frequently accessed entries to indices 0-255 to enable
   push_const8 (2 bytes) instead of push_const (5 bytes). */
void opt_reorder_cpool(BytecodeOptCtx *opt_ctx, const uint8_t *bc_buf,
                       int bc_len);

/* ========================================================================
 * TDZ STATE MANAGEMENT FUNCTIONS
 * ======================================================================== */

/* Merge saved forward-branch initialization states with the current state
   at a label target.  For forward-only labels, intersects all incoming
   branch states.  For labels with backward edges (loops), resets to 0
   while preserving permanently-initialized vars.  Frees the per-label
   state arrays after merging.  Updates *before_first_backward_label. */
void opt_tdz_merge_label_state(
    BytecodeOptCtx *opt_ctx, int label, int ref_count, uint8_t *loc_initialized,
    uint8_t *var_ref_initialized, uint8_t ***label_init_state,
    uint8_t ***label_var_ref_init_state, int *label_fwd_refs, int var_count,
    int closure_var_count, BOOL *before_first_backward_label);

/* Save current initialization state at a forward branch.  Called when
   emitting a branch to a label that hasn't been reached yet (ls->addr == -1).
   First forward branch: allocates and copies current state.
   Subsequent forward branches: intersects (AND) current state with saved.
   Increments label_fwd_refs[label] for forward-only detection. */
void opt_tdz_save_branch_state(BytecodeOptCtx *opt_ctx, int label,
                               uint8_t *loc_initialized,
                               uint8_t *var_ref_initialized,
                               uint8_t ***label_init_state,
                               uint8_t ***label_var_ref_init_state,
                               int *label_fwd_refs, int var_count,
                               int closure_var_count);

/* ========================================================================
 * CONSTANT FOLDING HELPERS (pure computation, no bc_out emission)
 * ======================================================================== */

/* Try to constant-fold a binary integer operation.
   Returns TRUE if folding succeeded, with result stored in *out_result.
   Handles overflow, division-by-zero, and JS semantics (e.g. -0, unsigned shr).
   Supported ops: OP_add, OP_sub, OP_mul, OP_div, OP_mod,
                  OP_and, OP_or, OP_xor, OP_shl, OP_sar, OP_shr. */
BOOL opt_const_fold_try_binary(int op, int32_t left, int32_t right,
                               int32_t *out_result);

/* Try to constant-fold an integer comparison operation.
   Returns TRUE if folding succeeded, with boolean result (0 or 1) in
   *out_result. is_bool1/is_bool2: whether each operand is a boolean constant.
     Strict equality with boolean operand cannot be folded because true===1 is
   false. Supported ops: OP_lt, OP_lte, OP_gt, OP_gte, OP_eq, OP_neq,
   OP_strict_eq, OP_strict_neq. */
BOOL opt_const_fold_try_compare(int op, int32_t left, int32_t right,
                                int is_bool1, int is_bool2,
                                int32_t *out_result);

/* Try to constant-fold a unary integer operation.
   Returns TRUE if folding succeeded, with result stored in *out_result.
   Supported ops: OP_neg (fails for INT32_MIN and 0 due to -0), OP_not (~val).
 */
BOOL opt_const_fold_try_unary(int op, int32_t val, int32_t *out_result);

/* Update the two-slot constant fold tracker after emitting one instruction.
   If the emitted instruction is a constant integer push (push_minus1..push_7,
   push_i8, push_i16, push_i32, push_true, push_false), shift it into the
   tracker (pos1=old pos2, pos2=new push position). Otherwise, reset both
   tracker slots to -1 (the instruction may have side effects or consume
   the constants).
   Does nothing if cf_emitted_size <= 0 (instruction was eliminated). */
void opt_const_fold_update_tracker(const uint8_t *bc_out_buf, int cf_emit_start,
                                   int cf_emitted_size, int *cf_pos1,
                                   int *cf_pos2, int32_t *cf_val1,
                                   int32_t *cf_val2, int *cf_is_bool1,
                                   int *cf_is_bool2);

/* Downgrade closure var_ref_check opcodes in a child function's bytecode
   when the parent's backing local is already initialized.  For each closure
   variable that is a local (not arg) lexical variable and whose parent
   local is already initialized, replace get_var_ref_check → get_var_ref
   and put_var_ref_check → put_var_ref in the child's bytecode.
   Safe because the variable is guaranteed to be initialized, so no
   TDZ check is needed when accessing it through the closure. */
void opt_downgrade_closure_var_ref_check(JSFunctionDef *parent_s,
                                         LEPUSFunctionBytecode *child_b,
                                         const uint8_t *loc_initialized);

/* ========================================================================
 * POST-PASS FUNCTIONS
 * ======================================================================== */

/* Eliminate dead set_loc_uninitialized instructions.
   An SLU is dead if no get_loc_check/put_loc_check instructions remain in
   bc_out for that variable (meaning all TDZ checks were successfully
   downgraded during the main emission loop). Dead SLUs are replaced with NOP.
 */
void opt_dead_slu_elim(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out,
                       const SLURecord *slu_records, int slu_pos_count);

/* Short-range post-pass peephole optimization on final bc_out.
   Matches 2-3 instruction patterns that the main emission loop couldn't
   catch because they span labels or were created by SLU elimination.
   All transforms are NOP-padded; label addresses are preserved.
   Patterns include:
   - put_loc(n) + get_loc(n) -> set_loc(n)
   - get_xxx + drop -> nop (pure reads with unused result)
   - set_xxx + drop -> put_xxx (dead result stores)
   - dup + put -> set
   - set + get -> set + dup (redundant load)
   - dup + get_field -> get_field2
   - swap/nip simplifications
   - undefined + return -> return_undef
   - null/undefined + strict_eq -> is_null/is_undefined */
void opt_post_peephole(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out);

/* Result-unused drop elimination.
   When ALL jumps to a label L (where L: drop) match a known dead-value
   pattern (dup+if_xxx short-circuit, or const/pure-read + goto), NOP-out
   the dead value production and advance the label past the drop.
   Label addresses are preserved via NOP-fill for dead bytes; only the
   label target address itself moves forward by 1 (past the drop). */
void opt_dead_value_elim(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out);

/* Goto-to-return/throw chain following.
   Replaces goto/goto8/goto16(L) with a terminal instruction (return,
   return_undef, throw) when L — possibly through a chain of intermediate
   gotos — targets a terminal instruction. Follows up to 10 hops with
   cycle detection. Instruction size is preserved (goto operand bytes
   become NOPs), so label addresses stay stable. */
void opt_goto_chain_follow(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out);

/* Branch inversion.
   Transforms: if_xxx(skip) goto_yyy(L) → if_inv(L) + NOPs
   Handles all combinations of if_false8/if_true8/if_false/if_true with
   goto8/goto16/goto. The inverted if takes the goto's target label, and
   the goto bytes become NOPs. Also handles lnot + if_xxx → if_inv patterns
   from bytecode scanning.
   Label addresses are preserved (goto bytes are NOP-filled). */
void opt_branch_inversion(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out);

/* Dead code elimination on final bc_out. Includes:
   1) Unreachable code elimination after return/return_undef/throw
   2) set_xxx [nop*] drop -> put_xxx [nop*] nop (dead value elimination)
   3) pure_op [nop*] drop -> all nops (dead value elimination)
   4) Consecutive identical reads -> dup (redundant load elimination)
   Also: undefined+return -> return_undef, goto-to-return second pass. */
void opt_final_dce(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out);

/* Strip all NOP instructions from bc_out and adjust all position-dependent
   references: label addresses, jump positions, line number PCs, and caller
   position slots. */
void opt_nop_strip(LEPUSContext *ctx, JSFunctionDef *s, DynBuf *bc_out);

/* Inline TDZ scan: determine if a set_loc_uninitialized for variable idx
   can be eliminated by scanning forward from scan_start in bc_buf.
   Returns TRUE if the variable is always written (put_loc/set_loc) before
   being read (get_loc_check/put_loc_check) within the basic block. */
BOOL opt_tdz_inline_can_eliminate(JSFunctionDef *s, const uint8_t *bc_buf,
                                  int bc_len, int scan_start, int idx);

#else /* !ENABLE_LEPUSNG_BYTECODE_OPT */

/* Dummy definitions so quickjs.cc compiles without #ifdef guards everywhere.
   All optimization calls are guarded by lepusng_bytecode_opt (runtime flag)
   which is FALSE when ENABLE_LEPUSNG_BYTECODE_OPT is not defined, so these are
   never used. */

/* Result codes (must match the real enum) */
typedef enum {
  LEPUS_OPT_UNHANDLED = 0,
  LEPUS_OPT_BREAK,
  LEPUS_OPT_NO_CHANGE
} LepusOptResult;

struct SLURecord {
  int bc_out_pos;
  int var_idx;
};

typedef struct BytecodeOptCtx {
  uint8_t *loc_permanently_init;
  uint8_t *loc_perm_written;
  uint8_t *var_is_read;
  SLURecord *slu_records;
  int slu_pos_count;
  int slu_pos_size;
  uint8_t *loc_initialized;
  uint8_t *var_ref_initialized;
  uint8_t **label_init_state;
  uint8_t **label_var_ref_init_state;
  int *label_fwd_refs;
  BOOL before_first_backward_label;
  int const_fold_pos1, const_fold_pos2;
  int32_t const_fold_val1, const_fold_val2;
  int const_fold_is_bool1, const_fold_is_bool2;
  int preamble_skip_pos;
  struct JSFunctionDef *s;
  struct LEPUSContext *ctx;
} BytecodeOptCtx;

static inline BOOL lepusng_opt_resolve_labels_init(BytecodeOptCtx *opt_ctx,
                                                   void *ctx, void *s,
                                                   const void *bc_buf,
                                                   int bc_len, void *bc_out) {
  (void)opt_ctx;
  (void)ctx;
  (void)s;
  (void)bc_buf;
  (void)bc_len;
  (void)bc_out;
  return FALSE;
}

static inline void lepusng_opt_resolve_labels_finish(BytecodeOptCtx *opt_ctx,
                                                     void *bc_out,
                                                     BOOL run_post_pipeline) {
  (void)opt_ctx;
  (void)bc_out;
  (void)run_post_pipeline;
}

static inline void lepusng_opt_on_label(BytecodeOptCtx *opt_ctx, int label,
                                        void *ls) {
  (void)opt_ctx;
  (void)label;
  (void)ls;
}

static inline void lepusng_opt_on_return_throw(BytecodeOptCtx *opt_ctx) {
  (void)opt_ctx;
}

static inline void lepusng_opt_on_goto_redirected(BytecodeOptCtx *opt_ctx) {
  (void)opt_ctx;
}

static inline BOOL lepusng_opt_try_goto_inline_push_return(
    BytecodeOptCtx *opt_ctx, int target_label, const void *bc_buf, int bc_len,
    void *bc_out, int *pos_next, void *line_num, int fallthrough_pos,
    int64_t current_line) {
  (void)opt_ctx;
  (void)target_label;
  (void)bc_buf;
  (void)bc_len;
  (void)bc_out;
  (void)pos_next;
  (void)line_num;
  (void)fallthrough_pos;
  (void)current_line;
  return FALSE;
}

static inline void lepusng_opt_on_branch(BytecodeOptCtx *opt_ctx, int op,
                                         int label, void *ls) {
  (void)opt_ctx;
  (void)op;
  (void)label;
  (void)ls;
}

static inline void lepusng_opt_on_loc_written(BytecodeOptCtx *opt_ctx,
                                              int var_idx) {
  (void)opt_ctx;
  (void)var_idx;
}

static inline void lepusng_opt_on_emit_slu(BytecodeOptCtx *opt_ctx,
                                           int bc_out_pos, int var_idx) {
  (void)opt_ctx;
  (void)bc_out_pos;
  (void)var_idx;
}

static inline BOOL lepusng_opt_try_downgrade_get_loc_check(
    BytecodeOptCtx *opt_ctx, int idx) {
  (void)opt_ctx;
  (void)idx;
  return FALSE;
}

static inline BOOL lepusng_opt_try_downgrade_get_var_ref_check(
    BytecodeOptCtx *opt_ctx, int idx) {
  (void)opt_ctx;
  (void)idx;
  return FALSE;
}

static inline void lepusng_opt_after_emit(BytecodeOptCtx *opt_ctx, void *bc_out,
                                          int cf_emit_start) {
  (void)opt_ctx;
  (void)bc_out;
  (void)cf_emit_start;
}

static inline LepusOptResult lepusng_opt_dispatch_opcode(
    void *ctx, void *s, void *cc, const void *bc_buf, int bc_len, void *bc_out,
    void *label_slots, int pos, int *pos_next, int op, void *line_num,
    BytecodeOptCtx *opt_ctx, int *cf_emit_start, int *const_fold_pos1,
    int *const_fold_pos2, int32_t *const_fold_val1, int32_t *const_fold_val2,
    int *const_fold_is_bool1, int *const_fold_is_bool2,
    uint8_t **loc_initialized, uint8_t **var_ref_initialized,
    BOOL *before_first_backward_label, int *out_op, int *out_label,
    int *out_val, BOOL *out_has_val) {
  (void)ctx;
  (void)s;
  (void)cc;
  (void)bc_buf;
  (void)bc_len;
  (void)bc_out;
  (void)label_slots;
  (void)pos;
  (void)pos_next;
  (void)op;
  (void)line_num;
  (void)opt_ctx;
  (void)cf_emit_start;
  (void)const_fold_pos1;
  (void)const_fold_pos2;
  (void)const_fold_val1;
  (void)const_fold_val2;
  (void)const_fold_is_bool1;
  (void)const_fold_is_bool2;
  (void)loc_initialized;
  (void)var_ref_initialized;
  (void)before_first_backward_label;
  (void)out_op;
  (void)out_label;
  (void)out_val;
  (void)out_has_val;
  return LEPUS_OPT_UNHANDLED;
}

#endif /* ENABLE_LEPUSNG_BYTECODE_OPT */

#endif  // SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_OPT_BYTECODE_H_
