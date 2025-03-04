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

#include "inspector/debugger/debugger.h"

#include <assert.h>

#include "gc/trace-gc.h"
#include "inspector/debugger/debugger_breakpoint.h"
#include "inspector/debugger/debugger_callframe.h"
#include "inspector/debugger/debugger_properties.h"
#include "inspector/debugger/debugger_queue.h"
#include "inspector/debugger_inner.h"
#include "inspector/interface.h"
#include "inspector/protocols.h"

typedef struct DebuggerParams DebuggerParams;
char *FindDebuggerMagicContent(LEPUSContext *ctx, char *content1, char *name1,
                               uint8_t multi_line);

struct LEPUSDebuggerInfo *GetDebuggerInfo(LEPUSContext *ctx) {
  return ctx->debugger_info;
}

void *GetDebuggerInfoOpaque(LEPUSDebuggerInfo *info) {
  return info ? info->opaque : NULL;
}

void SetDebuggerInfoOpaque(LEPUSDebuggerInfo *info, void *opaque) {
  if (info) {
    info->opaque = opaque;
  }
}

struct qjs_queue *GetDebuggerMessageQueue(LEPUSDebuggerInfo *info) {
  return info ? info->message_queue : nullptr;
}

void SetDebuggerSourceCode(LEPUSContext *ctx, char *source_code) {
  if (ctx->debugger_info) {
    ctx->debugger_info->source_code =
        lepus_strndup(ctx, (const char *)source_code,
                      strlen((char *)source_code) + 1, ALLOC_TAG_WITHOUT_PTR);
    strcpy(ctx->debugger_info->source_code, source_code);
  }
  return;
}

QJS_STATIC uint8_t AddToFunctionBytecodeList(LEPUSContext *ctx,
                                             LEPUSFunctionBytecode *b,
                                             LEPUSFunctionBytecode **&list,
                                             uint32_t *use_size,
                                             uint32_t &total_size) {
  const uint32_t size = 50;
  if (*use_size >= total_size) {
    list = static_cast<LEPUSFunctionBytecode **>(lepus_realloc(
        ctx, list, sizeof(LEPUSFunctionBytecode *) * (total_size + size),
        ALLOC_TAG_WITHOUT_PTR));
    if (list) {
      total_size += size;
    } else {
      *use_size = 0;
      return 0;
    }
  }
  list[*use_size] = b;
  *use_size += 1;
  return 1;
}

QJS_HIDE void AddFunctionBytecode(LEPUSContext *ctx, LEPUSValue obj,
                                  LEPUSFunctionBytecode **&list,
                                  uint32_t *use_size, uint32_t &total_size) {
  int64_t tag = LEPUS_VALUE_GET_NORM_TAG(obj);
  switch (tag) {
    case LEPUS_TAG_FUNCTION_BYTECODE: {
      LEPUSFunctionBytecode *b =
          static_cast<LEPUSFunctionBytecode *>(LEPUS_VALUE_GET_PTR(obj));
      if (!AddToFunctionBytecodeList(ctx, b, list, use_size, total_size)) {
        if (!ctx->rt->gc_enable) lepus_free(ctx, list);
        list = NULL;
        return;
      }
      for (int i = 0; i < b->cpool_count; i++) {
        AddFunctionBytecode(ctx, b->cpool[i], list, use_size, total_size);
      }
      break;
    }
    case LEPUS_TAG_MODULE: {
      LEPUSModuleDef *m =
          static_cast<LEPUSModuleDef *>(LEPUS_VALUE_GET_PTR(obj));
      AddFunctionBytecode(ctx, m->func_obj, list, use_size, total_size);
      break;
    }
    case LEPUS_TAG_OBJECT: {
      LEPUSObject *p = LEPUS_VALUE_GET_OBJ(obj);
      uint32_t i, len;
      JSShape *sh;
      JSShapeProperty *pr;
      LEPUSValue val;
      int pass;
      BOOL is_template;
      JSAtom atom;

      if (p->class_id == JS_CLASS_ARRAY) {
        if (!p->extensible) {
          is_template = TRUE;
        } else {
          is_template = FALSE;
        }
        if (lepus_get_length32(ctx, &len, obj)) {
          break;
        };
        for (i = 0; i < len; i++) {
          val = LEPUS_GetPropertyUint32(ctx, obj, i);
          if (LEPUS_IsException(val)) break;
          AddFunctionBytecode(ctx, val, list, use_size, total_size);
          if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, val);
        }
        if (is_template) {
          val = LEPUS_GetPropertyInternal(ctx, obj, JS_ATOM_raw, obj, 0);
          if (LEPUS_IsException(val)) break;
          AddFunctionBytecode(ctx, val, list, use_size, total_size);
          if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, val);
        }
      } else {
        sh = p->shape;
        for (pass = 0; pass < 2; pass++) {
          for (i = 0, pr = sh->prop; i < sh->prop_count; i++, pr++) {
            atom = pr->atom;
            if (atom != JS_ATOM_NULL && JS_AtomIsString(ctx, atom) &&
                (pr->flags & LEPUS_PROP_ENUMERABLE)) {
              if (pr->flags & LEPUS_PROP_TMASK) {
                LEPUS_ThrowTypeError(ctx,
                                     "only value properties are supported");
                break;
              }
              if (pass != 0) {
                AddFunctionBytecode(ctx, p->prop[i].u.value, list, use_size,
                                    total_size);
              }
            }
          }
        }
      }
      break;
    }
    default: {
      break;
    }
  }
}

// get all the functionbytecode for lepusng debugger encode
LEPUSFunctionBytecode **GetDebuggerAllFunction(LEPUSContext *ctx,
                                               LEPUSValue top_level_function,
                                               uint32_t *use_size) {
  *use_size = 0;
  uint32_t total_size = 50;
  LEPUSFunctionBytecode **all_functions = static_cast<LEPUSFunctionBytecode **>(
      lepus_mallocz(ctx, sizeof(LEPUSFunctionBytecode *) * total_size,
                    ALLOC_TAG_WITHOUT_PTR));
  if (all_functions) {
    AddFunctionBytecode(ctx, top_level_function, all_functions, use_size,
                        total_size);
  }
  if (!ctx->debugger_info) return all_functions;

  for (uint32_t i = 0, size = *use_size; i < size; ++i) {
    auto *b = all_functions[i];
    list_add_tail(&b->link, &ctx->debugger_info->bytecode_list);
    b->func_level_state = DEBUGGER_LOW_LEVEL_FUNCTION;
  }
  return all_functions;
}

void SetFunctionDebugFileName(LEPUSContext *ctx, LEPUSFunctionBytecode *b,
                              const char *filename, int len) {
  assert(b->has_debug);
  if (filename) {
    b->debug.filename = LEPUS_NewAtom(ctx, filename);
  } else {
    b->debug.filename = JS_ATOM_NULL;
  }
}

void SetFunctionDebugLineNum(LEPUSFunctionBytecode *b, int line_number) {
  assert(b->has_debug);
  b->debug.line_num = line_number;
}

void SetFunctionDebugColumnNum(LEPUSFunctionBytecode *b,
                               int64_t column_number) {
  assert(b->has_debug);
  b->debug.column_num = column_number;
}

void SetFunctionDebugPC2LineBufLen(LEPUSContext *ctx, LEPUSFunctionBytecode *b,
                                   uint8_t *buf, int buf_len) {
  assert(b->has_debug);
  if (buf) {
    b->debug.pc2line_buf = static_cast<uint8_t *>(
        lepus_mallocz(ctx, buf_len, ALLOC_TAG_WITHOUT_PTR));
    if (!b->debug.pc2line_buf) {
      b->debug.pc2line_len = 0;
      return;
    }
    memcpy(b->debug.pc2line_buf, buf, buf_len);
    b->debug.pc2line_len = buf_len;
  } else {
    b->debug.pc2line_buf = NULL;
    b->debug.pc2line_len = 0;
  }
}

uint32_t GetFunctionDebugId(LEPUSFunctionBytecode *b) {
  return b->function_id - 1;
}

void SetFunctionDebugSource(LEPUSContext *ctx, LEPUSFunctionBytecode *b,
                            const char *source, int32_t source_len) {
  assert(b->has_debug);
  b->debug.source_len = source_len;
  b->debug.source = js_strmalloc((const char *)source, source_len);
  return;
}

int64_t *GetFunctionLineNums(LEPUSContext *ctx, const LEPUSFunctionBytecode *b,
                             size_t *size) {
#ifdef ENABLE_QUICKJS_DEBUGGER
  if (!b->has_debug || !b->debug.pc2line_buf) return nullptr;
  const uint8_t *p = b->debug.pc2line_buf, *p_end = p + b->debug.pc2line_len;
  int64_t line_num = b->debug.line_num, new_line_col = 0;
  uint32_t op = 0, i = 0, pc = 0;
  int64_t *result = static_cast<int64_t *>(lepus_malloc(
      ctx, sizeof(int64_t) * b->byte_code_len, ALLOC_TAG_WITHOUT_PTR));
  if (!result) goto fail;
  while (p < p_end) {
    op = *p++;
    if (op == 0) {
      int32_t ret;
      uint64_t val;
      int64_t v;
      ret = get_leb128_u64(&val, p, p_end);
      if (ret < 0) goto fail;
      p += ret;
      pc += val;
      ret = get_sleb128_u64(&v, p, p_end);
      if (ret < 0) {
        goto fail;
      }
      p += ret;
      new_line_col = line_num + v;
    } else {
      op -= PC2LINE_OP_FIRST;
      pc += (op / PC2LINE_RANGE);
      new_line_col = line_num + (op % PC2LINE_RANGE) + PC2LINE_BASE;
    }
    while (i < pc) {
      result[i++] = line_num;
    }
    line_num = new_line_col;
  }

  while (i < b->byte_code_len) {
    result[i++] = line_num;
  }

  *size = i;
  return result;
fail:
  if (!ctx->rt->gc_enable) {
    lepus_free(ctx, result);
  }
#endif
  *size = 0;
  return nullptr;
}

int32_t GetFunctionDebugSourceLen(LEPUSContext *ctx, LEPUSFunctionBytecode *b) {
  if (b && b->has_debug) {
    return b->debug.source_len;
  } else {
    return -1;
  }
}

// pause the vm
QJS_HIDE void RunMessageLoopOnPause(LEPUSContext *ctx) {
  auto pause_callback = ctx->rt->debugger_callbacks_.run_message_loop_on_pause;
  if (pause_callback) {
    pause_callback(ctx);
  }
}

// quit pause
QJS_HIDE void QuitMessageLoopOnPause(LEPUSContext *ctx) {
  auto quit_pause_callback =
      ctx->rt->debugger_callbacks_.quit_message_loop_on_pause;
  if (quit_pause_callback) {
    quit_pause_callback(ctx);
  }
}

/**
 * @brief get script by index
 */
QJS_HIDE LEPUSScriptSource *GetScriptByIndex(LEPUSContext *ctx,
                                             int32_t script_index) {
  struct list_head *el;
  int32_t idx = 0;
  list_for_each(el, &ctx->debugger_info->script_list) {
    LEPUSScriptSource *script = list_entry(el, LEPUSScriptSource, link);
    if (idx == script_index) {
      return script;
    } else {
      idx++;
    }
  }
  return NULL;
}

// add lepus.js script info into rt->script_list
void AddDebuggerScript(LEPUSContext *ctx, char *script_source,
                       int32_t source_len, int32_t end_line_num) {
  LEPUSScriptSource *script = static_cast<LEPUSScriptSource *>(lepus_mallocz(
      ctx, sizeof(LEPUSScriptSource), ALLOC_TAG_LEPUSScriptSource));
  HandleScope func_scope{ctx, script, HANDLE_TYPE_DIR_HEAP_OBJ};
  if (script) {
    script->id = ++(ctx->rt->next_script_id);
    script->is_debug_file = true;
    script->end_line = end_line_num;
    script->length = source_len;
    script->url = static_cast<char *>(
        lepus_strdup(ctx, "lepus.js", ALLOC_TAG_WITHOUT_PTR));
    script->source = static_cast<char *>(
        lepus_malloc(ctx, source_len + 1, ALLOC_TAG_WITHOUT_PTR));
    if (script->source) {
      memcpy(script->source, script_source, source_len + 1);
    }
    script->source_map_url = NULL;
    ctx->debugger_info->script_num++;
    list_add_tail(&script->link, &ctx->debugger_info->script_list);
  }
}

QJS_HIDE const char *GetScriptSourceByScriptId(LEPUSContext *ctx,
                                               int32_t script_id) {
  struct list_head *el;
  list_for_each(el, &ctx->debugger_info->script_list) {
    LEPUSScriptSource *script = list_entry(el, LEPUSScriptSource, link);
    if (script->id == script_id) {
      return script->source;
    }
  }
  return "";
}

QJS_STATIC void GetFunctionScriptId(LEPUSContext *ctx, LEPUSFunctionBytecode *b,
                                    int32_t &script_id, bool &is_lepus) {
  script_id = -1;
  if (!b->script) {
    auto *el = (ctx->debugger_info->script_list).next;
    if (el) {
      auto *script = list_entry(el, LEPUSScriptSource, link);
      if (script && script->url && (strcmp(script->url, "lepus.js") == 0)) {
        script_id = script->id;
        is_lepus = true;
      }
    }
  } else {
    script_id = b->script->is_debug_file ? b->script->id : -1;
    is_lepus = false;
  }
}

QJS_HIDE void GetCurrentLocation(LEPUSContext *ctx,
                                 struct LEPUSStackFrame *frame,
                                 const uint8_t *cur_pc, int32_t &line,
                                 int64_t &column, int32_t &script_id) {
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(frame->cur_func);
  if (p && lepus_class_has_bytecode(p->class_id)) {
    struct LEPUSFunctionBytecode *b = p->u.func.function_bytecode;
    if (!b || !b->has_debug) return;

    bool is_lepus = false;
    GetFunctionScriptId(ctx, b, script_id, is_lepus);

    const uint8_t *pc = frame != ctx->rt->current_stack_frame || !cur_pc
                            ? frame->cur_pc
                            : cur_pc;

    int64_t line_num1 =
        find_line_num(ctx, b, (uint32_t)(pc - b->byte_code_buf - 1));
    ComputeLineCol(line_num1, &line, &column);
  }
}

QJS_HIDE int32_t GetScriptIdByFunctionBytecode(
    LEPUSContext *ctx, struct LEPUSFunctionBytecode *b) {
  struct list_head *el, *el1;
  struct LEPUSFunctionBytecode *bytecode;
  list_for_each_safe(el, el1, &ctx->debugger_info->bytecode_list) {
    bytecode = list_entry(el, LEPUSFunctionBytecode, link);
    if (bytecode == b && bytecode->script) {
      return bytecode->script->id;
    }
  }
  return -1;
}

QJS_HIDE LEPUSFunctionBytecode *GetFunctionBytecodeByScriptId(
    LEPUSContext *ctx, int32_t script_id) {
  struct list_head *el, *el1;
  list_for_each_safe(el, el1, &ctx->debugger_info->bytecode_list) {
    LEPUSFunctionBytecode *b = list_entry(el, LEPUSFunctionBytecode, link);
    // return top level bytecode
    if (b->script && b->func_level_state == DEBUGGER_TOP_LEVEL_FUNCTION &&
        b->script->id == script_id) {
      return b;
    }
  }
  return NULL;
}

void DebuggerSetPropertyStr(LEPUSContext *ctx, LEPUSValueConst this_obj,
                            const char *prop, LEPUSValue val) {
  JSAtom atom;
  JSProperty *pr;
  atom = LEPUS_NewAtom(ctx, prop);
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(this_obj);
#ifdef ENABLE_COMPATIBLE_MM
  if (ctx->gc_enable) {
    HandleScope func_scope{ctx->rt};
    func_scope.PushLEPUSAtom(atom);
    pr = add_property_gc(ctx, p, atom, LEPUS_PROP_C_W_E);
    if (likely(pr)) pr->u.value = val;
    return;
  }
#endif
  pr = add_property(ctx, p, atom, LEPUS_PROP_C_W_E);
  if (likely(pr)) {
    pr->u.value = val;
  } else {
    LEPUS_FreeValue(ctx, val);
  }
  LEPUS_FreeAtom(ctx, atom);
  return;
}

LEPUSObject *DebuggerCreateObjFromShape(LEPUSDebuggerInfo *info, LEPUSValue obj,
                                        int32_t argc, LEPUSValue *argv) {
  JSShape *result_sh = LEPUS_VALUE_GET_OBJ(obj)->shape;
  auto *ctx = info->ctx;
  auto result = DEBUGGER_COMPATIBLE_CALL_RET(ctx, JS_NewObjectFromShape, ctx,
                                             js_dup_shape(result_sh), 1);
  auto *p = LEPUS_VALUE_GET_OBJ(result);
  if (!p) {
    if (!ctx->gc_enable) {
      for (uint32_t i = 0; i < argc; ++i) {
        LEPUS_FreeValue(ctx, argv[i]);
      }
    }
    return nullptr;
  }
  assert(argc <= p->shape->prop_count);
  for (uint32_t i = 0, size = p->shape->prop_count; i < size; ++i) {
    p->prop[i].u.value = argv[i];
  }
  return p;
}

LEPUSValue DebuggerDupException(LEPUSContext *ctx) {
  LEPUSValue val = ctx->rt->current_exception;
  LEPUS_DupValue(ctx, val);
  return val;
}

QJS_HIDE void SetDebuggerStepStatement(LEPUSDebuggerInfo *info,
                                       LEPUSContext *ctx,
                                       const uint8_t *cur_pc) {
  if (!info) return;
  LEPUSValue val = LEPUS_UNDEFINED;
  LEPUSValue function = ctx->rt->current_stack_frame->cur_func;
  struct LEPUSFunctionBytecode *b = JS_GetFunctionBytecode(function);
  int op_code = *(cur_pc - 1);
  switch ((op_code)) {
    case OP_push_const:
      val = b->cpool[get_u32(cur_pc)];
      break;
    case OP_push_const8:
      val = b->cpool[*cur_pc];
      break;
    default:
      break;
  }
  const char *name = LEPUS_ToCStringLen2(ctx, NULL, val, 0);
  if (name && strcmp(name, "statement") == 0) {
    // statement here
    info->step_statement = true;
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, name);
  return;
}

QJS_HIDE void DebuggerSetFunctionBytecodeScript(LEPUSContext *ctx,
                                                JSFunctionDef *fd,
                                                LEPUSFunctionBytecode *b) {
  b->func_level_state = DEBUGGER_LOW_LEVEL_FUNCTION;
  b->script = fd->script;
  if (b->script != NULL) {
    b->func_level_state = DEBUGGER_TOP_LEVEL_FUNCTION;
  } else if (fd->parent != NULL) {
    // set function bytecode script: top level function script
    JSFunctionDef *p = fd->parent;
    while (p->script == NULL && p->parent != NULL) {
      p = p->parent;
    }
    b->script = p->script;
  }
  // add bytecode to bytecode_list
  list_add_tail(&b->link, &ctx->debugger_info->bytecode_list);
}

QJS_STATIC void SetScriptSourceMappingUrl(LEPUSContext *ctx,
                                          LEPUSScriptSource *script) {
  char *source_map_url = FindDebuggerMagicContent(
      ctx, script->source, (char *)"sourceMappingURL", 0);
  script->source_map_url = source_map_url;
  return;
}

QJS_HIDE char *DebuggerSetScriptHash(LEPUSContext *ctx, const char *src,
                                     int32_t id) {
  const int32_t buf_len = 64;
  char *buf = static_cast<char *>(
      lepus_malloc(ctx, (sizeof(char) * buf_len), ALLOC_TAG_WITHOUT_PTR));
  if (buf) {
    uint64_t h = 0;
    while (*src) {
      h = h * 31 + *src++;
    }
    h = h * 31 + id;
    snprintf(buf, buf_len, "%llu", (unsigned long long)h);
  }
  return buf;
}

QJS_STATIC void SetScriptUrl(LEPUSContext *ctx, const char *filename,
                             LEPUSScriptSource *script, char *source_url) {
  script->url = NULL;
  if (*filename) {
    script->url = lepus_strdup(ctx, filename, ALLOC_TAG_WITHOUT_PTR);
  } else if (script->source) {
    script->url = source_url
                      ? lepus_strdup(ctx, source_url, ALLOC_TAG_WITHOUT_PTR)
                      : lepus_strdup(ctx, "", ALLOC_TAG_WITHOUT_PTR);
  }
  return;
}

QJS_STATIC void SetScriptHash(LEPUSContext *ctx, LEPUSScriptSource *script) {
  script->hash = NULL;
  if (script->source) {
    char *hash = DebuggerSetScriptHash(ctx, script->source, script->id);
    script->hash = hash;
  }
}

QJS_STATIC void SendParseScriptNotification(LEPUSContext *ctx,
                                            LEPUSScriptSource *script,
                                            int32_t err, int32_t view_id) {
  if (ctx->debugger_info->is_debugger_enabled) {
    if (!err) {
      if (view_id == -1) {
        auto cb = ctx->rt->debugger_callbacks_.script_parsed_ntfy;
        if (cb) {
          cb(ctx, script);
        }
      } else {
        auto cb = ctx->rt->debugger_callbacks_.script_parsed_ntfy_with_view_id;
        if (cb) {
          cb(ctx, script, view_id);
        }
      }
    } else {
      if (view_id == -1) {
        auto cb = ctx->rt->debugger_callbacks_.script_fail_parse_ntfy;
        if (cb) {
          cb(ctx, script);
        }
      } else {
        auto cb =
            ctx->rt->debugger_callbacks_.script_fail_parse_ntfy_with_view_id;
        if (cb) {
          cb(ctx, script, view_id);
        }
      }
    }
  }
}

QJS_STATIC bool IsDebuggerFile(const char *filename) {
  return filename && strcmp(filename, "quickjsTriggerTimer.js") != 0;
}

QJS_STATIC LEPUSScriptSource *FindDebuggerScript(LEPUSContext *ctx,
                                                 char *source_url) {
  struct list_head *el, *el1;
  list_for_each_safe(el, el1, &ctx->debugger_info->script_list) {
    LEPUSScriptSource *script = list_entry(el, LEPUSScriptSource, link);
    if (script && script->url && source_url &&
        strcmp(script->url, source_url) == 0) {
      return script;
    }
  }
  return NULL;
}

// get view id from filename
// filename format: file://viewx/app-service.js
QJS_STATIC int32_t GetViewID(const char *filename) {
  int32_t view_id = -1;
  const char *file_head = "file://view";
  size_t file_head_len = strlen(file_head);
  size_t file_name_len = strlen(filename);
  if (filename && strncmp(filename, file_head, file_head_len) == 0) {
    view_id = 0;
    for (size_t i = file_head_len; i < file_name_len && filename[i] != '/';
         i++) {
      if (filename[i] >= '0' && filename[i] <= '9') {
        view_id = view_id * 10 + (filename[i] - '0');
      }
    }
  }
  return view_id;
}

int32_t GetExecutionContextId(LEPUSContext *ctx) {
  struct list_head *el, *el1;
  LEPUSRuntime *rt = ctx->rt;
  int32_t index = 0;
  list_for_each_safe(el, el1, &rt->context_list) {
    LEPUSContext *ctx1 = list_entry(el, LEPUSContext, link);
    if (ctx1 == ctx) {
      return index;
    } else {
      index++;
    }
  }
  // not found
  return -1;
}

QJS_HIDE void DebuggerParseScript(LEPUSContext *ctx, const char *input,
                                  size_t input_len, JSFunctionDef *fd,
                                  const char *filename, int32_t end_line_num,
                                  int32_t err) {
  auto *debug_info = ctx->debugger_info;
  if (!debug_info) return;
  char *source_url = NULL;
  LEPUSScriptSource *script = NULL;
  HandleScope func_scope{ctx};
  if (input) {
    source_url =
        FindDebuggerMagicContent(ctx, (char *)input, (char *)"sourceURL", 0);

    func_scope.PushHandle(source_url, HANDLE_TYPE_DIR_HEAP_OBJ);
    if (source_url) {
      // if the script is already in script list, do not need to create new
      // script
      script = FindDebuggerScript(ctx, source_url);
    }
  }

  if (!script && IsDebuggerFile(filename)) {
    script = static_cast<LEPUSScriptSource *>(lepus_mallocz(
        ctx, sizeof(LEPUSScriptSource), ALLOC_TAG_LEPUSScriptSource));
    func_scope.PushHandle(script, HANDLE_TYPE_DIR_HEAP_OBJ);
    if (script) {
      script->id = ++ctx->rt->next_script_id;
      script->is_debug_file = (strcmp(filename, "<input>") != 0);
      script->length = input_len;
      script->source = static_cast<char *>(
          lepus_malloc(ctx, input_len + 1, ALLOC_TAG_WITHOUT_PTR));
      if (script->source) {
        memcpy(script->source, input, input_len + 1);
      }
      script->end_line = end_line_num;
      SetScriptUrl(ctx, filename, script, source_url);
      SetScriptSourceMappingUrl(ctx, script);
      SetScriptHash(ctx, script);
      debug_info->script_num++;
      list_add_tail(&script->link, &ctx->debugger_info->script_list);
    }
  }

  if (script) {
    fd->source_len = input_len;
    if (ctx->gc_enable || err) {
      // fd->source free in js_free_function_def
      fd->source = js_strmalloc(script->source, strlen(script->source));
    } else {
      fd->source = script->source;
    }
    fd->script = script;
    int32_t view_id = GetViewID(filename);
    const char *script_url = script ? script->url : nullptr;
    if (!(script_url && strcmp(script_url, "<input>") == 0)) {
      SendParseScriptNotification(ctx, script, err, view_id);
    }
  }
  if (!ctx->gc_enable) {
    lepus_free(ctx, source_url);
  }
  return;
}

void DebuggerPause(LEPUSContext *ctx, LEPUSValue val, const uint8_t *pc) {
  auto *info = ctx->debugger_info;
  if (!info) return;
  const char *name = LEPUS_ToCStringLen2(ctx, NULL, val, 0);
  HandleScope func_scope{ctx, &name, HANDLE_TYPE_CSTRING};
  // only pause when breakpoint is active
  if (info->breakpoints_is_active && name && strcmp(name, "debugger") == 0) {
    auto paused_callback = ctx->rt->debugger_callbacks_.debugger_paused;
    if (paused_callback) {
      paused_callback(ctx, pc);
    }
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, name);
  return;
}

const char *GetFunctionDebugSource(LEPUSContext *ctx,
                                   LEPUSFunctionBytecode *b) {
  if (b && b->has_debug) {
    return b->debug.source;
  } else {
    return NULL;
  }
}

uint8_t *GetFunctionDebugPC2LineBuf(LEPUSContext *ctx,
                                    LEPUSFunctionBytecode *b) {
  if (b && b->has_debug) {
    return b->debug.pc2line_buf;
  }
  return NULL;
}

int GetFunctionDebugPC2LineLen(LEPUSContext *ctx, LEPUSFunctionBytecode *b) {
  if (b && b->has_debug) {
    return b->debug.pc2line_len;
  }
  return 0;
}

uint32_t DebuggerGetFuncSize(LEPUSContext *ctx) {
  return ctx->next_function_id - 1;  // next_function_id start from 1
}

const char *GetFunctionDebugFileName(LEPUSContext *ctx,
                                     LEPUSFunctionBytecode *b) {
  if (b && b->has_debug) {
    return LEPUS_AtomToCString(ctx, b->debug.filename);
  }
  return NULL;
}

const char *GetFunctionName(LEPUSContext *ctx, LEPUSFunctionBytecode *b) {
  if (b) {
    if (b->func_name == JS_ATOM_NULL) return NULL;
    return LEPUS_AtomToCString(ctx, b->func_name);
  }
  return NULL;
}

int32_t GetFunctionDebugLineNum(LEPUSContext *ctx, LEPUSFunctionBytecode *b) {
  if (b && b->has_debug) {
    return b->debug.line_num - 1;
  } else {
    return -1;
  }
}

void SetDebuggerEndLineNum(LEPUSContext *ctx, int32_t end_line_num) {
  if (ctx->debugger_info) {
    ctx->debugger_info->end_line_num = end_line_num;
  }
}

int GetFunctionBytecodeLen(LEPUSFunctionBytecode *b) {
  if (b) {
    return b->byte_code_len;
  } else {
    return -1;
  }
}

int64_t GetFunctionDebugColumnNum(LEPUSContext *ctx, LEPUSFunctionBytecode *b) {
  if (b && b->has_debug) {
    return b->debug.column_num;
  }
  return -1;
}

PCScope::PCScope(LEPUSContext *ctx) : ctx_(ctx) {
  pc_ = ctx_->debugger_info->debugger_current_pc;
}

PCScope::~PCScope() { ctx_->debugger_info->debugger_current_pc = pc_; }

// send Debugger.paused event, do not call run_message_loop_on_pause
static void SendPausedEventWithoutPause(
    LEPUSContext *ctx, LEPUSDebuggerInfo *info, const uint8_t *cur_pc,
    LEPUSValue breakpoint_id, const char *reason, int32_t view_id = -1) {
  LEPUSValue paused_params = LEPUS_NewObject(ctx);
  if (LEPUS_IsException(paused_params)) {
    return;
  }
  HandleScope func_scope(ctx, &paused_params, HANDLE_TYPE_LEPUS_VALUE);
  // get call stack the virtual machine stopped on
  LEPUSValue callFrames = BuildBacktrace(ctx, cur_pc);
  if (!LEPUS_IsUndefined(callFrames)) {
    func_scope.PushHandle(&callFrames, HANDLE_TYPE_LEPUS_VALUE);
    DebuggerSetPropertyStr(ctx, paused_params, "callFrames", callFrames);
  }
  LEPUSValue param_reason = LEPUS_NewString(ctx, reason);
  if (!LEPUS_IsException(param_reason)) {
    func_scope.PushHandle(&param_reason, HANDLE_TYPE_LEPUS_VALUE);
    DebuggerSetPropertyStr(ctx, paused_params, "reason", param_reason);
  }

  if (!LEPUS_IsUndefined(breakpoint_id)) {
    LEPUSValue param_hit_breakpoints = LEPUS_NewArray(ctx);
    func_scope.PushHandle(&param_hit_breakpoints, HANDLE_TYPE_LEPUS_VALUE);
    LEPUS_SetPropertyUint32(ctx, param_hit_breakpoints, 0,
                            LEPUS_DupValue(ctx, breakpoint_id));
    DebuggerSetPropertyStr(ctx, paused_params, "hitBreakpoints",
                           param_hit_breakpoints);
  }

  // remove breakpoint which specific location flag is true
  if (info->special_breakpoints) {
    int32_t bp_num = info->breakpoints_num;
    for (int32_t i = 0; i < bp_num; i++) {
      LEPUSBreakpoint *bp = info->bps + i;
      if (bp->specific_location) {
        // remove
        DeleteBreakpoint(info, i);
        break;
      }
    }
    info->special_breakpoints = 0;
  }

  // set "data" property if break by exception
  if (reason && strcmp(reason, "exception") == 0) {
    LEPUSValue exception = DebuggerDupException(ctx);
    LEPUSValue remote_object =
        GetRemoteObject(ctx, exception, 0, 0);  // free exception
    func_scope.PushHandle(&remote_object, HANDLE_TYPE_LEPUS_VALUE);
    DebuggerSetPropertyStr(ctx, paused_params, "data", remote_object);
  }
  // send "Debugger.paused" event
  SendNotification(ctx, "Debugger.paused", paused_params, view_id);
}

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-paused
// send Debugger.paused event, and call run_message_loop_on_pause
void SendPausedEvent(LEPUSDebuggerInfo *info, const uint8_t *cur_pc,
                     LEPUSValue breakpoint_id, const char *reason) {
  LEPUSContext *ctx = info->ctx;
  // if already in pause state, do not need to generate PauseStateScope
  PauseStateScope ps(info);
  {
    SendPausedEventWithoutPause(ctx, info, cur_pc, breakpoint_id, reason);
    RunMessageLoopOnPause(ctx);
  }
}

void HandleDebuggerException(LEPUSContext *ctx) {
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  if (!info) return;
  // if no need to pause at exception, return
  if (!info->exception_breakpoint) return;
  const uint8_t *pc = ctx->debugger_info->debugger_current_pc;
  SendPausedEvent(info, pc, LEPUS_UNDEFINED, "exception");
  ProcessProtocolMessages(info);
}

static void FreeFixedShapeObj(LEPUSDebuggerInfo *info) {
  auto *ctx = info->ctx;
  auto &fixed_shape_obj = info->debugger_obj;
  LEPUS_FreeValue(ctx, fixed_shape_obj.response);
  LEPUS_FreeValue(ctx, fixed_shape_obj.notification);
  LEPUS_FreeValue(ctx, fixed_shape_obj.breakpoint);
  LEPUS_FreeValue(ctx, fixed_shape_obj.bp_location);
  LEPUS_FreeValue(ctx, fixed_shape_obj.result);
  LEPUS_FreeValue(ctx, fixed_shape_obj.preview_prop);
}

static void FreeStringPool(LEPUSDebuggerInfo *info) {
  auto *ctx = info->ctx;
  auto &literal_pool = info->literal_pool;
#define DebuggerFreeStringPool(name, str) \
  LEPUS_FreeValue(ctx, literal_pool.name);
  QJSDebuggerStringPool(DebuggerFreeStringPool)
#undef DebuggerFreeStringPool
}

static void InitializeShape(LEPUSContext *ctx, LEPUSObject *p,
                            const char *key) {
  JSAtom atom = LEPUS_NewAtom(ctx, key);
  JSProperty *pr = nullptr;
#ifdef ENABLE_COMPATIBLE_MM
  if (ctx->gc_enable) {
    HandleScope func_scope(ctx);
    func_scope.PushLEPUSAtom(atom);
    pr = add_property_gc(ctx, p, atom, LEPUS_PROP_C_W_E);
    if (pr) {
      pr->u.value = LEPUS_UNDEFINED;
    }
    return;
  }
#endif

  pr = add_property(ctx, p, atom, LEPUS_PROP_C_W_E);
  LEPUS_FreeAtom(ctx, atom);
  if (pr) pr->u.value = LEPUS_UNDEFINED;
  return;
}

static void InitFixedShapeResult(LEPUSDebuggerInfo *info) {
  LEPUSContext *ctx = info->ctx;
  info->debugger_obj.result = LEPUS_NewObject(ctx);
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(info->debugger_obj.result);
  InitializeShape(ctx, p, "result");
}

static void InitFixedShapePreviewProp(LEPUSDebuggerInfo *info) {
  LEPUSContext *ctx = info->ctx;
  info->debugger_obj.preview_prop = LEPUS_NewObject(ctx);
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(info->debugger_obj.preview_prop);
  InitializeShape(ctx, p, "name");
  InitializeShape(ctx, p, "type");
  InitializeShape(ctx, p, "value");
}

static void InitFixedShapeBPLocation(LEPUSDebuggerInfo *info) {
  LEPUSContext *ctx = info->ctx;
  info->debugger_obj.bp_location = LEPUS_NewObject(ctx);
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(info->debugger_obj.bp_location);
  InitializeShape(ctx, p, "scriptId");
  InitializeShape(ctx, p, "lineNumber");
  InitializeShape(ctx, p, "columnNumber");
}

static void InitFixedShapeBreakpoint(LEPUSDebuggerInfo *info) {
  LEPUSContext *ctx = info->ctx;
  info->debugger_obj.breakpoint = LEPUS_NewObject(ctx);
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(info->debugger_obj.breakpoint);
  InitializeShape(ctx, p, "breakpointId");
  InitializeShape(ctx, p, "locations");
}

static void InitFixedShapeNotification(LEPUSDebuggerInfo *info) {
  LEPUSContext *ctx = info->ctx;
  info->debugger_obj.notification = LEPUS_NewObject(ctx);
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(info->debugger_obj.notification);
  InitializeShape(ctx, p, "method");
  InitializeShape(ctx, p, "params");
}

static void InitFixedShapeResponse(LEPUSDebuggerInfo *info) {
  LEPUSContext *ctx = info->ctx;
  info->debugger_obj.response = LEPUS_NewObject(ctx);
  LEPUSObject *p = LEPUS_VALUE_GET_OBJ(info->debugger_obj.response);
  InitializeShape(ctx, p, "id");
  InitializeShape(ctx, p, "result");
}

static void InitializeFixedShapeObj(LEPUSDebuggerInfo *info) {
  InitFixedShapeResponse(info);
  InitFixedShapeNotification(info);
  InitFixedShapeBreakpoint(info);
  InitFixedShapeBPLocation(info);
  InitFixedShapeResult(info);
  InitFixedShapePreviewProp(info);
}

static void InitializeStringPool(LEPUSDebuggerInfo *info) {
  auto *ctx = info->ctx;
  auto &literal_pool = info->literal_pool;
#define DebuggerInitializeStringPool(name, str) \
  literal_pool.name = LEPUS_NewString(ctx, str);
  QJSDebuggerStringPool(DebuggerInitializeStringPool)
#undef DebuggerInitializeStringPool
}

QJS_STATIC void OnConsoleMessageInspect(LEPUSContext *, LEPUSValue);
QJS_STATIC void GetConsoleMessageRIDOrGroupID(LEPUSContext *ctx, LEPUSValue val,
                                              int32_t &rid, char *&gid,
                                              int32_t &lepus_id) {
  const char *first_arg = LEPUS_ToCStringLen2(ctx, NULL, val, 0);
  HandleScope func_scope{ctx, &first_arg, HANDLE_TYPE_CSTRING};
  const char *console_tag[] = {"runtimeId:", "groupId:", "lepusRuntimeId:"};
  if (first_arg) {
    const char *rid_head = console_tag[0];
    size_t rid_head_len = strlen(rid_head);
    if (strncmp(first_arg, rid_head, rid_head_len) == 0) {
      const char *view_id_str = first_arg + rid_head_len;
      if (view_id_str) {
        rid = atoi(view_id_str);
      }
    } else {
      const char *gid_head = console_tag[1];
      size_t gid_head_len = strlen(gid_head);
      if (strncmp(first_arg, gid_head, gid_head_len) == 0) {
        gid = static_cast<char *>(
            lepus_malloc(ctx, strlen(first_arg) - gid_head_len + 1,
                         ALLOC_TAG_WITHOUT_PTR));  // need to be freed
        strcpy(gid, first_arg + gid_head_len);
      } else {
        const char *lepus_head = console_tag[2];
        size_t lepus_head_len = strlen(lepus_head);
        if (strncmp(first_arg, lepus_head, lepus_head_len) == 0) {
          const char *lepus_id_str = first_arg + lepus_head_len;
          if (lepus_id_str) {
            lepus_id = atoi(lepus_id_str);
          }
        }
      }
    }
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, first_arg);
}

QJS_STATIC void CommonLog(LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
                          LEPUSValueConst *argv, int magic,
                          bool is_lynx_console = false) {
  auto *debugger_info = ctx->debugger_info;
  if (!debugger_info || LEPUS_IsNull(debugger_info->console.messages)) return;
  const char *tag_table[] = {"log", "info", "debug", "error", "warning", "log",
                             "",    "",     "log",   "",      "timeEnd"};
  const char *tag = tag_table[magic];
  if (*tag == '\0') return;
  LEPUSValue console_msg = LEPUS_NewArray(ctx);
  HandleScope func_scope{ctx, &console_msg, HANDLE_TYPE_LEPUS_VALUE};
  int32_t rid = -1;
  char *gid = nullptr;
  int32_t lepus_id = -1;
  int argc_idx;
  int real_param = 0;
  func_scope.PushHandle(&gid, HANDLE_TYPE_HEAP_OBJ);
  for (argc_idx = 0; argc_idx < argc; argc_idx++) {
    if (argc_idx == 0 && is_lynx_console) {
      GetConsoleMessageRIDOrGroupID(ctx, argv[0], rid, gid,
                                    lepus_id);  // gid need to be freed
      if (rid == -1 && !gid && lepus_id == -1) {
        LEPUS_SetPropertyUint32(ctx, console_msg, real_param++,
                                LEPUS_DupValue(ctx, argv[argc_idx]));
      }

    } else {
      LEPUS_SetPropertyUint32(ctx, console_msg, real_param++,
                              LEPUS_DupValue(ctx, argv[argc_idx]));
    }
  }
  LEPUSValue str = LEPUS_NewString(ctx, tag);
  func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyStr(ctx, console_msg, "tag", str);
  LEPUS_SetPropertyStr(ctx, console_msg, "timestamp",
                       LEPUS_NewInt64(ctx, date_now()));
  {
    // GetStackTrace
    LEPUSValue stack_trace = LEPUS_NewObject(ctx);
    HandleScope block_scope{ctx, &stack_trace, HANDLE_TYPE_LEPUS_VALUE};
    GetConsoleStackTrace(ctx, &stack_trace);
    LEPUS_SetPropertyStr(ctx, console_msg, "stackTrace", stack_trace);
  }
  if (is_lynx_console) {
    if (rid != -1) {
      LEPUS_SetPropertyStr(ctx, console_msg, "rid", LEPUS_NewInt32(ctx, rid));
    }
    if (gid) {
      str = LEPUS_NewString(ctx, gid);
      func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
      LEPUS_SetPropertyStr(ctx, console_msg, "gid", str);
      if (!ctx->rt->gc_enable) lepus_free(ctx, gid);
    }
    if (lepus_id != -1) {
      LEPUS_SetPropertyStr(ctx, console_msg, "rid",
                           LEPUS_NewInt32(ctx, lepus_id));
      LEPUS_SetPropertyStr(ctx, console_msg, "lepusConsole",
                           LEPUS_NewBool(ctx, 1));
    }
  }

  int idx = debugger_info->console.length++;
  LEPUS_SetPropertyUint32(ctx, debugger_info->console.messages, idx,
                          LEPUS_DupValue(ctx, console_msg));

  LEPUSRuntime *rt = ctx->rt;
  if (ctx->debugger_info->is_runtime_enabled) {
    auto cb = is_lynx_console
                  ? rt->debugger_callbacks_.console_api_called_ntfy_with_rid
                  : rt->debugger_callbacks_.console_api_called_ntfy;
    if (cb) {
      cb(ctx, &console_msg);
    }
  }
  auto console_message_cb = rt->debugger_callbacks_.console_message;
  if (console_message_cb) {
    console_message_cb(ctx, magic, argv, argc);
  }

  if (is_lynx_console && ctx->console_inspect) {
    OnConsoleMessageInspect(ctx, console_msg);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, console_msg);
  return;
}

QJS_STATIC LEPUSValue DebuggerLog(LEPUSContext *ctx, LEPUSValueConst this_val,
                                  int argc, LEPUSValueConst *argv, int magic) {
  CommonLog(ctx, this_val, argc, argv, magic);
  return LEPUS_UNDEFINED;
}

QJS_STATIC LEPUSValue LynxDebuggerLog(LEPUSContext *ctx,
                                      LEPUSValueConst this_val, int argc,
                                      LEPUSValueConst *argv, int magic) {
  CommonLog(ctx, this_val, argc, argv, magic, true);
  return LEPUS_UNDEFINED;
}

QJS_HIDE void JS_AddIntrinsicConsole(LEPUSContext *ctx,
                                     bool is_lynx_console = false) {
  LEPUSValue global = ctx->global_obj;
  LEPUSValue console = LEPUS_NewObject(ctx);
  HandleScope func_scope{ctx, &console, HANDLE_TYPE_LEPUS_VALUE};
  auto log_func = is_lynx_console ? LynxDebuggerLog : DebuggerLog;
  if (is_lynx_console) {
    DebuggerSetPropertyStr(ctx, global, "lynxConsole", console);
  } else {
    DebuggerSetPropertyStr(ctx, global, "console", console);
  }
  LEPUSValue cfunc = LEPUS_UNDEFINED;
  func_scope.PushHandle(&cfunc, HANDLE_TYPE_LEPUS_VALUE);
#define RegisterConsole(name, type)                                          \
  cfunc = LEPUS_NewCFunctionMagic(                                           \
      ctx, log_func, name, 1, LEPUS_CFUNC_generic_magic, JS_CONSOLE_##type); \
  DebuggerSetPropertyStr(ctx, console, name, cfunc);
  QJSDebuggerRegisterConsole(RegisterConsole)
#undef RegisterConsole
      if (ctx->debugger_info &&
          LEPUS_IsNull(ctx->debugger_info->console.messages)) {
    ctx->debugger_info->console.messages = LEPUS_NewArray(ctx);
    ctx->debugger_info->console.length = 0;
  }
}

QJS_HIDE void RegisterLynxConsole(LEPUSContext *ctx) {
  // register lynx console
  LEPUSValue global = ctx->global_obj;
  LEPUSValue lynx_console = LEPUS_GetPropertyStr(ctx, global, "lynxConsole");
  if (LEPUS_IsUndefined(lynx_console)) {
    // for lynxconsole.xxx
    JS_AddIntrinsicConsole(ctx, true);
  }
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, lynx_console);
  }
  return;
}

// debugger initialize
void QJSDebuggerInitialize(LEPUSContext *ctx) {
  LEPUSRuntime *rt = ctx->rt;
  const char *biz_name = DEFAULT_BIZ_NAME;
  if (rt->rt_info) {
    biz_name = rt->rt_info;
  }
#ifdef ENABLE_PRIMJS_SNAPSHOT
  const char *module_name = rt->use_primjs ? MODULE_PRIMJS : MODULE_QUICK;
  MonitorEvent(MODULE_QUICK, biz_name, "QuickjsDebug", module_name);
#else
  MonitorEvent(MODULE_QUICK, biz_name, "QuickjsDebug", MODULE_QUICK);
#endif

  auto *&info = ctx->debugger_info;
  if (!info) {
    info = new (ctx) LEPUSDebuggerInfo{ctx};
    JS_AddIntrinsicConsole(ctx);
  }
  info->ref_count++;
  return;
}

// when pause on debugger keyword, call this function to pause
void PauseOnDebuggerKeyword(LEPUSDebuggerInfo *info, const uint8_t *cur_pc) {
  LEPUSContext *ctx = info->ctx;
  // if already pause on this line due to step, skip this debugger keyword
  if (info->step_type) {
    int32_t line = -1;
    int64_t column = -1;
    int32_t script_id = 0;
    GetDebuggerCurrentLocation(ctx, cur_pc, line, column, script_id);

    auto &step_location = info->step_location;
    int32_t step_line = step_location.line;
    int32_t step_script_id = step_location.script_id;
    if (step_line == line && script_id == step_script_id) {
      return;
    }
  }
  SendPausedEvent(info, cur_pc, LEPUS_UNDEFINED, "debugCommand");
}

DebuggerStatus HandleStepOver(LEPUSDebuggerInfo *info, LEPUSContext *ctx,
                              const uint8_t *cur_pc) {
  // step over: stop if the line number is change or the depth is deeper. else
  // keep running
  int32_t line = -1;
  int64_t column = -1;
  int32_t script_id = 0;
  int32_t stack_depth = GetDebuggerStackDepth(ctx);
  GetDebuggerCurrentLocation(ctx, cur_pc, line, column, script_id);

  auto &step_location = info->step_location;
  int32_t step_line = step_location.line;
  int32_t step_script_id = step_location.script_id;
  int32_t step_depth = info->step_depth;

  // different script & no deeper stack: paused
  if (step_script_id != -1 && script_id != -1 && script_id != step_script_id &&
      stack_depth <= step_depth && !(line == 0 && column == 0)) {
    return JS_DEBUGGER_PAUSED;
  }

  // stack deeper: keep running
  if (stack_depth > step_depth || (line == 0 && column == 0)) {
    info->step_statement = false;
    info->next_statement_count = 0;
    return JS_DEBUGGER_RUN;
  }

  // same line: stack no deeper, statement start: pause after op_push_const &
  // op_drop
  if (info->step_statement) {
    info->step_statement = false;
    info->next_statement_count = 1;  // pass op_push_const statement
    goto done;
  }

  // pause at next pc after statement
  if (info->next_statement_count == 1) {
    info->next_statement_count = 2;  // pass op_drop
    goto done;
  }

  if (info->next_statement_count == 2) goto paused;

done:
  // different line, and stack no deeper: paused
  if (line != step_line && stack_depth <= step_depth) goto paused;
  if (line == step_line && stack_depth < step_depth) goto paused;

  return JS_DEBUGGER_RUN;

paused:
  return JS_DEBUGGER_PAUSED;
}

int32_t HandleStepIn(LEPUSDebuggerInfo *info, LEPUSContext *ctx,
                     const uint8_t *cur_pc) {
  // step in: paused when the depth changes, else process as StepOver
  if (info->step_depth == GetDebuggerStackDepth(ctx)) {
    return HandleStepOver(info, ctx, cur_pc);
  } else {
    return JS_DEBUGGER_PAUSED;
  }
}

DebuggerStatus HandleStepOut(LEPUSDebuggerInfo *info, LEPUSContext *ctx,
                             const uint8_t *cur_pc) {
  // step out: if depth is smaller, stop. else keep running
  int32_t stack_depth = GetDebuggerStackDepth(ctx);
  int32_t step_depth = info->step_depth;
  if (stack_depth >= step_depth) {
    return JS_DEBUGGER_RUN;
  }
  return JS_DEBUGGER_PAUSED;
}

/**
 * @brief handle stepping method
 */
static DebuggerStatus HandleStepping(LEPUSDebuggerInfo *info, LEPUSContext *ctx,
                                     const uint8_t *cur_pc) {
  SetDebuggerStepStatement(info, ctx, cur_pc);
  uint8_t step_type = info->step_type;
  int32_t res = JS_DEBUGGER_RUN;
  if (step_type == DEBUGGER_STEP_CONTINUE) {
    info->step_type = 0;
    goto running;
  } else if (step_type == DEBUGGER_STEP_IN) {
    res = HandleStepIn(info, ctx, cur_pc);
    if (res == JS_DEBUGGER_PAUSED) goto paused;
    goto running;
  } else if (step_type == DEBUGGER_STEP_OUT) {
    res = HandleStepOut(info, ctx, cur_pc);
    if (res == JS_DEBUGGER_PAUSED) goto paused;
    goto running;
  } else if (step_type == DEBUGGER_STEP) {
    res = HandleStepOver(info, ctx, cur_pc);
    if (res == JS_DEBUGGER_PAUSED) goto paused;
    goto running;
  }
paused:
  info->step_type = 0;
  info->step_statement = false;
  info->next_statement_count = 0;
  return JS_DEBUGGER_PAUSED;
running:
  return JS_DEBUGGER_RUN;
}

// true: continue running
// false: pause
bool DebuggerNeedProcess(LEPUSDebuggerInfo *info, LEPUSContext *ctx) {
  uint8_t step_type = info->step_type;
  const uint8_t *cur_pc = ctx->debugger_info->debugger_current_pc;
  if (step_type) {
    int32_t line = -1;
    int64_t column = -1;
    int32_t script_id = 0;
    GetDebuggerCurrentLocation(ctx, cur_pc, line, column, script_id);
    int32_t stack_depth = GetDebuggerStackDepth(ctx);

    auto &step_location = info->step_location;
    int32_t step_line = step_location.line, step_depth = info->step_depth,
            step_script_id = step_location.script_id;
    int64_t step_column = step_location.column;

    if ((stack_depth == step_depth && line == step_line &&
         column == step_column && script_id == step_script_id &&
         info->step_over_valid) ||
        (line == 0 && column == 0)) {
      return true;
    }
    info->step_over_valid = 0;
  }

  auto &break_map = info->break_bytecode_map;
  if (info->breakpoints_is_active && break_map.count(cur_pc)) {
    LEPUSValue bp_id = break_map[cur_pc];
    // find the right breakpoint
    int32_t bp_num = info->breakpoints_num;
    for (int32_t i = 0; i < bp_num; i++) {
      LEPUSBreakpoint *hit_bp = info->bps + i;
      if (!hit_bp) continue;
      LEPUSValue id_str = hit_bp->breakpoint_id;
      if (LEPUS_VALUE_GET_PTR(id_str) == LEPUS_VALUE_GET_PTR(bp_id) &&
          SatisfyCondition(info, ctx, hit_bp)) {
        // current position is a breakpoint
        PauseAtBreakpoint(info, hit_bp, cur_pc);
        return false;
      }
    }
  }

  // if not a breakpoint, handle stepping
  if (step_type && !HandleStepping(info, ctx, cur_pc)) {
    goto paused;
  }

  return true;

paused:
  SendPausedEvent(info, cur_pc, LEPUS_UNDEFINED, "debugCommand");
  return false;
}

// return current frame stack depth
uint32_t GetDebuggerStackDepth(LEPUSContext *ctx) {
  uint32_t stack_depth = 0;
  struct LEPUSStackFrame *sf = ctx->rt->current_stack_frame;
  while (sf != NULL) {
    sf = sf->prev_frame;
    stack_depth++;
  }
  return stack_depth;
}

// given current pc, return line and column number
void GetDebuggerCurrentLocation(LEPUSContext *ctx, const uint8_t *cur_pc,
                                int32_t &line, int64_t &column,
                                int32_t &script_id) {
  struct LEPUSStackFrame *sf = ctx->rt->current_stack_frame;
  if (!sf) return;
  GetCurrentLocation(ctx, sf, cur_pc, line, column, script_id);
}

/**
 * @brief construct scriptParsed message
 */
LEPUSValue GetMultiScriptParsedInfo(LEPUSContext *ctx,
                                    LEPUSScriptSource *script) {
  LEPUSValue script_parsed_params = LEPUS_NewObject(ctx);
  if (LEPUS_IsException(script_parsed_params)) {
    return LEPUS_UNDEFINED;
  }
  HandleScope func_scope(ctx, &script_parsed_params, HANDLE_TYPE_LEPUS_VALUE);
  int32_t script_id = script ? script->id : -1;
  LEPUSValue str = LEPUS_ToString(ctx, LEPUS_NewInt32(ctx, script_id));
  func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
  DebuggerSetPropertyStr(ctx, script_parsed_params, "scriptId", str);
  const char *url = script ? script->url : nullptr;
  const char *ret_url = "";
  int32_t has_source_url = 0;
  if (url && url[0] != '\0') {
    ret_url = url;
    has_source_url = 1;
  }
  str = LEPUS_NewString(ctx, ret_url);
  DebuggerSetPropertyStr(ctx, script_parsed_params, "url", str);
  DebuggerSetPropertyStr(ctx, script_parsed_params, "hasSourceURL",
                         LEPUS_NewBool(ctx, has_source_url));

  DebuggerSetPropertyStr(ctx, script_parsed_params, "startLine",
                         LEPUS_NewInt32(ctx, 0));
  DebuggerSetPropertyStr(
      ctx, script_parsed_params, "endLine",
      LEPUS_NewInt32(ctx, script ? script->end_line + 1 : 0));
  DebuggerSetPropertyStr(ctx, script_parsed_params, "startColumn",
                         LEPUS_NewInt32(ctx, 0));
  DebuggerSetPropertyStr(ctx, script_parsed_params, "endColumn",
                         LEPUS_NewInt32(ctx, 0));
  int32_t execution_context_id = GetExecutionContextId(ctx);
  DebuggerSetPropertyStr(ctx, script_parsed_params, "executionContextId",
                         LEPUS_NewInt32(ctx, execution_context_id));
  const char *script_hash = script ? script->hash : nullptr;
  if (script_hash) {
    str = LEPUS_NewString(ctx, script_hash);
    DebuggerSetPropertyStr(ctx, script_parsed_params, "hash", str);
  }
  const char *script_source = script ? script->source : nullptr;
  DebuggerSetPropertyStr(
      ctx, script_parsed_params, "length",
      LEPUS_NewInt32(ctx, script_source ? (int32_t)strlen(script_source) : 0));
  DebuggerSetPropertyStr(
      ctx, script_parsed_params, "scriptLanguage",
      LEPUS_DupValue(ctx, ctx->debugger_info->literal_pool.capital_javascript));
  const char *source_map_url = script->source_map_url;

  if (!source_map_url) {
    source_map_url = "";
  }
  str = LEPUS_NewString(ctx, source_map_url);
  DebuggerSetPropertyStr(ctx, script_parsed_params, "sourceMapURL", str);

  return script_parsed_params;
}

// stop at first bytecode
void HandleStopAtEntry(DebuggerParams *debugger_options) {
  HandlePauseOnNextStatement(debugger_options->ctx);
}

// pause on next statement
void HandlePauseOnNextStatement(LEPUSContext *ctx) {
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  info->pause_on_next_statement = false;
  SendPausedEvent(info, ctx->debugger_info->debugger_current_pc,
                  LEPUS_UNDEFINED,
                  info->pause_on_next_statement_reason
                      ? info->pause_on_next_statement_reason
                      : "stopAtEntry");
  if (info->pause_on_next_statement_reason && !ctx->rt->gc_enable) {
    LEPUS_FreeCString(ctx, info->pause_on_next_statement_reason);
  }
  info->pause_on_next_statement_reason = nullptr;
}

/**
 * @brief handle "Debugger.enable"
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-enable
void HandleEnable(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSValue message = debugger_options->message;
    LEPUSDebuggerInfo *info = ctx->debugger_info;

    LEPUSValue result = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(result)) {
      return;
    }
    HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
    DebuggerSetPropertyStr(ctx, result, "debuggerId",
                           LEPUS_DupValue(ctx, info->literal_pool.minus_one));

    LEPUSValue view_id_val = LEPUS_GetPropertyStr(ctx, message, "view_id");
    int32_t view_id = -1;
    if (!LEPUS_IsUndefined(view_id_val)) {
      LEPUS_ToInt32(ctx, &view_id, view_id_val);
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, view_id_val);
    }

    bool is_already_enabled = false;
    bool is_paused = false;
    info->breakpoints_is_active = 1;
    if (view_id != -1) {
      // get if session is enabled and if session is paused
      GetSessionState(ctx, view_id, &is_already_enabled, &is_paused);
      // set session enable state
      SetSessionEnableState(ctx, view_id, DEBUGGER_ENABLE);
    } else {
      is_already_enabled = !!(info->is_debugger_enabled);
    }
    // send response for debugger.enable
    SendResponse(ctx, message, result);
    // if the session is already enabled, do not send Debugger.scriptParsed
    // event
    if (!is_already_enabled) {
      ctx->debugger_mode = 1;
      info->is_debugger_enabled += 1;
      int32_t script_num = info->script_num;
      for (int32_t index = 0; index < script_num; ++index) {
        LEPUSScriptSource *script = GetScriptByIndex(ctx, index);
        if (!script) continue;
        const char *url = script ? script->url : nullptr;
        if (url && strcmp(url, "<input>") == 0) {
          continue;
        }
        SendScriptParsedNotificationWithViewID(ctx, script, view_id);
      }
    }
    // if the session is paused, send Debugger.paused event
    if (is_paused) {
      SendPausedEventWithoutPause(ctx, info,
                                  ctx->debugger_info->debugger_current_pc,
                                  LEPUS_UNDEFINED, "debugCommand", view_id);
    }
  }
}

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-setSkipAllPauses
void HandleSkipAllPauses(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSValue message = debugger_options->message;
    LEPUSDebuggerInfo *info = ctx->debugger_info;
    LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");
    LEPUSValue params_skip = LEPUS_GetPropertyStr(ctx, params, "skip");
    int32_t is_skip = LEPUS_VALUE_GET_BOOL(params_skip);
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params);
    if (is_skip) {
      info->breakpoints_is_active_before = info->breakpoints_is_active;
      info->exception_breakpoint_before = info->exception_breakpoint;
      info->breakpoints_is_active = 0;
      info->exception_breakpoint = 0;
    } else {
      info->breakpoints_is_active = info->breakpoints_is_active_before;
      info->exception_breakpoint = info->exception_breakpoint_before;
    }
    LEPUSValue result = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(result)) {
      return;
    }
    HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
    SendResponse(ctx, message, result);
  }
}

/**
 * @brief handle "Debugger.getScriptSource" protocol
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-getScriptSource
void HandleGetScriptSource(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSValue message = debugger_options->message;
    if (!CheckEnable(ctx, message, DEBUGGER_ENABLE)) return;
    LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");
    LEPUSValue params_scriptId = LEPUS_GetPropertyStr(ctx, params, "scriptId");
    int32_t script_id;
    LEPUS_ToInt32(ctx, &script_id, params_scriptId);
    if (!ctx->rt->gc_enable) {
      LEPUS_FreeValue(ctx, params_scriptId);
      LEPUS_FreeValue(ctx, params);
    }

    const char *script_source = GetScriptSourceByScriptId(ctx, script_id);

    if (script_source) {
      LEPUSValue result = LEPUS_NewObject(ctx);
      if (LEPUS_IsException(result)) {
        return;
      }
      HandleScope block_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
      LEPUSValue str = LEPUS_NewString(ctx, script_source);
      block_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
      DebuggerSetPropertyStr(ctx, result, "scriptSource", str);
      SendResponse(ctx, message, result);
    }
  }
}

/**
 * @brief handle "Debugger.pause" protocol
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-pause
void HandlePause(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSDebuggerInfo *info = ctx->debugger_info;
    LEPUSValue message = debugger_options->message;
    if (!CheckEnable(ctx, message, DEBUGGER_ENABLE)) return;
    const uint8_t *cur_pc = ctx->debugger_info->debugger_current_pc;
    LEPUSValue result = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(result)) {
      return;
    }
    HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
    SendResponse(ctx, message, result);
    if (!ctx->rt->current_stack_frame) return;
    SendPausedEvent(info, cur_pc, LEPUS_UNDEFINED, "other");
  }
}

void DeleteConsoleMessageWithRID(LEPUSContext *ctx, int32_t rid) {
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  if (!info) {
    return;
  }
  LEPUSValue msg = info->console.messages;
  int32_t msg_len = info->console.length;
  LEPUSValue new_msg = LEPUS_NewArray(ctx);
  int32_t new_msg_len = 0;
  HandleScope func_scope(ctx, &new_msg, HANDLE_TYPE_LEPUS_VALUE);

  for (int32_t i = 0; i < msg_len; i++) {
    LEPUSValue console_message = LEPUS_GetPropertyUint32(ctx, msg, i);
    if (!LEPUS_IsUndefined(console_message)) {
      LEPUSValue rid_val = LEPUS_GetPropertyStr(ctx, console_message, "rid");
      if (!LEPUS_IsUndefined(rid_val)) {
        int32_t each_rid = -1;
        LEPUS_ToInt32(ctx, &each_rid, rid_val);
        if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, rid_val);
        if (each_rid != rid) {
          LEPUS_SetPropertyUint32(ctx, new_msg, new_msg_len++,
                                  LEPUS_DupValue(ctx, console_message));
        }
      } else {
        LEPUS_SetPropertyUint32(ctx, new_msg, new_msg_len++,
                                LEPUS_DupValue(ctx, console_message));
      }
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, console_message);
    }
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, msg);
  info->console.messages = new_msg;
  info->console.length = new_msg_len;
}

void SendConsoleAPICalled(LEPUSContext *ctx, LEPUSValue *msg, bool has_rid) {
  uint32_t argc = LEPUS_GetLength(ctx, *msg);
  LEPUSValue params = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &params, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue args = LEPUS_NewArray(ctx);
  func_scope.PushHandle(&args, HANDLE_TYPE_LEPUS_VALUE);
  DebuggerSetPropertyStr(ctx, params, "type",
                         LEPUS_GetPropertyStr(ctx, *msg, "tag"));
  int32_t execution_context_id = GetExecutionContextId(ctx);
  DebuggerSetPropertyStr(ctx, params, "executionContextId",
                         LEPUS_NewInt32(ctx, execution_context_id));
  DebuggerSetPropertyStr(ctx, params, "timestamp",
                         LEPUS_GetPropertyStr(ctx, *msg, "timestamp"));
  DebuggerSetPropertyStr(ctx, params, "args", args);
  LEPUSValue stack_trace = LEPUS_GetPropertyStr(ctx, *msg, "stackTrace");
  if (!LEPUS_IsUndefined(stack_trace)) {
    DebuggerSetPropertyStr(ctx, params, "stackTrace", stack_trace);
  }

  int rid = -1;
  const char *gid = nullptr;
  bool is_lepus_console = false;
  if (has_rid) {
    LEPUSValue rid_val = LEPUS_GetPropertyStr(ctx, *msg, "rid");
    if (!LEPUS_IsUndefined(rid_val)) {
      LEPUS_ToInt32(ctx, &rid, rid_val);
    }
    LEPUSValue gid_val = LEPUS_GetPropertyStr(ctx, *msg, "gid");
    if (!LEPUS_IsUndefined(gid_val)) {
      gid = LEPUS_ToCString(ctx, gid_val);
      func_scope.PushHandle(reinterpret_cast<void *>(&gid),
                            HANDLE_TYPE_CSTRING);
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, gid_val);
    }
    LEPUSValue js_console = LEPUS_GetPropertyStr(ctx, *msg, "lepusConsole");
    if (!LEPUS_IsUndefined(js_console)) {
      is_lepus_console = true;
    }
  }
  LEPUSValue v2 = LEPUS_UNDEFINED;
  func_scope.PushHandle(&v2, HANDLE_TYPE_LEPUS_VALUE);
  for (int idx = 0; idx < argc; idx++) {
    LEPUSValue v = LEPUS_GetPropertyUint32(ctx, *msg, idx);
    v2 = GetRemoteObject(ctx, v, 0, 0);  // free v
    LEPUS_SetPropertyUint32(ctx, args, idx, v2);
  }
  LEPUSValue str = LEPUS_UNDEFINED;
  func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
  if (has_rid) {
    if (rid != -1) {
      DebuggerSetPropertyStr(ctx, params, "runtimeId",
                             LEPUS_NewInt32(ctx, rid));
    }
    if (gid) {
      str = LEPUS_NewString(ctx, gid);
      DebuggerSetPropertyStr(ctx, params, "groupId", str);
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, gid);
    }
    if (is_lepus_console) {
      str = LEPUS_NewString(ctx, "lepus");
      DebuggerSetPropertyStr(ctx, params, "consoleTag", str);
    }
  }
  SendNotification(ctx, "Runtime.consoleAPICalled", params, -1);
}

void SendConsoleAPICalledNotificationWithRID(LEPUSContext *ctx,
                                             LEPUSValue *msg) {
  SendConsoleAPICalled(ctx, msg, true);
}

/**
 * @brief send console-message notification to devtools frontend
 * ref:
 * https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#event-consoleAPICalled
 */
void SendConsoleAPICalledNotification(LEPUSContext *ctx, LEPUSValue *msg) {
  SendConsoleAPICalled(ctx, msg);
}

/**
 * @brief use this function to handle "Debugger.stepInto", "Debugger.stepOver",
 * "Debugger.stepOut" etc
 */
void HandleStep(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  LEPUSValue message = debugger_options->message;
  if (!CheckEnable(ctx, message, DEBUGGER_ENABLE)) return;
  const uint8_t *cur_pc = ctx->debugger_info->debugger_current_pc;
  uint8_t step_mode = debugger_options->type;
  if (ctx) {
    LEPUSDebuggerInfo *info = ctx->debugger_info;
    info->step_type = step_mode;
    if (step_mode) {
      info->step_over_valid = 1;
    }
    // record the location and stack depth
    int32_t line = -1;
    int64_t column = -1;
    int32_t script_id = 0;
    int32_t stack_depth = GetDebuggerStackDepth(ctx);
    GetDebuggerCurrentLocation(ctx, cur_pc, line, column, script_id);

    info->step_location.line = line;
    info->step_location.column = column;
    info->step_location.script_id = script_id;
    info->step_depth = stack_depth;

    LEPUSValue result = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(result)) {
      return;
    }
    HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
    SendResponse(ctx, message, result);

    LEPUSValue resumed_params = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(resumed_params)) {
      return;
    }
    func_scope.PushHandle(&resumed_params, HANDLE_TYPE_LEPUS_VALUE);
    // continue running
    // send "Debugger.resumed" event
    // ref:
    // https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-resumed
    SendNotification(ctx, "Debugger.resumed", resumed_params);
    QuitMessageLoopOnPause(ctx);
  }
}

/**
 * @brief handle "Debugger.resume" protocol
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-resume
void HandleResume(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSValue message = debugger_options->message;
    if (!CheckEnable(ctx, message, DEBUGGER_ENABLE)) return;
    const uint8_t *cur_pc = ctx->debugger_info->debugger_current_pc;
    LEPUSDebuggerInfo *info = ctx->debugger_info;
    info->step_type = DEBUGGER_STEP_CONTINUE;
    info->step_over_valid = 1;
    int32_t line = -1;
    int64_t column = -1;
    int32_t script_id = 0;
    GetDebuggerCurrentLocation(ctx, cur_pc, line, column, script_id);

    info->step_location.line = line;
    info->step_location.column = column;
    info->step_location.script_id = script_id;
    info->step_depth = GetDebuggerStackDepth(ctx);

    LEPUSValue result = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(result)) {
      return;
    }
    HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
    SendResponse(ctx, message, result);

    LEPUSValue resumed_params = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(resumed_params)) {
      return;
    }
    func_scope.PushHandle(&resumed_params, HANDLE_TYPE_LEPUS_VALUE);
    // send "Debugger.resumed" event
    // ref:
    // https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#event-resumed
    SendNotification(ctx, "Debugger.resumed", resumed_params);
    QuitMessageLoopOnPause(ctx);
  }
}

/**
 * @brief if there is an exception, send paused event
 */
void HandleSetPauseOnExceptions(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSValue message = debugger_options->message;
    LEPUSDebuggerInfo *info = ctx->debugger_info;
    LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");
    LEPUSValue params_state = LEPUS_GetPropertyStr(ctx, params, "state");
    const char *state = LEPUS_ToCString(ctx, params_state);
    if (!ctx->rt->gc_enable) {
      LEPUS_FreeValue(ctx, params);
      LEPUS_FreeValue(ctx, params_state);
    }
    if (state) {
      if (strcmp("uncaught", state) == 0 || strcmp("all", state) == 0) {
        info->exception_breakpoint = 1;
      } else if (strcmp("none", state) == 0) {
        info->exception_breakpoint = 0;
      }
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, state);

      LEPUSValue result = LEPUS_NewObject(ctx);
      if (LEPUS_IsException(result)) {
        return;
      }
      HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
      SendResponse(ctx, message, result);
    }
  }
}

/**
 * @brief handle "Debugger.disable"
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-disable
void HandleDisable(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSDebuggerInfo *info = ctx->debugger_info;
    LEPUSValue message = debugger_options->message;
    if (!CheckEnable(ctx, message, DEBUGGER_ENABLE)) return;
    // end debugging mode
    // when get debugger.disable, quit pause
    LEPUSValue result = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(result)) {
      return;
    }
    HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue view_id_val = LEPUS_GetPropertyStr(ctx, message, "view_id");
    int32_t view_id = -1;
    if (!LEPUS_IsUndefined(view_id_val)) {
      LEPUS_ToInt32(ctx, &view_id, view_id_val);
    }
    bool is_already_enabled = false;
    bool is_paused = false;

    if (view_id != -1) {
      GetSessionState(ctx, view_id, &is_already_enabled, &is_paused);
      if (is_already_enabled) {
        info->is_debugger_enabled -= 1;
      }
      // set session enable state
      SetSessionEnableState(ctx, view_id, DEBUGGER_DISABLE);
    } else {
      if (info->is_debugger_enabled) {
        info->is_debugger_enabled -= 1;
      }
      LEPUSValue val = LEPUS_NewObject(ctx);
      func_scope.PushHandle(&val, HANDLE_TYPE_LEPUS_VALUE);
      SendNotification(ctx, "Debugger.resumed", val);
      QuitMessageLoopOnPause(ctx);
    }
    SendResponse(ctx, message, result);
  }
}

// free debugger
void QJSDebuggerFree(LEPUSContext *ctx) {
  auto *&info = ctx->debugger_info;
  if (!info || --info->ref_count > 0) return;
  delete info;
  info = nullptr;
  return;
}

// process protocol message sent here when then paused
void ProcessPausedMessages(LEPUSContext *ctx, const char *message) {
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  if (!info) return;
  if (message && message[0] != '\0') {
    PushBackQueue(GetDebuggerMessageQueue(info), message);
  }
  ProcessProtocolMessages(info);
}

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-setAsyncCallStackDepth
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-setAsyncCallStackDepth
void HandleSetAsyncCallStackDepth(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSValue message = debugger_options->message;
    if (!CheckEnable(ctx, message, DEBUGGER_ENABLE) &&
        !CheckEnable(ctx, message, RUNTIME_ENABLE))
      return;
    LEPUSValue param = LEPUS_GetPropertyStr(ctx, message, "params");
    LEPUSValue param_max_depth = LEPUS_GetPropertyStr(ctx, param, "maxDepth");

    int32_t max_depth = 0;
    LEPUS_ToInt32(ctx, &max_depth, param_max_depth);
    ctx->debugger_info->max_async_call_stack_depth = max_depth;
    if (!ctx->rt->gc_enable) {
      LEPUS_FreeValue(ctx, param);
      LEPUS_FreeValue(ctx, param_max_depth);
    }
    LEPUSValue result = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(result)) {
      return;
    }
    HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
    SendResponse(ctx, message, result);
  }
}

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#type-Location
LEPUSValue GetLocation(LEPUSContext *ctx, int32_t line, int64_t column,
                       int32_t script_id) {
  LEPUSValue ret = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &ret, HANDLE_TYPE_LEPUS_VALUE);
  DebuggerSetPropertyStr(ctx, ret, "lineNumber", LEPUS_NewInt32(ctx, line));
  DebuggerSetPropertyStr(ctx, ret, "columnNumber", LEPUS_NewInt64(ctx, column));
  LEPUSValue column_num = LEPUS_NewInt32(ctx, script_id);
  LEPUSValue str = LEPUS_ToString(ctx, column_num);
  func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
  DebuggerSetPropertyStr(ctx, ret, "scriptId", str);
  return ret;
}

static void GetExpression(char *expression, LEPUSValue new_value,
                          const char *variable_name, const char *value) {
  *expression = '\0';
  strcat(expression, variable_name);
  strcat(expression, "=");
  if (LEPUS_IsString(new_value)) {
    // string, add ""
    strcat(expression, "\"");
  }
  strcat(expression, value);
  if (LEPUS_IsString(new_value)) {
    strcat(expression, "\"");
  }
}

static void GetSetVariableValueParams(LEPUSContext *ctx, LEPUSValue params,
                                      int32_t *scope_num,
                                      const char **variable_name,
                                      LEPUSValue *new_value,
                                      const char **new_value_str,
                                      const char **frame_id) {
  LEPUSValue param_scope_num = LEPUS_GetPropertyStr(ctx, params, "scopeNumber");
  LEPUS_ToInt32(ctx, scope_num, param_scope_num);

  LEPUSValue param_variable_name =
      LEPUS_GetPropertyStr(ctx, params, "variableName");
  *variable_name = LEPUS_ToCString(ctx, param_variable_name);

  LEPUSValue param_new_value = LEPUS_GetPropertyStr(ctx, params, "newValue");
  *new_value = LEPUS_GetPropertyStr(ctx, param_new_value, "value");

  LEPUSValue param_call_frame_id =
      LEPUS_GetPropertyStr(ctx, params, "callFrameId");
  *frame_id = LEPUS_ToCString(ctx, param_call_frame_id);

  LEPUSValue value_str = LEPUS_ToString(ctx, *new_value);
  HandleScope func_scope(ctx, &value_str, HANDLE_TYPE_LEPUS_VALUE);
  *new_value_str = LEPUS_ToCString(ctx, value_str);
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, param_scope_num);
    LEPUS_FreeValue(ctx, param_variable_name);
    LEPUS_FreeValue(ctx, param_new_value);
    LEPUS_FreeValue(ctx, param_call_frame_id);
    LEPUS_FreeValue(ctx, value_str);
    LEPUS_FreeValue(ctx, params);
  }
  return;
}

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-setVariableValue
void HandleSetVariableValue(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  if (ctx) {
    LEPUSValue message = debugger_options->message;
    if (!CheckEnable(ctx, message, DEBUGGER_ENABLE)) return;
    LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");
    int32_t scope_num = 0;
    const char *variable_name = NULL;
    LEPUSValue new_value = LEPUS_UNDEFINED;
    const char *new_value_str = NULL;
    const char *frame_id = NULL;
    HandleScope func_scope(ctx, reinterpret_cast<void *>(&variable_name),
                           HANDLE_TYPE_CSTRING);
    func_scope.PushHandle(&new_value, HANDLE_TYPE_LEPUS_VALUE);
    func_scope.PushHandle(reinterpret_cast<void *>(&new_value_str),
                          HANDLE_TYPE_CSTRING);
    func_scope.PushHandle(reinterpret_cast<void *>(&frame_id),
                          HANDLE_TYPE_CSTRING);
    GetSetVariableValueParams(ctx, params, &scope_num, &variable_name,
                              &new_value, &new_value_str, &frame_id);

    int32_t expression_len = strlen(variable_name) + strlen(new_value_str) + 6;
    char *expression = static_cast<char *>(lepus_malloc(
        ctx, (sizeof(char) * expression_len), ALLOC_TAG_WITHOUT_PTR));
    if (expression) {
      func_scope.PushHandle(reinterpret_cast<void *>(expression),
                            HANDLE_TYPE_DIR_HEAP_OBJ);
      GetExpression(expression, new_value, variable_name, new_value_str);
      LEPUSValue expression_val = LEPUS_NewString(ctx, expression);
      func_scope.PushHandle(&expression_val, HANDLE_TYPE_LEPUS_VALUE);
      {
        PCScope ps(ctx);
        LEPUSValue ret = DebuggerEvaluate(ctx, frame_id, expression_val);
        if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
      }
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, expression_val);
    }
    if (!ctx->rt->gc_enable) {
      lepus_free(ctx, expression);

      LEPUS_FreeCString(ctx, new_value_str);
      LEPUS_FreeCString(ctx, frame_id);
      LEPUS_FreeCString(ctx, variable_name);
      LEPUS_FreeValue(ctx, new_value);
    }

    LEPUSValue result = LEPUS_NewObject(ctx);
    func_scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
    SendResponse(ctx, message, result);
  }
}

QJS_HIDE void GetConsoleMessages(LEPUSContext *ctx) {
  auto *info = ctx->debugger_info;
  if (info == nullptr) return;

  auto all_msg = info->console.messages;
  auto length = info->console.length;

  for (int32_t i = 0; i < length; ++i) {
    auto message = LEPUS_GetPropertyUint32(ctx, all_msg, i);
    if (LEPUS_VALUE_IS_OBJECT(message)) {
      OnConsoleMessageInspect(ctx, message);
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, message);
  }
  return;
}

void SetContextConsoleInspect(LEPUSContext *ctx, bool enable) {
  ctx->console_inspect = enable;
  if (enable) {
    GetConsoleMessages(ctx);
  }
  return;
}

QJS_STATIC void OnConsoleMessageInspect(LEPUSContext *ctx, LEPUSValue message) {
  LEPUSValue console_protocol = LEPUS_NewObject(ctx);
  HandleScope func_scope{ctx, &console_protocol, HANDLE_TYPE_LEPUS_VALUE};
  /*
  {
    type: "log", // "error"...
    args: [
      {
        type: string,
        objectid: string
        ....
      }
    ]
  }
  */

  LEPUS_SetPropertyStr(ctx, console_protocol, "type",
                       LEPUS_GetPropertyStr(ctx, message, "tag"));
  auto rid = LEPUS_GetPropertyStr(ctx, message, "rid");
  int32_t runtime_id = -1;
  if (!LEPUS_IsUndefined(rid)) {
    LEPUS_ToInt32(ctx, &runtime_id, rid);
  }

  uint32_t length = LEPUS_GetLength(ctx, message);
  LEPUSValue console_message = LEPUS_NewArray(ctx);
  func_scope.PushHandle(&console_message, HANDLE_TYPE_LEPUS_VALUE);
  for (uint32_t i{0}; i < length; ++i) {
    LEPUSValue argv = LEPUS_GetPropertyUint32(ctx, message, i);
    // argv is freed by GetRemoteObject
    LEPUSValue remote_obj = GetRemoteObject(ctx, argv, false, false);
    HandleScope block_scope{ctx, &remote_obj, HANDLE_TYPE_LEPUS_VALUE};
    LEPUS_SetPropertyUint32(ctx, console_message, i, remote_obj);
  }
  LEPUS_SetPropertyStr(ctx, console_protocol, "args", console_message);
  if (auto cb = ctx->rt->debugger_callbacks_.on_console_message) {
    cb(ctx, console_protocol, runtime_id);
  }
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, rid);
    LEPUS_FreeValue(ctx, console_protocol);
  }
  return;
}

LEPUSDebuggerInfo::LEPUSDebuggerInfo(LEPUSContext *ctx_) : ctx{ctx_} {
  HandleScope func_scope{ctx, this, HANDLE_TYPE_DIR_HEAP_OBJ};
  init_list_head(&script_list);
  init_list_head(&bytecode_list);
  message_queue = InitQueue();
  running_state.get_properties_array = LEPUS_NewArray(ctx);
  InitializeStringPool(this);
  InitializeFixedShapeObj(this);
  debugger_current_pc = nullptr;

  if (auto *check_connect = ctx->rt->debugger_callbacks_.is_devtool_on) {
    if (check_connect(ctx->rt)) {
      ctx_->debugger_mode = 1;
    }
  }
  return;
}

QJS_HIDE void DebuggerFreeScript(LEPUSContext *ctx, LEPUSScriptSource *script) {
  ctx->debugger_info->script_num--;
  LEPUSRuntime *rt = ctx->rt;
  list_del(&script->link);
  if (ctx->gc_enable) return;
  lepus_free_rt(rt, script->url);
  lepus_free_rt(rt, script->source);
  lepus_free_rt(rt, script->hash);
  lepus_free_rt(rt, script->source_map_url);
  lepus_free_rt(rt, script);
}

// for shared context qjs debugger: delete qjs debugger script by URL
void DeleteScriptByURL(LEPUSContext *ctx, const char *filename) {
  struct list_head *el, *el1;
  list_for_each_safe(el, el1, &ctx->debugger_info->script_list) {
    auto script = list_entry(el, LEPUSScriptSource, link);
    if (script->url && filename && strcmp(script->url, filename) == 0) {
      DebuggerFreeScript(ctx, script);
    }
  }
}

static void FreeDebuggerScriptAndBytecodeList(LEPUSContext *ctx) {
  struct list_head *el, *el1;
  list_for_each_safe(el, el1, &ctx->debugger_info->script_list) {
    LEPUSScriptSource *script = list_entry(el, LEPUSScriptSource, link);
    DebuggerFreeScript(ctx, script);
  }
  list_for_each_safe(el, el1, &ctx->debugger_info->bytecode_list) {
    list_del(el);
  }
}

LEPUSDebuggerInfo::~LEPUSDebuggerInfo() {
  FreeDebuggerScriptAndBytecodeList(ctx);
  if (auto *qjs_queue = message_queue) {
    DeleteQueue(qjs_queue);
  }

  for (int32_t i = 0; i < breakpoints_num;) {
    DeleteBreakpoint(this, i);
  }
  if (!ctx->gc_enable) {
    LEPUS_FreeValue(ctx, debugger_name);
    lepus_free(ctx, source_code);
    lepus_free(ctx, bps);
    if (pause_on_next_statement_reason) {
      LEPUS_FreeCString(ctx, pause_on_next_statement_reason);
    }
    LEPUS_FreeValue(ctx, running_state.get_properties_array);
    LEPUS_FreeValue(ctx, console.messages);
    FreeFixedShapeObj(this);
    FreeStringPool(this);
  }
  ctx->debugger_mode = 0;
  return;
}

void *LEPUSDebuggerInfo::operator new(std::size_t size, LEPUSContext *ctx) {
  return lepus_malloc(ctx, size, ALLOC_TAG_LEPUSDebuggerInfo);
}

void LEPUSDebuggerInfo::operator delete(void *ptr) {
  auto *info = static_cast<LEPUSDebuggerInfo *>(ptr);
  auto *ctx = info->ctx;
  if (ctx->gc_enable) return;
  lepus_free(ctx, ptr);
  return;
}

void SetJSDebuggerName(LEPUSContext *ctx, const char *name) {
  auto *info = ctx->debugger_info;
  if (ctx->gc_enable) {
    LEPUS_FreeValue(ctx, info->debugger_name);
  }
  info->debugger_name = LEPUS_NewString(ctx, name);
  return;
}
