#include "Guard.h"

using namespace ACCPlusPlus;

Guard::Guard(const std::vector<GuardRule*> &guards) : GuardRule(), guards_{guards} { }

Guard::~Guard() {}

void Guard::onEntry() {
  for (std::vector<GuardRule*>::const_iterator it = guards_.begin();
       it != guards_.end(); ++it)
    (*it)->onEntry();
}

bool Guard::Execute(const IO::CarInputs &input) {
  bool result = true;
  for (std::vector<GuardRule*>::const_iterator it = guards_.begin();
       it != guards_.end(); ++it)
    result &= (*it)->Execute(input);

  return result;
}

void Guard::onExit() {
  for (std::vector<GuardRule*>::const_iterator it = guards_.begin();
       it != guards_.end(); ++it)
    (*it)->onExit();
}

std::string Guard::Name() {
  std::string name = "Guard";
  for (std::vector<GuardRule*>::const_iterator it = guards_.begin();
       it != guards_.end(); ++it)
    name += "_" + (*it)->Name();

  return name;
}