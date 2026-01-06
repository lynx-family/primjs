// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_WASM_LOG_
#define SRC_WASM_COMMON_WASM_LOG_

#include <cstdio>

#define LOG_LEVEL_VERBOSE 5
#define LOG_LEVEL_DEBUG 4
#define LOG_LEVEL_INFO 3
#define LOG_LEVEL_ERROR 2
#define LOG_LEVEL_FATAL 1

#ifndef LOG_LEVEL
#define LOG_LEVEL LOG_LEVEL_INFO
#endif

#if defined(OS_ANDROID)  // android
#include <android/log.h>

#define WASM_LOGD(format, ...) \
  __android_log_print(ANDROID_LOG_DEBUG, "WasmDebug", format, ##__VA_ARGS__)
#define WASM_LOGI(format, ...) \
  __android_log_print(ANDROID_LOG_INFO, "WasmInfo", format, ##__VA_ARGS__)
#define WASM_LOGE(format, ...) \
  __android_log_print(ANDROID_LOG_ERROR, "WasmError", format, ##__VA_ARGS__)
#define WASM_LOGW(format, ...) \
  __android_log_print(ANDROID_LOG_WARN, "WasmWarn", format, ##__VA_ARGS__)
#else
#include <cstdlib>

#define WASM_LOGD(format, ...) \
  // fprintf(stderr, "[WasmDebug] " format "\n", ##__VA_ARGS__)
#define WASM_LOGI(format, ...) \
  // fprintf(stderr, "[WasmInfo] " format "\n", ##__VA_ARGS__)
#define WASM_LOGW(format, ...) \
  // fprintf(stderr, "[WasmWarn] " format "\n", ##__VA_ARGS__)
#define WASM_LOGE(format, ...) \
  fprintf(stderr, "[WasmError] " format "\n", ##__VA_ARGS__)

#endif  // OS_ANDROID

#include <string>

template <typename... Args>
std::string format_to_string(const char* format, Args&&... args) {
  int length = std::snprintf(nullptr, 0, format, std::forward<Args>(args)...);
  std::string result(length + 1, '\0');
  std::snprintf(&result[0], length + 1, format, std::forward<Args>(args)...);
  return result;
}

#if defined(OS_ANDROID) || defined(OS_IOS)
#include "basic/log/logging.h"
#else
#define LOGV(...) ((void)0)
#define LOGI(...) ((void)0)
#define LOGW(...) ((void)0)
#define LOGE(...) ((void)0)
#endif

#if !defined(WLOGD) && (LOG_LEVEL >= LOG_LEVEL_VERBOSE) && \
    defined(ENABLE_MONITOR)
#define WLOGD(format, ...)                         \
  do {                                             \
    WASM_LOGD(format, ##__VA_ARGS__);              \
    LOGV(format_to_string(format, ##__VA_ARGS__)); \
  } while (0)
#else
#define WLOGD(format, ...) ((void)0)
#endif

#if !defined(WLOGI) && (LOG_LEVEL >= LOG_LEVEL_INFO) && defined(ENABLE_MONITOR)
#define WLOGI(format, ...)                         \
  do {                                             \
    WASM_LOGI(format, ##__VA_ARGS__);              \
    LOGI(format_to_string(format, ##__VA_ARGS__)); \
  } while (0)
#else
#define WLOGI(format, ...) ((void)0)
#endif

#if !defined(WLOGW) && (LOG_LEVEL >= LOG_LEVEL_ERROR) && defined(ENABLE_MONITOR)
#define WLOGW(format, ...)                         \
  do {                                             \
    WASM_LOGW(format, ##__VA_ARGS__);              \
    LOGW(format_to_string(format, ##__VA_ARGS__)); \
  } while (0)
#else
#define WLOGW(format, ...) ((void)0)
#endif

#if !defined(WLOGE) && (LOG_LEVEL >= LOG_LEVEL_ERROR) && defined(ENABLE_MONITOR)
#define WLOGE(format, ...)                         \
  do {                                             \
    WASM_LOGE(format, ##__VA_ARGS__);              \
    LOGE(format_to_string(format, ##__VA_ARGS__)); \
  } while (0)
#else
#define WLOGE(format, ...) ((void)0)
#endif

#endif  // SRC_WASM_COMMON_WASM_LOG_
