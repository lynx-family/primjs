// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_INTERP_CALL_STUB_H_
#define PRIMJS_INTERP_CALL_STUB_H_
#include "quickjs/include/quickjs-inner.h"

#ifdef ENABLE_PRIMJS_SNAPSHOT
struct QuickJsFrameStruct {
  void *last_lr;
  void *last_fp;
  LEPUSValue this_obj;
  LEPUSValue new_target;
  JSVarRef **var_refs_cache;
  LEPUSValue *cpool;
  int32_t argc;
  int32_t caller_argc;
};

struct QuickStackFrame {
  struct QuickStackFrame *prev_frame; /* NULL if first stack frame */
  LEPUSValue
      cur_func; /* current function, LEPUS_UNDEFINED if the frame is detached */
  LEPUSValue *arg_buf;           /* arguments */
  LEPUSValue *var_buf;           /* variables */
  struct list_head var_ref_list; /* list of JSVarRef.link */
  const uint8_t *cur_pc;         /* only used in bytecode functions : PC of the
                              instruction after the call */
  int arg_count;
  int js_mode; /* for C functions: 0 */
  /* only used in generators. Current stack pointer value. NULL if
     the function is running. */
  LEPUSValue *cur_sp;
  LEPUSValue *sp = nullptr;
  struct JSVarRef **var_refs = nullptr;
  uint32_t ref_size = 0;
};

struct QuickAsmJsFrame : public QuickStackFrame {
  QuickJsFrameStruct u;
};

struct DebuggerQuickStackFrame {
  struct DebuggerQuickStackFrame *prev_frame; /* NULL if first stack frame */
  LEPUSValue
      cur_func; /* current function, LEPUS_UNDEFINED if the frame is detached */
  LEPUSValue *arg_buf;           /* arguments */
  LEPUSValue *var_buf;           /* variables */
  struct list_head var_ref_list; /* list of JSVarRef.link */
  const uint8_t *cur_pc;         /* only used in bytecode functions : PC of the
                              instruction after the call */
  int arg_count;
  int js_mode; /* for C functions: 0 */
  /* only used in generators. Current stack pointer value. NULL if
     the function is running. */
  LEPUSValue *cur_sp;
  LEPUSValue *sp = nullptr;
  // for debugger: this_obj of the stack frame
  LEPUSValue pthis;
  struct JSVarRef **var_refs = nullptr;
  uint32_t ref_size = 0;
};

struct DebuggerQuickAsmJsFrame : public DebuggerQuickStackFrame {
  QuickJsFrameStruct u;
};
#endif  // ENABLE_PRIMJS_SNAPSHOT
#endif  // PRIMJS_INTERP_CALL_STUB_H_
