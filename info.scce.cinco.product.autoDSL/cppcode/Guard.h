#ifndef ACCPLUSPLUS_GUARD_H_
#define ACCPLUSPLUS_GUARD_H_

#include "GuardRule.h"

#include <vector>

namespace ACCPlusPlus {
class Guard : public GuardRule {
public:
  Guard(const std::string &, std::vector<GuardRule *> &);
  ~Guard();

  void onEntry();
  bool Execute(const IO::CarInputs &);
  void onExit();

private:
  const std::vector<GuardRule *> guards_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_GUARD_H_