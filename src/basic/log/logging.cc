// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "basic/log/logging.h"

#include <algorithm>
#include <cstring>
#include <ctime>
#include <iomanip>
#include <ostream>
#include <string>

namespace primjs {
namespace general {
namespace logging {
namespace {

const char *const log_severity_names[LOG_NUM_SEVERITIES] = {"INFO", "WARNING",
                                                            "ERROR", "FATAL"};

const char *log_severity_name(int severity) {
  if (severity >= 0 && severity < LOG_NUM_SEVERITIES)
    return log_severity_names[severity];
  return "UNKNOWN";
}

int g_min_log_level = 0;
}  // namespace

void SetMinLogLevel(int level) { g_min_log_level = std::min(LOG_FATAL, level); }

int GetMinAllLogLevel() { return std::min(g_min_log_level, LOG_INFO); }

LogMessage::LogMessage(const char *file, int line, LogSeverity severity)
    : severity_(severity), file_(file), line_(line) {
  Init(file_, line_);
}

std::ostringstream &LogMessage::stream() { return stream_; }

LogMessage::~LogMessage() {
  // on Windows, use spdlog which add newline at the end of each line.
#if !defined(_WIN32)
  stream_ << std::endl;
  primjs::general::logging::Log(this);
#else
  std::string str_newline(stream_.str());
  printf("primjs: %s\n", str_newline.c_str());
#endif

  if (severity_ == LOG_FATAL) {
    abort();
  }
}

// writes the common header info to the stream
void LogMessage::Init(const char *file, int line) {
  std::string filename(file);
  size_t last_slash_pos = filename.find_last_of("\\/");
  if (last_slash_pos != std::string::npos) {
    size_t size = last_slash_pos + 1;
    filename = filename.substr(size, filename.length() - size);
  }

  stream_ << '[';
  time_t t = time(NULL);
  struct tm local_time = {};

#if !defined(_WIN32)
  localtime_r(&t, &local_time);
#else
  localtime_s(&local_time, &t);
#endif

  struct tm *tm_time = &local_time;
  stream_ << std::setfill('0') << std::setw(2) << 1 + tm_time->tm_mon
          << std::setw(2) << tm_time->tm_mday << '/' << std::setw(2)
          << tm_time->tm_hour << std::setw(2) << tm_time->tm_min << std::setw(2)
          << tm_time->tm_sec << ':';

  if (severity_ >= 0)
    stream_ << log_severity_name(severity_);
  else
    stream_ << "VERBOSE" << -severity_;

  stream_ << ":" << filename << "(" << line << ")] ";
}

}  // namespace logging
}  // namespace general
}  // namespace primjs
