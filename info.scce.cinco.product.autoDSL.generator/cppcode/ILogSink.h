#ifndef ACCPLUSPLUS_ILOGSINK_H_
#define ACCPLUSPLUS_ILOGSINK_H_

#include <string>
#include <iostream>
#include <fstream>

namespace ACCPlusPlus {

class ILogSink {
public:
  virtual void operator()(const std::string &log_msg) = 0;
};

class LogToConsole : public ILogSink {
public:
  void operator()(const std::string &log_msg) { printf("%s", log_msg.c_str()); };
};

class LogToFile : public ILogSink {
public:
  LogToFile(const std::string& filename) { file_.open(filename, std::ios::trunc); }
  void operator()(const std::string &log_msg) { file_ << log_msg; };

private: 
  std::ofstream file_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_ILOGSINK_H_