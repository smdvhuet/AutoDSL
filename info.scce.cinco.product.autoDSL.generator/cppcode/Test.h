#ifndef ACCPLUSPLUS_MONITORING_TEST_H_
#define ACCPLUSPLUS_MONITORING_TEST_H_

#include <vector>

namespace ACCPlusPlus {
namespace Monitoring {
class Test {
public:
  Test() = default;
  Test(int execution_delay = 0, int times_to_execute = -1,
       int execution_frequence = 0);

  void Run();
  bool isRemovedTest();

private:
  bool checkTestCondition();
  bool executeDelayedTests();
  void runTest();

protected:
  virtual void Action() = 0;
  virtual bool Condition();

private:
  int times_to_execute_;
  int last_execution_;
  int execution_frequence_;
  int execution_delay_;
  std::vector<int> pending_executions_;
}
} // namespace Monitoring
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_MONITORING_TEST_H_