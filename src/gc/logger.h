#ifndef SRC_GC_LOGGER_H_
#define SRC_GC_LOGGER_H_

#include <chrono>
#include <iostream>
#include <sstream>
#include <string>

#ifdef ENABLE_GC_LOG
#define LOG(level)                        \
  if (!ROS_GC::LogBase::ShouldLog(level)) \
    ;                                     \
  else                                    \
    ROS_GC::LogStream(level)
#define SCOPED_LOGGER(taskName) ScopedLogger taskName##ScopedLogger(taskName)
#else
#define LOG(level) \
  if (true) {      \
  } else           \
    std::cerr
#define SCOPED_LOGGER(taskName)
#endif  // ENABLE_GC_LOG

namespace ROS_GC {

enum LogLevel {
  LEVEL_0 = 0,  // GC time statistics
  LEVEL_1,      // Mark/Sweep Record
  LEVEL_2,
  ERROR
};

class LogBase {
 public:
  LogBase(LogLevel level);
  ~LogBase() = default;

  static bool ShouldLog(LogLevel level);

 protected:
  static std::string LogLevelToString(LogLevel level);

  static LogLevel currentLevel;

  LogLevel logLevel;
};

class LogStream : public LogBase {
 public:
  LogStream(LogLevel level);
  ~LogStream();

  static void SetLevel(LogLevel level);

  template <typename T>
  inline LogStream &operator<<(const T &msg) {
    stream << msg;
    return *this;
  }

 private:
  std::ostringstream stream;
};

class ScopedLogger : public LogBase {
 public:
  ScopedLogger(const std::string &name);
  ~ScopedLogger();

 private:
  std::string taskName;
  std::chrono::time_point<std::chrono::steady_clock> start;
};

}  // namespace ROS_GC

#endif  // SRC_GC_LOGGER_H_
