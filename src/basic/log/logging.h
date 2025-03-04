// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_BASIC_LOG_LOGGING_H_
#define SRC_BASIC_LOG_LOGGING_H_

#include <memory>
#include <sstream>
#include <string>

#include "quickjs/include/base_export.h"

#if defined(OS_ANDROID)
#include <android/log.h>

#define VLOGW(...) __android_log_print(ANDROID_LOG_WARN, "PRIMJS", __VA_ARGS__)
#define VLOGE(...) __android_log_print(ANDROID_LOG_ERROR, "PRIMJS", __VA_ARGS__)
#define VLOGI(...) __android_log_print(ANDROID_LOG_INFO, "PRIMJS", __VA_ARGS__)
#define VLOGD(...) __android_log_print(ANDROID_LOG_DEBUG, "PRIMJS", __VA_ARGS__)
#else
#include <cstdlib>

#define VLOGW(format, ...) \
  fprintf(stderr, "[PRIMJS] " format "\n", ##__VA_ARGS__)
#define VLOGE(format, ...) \
  fprintf(stderr, "[PRIMJS] " format "\n", ##__VA_ARGS__)
#define VLOGI(format, ...) \
  fprintf(stderr, "[PRIMJS] " format "\n", ##__VA_ARGS__)
#define VLOGD(format, ...) \
  fprintf(stderr, "[PRIMJS] " format "\n", ##__VA_ARGS__)
#endif

namespace primjs {
namespace general {
namespace logging {

class LogMessage;
void Log(LogMessage *msg);

QJS_HIDE void SetMinLogLevel(int level);

QJS_EXPORT int GetMinAllLogLevel();

#define PRIMJS_LOG_LEVEL_VERBOSE -1
#define PRIMJS_LOG_LEVEL_INFO 0
#define PRIMJS_LOG_LEVEL_WARNING 1
#define PRIMJS_LOG_LEVEL_ERROR 2
#define PRIMJS_LOG_LEVEL_FATAL 3
#define PRIMJS_LOG_LEVEL_NUM 4

typedef int LogSeverity;
const LogSeverity LOG_VERBOSE = PRIMJS_LOG_LEVEL_VERBOSE;
const LogSeverity LOG_INFO = PRIMJS_LOG_LEVEL_INFO;
const LogSeverity LOG_WARNING = PRIMJS_LOG_LEVEL_WARNING;
const LogSeverity LOG_ERROR = PRIMJS_LOG_LEVEL_ERROR;
const LogSeverity LOG_FATAL = PRIMJS_LOG_LEVEL_FATAL;
const LogSeverity LOG_NUM_SEVERITIES = PRIMJS_LOG_LEVEL_NUM;

// This class is used to explicitly ignore values in the conditional
// logging macros.  This avoids compiler warnings like "value computed
// is not used" and "statement has no effect".
class LogMessageVoidify {
 public:
  LogMessageVoidify() = default;
  // This has to be an operator with a precedence lower than << but
  // higher than ?:
  void operator&(std::ostream &) {}
};

#define LOG_IS_ON(severity)                      \
  ((primjs::general::logging::LOG_##severity) >= \
   primjs::general::logging::GetMinAllLogLevel())

#define LOG_STREAM(severity)                                        \
  primjs::general::logging::LogMessage(                             \
      __FILE__, __LINE__, primjs::general::logging::LOG_##severity) \
      .stream()

#define LAZY_STREAM(stream, condition) \
  !(condition) ? (void)0               \
               : primjs::general::logging::LogMessageVoidify() & (stream)

// Use this macro to suppress warning if the variable in log is not used.
#define UNUSED_LOG_VARIABLE __attribute__((unused))

#ifndef PRIMJS_MIN_LOG_LEVEL
#define PRIMJS_MIN_LOG_LEVEL PRIMJS_LOG_LEVEL_VERBOSE
#endif

// TODO(zhixuan): Currently, the usage of log macros is like "LOGI("abc" <<
// variable)", which is mixed of stream pattern and format string pattern.
// Change the loggin fashion entirely to format string pattern in future.
#if PRIMJS_MIN_LOG_LEVEL <= PRIMJS_LOG_LEVEL_VERBOSE
#define LOGV(msg) LAZY_STREAM(LOG_STREAM(VERBOSE), LOG_IS_ON(VERBOSE)) << msg
#define DLOGV(msg) LAZY_STREAM(LOG_STREAM(VERBOSE), LOG_IS_ON(VERBOSE)) << msg
#else
#define LOGV(msg)
#define DLOGV(msg)
#endif

#if PRIMJS_MIN_LOG_LEVEL <= PRIMJS_LOG_LEVEL_INFO
#define LOGI(msg) LAZY_STREAM(LOG_STREAM(INFO), LOG_IS_ON(INFO)) << msg
#define DLOGI(msg) LAZY_STREAM(LOG_STREAM(INFO), LOG_IS_ON(INFO)) << msg
#else
#define LOGI(msg)
#define DLOGI(msg)
#endif

#if PRIMJS_MIN_LOG_LEVEL <= PRIMJS_LOG_LEVEL_WARNING
#define LOGW(msg) LAZY_STREAM(LOG_STREAM(WARNING), LOG_IS_ON(WARNING)) << msg
#define DLOGW(msg) LAZY_STREAM(LOG_STREAM(WARNING), LOG_IS_ON(WARNING)) << msg
#else
#define LOGW(msg)
#define DLOGW(msg)
#endif

#if PRIMJS_MIN_LOG_LEVEL <= PRIMJS_LOG_LEVEL_ERROR
#define LOGE(msg) LAZY_STREAM(LOG_STREAM(ERROR), LOG_IS_ON(ERROR)) << msg
#define DLOGE(msg) LAZY_STREAM(LOG_STREAM(ERROR), LOG_IS_ON(ERROR)) << msg
#else
#define LOGE(msg)
#define DLOGE(msg)
#endif

#if PRIMJS_MIN_LOG_LEVEL <= PRIMJS_LOG_LEVEL_FATAL
#define LOGF(msg) LAZY_STREAM(LOG_STREAM(FATAL), LOG_IS_ON(FATAL)) << msg
#define DLOGF(msg) LAZY_STREAM(LOG_STREAM(FATAL), LOG_IS_ON(FATAL)) << msg
#else
#define LOGF(msg)
#define DLOGF(msg)
#endif

#ifndef DCHECK
// for debug, if check failed, log fatal and abort
#if !defined(NDEBUG)
#define DCHECK(condition)                      \
  LAZY_STREAM(LOG_STREAM(FATAL), !(condition)) \
      << "Check failed: " #condition ". "
#else
// for release, do nothing
#define DCHECK(condition) !(condition) ? (void)0 : (void)0
#endif
#endif

#define NOTREACHED() LOGF("")

class QJS_EXPORT LogMessage {
 public:
  LogMessage(const char *file, int line, LogSeverity severity);
  ~LogMessage();
  std::ostringstream &stream();
  LogSeverity severity() { return severity_; }

 private:
  void Init(const char *file, int line);

  LogSeverity severity_;
  std::ostringstream stream_;

  const char *file_;
  const int line_;
  LogMessage(const LogMessage &) = delete;
  LogMessage &operator=(const LogMessage &) = delete;
};

}  // namespace logging
}  // namespace general
}  // namespace primjs

#endif  // SRC_BASIC_LOG_LOGGING_H_
