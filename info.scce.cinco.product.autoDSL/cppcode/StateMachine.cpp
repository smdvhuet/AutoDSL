#include "StateMachine.h"
#include "Debug.h"
#include <iostream>
#include <algorithm>

using namespace ACCPlusPlus;

void StateMachine::Run(const IO::CarInputs& input, IO::CarOutputs& output) {
  gLogger() << "\n";
  ACC_LOG2("Running dsl")
    current_state_->Execute(input, output);
  for (std::vector<Transition>::iterator it =
    transitions_[current_state_->ID()].begin();
    it != transitions_[current_state_->ID()].end(); ++it) {
    if (it->guard->Execute(input)) {
      current_state_->onExit();
      ACC_LOG2("Changing state from '" << current_state_->Name() << "' to '" << it->target_state->Name() << "'")
        current_state_ = it->target_state;
      current_state_->onEntry();
      break;
    }
  }
} 

bool StateMachine::isInEntryState() { return entry_state_ == current_state_; }
const std::string StateMachine::GetCurrentStateName() { return current_state_->Name(); }

void StateMachine::AddTransition(State *const &from, State *const &to,
  Guard *const &guard) {
  std::vector<Transition> *state_transitions = &transitions_[from->ID()];
  Transition new_transition(to, guard);

  if (state_transitions == NULL) {
    transitions_.insert(std::pair<Utility::IDType, std::vector<Transition>>(from->ID(), { new_transition }));
  }
  else if (std::find(state_transitions->begin(), state_transitions->end(),
    new_transition) == state_transitions->end()) {
    state_transitions->push_back(new_transition);
  }
}

void StateMachine::SetEntryState(State *const &entry_state) {
  entry_state_ = entry_state;

  if (current_state_ == nullptr)
    current_state_ = entry_state_;
}