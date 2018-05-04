#include "PID.h"

#include <limits>

using namespace ACCPlusPlus;

PID::PID(double p, double i, double d) {
  p_ = p;
  i_ = i;
  d_ = d;

  integral_ = 0;
  last_value_ = 0;
}

double PID::calculate(double current_value, double target_value,
                      double dtime_sec) {
  double error = target_value - current_value;
  double diff = (last_value_ - error) / dtime_sec;

  last_value_ = error;
  integral_ += (error * dtime_sec);

  double result = ((error + i_ * integral_ + d_ * diff) * p_) / dtime_sec;
  
  if(result > 1){
  	return 1;
  }else if(result < -1){
  	return -1;
  }else{
  	return result;
  }
}