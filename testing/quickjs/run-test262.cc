/*
 * ECMA Test 262 Runner for QuickLEPUS
 *
 * Copyright (c) 2017-2018 Fabrice Bellard
 * Copyright (c) 2017-2018 Charlie Gordon
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
#include <ctype.h>
#if !defined(_WIN32)
#include <dirent.h>
#include <ftw.h>
#include <unistd.h>
#endif
#include <errno.h>
#include <inttypes.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include <cstdio>

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/cutils.h"
#include "quickjs/include/list.h"
#include "quickjs/include/quickjs-libc.h"
#ifdef __cplusplus
}
#endif

#ifdef ENABLE_GC_DEBUG_TOOLS
#include <iostream>
#endif

#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

/* enable test262 thread support to test SharedArrayBuffer and Atomics */
#if !defined(_WIN32)
#define CONFIG_AGENT
#endif
/* cross-realm tests (not supported yet) */
// #define CONFIG_REALM

#define CMD_NAME "run-test262"

#undef printf

#if defined(_WIN32)
#include <stdio.h>
#include <windows.h>

#include <string>
int ftw(const char *dir,
        int (*fcn)(const char *filename, const struct stat *ptr, int flag),
        int nopenfd) {
  WIN32_FIND_DATA data;
  HANDLE hFind;
  std::string path;
  size_t old_dir_len = strlen(dir);
  char *new_dir_name = static_cast<char *>(malloc(old_dir_len + 2 + 1));
  memcpy(new_dir_name, dir, old_dir_len);
  new_dir_name[old_dir_len] = '\\';
  new_dir_name[old_dir_len + 1] = '*';
  new_dir_name[old_dir_len + 2] = '\0';
  if ((hFind = FindFirstFile(new_dir_name, &data)) != INVALID_HANDLE_VALUE) {
    do {
      path = std::string(dir) + "\\" + data.cFileName;
      if (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) {
        if (strcmp(data.cFileName, ".") != 0 &&
            strcmp(data.cFileName, "..") != 0) {
          ftw(path.c_str(), fcn, nopenfd);
        }
      } else {
        fcn(path.c_str(), nullptr, 0);
      }
    } while (FindNextFile(hFind, &data) != 0);
    FindClose(hFind);
  }
  free(new_dir_name);
  return 0;
}
#endif

char *strdup(const char *s1) {
  char *str;
  size_t size = strlen(s1) + 1;

  str = (char *)malloc(size);
  if (str) {
    memcpy(str, s1, size);
  }
  return str;
}
typedef struct namelist_t {
  char **array;
  int count;
  int size;
  unsigned int sorted : 1;
} namelist_t;

namelist_t test_list;
namelist_t exclude_list;
namelist_t exclude_dir_list;

FILE *outfile;
enum test_mode_t {
  TEST_DEFAULT_NOSTRICT, /* run tests as nostrict unless test is flagged as
                            strictonly */
  TEST_DEFAULT_STRICT, /* run tests as strict unless test is flagged as nostrict
                        */
  TEST_NOSTRICT,       /* run tests as nostrict, skip strictonly tests */
  TEST_STRICT,         /* run tests as strict, skip nostrict tests */
  TEST_ALL, /* run tests in both strict and nostrict, unless restricted by spec
             */
} test_mode = TEST_DEFAULT_NOSTRICT;
int skip_async;
int skip_module;
int new_style;
int dump_memory;
int stats_count;
LEPUSMemoryUsage stats_all, stats_avg, stats_min, stats_max;
char *stats_min_filename;
char *stats_max_filename;
int verbose;
char *harness_dir;
char *harness_exclude;
char *harness_features;
char *harness_skip_features;
char *error_filename;
char *error_file;
FILE *error_out;
char *report_filename;
int update_errors;
int test_count, test_failed, test_index, test_skipped, test_excluded;
int new_errors, changed_errors, fixed_errors;
int async_done;

static LEPUSValue js_print(LEPUSContext *ctx, LEPUSValueConst this_val,
                           int argc, LEPUSValueConst *argv) {
  int i;
  const char *str;

  for (i = 0; i < argc; i++) {
    if (i != 0) putchar(' ');
    str = LEPUS_ToCString(ctx, argv[i]);
    if (!str) return LEPUS_EXCEPTION;
    fputs(str, stdout);
    if (!LEPUS_IsGCMode(ctx)) {
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, str);
    }
  }
  putchar('\n');
  return LEPUS_UNDEFINED;
}

#if !defined(_WIN32)
void js_std_dump_error_gc(LEPUSContext *ctx) {
  LEPUSValue exception_val, val;
  const char *stack;
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
  if (!LEPUS_IsGCMode(ctx)) {
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
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, stack);
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, val);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, exception_val);
}

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

void warning(const char *, ...) __attribute__((__format__(__printf__, 1, 2)));
void fatal(int, const char *, ...)
    __attribute__((__format__(__printf__, 2, 3)));

void warning(const char *fmt, ...) {
  va_list ap;

  fflush(stdout);
  fprintf(stderr, "%s: ", CMD_NAME);
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  fputc('\n', stderr);
}

void fatal(int errcode, const char *fmt, ...) {
  va_list ap;

  fflush(stdout);
  fprintf(stderr, "%s: ", CMD_NAME);
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);
  fputc('\n', stderr);

  exit(errcode);
}

void perror_exit(int errcode, const char *s) {
  fflush(stdout);
  fprintf(stderr, "%s: ", CMD_NAME);
  perror(s);
  exit(errcode);
}

char *strdup_len(const char *str, int len) {
  char *p = static_cast<char *>(malloc(len + 1));
  memcpy(p, str, len);
  p[len] = '\0';
  return p;
}

static inline int str_equal(const char *a, const char *b) {
  return !strcmp(a, b);
}

char *str_append(char **pp, const char *sep, const char *str) {
  char *res, *p;
  size_t len = 0;
  p = *pp;
  if (p) {
    len = strlen(p) + strlen(sep);
  }
  res = static_cast<char *>(malloc(len + strlen(str) + 1));
  if (p) {
    strcpy(res, p);
    strcat(res, sep);
  }
  strcpy(res + len, str);
  free(p);
  return *pp = res;
}

char *str_strip(char *p) {
  size_t len = strlen(p);
  while (len > 0 && isspace((unsigned char)p[len - 1])) p[--len] = '\0';
  while (isspace((unsigned char)*p)) p++;
  return p;
}

int has_prefix(const char *str, const char *prefix) {
  return !strncmp(str, prefix, strlen(prefix));
}

char *skip_prefix(const char *str, const char *prefix) {
  int i;
  for (i = 0;; i++) {
    if (prefix[i] == '\0') { /* skip the prefix */
      str += i;
      break;
    }
    if (str[i] != prefix[i]) break;
  }
  return (char *)str;
}

char *skip_until(const char *str, const char *prefix) {
  for (int i = 0; str[i]; ++i) {
    if (has_prefix(str + i, prefix)) return skip_prefix(str + i, prefix);
  }
  return (char *)str;
}

char *get_basename(const char *filename) {
  char *p;
#if defined(_WIN32)
  p = const_cast<char *>(strrchr(filename, '\\'));
#else
  p = const_cast<char *>(strrchr(filename, '/'));
#endif
  if (!p) return NULL;
  return strdup_len(filename, p - filename);
}

char *compose_path(const char *path, const char *name) {
  int path_len, name_len;
  char *d, *q;
#if defined(_WIN32)
  char *win_name = static_cast<char *>(malloc(strlen(name) + 1));
  size_t i = 0;
  for (; name[i] != '\0'; ++i) {
    if (name[i] == '/') {
      win_name[i] = '\\';
    } else {
      win_name[i] = name[i];
    }
  }
  win_name[i] = '\0';
  name = win_name;
#endif
#if defined(_WIN32)
  if (!path || path[0] == '\0' || *name == '\\') {
#else
  if (!path || path[0] == '\0' || *name == '/') {
#endif
    d = strdup(name);
  } else {
    path_len = strlen(path);
    name_len = strlen(name);
    d = static_cast<char *>(malloc(path_len + 1 + name_len + 1));
    if (d) {
      q = d;
      memcpy(q, path, path_len);
      q += path_len;
#if defined(_WIN32)
      if (path[path_len - 1] != '\\') *q++ = '\\';
#else
      if (path[path_len - 1] != '/') *q++ = '/';
#endif
      memcpy(q, name, name_len + 1);
    }
  }
#if defined(_WIN32)
  free(win_name);
#endif
  return d;
}

int namelist_cmp(const char *a, const char *b) {
  /* compare strings in modified lexicographical order */
  for (;;) {
    int ca = (unsigned char)*a++;
    int cb = (unsigned char)*b++;
    if (isdigit(ca) && isdigit(cb)) {
      int na = ca - '0';
      int nb = cb - '0';
      while (isdigit(ca = (unsigned char)*a++)) na = na * 10 + ca - '0';
      while (isdigit(cb = (unsigned char)*b++)) nb = nb * 10 + cb - '0';
      if (na < nb) return -1;
      if (na > nb) return +1;
    }
    if (ca < cb) return -1;
    if (ca > cb) return +1;
    if (ca == '\0') return 0;
  }
}

int namelist_cmp_indirect(const void *a, const void *b) {
  return namelist_cmp(*(const char **)a, *(const char **)b);
}

void namelist_sort(namelist_t *lp) {
  int i, count;
  if (lp->count > 1) {
    qsort(lp->array, lp->count, sizeof(*lp->array), namelist_cmp_indirect);
    /* remove duplicates */
    for (count = i = 1; i < lp->count; i++) {
      if (namelist_cmp(lp->array[count - 1], lp->array[i]) == 0) {
        free(lp->array[i]);
      } else {
        lp->array[count++] = lp->array[i];
      }
    }
    lp->count = count;
  }
  lp->sorted = 1;
}

int namelist_find(namelist_t *lp, const char *name) {
  int a, b, m, cmp;

  if (!lp->sorted) {
    namelist_sort(lp);
  }
  for (a = 0, b = lp->count; a < b;) {
    m = a + (b - a) / 2;
    cmp = namelist_cmp(lp->array[m], name);
    if (cmp < 0)
      a = m + 1;
    else if (cmp > 0)
      b = m;
    else
      return m;
  }
  return -1;
}

void namelist_add(namelist_t *lp, const char *base, const char *name) {
  char *s;

  s = compose_path(base, name);
  if (!s) goto fail;
  if (lp->count == lp->size) {
    size_t newsize = lp->size + (lp->size >> 1) + 4;
    char **a = static_cast<char **>(
        realloc(lp->array, sizeof(lp->array[0]) * newsize));
    if (!a) goto fail;
    lp->array = a;
    lp->size = newsize;
  }
  lp->array[lp->count] = s;
  lp->count++;
  return;
fail:
  fatal(1, "allocation failure\n");
}

void namelist_load(namelist_t *lp, const char *filename) {
  char buf[1024];
  char *base_name;
  FILE *f;

  f = fopen(filename, "rb");
  if (!f) {
    perror_exit(1, filename);
  }
  base_name = get_basename(filename);

  while (fgets(buf, sizeof(buf), f) != NULL) {
    char *p = str_strip(buf);
    if (*p == '#' || *p == ';' || *p == '\0') continue; /* line comment */

    namelist_add(lp, base_name, p);
  }
  free(base_name);
  fclose(f);
}

void namelist_add_from_error_file(namelist_t *lp, const char *file) {
  const char *p, *p0;
  char *pp;

  for (p = file; (p = strstr(p, ".js:")) != NULL; p++) {
    for (p0 = p; p0 > file && p0[-1] != '\n'; p0--) continue;
    pp = strdup_len(p0, p + 3 - p0);
    namelist_add(lp, NULL, pp);
    free(pp);
  }
}

void namelist_free(namelist_t *lp) {
  while (lp->count > 0) {
    free(lp->array[--lp->count]);
  }
  free(lp->array);
  lp->array = NULL;
  lp->size = 0;
}

static int add_test_file(const char *filename, const struct stat *ptr,
                         int flag) {
  namelist_t *lp = &test_list;
  if (has_suffix(filename, ".js") && !has_suffix(filename, "_FIXTURE.js"))
    namelist_add(lp, NULL, filename);
  return 0;
}

/* find js files from the directory tree and sort the list */
static void enumerate_tests(const char *path) {
  namelist_t *lp = &test_list;
  int start = lp->count;
  ftw(path, add_test_file, 100);
  qsort(lp->array + start, lp->count - start, sizeof(*lp->array),
        namelist_cmp_indirect);
}

static LEPUSValue lepus_print(LEPUSContext *ctx, LEPUSValueConst this_val,
                              int argc, LEPUSValueConst *argv) {
  int i;
  const char *str;

  if (outfile) {
    for (i = 0; i < argc; i++) {
      if (i != 0) fputc(' ', outfile);
      str = LEPUS_ToCString(ctx, argv[i]);
      if (!str) return LEPUS_EXCEPTION;
      if (!strcmp(str, "Test262:AsyncTestComplete")) {
        async_done++;
      } else if (strstart(str, "Test262:AsyncTestFailure", NULL)) {
        async_done = 2; /* force an error */
      }
      fputs(str, outfile);
      if (!LEPUS_IsGCMode(ctx)) {
        if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, str);
      }
    }
    fputc('\n', outfile);
  }
  return LEPUS_UNDEFINED;
}

static LEPUSValue js_detachArrayBuffer(LEPUSContext *ctx, LEPUSValue this_val,
                                       int argc, LEPUSValue *argv) {
  LEPUS_DetachArrayBuffer(ctx, argv[0]);
  return LEPUS_UNDEFINED;
}

static LEPUSValue js_evalScript_gc(LEPUSContext *ctx, LEPUSValue this_val,
                                   int argc, LEPUSValue *argv) {
  const char *str;
  size_t len;
  LEPUSValue ret;
  str = LEPUS_ToCStringLen(ctx, &len, argv[0]);
  if (!str) return LEPUS_EXCEPTION;
  HandleScope func_scope(ctx, &str, HANDLE_TYPE_CSTRING);
  ret = LEPUS_Eval(ctx, str, len, "<evalScript>", LEPUS_EVAL_TYPE_GLOBAL);
  return ret;
}

static LEPUSValue js_evalScript(LEPUSContext *ctx, LEPUSValue this_val,
                                int argc, LEPUSValue *argv) {
  if (LEPUS_IsGCMode(ctx)) {
    return js_evalScript_gc(ctx, this_val, argc, argv);
  }
  const char *str;
  size_t len;
  LEPUSValue ret;
  str = LEPUS_ToCStringLen(ctx, &len, argv[0]);
  if (!str) return LEPUS_EXCEPTION;
  ret = LEPUS_Eval(ctx, str, len, "<evalScript>", LEPUS_EVAL_TYPE_GLOBAL);
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, str);
  return ret;
}

#ifdef CONFIG_AGENT

#include <pthread.h>

typedef struct {
  struct list_head link;
  pthread_t tid;
  char *script;
  LEPUSValue broadcast_func;
  BOOL broadcast_pending;
  LEPUSValue broadcast_sab; /* in the main context */
  uint8_t *broadcast_sab_buf;
  size_t broadcast_sab_size;
  int32_t broadcast_val;
} Test262Agent;

typedef struct {
  struct list_head link;
  char *str;
} AgentReport;

static LEPUSValue add_helpers1(LEPUSContext *ctx);
static void add_helpers(LEPUSContext *ctx);

static pthread_mutex_t agent_mutex = PTHREAD_MUTEX_INITIALIZER;
static pthread_cond_t agent_cond = PTHREAD_COND_INITIALIZER;
/* list of Test262Agent.link */
static struct list_head agent_list = LIST_HEAD_INIT(agent_list);

static pthread_mutex_t report_mutex = PTHREAD_MUTEX_INITIALIZER;
/* list of AgentReport.link */
static struct list_head report_list = LIST_HEAD_INIT(report_list);

static void *agent_start(void *arg) {
  Test262Agent *agent = static_cast<Test262Agent *>(arg);
  LEPUSRuntime *rt;
  LEPUSContext *ctx;
  LEPUSValue ret_val;
  int ret;

  rt = LEPUS_NewRuntime();
  if (rt == NULL) {
    fatal(1, "LEPUS_NewRuntime failure");
  }
  ctx = LEPUS_NewContext(rt);
  if (ctx == NULL) {
    LEPUS_FreeRuntime(rt);
    fatal(1, "LEPUS_NewContext failure");
  }
  LEPUS_SetContextOpaque(ctx, agent);
  LEPUS_SetRuntimeInfo(rt, "agent");
  LEPUS_SetCanBlock(rt, TRUE);

  add_helpers(ctx);
  ret_val = LEPUS_Eval(ctx, agent->script, strlen(agent->script),
                       "<evalScript>", LEPUS_EVAL_TYPE_GLOBAL);
  free(agent->script);
  agent->script = NULL;
  if (LEPUS_IsException(ret_val)) lepus_std_dump_error(ctx);
  if (!LEPUS_IsGCMode(ctx)) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret_val);
  }

  for (;;) {
    LEPUSContext *ctx1;
    ret = LEPUS_ExecutePendingJob(LEPUS_GetRuntime(ctx), &ctx1);
    if (ret < 0) {
      lepus_std_dump_error(ctx);
      break;
    } else if (ret == 0) {
      if (LEPUS_IsUndefined(agent->broadcast_func)) {
        break;
      } else {
        if (LEPUS_IsGCMode(ctx)) {
          LEPUSValue args[2];
          HandleScope block_scope(ctx);
          block_scope.PushLEPUSValueArrayHandle(args, 2);

          pthread_mutex_lock(&agent_mutex);
          while (!agent->broadcast_pending) {
            pthread_cond_wait(&agent_cond, &agent_mutex);
          }

          agent->broadcast_pending = FALSE;
          pthread_cond_signal(&agent_cond);

          pthread_mutex_unlock(&agent_mutex);

          args[0] =
              LEPUS_NewArrayBuffer(ctx, agent->broadcast_sab_buf,
                                   agent->broadcast_sab_size, NULL, NULL, TRUE);
          args[1] = LEPUS_NewInt32(ctx, agent->broadcast_val);
          ret_val = LEPUS_Call(ctx, agent->broadcast_func, LEPUS_UNDEFINED, 2,
                               (LEPUSValueConst *)args);
          if (LEPUS_IsException(ret_val)) lepus_std_dump_error(ctx);
          agent->broadcast_func = LEPUS_UNDEFINED;
        } else {
          LEPUSValue args[2];

          pthread_mutex_lock(&agent_mutex);
          while (!agent->broadcast_pending) {
            pthread_cond_wait(&agent_cond, &agent_mutex);
          }

          agent->broadcast_pending = FALSE;
          pthread_cond_signal(&agent_cond);

          pthread_mutex_unlock(&agent_mutex);

          args[0] =
              LEPUS_NewArrayBuffer(ctx, agent->broadcast_sab_buf,
                                   agent->broadcast_sab_size, NULL, NULL, TRUE);
          args[1] = LEPUS_NewInt32(ctx, agent->broadcast_val);
          ret_val = LEPUS_Call(ctx, agent->broadcast_func, LEPUS_UNDEFINED, 2,
                               (LEPUSValueConst *)args);
          if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, args[0]);
          if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, args[1]);
          if (LEPUS_IsException(ret_val)) lepus_std_dump_error(ctx);
          if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret_val);
          if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, agent->broadcast_func);
          agent->broadcast_func = LEPUS_UNDEFINED;
        }
      }
    }
  }
  if (!LEPUS_IsGCMode(ctx)) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, agent->broadcast_func);
  }

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
  return NULL;
}

static LEPUSValue js_agent_start(LEPUSContext *ctx, LEPUSValue this_val,
                                 int argc, LEPUSValue *argv) {
  const char *script;
  Test262Agent *agent;

  if (LEPUS_GetContextOpaque(ctx) != NULL)
    return LEPUS_ThrowTypeError(ctx, "cannot be called inside an agent");

  script = LEPUS_ToCString(ctx, argv[0]);
  if (!script) return LEPUS_EXCEPTION;
  agent = static_cast<Test262Agent *>(malloc(sizeof(*agent)));
  memset(agent, 0, sizeof(*agent));
  agent->broadcast_func = LEPUS_UNDEFINED;
  agent->broadcast_sab = LEPUS_UNDEFINED;
  agent->script = strdup(script);
  if (!LEPUS_IsGCMode(ctx))
    if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, script);
  list_add_tail(&agent->link, &agent_list);
  pthread_create(&agent->tid, NULL, agent_start, agent);
  return LEPUS_UNDEFINED;
}

static void js_agent_free(LEPUSContext *ctx) {
  struct list_head *el, *el1;
  Test262Agent *agent;

  list_for_each_safe(el, el1, &agent_list) {
    agent = list_entry(el, Test262Agent, link);
    pthread_join(agent->tid, NULL);
    if (!LEPUS_IsGCMode(ctx)) {
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, agent->broadcast_sab);
    }
    list_del(&agent->link);
    free(agent);
  }
}

static LEPUSValue js_agent_leaving(LEPUSContext *ctx, LEPUSValue this_val,
                                   int argc, LEPUSValue *argv) {
  Test262Agent *agent =
      static_cast<Test262Agent *>(LEPUS_GetContextOpaque(ctx));
  if (!agent)
    return LEPUS_ThrowTypeError(ctx, "must be called inside an agent");
  /* nothing to do */
  return LEPUS_UNDEFINED;
}

static BOOL is_broadcast_pending(void) {
  struct list_head *el;
  Test262Agent *agent;
  list_for_each(el, &agent_list) {
    agent = list_entry(el, Test262Agent, link);
    if (agent->broadcast_pending) return TRUE;
  }
  return FALSE;
}

static LEPUSValue js_agent_broadcast(LEPUSContext *ctx, LEPUSValue this_val,
                                     int argc, LEPUSValue *argv) {
  LEPUSValueConst sab = argv[0];
  struct list_head *el;
  Test262Agent *agent;
  uint8_t *buf;
  size_t buf_size;
  int32_t val;

  if (LEPUS_GetContextOpaque(ctx) != NULL)
    return LEPUS_ThrowTypeError(ctx, "cannot be called inside an agent");

  buf = LEPUS_GetArrayBuffer(ctx, &buf_size, sab);
  if (!buf) return LEPUS_EXCEPTION;
  if (LEPUS_ToInt32(ctx, &val, argv[1])) return LEPUS_EXCEPTION;

  /* broadcast the values and wait until all agents have started
     calling their callbacks */
  pthread_mutex_lock(&agent_mutex);
  list_for_each(el, &agent_list) {
    agent = list_entry(el, Test262Agent, link);
    agent->broadcast_pending = TRUE;
    /* the shared array buffer is used by the thread, so increment
       its refcount */
    if (LEPUS_IsGCMode(ctx)) {
      agent->broadcast_sab = sab;
    } else {
      agent->broadcast_sab = LEPUS_DupValue(ctx, sab);
    }
    agent->broadcast_sab_buf = buf;
    agent->broadcast_sab_size = buf_size;
    agent->broadcast_val = val;
  }
  pthread_cond_broadcast(&agent_cond);

  while (is_broadcast_pending()) {
    pthread_cond_wait(&agent_cond, &agent_mutex);
  }
  pthread_mutex_unlock(&agent_mutex);
  return LEPUS_UNDEFINED;
}

static LEPUSValue js_agent_receiveBroadcast(LEPUSContext *ctx,
                                            LEPUSValue this_val, int argc,
                                            LEPUSValue *argv) {
  Test262Agent *agent =
      static_cast<Test262Agent *>(LEPUS_GetContextOpaque(ctx));
  if (!agent)
    return LEPUS_ThrowTypeError(ctx, "must be called inside an agent");
  if (!LEPUS_IsFunction(ctx, argv[0]))
    return LEPUS_ThrowTypeError(ctx, "expecting function");
  if (LEPUS_IsGCMode(ctx)) {
    agent->broadcast_func = argv[0];
  } else {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, agent->broadcast_func);
    agent->broadcast_func = LEPUS_DupValue(ctx, argv[0]);
  }
  return LEPUS_UNDEFINED;
}

static LEPUSValue js_agent_sleep(LEPUSContext *ctx, LEPUSValue this_val,
                                 int argc, LEPUSValue *argv) {
  uint32_t duration;
  if (LEPUS_ToUint32(ctx, &duration, argv[0])) return LEPUS_EXCEPTION;
  usleep(duration * 1000);
  return LEPUS_UNDEFINED;
}

static LEPUSValue js_agent_monotonicNow(LEPUSContext *ctx, LEPUSValue this_val,
                                        int argc, LEPUSValue *argv) {
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  return LEPUS_NewInt64(ctx,
                        (uint64_t)ts.tv_sec * 1000 + (ts.tv_nsec / 1000000));
}

static LEPUSValue js_agent_getReport(LEPUSContext *ctx, LEPUSValue this_val,
                                     int argc, LEPUSValue *argv) {
  AgentReport *rep;
  LEPUSValue ret;

  pthread_mutex_lock(&report_mutex);
  if (list_empty(&report_list)) {
    rep = NULL;
  } else {
    rep = list_entry(report_list.next, AgentReport, link);
    list_del(&rep->link);
  }
  pthread_mutex_unlock(&report_mutex);
  if (rep) {
    ret = LEPUS_NewString(ctx, rep->str);
    free(rep->str);
    free(rep);
  } else {
    ret = LEPUS_NULL;
  }
  return ret;
}

static LEPUSValue js_agent_report(LEPUSContext *ctx, LEPUSValue this_val,
                                  int argc, LEPUSValue *argv) {
  const char *str;
  AgentReport *rep;

  str = LEPUS_ToCString(ctx, argv[0]);
  if (!str) return LEPUS_EXCEPTION;
  rep = static_cast<AgentReport *>(malloc(sizeof(*rep)));
  rep->str = strdup(str);
  if (!LEPUS_IsGCMode(ctx))
    if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, str);

  pthread_mutex_lock(&report_mutex);
  list_add_tail(&rep->link, &report_list);
  pthread_mutex_unlock(&report_mutex);
  return LEPUS_UNDEFINED;
}

static const LEPUSCFunctionListEntry js_agent_funcs[] = {
    /* only in main */
    LEPUS_CFUNC_DEF("start", 1, js_agent_start),
    LEPUS_CFUNC_DEF("getReport", 0, js_agent_getReport),
    LEPUS_CFUNC_DEF("broadcast", 2, js_agent_broadcast),
    /* only in agent */
    LEPUS_CFUNC_DEF("report", 1, js_agent_report),
    LEPUS_CFUNC_DEF("leaving", 0, js_agent_leaving),
    LEPUS_CFUNC_DEF("receiveBroadcast", 1, js_agent_receiveBroadcast),
    /* in both */
    LEPUS_CFUNC_DEF("sleep", 1, js_agent_sleep),
    LEPUS_CFUNC_DEF("monotonicNow", 0, js_agent_monotonicNow),
};

static LEPUSValue js_new_agent_gc(LEPUSContext *ctx) {
  LEPUSValue agent;
  agent = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &agent, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyFunctionList(ctx, agent, js_agent_funcs,
                                countof(js_agent_funcs));
  return agent;
}

static LEPUSValue js_new_agent(LEPUSContext *ctx) {
  if (LEPUS_IsGCMode(ctx)) {
    return js_new_agent_gc(ctx);
  }
  LEPUSValue agent;
  agent = LEPUS_NewObject(ctx);
  LEPUS_SetPropertyFunctionList(ctx, agent, js_agent_funcs,
                                countof(js_agent_funcs));
  return agent;
}
#endif

#ifdef CONFIG_REALM
static LEPUSValue js_createRealm(LEPUSContext *ctx, LEPUSValue this_val,
                                 int argc, LEPUSValue *argv) {
  LEPUSContext *ctx1;
  /* XXX: the context is not freed, need a refcount */
  ctx1 = LEPUS_NewContext(LEPUS_GetRuntime(ctx));
  if (!ctx1) return LEPUS_ThrowOutOfMemory(ctx);
  return add_helpers1(ctx1);
}
#endif

static LEPUSValue add_helpers1_gc(LEPUSContext *ctx) {
  LEPUSValue global_obj;
  LEPUSValue obj262;

  global_obj = LEPUS_GetGlobalObject(ctx);

  LEPUSValue cfunc = LEPUS_NewCFunction(ctx, lepus_print, "print", 1);
  HandleScope func_scope(ctx, &cfunc, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyStr(ctx, global_obj, "print", cfunc);

  /* $262 special object used by the tests */
  obj262 = LEPUS_NewObject(ctx);
  func_scope.PushHandle(&obj262, HANDLE_TYPE_LEPUS_VALUE);
  cfunc = LEPUS_NewCFunction(ctx, js_detachArrayBuffer, "detachArrayBuffer", 1);
  LEPUS_SetPropertyStr(ctx, obj262, "detachArrayBuffer", cfunc);
  LEPUS_SetPropertyStr(ctx, obj262, "evalScript",
                       LEPUS_NewCFunction(ctx, js_evalScript, "evalScript", 1));
  cfunc =
      LEPUS_NewCFunction(ctx, lepus_string_codePointRange, "codePointRange", 2);
  LEPUS_SetPropertyStr(ctx, obj262, "codePointRange", cfunc);
  cfunc = LEPUS_NewCFunction(ctx, lepus_gc, "gc", 0);
  LEPUS_SetPropertyStr(ctx, obj262, "gc", cfunc);
#ifdef CONFIG_AGENT
  LEPUSValue agent = js_new_agent(ctx);
  func_scope.PushHandle(&agent, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyStr(ctx, obj262, "agent", agent);
#endif

#ifdef CONFIG_REALM
  LEPUS_SetPropertyStr(ctx, obj262, "global", global_obj);

  LEPUS_SetPropertyStr(
      ctx, obj262, "createRealm",
      LEPUS_NewCFunction(ctx, js_createRealm, "createRealm", 0));
#endif

  LEPUS_SetPropertyStr(ctx, global_obj, "$262", obj262);

  return obj262;
}

static LEPUSValue add_helpers1(LEPUSContext *ctx) {
  if (LEPUS_IsGCMode(ctx)) {
    return add_helpers1_gc(ctx);
  }
  LEPUSValue global_obj;
  LEPUSValue obj262;

  global_obj = LEPUS_GetGlobalObject(ctx);

  LEPUS_SetPropertyStr(ctx, global_obj, "print",
                       LEPUS_NewCFunction(ctx, lepus_print, "print", 1));

  /* $262 special object used by the tests */
  obj262 = LEPUS_NewObject(ctx);
  LEPUS_SetPropertyStr(
      ctx, obj262, "detachArrayBuffer",
      LEPUS_NewCFunction(ctx, js_detachArrayBuffer, "detachArrayBuffer", 1));
  LEPUS_SetPropertyStr(ctx, obj262, "evalScript",
                       LEPUS_NewCFunction(ctx, js_evalScript, "evalScript", 1));
  LEPUS_SetPropertyStr(ctx, obj262, "codePointRange",
                       LEPUS_NewCFunction(ctx, lepus_string_codePointRange,
                                          "codePointRange", 2));
  LEPUS_SetPropertyStr(ctx, obj262, "gc",
                       LEPUS_NewCFunction(ctx, lepus_gc, "gc", 0));
#ifdef CONFIG_AGENT
  LEPUS_SetPropertyStr(ctx, obj262, "agent", js_new_agent(ctx));
#endif

#ifdef CONFIG_REALM
  LEPUS_SetPropertyStr(ctx, obj262, "global", LEPUS_DupValue(global_obj));

  LEPUS_SetPropertyStr(
      ctx, obj262, "createRealm",
      LEPUS_NewCFunction(ctx, js_createRealm, "createRealm", 0));
#endif

  LEPUS_SetPropertyStr(ctx, global_obj, "$262", LEPUS_DupValue(ctx, obj262));

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, global_obj);
  return obj262;
}

static void add_helpers(LEPUSContext *ctx) {
  if (!LEPUS_IsGCMode(ctx)) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, add_helpers1(ctx));
    return;
  }
  add_helpers1(ctx);
}

static char *load_file(const char *filename, size_t *lenp) {
  char *buf;
  size_t buf_len;
  buf = (char *)lepus_load_file(NULL, &buf_len, filename);
  if (!buf) perror_exit(1, filename);
  if (lenp) *lenp = buf_len;
  return buf;
}

static LEPUSModuleDef *js_module_loader_test(LEPUSContext *ctx,
                                             const char *module_name,
                                             void *opaque) {
  size_t buf_len;
  uint8_t *buf;
  LEPUSModuleDef *m;
  LEPUSValue func_val;

  buf = lepus_load_file(ctx, &buf_len, module_name);
  if (!buf) {
    LEPUS_ThrowReferenceError(ctx, "could not load module filename '%s'",
                              module_name);
    return NULL;
  }

  /* compile the module */
  func_val = LEPUS_Eval(ctx, (char *)buf, buf_len, module_name,
                        LEPUS_EVAL_TYPE_MODULE | LEPUS_EVAL_FLAG_COMPILE_ONLY);
  free(buf);
  if (LEPUS_IsException(func_val)) return NULL;
  /* the module is already referenced, so we must free it */
  m = static_cast<LEPUSModuleDef *>(LEPUS_VALUE_GET_PTR(func_val));
  if (!LEPUS_IsGCMode(ctx)) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, func_val);
  }
  return m;
}

int is_line_sep(char c) { return (c == '\0' || c == '\n' || c == '\r'); }

char *find_line(const char *str, const char *line) {
  if (str) {
    const char *p;
    int len = strlen(line);
    for (p = str; (p = strstr(p, line)) != NULL; p += len + 1) {
      if ((p == str || is_line_sep(p[-1])) && is_line_sep(p[len]))
        return (char *)p;
    }
  }
  return NULL;
}

int is_word_sep(char c) {
  return (c == '\0' || isspace((unsigned char)c) || c == ',');
}

char *find_word(const char *str, const char *word) {
  const char *p;
  int len = strlen(word);
  if (str && len) {
    for (p = str; (p = strstr(p, word)) != NULL; p += len) {
      if ((p == str || is_word_sep(p[-1])) && is_word_sep(p[len]))
        return (char *)p;
    }
  }
  return NULL;
}

/* handle exclude directories */
void update_exclude_dirs(void) {
  namelist_t *lp = &test_list;
  namelist_t *ep = &exclude_list;
  namelist_t *dp = &exclude_dir_list;
  char *name;
  int i, j, count;

  /* split directpries from exclude_list */
  for (count = i = 0; i < ep->count; i++) {
    name = ep->array[i];
    if (has_suffix(name, "/")) {
      namelist_add(dp, NULL, name);
      free(name);
    } else {
      ep->array[count++] = name;
    }
  }
  ep->count = count;

  namelist_sort(dp);

  /* filter out excluded directories */
  for (count = i = 0; i < lp->count; i++) {
    name = lp->array[i];
    for (j = 0; j < dp->count; j++) {
      if (has_prefix(name, dp->array[j])) {
        test_excluded++;
        free(name);
        name = NULL;
        break;
      }
    }
    if (name) {
      lp->array[count++] = name;
    }
  }
  lp->count = count;
}

void load_config(const char *filename) {
  char buf[1024];
  FILE *f;
  char *base_name;
  enum {
    SECTION_NONE = 0,
    SECTION_CONFIG,
    SECTION_EXCLUDE,
    SECTION_FEATURES,
    SECTION_TESTS,
  } section = SECTION_NONE;
  int lineno = 0;

  f = fopen(filename, "rb");
  if (!f) {
    perror_exit(1, filename);
  }
  base_name = get_basename(filename);

  while (fgets(buf, sizeof(buf), f) != NULL) {
    char *p, *q;
    lineno++;
    p = str_strip(buf);
    if (*p == '#' || *p == ';' || *p == '\0') continue; /* line comment */

    if (*p == "[]"[0]) {
      /* new section */
      p++;
      p[strcspn(p, "]")] = '\0';
      if (str_equal(p, "config"))
        section = SECTION_CONFIG;
      else if (str_equal(p, "exclude"))
        section = SECTION_EXCLUDE;
      else if (str_equal(p, "features"))
        section = SECTION_FEATURES;
      else if (str_equal(p, "tests"))
        section = SECTION_TESTS;
      else
        section = SECTION_NONE;
      continue;
    }
    q = strchr(p, '=');
    if (q) {
      /* setting: name=value */
      *q++ = '\0';
      q = str_strip(q);
    }
    switch (section) {
      case SECTION_CONFIG:
        if (!q) {
          printf("%s:%d: syntax error\n", filename, lineno);
          continue;
        }
        if (str_equal(p, "style")) {
          new_style = str_equal(q, "new");
          continue;
        }
        if (str_equal(p, "testdir")) {
          char *testdir = compose_path(base_name, q);
          enumerate_tests(testdir);
          free(testdir);
          continue;
        }
        if (str_equal(p, "harnessdir")) {
          harness_dir = compose_path(base_name, q);
          continue;
        }
        if (str_equal(p, "harnessexclude")) {
          str_append(&harness_exclude, " ", q);
          continue;
        }
        if (str_equal(p, "features")) {
          str_append(&harness_features, " ", q);
          continue;
        }
        if (str_equal(p, "skip-features")) {
          str_append(&harness_skip_features, " ", q);
          continue;
        }
        if (str_equal(p, "mode")) {
          if (str_equal(q, "default") || str_equal(q, "default-nostrict"))
            test_mode = TEST_DEFAULT_NOSTRICT;
          else if (str_equal(q, "default-strict"))
            test_mode = TEST_DEFAULT_STRICT;
          else if (str_equal(q, "nostrict"))
            test_mode = TEST_NOSTRICT;
          else if (str_equal(q, "strict"))
            test_mode = TEST_STRICT;
          else if (str_equal(q, "all") || str_equal(q, "both"))
            test_mode = TEST_ALL;
          else
            fatal(2, "unknown test mode: %s", q);
          continue;
        }
        if (str_equal(p, "strict")) {
          if (str_equal(q, "skip") || str_equal(q, "no"))
            test_mode = TEST_NOSTRICT;
          continue;
        }
        if (str_equal(p, "nostrict")) {
          if (str_equal(q, "skip") || str_equal(q, "no"))
            test_mode = TEST_STRICT;
          continue;
        }
        if (str_equal(p, "async")) {
          skip_async = !str_equal(q, "yes");
          continue;
        }
        if (str_equal(p, "module")) {
          skip_module = !str_equal(q, "yes");
          continue;
        }
        if (str_equal(p, "verbose")) {
          verbose = str_equal(q, "yes");
          continue;
        }
        if (str_equal(p, "errorfile")) {
          error_filename = compose_path(base_name, q);
          continue;
        }
        if (str_equal(p, "excludefile")) {
          char *path = compose_path(base_name, q);
          namelist_load(&exclude_list, path);
          free(path);
          continue;
        }
        if (str_equal(p, "reportfile")) {
          report_filename = compose_path(base_name, q);
          continue;
        }
      case SECTION_EXCLUDE:
        namelist_add(&exclude_list, base_name, p);
        break;
      case SECTION_FEATURES:
        if (!q || str_equal(q, "yes"))
          str_append(&harness_features, " ", p);
        else
          str_append(&harness_skip_features, " ", p);
        break;
      case SECTION_TESTS:
        namelist_add(&test_list, base_name, p);
        break;
      default:
        /* ignore settings in other sections */
        break;
    }
  }
  fclose(f);
  free(base_name);
}

char *find_error(const char *filename, int *pline, int is_strict) {
  if (error_file) {
    size_t len = strlen(filename);
    const char *p, *q, *r;
    int line;

    for (p = error_file; (p = strstr(p, filename)) != NULL; p += len) {
      if ((p == error_file || p[-1] == '\n' || p[-1] == '(') && p[len] == ':') {
        q = p + len;
        line = 1;
        if (*q == ':') {
          line = strtol(q + 1, (char **)&q, 10);
          if (*q == ':') q++;
        }
        while (*q == ' ') {
          q++;
        }
        /* check strict mode indicator */
        if (!strstart(q, "strict mode: ", &q) != !is_strict) continue;
        r = q = skip_prefix(q, "unexpected error: ");
        r += strcspn(r, "\n");
        while (r[0] == '\n' && r[1] && strncmp(r + 1, filename, 4)) {
          // just compare filename prefix:'test/'
          r++;
          r += strcspn(r, "\n");
        }
        if (pline) *pline = line;
        return strdup_len(q, r - q);
      }
    }
  }
  return NULL;
}

int skip_comments(const char *str, int line, int *pline) {
  const char *p;
  int c;

  p = str;
  while ((c = (unsigned char)*p++) != '\0') {
    if (isspace(c)) {
      if (c == '\n') line++;
      continue;
    }
    if (c == '/' && *p == '/') {
      while (*++p && *p != '\n') continue;
      continue;
    }
    if (c == '/' && *p == '*') {
      for (p += 1; *p; p++) {
        if (*p == '\n') {
          line++;
          continue;
        }
        if (*p == '*' && p[1] == '/') {
          p += 2;
          break;
        }
      }
      continue;
    }
    break;
  }
  if (pline) *pline = line;

  return p - str;
}

int longest_match(const char *str, const char *find, int pos, int *ppos,
                  int line, int *pline) {
  int len, maxlen;

  maxlen = 0;

  if (*find) {
    const char *p;
    for (p = str + pos; *p; p++) {
      if (*p == *find) {
        for (len = 1; p[len] && p[len] == find[len]; len++) continue;
        if (len > maxlen) {
          maxlen = len;
          if (ppos) *ppos = p - str;
          if (pline) *pline = line;
          if (!find[len]) break;
        }
      }
      if (*p == '\n') line++;
    }
  }
  return maxlen;
}

static int eval_buf_gc(LEPUSContext *ctx, const char *buf, size_t buf_len,
                       const char *filename, int is_test, int is_negative,
                       const char *error_type, FILE *outfile, int eval_flags,
                       int is_async) {
  HandleScope func_scope(LEPUS_GetRuntime(ctx));
  LEPUSValue res_val, exception_val;
  int ret, error_line, pos, pos_line;
  BOOL is_error, has_error_line;
  const char *error_name = NULL;
  func_scope.PushHandle(&error_name, HANDLE_TYPE_CSTRING);

  pos = skip_comments(buf, 1, &pos_line);
  error_line = pos_line;
  has_error_line = FALSE;
  exception_val = LEPUS_UNDEFINED;
  func_scope.PushHandle(&exception_val, HANDLE_TYPE_LEPUS_VALUE);
  error_name = NULL;
  async_done = 0;

  res_val = LEPUS_Eval(ctx, buf, buf_len, filename, eval_flags);
  func_scope.PushHandle(&res_val, HANDLE_TYPE_LEPUS_VALUE);

  if (is_async && !LEPUS_IsException(res_val)) {
    for (;;) {
      LEPUSContext *ctx1;
      ret = LEPUS_ExecutePendingJob(LEPUS_GetRuntime(ctx), &ctx1);
      if (ret < 0) {
        res_val = LEPUS_EXCEPTION;
        break;
      } else if (ret == 0) {
        /* test if the test called $DONE() */
        if (async_done != 1) {
          res_val = LEPUS_ThrowTypeError(ctx, "$DONE() not called");
        } else {
          res_val = LEPUS_UNDEFINED;
        }
        break;
      }
    }
  }

  filename = skip_until(filename, "test262/");

  if (LEPUS_IsException(res_val)) {
    exception_val = LEPUS_GetException(ctx);
    is_error = LEPUS_IsError(ctx, exception_val);
    /* XXX: should get the filename and line number */
    if (outfile) {
      if (!is_error)
        fprintf(outfile, "%sThrow: ",
                (eval_flags & LEPUS_EVAL_FLAG_STRICT) ? "strict mode: " : "");
      lepus_print(ctx, LEPUS_NULL, 1, &exception_val);
    }
    if (is_error) {
      HandleScope block_scope(LEPUS_GetRuntime(ctx));
      LEPUSValue name, stack;
      const char *stack_str;

      name = LEPUS_GetPropertyStr(ctx, exception_val, "name");
      block_scope.PushHandle(&name, HANDLE_TYPE_LEPUS_VALUE);
      error_name = LEPUS_ToCString(ctx, name);
      stack = LEPUS_GetPropertyStr(ctx, exception_val, "stack");
      block_scope.PushHandle(&stack, HANDLE_TYPE_LEPUS_VALUE);
      if (!LEPUS_IsUndefined(stack)) {
        stack_str = LEPUS_ToCString(ctx, stack);
        block_scope.PushHandle(&stack_str, HANDLE_TYPE_CSTRING);
        if (stack_str) {
          const char *p;
          int len;

          if (outfile) fprintf(outfile, "%s", stack_str);

          len = strlen(filename);
          p = strstr(stack_str, filename);
          if (p != NULL && p[len] == ':') {
            error_line = atoi(p + len + 1);
            has_error_line = TRUE;
          }
        }
      }
    }
    if (is_negative) {
      ret = 0;
      if (error_type) {
        HandleScope block_scope(LEPUS_GetRuntime(ctx));
        char *error_class;
        const char *msg;

        msg = LEPUS_ToCString(ctx, exception_val);
        block_scope.PushHandle(&msg, HANDLE_TYPE_CSTRING);
        error_class = strdup_len(msg, strcspn(msg, ":"));
        if (!str_equal(error_class, error_type)) ret = -1;
        free(error_class);
      }
    } else {
      ret = -1;
    }
  } else {
    if (is_negative)
      ret = -1;
    else
      ret = 0;
  }

  if (verbose && is_test) {
    HandleScope block_scope(LEPUS_GetRuntime(ctx));
    LEPUSValue msg_val = LEPUS_UNDEFINED;
    block_scope.PushHandle(&msg_val, HANDLE_TYPE_LEPUS_VALUE);
    const char *msg = NULL;
    block_scope.PushHandle(&msg, HANDLE_TYPE_CSTRING);
    int s_line;
    char *s =
        find_error(filename, &s_line, eval_flags & LEPUS_EVAL_FLAG_STRICT);
    const char *strict_mode =
        (eval_flags & LEPUS_EVAL_FLAG_STRICT) ? "strict mode: " : "";

    if (!LEPUS_IsUndefined(exception_val)) {
      msg_val = LEPUS_ToString(ctx, exception_val);
      msg = LEPUS_ToCString(ctx, msg_val);
    }
    if (is_negative) {  // expect error
      if (ret == 0) {
        if (msg && s &&
            (str_equal(s, "expected error") ||
             strstart(s, "unexpected error type:", NULL) ||
             str_equal(s, msg))) {  // did not have error yet
          if (!has_error_line) {
            longest_match(buf, msg, pos, &pos, pos_line, &error_line);
          }
          printf("%s:%d: %sOK, now has error %s\n", filename, error_line,
                 strict_mode, msg);
          fixed_errors++;
          fprintf(stderr, "%s:%d: %sOK, now has error %s\n", filename,
                  error_line, strict_mode, msg);
        }
      } else {
        if (!s) {  // not yet reported
          if (msg) {
            fprintf(error_out, "%s:%d: %sunexpected error type: %s\n", filename,
                    error_line, strict_mode, msg);
            fprintf(stderr, "%s:%d: %sunexpected error type: %s\n", filename,
                    error_line, strict_mode, msg);
          } else {
            fprintf(error_out, "%s:%d: %sexpected error\n", filename,
                    error_line, strict_mode);
            fprintf(stderr, "%s:%d: %sexpected error\n", filename, error_line,
                    strict_mode);
          }
          new_errors++;
        }
      }
    } else {  // should not have error
      if (msg) {
        if (!s || !str_equal(s, msg)) {
          if (!has_error_line) {
            char *p = skip_prefix(msg, "Test262 Error: ");
            if (strstr(p, "Test case returned non-true value!")) {
              longest_match(buf, "runTestCase", pos, &pos, pos_line,
                            &error_line);
            } else {
              longest_match(buf, p, pos, &pos, pos_line, &error_line);
            }
          }
          fprintf(error_out, "%s:%d: %s%s%s\n", filename, error_line,
                  strict_mode, error_file ? "unexpected error: " : "", msg);

          if (s && (!str_equal(s, msg) || error_line != s_line)) {
            printf("%s:%d: %sprevious error: %s\n", filename, s_line,
                   strict_mode, s);
            changed_errors++;
          } else {
            new_errors++;
            fprintf(stderr, "%s:%d: %s%s%s\n", filename, error_line,
                    strict_mode, error_file ? "unexpected error: " : "", msg);
          }
        }
      } else {
        if (s) {
          printf("%s:%d: %sOK, fixed error: %s\n", filename, s_line,
                 strict_mode, s);
          fixed_errors++;
          fprintf(stderr, "%s:%d: %sOK, fixed error: %s\n", filename, s_line,
                  strict_mode, s);
        }
      }
    }
    free(s);
  }
  return ret;
}

static int eval_buf(LEPUSContext *ctx, const char *buf, size_t buf_len,
                    const char *filename, int is_test, int is_negative,
                    const char *error_type, FILE *outfile, int eval_flags,
                    int is_async) {
  if (LEPUS_IsGCMode(ctx)) {
    return eval_buf_gc(ctx, buf, buf_len, filename, is_test, is_negative,
                       error_type, outfile, eval_flags, is_async);
  }
  LEPUSValue res_val, exception_val;
  int ret, error_line, pos, pos_line;
  BOOL is_error, has_error_line;
  const char *error_name = NULL;

  pos = skip_comments(buf, 1, &pos_line);
  error_line = pos_line;
  has_error_line = FALSE;
  exception_val = LEPUS_UNDEFINED;
  error_name = NULL;
  async_done = 0;

  res_val = LEPUS_Eval(ctx, buf, buf_len, filename, eval_flags);

  if (is_async && !LEPUS_IsException(res_val)) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, res_val);
    for (;;) {
      LEPUSContext *ctx1;
      ret = LEPUS_ExecutePendingJob(LEPUS_GetRuntime(ctx), &ctx1);
      if (ret < 0) {
        res_val = LEPUS_EXCEPTION;
        break;
      } else if (ret == 0) {
        /* test if the test called $DONE() */
        if (async_done != 1) {
          res_val = LEPUS_ThrowTypeError(ctx, "$DONE() not called");
        } else {
          res_val = LEPUS_UNDEFINED;
        }
        break;
      }
    }
  }

  filename = skip_until(filename, "test262/");

  if (LEPUS_IsException(res_val)) {
    exception_val = LEPUS_GetException(ctx);
    is_error = LEPUS_IsError(ctx, exception_val);
    /* XXX: should get the filename and line number */
    if (outfile) {
      if (!is_error)
        fprintf(outfile, "%sThrow: ",
                (eval_flags & LEPUS_EVAL_FLAG_STRICT) ? "strict mode: " : "");
      lepus_print(ctx, LEPUS_NULL, 1, &exception_val);
    }
    if (is_error) {
      LEPUSValue name, stack;
      const char *stack_str;

      name = LEPUS_GetPropertyStr(ctx, exception_val, "name");
      error_name = LEPUS_ToCString(ctx, name);
      stack = LEPUS_GetPropertyStr(ctx, exception_val, "stack");
      if (!LEPUS_IsUndefined(stack)) {
        stack_str = LEPUS_ToCString(ctx, stack);
        if (stack_str) {
          const char *p;
          int len;

          if (outfile) fprintf(outfile, "%s", stack_str);

          len = strlen(filename);
          p = strstr(stack_str, filename);
          if (p != NULL && p[len] == ':') {
            error_line = atoi(p + len + 1);
            has_error_line = TRUE;
          }
          if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, stack_str);
        }
      }
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, stack);
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, name);
    }
    if (is_negative) {
      ret = 0;
      if (error_type) {
        char *error_class;
        const char *msg;

        msg = LEPUS_ToCString(ctx, exception_val);
        error_class = strdup_len(msg, strcspn(msg, ":"));
        if (!str_equal(error_class, error_type)) ret = -1;
        free(error_class);
        if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, msg);
      }
    } else {
      ret = -1;
    }
  } else {
    if (is_negative)
      ret = -1;
    else
      ret = 0;
  }

  if (verbose && is_test) {
    LEPUSValue msg_val = LEPUS_UNDEFINED;
    const char *msg = NULL;
    int s_line;
    char *s =
        find_error(filename, &s_line, eval_flags & LEPUS_EVAL_FLAG_STRICT);
    const char *strict_mode =
        (eval_flags & LEPUS_EVAL_FLAG_STRICT) ? "strict mode: " : "";

    if (!LEPUS_IsUndefined(exception_val)) {
      msg_val = LEPUS_ToString(ctx, exception_val);
      msg = LEPUS_ToCString(ctx, msg_val);
    }
    if (is_negative) {  // expect error
      if (ret == 0) {
        if (msg && s &&
            (str_equal(s, "expected error") ||
             strstart(s, "unexpected error type:", NULL) ||
             str_equal(s, msg))) {  // did not have error yet
          if (!has_error_line) {
            longest_match(buf, msg, pos, &pos, pos_line, &error_line);
          }
          printf("%s:%d: %sOK, now has error %s\n", filename, error_line,
                 strict_mode, msg);
          fixed_errors++;
          fprintf(stderr, "%s:%d: %sOK, now has error %s\n", filename,
                  error_line, strict_mode, msg);
        }
      } else {
        if (!s) {  // not yet reported
          if (msg) {
            fprintf(error_out, "%s:%d: %sunexpected error type: %s\n", filename,
                    error_line, strict_mode, msg);
            fprintf(stderr, "%s:%d: %sunexpected error type: %s\n", filename,
                    error_line, strict_mode, msg);
          } else {
            fprintf(error_out, "%s:%d: %sexpected error\n", filename,
                    error_line, strict_mode);
            fprintf(stderr, "%s:%d: %sexpected error\n", filename, error_line,
                    strict_mode);
          }
          new_errors++;
        }
      }
    } else {  // should not have error
      if (msg) {
        if (!s || !str_equal(s, msg)) {
          if (!has_error_line) {
            char *p = skip_prefix(msg, "Test262 Error: ");
            if (strstr(p, "Test case returned non-true value!")) {
              longest_match(buf, "runTestCase", pos, &pos, pos_line,
                            &error_line);
            } else {
              longest_match(buf, p, pos, &pos, pos_line, &error_line);
            }
          }
          fprintf(error_out, "%s:%d: %s%s%s\n", filename, error_line,
                  strict_mode, error_file ? "unexpected error: " : "", msg);

          if (s && (!str_equal(s, msg) || error_line != s_line)) {
            printf("%s:%d: %sprevious error: %s\n", filename, s_line,
                   strict_mode, s);
            changed_errors++;
          } else {
            new_errors++;
            fprintf(stderr, "%s:%d: %s%s%s\n", filename, error_line,
                    strict_mode, error_file ? "unexpected error: " : "", msg);
          }
        }
      } else {
        if (s) {
          printf("%s:%d: %sOK, fixed error: %s\n", filename, s_line,
                 strict_mode, s);
          fixed_errors++;
          fprintf(stderr, "%s:%d: %sOK, fixed error: %s\n", filename, s_line,
                  strict_mode, s);
        }
      }
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, msg_val);
    if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, msg);
    free(s);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, error_name);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, exception_val);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, res_val);
  return ret;
}

static int eval_file(LEPUSContext *ctx, const char *base, const char *p,
                     int eval_flags) {
  char *buf;
  size_t buf_len;
  char *filename = compose_path(base, p);

  buf = load_file(filename, &buf_len);
  if (!buf) {
    warning("cannot load %s", filename);
    goto fail;
  }
  if (eval_buf(ctx, buf, buf_len, filename, FALSE, FALSE, NULL, stderr,
               eval_flags, FALSE)) {
    warning("error evaluating %s", filename);
    goto fail;
  }
  free(buf);
  free(filename);
  return 0;

fail:
  free(buf);
  free(filename);
  return 1;
}

char *extract_desc(const char *buf, char style) {
  const char *p, *desc_start;
  char *desc;
  int len;

  p = buf;
  while (*p != '\0') {
    if (p[0] == '/' && p[1] == '*' && p[2] == style && p[3] != '/') {
      p += 3;
      desc_start = p;
      while (*p != '\0' && (p[0] != '*' || p[1] != '/')) p++;
      if (*p == '\0') {
        warning("Expecting end of desc comment");
        return NULL;
      }
      len = p - desc_start;
      desc = static_cast<char *>(malloc(len + 1));
      memcpy(desc, desc_start, len);
      desc[len] = '\0';
      return desc;
    } else {
      p++;
    }
  }
  return NULL;
}

static char *find_tag(char *desc, const char *tag, int *state) {
  char *p;
  p = strstr(desc, tag);
  if (p) {
    p += strlen(tag);
    *state = 0;
  }
  return p;
}

static char *get_option(char **pp, int *state) {
  char *p, *p0, *option = NULL;
  if (*pp) {
    for (p = *pp;; p++) {
      switch (*p) {
        case '[':
          *state += 1;
          continue;
        case ']':
          *state -= 1;
          if (*state > 0) continue;
          p = NULL;
          break;
        case ' ':
        case '\t':
        case '\r':
        case ',':
        case '-':
          continue;
        case '\n':
          if (*state > 0 || p[1] == ' ') continue;
          p = NULL;
          break;
        case '\0':
          p = NULL;
          break;
        default:
          p0 = p;
          p += strcspn(p0, " \t\r\n,]");
          option = strdup_len(p0, p - p0);
          break;
      }
      break;
    }
    *pp = p;
  }
  return option;
}

void update_stats(LEPUSRuntime *rt, const char *filename) {
  LEPUSMemoryUsage stats;
  LEPUS_ComputeMemoryUsage(rt, &stats);
  if (stats_count++ == 0) {
    stats_avg = stats_all = stats_min = stats_max = stats;
    stats_min_filename = strdup(filename);
    stats_max_filename = strdup(filename);
  } else {
    if (stats_max.malloc_size < stats.malloc_size) {
      stats_max = stats;
      free(stats_max_filename);
      stats_max_filename = strdup(filename);
    }
    if (stats_min.malloc_size > stats.malloc_size) {
      stats_min = stats;
      free(stats_min_filename);
      stats_min_filename = strdup(filename);
    }

#define update(f) stats_avg.f = (stats_all.f += stats.f) / stats_count
    update(malloc_count);
    update(malloc_size);
    update(memory_used_count);
    update(memory_used_size);
    update(atom_count);
    update(atom_size);
    update(str_count);
    update(str_size);
    update(obj_count);
    update(obj_size);
    update(prop_count);
    update(prop_size);
    update(shape_count);
    update(shape_size);
    update(lepus_func_count);
    update(lepus_func_size);
    update(lepus_func_code_size);
    update(lepus_func_pc2line_count);
    update(lepus_func_pc2line_size);
    update(c_func_count);
    update(array_count);
    update(fast_array_count);
    update(fast_array_elements);
  }
#undef update
}

int run_test_buf(const char *filename, char *harness, namelist_t *ip, char *buf,
                 size_t buf_len, const char *error_type, int eval_flags,
                 BOOL is_negative, BOOL is_async, BOOL can_block) {
  LEPUSRuntime *rt;
  LEPUSContext *ctx;
  int i, ret;

  rt = LEPUS_NewRuntime();
  if (rt == NULL) {
    fatal(1, "LEPUS_NewRuntime failure");
  }
  ctx = LEPUS_NewContext(rt);
  if (ctx == NULL) {
    LEPUS_FreeRuntime(rt);
    fatal(1, "LEPUS_NewContext failure");
  }
  LEPUS_SetRuntimeInfo(rt, filename);

  LEPUS_SetCanBlock(rt, can_block);

  /* loader for ES6 modules */
  LEPUS_SetModuleLoaderFunc(rt, NULL, js_module_loader_test, NULL);

  add_helpers(ctx);

  /* add backtrace if the isError property is present in a thrown
     object */
  LEPUS_EnableIsErrorProperty(ctx, TRUE);

  /* a few tests use it, probably a bug in the tests */
  {
    LEPUSValue global_obj = LEPUS_GetGlobalObject(ctx);
    LEPUS_DefinePropertyValueStr(ctx, global_obj, "global", global_obj,
                                 LEPUS_PROP_WRITABLE | LEPUS_PROP_CONFIGURABLE);
  }

  for (i = 0; i < ip->count; i++) {
    if (eval_file(ctx, harness, ip->array[i],
                  LEPUS_EVAL_TYPE_GLOBAL | LEPUS_EVAL_FLAG_STRIP)) {
      fatal(1, "error including %s for %s", ip->array[i], filename);
    }
  }

  ret = eval_buf(ctx, buf, buf_len, filename, TRUE, is_negative, error_type,
                 outfile, eval_flags, is_async);
  ret = (ret != 0);

  if (dump_memory) {
    update_stats(rt, filename);
  }
#ifdef CONFIG_AGENT
  js_agent_free(ctx);
#endif
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);

  test_count++;
  if (ret) {
    test_failed++;
    if (outfile) {
      /* do not output a failure number to minimize diff */
      fprintf(outfile, "  FAILED\n");
    }
  }
  return ret;
}

int run_test(const char *filename, int index) {
  char harnessbuf[1024];
  char *harness;
  char *buf;
  size_t buf_len;
  char *desc, *p;
  char *error_type;
  int ret, eval_flags, use_strict, use_nostrict;
  BOOL is_negative, is_nostrict, is_onlystrict, is_async, is_module, skip;
  BOOL can_block;
  namelist_t include_list = {0}, *ip = &include_list;

  is_nostrict = is_onlystrict = is_negative = is_async = is_module = skip =
      FALSE;
  can_block = TRUE;
  error_type = NULL;
  buf = load_file(filename, &buf_len);

  harness = harness_dir;

  if (new_style) {
    if (!harness) {
      p = const_cast<char *>(strstr(filename, "test/"));
      if (p) {
        snprintf(harnessbuf, sizeof(harnessbuf), "%.*s%s", (int)(p - filename),
                 filename, "harness");
      }
      harness = harnessbuf;
    }
    namelist_add(ip, NULL, "sta.js");
    namelist_add(ip, NULL, "assert.js");
    /* extract the YAML frontmatter */
    desc = extract_desc(buf, '-');
    if (desc) {
      char *ifile, *option;
      int state;
      p = find_tag(desc, "includes:", &state);
      if (p) {
        while ((ifile = get_option(&p, &state)) != NULL) {
          // skip unsupported harness files
          if (find_word(harness_exclude, ifile)) {
            skip |= 1;
          } else {
            namelist_add(ip, NULL, ifile);
          }
          free(ifile);
        }
      }
      p = find_tag(desc, "flags:", &state);
      if (p) {
        while ((option = get_option(&p, &state)) != NULL) {
          if (str_equal(option, "noStrict")) {
            is_nostrict = TRUE;
            skip |= (test_mode == TEST_STRICT);
          } else if (str_equal(option, "onlyStrict")) {
            is_onlystrict = TRUE;
            skip |= (test_mode == TEST_NOSTRICT);
          } else if (str_equal(option, "async")) {
            is_async = TRUE;
            skip |= skip_async;
          } else if (str_equal(option, "module")) {
            is_module = TRUE;
            skip |= skip_module;
          } else if (str_equal(option, "CanBlockIsFalse")) {
            can_block = FALSE;
          }
          free(option);
        }
      }
      p = find_tag(desc, "negative:", &state);
      if (p) {
        /* XXX: should extract the phase */
        char *q = find_tag(p, "type:", &state);
        if (q) {
          while (isspace(*q)) q++;
          error_type = strdup_len(q, strcspn(q, " \n"));
        }
        is_negative = TRUE;
      }
      p = find_tag(desc, "features:", &state);
      if (p) {
        while ((option = get_option(&p, &state)) != NULL) {
          if (find_word(harness_features, option)) {
            /* feature is enabled */
          } else if (find_word(harness_skip_features, option)) {
            /* skip disabled feature */
            skip |= 1;
          } else {
            /* feature is not listed: skip and warn */
            printf("%s:%d: unknown feature: %s\n", filename, 1, option);
            skip |= 1;
          }
          free(option);
        }
      }
      free(desc);
    }
    if (is_async) namelist_add(ip, NULL, "doneprintHandle.js");
  } else {
    char *ifile;

    if (!harness) {
      p = const_cast<char *>(strstr(filename, "test/"));
      if (p) {
        snprintf(harnessbuf, sizeof(harnessbuf), "%.*s%s", (int)(p - filename),
                 filename, "test/harness");
      }
      harness = harnessbuf;
    }

    namelist_add(ip, NULL, "sta.js");

    /* include extra harness files */
    for (p = buf; (p = strstr(p, "$INCLUDE(\"")) != NULL; p++) {
      p += 10;
      ifile = strdup_len(p, strcspn(p, "\""));
      // skip unsupported harness files
      if (find_word(harness_exclude, ifile)) {
        skip |= 1;
      } else {
        namelist_add(ip, NULL, ifile);
      }
      free(ifile);
    }

    /* locate the old style configuration comment */
    desc = extract_desc(buf, '*');
    if (desc) {
      if (strstr(desc, "@noStrict")) {
        is_nostrict = TRUE;
        skip |= (test_mode == TEST_STRICT);
      }
      if (strstr(desc, "@onlyStrict")) {
        is_onlystrict = TRUE;
        skip |= (test_mode == TEST_NOSTRICT);
      }
      if (strstr(desc, "@negative")) {
        /* XXX: should extract the regex to check error type */
        is_negative = TRUE;
      }
      free(desc);
    }
  }

  if (outfile && index >= 0) {
    fprintf(outfile, "%d: %s%s%s%s%s%s%s\n", index, filename,
            is_nostrict ? "  @noStrict" : "",
            is_onlystrict ? "  @onlyStrict" : "", is_async ? "  async" : "",
            is_module ? "  module" : "", is_negative ? "  @negative" : "",
            skip ? "  SKIPPED" : "");
    fflush(outfile);
  }

  use_strict = use_nostrict = 0;
  switch (test_mode) {
    case TEST_DEFAULT_NOSTRICT:
      if (is_onlystrict)
        use_strict = 1;
      else
        use_nostrict = 1;
      break;
    case TEST_DEFAULT_STRICT:
      if (is_nostrict)
        use_nostrict = 1;
      else
        use_strict = 1;
      break;
    case TEST_NOSTRICT:
      if (!is_onlystrict) use_nostrict = 1;
      break;
    case TEST_STRICT:
      if (!is_nostrict) use_strict = 1;
      break;
    case TEST_ALL:
      if (!is_nostrict) use_strict = 1;
      if (!is_onlystrict) use_nostrict = 1;
      break;
  }

  if (skip || use_strict + use_nostrict == 0) {
    test_skipped++;
    ret = -2;
  } else {
    clock_t clocks;

    if (is_module) {
      eval_flags = LEPUS_EVAL_TYPE_MODULE;
    } else {
      eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
    }
    clocks = clock();
    ret = 0;
    if (use_nostrict) {
      ret = run_test_buf(filename, harness, ip, buf, buf_len, error_type,
                         eval_flags, is_negative, is_async, can_block);
    }
    if (use_strict) {
      ret |= run_test_buf(filename, harness, ip, buf, buf_len, error_type,
                          eval_flags | LEPUS_EVAL_FLAG_STRICT, is_negative,
                          is_async, can_block);
    }
    clocks = clock() - clocks;
    if (outfile && index >= 0 && clocks >= CLOCKS_PER_SEC / 10) {
      /* output timings for tests that take more than 100 ms */
      fprintf(outfile, " time: %d ms\n",
              (int)(clocks * 1000LL / CLOCKS_PER_SEC));
    }
  }
  namelist_free(&include_list);
  free(error_type);
  free(buf);

  return ret;
}

clock_t last_clock;

void show_progress(int force) {
  clock_t t = clock();
  if (force || !last_clock || (t - last_clock) > CLOCKS_PER_SEC / 20) {
    last_clock = t;
    /* output progress indicator: erase end of line and return to col 0 */
    fprintf(stdout, "%d/%d/%d\033[K\r", test_failed, test_count, test_skipped);
    fflush(stdout);
  }
}

void run_test_dir_list(namelist_t *lp, int start_index, int stop_index) {
  int i;

  namelist_sort(lp);
  for (i = 0; i < lp->count; i++) {
    const char *p = lp->array[i];
    if (namelist_find(&exclude_list, p) >= 0) {
      test_excluded++;
    } else if (test_index < start_index) {
      test_skipped++;
    } else if (stop_index >= 0 && test_index > stop_index) {
      test_skipped++;
    } else {
#ifdef ENABLE_GC_DEBUG_TOOLS
      std::cout << "trace_gc, index: " << i << " total: " << lp->count
                << " file: " << p << std::endl;
#endif
      run_test(p, test_index);
      show_progress(FALSE);
    }
    test_index++;
  }
  show_progress(TRUE);
}

void help(void) {
  printf(
      "usage: run-test262 [options] {-f file ... | [dir_list] [index range]}\n"
      "-h             help\n"
      "-a             run tests in strict and nostrict modes\n"
      "-m             print memory usage summary\n"
      "-n             use new style harness\n"
      "-s             run tests in strict mode, skip @nostrict tests\n"
      "-u             update error file\n"
      "-v             verbose: output error messages\n"
      "-c file        read configuration from 'file'\n"
      "-d dir         run all test files in directory tree 'dir'\n"
      "-e file        load the known errors from 'file'\n"
      "-f file        execute single test from 'file'\n"
      "-r file        set the report file name (default=none)\n"
      "-x file        exclude tests listed in 'file'\n");
  exit(1);
}

char *get_opt_arg(const char *option, char *arg) {
  if (!arg) {
    fatal(2, "missing argument for option %s", option);
  }
  return arg;
}

/* run a test when called by test262-harness+eshost */
int run_test262_harness_test(const char *filename, BOOL is_module) {
  LEPUSRuntime *rt;
  LEPUSContext *ctx;
  char *buf;
  size_t buf_len;
  int eval_flags, ret_code, ret;
  LEPUSValue res_val;
  BOOL can_block;

  outfile = stdout; /* for js_print */

  rt = LEPUS_NewRuntime();
  if (rt == NULL) {
    fatal(1, "JS_NewRuntime failure");
  }
  ctx = LEPUS_NewContext(rt);
  if (ctx == NULL) {
    LEPUS_FreeRuntime(rt);
    fatal(1, "JS_NewContext failure");
  }
  LEPUS_SetRuntimeInfo(rt, filename);

  can_block = TRUE;
  LEPUS_SetCanBlock(rt, can_block);

  /* loader for ES6 modules */
  LEPUS_SetModuleLoaderFunc(rt, NULL, js_module_loader_test, NULL);

  add_helpers(ctx);

  buf = load_file(filename, &buf_len);

  if (is_module) {
    eval_flags = LEPUS_EVAL_TYPE_MODULE;
  } else {
    eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  }
  res_val = LEPUS_Eval(ctx, buf, buf_len, filename, eval_flags);
  ret_code = 0;
  if (LEPUS_IsException(res_val)) {
    lepus_std_dump_error(ctx);
    ret_code = 1;
  } else {
    if (!LEPUS_IsGCMode(ctx)) {
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, res_val);
    }
    for (;;) {
      LEPUSContext *ctx1;
      ret = LEPUS_ExecutePendingJob(LEPUS_GetRuntime(ctx), &ctx1);
      if (ret < 0) {
        lepus_std_dump_error(ctx1);
        ret_code = 1;
      } else if (ret == 0) {
        break;
      }
    }
  }
  free(buf);
#ifdef CONFIG_AGENT
  js_agent_free(ctx);
#endif
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
  return ret_code;
}

int main(int argc, char **argv) {
  int optind, start_index, stop_index;
  BOOL is_dir_list;
  BOOL only_check_errors = FALSE;
  BOOL is_test262_harness = FALSE;
  BOOL is_module = FALSE;
  const char *filename;

#if !defined(_WIN32)
  /* Date tests assume California local time */
  setenv("TZ", "America/Los_Angeles", 1);
#endif

  /* cannot use getopt because we want to pass the command line to
     the script */
  optind = 1;
  is_dir_list = TRUE;
  while (optind < argc) {
    char *arg = argv[optind];
    if (*arg != '-') break;
    optind++;
    if (str_equal(arg, "-h")) {
      help();
    } else if (str_equal(arg, "-m")) {
      dump_memory++;
    } else if (str_equal(arg, "-n")) {
      new_style++;
    } else if (str_equal(arg, "-s")) {
      test_mode = TEST_STRICT;
    } else if (str_equal(arg, "-a")) {
      test_mode = TEST_ALL;
    } else if (str_equal(arg, "-u")) {
      update_errors++;
    } else if (str_equal(arg, "-v")) {
      verbose++;
    } else if (str_equal(arg, "-c")) {
      load_config(get_opt_arg(arg, argv[optind++]));
    } else if (str_equal(arg, "-d")) {
      enumerate_tests(get_opt_arg(arg, argv[optind++]));
    } else if (str_equal(arg, "-e")) {
      error_filename = get_opt_arg(arg, argv[optind++]);
    } else if (str_equal(arg, "-x")) {
      namelist_load(&exclude_list, get_opt_arg(arg, argv[optind++]));
    } else if (str_equal(arg, "-f")) {
      is_dir_list = FALSE;
    } else if (str_equal(arg, "-r")) {
      report_filename = get_opt_arg(arg, argv[optind++]);
    } else if (str_equal(arg, "-N")) {
      is_test262_harness = TRUE;
    } else if (str_equal(arg, "-E")) {
      only_check_errors = TRUE;
    } else if (str_equal(arg, "--module")) {
      is_module = TRUE;
    } else {
      fatal(1, "unknown option: %s", arg);
      break;
    }
  }

  if (is_test262_harness) {
    return run_test262_harness_test(argv[optind], is_module);
  }
  if (optind >= argc && !test_list.count) help();

  error_out = stdout;
  if (error_filename) {
    error_file = load_file(error_filename, NULL);
    if (only_check_errors && error_file) {
      namelist_free(&test_list);
      namelist_add_from_error_file(&test_list, error_file);
    }
    if (update_errors) {
      free(error_file);
      error_file = NULL;
      error_out = fopen(error_filename, "w");
      if (!error_out) {
        perror_exit(1, error_filename);
      }
    }
  }

  update_exclude_dirs();

  if (is_dir_list) {
    if (optind < argc && !isdigit(argv[optind][0])) {
      filename = argv[optind++];
      namelist_load(&test_list, filename);
    }
    start_index = 0;
    stop_index = -1;
    if (optind < argc) {
      start_index = atoi(argv[optind++]);
      if (optind < argc) {
        stop_index = atoi(argv[optind++]);
      }
    }
    if (!report_filename || str_equal(report_filename, "none")) {
      outfile = NULL;
    } else if (str_equal(report_filename, "-")) {
      outfile = stdout;
    } else {
      outfile = fopen(report_filename, "wb");
      if (!outfile) {
        perror_exit(1, report_filename);
      }
    }
    run_test_dir_list(&test_list, start_index, stop_index);

    if (outfile && outfile != stdout) {
      fclose(outfile);
      outfile = NULL;
    }
  } else {
    outfile = stdout;
    while (optind < argc) {
      run_test(argv[optind++], -1);
    }
  }

  if (dump_memory) {
    if (dump_memory > 1 && stats_count > 1) {
      printf("\nMininum memory statistics for %s:\n\n", stats_min_filename);
      LEPUS_DumpMemoryUsage(stdout, &stats_min, NULL);
      printf("\nMaximum memory statistics for %s:\n\n", stats_max_filename);
      LEPUS_DumpMemoryUsage(stdout, &stats_max, NULL);
    }
    printf("\nAverage memory statistics for %d tests:\n\n", stats_count);
    LEPUS_DumpMemoryUsage(stdout, &stats_avg, NULL);
    printf("\n");
  }

  if (is_dir_list) {
    fprintf(stderr, "Result: %d/%d error%s", test_failed, test_count,
            test_count != 1 ? "s" : "");
    if (test_excluded) fprintf(stderr, ", %d excluded", test_excluded);
    if (test_skipped) fprintf(stderr, ", %d skipped", test_skipped);
    if (error_file) {
      if (new_errors) fprintf(stderr, ", %d new", new_errors);
      if (changed_errors) fprintf(stderr, ", %d changed", changed_errors);
      if (fixed_errors) fprintf(stderr, ", %d fixed", fixed_errors);
    }
    fprintf(stderr, "\n");
  }

  if (error_out && error_out != stdout) {
    fclose(error_out);
    error_out = NULL;
  }
  if (new_errors || fixed_errors || changed_errors) {
    fprintf(
        stderr,
        "Check test262 result changed, please check the code!\n"
        "If the test results are expected, you can run\nninja -C out/Default "
        "run_test262 && out/Default/run_test262 -m -a -u -c "
        "out/Default/quickjs_test/test262.conf\nTo update the test262 record\n"
        "(gn args need to have is_test=true)\n");
  }
  namelist_free(&test_list);
  namelist_free(&exclude_list);
  namelist_free(&exclude_dir_list);
  free(harness_dir);
  free(harness_features);
  free(harness_exclude);
  free(error_file);
  if (update_errors) return 0;
  return new_errors || fixed_errors || changed_errors;
}
