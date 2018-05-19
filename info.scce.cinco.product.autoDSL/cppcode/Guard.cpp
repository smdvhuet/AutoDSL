#include "Guard.h"

#include "Debug.h"

using namespace ACCPlusPlus;

Guard::Guard(const std::string &name, std::vector<GuardRule *> &guards)
  : GuardRule(name), guards_{ guards } {}

Guard::~Guard() {
  for (std::vector<GuardRule *>::const_iterator it = guards_.begin();
       it != guards_.end(); ++it)
    delete (*it);
}

void Guard::onEntry() {
  for (std::vector<GuardRule *>::const_iterator it = guards_.begin();
       it != guards_.end(); ++it)
    (*it)->onEntry();
}

bool Guard::Execute(const IO::CarInputs &input) {
  bool result = true;
  for (std::vector<GuardRule *>::const_iterator it = guards_.begin();
       it != guards_.end(); ++it)
    result &= (*it)->Execute(input);

  ACC_LOG2("Guard '" << Name() << "' validated to '" << result << "'");
  return result;
}

void Guard::onExit() {
  for (std::vector<GuardRule *>::const_iterator it = guards_.begin();
       it != guards_.end(); ++it)
    (*it)->onExit();
}