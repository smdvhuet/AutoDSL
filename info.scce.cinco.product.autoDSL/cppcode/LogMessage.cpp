#include "LogMessage.h"

#include "Logger.h"

LogMessage::LogMessage(Logger &owner) : owner_(&owner) {}
LogMessage::LogMessage(LogMessage &&other) { *this = std::move(other); }
LogMessage::~LogMessage() { owner_ != nullptr ? owner_->flush(*this) : NULL; }

LogMessage &LogMessage::operator=(LogMessage &&other) {
  if (this != &other) {
    this->owner_ = std::move(other.owner_);
    this->buffer_ = std::move(other.buffer_);
  }

  return *this;
}

LogMessage &LogMessage::operator<<(std::ostream &(*pf)(std::ostream &)) {
  pf(buffer_);
  return *this;
}