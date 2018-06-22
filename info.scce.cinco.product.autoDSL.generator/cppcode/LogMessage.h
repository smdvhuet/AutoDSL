#ifndef ACCPLUSPLUS_LOGMESSAGE_H_
#define ACCPLUSPLUS_LOGMESSAGE_H_

#include <sstream>

namespace ACCPlusPlus {

class Logger;

class LogMessage {
  friend class Logger;

public:
  LogMessage(Logger &owner);
  LogMessage(LogMessage &&other);
  ~LogMessage();

  LogMessage &operator=(LogMessage &&other);

  template <typename T> LogMessage &operator<<(const T &msg) {
    buffer_ << msg;
    return *this;
  }

  LogMessage &operator<<(std::ostream &(*pf)(std::ostream &));

private:
  Logger *owner_;
  std::ostringstream buffer_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_LOGMESSAGE_H_