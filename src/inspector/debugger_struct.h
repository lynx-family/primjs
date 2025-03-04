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

// this file do not need to copy to LYNX!
#ifndef SRC_INSPECTOR_DEBUGGER_STRUCT_H_
#define SRC_INSPECTOR_DEBUGGER_STRUCT_H_

#include <stdint.h>

#include <atomic>
#include <condition_variable>
#include <map>
#include <memory>
#include <string>

#include "quickjs/include/list.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#define DEBUGGER_MAX_SCOPE_LEVEL 23

#define QJSDebuggerStringPool(V)                                \
  V(stack, "stack")                                             \
  V(string, "string")                                           \
  V(message, "message")                                         \
  V(undefined, "undefined")                                     \
  V(capital_undefined, "Undefined")                             \
  V(object, "object")                                           \
  V(lepus_js, "lepus.js")                                       \
  V(lepus, "lepus")                                             \
  V(arraybuffer, "arraybuffer")                                 \
  V(function, "function")                                       \
  V(exception, "exception")                                     \
  V(null, "null")                                               \
  V(capital_null, "Null")                                       \
  V(number, "number")                                           \
  V(bigint, "bigint")                                           \
  V(boolean, "boolean")                                         \
  V(size, "size")                                               \
  V(proto, "__proto__")                                         \
  V(capital_object, "Object")                                   \
  V(capital_promise, "Promise")                                 \
  V(capital_symbol, "Symbol")                                   \
  V(symbol, "symbol")                                           \
  V(capital_arraybuffer, "ArrayBuffer")                         \
  V(capital_uncaught, "Uncaught")                               \
  V(capital_javascript, "JavaScript")                           \
  V(minus_one, "-1")                                            \
  V(debugger_context, "debugger context")                       \
  V(anonymous, "<anonymous>")                                   \
  V(uncaught, "uncaught")                                       \
  V(unknown, "unknown")                                         \
  V(empty_string, "")                                           \
  V(function_location, "[[FunctionLocation]]")                  \
  V(generator_function_location, "[[GeneratorLocation]]")       \
  V(is_generator, "[[IsGenerator]]")                            \
  V(internal_location, "internal#location")                     \
  V(entries, "[[Entries]]")                                     \
  V(capital_weak_ref, "WeakRef")                                \
  V(capital_fr, "FinalizationRegistry")                         \
  V(capital_array_iterator, "ArrayIterator")                    \
  V(capital_string_iterator, "StringIterator")                  \
  V(capital_set_iterator, "SetIterator")                        \
  V(capital_map_iterator, "MapIterator")                        \
  V(capital_regexp_string_iterator, "RegExpStringIterator")     \
  V(capital_async_function, "AsyncFunction")                    \
  V(capital_async_generator, "AsyncGenerator")                  \
  V(capital_async_generator_function, "AsyncGeneratorFunction") \
  V(capital_async_function_resolve, "AsyncFunctionResolve")     \
  V(capital_async_function_reject, "AsyncFunctionReject")       \
  V(capital_async_from_sync_iterator, "AsyncFromSyncIterator")  \
  V(capital_promise_resolve_func, "PromiseResolveFunction")     \
  V(capital_promise_reject_func, "PromiseRejectFunction")       \
  V(capital_array, "Array")                                     \
  V(array, "array")                                             \
  V(capital_proxy, "Proxy")                                     \
  V(proxy, "proxy")                                             \
  V(capital_regexp, "Regexp")                                   \
  V(regexp, "regexp")                                           \
  V(capital_dataview, "DataView")                               \
  V(dataview, "dataview")                                       \
  V(error, "error")                                             \
  V(typedarray, "typedarray")                                   \
  V(capital_date, "Date")                                       \
  V(date, "date")                                               \
  V(capital_function, "Function")                               \
  V(capital_generator_function, "GeneratorFunction")            \
  V(capital_generator, "Generator")                             \
  V(capital_weak_set, "WeakSet")                                \
  V(weak_set, "weakset")                                        \
  V(capital_weak_map, "WeakMap")                                \
  V(weak_map, "weakmap")                                        \
  V(capital_set, "Set")                                         \
  V(set, "set")                                                 \
  V(capital_map, "Map")                                         \
  V(map, "map")                                                 \
  V(generator, "generator")                                     \
  V(promise, "promise")                                         \
  V(generator_state, "[[GeneratorState]]")                      \
  V(generator_function, "[[GeneratorFunction]]")

namespace primjs {
namespace CpuProfiler {
class CpuProfiler;
}  // namespace CpuProfiler
}  // namespace primjs

typedef enum DebuggerFuncLevelState {
  NO_DEBUGGER,
  DEBUGGER_TOP_LEVEL_FUNCTION,
  DEBUGGER_LOW_LEVEL_FUNCTION,
} DebuggerFuncLevelState;

// location of the pc, including line and column number
typedef struct JSDebuggerLocation {
  // script id of this position
  int32_t script_id{-1};
  int32_t line{-1};
  int64_t column{-1};
} JSDebuggerLocation;

typedef struct JSDebuggerConsole {
  LEPUSValue messages{LEPUS_NULL};
  int32_t length{0};
} JSDebuggerConsole;

struct LEPUSScriptSource {
  struct list_head link; /* ctx->debugger_info->script_list */
  // script url
  char *url;
  // script source
  char *source;
  // script hash
  char *hash;
  // script id
  int32_t id;
  // script length
  int32_t length;
  int32_t end_line;
  // source map url
  char *source_map_url;
  bool is_debug_file;
};

// data structure of debugger breakpoint
struct LEPUSBreakpoint {
  // url:line:column
  LEPUSValue breakpoint_id;
  // script url
  char *script_url;
  // script id
  int32_t script_id;
  // line number
  int32_t line;
  // column number
  int64_t column;
  // condition
  LEPUSValue condition;
  // pc hit this breakpoint
  const uint8_t *pc;
  // specific location
  uint8_t specific_location;
  // pause function
  LEPUSFunctionBytecode *b;
};

// data structure used by get properties related protocols
typedef struct DebuggerSuspendedState {
  LEPUSValue get_properties_array{LEPUS_NULL};
  uint32_t get_properties_array_len{0};
} DebuggerSuspendedState;

typedef struct DebuggerLiteralPool {
#define DebuggerDefineStringPool(name, str) LEPUSValue name{LEPUS_UNDEFINED};
  QJSDebuggerStringPool(DebuggerDefineStringPool)
#undef DebuggerDefineStringPool
} DebuggerLiteralPool;

typedef struct DebuggerFixeShapeObj {
  LEPUSValue response;
  LEPUSValue notification;
  LEPUSValue breakpoint;
  LEPUSValue bp_location;
  LEPUSValue result;
  LEPUSValue preview_prop;
} DebuggerFixeShapeObj;

// data structure of debugger info
struct LEPUSDebuggerInfo {
  // Ctor
  explicit LEPUSDebuggerInfo(LEPUSContext *);
  // Dtor
  ~LEPUSDebuggerInfo();
  void *operator new(std::size_t, LEPUSContext *);
  void operator delete(void *);
  uint32_t ref_count{0};
  LEPUSContext *ctx;  // context
  LEPUSValue debugger_name{LEPUS_UNDEFINED};
  void *opaque{nullptr};
  char *source_code{nullptr};
  struct qjs_queue *message_queue;  // protocol messages queue
  LEPUSBreakpoint *bps{nullptr};    // This is a dynamic array of JSBreakPoint.
  const uint8_t *debugger_current_pc;  // current pc
  struct list_head script_list;        // for debugger: all the debugger scripts
  struct list_head
      bytecode_list;  // for debugger: all the debugger function bytecode
  JSDebuggerLocation step_location;  // location when press step button
  struct DebuggerSuspendedState
      pause_state;  // need update when restart runframe
  struct DebuggerSuspendedState running_state;
  struct DebuggerLiteralPool literal_pool;
  struct DebuggerFixeShapeObj debugger_obj;
  JSDebuggerConsole console;  // use for console.xxx
  // bytecode, corresponding breakpoint id
  std::map<const uint8_t *, LEPUSValue> break_bytecode_map;
  std::shared_ptr<primjs::CpuProfiler::CpuProfiler> cpu_profiler;
  // sampling interval, default val: 100
  uint32_t profiler_interval{100};
  uint32_t step_depth{
      static_cast<uint32_t>(-1)};  // stack depth when press step button
  int32_t breakpoints_num{0};      // breakpoints number
  int32_t end_line_num{-1};
  int32_t is_debugger_enabled{0};
  int32_t is_runtime_enabled{0};
  int32_t is_profiling_enabled{0};
  int32_t breakpoints_capacity{0};
  int32_t next_breakpoint_id{0};
  int32_t max_async_call_stack_depth{0};
  int32_t script_num{0};
  uint8_t special_breakpoints{0};  // for debugger.continueToLocation protocol
  // start line, start column, end line, end column, hash, script size
  uint8_t exception_breakpoint{
      0};  // if need to break when there is an exception,
  // paused if the value is 1
  uint8_t exception_breakpoint_before{0};   // save for state before, use for
                                            // setskipallpauses
  uint8_t breakpoints_is_active{0};         // if breakpoints are active
  uint8_t breakpoints_is_active_before{0};  // save for state before, use for
                                            // setskipallpauses
  uint8_t next_statement_count{0};
  uint8_t step_over_valid{0};  // if step over is valid
  uint8_t step_type{
      0};  // step_type mode, including step in, step over, step out
  // and continue
  bool pause_on_next_statement{false};  // need to pause on next statement
  char *pause_on_next_statement_reason{nullptr};
  bool step_statement{false};
  // if profiling is started, true after Profiler.start
  bool is_profiling_started{false};
};

#define QJSDebuggerRegisterConsole(V) \
  V("log", LOG)                       \
  V("info", INFO)                     \
  V("debug", DEBUG)                   \
  V("error", ERROR)                   \
  V("warn", WARN)                     \
  V("alog", ALOG)                     \
  V("profile", PROFILE)               \
  V("profileEnd", PROFILEEND)         \
  V("report", REPORT)                 \
  V("time", TIME)                     \
  V("timeEnd", TIMEEND)

enum {
#define ConsoleEnum(name, type) JS_CONSOLE_##type,
  QJSDebuggerRegisterConsole(ConsoleEnum)
#undef ConsoleEnum
};

#endif  // SRC_INSPECTOR_DEBUGGER_STRUCT_H_
