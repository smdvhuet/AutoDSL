#include "Test.h"

Test::Test(std::function<void()> action,
           std::function<bool()> condition /* = nullptr */,
           int execution_delay /* = 0 */, int times_to_execute /* = -1 */,
           int execution_frequence /* = 0 */)
    : action_{action}, condition_{condition},
      times_to_execute_(times_to_execute),
      execution_frequence_(execution_frequence), last_execution_(0),
      execution_delay_(execution_delay) {}

void Test::Run() {
  executeDelayedTests();

  if (!checkTestCondition())
    return;

  runTest();
}

bool Test::checkTestCondition() {
  if (isRemovedTest())
    return false;

  if (last_execution_ < execution_frequence_) {
    last_execution++;
    return false;
  } else {
    last_execution_ = 0;
  }

  if (condition != NULL && !condition_())
    return false;

  return true;
}

void Test::executeDelayedTests() {
  if (execution_delay_ == 0)
    return;

  // Iterate over the pending tests, tests that are scheduled for this frame are
  // executed. Their pending entry is deleted.
  for (size_t i = 0; i < pending_executions_.size() && !isRemovedTest(); i++) {
    pending_executions_[i]--;
    if (pending_executions_[i] == 0) {
      runTest();
      pending_executions_.erase(i);
      i--;
    }
  }

  if (isRemovedTest())
    pending_executions_.clear();
}

void Test::runTest() {
  if (action_ != NULL)
    action_();

  if (times_to_execute_ > 0)
    times_to_execute--;
}

bool Test::isRemovedTest() { return times_to_execute_ == 0; }