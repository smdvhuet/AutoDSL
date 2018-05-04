#ifndef ACCPLUSPLUS_TYPE_H_
#define ACCPLUSPLUS_TYPE_H_

#include "IDGenerator.h"
#include <string>

namespace ACCPlusPlus{
class Type{
public:
  Type(const std::string &name) { id_ = Globals::gIDGenerator.createID(); name_ = name; }
  virtual ~Type(){};

  std::string Name() { return name_; }
  Utility::IDType ID() const { return id_; }

  bool operator==(const Type &rhs) const {
    return this->id_ == rhs.id_;
  }

private:
  Utility::IDType id_;
  std::string name_;
};
}
#endif // ACCPLUSPLUS_TYPE_H_