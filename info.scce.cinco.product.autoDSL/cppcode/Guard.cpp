#include "Guard.h"

using namespace ACCPlusPlus;

Guard::Guard() {}

Guard::~Guard() {}

void Guard::onEntry() {
  for (std::vector<GuardRule *>::iterator it = guards_.begin();
       it != guards_.end(); ++it)
    (*it)->onEntry();
}

bool Guard::Execute(const IO::CarInputs &input) {
  bool result = true;
  for (std::vector<GuardRule *>::iterator it = guards_.begin();
       it != guards_.end(); ++it)
    result &= (*it)->Execute(input);

  return result;
}

void Guard::onExit() {
  for (std::vector<GuardRule *>::iterator it = guards_.begin();
       it != guards_.end(); ++it)
    (*it)->onExit();
}

std::string Guard::Name() {
  std::string name = "Guard";
  for (std::vector<GuardRule *>::iterator it = guards_.begin();
       it != guards_.end(); ++it)
    name += "_" + (*it)->Name();

  return name;
}

void Guard::AddGuardRule(GuardRule *const &rule) { guards_.push_back(rule); }