/*
 * QuickJS Javascript Engine
 *
 * Copyright (c) 2017-2019 Fabrice Bellard
 * Copyright (c) 2017-2019 Charlie Gordon
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#ifndef SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_INNER_H_
#define SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_INNER_H_

#include "quickjs/include/base_export.h"
#ifdef __cplusplus
extern "C" {
#endif

#include "quickjs/include/cutils.h"
#include "quickjs/include/list.h"
#include "quickjs/include/quickjs.h"

#ifdef CONFIG_BIGNUM
#include "quickjs/include/libbf.h"
#endif

#ifdef __cplusplus
}
#endif

#include "gc/allocator.h"
#include "quickjs/include/primjs_monitor.h"
#include "quickjs/include/quickjs_queue.h"

#ifndef _WIN32
#include <sys/mman.h>

#include <unordered_set>
#endif
#include <cstring>

#ifdef ENABLE_GC_DEBUG_TOOLS
#include <unordered_map>
#ifndef DCHECK
#define DCHECK(condition) \
  if (!(condition)) abort();
#endif
#else
#ifndef DCHECK
#define DCHECK(condition) ((void)0)
#endif
#endif

typedef int BOOL;
#define SYSCALL_CHECK(condition) \
  if ((condition) == -1) {       \
    /*abort()*/                  \
  }

#ifdef ENABLE_QUICKJS_DEBUGGER
#include "inspector/debugger_inner.h"
#endif

#include "gc/qjsvaluevalue-space.h"

#if defined(CONFIG_BIGNUM) and defined(ENABLE_LEPUSNG)
#error bignum and lepusng are now conflict!
#endif
#if defined(QJS_UNITTEST) || defined(__WASI_SDK__)
#define QJS_STATIC
#else
#define QJS_STATIC static
#endif

#define OPTIMIZE 1
#define SHORT_OPCODES 1

#if !defined(__aarch64__)
#if defined(ENABLE_PRIMJS_SNAPSHOT)
#undef ENABLE_PRIMJS_SNAPSHOT
#endif
#if defined(ENABLE_COMPATIBLE_MM)
#undef ENABLE_COMPATIBLE_MM
#endif
#endif

#ifdef ENABLE_COMPATIBLE_MM
#undef DUMP_LEAKS
#undef DEBUG_MEMORY
#endif

#define KB (1024)
#define MB (1024 * KB)
#define MS (1000)

#define BUF_LEN (100)

#ifdef ENABLE_GC_DEBUG_TOOLS
size_t get_cur_cnt(void *runtime, void *ptr);
size_t get_del_cnt(void *runtime, void *ptr);
#endif

#define __exception __attribute__((warn_unused_result))

enum JS_CLASS_ID {
  /* classid tag        */ /* union usage   | properties */
  JS_CLASS_OBJECT = 1,     /* must be first */
  JS_CLASS_ARRAY,          /* u.array       | length */
  JS_CLASS_ERROR,
  JS_CLASS_NUMBER,           /* u.object_data */
  JS_CLASS_STRING,           /* u.object_data */
  JS_CLASS_BOOLEAN,          /* u.object_data */
  JS_CLASS_SYMBOL,           /* u.object_data */
  JS_CLASS_ARGUMENTS,        /* u.array       | length */
  JS_CLASS_MAPPED_ARGUMENTS, /*               | length */
  JS_CLASS_DATE,             /* u.object_data */
  JS_CLASS_MODULE_NS,
  JS_CLASS_C_FUNCTION,          /* u.cfunc */
  JS_CLASS_BYTECODE_FUNCTION,   /* u.func */
  JS_CLASS_BOUND_FUNCTION,      /* u.bound_function */
  JS_CLASS_C_FUNCTION_DATA,     /* u.c_function_data_record */
  JS_CLASS_GENERATOR_FUNCTION,  /* u.func */
  JS_CLASS_FOR_IN_ITERATOR,     /* u.for_in_iterator */
  JS_CLASS_REGEXP,              /* u.regexp */
  JS_CLASS_ARRAY_BUFFER,        /* u.array_buffer */
  JS_CLASS_SHARED_ARRAY_BUFFER, /* u.array_buffer */
  JS_CLASS_UINT8C_ARRAY,        /* u.array (typed_array) */
  JS_CLASS_INT8_ARRAY,          /* u.array (typed_array) */
  JS_CLASS_UINT8_ARRAY,         /* u.array (typed_array) */
  JS_CLASS_INT16_ARRAY,         /* u.array (typed_array) */
  JS_CLASS_UINT16_ARRAY,        /* u.array (typed_array) */
  JS_CLASS_INT32_ARRAY,         /* u.array (typed_array) */
  JS_CLASS_UINT32_ARRAY,        /* u.array (typed_array) */
#ifdef CONFIG_BIGNUM
  JS_CLASS_BIG_INT64_ARRAY,  /* u.array (typed_array) */
  JS_CLASS_BIG_UINT64_ARRAY, /* u.array (typed_array) */
#endif
  JS_CLASS_FLOAT32_ARRAY, /* u.array (typed_array) */
  JS_CLASS_FLOAT64_ARRAY, /* u.array (typed_array) */
  JS_CLASS_DATAVIEW,      /* u.typed_array */
#ifdef CONFIG_BIGNUM
  JS_CLASS_BIG_INT,   /* u.object_data */
  JS_CLASS_BIG_FLOAT, /* u.object_data */
  JS_CLASS_FLOAT_ENV, /* u.float_env */
#endif
  JS_CLASS_MAP,                      /* u.map_state */
  JS_CLASS_SET,                      /* u.map_state */
  JS_CLASS_WEAKMAP,                  /* u.map_state */
  JS_CLASS_WEAKSET,                  /* u.map_state */
  JS_CLASS_MAP_ITERATOR,             /* u.map_iterator_data */
  JS_CLASS_SET_ITERATOR,             /* u.map_iterator_data */
  JS_CLASS_ARRAY_ITERATOR,           /* u.array_iterator_data */
  JS_CLASS_STRING_ITERATOR,          /* u.array_iterator_data */
  JS_CLASS_REGEXP_STRING_ITERATOR,   /* u.regexp_string_iterator_data */
  JS_CLASS_GENERATOR,                /* u.generator_data */
  JS_CLASS_PROXY,                    /* u.proxy_data */
  JS_CLASS_PROMISE,                  /* u.promise_data */
  JS_CLASS_PROMISE_RESOLVE_FUNCTION, /* u.promise_function_data */
  JS_CLASS_PROMISE_REJECT_FUNCTION,  /* u.promise_function_data */
  JS_CLASS_ASYNC_FUNCTION,           /* u.func */
  JS_CLASS_ASYNC_FUNCTION_RESOLVE,   /* u.async_function_data */
  JS_CLASS_ASYNC_FUNCTION_REJECT,    /* u.async_function_data */
  JS_CLASS_ASYNC_FROM_SYNC_ITERATOR, /* u.async_from_sync_iterator_data */
  JS_CLASS_ASYNC_GENERATOR_FUNCTION, /* u.func */
  JS_CLASS_ASYNC_GENERATOR,          /* u.async_generator_data */
  JS_CLASS_WeakRef,
  JS_CLASS_FinalizationRegistry,

  JS_CLASS_INIT_COUNT, /* last entry for predefined classes */
};

typedef enum JSErrorEnum {
  JS_EVAL_ERROR,
  JS_RANGE_ERROR,
  JS_REFERENCE_ERROR,
  JS_SYNTAX_ERROR,
  JS_TYPE_ERROR,
  JS_URI_ERROR,
  JS_INTERNAL_ERROR,
  JS_AGGREGATE_ERROR,

  JS_NATIVE_ERROR_COUNT, /* number of different NativeError objects */
} JSErrorEnum;

#define BUILD_ASYNC_STACK

typedef struct JSShape JSShape;
typedef struct JSString JSString;
typedef struct JSString JSAtomStruct;

typedef struct JSLepusType {
  int32_t array_typeid_;
  int32_t table_typeid_;
  int32_t refcounted_typeid_;
  LEPUSClassID refcounted_cid_;
} JSLepusType;

typedef struct PrimjsCallbacks {
  void (*print_by_alog)(char *msg);
  int32_t (*js_has_property)(LEPUSContext *, LEPUSValue, JSAtom, int32_t);
  int32_t (*js_delete_property)(LEPUSContext *, LEPUSValue, JSAtom, int32_t);
  int32_t (*js_get_own_property_names)(LEPUSContext *, LEPUSValue, uint32_t *,
                                       struct LEPUSPropertyEnum **, int32_t);
  int32_t (*js_deep_equal_callback)(LEPUSContext *, LEPUSValue, LEPUSValue);
  LEPUSValue (*jsarray_push)(LEPUSContext *, LEPUSValue, int32_t,
                             LEPUSValueConst *, int32_t);
  LEPUSValue (*jsarray_pop)(LEPUSContext *, LEPUSValue, int32_t);
  int64_t (*jsarray_find)(LEPUSContext *, LEPUSValue, LEPUSValue, int64_t,
                          int32_t);
  LEPUSValue (*jsarray_reverse)(LEPUSContext *, LEPUSValue);
  LEPUSValue (*jsarray_slice)(LEPUSContext *, LEPUSValue, size_t, size_t,
                              size_t, LEPUSValue *, int32_t);
} PrimjsCallbacks;

typedef struct JSMallocState {
  size_t malloc_count;
  // <Primjs begin>
  uint64_t malloc_size;
  uint64_t malloc_limit;
  struct malloc_state allocate_state;
  // <Primjs end>
  void *opaque; /* user opaque */
} JSMallocState;

typedef struct LEPUSMallocFunctions {
  void *(*lepus_malloc)(JSMallocState *s, size_t size, int alloc_tag);
  void (*lepus_free)(JSMallocState *s, void *ptr);
  void *(*lepus_realloc)(JSMallocState *s, void *ptr, size_t size,
                         int alloc_tag);
  size_t (*lepus_malloc_usable_size)(const void *ptr);
} LEPUSMallocFunctions;

#ifdef ENABLE_QUICKJS_DEBUGGER
typedef struct QJSDebuggerCallbacks2 {
  // callbacks for quickjs debugger
  void (*run_message_loop_on_pause)(LEPUSContext *ctx);
  void (*quit_message_loop_on_pause)(LEPUSContext *ctx);
  void (*get_messages)(LEPUSContext *ctx);
  void (*send_response)(LEPUSContext *ctx, int32_t message_id,
                        const char *message);
  void (*send_notification)(LEPUSContext *ctx, const char *message);
  void (*free_messages)(LEPUSContext *ctx, char **messages, int32_t size);

  void (*inspector_check)(LEPUSContext *ctx);
  void (*debugger_exception)(LEPUSContext *ctx);
  void (*console_message)(LEPUSContext *ctx, int tag, LEPUSValueConst *argv,
                          int argc);
  void (*script_parsed_ntfy)(LEPUSContext *ctx, LEPUSScriptSource *source);
  void (*console_api_called_ntfy)(LEPUSContext *ctx, LEPUSValue *msg);
  void (*script_fail_parse_ntfy)(LEPUSContext *ctx, LEPUSScriptSource *source);
  void (*debugger_paused)(LEPUSContext *ctx, const uint8_t *cur_pc);
  uint8_t (*is_devtool_on)(LEPUSRuntime *rt);
  void (*send_response_with_view_id)(LEPUSContext *ctx, int32_t message_id,
                                     const char *message, int32_t view_id);
  void (*send_ntfy_with_view_id)(LEPUSContext *ctx, const char *message,
                                 int32_t view_id);
  void (*script_parsed_ntfy_with_view_id)(LEPUSContext *ctx,
                                          LEPUSScriptSource *source,
                                          int32_t view_id);
  void (*script_fail_parse_ntfy_with_view_id)(LEPUSContext *ctx,
                                              LEPUSScriptSource *source,
                                              int32_t view_id);
  void (*set_session_enable_state)(LEPUSContext *ctx, int32_t view_id,
                                   int32_t protocol_type);
  void (*get_session_state)(LEPUSContext *ctx, int32_t view_id,
                            bool *is_already_enabled, bool *is_paused);
  void (*console_api_called_ntfy_with_rid)(LEPUSContext *ctx, LEPUSValue *msg);
  void (*get_session_enable_state)(LEPUSContext *ctx, int32_t view_id,
                                   int32_t protocol_type, bool *ret);
  void (*get_console_stack_trace)(LEPUSContext *ctx, LEPUSValue *ret);
  void (*on_console_message)(LEPUSContext *ctx, LEPUSValue console_message,
                             int32_t);
} QJSDebuggerCallbacks2;
#endif

typedef struct SettingsOption {
  /*
    If this value is true, quickjs will not adjust stack size
     when stack size is unconsistent.
  */
  bool disable_adjust_stacksize;
  bool disable_json_opt;
  bool disable_deepclone_opt;
  bool disable_separable_string;
} SettingsOption;
class GlobalHandles;
class GarbageCollector;
class PtrHandles;
class ByteThreadPool;
class NAPIHandleScope;

struct LEPUSRuntime {
  LEPUSMallocFunctions mf;
  const char *rt_info;

  // for trace gc

  int atom_hash_size; /* power of two */
  int atom_count;
  int atom_size;
  int atom_count_resize; /* resize hash table at this count */
  uint32_t *atom_hash;
  JSAtomStruct **atom_array;
  int atom_free_index; /* 0 = none */

  int class_count; /* size of class_array */
  LEPUSClass *class_array;

  struct list_head context_list; /* list of LEPUSContext.link */
  /* list of JSGCObjectHeader.link. List of allocated GC objects (used
       by the garbage collector) */
  /* list of allocated objects (used by the garbage collector) */
  struct list_head obj_list; /* list of LEPUSObject.link */
  // <Primjs begin>
  struct list_head gc_bytecode_list;
  struct list_head gc_obj_list;
  // <Primjs end>
  struct list_head tmp_obj_list;  /* used during gc */
  struct list_head free_obj_list; /* used during gc */
  struct list_head *el_next;      /* used during gc */
  BOOL in_gc_sweep : 8;
  int c_stack_depth;
  uint64_t malloc_gc_threshold;
  /* stack limitation */
  const uint8_t *stack_top;
  size_t stack_size; /* in bytes */

  LEPUSValue current_exception;
  /* true if a backtrace needs to be added to the current exception
     (the backtrace generation cannot be done immediately in a bytecode
     function) */
  BOOL exception_needs_backtrace;
  /* true if inside an out of memory error, to avoid recursing */
  BOOL in_out_of_memory : 8;

  struct LEPUSStackFrame *current_stack_frame;

  LEPUSInterruptHandler *interrupt_handler;
  void *interrupt_opaque;

  struct list_head job_list; /* list of JSJobEntry.link */

  LEPUSModuleNormalizeFunc *module_normalize_func;
  LEPUSModuleLoaderFunc *module_loader_func;
  void *module_loader_opaque;

  BOOL can_block : 8; /* TRUE if Atomics.wait can block */

  /* Shape hash table */
  int shape_hash_bits;
  int shape_hash_size;
  int shape_hash_count; /* number of hashed shapes */
  JSShape **shape_hash;
  PrimjsCallbacks primjs_callbacks_;

  struct list_head
      unhandled_rejections;        // record the first unhandled rejection error
  struct list_head async_func_sf;  // record all async functions' stack frame.

#ifdef BUILD_ASYNC_STACK
  LEPUSValue *current_micro_task;
#endif

#ifdef ENABLE_LEPUSNG
  LEPUSLepusRefCallbacks js_callbacks_;
  JSLepusType js_type_;
#endif

#ifdef ENABLE_QUICKJS_DEBUGGER
  QJSDebuggerCallbacks2 debugger_callbacks_;
  int32_t next_script_id;  // next script id that can be used
#endif
#ifdef CONFIG_BIGNUM
  bf_context_t bf_ctx;
#endif
  // <Primjs begin>
#ifdef ENABLE_PRIMJS_SNAPSHOT
  bool use_primjs;
#endif
#ifdef DUMP_LEAKS
  struct list_head string_list; /* list of JSString.link */
#endif
  // <Primjs end>
  void (*update_gc_info)(const char *, int);
  char gc_info_start_[BUF_LEN];
  char gc_info_end_[BUF_LEN];
  int64_t init_time;

  ByteThreadPool *workerThreadPool;
  GlobalHandles *global_handles_ = nullptr;

  QJSValueValueSpace *qjsvaluevalue_allocator = nullptr;
  PtrHandles *ptr_handles;
  GarbageCollector *gc;
  size_t gc_cnt;
  void *mem_for_oom;
  bool gc_enable;
  bool is_lepusng;
  void *user_opaque;
  // Primjs begin
  SettingsOption settings_option;
  // Primjs end
  JSMallocState malloc_state;
#ifdef ENABLE_TRACING_GC
  LEPUSObject *boilerplateArg0;
  LEPUSObject *boilerplateArg1;
  LEPUSObject *boilerplateArg2;
  LEPUSObject *boilerplateArg3;
#endif
};

static const char *const native_error_name[JS_NATIVE_ERROR_COUNT] = {
    "EvalError", "RangeError", "ReferenceError", "SyntaxError",
    "TypeError", "URIError",   "InternalError",  "AggregateError"};

/* Set/Map/WeakSet/WeakMap */

typedef struct JSMapState {
  BOOL is_weak;             /* TRUE if WeakSet/WeakMap */
  struct list_head records; /* list of JSMapRecord.link */
  uint32_t record_count;
  struct list_head *hash_table;
  uint32_t hash_size;              /* must be a power of two */
  uint32_t record_count_threshold; /* count at which a hash table
                                      resize is needed */
} JSMapState;

typedef struct JSUnhandledRejectionEntry {
  struct list_head link;
  LEPUSValue error;
  LEPUSValue promise;
} JSUnhandledRejectionEntry;

struct LEPUSClass {
  uint32_t class_id; /* 0 means free entry */
  JSAtom class_name;
  LEPUSClassFinalizer *finalizer;
  LEPUSClassGCMark *gc_mark;
  LEPUSClassCall *call;
  /* pointers for exotic behavior, can be NULL if none are present */
  const LEPUSClassExoticMethods *exotic;
};

#define JS_MODE_STRICT (1 << 0)
#define JS_MODE_STRIP (1 << 1)
#define JS_MODE_BIGINT (1 << 2)
#define JS_MODE_MATH (1 << 3)

typedef struct LEPUSStackFrame {
  struct LEPUSStackFrame *prev_frame; /* NULL if first stack frame */
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
#ifdef ENABLE_QUICKJS_DEBUGGER
  // for debugger: this_obj of the stack frame
  LEPUSValue pthis;
#endif
  struct JSVarRef **var_refs = nullptr;
  uint32_t ref_size = 0;
} LEPUSStackFrame;

enum TOK {
  TOK_NUMBER = -128,
  TOK_STRING,
  TOK_TEMPLATE,
  TOK_IDENT,
  TOK_REGEXP,
  /* warning: order matters (see js_parse_assign_expr) */
  TOK_MUL_ASSIGN,
  TOK_DIV_ASSIGN,
  TOK_MOD_ASSIGN,
  TOK_PLUS_ASSIGN,
  TOK_MINUS_ASSIGN,
  TOK_SHL_ASSIGN,
  TOK_SAR_ASSIGN,
  TOK_SHR_ASSIGN,
  TOK_AND_ASSIGN,
  TOK_XOR_ASSIGN,
  TOK_OR_ASSIGN,
#ifdef CONFIG_BIGNUM
  TOK_MATH_POW_ASSIGN,
#endif
  TOK_POW_ASSIGN,
  TOK_DOUBLE_QUESTION_MARK_ASSIGN,
  TOK_DEC,
  TOK_INC,
  TOK_SHL,
  TOK_SAR,
  TOK_SHR,
  TOK_LT,
  TOK_LTE,
  TOK_GT,
  TOK_GTE,
  TOK_EQ,
  TOK_STRICT_EQ,
  TOK_NEQ,
  TOK_STRICT_NEQ,
  TOK_LAND,
  TOK_LOR,
#ifdef CONFIG_BIGNUM
  TOK_MATH_POW,
#endif
  TOK_POW,
  TOK_ARROW,
  TOK_ELLIPSIS,
  TOK_DOUBLE_QUESTION_MARK,
  TOK_QUESTION_MARK_DOT,
  TOK_ERROR,
  TOK_PRIVATE_NAME,
  TOK_EOF,
  /* keywords: WARNING: same order as atoms */
  TOK_NULL, /* must be first */
  TOK_FALSE,
  TOK_TRUE,
  TOK_IF,
  TOK_ELSE,
  TOK_RETURN,
  TOK_VAR,
  TOK_THIS,
  TOK_DELETE,
  TOK_VOID,
  TOK_TYPEOF,
  TOK_NEW,
  TOK_IN,
  TOK_INSTANCEOF,
  TOK_DO,
  TOK_WHILE,
  TOK_FOR,
  TOK_BREAK,
  TOK_CONTINUE,
  TOK_SWITCH,
  TOK_CASE,
  TOK_DEFAULT,
  TOK_THROW,
  TOK_TRY,
  TOK_CATCH,
  TOK_FINALLY,
  TOK_FUNCTION,
  TOK_DEBUGGER,
  TOK_WITH,
  /* FutureReservedWord */
  TOK_CLASS,
  TOK_CONST,
  TOK_ENUM,
  TOK_EXPORT,
  TOK_EXTENDS,
  TOK_IMPORT,
  TOK_SUPER,
  /* FutureReservedWords when parsing strict mode code */
  TOK_IMPLEMENTS,
  TOK_INTERFACE,
  TOK_LET,
  TOK_PACKAGE,
  TOK_PRIVATE,
  TOK_PROTECTED,
  TOK_PUBLIC,
  TOK_STATIC,
  TOK_YIELD,
  TOK_AWAIT, /* must be last */
  TOK_OF,    /* only used for js_parse_skip_parens_token() */
};
#define TOK_FIRST_KEYWORD TOK_NULL
#define TOK_LAST_KEYWORD TOK_AWAIT
struct JSString {
  LEPUSRefCountHeader header; /* must come first, 32-bit */
  uint32_t len : 31;
  uint8_t is_wide_char : 1; /* 0 = 8 bits, 1 = 16 bits characters */
  /* for JS_ATOM_TYPE_SYMBOL: hash = 0, atom_type = 3,
     for JS_ATOM_TYPE_PRIVATE: hash = 1, atom_type = 3
     XXX: could change encoding to have one more bit in hash */
  uint32_t hash : 30;
  uint8_t atom_type : 2; /* != 0 if atom, JS_ATOM_TYPE_x */
  uint32_t hash_next;    /* atom_index for JS_ATOM_TYPE_SYMBOL */
#ifdef DUMP_LEAKS
  struct list_head link; /* string list */
#endif

#ifdef ENABLE_LEPUSNG
  // Primjs add
  void *cache_;  // add to convert to jsString
#endif
  union {
    uint8_t str8[0]; /* 8 bit strings will get an extra null terminator */
    uint16_t str16[0];
  } u;
};

typedef struct JSGCHeader {
  uint8_t mark;
} JSGCHeader;

typedef struct JSVarRef {
  LEPUSRefCountHeader header; /* must come first, 32-bit */
  JSGCHeader gc_header;       /* must come after LEPUSRefCountHeader, 8-bit */
  uint8_t is_arg : 1;
  /*
   * 0: the VarRef is on the stack.
   * 1: the VarRef is detached, pvalue == &value;
   */
  uint8_t is_detached : 1;
  int var_idx; /* index of the corresponding function variable on
                  the stack */
  struct list_head link;
  LEPUSValue *pvalue; /* pointer to the value, either on the stack or
                      to 'value' */
  LEPUSValue value;   /* used when the variable is no longer on the stack */
} JSVarRef;

#ifdef CONFIG_BIGNUM
typedef struct JSFloatEnv {
  limb_t prec;
  bf_flags_t flags;
  unsigned int status;
} JSFloatEnv;

typedef struct JSBigFloat {
  LEPUSRefCountHeader header; /* must come first, 32-bit */
  bf_t num;
} JSBigFloat;

/* the same structure is used for big integers and big floats. Big
   integers are never infinite or NaNs */
#else
#ifdef ENABLE_LEPUSNG
// <Primjs begin>
typedef struct JSBigFloat {
  LEPUSRefCountHeader header; /* must come first, 32-bit */
  uint64_t num;
} JSBigFloat;

// <Primjs end>
#endif
#endif

/* must be large enough to have a negligible runtime cost and small
   enough to call the interrupt callback often. */
#define JS_INTERRUPT_COUNTER_INIT 10000
// <Primjs begin>
#define DEFAULT_VIRTUAL_STACK_SIZE 1024 * 1024 * 4
#define FALLBACK_VIRTUAL_STACK_SIZE 1024 * 1024 * 1
#define MINIFY_VIRTUAL_STACK_SIZE 1024 * 1024 * 2
// <Primjs end>

// <primjs begin>
typedef unsigned char u_char;
typedef u_char *address;
// <primjs end>

typedef enum OPCodeFormat {
#define FMT(f) OP_FMT_##f,
#define DEF(id, size, n_pop, n_push, f)
#include "quickjs/include/quickjs-opcode.h"
#undef DEF
#undef FMT
} OPCodeFormat;

typedef enum OPCodeEnum {
#define FMT(f)
#define DEF(id, size, n_pop, n_push, f) OP_##id,
#define def(id, size, n_pop, n_push, f)
#include "quickjs/include/quickjs-opcode.h"
#undef def
#undef DEF
#undef FMT
  OP_COUNT, /* excluding temporary opcodes */
  /* temporary opcodes : overlap with the short opcodes */
  OP_TEMP_START = OP_nop + 1,
  OP___dummy = OP_TEMP_START - 1,
#define FMT(f)
#define DEF(id, size, n_pop, n_push, f)
#define def(id, size, n_pop, n_push, f) OP_##id,
#include "quickjs/include/quickjs-opcode.h"
#undef def
#undef DEF
#undef FMT
  OP_TEMP_END,

// The following opcode cannot be dumped into the bianry production.
#define COMPILE_TIME_OPCODE(id, size, n_pop, n_push, f) OP_##id,
#include "quickjs/include/quickjs-opcode.h"
#undef COMPILE_TIME_OPCODE

} OPCodeEnum;

struct FinalizationRegistryContext;

struct LEPUSContext {
#ifdef ENABLE_PRIMJS_SNAPSHOT
  address (*dispatch_table)[OP_COUNT];
#endif
// <primjs end>
#ifndef ALLOCATE_WINDOWS
  mstate allocate_state;
#endif
  LEPUSRuntime *rt;
  struct list_head link;

  uint16_t binary_object_count;
  int binary_object_size;

  JSShape *array_shape; /* initial shape for Array objects */

  LEPUSValue *class_proto;
  LEPUSValue function_proto;
  LEPUSValue function_ctor;
  LEPUSValue regexp_ctor;
  LEPUSValue promise_ctor;
  LEPUSValue native_error_proto[JS_NATIVE_ERROR_COUNT];
  LEPUSValue iterator_proto;
  LEPUSValue async_iterator_proto;
  LEPUSValue array_proto_values;
  LEPUSValue throw_type_error;
  LEPUSValue eval_obj;

  LEPUSValue global_obj;     /* global object */
  LEPUSValue global_var_obj; /* contains the global let/const definitions */

  uint64_t random_state;
#ifdef CONFIG_BIGNUM
  bf_context_t *bf_ctx; /* points to rt->bf_ctx, shared by all contexts */
  JSFloatEnv fp_env;    /* global FP environment */
#endif
  /* when the counter reaches zero, JSRutime.interrupt_handler is called */
  int interrupt_counter;
  BOOL is_error_property_enabled;

  struct list_head loaded_modules; /* list of LEPUSModuleDef.link */

  /* if NULL, RegExp compilation is not supported */
  LEPUSValue (*compile_regexp)(LEPUSContext *ctx, LEPUSValueConst pattern,
                               LEPUSValueConst flags);
  /* if NULL, eval is not supported */
  LEPUSValue (*eval_internal)(LEPUSContext *ctx, LEPUSValueConst this_obj,
                              const char *input, size_t input_len,
                              const char *filename, int flags, int scope_idx,
                              bool debugger_eval, LEPUSStackFrame *sf);

  void *user_opaque;
  // <Primjs begin>
  int64_t napi_env;
  BOOL no_lepus_strict_mode;
#if defined(__APPLE__) && !defined(GEN_ANDROID_EMBEDDED)
  uint32_t stack_pos;
  uint8_t *stack;
#endif
#ifdef ENABLE_QUICKJS_DEBUGGER
  LEPUSDebuggerInfo *debugger_info;  // structure for quickjs debugger
#endif
  uint32_t next_function_id;  // for lepusng debugger encode.
  uint8_t
      debuginfo_outside;  // for lepusng debugger encode to avoid break change.
  char *lynx_target_sdk_version;
  BOOL debugger_mode;
  BOOL debugger_parse_script;  // for shared context debugger
  BOOL debugger_need_polling;
  BOOL console_inspect;
  // <Primjs end>

  PtrHandles *ptr_handles;
  NAPIHandleScope *napi_scope;
  bool gc_enable;
  bool is_lepusng;
  uint64_t binary_version;
  struct FinalizationRegistryContext *fg_ctx = nullptr;
};

typedef union JSFloat64Union {
  double d;
  uint64_t u64;
  uint32_t u32[2];
} JSFloat64Union;

enum {
  JS_ATOM_TYPE_STRING = 1,
  JS_ATOM_TYPE_GLOBAL_SYMBOL,
  JS_ATOM_TYPE_SYMBOL,
  JS_ATOM_TYPE_PRIVATE,
};

enum {
  JS_ATOM_HASH_SYMBOL,
  JS_ATOM_HASH_PRIVATE,
};

typedef enum {
  JS_ATOM_KIND_STRING,
  JS_ATOM_KIND_SYMBOL,
  JS_ATOM_KIND_PRIVATE,
} JSAtomKindEnum;

#define JS_ATOM_HASH_MASK ((1 << 30) - 1)

typedef struct LEPUSClosureVar {
  uint8_t is_local : 1;
  uint8_t is_arg : 1;
  uint8_t is_const : 1;
  uint8_t is_lexical : 1;
  uint8_t var_kind : 4; /* see JSVarKindEnum */
  /* 9 bits available */
  uint16_t var_idx; /* is_local = TRUE: index to a normal variable of the
                  parent function. otherwise: index to a closure
                  variable of the parent function */
  JSAtom var_name;
} LEPUSClosureVar;

#define ARG_SCOPE_INDEX 1
#define ARG_SCOPE_END (-2)
#define DEBUG_SCOPE_INDEX (-3)

typedef struct JSVarScope {
  int parent; /* index into fd->scopes of the enclosing scope */
  int first;  /* index into fd->vars of the last variable in this scope */
} JSVarScope;

typedef enum {
  /* XXX: add more variable kinds here instead of using bit fields */
  JS_VAR_NORMAL,
  JS_VAR_FUNCTION_DECL,     /* lexical var with function declaration */
  JS_VAR_NEW_FUNCTION_DECL, /* lexical var with async/generator function
                                  declaration */
  JS_VAR_CATCH,
  JS_VAR_FUNCTION_NAME,
  JS_VAR_PRIVATE_FIELD,
  JS_VAR_PRIVATE_METHOD,
  JS_VAR_PRIVATE_GETTER,
  JS_VAR_PRIVATE_SETTER,        /* must come after JS_VAR_PRIVATE_GETTER */
  JS_VAR_PRIVATE_GETTER_SETTER, /* must come after JS_VAR_PRIVATE_SETTER
                                 */
} JSVarKindEnum;

typedef struct JSVarDef {
  JSAtom var_name;
  int scope_level; /* index into fd->scopes of this variable lexical scope */
  int scope_next;  /* index into fd->vars of the next variable in the
                    * same or enclosing lexical scope */
  uint8_t is_const : 1;
  uint8_t is_lexical : 1;
  uint8_t is_captured : 1;
  uint8_t var_kind : 4;   /* see JSVarKindEnum */
  int func_pool_idx : 24; /* only used during compilation */
} JSVarDef;

/* for the encoding of the pc2line table */
#define PC2LINE_BASE (-1)
#define PC2LINE_RANGE 5
#define PC2LINE_OP_FIRST 1
#define PC2LINE_DIFF_PC_MAX ((255 - PC2LINE_OP_FIRST) / PC2LINE_RANGE)

// <Primjs begin>
#define LINE_NUMBER_BITS_COUNT 24
#define COLUMN_NUMBER_BITS_COUNT 40
// for compatibility
#define OLD_LINE_NUMBER_BITS_COUNT 12
// use 2 bits for type.
#define LINE_COLUMN_TYPE_SHIFT 62
// <Primjs end>

typedef enum JSFunctionKindEnum {
  JS_FUNC_NORMAL = 0,
  JS_FUNC_GENERATOR = (1 << 0),
  JS_FUNC_ASYNC = (1 << 1),
  JS_FUNC_ASYNC_GENERATOR = (JS_FUNC_GENERATOR | JS_FUNC_ASYNC),
} JSFunctionKindEnum;

// <primjs begin>
enum class EntryMode { INTERPRETER, BASELINE };

#define JIT_THRESHOLD 6

// <primjs end>

// settings key opt

enum {
  PRIMJS_SNAPSHOT_ENABLE = 0b000000001,
  JSON_OPT_DISABLE = 0b000000010,
  GC_INFO_ENABLE = 0b000000100,
  DEEPCLONE_OPT_DISABLE = 0b000001000,
  LEPUSNG_HEAP_20 = 0b000010000,
  LEPUSNG_HEAP_24 = 0b000100000,
  DISABLE_ADJUST_STACKSIZE = 0b001000000,
  DISABLE_SEPARABLE_STRING = 0b010000000,
  GC_ENABLE = 0b100000000,
  EFFECT_ENABLE = 0b1000000000,
  MINIFY_STACK_ENABLE = 0b10000000000,
  ENABLE_LEPUSNG_STRAGETY = 0b100000000000,
  LEPUSNG_HEAP_12 = 0b1000000000000,
  LEPUSNG_GC_DISABLE = 0b10000000000000,
};

inline int settingsFlag = 0;
// settings key opt end

typedef struct CallerStrSlot {
  uint32_t pc;
  uint32_t size : 31;
  uint32_t is_str : 1;
  union {
    const char *str;
    uint32_t off;
  };
} CallerStrSlot;

typedef struct LEPUSFunctionBytecode {
  LEPUSRefCountHeader header; /* must come first, 32-bit */
  JSGCHeader gc_header;       /* must come after header, 8-bit */
  uint8_t js_mode;
  uint8_t has_prototype : 1; /* true if a prototype field is necessary */
  uint8_t has_simple_parameter_list : 1;
  uint8_t is_derived_class_constructor : 1;
  /* true if home_object needs to be initialized */
  uint8_t need_home_object : 1;
  uint8_t func_kind : 2;
  uint8_t new_target_allowed : 1;
  uint8_t super_call_allowed : 1;
  uint8_t super_allowed : 1;
  uint8_t arguments_allowed : 1;
  uint8_t has_debug : 1;
  uint8_t read_only_bytecode : 1;
  /* XXX: 4 bits available */
  uint8_t *byte_code_buf; /* (self pointer) */
  int byte_code_len;
  JSAtom func_name;
  JSVarDef *vardefs; /* arguments + local variables (arg_count + var_count)
                        (self pointer) */
  LEPUSClosureVar
      *closure_var; /* list of variables in the closure (self pointer) */
  uint16_t arg_count;
  uint16_t var_count;
  uint16_t defined_arg_count; /* for length function property */
  uint16_t stack_size;        /* maximum stack size */
  LEPUSValue *cpool;          /* constant pool (self pointer) */
  int cpool_count;
  int closure_var_count;

#ifdef ENABLE_QUICKJS_DEBUGGER
  DebuggerFuncLevelState func_level_state;
  struct list_head link; /*ctx->debugger_info->bytecode_list*/
  LEPUSScriptSource *script;
  int32_t bp_num;
#endif
  // <Primjs begin>
  struct list_head gc_link;
  uint32_t function_id;  // for lepusNG debugger encode
  // <Primjs end>
  struct {
    /* debug info, move to separate structure to save memory? */
    JSAtom filename;
    int line_num;
    int source_len;
    int pc2line_len;
#ifdef ENABLE_QUICKJS_DEBUGGER
    int64_t column_num;
#endif
    uint8_t *pc2line_buf;
    char *source;
    struct list_head link;
    // for cpu profiler to use.
    JSString *file_name;
    JSString *func_name;

    CallerStrSlot *caller_slots;
    size_t caller_size;
    // end.
  } debug;
  // ATTENTION: NEW MEMBERS MUST BE ADDED IN FRONT OF DEBUG FIELD!
} LEPUSFunctionBytecode;

typedef struct JSBoundFunction {
  LEPUSValue func_obj;
  LEPUSValue this_val;
  int argc;
  LEPUSValue argv[0];
} JSBoundFunction;

typedef enum JSIteratorKindEnum {
  JS_ITERATOR_KIND_KEY,
  JS_ITERATOR_KIND_VALUE,
  JS_ITERATOR_KIND_KEY_AND_VALUE,
} JSIteratorKindEnum;

typedef struct JSForInIterator {
  LEPUSValue obj;
  BOOL is_array;
  uint32_t array_length;
  uint32_t idx;
} JSForInIterator;

typedef struct JSRegExp {
  JSString *pattern;
  JSString *bytecode; /* also contains the flags */
} JSRegExp;

typedef struct JSProxyData {
  LEPUSValue target;
  LEPUSValue handler;
  LEPUSValue proto;
  uint8_t is_func;
  uint8_t is_revoked;
} JSProxyData;

typedef struct JSArrayBuffer {
  int byte_length; /* 0 if detached */
  uint8_t detached;
  uint8_t shared; /* if shared, the array buffer cannot be detached */
  uint8_t *data;  /* NULL if detached */
  struct list_head array_list;
  void *opaque;
  LEPUSFreeArrayBufferDataFunc *free_func;
  BOOL from_js_heap;
} JSArrayBuffer;

typedef struct JSTypedArray {
  struct list_head link; /* link to arraybuffer */
  LEPUSObject *obj;      /* back pointer to the TypedArray/DataView object */
  LEPUSObject *buffer;   /* based array buffer */
  uint32_t offset;       /* offset in the array buffer */
  uint32_t length;       /* length in the array buffer */
} JSTypedArray;

typedef struct JSAsyncFunctionState {
  LEPUSValue this_val; /* 'this' generator argument */
  int argc;            /* number of function arguments */
  BOOL throw_flag;     /* used to throw an exception in JS_CallInternal() */
  LEPUSStackFrame frame;
  list_head link;
#ifdef ENABLE_PRIMJS_SNAPSHOT
  LEPUSValue *_arg_buf;
#endif
} JSAsyncFunctionState;

/* XXX: could use an object instead to avoid the
   LEPUS_TAG_ASYNC_FUNCTION tag for the GC */
typedef struct JSAsyncFunctionData {
  LEPUSRefCountHeader header; /* must come first, 32-bit */
  JSGCHeader gc_header;       /* must come after LEPUSRefCountHeader, 8-bit */
  LEPUSValue resolving_funcs[2];
  BOOL is_active; /* true if the async function state is valid */
  JSAsyncFunctionState func_state;
} JSAsyncFunctionData;

typedef struct JSReqModuleEntry {
  JSAtom module_name;
  LEPUSModuleDef *module; /* used using resolution */
} JSReqModuleEntry;

typedef enum JSExportTypeEnum {
  JS_EXPORT_TYPE_LOCAL,
  JS_EXPORT_TYPE_INDIRECT,
} JSExportTypeEnum;

typedef struct JSExportEntry {
  union {
    struct {
      int var_idx;       /* closure variable index */
      JSVarRef *var_ref; /* if != NULL, reference to the variable */
    } local;             /* for local export */
    int req_module_idx;  /* module for indirect export */
  } u;
  JSExportTypeEnum export_type;
  JSAtom local_name;  /* '*' if export ns from. not used for local
                         export after compilation */
  JSAtom export_name; /* exported variable name */
} JSExportEntry;

typedef struct JSStarExportEntry {
  int req_module_idx; /* in req_module_entries */
} JSStarExportEntry;

typedef struct JSImportEntry {
  int var_idx; /* closure variable index */
  JSAtom import_name;
  int req_module_idx; /* in req_module_entries */
} JSImportEntry;

struct LEPUSModuleDef {
  LEPUSRefCountHeader header; /* must come first, 32-bit */
  JSAtom module_name;
  struct list_head link;

  JSReqModuleEntry *req_module_entries;
  int req_module_entries_count;
  int req_module_entries_size;

  JSExportEntry *export_entries;
  int export_entries_count;
  int export_entries_size;

  JSStarExportEntry *star_export_entries;
  int star_export_entries_count;
  int star_export_entries_size;

  JSImportEntry *import_entries;
  int import_entries_count;
  int import_entries_size;

  LEPUSValue module_ns;
  LEPUSValue func_obj;            /* only used for LEPUS modules */
  LEPUSModuleInitFunc *init_func; /* only used for C modules */
  BOOL resolved : 8;
  BOOL instantiated : 8;
  BOOL evaluated : 8;
  BOOL eval_mark : 8; /* temporary use during js_evaluate_module() */
  /* true if evaluation yielded an exception. It is saved in
     eval_exception */
  BOOL eval_has_exception : 8;
  LEPUSValue eval_exception;
};

typedef struct JSJobEntry {
  struct list_head link;
  LEPUSContext *ctx;
  LEPUSJobFunc *job_func;
  int argc;
  LEPUSValue argv[0];
} JSJobEntry;

typedef enum {
  WEAK_REF_KIND_WEAK_MAP,
  WEAK_REF_KIND_WEAK_REF,
  WEAK_REF_KIND_FINALIZATION_REGISTRY,
} WeakRefRecordKind;

typedef struct FinalizationRegistryContext {
  int32_t ref_count;
  LEPUSContext *ctx;
} FinalizationRegistryContext;

typedef struct FinalizationRegistryData {
  struct FinalizationRegistryContext *fg_ctx;
  list_head entries;
  LEPUSValue cbs;
} FinalizationRegistryData;

typedef struct FinalizationRegistryEntry {
  struct list_head link;
  FinalizationRegistryData *data;  // FinalizationRegistryObj
  LEPUSValue target;               // registerd object
  LEPUSValue held_value;
  LEPUSValue token;
} FinalizationRegistryEntry;

typedef struct WeakRefData {
  LEPUSValue target;
} WeakRefData;

typedef struct WeakRefRecord {
  WeakRefRecordKind kind;
  struct WeakRefRecord *next_weak_ref;
  union {
    JSMapRecord *map_record;
    FinalizationRegistryEntry *fin_node;
    WeakRefData *weak_ref;
    void *ptr;
  } u;
} WeakRefRecord;

typedef enum JSGeneratorStateEnum {
  JS_GENERATOR_STATE_SUSPENDED_START,
  JS_GENERATOR_STATE_SUSPENDED_YIELD,
  JS_GENERATOR_STATE_SUSPENDED_YIELD_STAR,
  JS_GENERATOR_STATE_EXECUTING,
  JS_GENERATOR_STATE_COMPLETED,
} JSGeneratorStateEnum;

typedef struct JSGeneratorData {
  JSGeneratorStateEnum state;
  JSAsyncFunctionState func_state;
} JSGeneratorData;

typedef struct JSProperty {
  union {
    LEPUSValue value;      /* LEPUS_PROP_NORMAL */
    struct {               /* LEPUS_PROP_GETSET */
      LEPUSObject *getter; /* NULL if undefined */
      LEPUSObject *setter; /* NULL if undefined */
    } getset;
    JSVarRef *var_ref; /* LEPUS_PROP_VARREF */
    struct {           /* LEPUS_PROP_AUTOINIT */
      LEPUSValue (*init_func)(LEPUSContext *ctx, LEPUSObject *obj, JSAtom prop,
                              void *opaque);
      void *opaque;
    } init;
  } u;
} JSProperty;

#define JS_PROP_INITIAL_SIZE 2
#define JS_PROP_INITIAL_HASH_SIZE 4 /* must be a power of two */
#define JS_ARRAY_INITIAL_SIZE 2

typedef struct JSShapeProperty {
  uint32_t hash_next : 26; /* 0 if last in list */
  uint32_t flags : 6;      /* JS_PROP_XXX */
  JSAtom atom;             /* JS_ATOM_NULL = free property entry */
} JSShapeProperty;

struct JSShape {
  uint32_t prop_hash_end[0];  /* hash table of size hash_mask + 1
                                 before the start of the structure. */
  LEPUSRefCountHeader header; /* must come first, 32-bit */
  JSGCHeader gc_header;       /* must come after LEPUSRefCountHeader, 8-bit */
  /* true if the shape is inserted in the shape hash table. If not,
     JSShape.hash is not valid */
  uint8_t is_hashed;
  /* If true, the shape may have small array index properties 'n' with 0
     <= n <= 2^31-1. If false, the shape is guaranteed not to have
     small array index properties */
  uint8_t has_small_array_index;
  uint32_t hash; /* current hash value */
  uint32_t prop_hash_mask;
  int prop_size; /* allocated properties */
  int prop_count;
  JSShape *shape_hash_next; /* in LEPUSRuntime.shape_hash[h] list */
  LEPUSObject *proto;
  JSShapeProperty prop[0]; /* prop_size elements */
};
struct LEPUSObject {
  LEPUSRefCountHeader header; /* must come first, 32-bit */
  JSGCHeader gc_header;       /* must come after LEPUSRefCountHeader, 8-bit */
  uint8_t extensible : 1;
  uint8_t free_mark : 1;      /* only used when freeing objects with cycles */
  uint8_t is_exotic : 1;      /* TRUE if object has exotic property handlers */
  uint8_t fast_array : 1;     /* TRUE if u.array is used for get/put */
  uint8_t is_constructor : 1; /* TRUE if object is a constructor function */
  uint8_t is_uncatchable_error : 1; /* if TRUE, error is not catchable */
  uint8_t is_class : 1;             /* TRUE if object is a class constructor */
  uint8_t tmp_mark : 1;             /* used in JS_WriteObjectRec() */
  uint16_t class_id;                /* see JS_CLASS_x */
  /* byte offsets: 8/8 */
  struct list_head link; /* object list */
  /* byte offsets: 16/24 */
  JSShape *shape;   /* prototype and property names + flag */
  JSProperty *prop; /* array of properties */
  /* byte offsets: 24/40 */
  struct WeakRefRecord
      *first_weak_ref; /* XXX: use a bit and an external hash table? */
  /* byte offsets: 28/48 */
  union {
    void *opaque;
    struct JSBoundFunction *bound_function; /* JS_CLASS_BOUND_FUNCTION */
    struct JSCFunctionDataRecord
        *c_function_data_record;             /* JS_CLASS_C_FUNCTION_DATA */
    struct JSForInIterator *for_in_iterator; /* JS_CLASS_FOR_IN_ITERATOR */
    struct JSArrayBuffer *array_buffer;      /* JS_CLASS_ARRAY_BUFFER,
                                                   JS_CLASS_SHARED_ARRAY_BUFFER */
    struct JSTypedArray
        *typed_array; /* JS_CLASS_UINT8C_ARRAY..JS_CLASS_DATAVIEW */
#ifdef CONFIG_BIGNUM
    struct JSFloatEnv *float_env; /* JS_CLASS_FLOAT_ENV */
#endif
    struct JSMapState *map_state; /* JS_CLASS_MAP..JS_CLASS_WEAKSET */
    struct JSMapIteratorData *map_iterator_data; /* JS_CLASS_MAP_ITERATOR,
                                                       JS_CLASS_SET_ITERATOR */
    struct JSArrayIteratorData
        *array_iterator_data; /* JS_CLASS_ARRAY_ITERATOR,
                                 JS_CLASS_STRING_ITERATOR */
    struct JSRegExpStringIteratorData
        *regexp_string_iterator_data; /* JS_CLASS_REGEXP_STRING_ITERATOR */
    struct JSGeneratorData *generator_data; /* JS_CLASS_GENERATOR */
    struct JSProxyData *proxy_data;         /* JS_CLASS_PROXY */
    struct JSPromiseData *promise_data;     /* JS_CLASS_PROMISE */
    struct JSPromiseFunctionData
        *promise_function_data; /* JS_CLASS_PROMISE_RESOLVE_FUNCTION,
                                   JS_CLASS_PROMISE_REJECT_FUNCTION */
    struct JSAsyncFunctionData
        *async_function_data; /* JS_CLASS_ASYNC_FUNCTION_RESOLVE,
                                 JS_CLASS_ASYNC_FUNCTION_REJECT */
    struct JSAsyncFromSyncIteratorData
        *async_from_sync_iterator_data; /* JS_CLASS_ASYNC_FROM_SYNC_ITERATOR
                                         */
    struct JSAsyncGeneratorData
        *async_generator_data; /* JS_CLASS_ASYNC_GENERATOR */
    struct FinalizationRegistryData
        *fin_reg_data;  // JS_CLASS_FinalizationRegistry
    struct WeakRefData *weak_ref_data;
    struct { /* JS_CLASS_BYTECODE_FUNCTION: 12/24
 bytes */
      /* also used by JS_CLASS_GENERATOR_FUNCTION, JS_CLASS_ASYNC_FUNCTION
       * and JS_CLASS_ASYNC_GENERATOR_FUNCTION */
      struct LEPUSFunctionBytecode *function_bytecode;
      JSVarRef **var_refs;
      LEPUSObject *home_object; /* for 'super' access */
    } func;
    struct { /* JS_CLASS_C_FUNCTION: 12/20 bytes */
      LEPUSCFunctionType c_function;
      uint8_t length;
      uint8_t cproto;
      int16_t magic;
    } cfunc;
    /* array part for fast arrays and typed arrays */
    struct { /* JS_CLASS_ARRAY, JS_CLASS_ARGUMENTS,
                JS_CLASS_UINT8C_ARRAY..JS_CLASS_FLOAT64_ARRAY */
      union {
        uint32_t size; /* JS_CLASS_ARRAY, JS_CLASS_ARGUMENTS */
        struct JSTypedArray
            *typed_array; /* JS_CLASS_UINT8C_ARRAY..JS_CLASS_FLOAT64_ARRAY
                           */
      } u1;
      union {
        LEPUSValue *values; /* JS_CLASS_ARRAY, JS_CLASS_ARGUMENTS */
        void *ptr;          /* JS_CLASS_UINT8C_ARRAY..JS_CLASS_FLOAT64_ARRAY */
        int8_t *int8_ptr;   /* JS_CLASS_INT8_ARRAY */
        uint8_t *uint8_ptr; /* JS_CLASS_UINT8_ARRAY, JS_CLASS_UINT8C_ARRAY */
        int16_t *int16_ptr; /* JS_CLASS_INT16_ARRAY */
        uint16_t *uint16_ptr; /* JS_CLASS_UINT16_ARRAY */
        int32_t *int32_ptr;   /* JS_CLASS_INT32_ARRAY */
        uint32_t *uint32_ptr; /* JS_CLASS_UINT32_ARRAY */
        int64_t *int64_ptr;   /* JS_CLASS_INT64_ARRAY */
        uint64_t *uint64_ptr; /* JS_CLASS_UINT64_ARRAY */
        float *float_ptr;     /* JS_CLASS_FLOAT32_ARRAY */
        double *double_ptr;   /* JS_CLASS_FLOAT64_ARRAY */
      } u;
      uint32_t count;       /* <= 2^31-1. 0 for a detached typed array */
    } array;                /* 12/20 bytes */
    JSRegExp regexp;        /* JS_CLASS_REGEXP: 8/16 bytes */
    LEPUSValue object_data; /* for JS_SetObjectData(): 8/16/16 bytes */
  } u;
  /* byte sizes: 40/48/72 */
};

constexpr const char *lepusjs_filename = "file://lepus.js";
constexpr const char *lepusng_functionid_str = "__lepusNG_function_id__";

enum {
  JS_ATOM_NULL,
#define DEF(name, str) JS_ATOM_##name,
#include "quickjs/include/quickjs-atom.h"
#undef DEF
  JS_ATOM_END,
};
#define JS_ATOM_LAST_KEYWORD JS_ATOM_super
#define JS_ATOM_LAST_STRICT_KEYWORD JS_ATOM_yield

static const char js_atom_init[] =
#define DEF(name, str) str "\0"
#include "quickjs/include/quickjs-atom.h"
#undef DEF
    ;

typedef struct JSOpCode {
#if defined(ENABLE_PRIMJS_SNAPSHOT) || defined(DUMP_BYTECODE)
  const char *name;
#endif

  uint8_t size; /* in bytes */
  /* the opcodes remove n_pop items from the top of the stack, then
     pushes n_push items */
  uint8_t n_pop;
  uint8_t n_push;
  uint8_t fmt;
} JSOpCode;

extern const JSOpCode opcode_info[];

#if SHORT_OPCODES
/* After the final compilation pass, short opcodes are used. Their
   opcodes overlap with the temporary opcodes which cannot appear in
   the final bytecode. Their description is after the temporary
   opcodes in opcode_info[]. */
#define short_opcode_info(op)                                              \
  opcode_info[(op) >= OP_TEMP_START ? (op) + (OP_TEMP_END - OP_TEMP_START) \
                                    : (op)]
#else
#define short_opcode_info(op) opcode_info[op]
#endif

// <primjs begin>

#if defined(ANDROID) || defined(__ANDROID__)
#include <android/log.h>

#define LOG_TAG "primjs"

#ifndef LOGD
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)
#endif
#ifndef LOGE
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#endif
#ifndef LOGI
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#endif
#endif

#define PRINT_LOG_TO_FILE 0

#ifdef ENABLE_PRIMJS_TRACE
#if defined(ANDROID) || defined(__ANDROID__)
#if PRINT_LOG_TO_FILE
extern FILE *log_f;
#define PRIM_LOG(...)            \
  do {                           \
    fprintf(log_f, __VA_ARGS__); \
    fflush(log_f);               \
  } while (0)
#else
#define PRIM_LOG(...) \
  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#endif  // PRINT_LOG_TO_FILE
#else
#define PRIM_LOG printf
#endif  // ANDROID
#else
#define PRIM_LOG(...)
#endif  // ENABLE_PRIMJS_TRACE

#define OP_DEFINE_METHOD_METHOD 0
#define OP_DEFINE_METHOD_GETTER 1
#define OP_DEFINE_METHOD_SETTER 2
#define OP_DEFINE_METHOD_ENUMERABLE 4

#define JS_THROW_VAR_RO 0
#define JS_THROW_VAR_REDECL 1
#define JS_THROW_VAR_UNINITIALIZED 2
#define JS_THROW_ERROR_DELETE_SUPER 3

#define LEPUS_CALL_FLAG_CONSTRUCTOR (1 << 0)
#define JS_CALL_FLAG_COPY_ARGV (1 << 1)
#define JS_CALL_FLAG_GENERATOR (1 << 2)

#define __exception __attribute__((warn_unused_result))

/* JSAtom support */
#define JS_ATOM_TAG_INT (1U << 31)
#define JS_ATOM_MAX_INT (JS_ATOM_TAG_INT - 1)
#define JS_ATOM_MAX ((1U << 30) - 1)

/* return the max count from the hash size */
#define JS_ATOM_COUNT_RESIZE(n) ((n) * 2)

/* argument of OP_special_object */
typedef enum {
  OP_SPECIAL_OBJECT_ARGUMENTS,
  OP_SPECIAL_OBJECT_MAPPED_ARGUMENTS,
  OP_SPECIAL_OBJECT_THIS_FUNC,
  OP_SPECIAL_OBJECT_NEW_TARGET,
  OP_SPECIAL_OBJECT_HOME_OBJECT,
  OP_SPECIAL_OBJECT_VAR_OBJECT,
} OPSpecialObjectEnum;

#define FUNC_RET_AWAIT 0
#define FUNC_RET_YIELD 1
#define FUNC_RET_YIELD_STAR 2

#define HINT_STRING 0
#define HINT_NUMBER 1
#define HINT_NONE 2
#ifdef CONFIG_BIGNUM
#define HINT_INTEGER 3
#endif
/* don't try Symbol.toPrimitive */
#define HINT_FORCE_ORDINARY (1 << 4)

#define prim_abort()                               \
  {                                                \
    printf("[%s:%d] Abort\n", __FILE__, __LINE__); \
    abort();                                       \
  }

#ifdef __cplusplus
extern "C" {
#endif

inline void *system_malloc(size_t size) {
  void *ptr;
  ptr = malloc(size);
  if (!ptr) return NULL;
  return ptr;
}
inline void *system_mallocz(size_t size) {
  void *ptr;
  ptr = system_malloc(size);
  if (!ptr) return NULL;
  return memset(ptr, 0, size);
}
inline __attribute__((unused)) void *system_realloc(void *ptr, size_t size) {
  if (!ptr) {
    if (size == 0) return NULL;
    return system_malloc(size);
  }
  if (size == 0) {
    free(ptr);
    return NULL;
  }

  ptr = realloc(ptr, size);
  if (!ptr) return NULL;
  return ptr;
}
inline void system_free(void *ptr) {
  if (!ptr) return;
  free(ptr);
}

typedef struct JSSeparableString {
  LEPUSRefCountHeader header; /* ref count for gc*/
  uint32_t len : 31;
  uint8_t is_wide_char : 1;
  uint32_t depth;
  LEPUSValue left_op;
  LEPUSValue right_op;
  LEPUSValue flat_content;
} JSSeparableString;

class CStack {
  using element = JSSeparableString *;
  element *base_ = nullptr;
  element *top_ = nullptr;
  size_t stack_size_ = 0;
  LEPUSRuntime *runtime_ = nullptr;
  static constexpr size_t STACK_INIT_SIZE = 64;

 public:
  explicit CStack(LEPUSRuntime *rt, uint32_t depth = STACK_INIT_SIZE) {
    runtime_ = rt;
    base_ = static_cast<element *>(system_malloc(sizeof(element) * depth));
    if (!base_) return;
    top_ = base_;
    stack_size_ = depth;
  }

  ~CStack() { system_free(base_); }

  void Push(element node) {
    if (static_cast<size_t>(top_ - base_) >= stack_size_) {
      base_ = static_cast<element *>(
          system_realloc(base_, 2 * stack_size_ * sizeof(element)));
      if (!base_) {
        stack_size_ = 0;
        top_ = nullptr;
        return;
      }
      top_ = base_ + stack_size_;
      stack_size_ *= 2;
    }
    *top_++ = node;
  }

  void Pop() {
    if (!Empty()) {
      --top_;
    }
  }

  element Top() {
    if (!Empty()) {
      return *(top_ - 1);
    }
    return nullptr;
  }

  int32_t Empty() { return top_ == base_; }
};

QJS_STATIC inline int32_t JS_IsSeparableString(LEPUSValue val) {
  return LEPUS_VALUE_IS_SEPARABLE_STRING(val);
}

QJS_STATIC inline JSSeparableString *JS_GetSeparableString(LEPUSValue val) {
  return reinterpret_cast<JSSeparableString *>(LEPUS_VALUE_GET_PTR(val));
}

LEPUSValue JS_GetSeparableStringContent(LEPUSContext *ctx, LEPUSValue val);
LEPUSValue JS_GetSeparableStringContentNotDup(LEPUSContext *ctx,
                                              LEPUSValue val);

QJS_HIDE LEPUSValue JS_GetPropertyInternalImpl(LEPUSContext *ctx,
                                               LEPUSValueConst obj, JSAtom prop,
                                               LEPUSValueConst this_obj,
                                               BOOL throw_ref_error);
QJS_HIDE LEPUSValue JS_GetPropertyInternalImpl_GC(LEPUSContext *ctx,
                                                  LEPUSValueConst obj,
                                                  JSAtom prop,
                                                  LEPUSValueConst this_obj,
                                                  BOOL throw_ref_error);
QJS_HIDE void prim_js_print(const char *msg);
QJS_HIDE void prim_js_print_gc(const char *msg);

QJS_HIDE void prim_js_print_register(uint64_t reg_val);

QJS_HIDE void prim_js_print_trace(int bytecode, int tos);
QJS_HIDE void prim_js_print_trace_gc(int bytecode, int tos);

QJS_HIDE void prim_js_print_func(LEPUSContext *ctx, LEPUSValue func_obj);
QJS_HIDE void prim_js_print_func_gc(LEPUSContext *ctx, LEPUSValue func_obj);

QJS_HIDE void JS_FreeValueRef(LEPUSContext *ctx, LEPUSValue v);

QJS_HIDE LEPUSValue js_closure(LEPUSContext *ctx, LEPUSValue bfunc,
                               JSVarRef **cur_var_refs, LEPUSStackFrame *sf);
LEPUSValue js_closure_gc(LEPUSContext *ctx, LEPUSValue bfunc,
                         JSVarRef **cur_var_refs, LEPUSStackFrame *sf);

QJS_HIDE void DebuggerPause(LEPUSContext *ctx, LEPUSValue val,
                            const uint8_t *pc);

QJS_HIDE void DebuggerCallEachOp(LEPUSContext *ctx, const uint8_t *pc,
                                 LEPUSFunctionBytecode *b);

QJS_HIDE void DebuggerCallEachFunc(LEPUSContext *ctx, const uint8_t *pc);

QJS_HIDE LEPUSValue __JS_AtomToValue(LEPUSContext *ctx, JSAtom atom,
                                     BOOL force_string);
QJS_HIDE LEPUSValue __JS_AtomToValue_GC(LEPUSContext *ctx, JSAtom atom,
                                        BOOL force_string);
QJS_HIDE BOOL js_check_stack_overflow(LEPUSContext *ctx, size_t alloca_size);
QJS_HIDE LEPUSValue JS_ThrowStackOverflow(LEPUSContext *ctx);
QJS_HIDE LEPUSValue JS_ThrowStackOverflow_GC(LEPUSContext *ctx);
QJS_HIDE void build_backtrace(
    LEPUSContext *ctx, LEPUSValueConst error_obj, const char *filename,
    /* <Primjs begin> */ int64_t line_num, /* <Primjs end> */
    const uint8_t *cur_pc, int backtrace_flags, uint8_t is_parse_error = 0);
QJS_HIDE LEPUSValue JS_NewSymbolFromAtom(LEPUSContext *ctx, JSAtom descr,
                                         int atom_type);
QJS_HIDE LEPUSValue JS_NewSymbolFromAtom_GC(LEPUSContext *ctx, JSAtom descr,
                                            int atom_type);
QJS_HIDE LEPUSValue JS_ToObject_GC(LEPUSContext *ctx, LEPUSValueConst val);
QJS_HIDE LEPUSValue PRIM_JS_NewObject(LEPUSContext *ctx);
QJS_HIDE LEPUSValue PRIM_JS_NewObject_GC(LEPUSContext *ctx);
QJS_HIDE LEPUSValue js_build_arguments(LEPUSContext *ctx, int argc,
                                       LEPUSValueConst *argv);
QJS_HIDE LEPUSValue js_build_arguments_gc(LEPUSContext *ctx, int argc,
                                          LEPUSValueConst *argv);
QJS_HIDE LEPUSValue js_build_mapped_arguments(LEPUSContext *ctx, int argc,
                                              LEPUSValueConst *argv,
                                              LEPUSStackFrame *sf,
                                              int arg_count);
QJS_HIDE LEPUSValue js_build_mapped_arguments_gc(LEPUSContext *ctx, int argc,
                                                 LEPUSValueConst *argv,
                                                 LEPUSStackFrame *sf,
                                                 int arg_count);
QJS_HIDE void prim_close_var_refs(LEPUSContext *ctx, LEPUSStackFrame *sf);
QJS_HIDE void prim_close_var_refs_gc(LEPUSContext *ctx, LEPUSStackFrame *sf);
QJS_HIDE LEPUSValue js_build_rest(LEPUSContext *ctx, int first, int argc,
                                  LEPUSValueConst *argv);
QJS_HIDE LEPUSValue js_build_rest_gc(LEPUSContext *ctx, int first, int argc,
                                     LEPUSValueConst *argv);
QJS_HIDE LEPUSValue js_function_apply(LEPUSContext *ctx,
                                      LEPUSValueConst this_val, int argc,
                                      LEPUSValueConst *argv, int magic);
QJS_HIDE LEPUSValue js_function_apply_gc(LEPUSContext *ctx,
                                         LEPUSValueConst this_val, int argc,
                                         LEPUSValueConst *argv, int magic);
QJS_HIDE int JS_CheckBrand(LEPUSContext *ctx, LEPUSValueConst obj,
                           LEPUSValueConst func);
QJS_HIDE int JS_CheckBrand_GC(LEPUSContext *ctx, LEPUSValueConst obj,
                              LEPUSValueConst func);
QJS_HIDE int JS_AddBrand(LEPUSContext *ctx, LEPUSValueConst obj,
                         LEPUSValueConst home_obj);
QJS_HIDE int JS_AddBrand_GC(LEPUSContext *ctx, LEPUSValueConst obj,
                            LEPUSValueConst home_obj);
QJS_HIDE int JS_ThrowTypeErrorReadOnly(LEPUSContext *ctx, int flags,
                                       JSAtom atom);
QJS_HIDE LEPUSValue JS_ThrowSyntaxErrorVarRedeclaration(LEPUSContext *ctx,
                                                        JSAtom prop);
QJS_HIDE LEPUSValue JS_ThrowSyntaxErrorVarRedeclaration_GC(LEPUSContext *ctx,
                                                           JSAtom prop);
QJS_HIDE LEPUSValue JS_ThrowReferenceErrorUninitialized(LEPUSContext *ctx,
                                                        JSAtom name);
QJS_HIDE LEPUSValue JS_ThrowReferenceErrorUninitialized_GC(LEPUSContext *ctx,
                                                           JSAtom name);
QJS_HIDE int JS_IteratorClose(LEPUSContext *ctx, LEPUSValueConst enum_obj,
                              BOOL is_exception_pending);

QJS_HIDE LEPUSValue JS_CallConstructorInternal(LEPUSContext *ctx,
                                               LEPUSValueConst func_obj,
                                               LEPUSValueConst new_target,
                                               int argc, LEPUSValue *argv,
                                               int flags);
QJS_HIDE LEPUSValue JS_CallConstructorInternal_GC(LEPUSContext *ctx,
                                                  LEPUSValueConst func_obj,
                                                  LEPUSValueConst new_target,
                                                  int argc, LEPUSValue *argv,
                                                  int flags);
QJS_HIDE int JS_CheckGlobalVar(LEPUSContext *ctx, JSAtom prop);
QJS_HIDE int JS_CheckGlobalVar_GC(LEPUSContext *ctx, JSAtom prop);
QJS_HIDE LEPUSValue JS_GetPropertyValue(LEPUSContext *ctx,
                                        LEPUSValueConst this_obj,
                                        LEPUSValue prop);

QJS_HIDE LEPUSValue JS_GetPropertyValue_GC(LEPUSContext *ctx,
                                           LEPUSValueConst this_obj,
                                           LEPUSValue prop);
QJS_HIDE int JS_DefineGlobalVar(LEPUSContext *ctx, JSAtom prop, int def_flags);
QJS_HIDE int JS_DefineGlobalVar_GC(LEPUSContext *ctx, JSAtom prop,
                                   int def_flags);
QJS_HIDE LEPUSValue PRIM_JS_NewArray(LEPUSContext *ctx);
QJS_HIDE LEPUSValue PRIM_JS_NewArray_GC(LEPUSContext *ctx);

QJS_HIDE LEPUSValue js_regexp_constructor_internal(LEPUSContext *ctx,
                                                   LEPUSValueConst ctor,
                                                   LEPUSValue pattern,
                                                   LEPUSValue bc);
QJS_HIDE LEPUSValue js_regexp_constructor_internal_gc(LEPUSContext *ctx,
                                                      LEPUSValueConst ctor,
                                                      LEPUSValue pattern,
                                                      LEPUSValue bc);
QJS_HIDE int JS_SetPropertyValue(LEPUSContext *ctx, LEPUSValueConst this_obj,
                                 LEPUSValue prop, LEPUSValue val, int flags);
QJS_HIDE int JS_SetPropertyValue_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                                    LEPUSValue prop, LEPUSValue val, int flags);
QJS_HIDE int JS_CheckDefineGlobalVar(LEPUSContext *ctx, JSAtom prop, int flags);
QJS_HIDE int JS_CheckDefineGlobalVar_GC(LEPUSContext *ctx, JSAtom prop,
                                        int flags);
QJS_HIDE int JS_DefineGlobalFunction(LEPUSContext *ctx, JSAtom prop,
                                     LEPUSValueConst func, int def_flags);
QJS_HIDE int JS_DefineGlobalFunction_GC(LEPUSContext *ctx, JSAtom prop,
                                        LEPUSValueConst func, int def_flags);
QJS_HIDE LEPUSValue JS_GetPrivateField(LEPUSContext *ctx, LEPUSValueConst obj,
                                       LEPUSValueConst name);
QJS_HIDE LEPUSValue JS_GetPrivateField_GC(LEPUSContext *ctx,
                                          LEPUSValueConst obj,
                                          LEPUSValueConst name);
QJS_HIDE int JS_DefinePrivateField(LEPUSContext *ctx, LEPUSValueConst obj,
                                   LEPUSValueConst name, LEPUSValue val);
QJS_HIDE int JS_DefinePrivateField_GC(LEPUSContext *ctx, LEPUSValueConst obj,
                                      LEPUSValueConst name, LEPUSValue val);
QJS_HIDE int JS_DefineObjectName(LEPUSContext *ctx, LEPUSValueConst obj,
                                 JSAtom name, int flags);
QJS_HIDE int JS_DefineObjectNameComputed(LEPUSContext *ctx, LEPUSValueConst obj,
                                         LEPUSValueConst str, int flags);
QJS_HIDE int JS_DefineObjectNameComputed_GC(LEPUSContext *ctx,
                                            LEPUSValueConst obj,
                                            LEPUSValueConst str, int flags);
QJS_HIDE int JS_SetPrototypeInternal(LEPUSContext *ctx, LEPUSValueConst obj,
                                     LEPUSValueConst proto_val,
                                     BOOL throw_flag);
QJS_HIDE int JS_SetPrototypeInternal_GC(LEPUSContext *ctx, LEPUSValueConst obj,
                                        LEPUSValueConst proto_val,
                                        BOOL throw_flag);
QJS_HIDE void js_method_set_home_object(LEPUSContext *ctx,
                                        LEPUSValueConst func_obj,
                                        LEPUSValueConst home_obj);
QJS_HIDE void js_method_set_home_object_gc(LEPUSContext *ctx,
                                           LEPUSValueConst func_obj,
                                           LEPUSValueConst home_obj);
QJS_HIDE int JS_DefinePropertyValueValue(LEPUSContext *ctx,
                                         LEPUSValueConst this_obj,
                                         LEPUSValue prop, LEPUSValue val,
                                         int flags);
QJS_HIDE int JS_DefinePropertyValueValue_GC(LEPUSContext *ctx,
                                            LEPUSValueConst this_obj,
                                            LEPUSValue prop, LEPUSValue val,
                                            int flags);
QJS_HIDE __exception int js_append_enumerate(LEPUSContext *ctx, LEPUSValue *sp);
QJS_HIDE __exception int js_append_enumerate_gc(LEPUSContext *ctx,
                                                LEPUSValue *sp);
QJS_HIDE int js_method_set_properties(LEPUSContext *ctx,
                                      LEPUSValueConst func_obj, JSAtom name,
                                      int flags, LEPUSValueConst home_obj);
QJS_HIDE int js_method_set_properties_gc(LEPUSContext *ctx,
                                         LEPUSValueConst func_obj, JSAtom name,
                                         int flags, LEPUSValueConst home_obj);
QJS_HIDE int prim_js_copy_data_properties(LEPUSContext *ctx, LEPUSValue *sp,
                                          int mask);
QJS_HIDE int prim_js_copy_data_properties_gc(LEPUSContext *ctx, LEPUSValue *sp,
                                             int mask);
QJS_HIDE int JS_ToBoolFree(LEPUSContext *ctx, LEPUSValue val);
QJS_HIDE int JS_ToBoolFree_GC(LEPUSContext *ctx, LEPUSValue val);
QJS_HIDE int js_op_define_class(LEPUSContext *ctx, LEPUSValue *sp,
                                JSAtom class_name, int class_flags,
                                JSVarRef **cur_var_refs, LEPUSStackFrame *sf);
QJS_HIDE void close_lexical_var(LEPUSContext *ctx, LEPUSStackFrame *sf,
                                int idx);
QJS_HIDE int JS_SetPropertyGeneric(LEPUSContext *ctx, LEPUSObject *p,
                                   JSAtom prop, LEPUSValue val,
                                   LEPUSValueConst this_obj, int flags);
QJS_HIDE int JS_SetPropertyGeneric_GC(LEPUSContext *ctx, LEPUSObject *p,
                                      JSAtom prop, LEPUSValue val,
                                      LEPUSValueConst this_obj, int flags);
QJS_HIDE int JS_SetPrivateField(LEPUSContext *ctx, LEPUSValueConst obj,
                                LEPUSValueConst name, LEPUSValue val);
QJS_HIDE int JS_SetPrivateField_GC(LEPUSContext *ctx, LEPUSValueConst obj,
                                   LEPUSValueConst name, LEPUSValue val);
QJS_HIDE LEPUSValue JS_ThrowTypeErrorNotAnObject(LEPUSContext *ctx);
QJS_HIDE int prim_js_with_op_gc(LEPUSContext *ctx, LEPUSValue *sp, JSAtom atom,
                                int is_with, int opcode);
QJS_HIDE JSVarRef *get_var_ref(LEPUSContext *ctx, LEPUSStackFrame *sf,
                               int var_idx, BOOL is_arg);
QJS_HIDE JSVarRef *get_var_ref_gc(LEPUSContext *ctx, LEPUSStackFrame *sf,
                                  int var_idx, BOOL is_arg);
QJS_HIDE void free_var_ref(LEPUSRuntime *rt, JSVarRef *var_ref);

QJS_HIDE JSProperty *add_property(LEPUSContext *ctx, LEPUSObject *p,
                                  JSAtom prop, int prop_flags);
QJS_HIDE JSProperty *add_property_gc(LEPUSContext *ctx, LEPUSObject *p,
                                     JSAtom prop, int prop_flags);
QJS_HIDE LEPUSValue prim_js_op_eval(LEPUSContext *ctx, int scope_idx,
                                    LEPUSValue op1);
QJS_HIDE LEPUSValue prim_js_op_eval_gc(LEPUSContext *ctx, int scope_idx,
                                       LEPUSValue op1);
QJS_HIDE int prim_js_with_op(LEPUSContext *ctx, LEPUSValue *sp, JSAtom atom,
                             int is_with, int opcode);

QJS_HIDE LEPUSValue JS_GetGlobalVarImpl(LEPUSContext *ctx, JSAtom prop,
                                        BOOL throw_ref_error);
QJS_HIDE LEPUSValue JS_GetGlobalVarImpl_GC(LEPUSContext *ctx, JSAtom prop,
                                           BOOL throw_ref_error);
QJS_HIDE int JS_GetGlobalVarRef(LEPUSContext *ctx, JSAtom prop, LEPUSValue *sp);
QJS_HIDE int JS_GetGlobalVarRef_GC(LEPUSContext *ctx, JSAtom prop,
                                   LEPUSValue *sp);
QJS_HIDE LEPUSValue prim_js_for_in_start(LEPUSContext *ctx, LEPUSValue op);
QJS_HIDE LEPUSValue prim_js_for_in_start_gc(LEPUSContext *ctx, LEPUSValue op);
QJS_HIDE int js_for_in_next(LEPUSContext *ctx, LEPUSValue *sp);
QJS_HIDE int js_for_in_next_gc(LEPUSContext *ctx, LEPUSValue *sp);
QJS_HIDE int js_for_await_of_next(LEPUSContext *ctx, LEPUSValue *sp);
QJS_HIDE int js_for_await_of_next_gc(LEPUSContext *ctx, LEPUSValue *sp);
QJS_HIDE int js_iterator_get_value_done(LEPUSContext *ctx, LEPUSValue *sp);
QJS_HIDE int js_iterator_get_value_done_gc(LEPUSContext *ctx, LEPUSValue *sp);
QJS_HIDE int js_for_of_start(LEPUSContext *ctx, LEPUSValue *sp, BOOL is_async);
QJS_HIDE int js_for_of_start_gc(LEPUSContext *ctx, LEPUSValue *sp,
                                BOOL is_async);
QJS_HIDE int js_for_of_next(LEPUSContext *ctx, LEPUSValue *sp, int offset);
QJS_HIDE int js_for_of_next_gc(LEPUSContext *ctx, LEPUSValue *sp, int offset);
QJS_HIDE LEPUSValue *prim_js_iterator_close_return(LEPUSContext *ctx,
                                                   LEPUSValue *sp,
                                                   LEPUSValue *stack_buf);
QJS_HIDE LEPUSValue *prim_js_iterator_close_return_gc(LEPUSContext *ctx,
                                                      LEPUSValue *sp);
QJS_HIDE int prim_js_async_iterator_close(LEPUSContext *ctx, LEPUSValue *sp);
QJS_HIDE int prim_js_async_iterator_close_gc(LEPUSContext *ctx, LEPUSValue *sp);
QJS_HIDE int prim_js_async_iterator_get(LEPUSContext *ctx, LEPUSValue *sp,
                                        int flags);
QJS_HIDE int prim_js_async_iterator_get_gc(LEPUSContext *ctx, LEPUSValue *sp,
                                           int flags);
QJS_HIDE LEPUSValue primjs_get_super_ctor(LEPUSContext *ctx, LEPUSValue op);
QJS_HIDE LEPUSValue primjs_get_super_ctor_gc(LEPUSContext *ctx, LEPUSValue op);
QJS_HIDE int prim_js_iterator_call(LEPUSContext *ctx, LEPUSValue *sp,
                                   int flags);

QJS_HIDE LEPUSValue JS_ToPrimitiveFree(LEPUSContext *ctx, LEPUSValue val,
                                       int hint);
QJS_HIDE LEPUSValue JS_ToPrimitiveFree_GC(LEPUSContext *ctx, LEPUSValue val,
                                          int hint);
QJS_HIDE LEPUSValue JS_ConcatString(LEPUSContext *ctx, LEPUSValue op1,
                                    LEPUSValue op2);
QJS_HIDE LEPUSValue JS_ConcatString_GC(LEPUSContext *ctx, LEPUSValue op1,
                                       LEPUSValue op2);
QJS_HIDE LEPUSValue prim_js_unary_arith_slow(LEPUSContext *ctx, LEPUSValue op1,
                                             OPCodeEnum op);
QJS_HIDE LEPUSValue prim_js_unary_arith_slow_gc(LEPUSContext *ctx,
                                                LEPUSValue op1, OPCodeEnum op);
QJS_HIDE LEPUSValue prim_js_add_slow(LEPUSContext *ctx, LEPUSValue op1,
                                     LEPUSValue op2);
QJS_HIDE LEPUSValue prim_js_add_slow_gc(LEPUSContext *ctx, LEPUSValue op1,
                                        LEPUSValue op2);
QJS_HIDE no_inline LEPUSValue prim_js_not_slow(LEPUSContext *ctx,
                                               LEPUSValue op);
QJS_HIDE no_inline LEPUSValue prim_js_not_slow_gc(LEPUSContext *ctx,
                                                  LEPUSValue op);
QJS_HIDE LEPUSValue prim_js_binary_arith_slow(LEPUSContext *ctx, LEPUSValue op1,
                                              LEPUSValue op2, OPCodeEnum op);
QJS_HIDE LEPUSValue prim_js_binary_arith_slow_gc(LEPUSContext *ctx,
                                                 LEPUSValue op1, LEPUSValue op2,
                                                 OPCodeEnum op);
QJS_HIDE double prim_js_fmod_double(double a, double b);
QJS_HIDE double prim_js_fmod_double_gc(double a, double b);
QJS_HIDE int js_post_inc_slow(LEPUSContext *ctx, LEPUSValue *sp, OPCodeEnum op);
QJS_HIDE int js_post_inc_slow_gc(LEPUSContext *ctx, LEPUSValue *sp,
                                 OPCodeEnum op);
QJS_HIDE LEPUSValue prim_js_binary_logic_slow(LEPUSContext *ctx, LEPUSValue op1,
                                              LEPUSValue op2, OPCodeEnum op);
QJS_HIDE LEPUSValue prim_js_binary_logic_slow_gc(LEPUSContext *ctx,
                                                 LEPUSValue op1, LEPUSValue op2,
                                                 OPCodeEnum op);
QJS_HIDE LEPUSValue prim_js_shr_slow(LEPUSContext *ctx, LEPUSValue op1,
                                     LEPUSValue op2);
QJS_HIDE LEPUSValue prim_js_shr_slow_gc(LEPUSContext *ctx, LEPUSValue op1,
                                        LEPUSValue op2);
QJS_HIDE LEPUSValue prim_js_relation_slow(LEPUSContext *ctx, LEPUSValue op1,
                                          LEPUSValue op2, OPCodeEnum op);
QJS_HIDE LEPUSValue prim_js_relation_slow_gc(LEPUSContext *ctx, LEPUSValue op1,
                                             LEPUSValue op2, OPCodeEnum op);
QJS_HIDE LEPUSValue prim_js_eq_slow(LEPUSContext *ctx, LEPUSValue op1,
                                    LEPUSValue op2, int is_neq);
QJS_HIDE LEPUSValue prim_js_eq_slow_gc(LEPUSContext *ctx, LEPUSValue op1,
                                       LEPUSValue op2, int is_neq);
QJS_HIDE LEPUSValue prim_js_strict_eq_slow(LEPUSContext *ctx, LEPUSValue op1,
                                           LEPUSValue op2, BOOL is_neq);
QJS_HIDE LEPUSValue prim_js_strict_eq_slow_gc(LEPUSContext *ctx, LEPUSValue op1,
                                              LEPUSValue op2, BOOL is_neq);
QJS_HIDE LEPUSValue prim_js_operator_instanceof(LEPUSContext *ctx,
                                                LEPUSValue op1, LEPUSValue op2);
QJS_HIDE LEPUSValue prim_js_operator_instanceof_gc(LEPUSContext *ctx,
                                                   LEPUSValue op1,
                                                   LEPUSValue op2);
QJS_HIDE LEPUSValue prim_js_operator_in(LEPUSContext *ctx, LEPUSValue op1,
                                        LEPUSValue op2);
QJS_HIDE LEPUSValue prim_js_operator_in_gc(LEPUSContext *ctx, LEPUSValue op1,
                                           LEPUSValue op2);
QJS_HIDE __exception int js_operator_typeof(LEPUSContext *ctx, LEPUSValue op1);
QJS_HIDE __exception int js_operator_typeof_gc(LEPUSContext *ctx,
                                               LEPUSValue op1);
QJS_HIDE LEPUSValue prim_js_operator_delete(LEPUSContext *ctx, LEPUSValue op1,
                                            LEPUSValue op2);
QJS_HIDE LEPUSValue prim_js_operator_delete_gc(LEPUSContext *ctx,
                                               LEPUSValue op1, LEPUSValue op2);
QJS_HIDE int JS_SetPropertyInternalImpl(LEPUSContext *ctx,
                                        LEPUSValueConst this_obj, JSAtom prop,
                                        LEPUSValue val, int flags);
QJS_HIDE int JS_SetPropertyInternalImpl_GC(LEPUSContext *ctx,
                                           LEPUSValueConst this_obj,
                                           JSAtom prop, LEPUSValue val,
                                           int flags);

QJS_HIDE int set_array_length(LEPUSContext *ctx, LEPUSObject *p,
                              JSProperty *prop, LEPUSValue val, int flags);

QJS_HIDE BOOL JS_IsUncatchableError(LEPUSContext *ctx, LEPUSValueConst val);
QJS_HIDE BOOL JS_IsUncatchableError_GC(LEPUSContext *ctx, LEPUSValueConst val);
QJS_HIDE JSAtom js_value_to_atom(LEPUSContext *ctx, LEPUSValueConst val);
QJS_HIDE JSAtom js_value_to_atom_gc(LEPUSContext *ctx, LEPUSValueConst val);
QJS_HIDE LEPUSValue JS_ThrowReferenceErrorNotDefined(LEPUSContext *ctx,
                                                     JSAtom name);
QJS_HIDE LEPUSValue JS_ThrowReferenceErrorNotDefined_GC(LEPUSContext *ctx,
                                                        JSAtom name);
LEPUSValue JS_ThrowTypeErrorNotFunction(LEPUSContext *ctx);

#ifdef ENABLE_PRIMJS_SNAPSHOT
typedef LEPUSValue (*QuickJsCallStub)(LEPUSValue this_arg,
                                      LEPUSValue new_target,
                                      LEPUSValue func_obj, address entry_point,
                                      int argc, LEPUSValue *argv, int flags);

extern QuickJsCallStub entry;
QJS_HIDE void compile_function(LEPUSContext *, LEPUSFunctionBytecode *bytecode);
#endif

// <primjs end>

typedef struct JSToken {
  int val;
  int line_num; /* line number of token start */
  const uint8_t *ptr;
  union {
    struct {
      LEPUSValue str;
      int sep;
    } str;
    struct {
      LEPUSValue val;
#ifdef CONFIG_BIGNUM
      slimb_t exponent; /* may be != 0 only if val is a float */
#endif
    } num;
    struct {
      JSAtom atom;
      BOOL has_escape;
      BOOL is_reserved;
    } ident;
    struct {
      LEPUSValue body;
      LEPUSValue flags;
    } regexp;
  } u;
} JSToken;

#ifndef NO_QUICKJS_COMPILER
LEPUSValue js_dynamic_import(LEPUSContext *ctx, LEPUSValueConst specifier);
#endif

#ifdef __cplusplus
}
#endif

/* <rc begin> */
static __attribute__((unused)) int JS_DefineProperty_RC(
    LEPUSContext *ctx, LEPUSValueConst this_obj, JSAtom prop,
    LEPUSValueConst val, LEPUSValueConst getter, LEPUSValueConst setter,
    int flags);
static __attribute__((unused)) int JS_DefinePropertyValue_RC(
    LEPUSContext *ctx, LEPUSValueConst this_obj, JSAtom prop, LEPUSValue val,
    int flags);
static __attribute__((unused)) void JS_MarkValue_RC(LEPUSRuntime *rt,
                                                    LEPUSValueConst val,
                                                    LEPUS_MarkFunc *mark_func,
                                                    int local_idx = -1);
static __attribute__((unused)) int JS_ToBoolFree_RC(LEPUSContext *ctx,
                                                    LEPUSValue val);
static __attribute__((unused)) int JS_IsInstanceOf_RC(LEPUSContext *ctx,
                                                      LEPUSValueConst val,
                                                      LEPUSValueConst obj);
static __attribute__((unused)) LEPUSValue JS_ToString_RC(LEPUSContext *ctx,
                                                         LEPUSValueConst val);
/* <rc end> */

/* <gc begin> */
LEPUSValue JS_GetSeparableStringContent_GC(LEPUSContext *ctx, LEPUSValue val);
LEPUSValue JS_GetSeparableStringContentNotDup_GC(LEPUSContext *ctx,
                                                 LEPUSValue val);
QJS_HIDE int set_array_length_gc(LEPUSContext *ctx, LEPUSObject *p,
                                 JSProperty *prop, LEPUSValue val, int flags);
bool gc_enabled();
LEPUSRuntime *JS_NewRuntime_GC();
LEPUSRuntime *JS_NewRuntime2_GC(const LEPUSMallocFunctions *mf, void *opaque);
void JS_FreeRuntime_GC(LEPUSRuntime *rt);
void JS_FreeRuntimeForEffect(LEPUSRuntime *rt);
LEPUSContext *JS_NewContext_GC(LEPUSRuntime *rt);
void JS_FreeContext_GC(LEPUSContext *ctx);
LEPUSContext *JS_NewContextRaw_GC(LEPUSRuntime *rt);

void JS_SetMemoryLimit_GC(LEPUSRuntime *rt, size_t limit);
void JS_RunGC_GC(LEPUSRuntime *rt);

void JS_AddIntrinsicBaseObjects_GC(LEPUSContext *ctx);
void JS_AddIntrinsicDate_GC(LEPUSContext *ctx);
void JS_AddIntrinsicEval_GC(LEPUSContext *ctx);
void JS_AddIntrinsicStringNormalize_GC(LEPUSContext *ctx);
void JS_AddIntrinsicRegExp_GC(LEPUSContext *ctx);
void JS_AddIntrinsicJSON_GC(LEPUSContext *ctx);
void JS_AddIntrinsicProxy_GC(LEPUSContext *ctx);
void JS_AddIntrinsicMapSet_GC(LEPUSContext *ctx);
void JS_AddIntrinsicTypedArrays_GC(LEPUSContext *ctx);
void JS_AddIntrinsicPromise_GC(LEPUSContext *ctx);

void JS_SetClassProto_GC(LEPUSContext *ctx, LEPUSClassID class_id,
                         LEPUSValue obj);
LEPUSValue JS_GetClassProto_GC(LEPUSContext *ctx, LEPUSClassID class_id);
int JS_MoveUnhandledRejectionToException_GC(LEPUSContext *ctx);
void JS_AddIntrinsicRegExpCompiler_GC(LEPUSContext *ctx);
#ifdef QJS_UNITTEST
LEPUSValue js_string_codePointRange_GC(LEPUSContext *ctx,
                                       LEPUSValueConst this_val, int argc,
                                       LEPUSValueConst *argv);
#endif

JSAtom LEPUS_NewAtom(LEPUSContext *ctx, const char *str);
JSAtom JS_NewAtomUInt32_GC(LEPUSContext *ctx, uint32_t n);
LEPUSValue JS_AtomToValue_GC(LEPUSContext *ctx, JSAtom atom);
LEPUSValue JS_AtomToString_GC(LEPUSContext *ctx, JSAtom atom);
typedef struct JSClassShortDef {
  JSAtom class_name;
  LEPUSClassFinalizer *finalizer;
  LEPUSClassGCMark *gc_mark;
} JSClassShortDef;
QJS_HIDE int init_class_range(LEPUSRuntime *rt, JSClassShortDef const *tab,
                              int start, int count);
const char *JS_AtomToCString_GC(LEPUSContext *ctx, JSAtom atom);

void JS_MarkValue_GC(LEPUSRuntime *rt, LEPUSValueConst val,
                     LEPUS_MarkFunc *mark_func, int local_idx = -1);

LEPUSValue JS_NewInt64_GC(LEPUSContext *ctx, int64_t v);
LEPUSValue JS_NewError_GC(LEPUSContext *ctx);

void JS_SetVirtualStackSize_GC(LEPUSContext *ctx, uint32_t stack_size);
int JS_ToBool_GC(LEPUSContext *ctx, LEPUSValueConst val);
int JS_ToInt32_GC(LEPUSContext *ctx, int32_t *pres, LEPUSValueConst val);
int JS_ToInt64_GC(LEPUSContext *ctx, int64_t *pres, LEPUSValueConst val);
int JS_ToIndex_GC(LEPUSContext *ctx, uint64_t *plen, LEPUSValueConst val);
int JS_ToFloat64_GC(LEPUSContext *ctx, double *pres, LEPUSValueConst val);
int JS_ToBigInt64_GC(LEPUSContext *ctx, int64_t *pres, LEPUSValueConst val);
LEPUSValue JS_NewStringLen_GC(LEPUSContext *ctx, const char *buf,
                              size_t buf_len);
LEPUSValue JS_NewString_GC(LEPUSContext *ctx, const char *str);
LEPUSValue JS_NewAtomString_GC(LEPUSContext *ctx, const char *str);
LEPUSValue JS_ToString_GC(LEPUSContext *ctx, LEPUSValueConst val);
LEPUSValue JS_ToPropertyKey_GC(LEPUSContext *ctx, LEPUSValueConst val);
const char *JS_ToCStringLen2_GC(LEPUSContext *ctx, size_t *plen,
                                LEPUSValueConst val1, BOOL cesu8);

LEPUSValue __attribute__((always_inline))
JS_NewObjectProtoClass_GC(LEPUSContext *ctx, LEPUSValueConst proto_val,
                          LEPUSClassID class_id);
LEPUSValue JS_NewObjectClass_GC(LEPUSContext *ctx, int class_id);
LEPUSValue JS_NewObjectProto_GC(LEPUSContext *ctx, LEPUSValueConst proto);
LEPUSValue JS_NewObject_GC(LEPUSContext *ctx);
LEPUSValue JS_NewArray_GC(LEPUSContext *ctx);
int JS_IsArray_GC(LEPUSContext *ctx, LEPUSValueConst val);

LEPUSValue JS_GetPropertyInternal_GC(LEPUSContext *ctx, LEPUSValueConst obj,
                                     JSAtom prop, LEPUSValueConst this_obj,
                                     BOOL throw_ref_error);
LEPUSValue JS_GetPropertyStr_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                                const char *prop);
LEPUSValue JS_GetPropertyUint32_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                                   uint32_t idx);
int JS_SetPropertyInternal_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                              JSAtom prop, LEPUSValue val, int flags);

int JS_SetPropertyUint32_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                            uint32_t idx, LEPUSValue val);
int JS_SetPropertyInt64_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                           int64_t idx, LEPUSValue val);

int JS_SetPropertyStr_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                         const char *prop, LEPUSValue val);
int JS_HasProperty_GC(LEPUSContext *ctx, LEPUSValueConst obj, JSAtom prop);
int JS_IsExtensible_GC(LEPUSContext *ctx, LEPUSValueConst obj);
int JS_PreventExtensions_GC(LEPUSContext *ctx, LEPUSValueConst obj);
int JS_DeleteProperty_GC(LEPUSContext *ctx, LEPUSValueConst obj, JSAtom prop,
                         int flags);
int JS_SetPrototype_GC(LEPUSContext *ctx, LEPUSValueConst obj,
                       LEPUSValueConst proto_val);
LEPUSValueConst JS_GetPrototype_GC(LEPUSContext *ctx, LEPUSValueConst val);
int JS_GetOwnPropertyNames_GC(LEPUSContext *ctx, LEPUSPropertyEnum **ptab,
                              uint32_t *plen, LEPUSValueConst obj, int flags);
int JS_GetOwnProperty_GC(LEPUSContext *ctx, LEPUSPropertyDescriptor *desc,
                         LEPUSValueConst obj, JSAtom prop);
LEPUSValue JS_Call_GC(LEPUSContext *ctx, LEPUSValueConst func_obj,
                      LEPUSValueConst this_obj, int argc,
                      LEPUSValueConst *argv);
LEPUSValue JS_CallInternalTI_GC(LEPUSContext *caller_ctx, LEPUSValue func_obj,
                                LEPUSValue this_obj, LEPUSValue new_target,
                                int argc, LEPUSValue *argv, int flags);

LEPUSValue JS_Invoke_GC(LEPUSContext *ctx, LEPUSValueConst this_val,
                        JSAtom atom, int argc, LEPUSValueConst *argv);
LEPUSValue JS_CallConstructor_GC(LEPUSContext *ctx, LEPUSValueConst func_obj,
                                 int argc, LEPUSValueConst *argv);
LEPUSValue JS_CallConstructor2_GC(LEPUSContext *ctx, LEPUSValueConst func_obj,
                                  LEPUSValueConst new_target, int argc,
                                  LEPUSValueConst *argv);
LEPUSValue JS_Eval_GC(LEPUSContext *ctx, const char *input, size_t input_len,
                      const char *filename, int eval_flags);
LEPUSValue JS_EvalBinary_GC(LEPUSContext *ctx, const uint8_t *buf,
                            size_t buf_len, int flags);
LEPUSValue JS_GetGlobalObject_GC(LEPUSContext *ctx);
LEPUSValue JS_GetGlobalVar_GC(LEPUSContext *ctx, JSAtom prop,
                              BOOL throw_ref_error);
void JS_SetStringCache_GC(LEPUSContext *ctx, LEPUSValue val, void *p);
int JS_SetGlobalVar_GC(LEPUSContext *ctx, JSAtom prop, LEPUSValue val,
                       int flag);
LEPUSValue JS_DeepEqual_GC(LEPUSContext *ctx, LEPUSValueConst obj1,
                           LEPUSValueConst obj2);
LEPUSValue JS_DeepCopy_GC(LEPUSContext *ctx, LEPUSValueConst obj);
void JS_IterateObject_GC(LEPUSContext *ctx, LEPUSValue obj,
                         IterateObject callback, void *pfunc, void *raw_data);
int JS_GetLength_GC(LEPUSContext *ctx, LEPUSValue val);

int JS_IsInstanceOf_GC(LEPUSContext *ctx, LEPUSValueConst val,
                       LEPUSValueConst obj);

int JS_DefineProperty_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                         JSAtom prop, LEPUSValueConst val,
                         LEPUSValueConst getter, LEPUSValueConst setter,
                         int flags);
int JS_DefinePropertyValue_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                              JSAtom prop, LEPUSValue val, int flags);
int JS_DefinePropertyValueUint32_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                                    uint32_t idx, LEPUSValue val, int flags);
int JS_DefinePropertyValueStr_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                                 const char *prop, LEPUSValue val, int flags);
int JS_DefinePropertyGetSet_GC(LEPUSContext *ctx, LEPUSValueConst this_obj,
                               JSAtom prop, LEPUSValue getter,
                               LEPUSValue setter, int flags);
void *JS_GetOpaque2_GC(LEPUSContext *ctx, LEPUSValueConst obj,
                       LEPUSClassID class_id);
LEPUSValue JS_NewArrayBuffer_GC(LEPUSContext *ctx, uint8_t *buf, size_t len,
                                LEPUSFreeArrayBufferDataFunc *free_func,
                                void *opaque, BOOL is_shared);
LEPUSValue JS_NewArrayBufferCopy_GC(LEPUSContext *ctx, const uint8_t *buf,
                                    size_t len);
void JS_DetachArrayBuffer_GC(LEPUSContext *ctx, LEPUSValueConst obj);
uint8_t *JS_GetArrayBuffer_GC(LEPUSContext *ctx, size_t *psize,
                              LEPUSValueConst obj);
uint8_t *JS_MoveArrayBuffer_GC(LEPUSContext *ctx, size_t *psize,
                               LEPUSValueConst obj);
LEPUS_BOOL JS_StrictEq_GC(LEPUSContext *ctx, LEPUSValueConst op1,
                          LEPUSValueConst op2);
LEPUS_BOOL JS_SameValue_GC(LEPUSContext *ctx, LEPUSValueConst op1,
                           LEPUSValueConst op2);
LEPUSValue JS_NewPromiseCapability_GC(LEPUSContext *ctx,
                                      LEPUSValue *resolving_funcs);
int JS_EnqueueJob_GC(LEPUSContext *ctx, LEPUSJobFunc *job_func, int argc,
                     LEPUSValueConst *argv);
int JS_ExecutePendingJob_GC(LEPUSRuntime *rt, LEPUSContext **pctx);

uint8_t *JS_WriteObject_GC(LEPUSContext *ctx, size_t *psize,
                           LEPUSValueConst obj, int flags);
LEPUSValue JS_EvalFunction_GC(LEPUSContext *ctx, LEPUSValue fun_obj,
                              LEPUSValueConst this_obj);
LEPUSValue JS_NewWString_GC(LEPUSContext *ctx, const uint16_t *buf,
                            size_t length);
QJS_HIDE LEPUSValue js_json_stringify_opt_GC(LEPUSContext *, LEPUSValue,
                                             int32_t, LEPUSValue *);
JSAtom JS_ValueToAtom_GC(LEPUSContext *ctx, LEPUSValueConst val);
const uint16_t *JS_GetStringChars_GC(LEPUSContext *ctx, LEPUSValueConst str);
QJS_HIDE LEPUSValue JS_NewArrayWithValue_GC(LEPUSContext *ctx, uint32_t length,
                                            LEPUSValueConst *values);
QJS_HIDE LEPUSValue JS_NewTypedArray_GC(LEPUSContext *ctx, uint32_t length,
                                        LEPUSClassID class_id);
QJS_HIDE LEPUSValue JS_NewTypedArrayWithBuffer_GC(LEPUSContext *ctx,
                                                  LEPUSValueConst buffer,
                                                  uint32_t byteOffset,
                                                  uint32_t length,
                                                  LEPUSClassID class_id);

QJS_HIDE LEPUSValue JS_CallConstructorV_GC(LEPUSContext *ctx,
                                           LEPUSValueConst func_obj, int argc,
                                           LEPUSValue *argv);
QJS_HIDE LEPUSValue JS_NewCFunction2_GC(LEPUSContext *ctx, LEPUSCFunction *func,
                                        const char *name, int length,
                                        LEPUSCFunctionEnum cproto, int magic);
QJS_HIDE LEPUSValue JS_NewCFunctionData_GC(LEPUSContext *ctx,
                                           LEPUSCFunctionData *func, int length,
                                           int magic, int data_len,
                                           LEPUSValueConst *data);
QJS_HIDE void JS_SetPropertyFunctionList_GC(LEPUSContext *ctx,
                                            LEPUSValueConst obj,
                                            const LEPUSCFunctionListEntry *tab,
                                            int len);
QJS_HIDE LEPUSValue js_object_getOwnPropertyDescriptor_GC(
    LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
    LEPUSValueConst *argv, int magic);
QJS_HIDE int js_get_length32_gc(LEPUSContext *ctx, uint32_t *pres,
                                LEPUSValueConst obj);

QJS_HIDE LEPUSValue JS_NewObjectWithArgs_GC(LEPUSContext *ctx, int32_t size,
                                            const char **keys,
                                            LEPUSValue *values);
QJS_HIDE LEPUSValue JS_NewArrayWithArgs_GC(LEPUSContext *ctx, int32_t size,
                                           LEPUSValue *values);

QJS_HIDE __exception int js_append_enumerate_gc(LEPUSContext *ctx,
                                                LEPUSValue *sp);
QJS_HIDE __exception int js_iterator_get_value_done_gc(LEPUSContext *ctx,
                                                       LEPUSValue *sp);

QJS_HIDE int JS_ToBoolFree_GC(LEPUSContext *ctx, LEPUSValue val);
QJS_HIDE LEPUSValue JS_ToPrimitiveFree_GC(LEPUSContext *ctx, LEPUSValue val,
                                          int hint);
QJS_HIDE LEPUSValue JS_NewBigUint64_GC(LEPUSContext *ctx, uint64_t v);

QJS_HIDE void JS_VisitLEPUSValue_GC(LEPUSRuntime *rt, LEPUSValue *val,
                                    int local_idx);
QJS_HIDE void DisposeGlobal_GC(LEPUSRuntime *runtime,
                               LEPUSValue *global_handle);
QJS_HIDE LEPUSValue *GlobalizeReference_GC(LEPUSRuntime *runtime,
                                           LEPUSValue val, bool is_weak);
QJS_HIDE void FreeNapiScope_GC(LEPUSContext *ctx);
QJS_HIDE void ClearGlobalWeak_GC(LEPUSRuntime *runtime,
                                 LEPUSValue *global_handle);
QJS_HIDE void SetGlobalWeak_GC(LEPUSRuntime *runtime, LEPUSValue *global_handle,
                               void *data, void (*cb)(void *));
QJS_HIDE void *GetNapiScope_GC(LEPUSContext *ctx);
QJS_HIDE void InitNapiScope_GC(LEPUSContext *ctx);
QJS_HIDE void SetNapiScope_GC(LEPUSContext *ctx, void *scope);
QJS_HIDE void SetWeakState_GC(LEPUSRuntime *runtime, LEPUSValue *global_handle);

QJS_HIDE void JS_SetGCPauseSuppressionMode_GC(LEPUSRuntime *rt, bool mode);
QJS_HIDE bool JS_GetGCPauseSuppressionMode_GC(LEPUSRuntime *rt);
QJS_HIDE __attribute__((unused)) bool CheckValidPtr_GC(void *runtime,
                                                       void *ptr);
QJS_HIDE JSString *js_alloc_string(LEPUSContext *ctx, int max_len,
                                   int is_wide_char);
QJS_HIDE int JS_InitAtoms(LEPUSRuntime *rt);
QJS_HIDE int JS_isConcatSpreadable(LEPUSContext *ctx, LEPUSValueConst obj);
typedef struct StringBuffer {
  LEPUSContext *ctx;
  JSString *str;
  int len;
  int size;
  int is_wide_char;
  int error_status;
} StringBuffer;
QJS_HIDE int string_buffer_write8(StringBuffer *s, const uint8_t *p, int len);
QJS_HIDE int string_buffer_concat(StringBuffer *s, const JSString *p,
                                  uint32_t from, uint32_t to);
QJS_HIDE int string_buffer_putc8(StringBuffer *s, uint32_t c);
QJS_HIDE int string_buffer_putc16(StringBuffer *s, uint32_t c);
QJS_HIDE int string_getc(const JSString *p, int *pidx);
QJS_HIDE BOOL test_final_sigma(JSString *p, int sigma_pos);
QJS_HIDE int string_buffer_putc(StringBuffer *s, uint32_t c);
QJS_HIDE int string_buffer_fill(StringBuffer *s, int c, int count);
QJS_HIDE int seal_template_obj_GC(LEPUSContext *ctx, LEPUSValueConst obj);
struct BCReaderState;
QJS_HIDE LEPUSValue JS_ReadError_GC(BCReaderState *s);
QJS_HIDE LEPUSValue JS_ReadRegExp(BCReaderState *s);
QJS_HIDE LEPUSValue JS_ReadMap_GC(BCReaderState *s);
QJS_HIDE LEPUSValue js_typed_array_constructor_GC(LEPUSContext *ctx,
                                                  LEPUSValueConst new_target,
                                                  int argc,
                                                  LEPUSValueConst *argv,
                                                  int classid);
QJS_HIDE LEPUSValue JS_ReadObjectRec(BCReaderState *s);
QJS_HIDE LEPUSValue JS_ReadRegExp_GC(BCReaderState *s);
QJS_HIDE JSAtom __JS_NewAtom(LEPUSRuntime *rt, JSString *str, int atom_type);
QJS_HIDE int js_string_compare(LEPUSContext *ctx, const JSString *p1,
                               const JSString *p2);

QJS_HIDE JSAtom JS_NewAtomStr(LEPUSContext *ctx, JSString *p);
QJS_HIDE BOOL JS_AtomIsArrayIndex(LEPUSContext *ctx, uint32_t *pval,
                                  JSAtom atom);

QJS_HIDE JSAtom js_get_atom_index(LEPUSRuntime *rt, JSAtomStruct *p);
QJS_HIDE LEPUSModuleDef *js_new_module_def(LEPUSContext *ctx, JSAtom name);
struct JSFunctionDef;
QJS_HIDE int resolve_labels(LEPUSContext *ctx, JSFunctionDef *s);
QJS_HIDE int resolve_variables(LEPUSContext *ctx, JSFunctionDef *s);
QJS_HIDE int new_label_fd(JSFunctionDef *fd, int label);
struct JSParseState;
QJS_HIDE int js_parse_unary_GC(JSParseState *s, int parse_flags);
QJS_HIDE int js_parse_array_literal(JSParseState *s);
QJS_HIDE int js_parse_cond_expr(JSParseState *s, int parse_flags);
QJS_HIDE int js_parse_assign_expr(JSParseState *s, int parse_flags);
QJS_HIDE int js_parse_expr(JSParseState *s);
QJS_HIDE int js_parse_expr2(JSParseState *s, int parse_flags);
QJS_HIDE __exception int next_token(JSParseState *s);
struct JSToken;
QJS_HIDE int js_parse_string(JSParseState *s, int sep, BOOL do_throw,
                             const uint8_t *p, JSToken *token,
                             const uint8_t **pp);

QJS_HIDE int cpool_add(JSParseState *s, LEPUSValue val);
QJS_HIDE int emit_push_const(JSParseState *s, LEPUSValueConst val,
                             BOOL as_atom);
QJS_HIDE void emit_op(JSParseState *s, uint8_t val);
QJS_HIDE int emit_label(JSParseState *s, int label);
QJS_HIDE void emit_return(JSParseState *s, BOOL hasval);
QJS_HIDE int emit_goto(JSParseState *s, int opcode, int label);
QJS_HIDE int emit_break(JSParseState *s, JSAtom name, int is_cont);
QJS_HIDE void optional_chain_test(JSParseState *s,
                                  int *poptional_chaining_label,
                                  int drop_count);
QJS_HIDE int js_parse_template_part(JSParseState *s, const uint8_t *p);
QJS_HIDE int js_parse_template(JSParseState *s, int call, int *argc);
struct JSParsePos;
QJS_HIDE int js_parse_get_pos(JSParseState *s, JSParsePos *sp);
QJS_HIDE int js_parse_seek_token(JSParseState *s, const JSParsePos *sp);
QJS_HIDE int js_parse_regexp(JSParseState *s);
QJS_HIDE int js_parse_skip_parens_token(JSParseState *s, int *pbits,
                                        BOOL no_line_terminator,
                                        BOOL *has_ellipsis = nullptr);
QJS_HIDE int js_resize_array(LEPUSContext *ctx, void **parray, int elem_size,
                             int *psize, int *pcount, int new_count);
QJS_HIDE JSExportEntry *find_export_entry(LEPUSContext *ctx, LEPUSModuleDef *m,
                                          JSAtom export_name);

QJS_HIDE JSExportEntry *add_export_entry(JSParseState *s, LEPUSModuleDef *m,
                                         JSAtom local_name, JSAtom export_name,
                                         JSExportTypeEnum export_type);
QJS_HIDE void set_object_name_computed(JSParseState *s);
QJS_HIDE BOOL set_object_name(JSParseState *s, JSAtom name);
QJS_HIDE int add_scope_var(LEPUSContext *ctx, JSFunctionDef *fd, JSAtom name,
                           JSVarKindEnum var_kind);
QJS_HIDE int add_var(LEPUSContext *ctx, JSFunctionDef *fd, JSAtom name);
typedef struct JSHoistedDef {  // called JSGlobalVar in latest version
  int cpool_idx;               /* -1 means variable global definition */
  uint8_t force_init : 1;      /* initialize to undefined */
  uint8_t is_lexical : 1;      /* global let/const definition */
  uint8_t is_const : 1;        /* const definition */
  int var_idx;                 /* function object index if cpool_idx >= 0 */
  int scope_level;             /* scope of definition */
  JSAtom var_name;             /* variable name if cpool_idx < 0 */
} JSHoistedDef;
QJS_HIDE JSHoistedDef *add_hoisted_def(LEPUSContext *ctx, JSFunctionDef *s,
                                       int cpool_idx, JSAtom name, int var_idx,
                                       BOOL is_lexical);
QJS_HIDE int peek_token(JSParseState *s, BOOL no_line_terminator);
QJS_HIDE int push_scope(JSParseState *s);
QJS_HIDE int find_private_class_field(LEPUSContext *ctx, JSFunctionDef *fd,
                                      JSAtom name, int scope_level);
typedef enum JSParseFunctionEnum {
  JS_PARSE_FUNC_STATEMENT,
  JS_PARSE_FUNC_VAR,
  JS_PARSE_FUNC_EXPR,
  JS_PARSE_FUNC_ARROW,
  JS_PARSE_FUNC_GETTER,
  JS_PARSE_FUNC_SETTER,
  JS_PARSE_FUNC_METHOD,
  JS_PARSE_FUNC_CLASS_CONSTRUCTOR,
  JS_PARSE_FUNC_DERIVED_CLASS_CONSTRUCTOR,
} JSParseFunctionEnum;
typedef enum JSParseExportEnum {
  JS_PARSE_EXPORT_NONE,
  JS_PARSE_EXPORT_NAMED,
  JS_PARSE_EXPORT_DEFAULT,
} JSParseExportEnum;
typedef enum {
  JS_VAR_DEF_WITH,
  JS_VAR_DEF_LET,
  JS_VAR_DEF_CONST,
  JS_VAR_DEF_FUNCTION_DECL,     /* function declaration */
  JS_VAR_DEF_NEW_FUNCTION_DECL, /* async/generator function declaration */
  JS_VAR_DEF_CATCH,
  JS_VAR_DEF_VAR,
} JSVarDefEnum;
QJS_HIDE int js_parse_function_decl2_GC(
    JSParseState *s, JSParseFunctionEnum func_type,
    JSFunctionKindEnum func_kind, JSAtom func_name, const uint8_t *ptr,
    int function_line_num, JSParseExportEnum export_flag, JSFunctionDef **pfd);
QJS_HIDE int js_parse_class_default_ctor(JSParseState *s, BOOL has_super,
                                         JSFunctionDef **pfd);

QJS_HIDE int define_var_GC(JSParseState *s, JSFunctionDef *fd, JSAtom name,
                           JSVarDefEnum var_def_type);

QJS_HIDE uint64_t compute_column(JSParseState *s, BOOL is_get_var);
QJS_HIDE BOOL js_is_live_code(JSParseState *s);
QJS_HIDE int js_parse_directives(JSParseState *s);
QJS_HIDE int add_closure_var(LEPUSContext *ctx, JSFunctionDef *s, BOOL is_local,
                             BOOL is_arg, int var_idx, JSAtom var_name,
                             BOOL is_const, BOOL is_lexical,
                             JSVarKindEnum var_kind);
QJS_HIDE BOOL is_var_in_arg_scope(LEPUSContext *ctx, const JSVarDef *vd);
QJS_HIDE LEPUSValue js_create_function(LEPUSContext *ctx, JSFunctionDef *fd);
QJS_HIDE void skip_shebang(JSParseState *s);
QJS_HIDE const char *JS_AtomGetStrRT(LEPUSRuntime *rt, char *buf, int buf_size,
                                     JSAtom atom);
QJS_HIDE const char *JS_AtomGetStr(LEPUSContext *ctx, char *buf, int buf_size,
                                   JSAtom atom);
QJS_HIDE int js_parse_error_reserved_identifier(JSParseState *s);
QJS_HIDE BOOL token_is_pseudo_keyword(JSParseState *s, JSAtom atom);
QJS_HIDE BOOL token_is_ident(int tok);
QJS_HIDE int js_parse_expect(JSParseState *s, int tok);
QJS_HIDE int js_parse_object_literal_GC(JSParseState *s);
QJS_HIDE int js_parse_expr_paren(JSParseState *s);
QJS_HIDE __exception JSAtom js_parse_from_clause(JSParseState *s);
QJS_HIDE int add_req_module_entry(LEPUSContext *ctx, LEPUSModuleDef *m,
                                  JSAtom module_name);
QJS_HIDE int js_parse_expect_semi(JSParseState *s);
QJS_HIDE __exception int js_parse_export(JSParseState *s);
QJS_HIDE __exception int js_parse_import(JSParseState *s);
QJS_HIDE LEPUSValue JS_CallFree_GC(LEPUSContext *ctx, LEPUSValue func_obj,
                                   LEPUSValueConst this_obj, int argc,
                                   LEPUSValueConst *argv);
QJS_HIDE int add_star_export_entry(LEPUSContext *ctx, LEPUSModuleDef *m,
                                   int req_module_idx);
QJS_HIDE int js_define_var(JSParseState *s, JSAtom name, int tok);
QJS_HIDE int get_prev_opcode(JSFunctionDef *fd);
QJS_HIDE int update_label(JSFunctionDef *s, int label, int delta);
QJS_HIDE int get_lvalue(JSParseState *s, int *popcode, int *pscope,
                        JSAtom *pname, int *plabel, int *pdepth, BOOL keep,
                        int tok);
typedef enum {
  PUT_LVALUE_NOKEEP,        /* [depth] v -> */
  PUT_LVALUE_NOKEEP_DEPTH,  /* [depth] v -> , keep depth (currently
                               just disable optimizations) */
  PUT_LVALUE_KEEP_TOP,      /* [depth] v -> v */
  PUT_LVALUE_KEEP_SECOND,   /* [depth] v0 v -> v0 */
  PUT_LVALUE_NOKEEP_BOTTOM, /* v [depth] -> */
} PutLValueEnum;
QJS_HIDE void put_lvalue(JSParseState *s, int opcode, int scope, JSAtom name,
                         int label, PutLValueEnum special, BOOL is_let);
QJS_HIDE JSAtom js_parse_destructing_var(JSParseState *s, int tok, int is_arg);
QJS_HIDE int js_parse_check_duplicate_parameter(JSParseState *s, JSAtom name);
QJS_HIDE int js_parse_destructing_element_GC(JSParseState *s, int tok,
                                             int is_arg, int hasval,
                                             int has_ellipsis,
                                             BOOL allow_initializer);
QJS_HIDE int js_parse_var(JSParseState *s, int parse_flags, int tok,
                          BOOL export_flag);
QJS_HIDE LEPUSValue js_evaluate_module(LEPUSContext *ctx, LEPUSModuleDef *m);
QJS_HIDE JSVarRef *js_create_module_var(LEPUSContext *ctx, BOOL is_lexical);
QJS_HIDE int js_create_module_function(LEPUSContext *ctx, LEPUSModuleDef *m);
QJS_HIDE void set_value_gc(LEPUSContext *ctx, LEPUSValue *pval,
                           LEPUSValue new_val);
QJS_HIDE int JS_DefineAutoInitProperty_GC(
    LEPUSContext *ctx, LEPUSValueConst this_obj, JSAtom prop,
    LEPUSValue (*init_func)(LEPUSContext *ctx, LEPUSObject *obj, JSAtom prop,
                            void *opaque),
    void *opaque, int flags);
QJS_HIDE int js_link_module(LEPUSContext *ctx, LEPUSModuleDef *m);
QJS_HIDE int skip_spaces(const char *pc);
int JS_DefineObjectName_GC(LEPUSContext *ctx, LEPUSValueConst obj, JSAtom name,
                           int flags);
QJS_HIDE LEPUSValue js_atod(LEPUSContext *ctx, const char *str, const char **pp,
                            int radix, int flags);
QJS_HIDE int js_resolve_module(LEPUSContext *ctx, LEPUSModuleDef *m);
QJS_HIDE void close_scopes(JSParseState *s, int scope, int scope_stop);
QJS_HIDE JSFunctionDef *js_new_function_def_GC(LEPUSContext *ctx,
                                               JSFunctionDef *parent,
                                               BOOL is_eval, BOOL is_func_expr,
                                               const char *filename,
                                               int line_num);
QJS_HIDE void pop_scope(JSParseState *s);
QJS_HIDE JSHoistedDef *find_hoisted_def(JSFunctionDef *fd, JSAtom name);
QJS_HIDE BOOL is_child_scope(LEPUSContext *ctx, JSFunctionDef *fd, int scope,
                             int parent_scope);
QJS_HIDE int find_lexical_decl(LEPUSContext *ctx, JSFunctionDef *fd,
                               JSAtom name, int scope_idx,
                               BOOL check_catch_var);
QJS_HIDE int find_arg(LEPUSContext *ctx, JSFunctionDef *fd, JSAtom name);
QJS_HIDE int find_var(LEPUSContext *ctx, JSFunctionDef *fd, JSAtom name);
QJS_HIDE int js_parse_class(JSParseState *s, BOOL is_class_expr,
                            JSParseExportEnum export_flag);
QJS_HIDE int js_parse_left_hand_side_expr_GC(JSParseState *s);
QJS_HIDE int js_parse_property_name_GC(JSParseState *s, JSAtom *pname,
                                       BOOL allow_method, BOOL allow_var,
                                       BOOL allow_private);
QJS_HIDE int js_parse_function_check_names(JSParseState *s, JSFunctionDef *fd,
                                           JSAtom func_name);
QJS_HIDE int is_let(JSParseState *s, int decl_mask);
QJS_HIDE int __attribute__((format(printf, 2, 3))) QJS_HIDE js_parse_error(
    JSParseState *s, const char *fmt, ...);
QJS_HIDE int find_var_in_child_scope(LEPUSContext *ctx, JSFunctionDef *fd,
                                     JSAtom name, int scope_level);
QJS_HIDE int add_arg(LEPUSContext *ctx, JSFunctionDef *fd, JSAtom name);
#ifndef NO_QUICKJS_COMPILER
typedef struct JSParseState {
  LEPUSContext *ctx;
  int last_line_num; /* line number of last token */
  int line_num;      /* line number of current offset */
  const char *filename;
  JSToken token;
  BOOL got_lf; /* true if got line feed before the current token */
  const uint8_t *last_ptr;
  const uint8_t *buf_ptr;
  const uint8_t *buf_end;
  // <Primjs begin>
  int debugger_last_line_num;
  const uint8_t *line_begin_ptr;
  const uint8_t *last_line_begin_ptr;
  const uint8_t *last_emit_ptr;
  const uint8_t *func_call_ptr;
  const uint8_t *utf8_parse_front;
  int utf8_adapte_size;
  int func_call_adapte_size;
  int last_utf8_adapte_size;
  const uint8_t *last_last_ptr;
  // <Primjs end>
  /* current function code */
  JSFunctionDef *cur_func;
  BOOL is_module; /* parsing a module */
  BOOL allow_html_comments;
} JSParseState;
#endif
QJS_HIDE LEPUSValue js_finalizationRegistry_unregister(LEPUSContext *ctx,
                                                       LEPUSValueConst this_val,
                                                       int argc,
                                                       LEPUSValueConst *argv);
QJS_HIDE LEPUSValue js_finalizationRegistry_unregister_gc(
    LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
    LEPUSValueConst *argv);

QJS_HIDE LEPUSValue js_finalizationRegistry_register(LEPUSContext *ctx,
                                                     LEPUSValueConst this_val,
                                                     int argc,
                                                     LEPUSValueConst *argv);
QJS_HIDE LEPUSValue
js_finalizationRegistry_register_gc(LEPUSContext *ctx, LEPUSValueConst this_val,
                                    int argc, LEPUSValueConst *argv);

QJS_HIDE void AddReferenceRecord(LEPUSContext *ctx, LEPUSObject *obj,
                                 LEPUSValue val);
QJS_HIDE const char *generate_json_str(LEPUSContext *ctx, LEPUSValue obj,
                                       size_t &str_len, const char ***str_arr,
                                       size_t &ts, size_t &cs);
typedef union json_val_uni {
  int64_t i64;
  double f64;
  const char *str;
  size_t ofs;
  LEPUSValue bigf;  // for JSON.stringify bigfloat
  LEPUSValue num;   // for JSON.parse number
} json_val_uni;

struct json_val {
  uint64_t tag;     /**< type, subtype and length */
  json_val_uni uni; /**< payload */
};
QJS_HIDE int make_json_val_incr(LEPUSContext *ctx, size_t &alc_len,
                                json_val **val_hdr, json_val **val,
                                json_val **ctn, json_val **val_end);
QJS_HIDE uint8_t *json_val_write_format(LEPUSContext *ctx, json_val *root,
                                        const char *gap_str);
QJS_HIDE uint8_t *json_val_write(LEPUSContext *ctx, json_val *root);
QJS_HIDE void parse_json_space(JSParseState *s, const uint8_t **cur);
QJS_HIDE bool read_string(JSParseState *s, uint8_t **ptr, json_val *val);
QJS_HIDE json_val *json_parse_value(JSParseState *s, size_t dat_len);
QJS_HIDE void js_parse_init(LEPUSContext *ctx, JSParseState *s,
                            const char *input, size_t input_len,
                            const char *filename);
QJS_HIDE LEPUSValue JS_ParseJSONOPT(LEPUSContext *ctx, const char *buf,
                                    size_t buf_len, const char *filename);
QJS_HIDE LEPUSObject *get_typed_array(LEPUSContext *ctx,
                                      LEPUSValueConst this_val,
                                      int is_dataview);
QJS_HIDE BOOL typed_array_is_detached(LEPUSContext *ctx, LEPUSObject *p);
QJS_HIDE LEPUSValue js_dataview_getValue(LEPUSContext *ctx,
                                         LEPUSValueConst this_obj, int argc,
                                         LEPUSValueConst *argv, int class_id);
QJS_HIDE LEPUSValue js_dataview_setValue(LEPUSContext *ctx,
                                         LEPUSValueConst this_obj, int argc,
                                         LEPUSValueConst *argv, int class_id);
QJS_HIDE JSArrayBuffer *js_get_array_buffer(LEPUSContext *ctx,
                                            LEPUSValueConst obj);
QJS_HIDE LEPUSValue js_create_from_ctor_GC(LEPUSContext *ctx,
                                           LEPUSValueConst ctor, int class_id);
QJS_HIDE LEPUSValue js_dataview_constructor(LEPUSContext *ctx,
                                            LEPUSValueConst new_target,
                                            int argc, LEPUSValueConst *argv);
QJS_HIDE LEPUSValue js_typed_array_get_buffer(LEPUSContext *ctx,
                                              LEPUSValueConst this_val,
                                              int is_dataview);
QJS_HIDE LEPUSValue js_typed_array_get_length(LEPUSContext *ctx,
                                              LEPUSValueConst this_val);
QJS_HIDE LEPUSValue js_typed_array_get_byteLength(LEPUSContext *ctx,
                                                  LEPUSValueConst this_val,
                                                  int is_dataview);
QJS_HIDE LEPUSValue js_typed_array_get_byteOffset(LEPUSContext *ctx,
                                                  LEPUSValueConst this_val,
                                                  int is_dataview);
const LEPUSCFunctionListEntry js_dataview_proto_funcs[] = {
    LEPUS_CGETSET_MAGIC_DEF("buffer", js_typed_array_get_buffer, NULL, 1),
    LEPUS_CGETSET_MAGIC_DEF("byteLength", js_typed_array_get_byteLength, NULL,
                            1),
    LEPUS_CGETSET_MAGIC_DEF("byteOffset", js_typed_array_get_byteOffset, NULL,
                            1),
    LEPUS_CFUNC_MAGIC_DEF("getInt8", 1, js_dataview_getValue,
                          JS_CLASS_INT8_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("getUint8", 1, js_dataview_getValue,
                          JS_CLASS_UINT8_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("getInt16", 1, js_dataview_getValue,
                          JS_CLASS_INT16_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("getUint16", 1, js_dataview_getValue,
                          JS_CLASS_UINT16_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("getInt32", 1, js_dataview_getValue,
                          JS_CLASS_INT32_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("getUint32", 1, js_dataview_getValue,
                          JS_CLASS_UINT32_ARRAY),
#ifdef CONFIG_BIGNUM
    LEPUS_CFUNC_MAGIC_DEF("getBigInt64", 1, js_dataview_getValue,
                          JS_CLASS_BIG_INT64_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("getBigUint64", 1, js_dataview_getValue,
                          JS_CLASS_BIG_UINT64_ARRAY),
#endif
    LEPUS_CFUNC_MAGIC_DEF("getFloat32", 1, js_dataview_getValue,
                          JS_CLASS_FLOAT32_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("getFloat64", 1, js_dataview_getValue,
                          JS_CLASS_FLOAT64_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("setInt8", 2, js_dataview_setValue,
                          JS_CLASS_INT8_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("setUint8", 2, js_dataview_setValue,
                          JS_CLASS_UINT8_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("setInt16", 2, js_dataview_setValue,
                          JS_CLASS_INT16_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("setUint16", 2, js_dataview_setValue,
                          JS_CLASS_UINT16_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("setInt32", 2, js_dataview_setValue,
                          JS_CLASS_INT32_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("setUint32", 2, js_dataview_setValue,
                          JS_CLASS_UINT32_ARRAY),
#ifdef CONFIG_BIGNUM
    LEPUS_CFUNC_MAGIC_DEF("setBigInt64", 2, js_dataview_setValue,
                          JS_CLASS_BIG_INT64_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("setBigUint64", 2, js_dataview_setValue,
                          JS_CLASS_BIG_UINT64_ARRAY),
#endif
    LEPUS_CFUNC_MAGIC_DEF("setFloat32", 2, js_dataview_setValue,
                          JS_CLASS_FLOAT32_ARRAY),
    LEPUS_CFUNC_MAGIC_DEF("setFloat64", 2, js_dataview_setValue,
                          JS_CLASS_FLOAT64_ARRAY),
    LEPUS_PROP_STRING_DEF("[Symbol.toStringTag]", "DataView",
                          LEPUS_PROP_CONFIGURABLE),
};
QJS_HIDE void js_dtoa1(char *buf, double d, int radix, int n_digits, int flags);
QJS_HIDE LEPUSValue js_closure2(LEPUSContext *ctx, LEPUSValue func_obj,
                                LEPUSFunctionBytecode *b,
                                JSVarRef **cur_var_refs, LEPUSStackFrame *sf);
QJS_HIDE void js_random_init(LEPUSContext *ctx);
QJS_HIDE LEPUSValue js_math_random(LEPUSContext *ctx, LEPUSValueConst this_val,
                                   int argc, LEPUSValueConst *argv);
QJS_HIDE int getTimezoneOffset(int64_t time);
QJS_HIDE int JS_SetPrototypeInternal_GC(LEPUSContext *ctx, LEPUSValueConst obj,
                                        LEPUSValueConst proto_val,
                                        BOOL throw_flag);
QJS_HIDE LEPUSValue js_reflect_setPrototypeOf(LEPUSContext *ctx,
                                              LEPUSValueConst this_val,
                                              int argc, LEPUSValueConst *argv);
QJS_HIDE LEPUSValue js_reflect_has(LEPUSContext *ctx, LEPUSValueConst this_val,
                                   int argc, LEPUSValueConst *argv);
QJS_HIDE LEPUSValue js_reflect_set(LEPUSContext *ctx, LEPUSValueConst this_val,
                                   int argc, LEPUSValueConst *argv);
QJS_HIDE LEPUSValue js_reflect_get(LEPUSContext *ctx, LEPUSValueConst this_val,
                                   int argc, LEPUSValueConst *argv);
QJS_HIDE LEPUSValue js_reflect_deleteProperty(LEPUSContext *ctx,
                                              LEPUSValueConst this_val,
                                              int argc, LEPUSValueConst *argv);
QJS_HIDE int JS_SetPropertyGeneric_GC(LEPUSContext *ctx, LEPUSObject *p,
                                      JSAtom prop, LEPUSValue val,
                                      LEPUSValueConst this_obj, int flags);
QJS_HIDE void js_shape_hash_unlink(LEPUSRuntime *rt, JSShape *sh);
QJS_HIDE void js_shape_hash_link(LEPUSRuntime *rt, JSShape *sh);
QJS_HIDE int resize_shape_hash(LEPUSRuntime *rt, int new_shape_hash_bits);
QJS_HIDE int resize_properties(LEPUSContext *ctx, JSShape **psh, LEPUSObject *p,
                               uint32_t count);
QJS_HIDE BOOL lre_check_stack_overflow(void *opaque, size_t alloca_size);
QJS_HIDE void build_backtrace_frame(LEPUSContext *ctx, LEPUSStackFrame *sf,
                                    DynBuf *dbuf, const uint8_t *cur_pc,
                                    BOOL is_async, BOOL is_debug_mode,
                                    LEPUSValueConst error_obj);
QJS_HIDE void get_backtrace(LEPUSContext *ctx, DynBuf *dbuf, BOOL is_debug_mode,
                            LEPUSValueConst error_obj, const uint8_t *cur_pc,
                            int backtrace_flags);
QJS_HIDE LEPUSValue JS_GetIterator(LEPUSContext *ctx, LEPUSValueConst obj,
                                   BOOL is_async);
QJS_HIDE LEPUSValue JS_GetIterator2(LEPUSContext *ctx, LEPUSValueConst obj,
                                    LEPUSValueConst method);
QJS_HIDE LEPUSValue JS_IteratorNext2(LEPUSContext *ctx,
                                     LEPUSValueConst enum_obj,
                                     LEPUSValueConst method, int argc,
                                     LEPUSValueConst *argv, int *pdone);
QJS_HIDE LEPUSValue JS_IteratorNext(LEPUSContext *ctx, LEPUSValueConst enum_obj,
                                    LEPUSValueConst method, int argc,
                                    LEPUSValueConst *argv, BOOL *pdone);
QJS_HIDE JSShapeProperty *find_own_property1(LEPUSObject *p, JSAtom atom);
QJS_HIDE LEPUSValue JS_ThrowError(LEPUSContext *ctx, JSErrorEnum error_num,
                                  const char *fmt, va_list ap);
QJS_HIDE int __attribute__((format(printf, 3, 4)))
JS_ThrowTypeErrorOrFalse(LEPUSContext *ctx, int flags, const char *fmt, ...);
QJS_HIDE int __attribute__((format(printf, 2, 3))) QJS_HIDE js_throw_URIError(
    LEPUSContext *ctx, const char *fmt, ...);
QJS_HIDE void *LEPUS_GetOpaque2(LEPUSContext *ctx, LEPUSValueConst obj,
                                LEPUSClassID class_id);
QJS_HIDE JSRegExp *js_get_regexp(LEPUSContext *ctx, LEPUSValueConst obj,
                                 BOOL throw_error);
QJS_HIDE LEPUSValue __attribute__((format(printf, 3, 4)))
__JS_ThrowTypeErrorAtom(LEPUSContext *ctx, JSAtom atom, const char *fmt, ...);
QJS_HIDE LEPUSValue JS_ThrowTypeErrorPrivateNotFound(LEPUSContext *ctx,
                                                     JSAtom atom);
typedef struct BlockEnv {
  struct BlockEnv *prev;
  JSAtom label_name; /* JS_ATOM_NULL if none */
  int label_break;   /* -1 if none */
  int label_cont;    /* -1 if none */
  int drop_count;    /* number of stack elements to drop */
  int label_finally; /* -1 if none */
  int scope_level;
  int has_iterator;
} BlockEnv;

typedef struct RelocEntry {
  struct RelocEntry *next;
  uint32_t addr; /* address to patch */
  int size;      /* address size: 1, 2 or 4 bytes */
} RelocEntry;

typedef struct JumpSlot {
  int op;
  int size;
  int pos;
  int label;
} JumpSlot;

typedef struct LabelSlot {
  int ref_count;
  int pos;  /* phase 1 address, -1 means not resolved yet */
  int pos2; /* phase 2 address, -1 means not resolved yet */
  int addr; /* phase 3 address, -1 means not resolved yet */
  RelocEntry *first_reloc;
} LabelSlot;

typedef struct LineNumberSlot {
  uint32_t pc;
  // <Primjs begin>
  uint64_t line_num;
  // <Primjs end>
} LineNumberSlot;

typedef struct JSFunctionDef {
  LEPUSContext *ctx;
  struct JSFunctionDef *parent;
  int parent_cpool_idx;   /* index in the constant pool of the parent
                             or -1 if none */
  int parent_scope_level; /* scope level in parent at point of definition */
  struct list_head child_list; /* list of JSFunctionDef.link */
  struct list_head link;

  BOOL is_eval;         /* TRUE if eval code */
  int eval_type;        /* only valid if is_eval = TRUE */
  BOOL is_global_var;   /* TRUE if variables are not defined locally:
                           eval global, eval module or non strict eval */
  BOOL is_func_expr;    /* TRUE if function expression */
  BOOL has_home_object; /* TRUE if the home object is available */
  BOOL has_prototype;   /* true if a prototype field is necessary */
  BOOL has_simple_parameter_list;
  BOOL has_parameter_expressions; /* if true, an argument scope is created */
  BOOL has_use_strict;            /* to reject directive in special cases */
  BOOL has_eval_call; /* true if the function contains a call to eval() */
  BOOL has_arguments_binding; /* true if the 'arguments' binding is
                                 available in the function */
  BOOL has_this_binding;      /* true if the 'this' and new.target binding are
                                 available in the function */
  BOOL new_target_allowed;    /* true if the 'new.target' does not
                                 throw a syntax error */
  BOOL super_call_allowed;    /* true if super() is allowed */
  BOOL super_allowed;         /* true if super. or super[] is allowed */
  BOOL arguments_allowed; /* true if the 'arguments' identifier is allowed */
  BOOL is_derived_class_constructor;
  BOOL in_function_body;
  JSFunctionKindEnum func_kind : 8;
  JSParseFunctionEnum func_type : 8;
  uint8_t js_mode;  /* bitmap of JS_MODE_x */
  JSAtom func_name; /* JS_ATOM_NULL if no name */

  JSVarDef *vars;
  int var_size; /* allocated size for vars[] */
  int var_count;
  JSVarDef *args;
  int arg_size;  /* allocated size for args[] */
  int arg_count; /* number of arguments */
  int defined_arg_count;
  int var_object_idx;     /* -1 if none */
  int arg_var_object_idx; /* -1 if none (var object for the argument scope) */
  int arguments_var_idx;  /* -1 if none */
  int arguments_arg_idx;  /* argument variable definition in argument scope, -1
                             if none */
  int func_var_idx;       /* variable containing the current function (-1
                             if none, only used if is_func_expr is true) */
  int eval_ret_idx; /* variable containing the return value of the eval, -1 if
                       none */
  int this_var_idx; /* variable containg the 'this' value, -1 if none */
  int new_target_var_idx; /* variable containg the 'new.target' value, -1 if
                             none */
  int this_active_func_var_idx; /* variable containg the 'this.active_func'
                                   value, -1 if none */
  int home_object_var_idx;
  BOOL need_home_object;

  int scope_level; /* index into fd->scopes if the current lexical scope */
  int scope_first; /* index into vd->vars of first lexically scoped variable */
  int scope_size;  /* allocated size of fd->scopes array */
  int scope_count; /* number of entries used in the fd->scopes array */
  JSVarScope *scopes;
  JSVarScope def_scope_array[4];
  int body_scope; /* scope of the body of the function or eval */

  int hoisted_def_count;
  int hoisted_def_size;
  JSHoistedDef *hoisted_def;

  DynBuf byte_code;
  int last_opcode_pos; /* -1 if no last opcode */
  int last_opcode_line_num;
  BOOL use_short_opcodes; /* true if short opcodes are used in byte_code */

  LabelSlot *label_slots;
  int label_size; /* allocated size for label_slots[] */
  int label_count;
  BlockEnv *top_break; /* break/continue label stack */

  /* constant pool (strings, functions, numbers) */
  LEPUSValue *cpool;
  uint32_t cpool_count;
  uint32_t cpool_size;

  /* list of variables in the closure */
  int closure_var_count;
  int closure_var_size;
  LEPUSClosureVar *closure_var;

  JumpSlot *jump_slots;
  int jump_size;
  int jump_count;

  LineNumberSlot *line_number_slots;
  int line_number_size;
  int line_number_count;
  // <Primjs begin>
  int64_t line_number_last;
  int64_t line_number_last_pc;
  // <Primjs end>

  /* pc2line table */
  JSAtom filename;
  int line_num;
#ifdef ENABLE_QUICKJS_DEBUGGER
  int64_t column_num;
  LEPUSScriptSource *script;
#endif
  DynBuf pc2line;

  CallerStrSlot *caller_slots;
  int32_t caller_size;
  int32_t caller_count;
  int32_t resolve_caller_count;
  bool should_add_slot;

  const char *src_start;
  char *source; /* raw source, utf-8 encoded */
  int source_len;

  LEPUSModuleDef *module; /* != NULL when parsing a module */
} JSFunctionDef;

QJS_HIDE int add_closure_variables(LEPUSContext *ctx, JSFunctionDef *s,
                                   LEPUSFunctionBytecode *b, int scope_idx);
QJS_HIDE int JS_DefinePropertyValueInt64_GC(LEPUSContext *ctx,
                                            LEPUSValueConst this_obj,
                                            int64_t idx, LEPUSValue val,
                                            int flags);
QJS_HIDE LEPUSValue js_error_constructor(LEPUSContext *ctx,
                                         LEPUSValueConst new_target, int argc,
                                         LEPUSValueConst *argv, int magic);

QJS_HIDE BOOL JS_AtomIsString(LEPUSContext *ctx, JSAtom v);

QJS_HIDE LEPUSValue JS_NewObjectFromShape(LEPUSContext *, JSShape *,
                                          LEPUSClassID);

QJS_HIDE LEPUSValue JS_NewObjectFromShape_GC(LEPUSContext *, JSShape *,
                                             LEPUSClassID);

QJS_HIDE LEPUSFunctionBytecode *JS_GetFunctionBytecode(LEPUSValueConst);
QJS_HIDE JSAtom js_symbol_to_atom(LEPUSContext *, LEPUSValue);
QJS_HIDE LEPUSValueConst JS_GetActiveFunction(LEPUSContext *ctx);
QJS_HIDE LEPUSValue js_array_buffer_get_byteLength(LEPUSContext *,
                                                   LEPUSValueConst, int32_t);
#ifndef NO_QUICKJS_COMPILER
// the last two parameters are needed for qjs debugger, default value: false,
// NULL
QJS_HIDE LEPUSValue JS_EvalInternal(LEPUSContext *, LEPUSValue, const char *,
                                    size_t, const char *, int, int,
                                    bool = false, LEPUSStackFrame * = nullptr);
#endif

LEPUSValue js_array_reduce_gc(LEPUSContext *ctx, LEPUSValueConst this_val,
                              int argc, LEPUSValueConst *argv, int special);

LEPUSValue js_array_concat_gc(LEPUSContext *ctx, LEPUSValueConst this_val,
                              int argc, LEPUSValueConst *argv);
/* Shape support */
QJS_STATIC inline JSShapeProperty *get_shape_prop(JSShape *sh) {
  return sh->prop;
}

QJS_STATIC inline size_t get_shape_size(size_t hash_size, size_t prop_size) {
  return hash_size * sizeof(uint32_t) + sizeof(JSShape) +
         prop_size * sizeof(JSShapeProperty);
}

QJS_STATIC inline JSShape *get_shape_from_alloc(void *sh_alloc,
                                                size_t hash_size) {
  return (JSShape *)(void *)((uint32_t *)sh_alloc + hash_size);
}

QJS_STATIC inline void *get_alloc_from_shape(JSShape *sh) {
  return sh->prop_hash_end - ((intptr_t)sh->prop_hash_mask + 1);
}

QJS_STATIC inline BOOL atom_is_free(const JSAtomStruct *p) {
  return (uintptr_t)p & 1;
}

QJS_STATIC inline BOOL __JS_AtomIsTaggedInt(JSAtom v) {
  return (v & JS_ATOM_TAG_INT) != 0;
}

QJS_STATIC inline JSAtom __JS_AtomFromUInt32(uint32_t v) {
  return v | JS_ATOM_TAG_INT;
}

QJS_STATIC inline uint32_t __JS_AtomToUInt32(JSAtom atom) {
  return atom & ~JS_ATOM_TAG_INT;
}

QJS_HIDE JSAtomKindEnum JS_AtomGetKind(LEPUSContext *, JSAtom);
QJS_HIDE LEPUS_BOOL JS_LepusRefIsArray(LEPUSRuntime *rt, LEPUSValue v);
QJS_HIDE LEPUS_BOOL JS_LepusRefIsTable(LEPUSRuntime *rt, LEPUSValue v);
QJS_HIDE JSShape *js_dup_shape(JSShape *sh);

typedef struct JSCFunctionDataRecord {
  LEPUSCFunctionData *func;
  uint8_t length;
  uint8_t data_len;
  uint16_t magic;
  LEPUSValue data[0];
} JSCFunctionDataRecord;

typedef struct ValueBuffer {
  LEPUSContext *ctx;
  LEPUSValue *arr;
  LEPUSValue def[4];
  int len;
  int size;
  int error_status;
} ValueBuffer;

typedef enum JSPromiseStateEnum {
  JS_PROMISE_PENDING,
  JS_PROMISE_FULFILLED,
  JS_PROMISE_REJECTED,
} JSPromiseStateEnum;

typedef struct JSPromiseData {
  JSPromiseStateEnum promise_state;
  /* 0=fulfill, 1=reject, list of JSPromiseReactionData.link */
  struct list_head promise_reactions[2];
  BOOL is_handled; /* Note: only useful to debug */
  LEPUSValue promise_result;
} JSPromiseData;

typedef struct JSPromiseFunctionDataResolved {
  int ref_count;
  BOOL already_resolved;
} JSPromiseFunctionDataResolved;

typedef struct JSPromiseFunctionData {
  LEPUSValue promise;
  JSPromiseFunctionDataResolved *presolved;
} JSPromiseFunctionData;

typedef struct JSPromiseReactionData {
  struct list_head link; /* not used in promise_reaction_job */
  LEPUSValue resolving_funcs[2];
  LEPUSValue handler;
} JSPromiseReactionData;

typedef struct ReferenceRecord {
  int max_size;
  LEPUSValue *references;
  int length;
} ReferenceRecord;

typedef struct RegistryRecord {
  struct ReferenceRecord *registra;
  struct ReferenceRecord *heldvalue;
  struct ReferenceRecord *target;
  struct ReferenceRecord *token;
  struct JSFinalizationRegistryEntry *entry;
  int *idx;
} RegistryRecord;

typedef struct JSMapRecord {
  int ref_count; /* used during enumeration to avoid freeing the record */
  BOOL empty;    /* TRUE if the record is deleted */
  struct JSMapState *map;
  struct list_head link;
  struct list_head hash_link;
  LEPUSValue key;
  LEPUSValue value;
} JSMapRecord;

typedef struct ValueSlot {
  LEPUSValue val;
  JSString *str;
  int64_t pos;
} ValueSlot;

struct array_sort_context {
  LEPUSContext *ctx;
  int exception;
  int has_method;
  LEPUSValueConst method;
};

typedef struct FinalizerOpaque {
  LEPUSContext *ctx;
} FinalizerOpaque;

/* <gc end> */
#define BC_NEW_PREFIX 0x8
#define VERSION_PLACEHOLDER 0xCAB00000
#define NEW_DEBUGINFO_FLAG 0x100000000

bool JS_IsNewVersion(LEPUSContext *ctx);
bool JS_CheckBytecodeVersion(uint64_t v64);

QJS_HIDE bool primjs_snapshot_enabled();

QJS_HIDE void DeleteCurNode(LEPUSRuntime *rt, void *node, int type);
QJS_HIDE bool CheckValidNode(LEPUSRuntime *rt, void *node, int type);

// #sec-tointgerorinfinity
inline double DoubleToInteger(double x) {
  if (isnan(x) || x == 0.0) return 0;
  if (!isfinite(x)) return x;
  return ((x > 0) ? floor(x) : ceil(x)) + 0.0;
}

inline void insert_weakref_record(LEPUSObject *p,
                                  struct WeakRefRecord *record) {
  record->next_weak_ref = p->first_weak_ref;
  p->first_weak_ref = record;
  return;
}

char *js_strmalloc(const char *s, size_t n);
void AddLepusRefCount(LEPUSContext *ctx);

class LynxTraceInstance {
 public:
  using BeginPtr = void *(*)(const char *);
  using EndPtr = void (*)(void *);
  static auto &GetInstance() {
    static LynxTraceInstance instance;
    return instance;
  }
  void InitBeginPtr(BeginPtr begin) { trace_start_ = begin; }
  void InitEndPtr(EndPtr end) { trace_end_ = end; }

  auto GetBeginPtr() const { return trace_start_; }
  auto GetEndPtr() const { return trace_end_; }

 private:
  BeginPtr trace_start_{nullptr};
  EndPtr trace_end_{nullptr};
};

class TraceManager {
 public:
  explicit TraceManager(const char *name) {
    if (auto call_begin = LynxTraceInstance::GetInstance().GetBeginPtr()) {
      ptr = call_begin(name);
    }
  }

  ~TraceManager() {
    if (auto call_end = LynxTraceInstance::GetInstance().GetEndPtr()) {
      call_end(ptr);
    }
  }

 private:
  void *ptr{nullptr};
};

#define JS_OBJECT_IS_OUTER(obj) (obj->class_id >= JS_CLASS_INIT_COUNT)

#ifdef ENABLE_QUICKJS_DEBUGGER
#define TRACE_EVENT(name) auto tracer = TraceManager{name};

#ifdef ENABLE_COMPATIBLE_MM
#define DEBUGGER_COMPATIBLE_CALL_RET(ctx, name, args...) \
  (ctx->rt->gc_enable) ? (name##_GC(args)) : (name(args))
#else
#define DEBUGGER_COMPATIBLE_CALL_RET(ctx, name, args...) (name(args))
#endif /* ENABLE_COMPATIBLE_MM */

#else
#define TRACE_EVENT(name)
#define DEBUGGER_COMPATIBLE_CALL_RET
#endif /* ENABLE_QUICKJS_DEBUGGER */

int64_t date_now();

inline bool json_opt_disabled() { return JSON_OPT_DISABLE & settingsFlag; }
inline bool json_opt_disabled(LEPUSRuntime *rt) {
  return rt->settings_option.disable_json_opt;
}
inline bool deepclone_opt_disabled() {
  return DEEPCLONE_OPT_DISABLE & settingsFlag;
}

inline bool deepclone_opt_disabled(LEPUSRuntime *rt) {
  return rt->settings_option.disable_deepclone_opt;
}

inline bool separable_string_disabled() {
  return DISABLE_SEPARABLE_STRING & settingsFlag;
}

inline bool minify_virtual_stack_size_enabled() {
  return settingsFlag & MINIFY_STACK_ENABLE;
}

inline bool separable_string_disabled(LEPUSRuntime *rt) {
  return rt->settings_option.disable_separable_string;
}

inline bool adjust_stacksize_disabled() {
  return DISABLE_ADJUST_STACKSIZE & settingsFlag;
}

inline void js_init_settings_options(LEPUSRuntime *rt) {
  rt->settings_option.disable_adjust_stacksize = adjust_stacksize_disabled();
  rt->settings_option.disable_json_opt = json_opt_disabled();
  rt->settings_option.disable_deepclone_opt = deepclone_opt_disabled();
  rt->settings_option.disable_separable_string = separable_string_disabled();
  return;
}

inline bool js_is_bytecode_function(LEPUSValue obj) {
  return (LEPUS_VALUE_IS_OBJECT(obj)) &&
         (LEPUS_VALUE_GET_OBJ(obj)->class_id == JS_CLASS_BYTECODE_FUNCTION);
}

bool emit_name_str(JSParseState *s, const uint8_t *start, const uint8_t *end);
void get_caller_string(JSFunctionDef *s);

#endif  // SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_INNER_H_
