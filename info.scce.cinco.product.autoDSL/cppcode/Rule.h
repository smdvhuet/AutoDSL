#ifndef ACCPLUSPLUS_RULE_H_
#define ACCPLUSPLUS_RULE_H_

#include "IO.h"
#include "Type.h"

#include <map>

namespace ACCPlusPlus {
class Rule : public Type {
public:
  Rule() : Type() {}
  virtual ~Rule() {}

  virtual void onEntry() = 0;
  virtual void Execute(const IO::CarInputs &, IO::CarOutputs &) = 0;
  virtual void onExit() = 0;
};

namespace Globals {
static std::map<Utility::IDType, Rule *> gRuleRegister;
}
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_RULE_H_