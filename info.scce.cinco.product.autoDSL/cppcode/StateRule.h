#ifndef ACCPLUSPLUS_STATERULE_H_
#define ACCPLUSPLUS_STATERULE_H_

#include "IO.h"
#include "Type.h"

#include <map>

namespace ACCPlusPlus {
class StateRule : public Type {
public:
  StateRule(const std::string &name) : Type(name) {}
  virtual ~StateRule() {}

  virtual void onEntry() = 0;
  virtual void Execute(const IO::CarInputs &, IO::CarOutputs &) = 0;
  virtual void onExit() = 0;
};

namespace Globals {
static std::map<Utility::IDType, StateRule *> gRuleRegister;
}
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_STATERULE_H_