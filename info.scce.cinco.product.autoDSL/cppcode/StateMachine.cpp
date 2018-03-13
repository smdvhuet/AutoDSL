#include "StateMachine.h"

#include <algorithm>

using namespace ACCPlusPlus;

void StateMachine::Run(const IO::CarInputs& input, IO::CarOutputs& output) {
  current_state_->Execute(input, output);

  for (std::vector<Transition>::iterator it =
           transitions_[current_state_->ID()].begin();
       it != transitions_[current_state_->ID()].end(); ++it) {
    if (it->condition(current_state_)) {
      current_state_->onExit();
      current_state_ = it->target_state;
      current_state_->onEntry();
      break;
    }
  }
}

void StateMachine::AddTransition(State *const &from, State *const &to,
                                 GuardRule *const &guardRule) {
  std::vector<Transition> *state_transitions = &transitions_[from->ID()];
  Transition new_transition(to, condition);

  if (state_transitions == NULL) {
    transitions_.insert(std::pair<Utility::IDType, std::vector<Transition>>(from->ID(), { new_transition });
  } else if (std::find(state_transitions->begin(), state_transitions->end(),
                       new_transition) == state_transitions->end()) {
    state_transitions->push_back(new_transition);
  }
}

void StateMachine::SetEntryState(State *const &entry_state) {
  entry_state_ = entry_state;
}