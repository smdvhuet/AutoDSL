#ifndef ACCPLUSPLUS_NEUTRALRULE_H_
#define ACCPLUSPLUS_NEUTRALRULE_H_

#include "IO.h"
#include "Type.h"

#include <map>

namespace ACCPlusPlus {
  class NeutralRule : public Type {
  public:
    NeutralRule(const std::string& name) : Type(name) {}
    virtual ~NeutralRule() {}

    virtual void onEntry() = 0;
    virtual void Execute(const IO::CarInputs &) = 0;
    virtual void onExit() = 0;
  };

  namespace Globals {
    static std::map<Utility::IDType, NeutralRule *> gNeutralRuleRegister;
  }
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_NEUTRALRULE_H_