#ifndef ACCPLUSPLUS_STATEMACHINE_H_
#define ACCPLUSPLUS_STATEMACHINE_H_

#include "State.h"
#include "Guard.h"

#include <map>
#include <vector>

namespace ACCPlusPlus {
class StateMachine {
private:
  struct Transition {
    State *target_state;
    Guard* guard;

    Transition(State* const target_state, Guard* const guard) {
      this->target_state = target_state;
      this->guard = guard;
    }

    bool operator==(const Transition &rhs) const {
      return this->target_state == rhs.target_state && this->guard == rhs.guard;
    }
  };

public:
  State *current_state_;
  void Run(const IO::CarInputs& input, IO::CarOutputs& output);
  bool isInEntryState();
  const std::string GetCurrentStateName();

protected:
  void AddTransition(State *const &from, State *const &to,
                     Guard *const &guard);

  void SetEntryState(State *const &entry_state);

private:
  State *entry_state_;

  using TransitionRegister = std::map<Utility::IDType, std::vector<Transition>>;
  TransitionRegister transitions_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_STATEMACHINE_H_
