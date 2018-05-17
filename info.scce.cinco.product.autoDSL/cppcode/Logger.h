#ifndef ACCPLUSPLUS_LOGGER_H_
#define ACCPLUSPLUS_LOGGER_H_

#include "ILogSink.h"
#include "LogMessage.h"
#include <vector>

class Logger {
public:
  void flush(const LogMessage &msg) {
    std::string flush_string = msg.buffer_.str() + "\n";
    for (int i = 0; i < sinks_.size(); i++)
      (*sinks_[i])(flush_string);
  }
  LogMessage operator()() { return LogMessage(*this); }

  std::vector<ILogSink *> sinks_;
};

#endif // ACCPLUSPLUS_LOGGER_H_