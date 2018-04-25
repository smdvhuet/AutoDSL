#ifndef ACCPLUSPLUS_IO_H_
#define ACCPLUSPLUS_IO_H_

namespace ACCPlusPlus {
namespace IO {
struct CarInputs {
  bool SystemOnButton;
  bool SystemActiveButton;
  bool HasLeadingCar;
  bool HasEngineError;
  bool HasSteeringError;
  bool HasGearboxError;

  double DistanceFront;
  double DistanceRear;
  double TimeDistanceFront;
  double LeadingCarRelativeSpeed;

  double CurrentSpeed;
  double Acceleration;
  double Steering;
  double SetSpeed;
  double SetDistance;
};

struct CarOutputs {
  bool ObstacleDetectedWarning;
  bool ErrorWarning;
  bool SystemOn;
  bool SystemActive;
  bool Scheinwerfer_An;

  double Acceleration;
  double Steering;
  double SetSpeed;
  double SetDistance;
};
} // namespace IO
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_IO_H_