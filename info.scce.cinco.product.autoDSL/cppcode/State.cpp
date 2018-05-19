#include "State.h"

#include "Debug.h"

using namespace ACCPlusPlus;

State::State(const std::vector<StateRule *> &rules) : StateRule(""), rules_{ rules } {}

State::~State() {
  for (std::vector<StateRule *>::const_iterator it = rules_.begin();
    it != rules_.end(); ++it)
    delete (*it);
}

void State::onEntry() {
  for (std::vector<StateRule *>::const_iterator it = rules_.begin();
    it != rules_.end(); ++it)
    (*it)->onEntry();
}

void State::Execute(const IO::CarInputs &input, IO::CarOutputs &output) {
  ACC_LOG2("Execute '" << Name() << "'")
    for (std::vector<StateRule *>::const_iterator it = rules_.begin();
      it != rules_.end(); ++it)
      (*it)->Execute(input, output);
}

void State::onExit() {
  for (std::vector<StateRule *>::const_iterator it = rules_.begin();
    it != rules_.end(); ++it)
    (*it)->onExit();
}

std::string State::Name() {
  std::string name = "State";
  for (std::vector<StateRule *>::const_iterator it = rules_.begin();
    it != rules_.end(); ++it)
    name += "_" + (*it)->Name();

  return name;
}