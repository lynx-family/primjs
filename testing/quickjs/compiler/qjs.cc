/*
 * QuickJS stand alone interpreter
 *
 * Copyright (c) 2017-2021 Fabrice Bellard
 * Copyright (c) 2017-2021 Charlie Gordon
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
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#if defined(__APPLE__)
#include <malloc/malloc.h>
#elif defined(__linux__)
#include <malloc.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/cutils.h"
#include "quickjs/include/quickjs-libc.h"
#ifdef __cplusplus
}
#endif
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

static int eval_file(LEPUSContext *ctx, const char *filename) {
  uint8_t *buf;
  int ret, eval_flags;
  size_t buf_len;

  buf = lepus_load_file(ctx, &buf_len, filename);
  if (!buf) {
    perror(filename);
    exit(1);
  }
  eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  LEPUSValue val =
      LEPUS_Eval(ctx, (const char *)buf, buf_len, filename, eval_flags);

  if (LEPUS_IsException(val)) {
    lepus_std_dump_error(ctx);
    ret = -1;
  } else {
    ret = 0;
  }
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, val);
  }

  free(buf);
  lepus_std_loop(ctx);
  return ret;
}

static LEPUSValue JS_Assert(LEPUSContext *ctx, LEPUSValueConst this_obj,
                            int argc, LEPUSValueConst *argv) {
  int32_t condition = LEPUS_ToBool(ctx, argv[0]);

  if (!condition) {
    char *assert_fail_msg = NULL;
    if (argc > 1) {
      const char *str = LEPUS_ToCString(ctx, argv[1]);
      assert_fail_msg =
          static_cast<char *>(malloc(sizeof(char) * (strlen(str) + 1)));
      strcpy(assert_fail_msg, str);
      if (str) {
        if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, str);
      }
    }
    LEPUS_ThrowInternalError(ctx, "Assertion Failed: %s", assert_fail_msg);
    return LEPUS_EXCEPTION;
  }
  return LEPUS_UNDEFINED;
}

/* load a file as a UTF-8 encoded string */
static LEPUSValue js_std_load_file(LEPUSContext *ctx, LEPUSValueConst this_val,
                                   int argc, LEPUSValueConst *argv) {
  uint8_t *buf;
  const char *filename;
  LEPUSValue ret;
  size_t buf_len;

  filename = LEPUS_ToCString(ctx, argv[0]);
  if (!filename) return LEPUS_EXCEPTION;
  buf = lepus_load_file(ctx, &buf_len, filename);
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, filename);
  if (!buf) return LEPUS_NULL;
  ret = LEPUS_NewStringLen(ctx, (char *)buf, buf_len);
  free(buf);
  return ret;
}

static void JS_AddIntrinsicAssert(LEPUSContext *ctx) {
  LEPUSValue global_obj = LEPUS_GetGlobalObject(ctx);
  LEPUS_SetPropertyStr(ctx, global_obj, "Assert",
                       LEPUS_NewCFunction(ctx, JS_Assert, "Assert", 2));
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, global_obj);
  }
}

static void js_dump_unhandled_rejection(LEPUSContext *ctx) {
  int count = 0;
  while (LEPUS_MoveUnhandledRejectionToException(ctx)) {
    lepus_std_dump_error(ctx);
    count++;
  }
  if (count == 0) return;
  printf("%d unhandled rejection detected\n", count);
}

int main(int argc, char **argv) {
  LEPUSRuntime *rt;
  LEPUSContext *ctx;
  int32_t dump_memory = 0;
  const char *filename;
  if (argc == 1) {
    printf("Input the test file name\n");
    return 0;
  }

  if (argc > 2 && !strcmp(argv[1], "-d")) {  // -d: dump memory
    dump_memory = 1;
  }
  filename = argv[argc - 1];

  rt = LEPUS_NewRuntime();
  if (!rt) {
    fprintf(stderr, "qjs: cannot allocate JS runtime\n");
    exit(2);
  }
  ctx = LEPUS_NewContext(rt);
  if (!ctx) {
    fprintf(stderr, "qjs: cannot allocate JS context\n");
    exit(2);
  }
  lepus_std_add_helpers(ctx, 0, NULL);

  LEPUSValue global_obj = LEPUS_GetGlobalObject(ctx);
  LEPUSValue cfunc = LEPUS_NewCFunction(ctx, js_std_load_file, "read", 1);
  HandleScope func_scope(ctx, &cfunc, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyStr(ctx, global_obj, "read", cfunc);
  cfunc = LEPUS_NewCFunction(
      ctx,
      [](LEPUSContext *ctx, LEPUSValue this_obj, int32_t argc,
         LEPUSValue *argv) {
        LEPUS_RunGC(LEPUS_GetRuntime(ctx));
        return LEPUS_UNDEFINED;
      },
      "", 0);
  LEPUS_SetPropertyStr(ctx, global_obj, "gc", cfunc);
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, global_obj);
  }
  JS_AddIntrinsicAssert(ctx);

  if (eval_file(ctx, filename)) goto fail;
  lepus_std_loop(ctx);
  js_dump_unhandled_rejection(ctx);

  if (dump_memory) {
    LEPUSMemoryUsage stats;
    LEPUS_ComputeMemoryUsage(rt, &stats);
    LEPUS_DumpMemoryUsage(stdout, &stats, rt);
  }

  lepus_std_free_handlers(rt);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
  return 0;
fail:
  js_dump_unhandled_rejection(ctx);
  lepus_std_free_handlers(rt);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
  return 1;
}
