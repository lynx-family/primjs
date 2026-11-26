// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_WASM_LOG_
#define SRC_WASM_COMMON_WASM_LOG_

#if defined(OS_ANDROID)
#include <android/log.h>
#elif defined(OS_IOS) || defined(OS_HARMONY)
#include "basic/log/logging.h"
#endif

#define LOG_LEVEL_VERBOSE 5
#define LOG_LEVEL_DEBUG 4
#define LOG_LEVEL_INFO 3
#define LOG_LEVEL_ERROR 2
#define LOG_LEVEL_FATAL 1

#ifndef LOG_LEVEL
#define LOG_LEVEL LOG_LEVEL_INFO
#endif

namespace primjs::wasm {
#if defined(__GNUC__) || defined(__clang__)
__attribute__((cold, noinline, format(printf, 2, 3)))
#endif
void WasmLogPrint(int level, const char* format, ...);
}  // namespace primjs::wasm

#if !defined(WLOGD) && (LOG_LEVEL >= LOG_LEVEL_VERBOSE) && \
    defined(ENABLE_MONITOR)
#define WLOGD(format, ...) \
  ::primjs::wasm::WasmLogPrint(LOG_LEVEL_DEBUG, format, ##__VA_ARGS__)
#else
#define WLOGD(format, ...) ((void)0)
#endif

#if !defined(WLOGI) && (LOG_LEVEL >= LOG_LEVEL_INFO) && defined(ENABLE_MONITOR)
#define WLOGI(format, ...) \
  ::primjs::wasm::WasmLogPrint(LOG_LEVEL_INFO, format, ##__VA_ARGS__)
#else
#define WLOGI(format, ...) ((void)0)
#endif

#if !defined(WLOGW) && (LOG_LEVEL >= LOG_LEVEL_ERROR) && defined(ENABLE_MONITOR)
#define WLOGW(format, ...) \
  ::primjs::wasm::WasmLogPrint(LOG_LEVEL_ERROR, format, ##__VA_ARGS__)
#else
#define WLOGW(format, ...) ((void)0)
#endif

#if !defined(WLOGE) && (LOG_LEVEL >= LOG_LEVEL_ERROR) && defined(ENABLE_MONITOR)
#define WLOGE(format, ...) \
  ::primjs::wasm::WasmLogPrint(LOG_LEVEL_ERROR, format, ##__VA_ARGS__)
#else
#define WLOGE(format, ...) ((void)0)
#endif

#endif  // SRC_WASM_COMMON_WASM_LOG_
