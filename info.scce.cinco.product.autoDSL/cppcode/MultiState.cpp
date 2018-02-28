#include "MultiState.h"

using namespace ACCPlusPlus;


MultiState::MultiState(){
}

MultiState::~MultiState(){
}

void MultiState::onEntry() {
  for (std::vector<State *>::iterator it = states_.begin();
       it != states_.end(); ++it)
    (*it)->onEntry();
}

void MultiState::Execute() {
  for (std::vector<State *>::iterator it = states_.begin();
       it != states_.end(); ++it)
    (*it)->Execute();
}

void MultiState::onExit() {
  for (std::vector<State *>::iterator it = states_.begin();
       it != states_.end(); ++it)
    (*it)->onExit();
}

std::string MultiState::Name() {
  std::string name = "MultiState";
  for (std::vector<State *>::iterator it = states_.begin();
       it != states_.end(); ++it)
    name += "_" + (*it)->Name();

  return name;
}

void MultiState::AddState(State *const &state) { states_.push_back(state); }