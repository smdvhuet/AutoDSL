#ifndef ACCPLUSPLUS_MULTISTATE_H_
#define ACCPLUSPLUS_MULTISTATE_H_

#include "State.h"

#include <vector>
#include <map>

namespace ACCPlusPlus {
class MultiState : public State {
public:
  MultiState();
  ~MultiState();

  void onEntry();
  void Execute();
  void onExit();
  std::string Name();

  void AddState(State *const &state);

private:
  std::vector<State *> states_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_MULTISTATE_H_