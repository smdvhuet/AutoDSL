#ifndef ACCPLUSPLUS_PID_H_
#define ACCPLUSPLUS_PID_H_

namespace ACCPlusPlus {
class PID {
public:
  PID(double p, double i, double d);

  double calculate(double current_value, double target_value, double dtime_sec);

public:
  double p_, i_, d_;

private:
  double last_value_;
  double integral_;
};
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_PID_H_