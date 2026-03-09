// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <stdio.h>
#include <string.h>
#include <time.h>

#include <chrono>
#include <condition_variable>
#include <cstring>
#include <fstream>
#include <iostream>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

#include "common/wasm_type.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"
#include "wasm/qjs/qjs_wasm.h"

struct TimerTask {
  int64_t deadline;
  LEPUSValue func;
  LEPUSContext *ctx;
};

static std::vector<TimerTask> timer_tasks;
static std::mutex tasks_mutex;
static std::condition_variable tasks_cv;
static bool stop_thread = false;
static std::thread timer_thread;
static std::atomic<int> task_cnt{0};
static std::atomic<bool> ctx_invalid{false};

void timer_thread_func() {
  while (!stop_thread) {
    std::unique_lock<std::mutex> lock(tasks_mutex);
    if (timer_tasks.empty()) {
      tasks_cv.wait(lock, [] { return stop_thread || !timer_tasks.empty(); });
    } else {
      auto now = std::chrono::steady_clock::now();
      int64_t now_ms =
          std::chrono::time_point_cast<std::chrono::milliseconds>(now)
              .time_since_epoch()
              .count();

      if (timer_tasks.front().deadline <= now_ms) {
        TimerTask task = timer_tasks.front();
        std::pop_heap(timer_tasks.begin(), timer_tasks.end(),
                      [](const TimerTask &a, const TimerTask &b) {
                        return a.deadline > b.deadline;
                      });
        timer_tasks.pop_back();
        lock.unlock();

        if (!ctx_invalid) {
          LEPUS_Call(task.ctx, task.func, LEPUS_UNDEFINED, 0, nullptr);
          LEPUS_FreeValue(task.ctx, task.func);
        }
        --task_cnt;
      } else {
        tasks_cv.wait_for(lock, std::chrono::milliseconds(
                                    timer_tasks.front().deadline - now_ms));
      }
    }
  }
}

void init_thread() { timer_thread = std::thread(timer_thread_func); }

void cleanup_thread() {
  {
    std::unique_lock<std::mutex> lock(tasks_mutex);
    stop_thread = true;
  }
  tasks_cv.notify_all();
  if (timer_thread.joinable()) {
    timer_thread.join();
  }
}

void PostTaskDelay(LEPUSContext *ctx, LEPUSValue func, int interval) {
  auto now = std::chrono::steady_clock::now();
  int64_t deadline =
      std::chrono::time_point_cast<std::chrono::milliseconds>(now)
          .time_since_epoch()
          .count() +
      interval;

  {
    std::unique_lock<std::mutex> lock(tasks_mutex);
    timer_tasks.push_back({deadline, LEPUS_DupValue(ctx, func), ctx});
    std::push_heap(timer_tasks.begin(), timer_tasks.end(),
                   [](const TimerTask &a, const TimerTask &b) {
                     return a.deadline > b.deadline;
                   });
  }
  ++task_cnt;
  tasks_cv.notify_one();
}

size_t read_js(const char *file_name, uint8_t **result, bool is_binary) {
  std::ifstream file_in(
      file_name, is_binary ? (std::ios::in | std::ios::binary) : std::ios::in);
  if (!file_in.is_open()) return 0;

  file_in.seekg(0, std::ios::end);
  size_t len = file_in.tellg();
  file_in.seekg(0, std::ios::beg);

  uint8_t *buf = (uint8_t *)malloc(len + (is_binary ? 0 : 1));
  if (!buf) return 0;

  file_in.read((char *)buf, len);
  if (!is_binary) buf[len] = '\0';
  file_in.close();

  *result = buf;
  return len + (is_binary ? 0 : 1);
}

double execute_js(LEPUSContext *ctx, const char *script, bool test_cache,
                  LEPUSValue *result) {
  clock_t _start, _end;
  if (test_cache) {
    LEPUSValue top_func =
        LEPUS_Eval(ctx, script, strlen(script), "",
                   LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL);
    if (!LEPUS_IsException(top_func) && !LEPUS_IsUndefined(top_func)) {
      _start = clock();
      LEPUSValue global = LEPUS_GetGlobalObject(ctx);
      *result = LEPUS_EvalFunction(ctx, top_func, global);
      _end = clock();
    } else {
      return -1;
    }
  } else {
    _start = clock();
    *result =
        LEPUS_Eval(ctx, script, strlen(script), "", LEPUS_EVAL_TYPE_GLOBAL);
    _end = clock();
  }
  return (_end - _start) * 1000 / CLOCKS_PER_SEC;
}

void inject_js_function_gc(LEPUSContext *ctx) {
  LEPUSValue global = LEPUS_GetGlobalObject(ctx);

  LEPUSValue logger = LEPUS_NewCFunction(
      ctx,
      [](LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
         LEPUSValueConst *argv) {
        const char *msg = LEPUS_ToCString(ctx, argv[0]);
        if (!msg)
          WLOGI("JsException");
        else
          std::cout << msg << std::endl;

        return LEPUS_UNDEFINED;
      },
      "log", 1);
  HandleScope func_scope(ctx, &logger, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue console = LEPUS_NewObject(ctx);
  func_scope.PushHandle(&console, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyStr(ctx, global, "console", console);
  LEPUS_DefinePropertyValueStr(ctx, console, "log", logger, LEPUS_PROP_C_W_E);
  LEPUS_SetPropertyStr(ctx, global, "print", logger);

  LEPUSValue reader = LEPUS_NewCFunction(
      ctx,
      [](LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
         LEPUSValueConst *argv) {
        const char *file_path = LEPUS_ToCString(ctx, argv[0]);
        const char *option = LEPUS_ToCString(ctx, argv[1]);
        bool is_binary = option && strcmp(option, "binary") == 0;

        if (file_path) {
          uint8_t *res = NULL;
          size_t len = read_js(file_path, &res, is_binary);

          if (res && is_binary) {
            return LEPUS_NewArrayBuffer(
                ctx, res, len,
                [](LEPUSRuntime *rt, void *opaque, void *ptr) { free(ptr); },
                nullptr, false);
          } else if (res) {
            return LEPUS_NewStringLen(ctx, (char *)res, len);
          }
        }

        return LEPUS_EXCEPTION;
      },
      "read", 1);
  func_scope.PushHandle(&reader, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_DefinePropertyValueStr(ctx, global, "read", reader,
                               LEPUS_PROP_CONFIGURABLE);

  LEPUSValue loadFunc = LEPUS_NewCFunction(
      ctx,
      [](LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
         LEPUSValueConst *argv) {
        const char *file_path = LEPUS_ToCString(ctx, argv[0]);
        if (file_path) {
          uint8_t *res = NULL;
          size_t len = read_js(file_path, &res, false);

          if (res) {
            return LEPUS_Eval(ctx, (const char *)res, len, "",
                              LEPUS_EVAL_TYPE_GLOBAL);
          } else {
            return LEPUS_ThrowInternalError(ctx, "reading %s failed.",
                                            file_path);
          }
        }

        return LEPUS_EXCEPTION;
      },
      "load", 1);
  func_scope.PushHandle(&loadFunc, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_DefinePropertyValueStr(ctx, global, "load", loadFunc,
                               LEPUS_PROP_CONFIGURABLE);
  LEPUS_DefinePropertyValueStr(ctx, global, "require", loadFunc,
                               LEPUS_PROP_CONFIGURABLE);

  LEPUSValue timeoutFunc = LEPUS_NewCFunction(
      ctx,
      [](LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
         LEPUSValueConst *argv) {
        if (!LEPUS_IsFunction(ctx, argv[0])) {
          return LEPUS_EXCEPTION;
        }
        int out_time;
        if (LEPUS_ToInt32(ctx, &out_time, argv[1]) || out_time < 0) {
          return LEPUS_EXCEPTION;
        }
        PostTaskDelay(ctx, argv[0], out_time);
        return LEPUS_UNDEFINED;
      },
      "setTimeout", 2);
  func_scope.PushHandle(&timeoutFunc, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_DefinePropertyValueStr(ctx, global, "setTimeout", timeoutFunc,
                               LEPUS_PROP_CONFIGURABLE);
}

void inject_js_function(LEPUSContext *ctx) {
  if (LEPUS_IsGCMode(ctx)) {
    inject_js_function_gc(ctx);
    return;
  }
  LEPUSValue global = LEPUS_GetGlobalObject(ctx);

  LEPUSValue logger = LEPUS_NewCFunction(
      ctx,
      [](LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
         LEPUSValueConst *argv) {
        const char *msg = LEPUS_ToCString(ctx, argv[0]);
        if (!msg)
          WLOGI("JsException");
        else
          std::cout << msg << std::endl;

        LEPUS_FreeCString(ctx, msg);
        return LEPUS_UNDEFINED;
      },
      "log", 1);
  LEPUSValue console = LEPUS_NewObject(ctx);
  LEPUS_SetPropertyStr(ctx, global, "console", console);
  LEPUS_DefinePropertyValueStr(ctx, console, "log", logger, LEPUS_PROP_C_W_E);
  LEPUS_SetPropertyStr(ctx, global, "print", LEPUS_DupValue(ctx, logger));

  LEPUSValue reader = LEPUS_NewCFunction(
      ctx,
      [](LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
         LEPUSValueConst *argv) {
        const char *file_path = LEPUS_ToCString(ctx, argv[0]);
        const char *option = LEPUS_ToCString(ctx, argv[1]);
        bool is_binary = option && strcmp(option, "binary") == 0;
        LEPUS_FreeCString(ctx, option);

        if (file_path) {
          uint8_t *res = NULL;
          size_t len = read_js(file_path, &res, is_binary);
          LEPUS_FreeCString(ctx, file_path);

          if (res && is_binary) {
            return LEPUS_NewArrayBuffer(
                ctx, res, len,
                [](LEPUSRuntime *rt, void *opaque, void *ptr) { free(ptr); },
                nullptr, false);
          } else if (res) {
            return LEPUS_NewStringLen(ctx, (char *)res, len);
          }
        }

        LEPUS_FreeCString(ctx, file_path);
        return LEPUS_EXCEPTION;
      },
      "read", 1);
  LEPUS_DefinePropertyValueStr(ctx, global, "read", reader,
                               LEPUS_PROP_CONFIGURABLE);

  LEPUSValue loadFunc = LEPUS_NewCFunction(
      ctx,
      [](LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
         LEPUSValueConst *argv) {
        const char *file_path = LEPUS_ToCString(ctx, argv[0]);
        if (file_path) {
          uint8_t *res = NULL;
          size_t len = read_js(file_path, &res, false);
          LEPUS_FreeCString(ctx, file_path);

          if (res) {
            return LEPUS_Eval(ctx, (const char *)res, len, "",
                              LEPUS_EVAL_TYPE_GLOBAL);
          } else {
            return LEPUS_ThrowInternalError(ctx, "reading %s failed.",
                                            file_path);
          }
        }

        LEPUS_FreeCString(ctx, file_path);
        return LEPUS_EXCEPTION;
      },
      "load", 1);
  LEPUS_DefinePropertyValueStr(ctx, global, "load", loadFunc,
                               LEPUS_PROP_CONFIGURABLE);
  LEPUS_DefinePropertyValueStr(ctx, global, "require",
                               LEPUS_DupValue(ctx, loadFunc),
                               LEPUS_PROP_CONFIGURABLE);

  LEPUSValue timeoutFunc = LEPUS_NewCFunction(
      ctx,
      [](LEPUSContext *ctx, LEPUSValueConst this_val, int argc,
         LEPUSValueConst *argv) {
        if (!LEPUS_IsFunction(ctx, argv[0])) {
          return LEPUS_EXCEPTION;
        }
        int out_time;
        if (LEPUS_ToInt32(ctx, &out_time, argv[1]) || out_time < 0) {
          return LEPUS_EXCEPTION;
        }
        PostTaskDelay(ctx, argv[0], out_time);
        return LEPUS_UNDEFINED;
      },
      "setTimeout", 2);
  LEPUS_DefinePropertyValueStr(ctx, global, "setTimeout", timeoutFunc,
                               LEPUS_PROP_CONFIGURABLE);
  LEPUS_FreeValue(ctx, global);
}

std::string GetExceptionMessage_GC(LEPUSContext *ctx) {
  LEPUSValue exception_val = LEPUS_GetException(ctx);
  HandleScope func_scope(ctx, &exception_val, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue val;
  const char *stack;
  const char *message = LEPUS_ToCString(ctx, exception_val);
  std::string ret = "lepus: ";
  if (message) {
    ret += message;
  }
  ret += "\n";

  bool is_error = LEPUS_IsError(ctx, exception_val);
  if (is_error) {
    val = LEPUS_GetPropertyStr(ctx, exception_val, "message");
    if (!LEPUS_IsUndefined(val)) {
      message = LEPUS_ToCString(ctx, val);
      ret += message;
      ret += "\n";
    }
    val = LEPUS_GetPropertyStr(ctx, exception_val, "stack");
    if (!LEPUS_IsUndefined(val)) {
      stack = LEPUS_ToCString(ctx, val);
      ret += stack;
      ret += "\n";
    }
  }
  return ret;
}

std::string GetExceptionMessage(LEPUSContext *ctx) {
  if (LEPUS_IsGCMode(ctx)) {
    return GetExceptionMessage_GC(ctx);
  }
  LEPUSValue exception_val = LEPUS_GetException(ctx);
  LEPUSValue val;
  const char *stack;
  const char *message = LEPUS_ToCString(ctx, exception_val);
  std::string ret = "lepus: ";
  if (message) {
    ret += message;
    LEPUS_FreeCString(ctx, message);
  }
  ret += "\n";

  bool is_error = LEPUS_IsError(ctx, exception_val);
  if (is_error) {
    val = LEPUS_GetPropertyStr(ctx, exception_val, "message");
    if (!LEPUS_IsUndefined(val)) {
      message = LEPUS_ToCString(ctx, val);
      ret += message;
      ret += "\n";
      LEPUS_FreeCString(ctx, message);
    }
    LEPUS_FreeValue(ctx, val);

    val = LEPUS_GetPropertyStr(ctx, exception_val, "stack");
    if (!LEPUS_IsUndefined(val)) {
      stack = LEPUS_ToCString(ctx, val);
      ret += stack;
      ret += "\n";
      LEPUS_FreeCString(ctx, stack);
    }
    LEPUS_FreeValue(ctx, val);
  }
  LEPUS_FreeValue(ctx, exception_val);
  return ret;
}

int HandleResult(bool test_cache, double exec_time, LEPUSContext *ctx,
                 LEPUSValue result) {
  int res = 0;
  if (test_cache && exec_time == -1) {
    WLOGI("JS Compilation errors happened.");
    res = 1;
  } else if (LEPUS_IsException(result)) {
    std::string err_msg = GetExceptionMessage(ctx);
    WLOGI("Exceptions happened in %s", err_msg.c_str());
    res = 1;
  } else {
    if (test_cache)
      WLOGI("in [use_cache] mode");
    else
      WLOGI("in [normal] mode");

    bool ret_exception = LEPUS_ToBool(ctx, result) == -1;
    if (!ret_exception) {
      size_t length;
      const char *str = LEPUS_ToCStringLen(ctx, &length, result);
      WLOGI("result: %s", str);
      if (!LEPUS_IsGCMode(ctx)) {
        LEPUS_FreeCString(ctx, str);
      }
    }
  }
  return res;
}

int main(int argc, char **argv) {
  bool test_cache = false;
  primjs::WasmRuntimeType runtime_type = primjs::WasmRuntimeType::WASM3;
  if (argc < 2) {
    std::cout << " Please enter js file path as an argument." << std::endl;
    return 0;
  } else {
    // default the last parameter is test file
    for (int i = 0; i < argc - 1; i++) {
      if (strcmp(argv[i], "--test-cache") == 0) {
        test_cache = true;
      } else if (strcmp(argv[i], "--wasm-engine") == 0) {
        i += 1;
        if (strcmp(argv[i], "prism") == 0) {
          runtime_type = primjs::WasmRuntimeType::PRISM;
        }
      }
    }
  }
  uint8_t *script;
  const char *file_name = argv[argc - 1];
  read_js(file_name, &script, false);
  if (script == nullptr) {
    std::cout << "Invalid js file path: " << file_name << std::endl;
    return 0;
  }

  init_thread();

  LEPUSRuntime *qjs_runtime_;
  LEPUSContext *ctx;
  LEPUSValue result = LEPUS_UNDEFINED;

  double exec_time = 0;
  int res = 0;

  task_cnt++;

  qjs_runtime_ = LEPUS_NewRuntime();
  ctx = LEPUS_NewContext(qjs_runtime_);

  primjs::qjs::QJSWebAssembly::RegisterWebAssembly(ctx, &ctx_invalid,
                                                   runtime_type);

  inject_js_function(ctx);
  exec_time = execute_js(ctx, (const char *)script, test_cache, &result);
  res = HandleResult(test_cache, exec_time, ctx, result);
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, result);
  }

  --task_cnt;

  while (task_cnt.load() != 0) {
    std::this_thread::sleep_for(std::chrono::milliseconds(200));
  }

  ctx_invalid = true;
  cleanup_thread();
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(qjs_runtime_);
  return res;
}
