// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/interp/call_stub.h"

#include <iostream>

#include "gc/collector.h"
#include "gc/trace-gc.h"
#include "quickjs/include/cutils.h"
#include "quickjs/include/quickjs-inner.h"

#ifdef ENABLE_PRIMJS_TRACE
static uint64_t check_count = 0;
static uint64_t name_count[100] = {0};

static const char *get_name(int i) {
  static const char *opCodeStrings[] = {
#define DEF_CALL_DESC(name, ...) #name,
#include "primjs/son/vmTrampoline.def"
#undef DEF_CALL_DESC
  };
  return opCodeStrings[i];
}

extern "C" void call_runtime_wrapper(LEPUSContext *ctx, int index) {
  name_count[index]++;
  check_count++;
  bool print = false;
  if (check_count == 100) {
    print = true;
  }
  if (check_count == 1000) {
    print = true;
  }
  if (check_count == 10000) {
    print = true;
  }
  if (check_count == 100000) {
    print = true;
  }
  if (check_count == 1000000) {
    print = true;
  }
  if (check_count == 10000000) {
    print = true;
  }
  if (check_count == 100000000) {
    print = true;
  }
  if (print) {
    std::cout << "------------------------ check count: " << check_count
              << std::endl;
    for (int i = 0; i < 100; i++) {
      if (name_count[i] != 0) {
        std::cout << "name: " << get_name(i) << " count: " << name_count[i]
                  << std::endl;
      }
    }
  }
}

// extern "C" void call_runtime_wrapper2(LEPUSContext *ctx, int index) {
//   auto rt = ctx->rt;
//   LEPUS_RunGC(rt);
//   if (rt->gc_cnt % 1000 == 0) {
//     std::cout << "----------------> trace_gc_cnt: " << rt->gc_cnt
//               << " rt: " << rt << std::endl;
//   }
// }

static void check_heap_object(LEPUSContext *ctx, void *ptr) {
  if (!ptr) return;
  auto val1 = (uint64_t)ptr;
  if ((val1 < 0x1000) && val1 != 0) {
    if ((val1 & 0x3) == 0) {
      *((intptr_t *)0xdeadbeef) = 100;
    }
  }
}

static void check_root_object(LEPUSContext *ctx, LEPUSValue val) {
  auto val1 = (uint64_t)val.as_int64;
  if ((val1 < 0x1000) && val1 != 0) {
    if ((val1 & 0x3) == 0) {
      *((intptr_t *)0xdeadbeef) = 100;
    }
  }
}

static void check_stack_object(LEPUSContext *ctx) {
  auto rt = ctx->rt;
  LEPUSStackFrame *sf = rt->current_stack_frame;
  struct list_head *el;
  while (sf) {
    // arg_buf
    if (sf->arg_buf) {
      for (int i = 0; i < sf->arg_count; i++) {
        check_root_object(ctx, sf->arg_buf[i]);
      }
    }
    // var_buf
    if (sf->var_buf) {
      LEPUSValue *cur_sp =
          sf->cur_sp ? sf->cur_sp : (sf->sp ? sf->sp : nullptr);
      if (cur_sp) {
        for (LEPUSValue *sp = sf->var_buf; sp < cur_sp; sp++) {
          check_root_object(ctx, *sp);
        }
      }
    }
    check_root_object(ctx, sf->cur_func);
    list_for_each(el, &sf->var_ref_list) {
      JSVarRef *var_ref = list_entry(el, JSVarRef, link);
      check_heap_object(ctx, var_ref);
    }

    if (sf->var_refs) {
      check_heap_object(ctx, sf->var_refs);
    }
    sf = sf->prev_frame;
  }
}

extern "C" void verify_stack(const uint8_t *pc, const uint8_t *sp,
                             LEPUSStackFrame *sf) {
  static const uint8_t *prev_sp = nullptr;
  static LEPUSStackFrame *prev_sf = nullptr;
  static int prev_npush = 0;
  static int prev_npop = 0;
  static int prev_opcode = 0;

  if (intptr_t(sp) <= intptr_t(sf)) {
    // *((intptr_t*)0xdeadbeef) = 100;
    std::cout << std::hex << "sp: " << (intptr_t)sp << ", sf: " << (intptr_t)sf
              << std::endl;
  }
  if (sf->prev_frame != nullptr) {
    if (intptr_t(sp) > intptr_t(sf->prev_frame)) {
      // *((intptr_t*)0xdeadbeef) = 10;
      std::cout << std::hex << "sp: " << (intptr_t)sp
                << ", sf: " << (intptr_t)sf->prev_frame << std::endl;
    }
  }

  if (prev_sf == sf) {
    int diff = (intptr_t(sp) - intptr_t(prev_sp)) / sizeof(LEPUSValue);
    if ((prev_npush != 0) && (prev_npop != 0)) {
      int count = prev_npush - prev_npop;
      if (diff != count) {
        std::cout << std::oct << "diff: " << (int)diff
                  << ", count: " << (int)count << std::endl;
      }
    } else if (prev_npush != 0) {
      if (diff != prev_npush) {
        std::cout << std::oct << "diff: " << (int)diff
                  << ", n_push: " << (int)prev_npush << std::endl;
      }
    } else if (prev_npop != 0) {
      if (-diff != prev_npop) {
        std::cout << std::oct << "diff: " << (int)diff
                  << ", n_pop: " << (int)prev_npop << std::endl;
      }
    }
  }
  int bytecode = *(pc - 1);
  auto info = short_opcode_info((OPCodeEnum)bytecode);
  prev_npush = info.n_push;
  prev_npop = info.n_pop;
  prev_opcode = bytecode;
  prev_sp = sp;
  prev_sf = sf;
}

static uint64_t check_count = 0;
static uint64_t op_count[255] = {0};

extern "C" void prim_debug_trace(LEPUSContext *ctx,
                                 const intptr_t *dispatch_table,
                                 const uint8_t *pc, const uint8_t *sp,
                                 LEPUSStackFrame *sf) {
  static int trace_id = 0;
  // if (intptr_t(sp) <= intptr_t(sf)) {
  //   // *((intptr_t*)0xdeadbeef) = 100;
  //   std::cout << std::hex << "sp: " << (intptr_t)sp << ", sf: " <<
  //   (intptr_t)sf
  //             << std::endl;
  // }
  // if (sf->prev_frame != nullptr) {
  //   if (intptr_t(sp) > intptr_t(sf->prev_frame)) {
  //     *((intptr_t *)0xdeadbeef) = 10;
  //   }
  // }
  int bytecode = *(pc - 1);
  op_count[bytecode]++;
  check_count++;

  bool print = false;
  if (check_count == 100) {
    print = true;
  }
  if (check_count == 1000) {
    print = true;
  }
  if (check_count == 10000) {
    print = true;
  }
  if (check_count == 100000) {
    print = true;
  }
  if (check_count == 1000000) {
    print = true;
  }
  if (check_count == 10000000) {
    print = true;
  }
  if (check_count == 100000000) {
    print = true;
  }
  if (print) {
    std::cout << "------------------------ check count: " << check_count
              << std::endl;
    for (int i = 0; i < 255; i++) {
      auto info = short_opcode_info((OPCodeEnum)i);
      if (op_count[i] != 0) {
        const char *name = info.name;
        std::cout << "name: " << name << " count: " << op_count[i] << std::endl;
      }
    }
  }

  bool trace = false;
  if (trace) {
    auto info = short_opcode_info((OPCodeEnum)bytecode);
    const char *name = info.name;
    auto diff = (dispatch_table -
                 reinterpret_cast<const intptr_t *>(ctx->dispatch_table)) /
                (int)OP_COUNT;
    std::cout << std::hex << (uint64_t)(pc - 1) << " TRACE: id: " << std::oct
              << trace_id << ", opcode: " << bytecode << ", name: " << name;
    std::cout << "_" << diff;
    std::cout << std::hex << " sp: " << (intptr_t)sp
              << ", sf: " << (intptr_t)sf;
    std::cout << std::oct << " npush: " << (int)info.n_push
              << ", npop: " << (int)info.n_pop;
    std::cout << std::oct << " pc0: " << (int)*pc << ", pc1: " << (int)*(pc + 1)
              << std::endl;
    trace_id++;
  }
}
#endif

#ifdef ENABLE_PRIMJS_SNAPSHOT

#define PRIMJS_INTERNAL_SYMBOL __attribute__((visibility("hidden")))

extern "C" PRIMJS_INTERNAL_SYMBOL void prim_abort0(int64_t val1, int64_t val2) {
  *reinterpret_cast<int *>(0xdeadbeef) = 101;
}

#ifdef ENABLE_QUICKJS_DEBUGGER
static constexpr int NUM_OF_TOS_STATES = 3;
#endif

extern "C" PRIMJS_INTERNAL_SYMBOL void InstallDebuggerBcHandler(
    LEPUSContext *ctx, bool attach) {
  if (!attach) {
    ctx->dispatch_table = primjs_dispatch_table;
    return;
  }
#ifdef ENABLE_QUICKJS_DEBUGGER
  ctx->dispatch_table = &primjs_dispatch_table[NUM_OF_TOS_STATES];
#endif
}

extern "C" PRIMJS_INTERNAL_SYMBOL LEPUSValue prim_call_c_function_default(
    LEPUSContext *ctx, LEPUSValueConst func_obj, LEPUSValueConst this_obj,
    int argc, LEPUSValueConst *argv) {
  LEPUSCFunctionType func;
  LEPUSObject *p;
  LEPUSValue ret_val;
  LEPUSValueConst *arg_buf;
  LEPUSCFunctionEnum cproto;

  p = LEPUS_VALUE_GET_OBJ(func_obj);
  cproto = static_cast<LEPUSCFunctionEnum>(p->u.cfunc.cproto);
  arg_buf = argv;

  func = p->u.cfunc.c_function;
  switch (cproto) {
    case LEPUS_CFUNC_constructor:
    case LEPUS_CFUNC_constructor_magic:
      ret_val = LEPUS_ThrowTypeError(ctx, "must be called with new");
      break;
    case LEPUS_CFUNC_f_f: {
      double d1;

      if (unlikely(JS_ToFloat64_GC(ctx, &d1, arg_buf[0]))) {
        ret_val = LEPUS_EXCEPTION;
        break;
      }
      ret_val = LEPUS_NewFloat64(ctx, func.f_f(d1));
    } break;
    case LEPUS_CFUNC_f_f_f: {
      double d1, d2;

      if (unlikely(JS_ToFloat64_GC(ctx, &d1, arg_buf[0]))) {
        ret_val = LEPUS_EXCEPTION;
        break;
      }
      if (unlikely(JS_ToFloat64_GC(ctx, &d2, arg_buf[1]))) {
        ret_val = LEPUS_EXCEPTION;
        break;
      }
      ret_val = LEPUS_NewFloat64(ctx, func.f_f_f(d1, d2));
    } break;
    case LEPUS_CFUNC_iterator_next: {
      int done;
      ret_val = func.iterator_next(ctx, this_obj, argc, arg_buf, &done,
                                   p->u.cfunc.magic);
      if (!LEPUS_IsException(ret_val) && done != 2) {
        HandleScope func_scope(ctx, &ret_val, HANDLE_TYPE_LEPUS_VALUE);
        ret_val = js_create_iterator_result_gc(ctx, ret_val, done);
      }
    } break;
    default:
      abort();
  }
  return ret_val;
}

#undef PRIMJS_INTERNAL_SYMBOL
#endif
