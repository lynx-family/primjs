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

#include "inspector/debugger/debugger_breakpoint.h"

#include <string>

#include "gc/trace-gc.h"
#include "inspector/debugger/debugger.h"
#include "inspector/debugger_inner.h"
#include "inspector/interface.h"
#include "inspector/protocols.h"

// given the line and column range, return if the current line and column is in
// this range
QJS_STATIC BOOL InRange(int32_t line, int64_t column, int64_t start_line,
                        int64_t start_col, int64_t end_line, int64_t end_col) {
  if (line == start_line && line != end_line) {
    return column >= start_col;
  }
  if (line == end_line && line != start_line) {
    return (end_col != 0 && column <= end_col);
  }

  if (line == start_line && line == end_line) {
    return column >= start_col && column <= end_col;
  }

  return line > start_line && line < end_line;
}

QJS_STATIC bool LineColExist(LEPUSContext *ctx, LEPUSValue locations,
                             int32_t line, int64_t column) {
  int len = LEPUS_GetLength(ctx, locations);
  for (int i = 0; i < len; i++) {
    HandleScope block_scope{ctx->rt};
    LEPUSValue location = LEPUS_GetPropertyUint32(ctx, locations, i);
    block_scope.PushHandle(&location, HANDLE_TYPE_LEPUS_VALUE);
    int32_t each_line = -1;
    int64_t each_column = -1;
    LEPUSValue line_number = LEPUS_GetPropertyStr(ctx, location, "lineNumber");
    block_scope.PushHandle(&line_number, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue column_number =
        LEPUS_GetPropertyStr(ctx, location, "columnNumber");
    block_scope.PushHandle(&column_number, HANDLE_TYPE_LEPUS_VALUE);
    LEPUS_ToInt32(ctx, &each_line, line_number);
    LEPUS_ToInt64(ctx, &each_column, column_number);
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, location);
    if (line == each_line && column == each_column) {
      return true;
    }
  }
  return false;
}

QJS_STATIC bool AdjustSatisfy(int32_t line, int64_t column, int32_t bp_line,
                              int64_t bp_column, int32_t closed_line,
                              int64_t closed_column) {
  if (closed_line == -1) return true;
  bool condition1 = (line != bp_line && line - bp_line < closed_line - bp_line);
  if (condition1) return true;

  bool condition2 = (line == bp_line && line == closed_line &&
                     column - bp_column < closed_column - bp_column);
  if (condition2) return true;

  bool condition3 = (line == bp_line && bp_line != closed_line);
  return condition3;
}

QJS_HIDE bool NotInCurrentFunc(LEPUSFunctionBytecode *b, int32_t script_id,
                               int64_t bp_line) {
  if (!b || !b->has_debug) return true;
  if ((b->script && b->script->id != script_id) ||
      (b->debug.line_num - 1 > bp_line)) {
    return true;
  }
  return false;
}

QJS_HIDE LEPUSScriptSource *GetScriptByHash(LEPUSContext *ctx,
                                            const char *hash) {
  struct list_head *el;
  list_for_each(el, &ctx->debugger_info->script_list) {
    LEPUSScriptSource *script = list_entry(el, LEPUSScriptSource, link);
    if (script && script->hash && hash && strcmp(script->hash, hash) == 0) {
      return script;
    }
  }
  return NULL;
}

// given pc, return where this pc is
QJS_STATIC void GetPCLineColumn(LEPUSContext *ctx, const uint8_t *&p, int &pc,
                                int &pc_prev, const uint8_t *p_end,
                                struct LEPUSFunctionBytecode *b, int32_t &line,
                                int64_t &column) {
  pc_prev = pc;
  if (p < p_end) {
    int64_t v;
    int ret;
    unsigned int op;
    op = *(p)++;
    if (op == 0) {
      uint64_t val;
      ret = get_leb128_u64(&val, p, p_end);
      if (ret < 0) goto fail;
      pc += val;
      p += ret;
      ret = get_sleb128_u64(&v, p, p_end);
      if (ret < 0) {
      fail:
        return;
      }
      p += ret;
    } else {
      op -= PC2LINE_OP_FIRST;
      pc += (op / PC2LINE_RANGE);
    }
  }
  int64_t line_column_num = find_line_num(ctx, b, pc_prev);
  ComputeLineCol(line_column_num, &line, &column);
  return;
}

QJS_HIDE LEPUSScriptSource *GetScriptByScriptURL(LEPUSContext *ctx,
                                                 const char *filename) {
  struct list_head *el;
  list_for_each(el, &ctx->debugger_info->script_list) {
    LEPUSScriptSource *script = list_entry(el, LEPUSScriptSource, link);
    if (script && script->url && filename &&
        strcmp(script->url, filename) == 0) {
      return script;
    }
  }
  return NULL;
}

QJS_HIDE void DecreaseBpNum(LEPUSContext *ctx, LEPUSFunctionBytecode *b) {
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  if (!info) return;
  struct list_head *el;
  // skip the function bytecode which is already freed
  list_for_each(el, &ctx->debugger_info->bytecode_list) {
    LEPUSFunctionBytecode *each_b = list_entry(el, LEPUSFunctionBytecode, link);
    if (each_b == b) {
      --b->bp_num;
      break;
    }
  }
}

/**
 * @brief adjust breakpoint location to the nearest bytecode
 */
QJS_HIDE void AdjustBreakpoint(LEPUSDebuggerInfo *info, const char *url,
                               const char *hash, LEPUSBreakpoint *bp) {
  LEPUSContext *ctx = info->ctx;
  LEPUSScriptSource *bsrc = NULL;
  if (url && url[0] != '\0') {
    bsrc = GetScriptByScriptURL(ctx, url);
  } else if (hash && hash[0] != '\0') {
    bsrc = GetScriptByHash(ctx, hash);
  }
  if (!bsrc) {
    return;
  }
  int64_t closed_column = -1;
  int32_t closed_line = -1;
  struct list_head *el;
  int32_t bp_line = bp->line;
  int32_t bp_column = bp->column;
  list_for_each(el, &ctx->debugger_info->bytecode_list) {
    LEPUSFunctionBytecode *b = list_entry(el, LEPUSFunctionBytecode, link);
    if (!b || !b->has_debug) continue;
    if (b->script && b->script != bsrc) continue;
    if (!b->script && url && strcmp(url, "lepus.js") != 0) continue;

    const uint8_t *p_end, *p, *p_prev;
    int pc, pc_prev;

    p_prev = p = b->debug.pc2line_buf;
    p_end = p + b->debug.pc2line_len;
    pc = 0;
    while (p_prev < p_end) {
      int32_t line = -1;
      int64_t column = -1;
      p_prev = p;
      GetPCLineColumn(ctx, p, pc, pc_prev, p_end, b, line, column);
      if (line < bp_line || line < b->debug.line_num - 1 ||
          (closed_line != -1 && line > closed_line) ||
          (line == bp_line && column < bp_column)) {
        continue;
      }

      if (AdjustSatisfy(line, column, bp_line, bp_column, closed_line,
                        closed_column)) {
        closed_line = line;
        closed_column = column;
      }
    }
  }
  if (closed_column >= 0 && closed_line >= 0) {
    bp->column = closed_column;
    bp->line = closed_line;
  }

  bp->script_id = bp->script_id == -1 ? -1 : bsrc->id;
  return;
}

QJS_HIDE void AdjustBreakpoints(LEPUSContext *ctx, LEPUSScriptSource *script) {
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  if (!info) return;
  int32_t bp_num = info->breakpoints_num;
  for (size_t idx = 0; idx < bp_num; ++idx) {
    if (LEPUSBreakpoint *bp = info->bps + idx) {
      if (!bp->pc && bp->script_url && script->url &&
          !strcmp(bp->script_url, script->url)) {
        bp->script_id = script->id;
        AdjustBreakpoint(info, bp->script_url, nullptr, bp);
        if (const uint8_t *pc = FindBreakpointBytecode(ctx, bp)) {
          info->break_bytecode_map.try_emplace(pc, bp->breakpoint_id);
          bp->pc = pc;
        }
      }
    }
  }
}

QJS_HIDE const uint8_t *FindBreakpointBytecode(LEPUSContext *ctx,
                                               LEPUSBreakpoint *bp) {
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  if (!info) return nullptr;
  struct list_head *el;
  list_for_each(el, &ctx->debugger_info->bytecode_list) {
    LEPUSFunctionBytecode *b = list_entry(el, LEPUSFunctionBytecode, link);
    if (NotInCurrentFunc(b, bp->script_id, bp->line)) {
      continue;
    }
    const uint8_t *p_end, *p, *p_prev;
    int pc, pc_prev;
    p_prev = p = b->debug.pc2line_buf;
    p_end = p + b->debug.pc2line_len;
    pc = 0;
    while (p_prev < p_end) {
      int32_t line = -1;
      int64_t column = -1;
      p_prev = p;
      GetPCLineColumn(ctx, p, pc, pc_prev, p_end, b, line, column);
      if (line == -1 && column == -1) {
        continue;
      }
      if (bp->line == line && bp->column == column) {
        // find the break bytecode
        b->bp_num++;
        bp->b = b;
        return (pc_prev + b->byte_code_buf + 1);
      }
    }
  }
  return nullptr;
}

// traverse all the funciton and traverse all the pc. find all the pc in the
// given range
QJS_HIDE void GetPossibleBreakpointsByScriptId(
    LEPUSContext *ctx, int32_t script_id, int64_t start_line, int64_t start_col,
    int64_t end_line, int64_t end_col, LEPUSValue locations) {
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  if (!info) return;
  int32_t id = 0;
  struct list_head *el;
  list_for_each(el, &ctx->debugger_info->bytecode_list) {
    LEPUSFunctionBytecode *b = list_entry(el, LEPUSFunctionBytecode, link);
    if (NotInCurrentFunc(b, script_id, end_line)) {
      continue;
    }
    const uint8_t *p_end, *p, *p_prev;
    int pc, pc_prev;
    p_prev = p = b->debug.pc2line_buf;
    p_end = p + b->debug.pc2line_len;
    pc = 0;
    while (p_prev < p_end) {
      int32_t line = -1;
      int64_t column = -1;
      p_prev = p;
      GetPCLineColumn(ctx, p, pc, pc_prev, p_end, b, line, column);
      if (line == -1 && column == -1) {
        continue;
      }
      if (InRange(line, column, start_line, start_col, end_line, end_col) &&
          !LineColExist(ctx, locations, line, column)) {
        char str_script_id[40];
        snprintf(str_script_id,
                 (sizeof(str_script_id) / sizeof(str_script_id[0])), "%d",
                 script_id);
        auto *info = ctx->debugger_info;
        LEPUSValue props[3];
        HandleScope block_scope{ctx};
        block_scope.PushLEPUSValueArrayHandle(
            props, sizeof(props) / sizeof(LEPUSValue));
        props[0] = LEPUS_NewString(ctx, str_script_id);
        props[1] = LEPUS_NewInt32(ctx, line);
        props[2] = LEPUS_NewInt64(ctx, column);
        LEPUSObject *p = DebuggerCreateObjFromShape(
            info, info->debugger_obj.bp_location,
            sizeof(props) / sizeof(LEPUSValue), props);
        block_scope.PushHandle(p, HANDLE_TYPE_DIR_HEAP_OBJ);
        LEPUS_SetPropertyUint32(ctx, locations, id++,
                                LEPUS_MKPTR(LEPUS_TAG_OBJECT, p));
      }
    }
  }
}

QJS_HIDE const char *GetScriptURLByScriptId(LEPUSContext *ctx,
                                            int32_t script_id) {
  struct list_head *el, *el1;
  list_for_each_safe(el, el1, &ctx->debugger_info->script_list) {
    LEPUSScriptSource *script = list_entry(el, LEPUSScriptSource, link);
    if (script->id == script_id) {
      return script->url;
    }
  }
  return NULL;
}

// get line and column number of breakpoint
static void GetBreakpointLineAndColumn(LEPUSContext *ctx, LEPUSValue param,
                                       int32_t &line_num, int64_t &column_num,
                                       int32_t &script_id) {
  LEPUSValue breakpoint_line_prop =
      LEPUS_GetPropertyStr(ctx, param, "lineNumber");
  LEPUS_ToInt32(ctx, &line_num, breakpoint_line_prop);

  LEPUSValue breakpoint_column_prop =
      LEPUS_GetPropertyStr(ctx, param, "columnNumber");
  if (LEPUS_IsUndefined(breakpoint_column_prop)) {
    column_num = -1;
  } else {
    LEPUS_ToInt64(ctx, &column_num, breakpoint_column_prop);
  }
  LEPUSValue param_script_id = LEPUS_GetPropertyStr(ctx, param, "scriptId");
  if (!LEPUS_IsUndefined(param_script_id)) {
    LEPUS_ToInt32(ctx, &script_id, param_script_id);
  }

  if (script_id == -1) {
    LEPUSValue param_script_hash =
        LEPUS_GetPropertyStr(ctx, param, "scriptHash");
    if (!LEPUS_IsUndefined(param_script_hash)) {
      const char *script_hash = LEPUS_ToCString(ctx, param_script_hash);
      LEPUSScriptSource *script = GetScriptByHash(ctx, script_hash);
      if (script) {
        script_id = script ? script->id : -1;
      }
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, script_hash);
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, param_script_hash);
  }
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, breakpoint_line_prop);
    LEPUS_FreeValue(ctx, breakpoint_column_prop);
    LEPUS_FreeValue(ctx, param_script_id);
  }
  return;
}

/**
 * @brief generate unique breakpoint id
 * @param url script url
 * @return unique breakpoint id
 */
static char *GenerateBreakpointId(LEPUSContext *ctx, const char *url,
                                  const char *script_hash, int32_t line_number,
                                  int64_t column_number) {
  // breakpoint_id:   1:line_number:column_number:script_url
  std::string line_string = std::to_string(line_number);
  std::string column_string = std::to_string(column_number);
  const char *line_str = line_string.c_str();
  const char *column_str = column_string.c_str();

  const char *str = url ? url : "";
  // if url is "" and has hash, use hash to generate breakpoint id
  if (str[0] == '\0' && script_hash && script_hash[0] != '\0') {
    str = script_hash;
  }
  const int32_t other_str_len = 7;
  int32_t breakpoint_id_len =
      strlen(line_str) + strlen(str) + strlen(column_str) + other_str_len;
  char *breakpointId = static_cast<char *>(lepus_malloc(
      ctx, (sizeof(char) * breakpoint_id_len), ALLOC_TAG_WITHOUT_PTR));
  if (breakpointId) {
    *breakpointId = '\0';
    strcpy(breakpointId, "1:");
    strcat(breakpointId, line_str);
    strcat(breakpointId, ":");
    strcat(breakpointId, column_str);
    strcat(breakpointId, ":");
    strcat(breakpointId, str);
  }

  return breakpointId;
}

QJS_STATIC bool IsBreakpointEqual(LEPUSContext *ctx, LEPUSBreakpoint *a,
                                  int32_t script_id, int32_t line_number,
                                  int64_t column_number,
                                  LEPUSValue condition_b) {
  bool res1 = a->script_id == script_id && a->line == line_number &&
              a->column == column_number;
  if (res1) {
    LEPUSValue condition_a = a->condition;

    if ((LEPUS_IsNull(condition_a) ^ LEPUS_IsNull(condition_b))) {
      // one null, one has condition
      return false;
    } else {
      // both have condition
      if (!LEPUS_IsNull(condition_a)) {
        const char *condition1 = LEPUS_ToCString(ctx, condition_a);
        const char *condition2 = LEPUS_ToCString(ctx, condition_b);
        if (!condition1 || !condition2) return false;
        bool res2 = strcmp(condition1, condition2) == 0;
        if (!ctx->rt->gc_enable) {
          LEPUS_FreeCString(ctx, condition1);
          LEPUS_FreeCString(ctx, condition2);
        }
        return res2;
      } else {
        return true;
      }
    }
  } else {
    return false;
  }
}

static void SetBps(LEPUSDebuggerInfo *debugger_info, int32_t capacity) {
  debugger_info->breakpoints_capacity = capacity;
  debugger_info->bps = static_cast<LEPUSBreakpoint *>(
      lepus_realloc(debugger_info->ctx, debugger_info->bps,
                    capacity * sizeof(LEPUSBreakpoint), ALLOC_TAG_WITHOUT_PTR));
  return;
}

/**
 * @brief add a breakpoint
 * @param url script url
 * @param line_number breakpoint line number
 * @param column_number  breakpoint column number
 */
QJS_STATIC LEPUSBreakpoint *AddBreakpoint(
    LEPUSDebuggerInfo *info, const char *url, const char *hash,
    int32_t line_number, int64_t column_number, int32_t script_id,
    const char *condition, uint8_t specific_location) {
  LEPUSContext *ctx = info->ctx;
  int32_t bp_num = info->breakpoints_num;
  LEPUSValue condition_val = (condition && condition[0] != '\0')
                                 ? LEPUS_NewString(ctx, condition)
                                 : LEPUS_NULL;
  HandleScope func_scope{ctx, &condition_val, HANDLE_TYPE_LEPUS_VALUE};
  // detect breakpoint existance
  for (int32_t idx = 0; idx < bp_num; idx++) {
    LEPUSBreakpoint *t = info->bps + idx;
    if (IsBreakpointEqual(ctx, t, script_id, line_number, column_number,
                          condition_val)) {
      return t;
    }
  }

  LEPUSBreakpoint *bp;
  const int32_t bp_capacity_increase_size = 8;
  int32_t current_capacity = info->breakpoints_capacity;
  if (bp_num + 1 > current_capacity) {
    SetBps(info, current_capacity + bp_capacity_increase_size);
    if (!info->bps) {
      // fail
      return NULL;
    }
  }

  char *bp_url = static_cast<char *>(
      lepus_malloc(ctx, sizeof(char) * ((url ? strlen(url) : 0) + 1),
                   ALLOC_TAG_WITHOUT_PTR));
  if (bp_url) {
    strcpy(bp_url, url ? url : "");
  }

  bp = info->bps + bp_num;
  bp->breakpoint_id = LEPUS_UNDEFINED;
  bp->script_url = bp_url;
  bp->line = line_number;
  bp->column = column_number;
  bp->script_id = script_id;
  bp->b = nullptr;
  AdjustBreakpoint(info, url, hash, bp);

  char *gen_breakpoint_id =
      GenerateBreakpointId(ctx, url, hash, line_number, column_number);
  if (gen_breakpoint_id) {
    func_scope.PushHandle(gen_breakpoint_id, HANDLE_TYPE_DIR_HEAP_OBJ);
    LEPUSValue breakpoint_id = LEPUS_NewString(ctx, gen_breakpoint_id);
    if (!ctx->rt->gc_enable) lepus_free(ctx, gen_breakpoint_id);
    if (!LEPUS_IsException(breakpoint_id)) {
      bp->breakpoint_id = breakpoint_id;
    }
  }

  bp->specific_location = specific_location;
  bp->pc = NULL;
  bp->condition = condition_val;
  ++info->breakpoints_num;
  ++info->next_breakpoint_id;
  return bp;
}

static void SendBreakpointResponse(LEPUSContext *ctx, LEPUSValue message,
                                   LEPUSBreakpoint *bp,
                                   LEPUSValue breakpoint_id) {
  LEPUSValue locations_array = LEPUS_NewArray(ctx);
  if (LEPUS_IsException(locations_array)) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, breakpoint_id);
    return;
  }

  HandleScope func_scope{ctx, &locations_array, HANDLE_TYPE_LEPUS_VALUE};
  // construct result message
  // ref:
  // https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-setBreakpointByUrl
  auto *info = ctx->debugger_info;
  LEPUSValue location = GetLocation(ctx, bp->line, bp->column, bp->script_id);
  func_scope.PushHandle(&location, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyUint32(ctx, locations_array, 0, location);
  LEPUSValue props[] = {breakpoint_id, locations_array};
  LEPUSObject *p =
      DebuggerCreateObjFromShape(info, info->debugger_obj.breakpoint,
                                 sizeof(props) / sizeof(LEPUSValue), props);
  func_scope.PushHandle(p, HANDLE_TYPE_DIR_HEAP_OBJ);
  SendResponse(ctx, message, LEPUS_MKPTR(LEPUS_TAG_OBJECT, p));
}

static void ProcessSetBreakpoint(LEPUSContext *ctx, const char *script_url,
                                 const char *script_hash, int32_t script_id,
                                 int32_t line_number, int64_t column_number,
                                 LEPUSValue message, const char *condition) {
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  // TODO CHECK if other bp messages sent here!
  // add this new breakpoint to the info->breakpoints
  LEPUSBreakpoint *bp =
      AddBreakpoint(info, script_url, script_hash, line_number, column_number,
                    script_id, condition, 0);

  if (!bp) {
    return;
  }
  // generate breakpoint id
  char *breakpoint_id = GenerateBreakpointId(ctx, script_url, script_hash,
                                             line_number, column_number);
  if (!breakpoint_id) {
    return;
  }

  // find the bytecode at this breakpoint
  bp->pc = nullptr;
  if (const uint8_t *pc = FindBreakpointBytecode(ctx, bp)) {
    info->break_bytecode_map.try_emplace(pc, bp->breakpoint_id);
    bp->pc = pc;
  }

  HandleScope func_scope{ctx, breakpoint_id, HANDLE_TYPE_DIR_HEAP_OBJ};
  LEPUSValue breakpoint_id_value = LEPUS_NewString(ctx, breakpoint_id);
  func_scope.PushHandle(&breakpoint_id_value, HANDLE_TYPE_LEPUS_VALUE);
  SendBreakpointResponse(ctx, message, bp, breakpoint_id_value);

  if (!ctx->rt->gc_enable) lepus_free(ctx, breakpoint_id);
  breakpoint_id = NULL;
}

static void GetSetBpByURLParams(LEPUSContext *ctx, LEPUSValue params,
                                int32_t &line_number, int64_t &column_number,
                                int32_t &script_id, const char **script_url,
                                const char **script_hash,
                                const char **condition) {
  GetBreakpointLineAndColumn(ctx, params, line_number, column_number,
                             script_id);
  LEPUSValue param_url = LEPUS_GetPropertyStr(ctx, params, "url");
  if (!LEPUS_IsUndefined(param_url)) {
    const char *script_url_cstr = LEPUS_ToCString(ctx, param_url);
    *script_url = lepus_strdup(ctx, script_url_cstr, ALLOC_TAG_WITHOUT_PTR);
    if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, script_url_cstr);
  }

  // lynx js thread: get script id from script url
  if (*script_url && script_id == -1) {
    LEPUSScriptSource *script = GetScriptByScriptURL(ctx, *script_url);
    if (script) {
      script_id = script ? script->id : -1;
    }
  }

  // script url is ""
  if (!(*script_url)) {
    *script_url = GetScriptURLByScriptId(ctx, script_id);
    *script_url = *script_url
                      ? lepus_strdup(ctx, *script_url, ALLOC_TAG_WITHOUT_PTR)
                      : lepus_strdup(ctx, "", ALLOC_TAG_WITHOUT_PTR);
  }
  LEPUSValue param_script_hash =
      LEPUS_GetPropertyStr(ctx, params, "scriptHash");
  if (!LEPUS_IsUndefined(param_script_hash)) {
    *script_hash = LEPUS_ToCString(ctx, param_script_hash);
  }
  LEPUSValue params_condition = LEPUS_GetPropertyStr(ctx, params, "condition");

  if (!LEPUS_IsUndefined(params_condition)) {
    *condition = LEPUS_ToCString(ctx, params_condition);
  }
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, params_condition);
    LEPUS_FreeValue(ctx, params);
    LEPUS_FreeValue(ctx, param_url);
    LEPUS_FreeValue(ctx, param_script_hash);
  }
}

// handle "Debugger.setBreakpointByUrl"
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-setBreakpointByUrl
void SetBreakpointByURL(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  LEPUSValue message = debugger_options->message;
  if (!CheckEnable(ctx, message, DEBUGGER_ENABLE)) return;
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");

  int32_t line_number = -1;
  int64_t column_number = -1;
  int32_t script_id = -1;
  const char *script_url = NULL;
  const char *script_hash = NULL;
  const char *condition = NULL;
  HandleScope func_scope{ctx, &script_url, HANDLE_TYPE_HEAP_OBJ};
  func_scope.PushHandle(&script_hash, HANDLE_TYPE_HEAP_OBJ);
  func_scope.PushHandle(&condition, HANDLE_TYPE_HEAP_OBJ);
  GetSetBpByURLParams(ctx, params, line_number, column_number, script_id,
                      &script_url, &script_hash, &condition);
  if (condition && condition[0] == '\0') {
    if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, condition);
    condition = NULL;
  }
  ProcessSetBreakpoint(ctx, script_url, script_hash, script_id, line_number,
                       column_number, message, condition);

  if (!ctx->rt->gc_enable) {
    LEPUS_FreeCString(ctx, condition);
    lepus_free_rt(LEPUS_GetRuntime(ctx), const_cast<char *>(script_url));
    LEPUS_FreeCString(ctx, script_hash);
  }
  return;
}

/**
 * @brief handle "Debugger.setBreakpointsActive" protocol
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-setBreakpointsActive
void HandleSetBreakpointActive(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  LEPUSValue message = debugger_options->message;
  if (!CheckEnable(ctx, message, DEBUGGER_ENABLE)) return;
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");
  LEPUSValue active = LEPUS_GetPropertyStr(ctx, params, "active");
  int32_t is_active = LEPUS_VALUE_GET_BOOL(active);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params);

  info->breakpoints_is_active = is_active ? 1 : 0;

  LEPUSValue result = LEPUS_NewObject(ctx);
  if (LEPUS_IsException(result)) {
    return;
  }
  HandleScope func_scope{ctx, &result, HANDLE_TYPE_LEPUS_VALUE};
  SendResponse(ctx, message, result);
}

// delete breakpoint of index bp_index from breakpoint list
void DeleteBreakpoint(LEPUSDebuggerInfo *info, uint32_t bp_index) {
  LEPUSContext *ctx = info->ctx;
  LEPUSBreakpoint *bp = info->bps + bp_index;

  auto it = info->break_bytecode_map.begin();
  while (it != info->break_bytecode_map.end()) {
    if (LEPUS_VALUE_GET_PTR(it->second) ==
        LEPUS_VALUE_GET_PTR(bp->breakpoint_id)) {
      it = info->break_bytecode_map.erase(it);
    } else {
      ++it;
    }
  }

  if (bp->b) {
    DecreaseBpNum(ctx, bp->b);
  }
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, bp->breakpoint_id);
    LEPUS_FreeValue(ctx, bp->condition);
    lepus_free(ctx, bp->script_url);
  }
  int32_t move = info->breakpoints_num - bp_index - 1;
  if (move > 0) {
    // just move, no delete. use breakpoint number to control
    memmove(bp, info->bps + (bp_index + 1), move * sizeof(LEPUSBreakpoint));
  }
  // breakpoint num -1
  info->breakpoints_num -= 1;
  return;
}

/**
 * @brief delete breakpoint using breakpoint id
 * @param deleted_breakpoint_id breakpoint id needed to be deleted
 */
static void DeleteBreakpointById(LEPUSDebuggerInfo *info,
                                 const char *deleted_breakpoint_id) {
  LEPUSContext *ctx = info->ctx;
  if (ctx && deleted_breakpoint_id) {
    int32_t bp_num = info->breakpoints_num;
    for (int32_t i = 0; i < bp_num; i++) {
      LEPUSBreakpoint *bp = info->bps + i;
      LEPUSValue id_str = bp->breakpoint_id;
      const char *current_breakpoint_id = LEPUS_ToCString(ctx, id_str);
      if (current_breakpoint_id) {
        if (strcmp(current_breakpoint_id, deleted_breakpoint_id) == 0) {
          DeleteBreakpoint(info, i);
          if (!ctx->rt->gc_enable)
            LEPUS_FreeCString(ctx, current_breakpoint_id);
          return;
        } else {
          if (!ctx->rt->gc_enable)
            LEPUS_FreeCString(ctx, current_breakpoint_id);
        }
      }
    }
  }
  return;
}

/**
 * @brief call this function to handle "Debugger.removeBreakpoint"
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-removeBreakpoint
void HandleRemoveBreakpoint(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  LEPUSDebuggerInfo *info = ctx->debugger_info;
  LEPUSValue message = debugger_options->message;
  if (!CheckEnable(ctx, message, DEBUGGER_ENABLE)) return;
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");
  LEPUSValue param_breakpoint_id =
      LEPUS_GetPropertyStr(ctx, params, "breakpointId");

  const char *deleted_breakpoint_id = LEPUS_ToCString(ctx, param_breakpoint_id);
  DeleteBreakpointById(info, deleted_breakpoint_id);
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, params);
    LEPUS_FreeValue(ctx, param_breakpoint_id);
    LEPUS_FreeCString(ctx, deleted_breakpoint_id);
  }
  LEPUSValue result = LEPUS_NewObject(ctx);
  if (LEPUS_IsException(result)) {
    return;
  }
  HandleScope func_scope{ctx, &result, HANDLE_TYPE_LEPUS_VALUE};
  SendResponse(ctx, message, result);
}

/**
 * @brief send "Debugger.breakpointResolved" event
 */
// static void SendBreakpointResolvedEvent(LEPUSDebuggerInfo *info,
//                                        LEPUSValue breakpoint, char *reason) {
//  LEPUSContext *ctx = GetContext(info);
//  LEPUSValue hit_breakpoint_info = LEPUS_NewObject(ctx);
//  if (LEPUS_IsException(hit_breakpoint_info)) {
//    return;
//  }
//  LEPUS_SetPropertyStr(ctx, hit_breakpoint_info, "breakpointId",
//                       LEPUS_GetPropertyStr(ctx, breakpoint, "breakpointId"));
//  LEPUSValue hit_breakpoint_location = LEPUS_NewObject(ctx);
//  if (LEPUS_IsException(hit_breakpoint_location)) {
//    LEPUS_FreeValue(ctx, hit_breakpoint_info);
//    return;
//  }
//
//  LEPUS_SetPropertyStr(ctx, hit_breakpoint_location, "scriptId",
//                       LEPUS_GetPropertyStr(ctx, breakpoint, "scriptId"));
//  LEPUS_SetPropertyStr(ctx, hit_breakpoint_location, "lineNumber",
//                       LEPUS_GetPropertyStr(ctx, breakpoint, "lineNumber"));
//  LEPUS_SetPropertyStr(ctx, hit_breakpoint_location, "columnNumber",
//                       LEPUS_GetPropertyStr(ctx, breakpoint, "columnNumber"));
//  LEPUS_SetPropertyStr(ctx, hit_breakpoint_info, "locations",
//                       hit_breakpoint_location);
//  SendNotification(ctx, "Debugger.breakpointResolved", hit_breakpoint_info);
//}

// given the pc needed to pause, send Debugger.breakpointResolved event and
// Debugger.paused event
void PauseAtBreakpoint(LEPUSDebuggerInfo *info, LEPUSBreakpoint *bp,
                       const uint8_t *cur_pc) {
  //  LEPUSContext *ctx = GetContext(info);
  // reaching a breakpoint resets any existing stepping.
  info->step_type = 0;
  // TODO CHECK IF THERE NEED BREAKPOINTRESOLVED EVENT
  // debugger.paused event
  LEPUSValue breakpoint_id = bp->breakpoint_id;
  SendPausedEvent(info, cur_pc, breakpoint_id, "debugCommand");
}

// for debugger.getpossiblebreakpoints, get start line, start column, end line,
// end column from the protocol
void GetRange(LEPUSContext *ctx, LEPUSValue params, int32_t &start_line,
              int64_t &start_column, int32_t &end_line, int64_t &end_column,
              int32_t &script_id) {
  LEPUSValue start = LEPUS_GetPropertyStr(ctx, params, "start");
  GetBreakpointLineAndColumn(ctx, start, start_line, start_column, script_id);
  LEPUSValue end = LEPUS_GetPropertyStr(ctx, params, "end");
  if (LEPUS_IsUndefined(end)) {
    end_line = -1;
    end_column = -1;
  } else {
    GetBreakpointLineAndColumn(ctx, end, end_line, end_column, script_id);
  }

  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, start);
    LEPUS_FreeValue(ctx, end);
  }
}

/**
 * @brief handle "Debugger.getPossibleBreakpoints" protocol
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-getPossibleBreakpoints
void HandleGetPossibleBreakpoints(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  LEPUSValue message = debugger_options->message;
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");

  int32_t start_line_num = -1, end_line_num = -1;
  int64_t start_column_num = -1, end_column_num = -1;
  int32_t script_id = -1;
  GetRange(ctx, params, start_line_num, start_column_num, end_line_num,
           end_column_num, script_id);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params);
  if (script_id == -1) {
    // error
    return;
  }

  LEPUSValue locations = LEPUS_NewArray(ctx);
  HandleScope func_scope{ctx, &locations, HANDLE_TYPE_LEPUS_VALUE};
  if (LEPUS_IsException(locations)) {
    return;
  }
  GetPossibleBreakpointsByScriptId(ctx, script_id, start_line_num,
                                   start_column_num, end_line_num,
                                   end_column_num, locations);
  LEPUSValue result = LEPUS_NewObject(ctx);
  if (LEPUS_IsException(result)) {
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, locations);
    return;
  }
  func_scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
  DebuggerSetPropertyStr(ctx, result, "locations", locations);
  SendResponse(ctx, message, result);
}

bool SatisfyCondition(LEPUSDebuggerInfo *info, LEPUSContext *ctx,
                      LEPUSBreakpoint *bp) {
  LEPUSValue bp_condition = bp->condition;
  if (!LEPUS_IsNull(bp_condition)) {
    bool result = false;
    const char *condition = LEPUS_ToCString(ctx, bp_condition);
    if (condition && condition[0] == '\0') {
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, condition);
      return result;
    }
    LEPUSValue ret;
    {
      // no exception pause during evaluate breakpoint condition
      ExceptionBreakpointScope es(info, 0);
      const uint8_t *cur_pc = ctx->debugger_info->debugger_current_pc;
      ret = DebuggerEvaluate(ctx, "0", bp_condition);
      ctx->debugger_info->debugger_current_pc = cur_pc;
    }
    if (LEPUS_IsBool(ret)) {
      if (LEPUS_VALUE_GET_BOOL(ret)) {
        result = true;
      }
    }
    if (!ctx->rt->gc_enable) {
      LEPUS_FreeValue(ctx, ret);
      LEPUS_FreeCString(ctx, condition);
    }
    return result;
  }
  return true;
}

static void GetContinueToLocationParams(LEPUSContext *ctx, LEPUSValue params,
                                        int32_t &line_number,
                                        int64_t &column_number,
                                        int32_t &script_id,
                                        const char *&target_callframes) {
  LEPUSValue params_location = LEPUS_GetPropertyStr(ctx, params, "location");
  GetBreakpointLineAndColumn(ctx, params_location, line_number, column_number,
                             script_id);

  LEPUSValue params_target_callframes =
      LEPUS_GetPropertyStr(ctx, params, "targetCallFrames");
  if (!LEPUS_IsUndefined(params_target_callframes)) {
    target_callframes = LEPUS_ToCString(ctx, params_target_callframes);
  }
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, params_location);
    LEPUS_FreeValue(ctx, params_target_callframes);
    LEPUS_FreeValue(ctx, params);
  }
}

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Debugger/#method-continueToLocation
void HandleContinueToLocation(DebuggerParams *debugger_options) {
  LEPUSContext *ctx = debugger_options->ctx;
  LEPUSValue message = debugger_options->message;
  if (!CheckEnable(ctx, message, DEBUGGER_ENABLE)) return;
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");
  LEPUSDebuggerInfo *info = ctx->debugger_info;

  int32_t line_number = -1;
  int64_t column_number = -1;
  int32_t script_id = -1;
  const char *target_callframes = NULL;
  HandleScope func_scope{ctx, &target_callframes, HANDLE_TYPE_CSTRING};
  GetContinueToLocationParams(ctx, params, line_number, column_number,
                              script_id, target_callframes);
  if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, target_callframes);

  info->special_breakpoints = 1;
  const char *url = GetScriptURLByScriptId(ctx, script_id);

  // set brekapoint active is 1
  info->breakpoints_is_active = 1;

  // add this new breakpoint to the info->breakpoints, set specific_condition
  // true
  AddBreakpoint(info, url, "", line_number, column_number, script_id, NULL, 1);
  LEPUSValue result = LEPUS_NewObject(ctx);
  func_scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
  SendResponse(ctx, message, result);
  // continue to run
  QuitMessageLoopOnPause(ctx);
}
