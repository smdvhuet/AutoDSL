#ifndef ACCPLUSPLUS_STATEMACHINE_H_
#define ACCPLUSPLUS_STATEMACHINE_H_

#include "IState.h"

#include <map>
#include <vector>

namespace ACCPlusPlus {
class StateMachine {
private:
  struct Transition {
    IState *target_state;
    bool (*condition)(IState *const &);

    Transition(IState *target_state, bool (*condition)(IState *const &)) {
      this->target_state = target_state;
      this->condition = condition;
    }

    bool operator==(const Transition &rhs) const {
      return this->target_state->ID() == rhs.target_state->ID() &&
             this->condition == rhs.condition;
    }
  };

public:
  void Run();

  void AddTransition(IState *const &from, IState *const &to,
                     bool (*condition)(IState *const &));
  void SetEntryState(IState *const &entry_state);

  bool isInEntryState();
  IState *getCurrentState();

private:
  IState *entry_state_;
  IState *current_state_;
  using TransitionRegister = std::map<Utility::IDType, std::vector<Transition>>;
  TransitionRegister transitions_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_STATEMACHINE_H_