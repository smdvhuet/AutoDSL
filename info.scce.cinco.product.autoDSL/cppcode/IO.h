#ifndef ACCPLUSPLUS_IO_H_
#define ACCPLUSPLUS_IO_H_

namespace ACCPlusPlus {
namespace IO {
struct ACCSettings {
  float set_speed;
};

struct DistanceInformation {
  float distance_front;
  float time_distance_front;
  float leading_car_relative_speed;
};

struct CarInputs {
  float current_speed;
  float steering;
  float throttle;

  ACCSettings acc;
  DistanceInformation distance_info;
};

struct CarOutputs {
  float acceleration;
  float steering;
  bool headlights;
};
} // namespace IO
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_IO_H_