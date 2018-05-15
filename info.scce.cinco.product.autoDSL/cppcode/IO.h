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
  
  bool DecrementSetDistanceButton;
  bool IncrementSetDistanceButton;
  bool DecrementSetSpeedButton;
  bool IncrementSetSpeedButton;

  double DistanceFront;
  double DistanceRear;
  double TimeDistanceFront;
  double LeadingCarRelativeSpeed;

  double CurrentSpeed;
  double PhysicalAcceleration;
  double Steering;
  double InputThrottle;
  double InputBrake;
  double dTime;
};

struct CarOutputs {
  bool ObstacleDetectedWarning;
  bool ErrorWarning;
  bool SystemOn;
  bool SystemActive;
  bool HeadlightsOn;

  double Throttle;
  double Brake;
  double Steering;
  double SetSpeed;
  double SetDistance;
};
} // namespace IO
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_IO_H_
