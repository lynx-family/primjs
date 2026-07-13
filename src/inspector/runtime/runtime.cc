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

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <memory>
#include <string>
#include <vector>

#include "gc/trace-gc.h"
#include "inspector/debugger/debugger.h"
#include "inspector/debugger/debugger_properties.h"
#include "inspector/debugger_inner.h"
#include "inspector/interface.h"
#include "inspector/protocols.h"

QJS_HIDE LEPUSValue js_closure(LEPUSContext* ctx, LEPUSValue bfunc,
                               JSVarRef** cur_var_refs, LEPUSStackFrame* sf);

const char kConsoleDerivedObjectsProp[] = "__debuggerConsoleObjects__";
const char kConsoleObjectIdPrefix[] = "console:";

uint32_t GetConsoleMessageIndex(const JSDebuggerConsole& console,
                                int32_t logical_index) {
  // Translate logical order [oldest -> newest] to physical ring-buffer slot.
  return static_cast<uint32_t>((console.head + logical_index) %
                               MAX_MESSAGE_COUNT);
}

bool IsConsoleMessageSlotActive(const JSDebuggerConsole& console,
                                uint32_t slot_index) {
  // Used by console objectId validation to reject recycled / out-of-window
  // slots.
  if (console.length <= 0) {
    return false;
  }
  if (console.length >= MAX_MESSAGE_COUNT) {
    return slot_index < static_cast<uint32_t>(MAX_MESSAGE_COUNT);
  }
  uint32_t tail = static_cast<uint32_t>((console.head + console.length) %
                                        MAX_MESSAGE_COUNT);
  if (console.head < static_cast<int32_t>(tail)) {
    return slot_index >= static_cast<uint32_t>(console.head) &&
           slot_index < tail;
  }
  return slot_index >= static_cast<uint32_t>(console.head) || slot_index < tail;
}

uint32_t GetConsoleMessageGeneration(const JSDebuggerConsole& console,
                                     uint32_t slot_index) {
  return console.generations[slot_index];
}

void InvalidateConsoleMessageSlot(JSDebuggerConsole& console,
                                  uint32_t slot_index) {
  ++console.generations[slot_index];
}

void InvalidateAllConsoleMessageSlots(JSDebuggerConsole& console) {
  for (int32_t i = 0; i < MAX_MESSAGE_COUNT; ++i) {
    ++console.generations[i];
  }
}

bool ParseConsoleObjectId(const char* object_id_str,
                          ConsoleObjectIdInfo* info) {
  size_t prefix_len = strlen(kConsoleObjectIdPrefix);
  if (strncmp(object_id_str, kConsoleObjectIdPrefix, prefix_len) != 0) {
    return false;
  }

  unsigned int message_slot = 0;
  unsigned int generation = 0;
  int prefix_consumed = 0;
  if (sscanf(object_id_str + prefix_len, "%u:%u:%n", &message_slot, &generation,
             &prefix_consumed) != 2) {
    return false;
  }

  const char* rest = object_id_str + prefix_len + prefix_consumed;
  if (*rest == '\0') {
    return false;
  }

  info->message_slot = message_slot;
  info->generation = generation;
  // Supported forms:
  //   console:<slot>:<generation>:<arg_index>
  //   console:<slot>:<generation>:child:<derived_index>
  if (strncmp(rest, "child:", strlen("child:")) == 0) {
    unsigned int derived_index = 0;
    char trailing = '\0';
    if (sscanf(rest + strlen("child:"), "%u%c", &derived_index, &trailing) !=
        1) {
      return false;
    }
    info->type = ConsoleObjectIdType::kDerived;
    info->index = derived_index;
    return true;
  }

  unsigned int argument_index = 0;
  char trailing = '\0';
  if (sscanf(rest, "%u%c", &argument_index, &trailing) != 1) {
    return false;
  }
  info->type = ConsoleObjectIdType::kRoot;
  info->index = argument_index;
  return true;
}

ScopedConsoleMessageContext::ScopedConsoleMessageContext(LEPUSContext* ctx,
                                                         uint32_t message_slot,
                                                         uint32_t generation)
    : ctx_(ctx) {
  auto& console = ctx_->debugger_info->console;
  // Save/restore the previous context so nested console serialization keeps the
  // correct lifetime domain. All objectIds created under this scope should be
  // interpreted relative to `message_slot + generation`, not the global
  // running_state object registry.
  previous_slot_ = console.current_message_slot;
  previous_generation_ = console.current_generation;
  console.current_message_slot = static_cast<int32_t>(message_slot);
  console.current_generation = generation;
}

ScopedConsoleMessageContext::~ScopedConsoleMessageContext() {
  auto& console = ctx_->debugger_info->console;
  console.current_message_slot = previous_slot_;
  console.current_generation = previous_generation_;
}

ScopedConsoleMessageSlot::ScopedConsoleMessageSlot(LEPUSContext* ctx,
                                                   uint32_t message_slot)
    : ScopedConsoleMessageContext(
          ctx, message_slot,
          // Snapshot the slot generation at scope entry. If this ring-buffer
          // slot gets recycled later, newly generated objectIds will use a
          // different generation and old ids will fail closed.
          GetConsoleMessageGeneration(ctx->debugger_info->console,
                                      message_slot)) {}

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
    uint32_t real_idx = GetConsoleMessageIndex(info->console, idx);
    LEPUSValue msg =
        LEPUS_GetPropertyUint32(ctx, info->console.messages, real_idx);
    ScopedConsoleMessageSlot console_scope(ctx, real_idx);
    SendConsoleAPICalledNotification(ctx, &msg);
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

  // Reset object group state to prevent memory leak on reconnect.
  LEPUSDebuggerInfo* info = ctx->debugger_info;
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, info->object_group_registry);
  LEPUS_HeapObjStore(ctx, &info->object_group_registry, LEPUS_NewObject(ctx));
  info->object_group_lengths.clear();
  info->object_id_to_groups.clear();
  info->object_group_ids.clear();
  info->current_object_groups.clear();

  LEPUSValue result = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &result, HANDLE_TYPE_LEPUS_VALUE);
  SendResponse(ctx, message, result);
}

// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-discardConsoleEntries
void HandleDiscardConsoleEntries(DebuggerParams* runtime_protocols) {
  LEPUSContext* ctx = runtime_protocols->ctx;
  LEPUSDebuggerInfo* info = ctx->debugger_info;
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, info->console.messages);
  InvalidateAllConsoleMessageSlots(info->console);
  info->console.length = 0;
  info->console.head = 0;
  LEPUS_HeapObjStore(ctx, &info->console.messages, LEPUS_NewArray(ctx));
}

// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-releaseObjectGroup
void HandleReleaseObjectGroup(DebuggerParams* params) {
  LEPUSContext* ctx = params->ctx;
  LEPUSValue message = params->message;
  LEPUSDebuggerInfo* info = ctx->debugger_info;

  LEPUSValue msg_params = LEPUS_GetPropertyStr(ctx, message, "params");
  LEPUSValue object_group_val =
      LEPUS_GetPropertyStr(ctx, msg_params, "objectGroup");
  const char* object_group = LEPUS_ToCString(ctx, object_group_val);
  HandleScope func_scope(ctx, reinterpret_cast<void*>(&object_group),
                         HANDLE_TYPE_CSTRING);

  if (LEPUS_IsString(object_group_val) && object_group &&
      object_group[0] != '\0') {
    LEPUSValue group_array =
        LEPUS_GetPropertyStr(ctx, info->object_group_registry, object_group);
    func_scope.PushHandle(&group_array, HANDLE_TYPE_LEPUS_VALUE);
    if (LEPUS_IsArray(ctx, group_array)) {
      // Delete property from registry — drops the registry's reference
      LEPUSAtom atom = LEPUS_NewAtom(ctx, object_group);
      LEPUS_DeleteProperty(ctx, info->object_group_registry, atom, 0);
      if (!ctx->rt->gc_enable) LEPUS_FreeAtom(ctx, atom);
      // Free the Get-produced reference after DeleteProperty to avoid
      // any ambiguity about dangling pointers.
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, group_array);
    } else {
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, group_array);
    }
    // Clean up reverse mapping entries for this group using per-group ID list
    std::string group_str(object_group);
    auto ids_it = info->object_group_ids.find(group_str);
    if (ids_it != info->object_group_ids.end()) {
      for (uint64_t obj_id : ids_it->second) {
        auto map_it = info->object_id_to_groups.find(obj_id);
        if (map_it != info->object_id_to_groups.end()) {
          map_it->second.erase(group_str);
          if (map_it->second.empty()) {
            info->object_id_to_groups.erase(map_it);
          }
        }
      }
      info->object_group_ids.erase(ids_it);
    }
    info->object_group_lengths.erase(group_str);
  }

  if (!ctx->rt->gc_enable) {
    LEPUS_FreeCString(ctx, object_group);
    LEPUS_FreeValue(ctx, object_group_val);
    LEPUS_FreeValue(ctx, msg_params);
  }

  LEPUSValue result = LEPUS_NewObject(ctx);
  func_scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
  SendResponse(ctx, message, result);
}

// Helper: scan an array for ALL slots matching the pointer and nullify them.
// The same object may have been DupValue'd into the array multiple times
// (e.g. repeated evaluate with the same group), so we must release every slot.
// Returns the new effective length after shrinking trailing undefined slots.
static uint32_t ReleaseObjectFromArray(LEPUSContext* ctx, LEPUSValue array,
                                       uint64_t target_ptr) {
  if (!LEPUS_IsArray(ctx, array)) return 0;
  HandleScope func_scope(ctx, &array, HANDLE_TYPE_LEPUS_VALUE);
  bool found = false;
  uint32_t len = LEPUS_GetLength(ctx, array);
  LEPUSValue elem = LEPUS_UNDEFINED;
  func_scope.PushHandle(&elem, HANDLE_TYPE_LEPUS_VALUE);
  for (uint32_t i = 0; i < len; ++i) {
    elem = LEPUS_GetPropertyUint32(ctx, array, i);
    if (LEPUS_IsObject(elem)) {
      LEPUSObject* p = LEPUS_VALUE_GET_OBJ(elem);
      if ((uint64_t)p == target_ptr) {
        if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, elem);
        LEPUS_SetPropertyUint32(ctx, array, i, LEPUS_UNDEFINED);
        found = true;
        continue;
      }
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, elem);
  }
  // Shrink trailing undefined slots to prevent unbounded array growth.
  if (found) {
    while (len > 0) {
      elem = LEPUS_GetPropertyUint32(ctx, array, len - 1);
      bool is_undef = LEPUS_IsUndefined(elem);
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, elem);
      if (!is_undef) break;
      --len;
    }
    LEPUS_SetPropertyStr(ctx, array, "length",
                         LEPUS_NewInt32(ctx, (int32_t)len));
  }
  return len;
}

// https://chromedevtools.github.io/devtools-protocol/tot/Runtime/#method-releaseObject
void HandleReleaseObject(DebuggerParams* params) {
  LEPUSContext* ctx = params->ctx;
  LEPUSValue message = params->message;
  LEPUSDebuggerInfo* info = ctx->debugger_info;

  LEPUSValue msg_params = LEPUS_GetPropertyStr(ctx, message, "params");
  LEPUSValue object_id_val = LEPUS_GetPropertyStr(ctx, msg_params, "objectId");
  const char* object_id_str = LEPUS_ToCString(ctx, object_id_val);
  HandleScope func_scope(ctx, reinterpret_cast<void*>(&object_id_str),
                         HANDLE_TYPE_CSTRING);

  // Skip console object IDs (managed by console ring-buffer) and scope IDs
  // (transient, only valid while paused). Only release heap object pointers.
  if (object_id_str && object_id_str[0] != '\0' &&
      strncmp(object_id_str, kConsoleObjectIdPrefix,
              strlen(kConsoleObjectIdPrefix)) != 0 &&
      strncmp(object_id_str, "scope:", 6) != 0) {
    char* end_ptr = nullptr;
    uint64_t target_ptr = strtoull(object_id_str, &end_ptr, 10);
    bool valid_id = (end_ptr && *end_ptr == '\0' && end_ptr != object_id_str);
    if (valid_id) {
      // O(1) lookup via multi-value reverse mapping.
      std::vector<std::string> affected_groups;
      auto groups_it = info->object_id_to_groups.find(target_ptr);
      if (groups_it != info->object_id_to_groups.end()) {
        affected_groups.assign(groups_it->second.begin(),
                               groups_it->second.end());
      }

      if (!affected_groups.empty()) {
        LEPUSValue group_array = LEPUS_UNDEFINED;
        func_scope.PushHandle(&group_array, HANDLE_TYPE_LEPUS_VALUE);
        for (auto& group_name : affected_groups) {
          group_array = LEPUS_GetPropertyStr(ctx, info->object_group_registry,
                                             group_name.c_str());
          uint32_t new_len =
              ReleaseObjectFromArray(ctx, group_array, target_ptr);
          if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, group_array);
          auto& ids_set = info->object_group_ids[group_name];
          ids_set.erase(target_ptr);
          // Clean up empty group to prevent unbounded growth of holes.
          if (ids_set.empty()) {
            LEPUSAtom atom = LEPUS_NewAtom(ctx, group_name.c_str());
            LEPUS_DeleteProperty(ctx, info->object_group_registry, atom, 0);
            if (!ctx->rt->gc_enable) LEPUS_FreeAtom(ctx, atom);
            info->object_group_ids.erase(group_name);
            info->object_group_lengths.erase(group_name);
          } else {
            info->object_group_lengths[group_name] = new_len;
          }
        }
      } else {
        // Not in any group: fallback to running_state.
        uint32_t new_len = ReleaseObjectFromArray(
            ctx, info->running_state.get_properties_array, target_ptr);
        info->running_state.get_properties_array_len = new_len;
      }

      // Clean up reverse mapping (no-op if key doesn't exist).
      info->object_id_to_groups.erase(target_ptr);
    }
  }

  if (!ctx->rt->gc_enable) {
    LEPUS_FreeCString(ctx, object_id_str);
    LEPUS_FreeValue(ctx, object_id_val);
    LEPUS_FreeValue(ctx, msg_params);
  }

  LEPUSValue result = LEPUS_NewObject(ctx);
  func_scope.PushHandle(&result, HANDLE_TYPE_LEPUS_VALUE);
  SendResponse(ctx, message, result);
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

    // Activate object group scope so objects created during evaluation
    // are tracked under this group for later release.
    std::unique_ptr<ScopedObjectGroup> obj_group_scope;
    if (LEPUS_IsString(params_object_group)) {
      const char* group_cstr = LEPUS_ToCString(ctx, params_object_group);
      if (group_cstr && group_cstr[0] != '\0') {
        obj_group_scope.reset(
            new ScopedObjectGroup(info, std::string(group_cstr)));
      }
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, group_cstr);
    }

    LEPUSContext* evaluate_ctx = ctx;
    if (context_id != -1) {
      evaluate_ctx = GetContextByContextId(LEPUS_GetRuntime(ctx), context_id);
      evaluate_ctx = evaluate_ctx ? evaluate_ctx : ctx;
    }

    char* val_expression = GetExpression(ctx, params_object_group, expression);
    func_scope.PushHandle(val_expression, HANDLE_TYPE_DIR_HEAP_OBJ);
    info->eval_throw_on_side_effect = throw_side_effect;

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
    info->eval_throw_on_side_effect = false;
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
  ConsoleObjectIdInfo console_object_id;
  if (ParseConsoleObjectId(object_id_str, &console_object_id)) {
    auto* info = ctx->debugger_info;
    // Reject immediately if the ring-buffer slot has already been recycled.
    if (!info ||
        console_object_id.message_slot >=
            static_cast<uint32_t>(MAX_MESSAGE_COUNT) ||
        !IsConsoleMessageSlotActive(info->console,
                                    console_object_id.message_slot) ||
        GetConsoleMessageGeneration(info->console,
                                    console_object_id.message_slot) !=
            console_object_id.generation) {
      return LEPUS_UNDEFINED;
    }
    LEPUSValue message = LEPUS_GetPropertyUint32(
        ctx, info->console.messages, console_object_id.message_slot);
    if (LEPUS_IsUndefined(message)) {
      return LEPUS_UNDEFINED;
    }
    LEPUSValue value = LEPUS_UNDEFINED;
    if (console_object_id.type == ConsoleObjectIdType::kRoot) {
      value = LEPUS_GetPropertyUint32(ctx, message, console_object_id.index);
    } else if (console_object_id.type == ConsoleObjectIdType::kDerived) {
      // Child objects are resolved from the hidden per-message registry created
      // during previous console-object expansion.
      LEPUSValue derived_objects =
          LEPUS_GetPropertyStr(ctx, message, kConsoleDerivedObjectsProp);
      if (!LEPUS_IsUndefined(derived_objects)) {
        value = LEPUS_GetPropertyUint32(ctx, derived_objects,
                                        console_object_id.index);
      }
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, derived_objects);
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, message);
    if (!LEPUS_IsObject(value)) {
      if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, value);
      return LEPUS_UNDEFINED;
    }
    return value;
  }

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
                                    LEPUSValue** argments, uint8_t* silent,
                                    LEPUSValue* params_object_group) {
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
  // params object group
  *params_object_group = LEPUS_GetPropertyStr(ctx, params, "objectGroup");
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
    LEPUSValue params_object_group = LEPUS_UNDEFINED;
    func_scope.PushHandle(&params_object_group, HANDLE_TYPE_LEPUS_VALUE);
    GetCallFunctionOnParams(ctx, params, &function_declaration, &this_obj,
                            &call_ctx, &return_by_value, &argc, &argments,
                            &silent, &params_object_group);

    // Activate object group scope so objects created during call are
    // tracked under this group for later release.
    std::unique_ptr<ScopedObjectGroup> obj_group_scope;
    if (LEPUS_IsString(params_object_group)) {
      const char* group_cstr = LEPUS_ToCString(ctx, params_object_group);
      if (group_cstr && group_cstr[0] != '\0') {
        obj_group_scope.reset(
            new ScopedObjectGroup(info, std::string(group_cstr)));
      }
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, group_cstr);
    }

    ExceptionBreakpointScope es(info, silent ? 0 : info->exception_breakpoint);
    LEPUSValue remote_object = CallFunctionOn(
        ctx, function_declaration, this_obj, argc, argments, return_by_value);
    func_scope.PushHandle(&remote_object, HANDLE_TYPE_LEPUS_VALUE);
    LEPUSObject* p = DebuggerCreateObjFromShape(info, info->debugger_obj.result,
                                                1, &remote_object);
    func_scope.PushHandle(p, HANDLE_TYPE_DIR_HEAP_OBJ);
    SendResponse(ctx, message, LEPUS_MKPTR(LEPUS_TAG_OBJECT, p));
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, params_object_group);
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
    used_size = rt->ros_->GetAllocatedSize();
    total_size = rt->ros_->GetHeapSize();
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
