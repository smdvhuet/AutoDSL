#ifndef ACCPLUSPLUS_STATE_H_
#define ACCPLUSPLUS_STATE_H_

#include "Rule.h"

#include <vector>

namespace ACCPlusPlus {
class State : public Rule {
public:
  State(const std::vector<Rule*> &);
  ~State();

  void onEntry();
  void Execute(const IO::CarInputs &, IO::CarOutputs &);
  void onExit();

  std::string Name();

private:
  const std::vector<Rule*> rules_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_STATE_H_