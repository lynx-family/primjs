#ifdef ENABLE_COMPATIBLE_MM
#include "gc/logger.h"

#if defined(ANDROID) || defined(__ANDROID__)
#include <android/log.h>
#endif
namespace ROS_GC {

#define GC_LOG_LEVEL 0
LogLevel LogBase::currentLevel = (LogLevel)GC_LOG_LEVEL;

LogBase::LogBase(LogLevel level) : logLevel(level) {}

// static
bool LogBase::ShouldLog(LogLevel level) { return level <= currentLevel; }

std::string LogBase::LogLevelToString(LogLevel level) {
  switch (level) {
    case LogLevel::LEVEL_0:
      return "[LEVEL_0]";
    case LogLevel::LEVEL_1:
      return "[LEVEL_1]";
    case LogLevel::LEVEL_2:
      return "[LEVEL_2]";
    case LogLevel::ERROR:
      return "[ERROR]";
    default:
      return "[UNKNOWN]";
  }
}

LogStream::LogStream(LogLevel level) : LogBase(level) {}

LogStream::~LogStream() {
#if defined(ANDROID) || defined(__ANDROID__)
  __android_log_print(ANDROID_LOG_ERROR, "PRIMJS_GC", "%s\n",
                      stream.str().c_str());
#else
  std::cout << LogLevelToString(logLevel) << ": " << stream.str() << std::endl;
#endif
}

void LogStream::SetLevel(LogLevel level) { currentLevel = level; }

ScopedLogger::ScopedLogger(const std::string &name)
    : LogBase(LEVEL_0),
      taskName(name),
      start(std::chrono::steady_clock::now()) {}

ScopedLogger::~ScopedLogger() {
  auto end = std::chrono::steady_clock::now();
  auto duration = std::chrono::duration<double, std::milli>(end - start);
#if defined(ANDROID) || defined(__ANDROID__)
  __android_log_print(ANDROID_LOG_ERROR, "PRIMJS_GC", "%s: %s took %f ms\n",
                      LogLevelToString(logLevel).c_str(), taskName.c_str(),
                      duration.count());
#else
  std::cout << LogLevelToString(logLevel) << ": " << taskName << " took "
            << duration.count() << " ms\n";
#endif
}

}  // namespace ROS_GC
#endif  // ENABLE_COMPATIBLE_MM
