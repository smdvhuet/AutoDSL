#ifndef ACCPLUSPLUS_STATE_H_
#define ACCPLUSPLUS_STATE_H_

#include "StateRule.h"

#include <vector>

namespace ACCPlusPlus {
class State : public StateRule {
public:
  State(const std::string &, const std::vector<StateRule *> &);
  ~State();

  void onEntry();
  void Execute(const IO::CarInputs &, IO::CarOutputs &);
  void onExit();

private:
  const std::vector<StateRule *> rules_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_STATE_H_