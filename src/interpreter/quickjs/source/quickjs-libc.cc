/*
 * QuickJS C library
 *
 * Copyright (c) 2017-2019 Fabrice Bellard
 * Copyright (c) 2017-2019 Charlie Gordon
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#if defined(_WIN32)
#include <io.h>
#if defined(_MSC_VER)
#include <BaseTsd.h>
typedef SSIZE_T ssize_t;
#endif
#include <winsock.h>
#else
#if !defined(__WASI_SDK__)
#include <dlfcn.h>
#include <termios.h>
#endif
#include <sys/ioctl.h>
#include <sys/time.h>
#include <unistd.h>
#if defined(__APPLE__)
typedef sig_t sighandler_t;
#endif
#endif

#include "gc/trace-gc.h"

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/cutils.h"
#include "quickjs/include/list.h"
#include "quickjs/include/quickjs-libc.h"
#ifdef __cplusplus
}
#endif
#include "quickjs/include/quickjs-inner.h"

#if defined(_WIN32)
int gettimeofday(struct timeval *tp, void *tzp) {
  static const uint64_t EPOCH = ((uint64_t)116444736000000000ULL);

  SYSTEMTIME system_time;
  FILETIME file_time;
  uint64_t time;

  GetSystemTime(&system_time);
  SystemTimeToFileTime(&system_time, &file_time);
  time = ((uint64_t)file_time.dwLowDateTime);
  time += ((uint64_t)file_time.dwHighDateTime) << 32;

  tp->tv_sec = (long)((time - EPOCH) / 10000000L);
  tp->tv_usec = (long)(system_time.wMilliseconds * 1000);
  return 0;
}
#endif

typedef struct {
  struct list_head link;
  int64_t timeout;
  LEPUSValue func;
  int32_t timer_id;
} JSOSTimer;

typedef struct JSThreadState {
  struct list_head os_timers;
  int32_t next_timer_id;
} JSThreadState;

static inline void JS_SetRuntimeOpaque(LEPUSRuntime *rt, void *opaque) {
  rt->user_opaque = opaque;
  return;
}

static inline void *JS_GetRuntimeOpaque(LEPUSRuntime *rt) {
  return rt->user_opaque;
}

static int (*os_poll_func)(LEPUSContext *ctx);
#if LYNX_SIMPLIFY
uint8_t *lepus_load_file(LEPUSContext *ctx, size_t *pbuf_len,
                         const char *filename) {
  FILE *f;
  uint8_t *buf;
  size_t buf_len;

  f = fopen(filename, "rb");
  if (!f) return NULL;
  fseek(f, 0, SEEK_END);
  buf_len = ftell(f);
  fseek(f, 0, SEEK_SET);
  buf = static_cast<uint8_t *>(malloc(buf_len + 1));
  fread(buf, 1, buf_len, f);
  buf[buf_len] = '\0';
  fclose(f);
  *pbuf_len = buf_len;
  return buf;
}

#endif

#if defined(__linux__) || defined(__APPLE__)
static int64_t get_time_ms(void) {
  struct timespec ts;
  if (__builtin_available(iOS 10.0, *)) {
    clock_gettime(CLOCK_MONOTONIC, &ts);
  } else {
    // Fallback on earlier versions
  }
  return (uint64_t)ts.tv_sec * 1000 + (ts.tv_nsec / 1000000);
}
#else
/* more portable, but does not work if the date is updated */
static int64_t get_time_ms(void) {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return (int64_t)tv.tv_sec * 1000 + (tv.tv_usec / 1000);
}
#endif

static void free_timer(LEPUSRuntime *rt, JSOSTimer *th) {
  list_del(&th->link);
  if (!LEPUS_IsGCModeRT(rt)) {
    LEPUS_FreeValueRT(rt, th->func);
    lepus_free_rt(rt, th);
  }
}

static LEPUSValue js_os_setTimeout_gc(LEPUSContext *ctx,
                                      LEPUSValueConst this_val, int argc,
                                      LEPUSValueConst *argv) {
  int64_t delay;
  LEPUSValueConst func;
  JSOSTimer *th;
  LEPUSRuntime *rt = ctx->rt;
  JSThreadState *ts = static_cast<JSThreadState *>(JS_GetRuntimeOpaque(rt));
  if (!ts) return LEPUS_EXCEPTION;
  func = argv[0];
  if (!LEPUS_IsFunction(ctx, func))
    return LEPUS_ThrowTypeError(ctx, "not a function");
  HandleScope func_scope(ctx, &func, HANDLE_TYPE_LEPUS_VALUE);
  if (LEPUS_ToInt64(ctx, &delay, argv[1])) return LEPUS_EXCEPTION;
  th = static_cast<JSOSTimer *>(
      lepus_mallocz(ctx, sizeof(*th), ALLOC_TAG_JSOSTimer));
  if (!th) {
    return LEPUS_EXCEPTION;
  }
  if (ts->next_timer_id == 0) {
    ts->next_timer_id = 1;
  }
  th->timer_id = ts->next_timer_id++;
  th->timeout = get_time_ms() + delay;
  th->func = func;
  list_add_tail(&th->link, &ts->os_timers);
  return LEPUS_NewInt32(ctx, th->timer_id);
}

static LEPUSValue js_os_setTimeout(LEPUSContext *ctx, LEPUSValueConst this_val,
                                   int argc, LEPUSValueConst *argv) {
  if (LEPUS_IsGCMode(ctx)) {
    return js_os_setTimeout_gc(ctx, this_val, argc, argv);
  }
  int64_t delay;
  LEPUSValueConst func;
  JSOSTimer *th;
  LEPUSRuntime *rt = ctx->rt;
  JSThreadState *ts = static_cast<JSThreadState *>(JS_GetRuntimeOpaque(rt));
  if (!ts) return LEPUS_EXCEPTION;
  func = argv[0];
  if (!LEPUS_IsFunction(ctx, func))
    return LEPUS_ThrowTypeError(ctx, "not a function");
  if (LEPUS_ToInt64(ctx, &delay, argv[1])) return LEPUS_EXCEPTION;
  th = static_cast<JSOSTimer *>(
      lepus_malloc(ctx, sizeof(JSOSTimer), ALLOC_TAG_JSOSTimer));
  if (!th) {
    return LEPUS_EXCEPTION;
  }
  if (ts->next_timer_id == 0) {
    ts->next_timer_id = 1;
  }
  th->timer_id = ts->next_timer_id++;
  th->timeout = get_time_ms() + delay;
  th->func = LEPUS_DupValue(ctx, func);
  list_add_tail(&th->link, &ts->os_timers);
  return LEPUS_NewInt32(ctx, th->timer_id);
}

static JSOSTimer *find_timer_by_id(JSThreadState *ts, int32_t timer_id) {
  if (timer_id <= 0) return nullptr;
  list_head *el;
  list_for_each(el, &ts->os_timers) {
    JSOSTimer *th = list_entry(el, JSOSTimer, link);
    if (th->timer_id == timer_id) return th;
  }
  return nullptr;
}

static LEPUSValue js_os_clearTimeout(LEPUSContext *ctx,
                                     LEPUSValueConst this_val, int argc,
                                     LEPUSValueConst *argv) {
  LEPUSRuntime *rt = ctx->rt;
  JSThreadState *ts = static_cast<JSThreadState *>(JS_GetRuntimeOpaque(rt));
  if (!ts) return LEPUS_EXCEPTION;
  int32_t timer_id = 0;
  if (LEPUS_ToInt32(ctx, &timer_id, argv[0])) {
    return LEPUS_EXCEPTION;
  }
  JSOSTimer *th = find_timer_by_id(ts, timer_id);
  if (th) free_timer(rt, th);
  return LEPUS_UNDEFINED;
}

static void call_handler_gc(LEPUSContext *ctx, LEPUSValueConst func) {
  LEPUSValue ret, func1;
  /* 'func' might be destroyed when calling itself (if it frees the
     handler), so must take extra care */
  func1 = func;
  HandleScope func_scope(ctx, &func1, HANDLE_TYPE_LEPUS_VALUE);
  ret = LEPUS_Call(ctx, func1, LEPUS_UNDEFINED, 0, NULL);
  if (LEPUS_IsException(ret)) lepus_std_dump_error(ctx);
}

static void call_handler(LEPUSContext *ctx, LEPUSValueConst func) {
  if (LEPUS_IsGCMode(ctx)) {
    return call_handler_gc(ctx, func);
  }
  LEPUSValue ret, func1;
  /* 'func' might be destroyed when calling itself (if it frees the
     handler), so must take extra care */
  func1 = LEPUS_DupValue(ctx, func);
  ret = LEPUS_Call(ctx, func1, LEPUS_UNDEFINED, 0, NULL);
  LEPUS_FreeValue(ctx, func1);
  if (LEPUS_IsException(ret)) lepus_std_dump_error(ctx);
  LEPUS_FreeValue(ctx, ret);
}

static int js_os_poll_gc(LEPUSContext *ctx) {
  int64_t cur_time, delay;
  struct list_head *el;
  LEPUSRuntime *rt = ctx->rt;
  JSThreadState *ts = static_cast<JSThreadState *>(JS_GetRuntimeOpaque(rt));
  if (!ts || list_empty(&ts->os_timers)) return -1; /* no more events */

  cur_time = get_time_ms();
  list_for_each(el, &ts->os_timers) {
    JSOSTimer *th = list_entry(el, JSOSTimer, link);
    delay = th->timeout - cur_time;
    if (delay <= 0) {
      HandleScope block_scope(rt);
      LEPUSValue func;
      /* the timer expired */
      func = th->func;
      block_scope.PushHandle(&func, HANDLE_TYPE_LEPUS_VALUE);
      th->func = LEPUS_UNDEFINED;
      free_timer(rt, th);
      call_handler(ctx, func);
      return 0;
    }
  }
  return 0;
}

static int js_os_poll(LEPUSContext *ctx) {
  if (LEPUS_IsGCMode(ctx)) {
    return js_os_poll_gc(ctx);
  }
  int64_t cur_time, delay;
  struct list_head *el;
  LEPUSRuntime *rt = ctx->rt;
  JSThreadState *ts = static_cast<JSThreadState *>(JS_GetRuntimeOpaque(rt));
  if (!ts || list_empty(&ts->os_timers)) return -1; /* no more events */

  cur_time = get_time_ms();
  list_for_each(el, &ts->os_timers) {
    JSOSTimer *th = list_entry(el, JSOSTimer, link);
    delay = th->timeout - cur_time;
    if (delay <= 0) {
      LEPUSValue func;
      /* the timer expired */
      func = th->func;
      th->func = LEPUS_UNDEFINED;
      free_timer(rt, th);
      call_handler(ctx, func);
      LEPUS_FreeValue(ctx, func);
      return 0;
    }
  }
  return 0;
}

#if defined(_WIN32)
#define OS_PLATFORM "win32"
#elif defined(__APPLE__)
#define OS_PLATFORM "darwin"
#elif defined(EMSCRIPTEN)
#define OS_PLATFORM "lepus"
#else
#define OS_PLATFORM "linux"
#endif

#define OS_FLAG(x) LEPUS_PROP_INT32_DEF(#x, x, LEPUS_PROP_CONFIGURABLE)

static const LEPUSCFunctionListEntry js_os_funcs[] = {
    LEPUS_CFUNC_DEF("setTimeout", 2, js_os_setTimeout),
    LEPUS_CFUNC_DEF("clearTimeout", 1, js_os_clearTimeout),

    /* stat, readlink, opendir, closedir, ... */
};

static int js_os_init(LEPUSContext *ctx, LEPUSModuleDef *m) {
  os_poll_func = js_os_poll;
  return LEPUS_SetModuleExportList(ctx, m, js_os_funcs, countof(js_os_funcs));
}

LEPUSModuleDef *lepus_init_module_os(LEPUSContext *ctx,
                                     const char *module_name) {
  LEPUSModuleDef *m;
  m = LEPUS_NewCModule(ctx, module_name, js_os_init);
  if (!m) return NULL;
  LEPUS_AddModuleExportList(ctx, m, js_os_funcs, countof(js_os_funcs));
  return m;
}

/**********************************************************/
static LEPUSValue js_print_gc(LEPUSContext *ctx, LEPUSValueConst this_val,
                              int argc, LEPUSValueConst *argv) {
  int i;
  const char *str;

  for (i = 0; i < argc; i++) {
    if (i != 0) putchar(' ');
    str = LEPUS_ToCString(ctx, argv[i]);
    if (!str) return LEPUS_EXCEPTION;
    fputs(str, stdout);
  }
  putchar('\n');
  return LEPUS_UNDEFINED;
}

static LEPUSValue js_print(LEPUSContext *ctx, LEPUSValueConst this_val,
                           int argc, LEPUSValueConst *argv) {
  if (LEPUS_IsGCMode(ctx)) {
    return js_print_gc(ctx, this_val, argc, argv);
  }
  int i;
  const char *str;

  for (i = 0; i < argc; i++) {
    if (i != 0) putchar(' ');
    str = LEPUS_ToCString(ctx, argv[i]);
    if (!str) return LEPUS_EXCEPTION;
    fputs(str, stdout);
    LEPUS_FreeCString(ctx, str);
  }
  putchar('\n');
  return LEPUS_UNDEFINED;
}

static void js_std_init_handlers(LEPUSRuntime *rt) {
  JSThreadState *ts = nullptr;
  ts = static_cast<JSThreadState *>(malloc(sizeof(JSThreadState)));
  if (!ts) return;
  ts->next_timer_id = 1;
  init_list_head(&ts->os_timers);
  JS_SetRuntimeOpaque(rt, ts);
  return;
}

void js_std_add_helpers_gc(LEPUSContext *ctx, int argc, char **argv) {
#if LYNX_SIMPLIFY
  LEPUSValue global_obj;
  LEPUSValue console;

  /* XXX: should these global definitions be enumerable? */
  global_obj = LEPUS_GetGlobalObject(ctx);
  HandleScope func_scope(ctx, &global_obj, HANDLE_TYPE_LEPUS_VALUE);

  console = LEPUS_NewObject(ctx);
  func_scope.PushHandle(&console, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyStr(ctx, console, "log",
                       LEPUS_NewCFunction(ctx, js_print, "log", 1));
  LEPUS_SetPropertyStr(ctx, global_obj, "console", console);
  LEPUS_SetPropertyStr(ctx, global_obj, "print",
                       LEPUS_NewCFunction(ctx, js_print, "print", 1));
#endif
  js_std_init_handlers(ctx->rt);
  return;
}
void lepus_std_add_helpers(LEPUSContext *ctx, int argc, char **argv) {
  if (LEPUS_IsGCMode(ctx)) {
    js_std_add_helpers_gc(ctx, argc, argv);
    return;
  }
#if LYNX_SIMPLIFY
  LEPUSValue global_obj;
  LEPUSValue console;

  /* XXX: should these global definitions be enumerable? */
  global_obj = LEPUS_GetGlobalObject(ctx);

  console = LEPUS_NewObject(ctx);
  LEPUS_SetPropertyStr(ctx, console, "log",
                       LEPUS_NewCFunction(ctx, js_print, "log", 1));
  LEPUS_SetPropertyStr(ctx, global_obj, "console", console);
  LEPUS_SetPropertyStr(ctx, global_obj, "print",
                       LEPUS_NewCFunction(ctx, js_print, "print", 1));
  LEPUS_FreeValue(ctx, global_obj);
#endif
  js_std_init_handlers(ctx->rt);
  return;
}

void lepus_std_free_handlers(LEPUSRuntime *rt) {
  struct list_head *el, *el1;
  JSThreadState *ts = static_cast<JSThreadState *>(JS_GetRuntimeOpaque(rt));
  if (!ts) return;
  list_for_each_safe(el, el1, &ts->os_timers) {
    JSOSTimer *th = list_entry(el, JSOSTimer, link);
    free_timer(rt, th);
  }
  free(ts);
  JS_SetRuntimeOpaque(rt, nullptr);
  return;
}

void js_std_dump_error_gc(LEPUSContext *ctx) {
  LEPUSValue exception_val, val;
  [[maybe_unused]] const char *stack;
  BOOL is_error;

  exception_val = LEPUS_GetException(ctx);
  HandleScope func_scope(ctx, &exception_val, HANDLE_TYPE_LEPUS_VALUE);
  is_error = LEPUS_IsError(ctx, exception_val);
  if (!is_error) printf("Throw: ");
  js_print(ctx, LEPUS_NULL, 1, (LEPUSValueConst *)&exception_val);
  if (is_error) {
    val = LEPUS_GetPropertyStr(ctx, exception_val, "stack");
    if (!LEPUS_IsUndefined(val)) {
      func_scope.PushHandle(&val, HANDLE_TYPE_LEPUS_VALUE);
      stack = LEPUS_ToCString(ctx, val);
      printf("%s\n", stack);
    }
  }
}

void lepus_std_dump_error(LEPUSContext *ctx) {
  if (LEPUS_IsGCMode(ctx)) {
    return js_std_dump_error_gc(ctx);
  }
  LEPUSValue exception_val, val;
  const char *stack;
  BOOL is_error;

  exception_val = LEPUS_GetException(ctx);
  is_error = LEPUS_IsError(ctx, exception_val);
  if (!is_error) printf("Throw: ");
  js_print(ctx, LEPUS_NULL, 1, (LEPUSValueConst *)&exception_val);
  if (is_error) {
    val = LEPUS_GetPropertyStr(ctx, exception_val, "stack");
    if (!LEPUS_IsUndefined(val)) {
      stack = LEPUS_ToCString(ctx, val);
      printf("%s\n", stack);
      LEPUS_FreeCString(ctx, stack);
    }
    LEPUS_FreeValue(ctx, val);
  }
  LEPUS_FreeValue(ctx, exception_val);
}

/* main loop which calls the user LEPUS callbacks */
void lepus_std_loop(LEPUSContext *ctx) {
  LEPUSContext *ctx1;
  int err;

  for (;;) {
    /* execute the pending jobs */
    for (;;) {
      err = LEPUS_ExecutePendingJob(LEPUS_GetRuntime(ctx), &ctx1);
      if (err <= 0) {
        if (err < 0) {
          lepus_std_dump_error(ctx1);
        }
        break;
      }
    }

    if (!os_poll_func || os_poll_func(ctx)) break;
  }
}
#if LYNX_SIMPLIFY
void lepus_std_eval_binary(LEPUSContext *ctx, const uint8_t *buf,
                           size_t buf_len, int flags) {
  LEPUSValue val;
  val = LEPUS_EvalBinary(ctx, buf, buf_len, flags);
  if (LEPUS_IsException(val)) {
    lepus_std_dump_error(ctx);
    exit(1);
  }
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, val);
  }
}
#endif
