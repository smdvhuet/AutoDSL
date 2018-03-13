#ifndef ACCPLUSPLUS_GUARD_H_
#define ACCPLUSPLUS_GUARD_H_

#include "GuardRule.h"

#include <vector>

namespace ACCPlusPlus {
class Guard {
public:
  Guard();
  ~Guard();

  void onEntry();
  bool Execute(const IO::CarInputs &);
  void onExit();

  std::string Name();

  void AddGuardRule(GuardRule *const &state);

private:
  std::vector<GuardRule *> guards_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_GUARD_H_