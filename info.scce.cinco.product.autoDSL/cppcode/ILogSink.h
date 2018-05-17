#ifndef ACCPLUSPLUS_ILOGSINK_H_
#define ACCPLUSPLUS_ILOGSINK_H_

#include <string>

class ILogSink {
public:
  virtual void operator()(const std::string &log_msg) = 0;
};

class ToConsole : public ILogSink {
  void operator()(const std::string &log_msg) { printf(log_msg.c_str()); };
};

#endif // ACCPLUSPLUS_ILOGSINK_H_