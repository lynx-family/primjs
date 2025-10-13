// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/interp/call_stub.h"

#include "quickjs/include/quickjs-inner.h"

#ifdef ENABLE_PRIMJS_SNAPSHOT
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

extern "C" void prim_debug_trace(LEPUSContext *ctx, intptr_t *dispatch_table,
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

  bool trace = true;
  if (trace) {
    auto info = short_opcode_info((OPCodeEnum)bytecode);
    const char *name = info.name;
    auto diff =
        (dispatch_table - (intptr_t *)ctx->dispatch_table) / (int)OP_COUNT;
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

extern "C" void prim_abort0(int64_t val1, int64_t val2) {
  *reinterpret_cast<int *>(0xdeadbeef) = 101;
}
#endif

extern "C" void InstallBcHandler(intptr_t *handler_table);

extern "C" void _init_dispatch_table(LEPUSContext *ctx) {
  auto _table_gc = (intptr_t *)(ctx->dispatch_table);
  InstallBcHandler(_table_gc);
}

extern "C" int LEPUS_add_fast_array_element(LEPUSContext *ctx, LEPUSObject *p,
                                            LEPUSValue val) {
  uint32_t new_len, array_len;
  /* extend the array by one */
  /* XXX: convert to slow array if new_len > 2^31-1 elements */
  new_len = p->u.array.count + 1;
  /* update the length if necessary. We assume that if the length is
     not an integer, then if it >= 2^31.  */
  if (likely(LEPUS_VALUE_IS_INT(p->prop[0].u.value))) {
    array_len = LEPUS_VALUE_GET_INT(p->prop[0].u.value);
    if (new_len > array_len) {
      if (unlikely(!(get_shape_prop(p->shape)->flags & LEPUS_PROP_WRITABLE))) {
        return JS_ThrowTypeErrorReadOnly(ctx, LEPUS_PROP_THROW_STRICT,
                                         JS_ATOM_length);
      }
      p->prop[0].u.value = LEPUS_NewInt32(ctx, new_len);
    }
  }
  if (unlikely(new_len > p->u.array.u1.size)) {
    uint32_t new_size;
    size_t slack;
    LEPUSValue *new_array_prop;
    /* XXX: potential arithmetic overflow */
    new_size = max_int(new_len, p->u.array.u1.size * 3 / 2);
    new_array_prop = static_cast<LEPUSValue *>(
        lepus_realloc2(ctx, p->u.array.u.values, sizeof(LEPUSValue) * new_size,
                       &slack, ALLOC_TAG_WITHOUT_PTR));
    if (!new_array_prop) {
      return -1;
    }
    new_size += slack / sizeof(*new_array_prop);
    p->u.array.u.values = new_array_prop;
    p->u.array.u1.size = new_size;
  }
  p->u.array.u.values[new_len - 1] = val;
  p->u.array.count = new_len;
  return TRUE;
}

extern "C" void prim_copy_var_refs_gc(LEPUSStackFrame *sf,
                                      LEPUSStackFrame *old_sf) {
  list_head *el, *el1;
  JSVarRef *var_ref;
  list_for_each_safe(el, el1, &sf->var_ref_list) {
    var_ref = list_entry(el, JSVarRef, link);
    list_add_tail(&var_ref->link, &old_sf->var_ref_list);
  }
  return;
}

#endif  // ENABLE_PRIMJS_SNAPSHOT
