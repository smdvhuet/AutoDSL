#ifndef ACCPLUSPLUS_ISTATE_H_
#define ACCPLUSPLUS_ISTATE_H_

#include "Type.h"

#include <map>

namespace ACCPlusPlus {
class State : public Type{
public:
  State();
  virtual ~State();

  virtual void onEntry() = 0;
  virtual void Execute() = 0;
  virtual void onExit() = 0;
};

namespace Globals{
  static std::map<Utility::IDType, State*> gStateRegister;
}
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_ISTATE_H_