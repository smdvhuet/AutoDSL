#ifndef ACCPLUSPLUS_GUARDRULE_H_
#define ACCPLUSPLUS_GUARDRULE_H_

#include "IO.h"
#include "Type.h"

#include <map>

namespace ACCPlusPlus {
  class GuardRule : public Type {
  public:
    GuardRule(const std::string& name) : Type(name) {}
    virtual ~GuardRule() {}

    virtual void onEntry() = 0;
    virtual bool Execute(const IO::CarInputs &) = 0;
    virtual void onExit() = 0;
  };

  namespace Globals {
    static std::map<Utility::IDType, GuardRule *> gGuardRuleRegister;
  }
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_GUARDRULE_H_