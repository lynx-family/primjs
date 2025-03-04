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

#include "inspector/runtime/runtime.h"

#include "gc/trace-gc.h"
#include "inspector/debugger/debugger.h"
#include "inspector/debugger/debugger_properties.h"
#include "inspector/debugger_inner.h"
#include "inspector/interface.h"
#include "inspector/protocols.h"

typedef struct LEPUSFunctionBytecode LEPUSFunctionBytecode;

QJS_HIDE LEPUSContext* GetContextByContextId(LEPUSRuntime* rt, int32_t id) {
  struct list_head *el, *el1;
  int32_t index = 0;
  list_for_each_safe(el, el1, &rt->context_list) {
    if (index == id) {
      LEPUSContext* ctx1 = list_entry(el, LEPUSContext, link);
      return ctx1;
    }
  }
  return NULL;
}

QJS_HIDE LEPUSValue JS_EvalFunctionWithThisObj(LEPUSContext* ctx,
                                               LEPUSValue func_obj,
                                               LEPUSValueConst this_obj,
                                               int argc, LEPUSValue* argv) {
  LEPUSValue res = LEPUS_UNDEFINED;
  LEPUSValue func_obj_save = func_obj;
  HandleScope func_scope(ctx, &func_obj_save, HANDLE_TYPE_LEPUS_VALUE);
  func_scope.PushHandle(&func_obj, HANDLE_TYPE_LEPUS_VALUE);
  if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(func_obj)) {
    LEPUSFunctionBytecode* b =
        static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(func_obj));
    for (int32_t i = 0; i < b->cpool_count; i++) {
      LEPUSValue child = b->cpool[i];
      if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(child)) {
        func_obj = child;
        b->cpool[i] = LEPUS_UNDEFINED;
        break;
      }
    }
#ifdef ENABLE_COMPATIBLE_MM
    if (ctx->gc_enable) {
      func_obj = js_closure_gc(ctx, func_obj, nullptr, nullptr);
    } else
#endif
      func_obj = js_closure(ctx, func_obj, nullptr, nullptr);
    res = LEPUS_Call(ctx, func_obj, this_obj, argc, argv);
    if (!ctx->gc_enable) {
      LEPUS_FreeValue(ctx, func_obj_save);
      LEPUS_FreeValue(ctx, func_obj);
    }
  }
  return res;
}

/**
 * @brief handle "Runtime.enable"
 */
// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-enable
void HandleRuntimeEnable(DebuggerParams* runtime_options) {
  LEPUSContext* ctx = runtime_options->ctx;
  LEPUSValue message = runtime_options->message;

  LEPUSValue view_id_val =
      LEPUS_GetPropertyStr(ctx, runtime_options->message, "view_id");
  int32_t view_id = -1;
  if (!LEPUS_IsUndefined(view_id_val)) {
    LEPUS_ToInt32(ctx, &view_id, view_id_val);
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, view_id_val);
  }

  if (view_id != -1) {
    // set session enable state
    SetSessionEnableState(ctx, view_id, RUNTIME_ENABLE);
  }

  auto* info = ctx->debugger_info;
  info->is_runtime_enabled += 1;

  LEPUSValue params = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &params, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue params_context = LEPUS_NewObject(ctx);
  func_scope.PushHandle(&params_context, HANDLE_TYPE_LEPUS_VALUE);

  DebuggerSetPropertyStr(ctx, params, "context", params_context);
  int32_t context_id = GetExecutionContextId(ctx);
  DebuggerSetPropertyStr(ctx, params_context, "id",
                         LEPUS_NewInt32(ctx, context_id));
  DebuggerSetPropertyStr(ctx, params_context, "origin",
                         LEPUS_DupValue(ctx, info->literal_pool.empty_string));
  DebuggerSetPropertyStr(
      ctx, params_context, "name",
      LEPUS_DupValue(ctx, LEPUS_VALUE_IS_STRING(info->debugger_name)
                              ? info->debugger_name
                              : info->literal_pool.debugger_context));
  SendNotification(ctx, "Runtime.executionContextCreated", params);

  int32_t console_length = info->console.length;
  for (int idx = 0; idx < console_length; idx++) {
    LEPUSValue msg = LEPUS_GetPropertyUint32(ctx, info->console.messages, idx);
    SendConsoleAPICalled(ctx, &msg, true);
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, msg);
  }
  LEPUSValue result = LEPUS_NewObject(ctx);
  func_scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
  SendResponse(ctx, message, result);
}

// handle runtime.disable
void HandleRuntimeDisable(DebuggerParams* runtime_options) {
  LEPUSContext* ctx = runtime_options->ctx;
  LEPUSValue message = runtime_options->message;
  if (!CheckEnable(ctx, message, RUNTIME_ENABLE)) return;
  ctx->debugger_info->is_runtime_enabled -= 1;
  LEPUSValue view_id_val =
      LEPUS_GetPropertyStr(ctx, runtime_options->message, "view_id");
  int32_t view_id = -1;
  if (!LEPUS_IsUndefined(view_id_val)) {
    LEPUS_ToInt32(ctx, &view_id, view_id_val);
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, view_id_val);
  }

  if (view_id != -1) {
    // set session enable state
    SetSessionEnableState(ctx, view_id, RUNTIME_DISABLE);
  }

  LEPUSValue result = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
  SendResponse(ctx, message, result);
}

// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-discardConsoleEntries
void HandleDiscardConsoleEntries(DebuggerParams* runtime_protocols) {
  LEPUSContext* ctx = runtime_protocols->ctx;
  LEPUSDebuggerInfo* info = ctx->debugger_info;
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, info->console.messages);
  info->console.length = 0;
  info->console.messages = LEPUS_NewArray(ctx);
}

static LEPUSValue Evaluate(LEPUSDebuggerInfo* info, LEPUSContext* evaluate_ctx,
                           char* expression, uint8_t silent, uint8_t preview,
                           int32_t throw_side_effect) {
  if (!expression) {
    return LEPUS_UNDEFINED;
  }
  LEPUSContext* ctx = info->ctx;
  LEPUSValue eval_ret = LEPUS_UNDEFINED;
  HandleScope func_scope(ctx, &eval_ret, HANDLE_TYPE_LEPUS_VALUE);
  {
    ExceptionBreakpointScope es(
        info, (silent || throw_side_effect) ? 0 : info->exception_breakpoint);
    {
      PCScope ps(ctx);
      eval_ret = LEPUS_Eval(evaluate_ctx, expression, strlen(expression), "",
                            LEPUS_EVAL_TYPE_GLOBAL);
    }
  }

  LEPUSValue remote_object = LEPUS_UNDEFINED;
  func_scope.PushHandle(&remote_object, HANDLE_TYPE_LEPUS_VALUE);
  if (LEPUS_IsException(eval_ret)) {
    LEPUSValue exception = DebuggerDupException(evaluate_ctx);
    remote_object = GetRemoteObject(ctx, exception, preview,
                                    0);  // free exception
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, eval_ret);
  } else {
    remote_object = GetRemoteObject(ctx, eval_ret, preview, 0);  // free ret
  }
  LEPUSObject* p = DebuggerCreateObjFromShape(info, info->debugger_obj.result,
                                              1, &remote_object);
  return LEPUS_MKPTR(LEPUS_TAG_OBJECT, p);
}

char* GetExpression(LEPUSContext* ctx, LEPUSValue object_group,
                    const char* expression) {
  char* ret = NULL;
  if (!LEPUS_IsUndefined(object_group)) {
    ret = static_cast<char*>(lepus_malloc(
        ctx, sizeof(char) * (strlen(expression) + 1), ALLOC_TAG_WITHOUT_PTR));
    if (ret) {
      *ret = '\0';
      strcat(ret, expression);
    }
  } else {
    const int32_t brace_len = 3;
    ret = static_cast<char*>(
        lepus_malloc(ctx, sizeof(char) * (strlen(expression) + brace_len),
                     ALLOC_TAG_WITHOUT_PTR));
    if (ret) {
      *ret = '\0';
      strcat(ret, "{");
      strcat(ret, expression);
      strcat(ret, "}");
    }
  }
  return ret;
}

static void GetEvaluateParam(LEPUSContext* ctx, LEPUSValue params,
                             const char** expression, uint8_t* silent,
                             int32_t* context_id, int32_t* throw_side_effect,
                             uint8_t* preview,
                             LEPUSValue* params_object_group) {
  LEPUSValue params_expression =
      LEPUS_GetPropertyStr(ctx, params, "expression");
  *expression = LEPUS_ToCString(ctx, params_expression);

  LEPUSValue params_silent = LEPUS_GetPropertyStr(ctx, params, "silent");
  if (LEPUS_IsUndefined(params_silent)) {
    *silent = LEPUS_VALUE_GET_BOOL(params_silent);
  }

  LEPUSValue params_context_id = LEPUS_GetPropertyStr(ctx, params, "contextId");
  if (!LEPUS_IsUndefined(params_context_id)) {
    LEPUS_ToInt32(ctx, context_id, params_context_id);
  }

  LEPUSValue params_throw_side_effect =
      LEPUS_GetPropertyStr(ctx, params, "throwOnSideEffect");
  *throw_side_effect = LEPUS_VALUE_GET_BOOL(params_throw_side_effect);

  LEPUSValue params_generate_preview =
      LEPUS_GetPropertyStr(ctx, params, "generatePreview");
  if (!LEPUS_IsUndefined(params_generate_preview)) {
    *preview = 1;
  }

  *params_object_group = LEPUS_GetPropertyStr(ctx, params, "objectGroup");
  if (!ctx->gc_enable) {
    LEPUS_FreeValue(ctx, params_expression);
    LEPUS_FreeValue(ctx, params_generate_preview);
    LEPUS_FreeValue(ctx, params_context_id);
    LEPUS_FreeValue(ctx, params);
  }
  return;
}

// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-evaluate
void HandleEvaluate(DebuggerParams* runtime_options) {
  LEPUSContext* ctx = runtime_options->ctx;
  if (ctx) {
    LEPUSDebuggerInfo* info = ctx->debugger_info;
    LEPUSValue message = runtime_options->message;
    LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");

    const char* expression = NULL;
    HandleScope func_scope(ctx, reinterpret_cast<void*>(&expression),
                           HANDLE_TYPE_CSTRING);
    uint8_t silent = 0;
    int32_t context_id = -1;
    int32_t throw_side_effect = 0;
    uint8_t preview = 0;
    LEPUSValue params_object_group = LEPUS_UNDEFINED;
    func_scope.PushHandle(&params_object_group, HANDLE_TYPE_LEPUS_VALUE);
    GetEvaluateParam(ctx, params, &expression, &silent, &context_id,
                     &throw_side_effect, &preview, &params_object_group);

    LEPUSContext* evaluate_ctx = ctx;
    if (context_id != -1) {
      evaluate_ctx = GetContextByContextId(LEPUS_GetRuntime(ctx), context_id);
      evaluate_ctx = evaluate_ctx ? evaluate_ctx : ctx;
    }

    char* val_expression = GetExpression(ctx, params_object_group, expression);
    func_scope.PushHandle(val_expression, HANDLE_TYPE_DIR_HEAP_OBJ);

    const char* str = "{(async function(){ await 1; })()}";
    if (throw_side_effect && val_expression &&
        strcmp(val_expression, str) == 0) {
      LEPUSValue result = GetSideEffectResult(ctx);
      func_scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
      SendResponse(ctx, message, result);
    } else {
      LEPUSValue result = Evaluate(info, evaluate_ctx, val_expression, silent,
                                   preview, throw_side_effect);
      func_scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
      SendResponse(ctx, message, result);
    }
    if (!ctx->rt->gc_enable) {
      LEPUS_FreeValue(ctx, params_object_group);
      LEPUS_FreeCString(ctx, expression);
      lepus_free(ctx, val_expression);
    }
    return;
  }
}

static LEPUSValue GetExceptionDetails(LEPUSContext* ctx, int32_t script_id) {
  LEPUSValue ret = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &ret, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue exception = DebuggerDupException(ctx);
  LEPUSValue line_col = LEPUS_GetPropertyStr(ctx, exception, "lineNumber");
  int64_t line_col_number = -1;
  LEPUS_ToInt64(ctx, &line_col_number, line_col);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, line_col);

  int32_t line_number = -1;
  int64_t col_number = -1;
  ComputeLineCol(line_col_number, &line_number, &col_number);
  DebuggerSetPropertyStr(ctx, ret, "lineNumber",
                         LEPUS_NewInt32(ctx, line_number));
  DebuggerSetPropertyStr(ctx, ret, "columnNumber",
                         LEPUS_NewInt64(ctx, col_number));
  DebuggerSetPropertyStr(ctx, ret, "exceptionId", LEPUS_NewInt32(ctx, 0));

  LEPUSValue exception_remote_obj =
      GetRemoteObject(ctx, exception, 0, 0);  // free exception
  func_scope.PushHandle(&exception_remote_obj, HANDLE_TYPE_LEPUS_VALUE);
  DebuggerSetPropertyStr(ctx, ret, "exception", exception_remote_obj);
  DebuggerSetPropertyStr(
      ctx, ret, "text",
      LEPUS_DupValue(ctx, ctx->debugger_info->literal_pool.uncaught));
  if (script_id != -1) {
    DebuggerSetPropertyStr(ctx, ret, "scriptId",
                           LEPUS_NewInt32(ctx, script_id));
  }
  int32_t execution_context_id = GetExecutionContextId(ctx);
  DebuggerSetPropertyStr(ctx, ret, "executionContextId",
                         LEPUS_NewInt32(ctx, execution_context_id));
  return ret;
}

static void GetCompileScriptParams(LEPUSContext* ctx, LEPUSValue params,
                                   const char** expression,
                                   const char** source_url,
                                   uint8_t* persist_script,
                                   int32_t* context_id) {
  LEPUSValue params_expression =
      LEPUS_GetPropertyStr(ctx, params, "expression");
  LEPUSValue params_source_url = LEPUS_GetPropertyStr(ctx, params, "sourceURL");
  *expression = LEPUS_ToCString(ctx, params_expression);
  *source_url = LEPUS_ToCString(ctx, params_source_url);

  LEPUSValue params_persist_script =
      LEPUS_GetPropertyStr(ctx, params, "persistScript");
  *persist_script = LEPUS_VALUE_GET_BOOL(params_persist_script);

  LEPUSValue params_execution_context_id =
      LEPUS_GetPropertyStr(ctx, params, "executionContextId");
  if (!LEPUS_IsUndefined(params_execution_context_id)) {
    LEPUS_ToInt32(ctx, context_id, params_execution_context_id);
  }
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, params_expression);
    LEPUS_FreeValue(ctx, params_source_url);
    LEPUS_FreeValue(ctx, params_execution_context_id);
    LEPUS_FreeValue(ctx, params);
  }
  return;
}

static LEPUSValue CompileScript(LEPUSContext* ctx, LEPUSContext* compile_ctx,
                                const char* source_url, const char* expression,
                                uint8_t persist_script) {
  LEPUSValue result = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
  if (expression && source_url) {
    int32_t eval_flags = LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL;
    if (!persist_script) {
      // do not need to send scriptparsed notification
      eval_flags = eval_flags | LEPUS_DEBUGGER_NO_PERSIST_SCRIPT;
    }

    LEPUSValue obj =
        LEPUS_Eval(compile_ctx, expression, strlen(expression), "", eval_flags);
    func_scope.PushHandle(&obj, HANDLE_TYPE_LEPUS_VALUE);
    if (!ctx->rt->gc_enable) {
      LEPUS_FreeCString(ctx, expression);
      LEPUS_FreeCString(ctx, source_url);
    }
    int32_t script_id = -1;
    if (persist_script) {
      // func_obj need to be free when Runtime.runscript
      LEPUSFunctionBytecode* b =
          static_cast<LEPUSFunctionBytecode*>(LEPUS_VALUE_GET_PTR(obj));
      script_id = GetScriptIdByFunctionBytecode(ctx, b);
      LEPUSValue script_num = LEPUS_NewInt32(ctx, script_id);
      LEPUSValue str = LEPUS_ToString(ctx, script_num);
      func_scope.PushHandle(&str, HANDLE_TYPE_LEPUS_VALUE);
      DebuggerSetPropertyStr(ctx, result, "scriptId", str);
    }

    if (LEPUS_IsException(obj)) {
      // exceptionDetails
      LEPUSValue exception_details =
          GetExceptionDetails(compile_ctx, script_id);
      func_scope.PushHandle(&exception_details, HANDLE_TYPE_LEPUS_VALUE);
      DebuggerSetPropertyStr(ctx, result, "exceptionDetails",
                             exception_details);
    }

    if (!persist_script && !ctx->rt->gc_enable) {
      LEPUS_FreeValue(ctx, obj);
    }
  }
  return result;
}

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-compileScript
void HandleCompileScript(DebuggerParams* runtime_options) {
  LEPUSContext* ctx = runtime_options->ctx;
  LEPUSValue message = runtime_options->message;
  if (!CheckEnable(ctx, message, RUNTIME_ENABLE)) return;
  LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");

  const char* expression = NULL;
  const char* source_url = NULL;
  HandleScope func_scope(ctx, reinterpret_cast<void*>(&expression),
                         HANDLE_TYPE_CSTRING);
  func_scope.PushHandle(reinterpret_cast<void*>(&source_url),
                        HANDLE_TYPE_CSTRING);
  uint8_t persist_script = 0;
  int32_t context_id = -1;
  GetCompileScriptParams(ctx, params, &expression, &source_url, &persist_script,
                         &context_id);

  LEPUSContext* compile_ctx = ctx;
  LEPUSRuntime* rt = LEPUS_GetRuntime(ctx);
  if (context_id != -1) {
    compile_ctx = GetContextByContextId(rt, context_id);
    compile_ctx = compile_ctx ? compile_ctx : ctx;
  }
  LEPUSValue result =
      CompileScript(ctx, compile_ctx, source_url, expression, persist_script);
  func_scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
  SendResponse(ctx, message, result);
}

LEPUSValue GetObjFromObjectId(LEPUSContext* ctx, const char* object_id_str,
                              uint64_t* object_id) {
  const char* obj_id_str = object_id_str;
  bool is_scope_obj_id = false;
  const int prefix_len = strlen("scope:");
  if (strlen(object_id_str) >= prefix_len && object_id_str[0] == 's') {
    obj_id_str = object_id_str + prefix_len;
    is_scope_obj_id = true;
  }

  for (int i = 0; i < strlen(obj_id_str); i++) {
    *object_id = 10 * (*object_id) + (obj_id_str[i] - '0');
  }
  if (is_scope_obj_id) return LEPUS_UNDEFINED;

  LEPUSObject* p = reinterpret_cast<LEPUSObject*>(*object_id);
  if (p) return LEPUS_DupValue(ctx, LEPUS_MKPTR(LEPUS_TAG_OBJECT, p));
  return LEPUS_UNDEFINED;
}

static LEPUSValue GetCallFunctionOnThisObj(LEPUSContext* ctx,
                                           LEPUSValue object_id) {
  LEPUSValue this_obj = LEPUS_UNDEFINED;
  if (!LEPUS_IsUndefined(object_id)) {
    uint64_t obj_id = 0;
    const char* object_id_str = LEPUS_ToCString(ctx, object_id);
    LEPUSValue obj = GetObjFromObjectId(ctx, object_id_str, &obj_id);
    if (!LEPUS_IsUndefined(obj)) {
      this_obj = obj;
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, object_id_str);
  }
  if (LEPUS_IsUndefined(this_obj)) {
    this_obj = LEPUS_GetGlobalObject(ctx);  // dup
  }
  return this_obj;
}

LEPUSValue* GetFunctionParams(LEPUSContext* ctx, LEPUSValue params,
                              int32_t* argc) {
  LEPUSValue* ret = NULL;
  LEPUSValue params_argments_array =
      LEPUS_GetPropertyStr(ctx, params, "arguments");
  if (!LEPUS_IsUndefined(params_argments_array)) {
    *argc = LEPUS_GetLength(ctx, params_argments_array);
    ret = static_cast<LEPUSValue*>(lepus_mallocz(
        ctx, sizeof(LEPUSValue) * (*argc), ALLOC_TAG_JSValueArray));
    HandleScope func_scope(ctx, ret, HANDLE_TYPE_DIR_HEAP_OBJ);
    if (ctx->rt->gc_enable) set_heap_obj_len(ret, *argc);
    if (ret) {
      for (int32_t i = 0; i < *argc; i++) {
        ret[i] = LEPUS_UNDEFINED;
        LEPUSValue call_argments =
            LEPUS_GetPropertyUint32(ctx, params_argments_array, i);
        LEPUSValue params_argments_value =
            LEPUS_GetPropertyStr(ctx, call_argments, "value");
        if (!LEPUS_IsUndefined(params_argments_value)) {
          ret[i] = params_argments_value;
        } else {
          LEPUSValue params_object_id =
              LEPUS_GetPropertyStr(ctx, call_argments, "objectId");
          if (!LEPUS_IsUndefined(params_object_id)) {
            const char* object_id_str = LEPUS_ToCString(ctx, params_object_id);
            uint64_t obj_id = 0;
            LEPUSValue obj = GetObjFromObjectId(ctx, object_id_str, &obj_id);
            ret[i] = obj;
            if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, object_id_str);
          }
          if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params_object_id);
        }
        if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, call_argments);
      }
    }
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params_argments_array);
  return ret;
}

static void GetCallFunctionOnParams(LEPUSContext* ctx, LEPUSValue params,
                                    const char** function_declaration,
                                    LEPUSValue* this_obj,
                                    LEPUSContext** call_ctx,
                                    uint8_t* return_by_value, int32_t* argc,
                                    LEPUSValue** argments, uint8_t* silent) {
  // params function declaration
  LEPUSValue params_function_declaration =
      LEPUS_GetPropertyStr(ctx, params, "functionDeclaration");
  *function_declaration = LEPUS_ToCString(ctx, params_function_declaration);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params_function_declaration);

  // params object id
  LEPUSValue params_object_id = LEPUS_GetPropertyStr(ctx, params, "objectId");
  if (!LEPUS_IsUndefined(params_object_id)) {
    *this_obj = GetCallFunctionOnThisObj(
        ctx, params_object_id);  // free params_object_id
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params_object_id);
  } else {
    LEPUSValue params_execution_context_id =
        LEPUS_GetPropertyStr(ctx, params, "executionContextId");
    if (!LEPUS_IsUndefined(params_execution_context_id)) {
      int32_t context_id = -1;
      LEPUS_ToInt32(ctx, &context_id, params_execution_context_id);
      if (!ctx->rt->gc_enable)
        LEPUS_FreeValue(ctx, params_execution_context_id);
      if (context_id != -1) {
        *call_ctx = GetContextByContextId(LEPUS_GetRuntime(ctx), context_id);
        *call_ctx = *call_ctx ? *call_ctx : ctx;
      }
      *this_obj = LEPUS_GetGlobalObject(*call_ctx);  // dup
    }
  }

  // params return by value
  LEPUSValue params_return_by_value =
      LEPUS_GetPropertyStr(ctx, params, "returnByValue");
  if (!LEPUS_IsUndefined(params_return_by_value)) {
    *return_by_value = LEPUS_VALUE_GET_BOOL(params_return_by_value);
  }

  // params arguments
  *argments = GetFunctionParams(ctx, params, argc);

  // params silent
  LEPUSValue params_silent = LEPUS_GetPropertyStr(ctx, params, "silent");
  if (!LEPUS_IsUndefined(params_silent)) {
    *silent = LEPUS_VALUE_GET_BOOL(params_silent);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params);
}

static LEPUSValue CallFunctionOn(LEPUSContext* ctx,
                                 const char* function_declaration,
                                 LEPUSValue this_obj, int32_t argc,
                                 LEPUSValue* argv, uint8_t return_by_value) {
  LEPUSValue function_call_result = LEPUS_UNDEFINED;
  HandleScope func_scope(ctx, &function_call_result, HANDLE_TYPE_LEPUS_VALUE);
  if (function_declaration) {
    {
      PCScope ps(ctx);
      LEPUSValue func_obj =
          LEPUS_Eval(ctx, function_declaration, strlen(function_declaration),
                     "", LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL);
      func_scope.PushHandle(&func_obj, HANDLE_TYPE_LEPUS_VALUE);
      function_call_result =
          JS_EvalFunctionWithThisObj(ctx, func_obj, this_obj, argc, argv);
    }

    if (LEPUS_IsException(function_call_result) ||
        LEPUS_IsUndefined(function_call_result)) {
      function_call_result = LEPUS_UNDEFINED;
    }
  }
  if (!ctx->rt->gc_enable) {
    // free arguments
    for (int32_t i = 0; i < argc; i++) {
      LEPUS_FreeValue(ctx, argv[i]);
    }
    lepus_free(ctx, argv);
    LEPUS_FreeValue(ctx, this_obj);
    LEPUS_FreeCString(ctx, function_declaration);
  }

  if (LEPUS_IsUndefined(function_call_result)) {
    function_call_result = LEPUS_NewArray(ctx);
    LEPUSValue item = LEPUS_NewObject(ctx);
    func_scope.PushHandle(&item, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSValue arr = LEPUS_NewArray(ctx);
    func_scope.PushHandle(&arr, HANDLE_TYPE_LEPUS_VALUE);
    DebuggerSetPropertyStr(ctx, item, "items", arr);
    LEPUS_SetPropertyUint32(ctx, function_call_result, 0, item);
  }
  LEPUSValue remote_object =
      GetRemoteObject(ctx, function_call_result, 0,
                      return_by_value);  // free function_call_result
  return remote_object;
}

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-callFunctionOn
void HandleCallFunctionOn(DebuggerParams* runtime_options) {
  LEPUSContext* ctx = runtime_options->ctx;
  if (ctx) {
    LEPUSValue message = runtime_options->message;
    LEPUSDebuggerInfo* info = ctx->debugger_info;
    LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");

    const char* function_declaration = NULL;
    HandleScope func_scope(ctx, &function_declaration, HANDLE_TYPE_CSTRING);
    LEPUSValue this_obj = LEPUS_UNDEFINED;
    func_scope.PushHandle(&this_obj, HANDLE_TYPE_LEPUS_VALUE);
    uint8_t return_by_value = 0;
    int32_t argc = 0;
    LEPUSValue* argments = NULL;
    func_scope.PushHandle(reinterpret_cast<void*>(&argments),
                          HANDLE_TYPE_HEAP_OBJ);
    uint8_t silent = 0;
    LEPUSContext* call_ctx = ctx;
    GetCallFunctionOnParams(ctx, params, &function_declaration, &this_obj,
                            &call_ctx, &return_by_value, &argc, &argments,
                            &silent);

    ExceptionBreakpointScope es(info, silent ? 0 : info->exception_breakpoint);
    LEPUSValue remote_object = CallFunctionOn(
        ctx, function_declaration, this_obj, argc, argments, return_by_value);
    func_scope.PushHandle(&remote_object, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSObject* p = DebuggerCreateObjFromShape(info, info->debugger_obj.result,
                                                1, &remote_object);
    func_scope.PushHandle(p, HANDLE_TYPE_DIR_HEAP_OBJ);
    SendResponse(ctx, message, LEPUS_MKPTR(LEPUS_TAG_OBJECT, p));
  }
}

LEPUSValue GetGlobalScopeVariables(LEPUSContext* ctx) {
  LEPUSValue global_var_obj = ctx->global_var_obj;
  LEPUSValue result = LEPUS_NewArray(ctx);
  HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);

  LEPUSPropertyEnum* ptab = NULL;
  func_scope.PushHandle(reinterpret_cast<void*>(&ptab), HANDLE_TYPE_HEAP_OBJ);
  uint32_t prop_count = 0;
  if (LEPUS_GetOwnPropertyNames(
          ctx, &ptab, &prop_count, global_var_obj,
          LEPUS_GPN_STRING_MASK | LEPUS_GPN_SYMBOL_MASK)) {
    return result;
  }

  uint32_t element_size = 0;
  LEPUSValue each_variable = LEPUS_UNDEFINED;
  func_scope.PushHandle(&each_variable, HANDLE_TYPE_LEPUS_VALUE);
  for (uint32_t i = 0; i < prop_count; i++) {
    LEPUSPropertyDescriptor desc;
    if (LEPUS_GetOwnProperty(ctx, &desc, global_var_obj, ptab[i].atom)) {
      const char* varialbe = LEPUS_AtomToCString(ctx, ptab[i].atom);
      each_variable = LEPUS_AtomToString(ctx, ptab[i].atom);
      LEPUS_SetPropertyUint32(ctx, result, element_size++, each_variable);
      if (!ctx->rt->gc_enable) {
        LEPUS_FreeCString(ctx, varialbe);
      }
    }
  }

  if (!ctx->rt->gc_enable) {
    for (uint32_t i = 0; i < prop_count; i++) {
      LEPUS_FreeAtom(ctx, ptab[i].atom);
    }
    lepus_free(ctx, ptab);
  }
  return result;
}

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-globalLexicalScopeNames
void HandleGlobalLexicalScopeNames(DebuggerParams* runtime_options) {
  LEPUSContext* ctx = runtime_options->ctx;
  if (ctx) {
    LEPUSValue message = runtime_options->message;
    LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");
    LEPUSValue execution_context_id =
        LEPUS_GetPropertyStr(ctx, params, "executionContextId");
    int32_t context_id = -1;
    LEPUS_ToInt32(ctx, &context_id, execution_context_id);
    if (!ctx->rt->gc_enable) {
      LEPUS_FreeValue(ctx, execution_context_id);
      LEPUS_FreeValue(ctx, params);
    }
    LEPUSValue result = LEPUS_NewObject(ctx);
    if (LEPUS_IsException(result)) {
      return;
    }
    HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);

    // TODO
    LEPUSContext* search_ctx = ctx;
    if (context_id != -1) {
      search_ctx = GetContextByContextId(LEPUS_GetRuntime(ctx), context_id);
      search_ctx = search_ctx ? search_ctx : ctx;
    }

    LEPUSValue names = GetGlobalScopeVariables(search_ctx);
    if (LEPUS_IsException(names) && !ctx->rt->gc_enable) {
      LEPUS_FreeValue(ctx, result);
      return;
    }
    func_scope.PushHandle(&names, HANDLE_TYPE_LEPUS_VALUE);
    DebuggerSetPropertyStr(ctx, result, "names", names);
    SendResponse(ctx, message, result);
  }
}

static void GetRunScriptParams(LEPUSContext* ctx, LEPUSValue params,
                               int32_t* script_id, int32_t* context_id,
                               uint8_t* silent, uint8_t* preview) {
  LEPUSValue params_script_id = LEPUS_GetPropertyStr(ctx, params, "scriptId");
  LEPUS_ToInt32(ctx, script_id, params_script_id);

  LEPUSValue params_execution_context_id =
      LEPUS_GetPropertyStr(ctx, params, "executionContextId");
  if (!LEPUS_IsUndefined(params_execution_context_id)) {
    LEPUS_ToInt32(ctx, context_id, params_execution_context_id);
  }

  LEPUSValue params_silent = LEPUS_GetPropertyStr(ctx, params, "silent");
  if (!LEPUS_IsUndefined(params_silent)) {
    *silent = LEPUS_VALUE_GET_BOOL(params_silent);
  }

  LEPUSValue params_generate_preview =
      LEPUS_GetPropertyStr(ctx, params, "generatePreview");
  if (!LEPUS_IsUndefined(params_generate_preview)) {
    *preview = 1;
  }
  if (!ctx->rt->gc_enable) {
    LEPUS_FreeValue(ctx, params_script_id);
    LEPUS_FreeValue(ctx, params_execution_context_id);
    LEPUS_FreeValue(ctx, params_generate_preview);
    LEPUS_FreeValue(ctx, params);
  }
  return;
}

static LEPUSValue RunScript(LEPUSContext* ctx, LEPUSContext* run_ctx,
                            int32_t script_id, uint8_t preview) {
  LEPUSValue ret = LEPUS_UNDEFINED;
  HandleScope func_scope(ctx, &ret, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSFunctionBytecode* b = GetFunctionBytecodeByScriptId(ctx, script_id);
  if (b) {
    LEPUSValue func_obj = LEPUS_MKPTR(LEPUS_TAG_FUNCTION_BYTECODE, b);
    LEPUSValue global_object = run_ctx->global_obj;
    {
      PCScope ps(ctx);
      ret = LEPUS_EvalFunction(run_ctx, func_obj, global_object);
    }
    // do not need to free func_obj
  }

  LEPUSValue remote_object = LEPUS_UNDEFINED;
  if (LEPUS_IsException(ret)) {
    LEPUSValue exception = DebuggerDupException(run_ctx);
    remote_object = GetRemoteObject(run_ctx, exception, preview,
                                    0);  // free exception
  } else {
    remote_object = GetRemoteObject(run_ctx, ret, preview, 0);  // free ret
  }
  return remote_object;
}

// ref:
// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-runScript
void HandleRunScript(DebuggerParams* runtime_options) {
  LEPUSContext* ctx = runtime_options->ctx;
  if (ctx) {
    LEPUSValue message = runtime_options->message;
    if (!CheckEnable(ctx, message, RUNTIME_ENABLE)) return;
    LEPUSDebuggerInfo* info = ctx->debugger_info;
    LEPUSRuntime* rt = LEPUS_GetRuntime(ctx);
    LEPUSValue params = LEPUS_GetPropertyStr(ctx, message, "params");

    int32_t script_id = -1;
    int32_t context_id = -1;
    uint8_t silent = 0;
    uint8_t preview = 0;
    GetRunScriptParams(ctx, params, &script_id, &context_id, &silent, &preview);

    LEPUSContext* run_ctx = ctx;
    if (context_id != -1) {
      run_ctx = GetContextByContextId(rt, context_id);
      run_ctx = run_ctx ? run_ctx : ctx;
    }
    LEPUSValue remote_object = LEPUS_UNDEFINED;
    HandleScope func_scope(run_ctx, &remote_object, HANDLE_TYPE_LEPUS_VALUE);
    {
      ExceptionBreakpointScope es(info,
                                  silent ? 0 : info->exception_breakpoint);
      remote_object = RunScript(ctx, run_ctx, script_id, preview);
    }

    LEPUSObject* p = DebuggerCreateObjFromShape(info, info->debugger_obj.result,
                                                1, &remote_object);
    func_scope.PushHandle(p, HANDLE_TYPE_DIR_HEAP_OBJ);
    SendResponse(ctx, message, LEPUS_MKPTR(LEPUS_TAG_OBJECT, p));
  }
}

void HandleRuntimeGetHeapUsage(DebuggerParams* runtime_options) {
  LEPUSContext* ctx = runtime_options->ctx;
  LEPUSValue message = runtime_options->message;

  if (!CheckEnable(ctx, message, RUNTIME_ENABLE)) return;
  LEPUSRuntime* rt = ctx->rt;
  LEPUSValue response = LEPUS_NewObject(ctx);
  HandleScope func_scope{ctx, &response, HANDLE_TYPE_LEPUS_VALUE};
  uint64_t used_size = 0, total_size = 0;
  if (ctx->gc_enable) {
    used_size = rt->malloc_state.allocate_state.footprint;
    total_size = rt->malloc_state.allocate_state.footprint_limit;
  } else {
    used_size = rt->malloc_state.malloc_size;
    total_size = used_size;
  }

  LEPUS_SetPropertyStr(ctx, response, "usedSize",
                       LEPUS_NewInt64(ctx, used_size));
  LEPUS_SetPropertyStr(ctx, response, "totalSize",
                       LEPUS_NewInt64(ctx, total_size));
  SendResponse(ctx, message, response);
  return;
}
