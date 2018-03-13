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

    Transition(const State& target_state, const Guard& guard) {
      this->target_state = target_state;
      this->guard = guard;
    }

    bool operator==(const Transition &rhs) const {
      return this->target_state->ID() == rhs.target_state->ID() &&
             this->condition == rhs.condition;
    }
  };

public:
  void Run(const IO::CarInputs& input, IO::CarOutputs& output);

protected:
  void AddTransition(State *const &from, State *const &to,
                     GuardRule *const &guardRule);

  void SetEntryState(State *const &entry_state);

private:
  State *entry_state_;
  State *current_state_;

  using TransitionRegister = std::map<Utility::IDType, std::vector<Transition>>;
  TransitionRegister transitions_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_STATEMACHINE_H_