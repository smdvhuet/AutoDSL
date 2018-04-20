#ifndef ACCPLUSPLUS_IO_H_
#define ACCPLUSPLUS_IO_H_

namespace ACCPlusPlus {
namespace IO {
//struct ACCSettings {
//  float set_speed;
//};

//struct DistanceInformation {
//  float distance_front;
//  float time_distance_front;
//  float leading_car_relative_speed;
//};

struct CarInputs {
//  float current_speed;
//  float steering;
//  float throttle;

//  ACCSettings acc;
//  DistanceInformation distance_info;
  
	bool SystemOnButton;
	bool SystemActiveButton;
	bool HasLeadingCar;
	bool HasEngineError;
	bool HasSteeringError;
	bool HasGearboxError;
  
	float DistanceFront;
	float DistanceRear;
	float TimeDistanceFront;
	float LeadingCarRelativeSpeed;
	
	float CurrentSpeed;
	float Acceleration;
	float Steering;
	float SetSpeed;
	float SetDistance;
};

struct CarOutputs {
//  float acceleration;
//  float steering;
//  bool headlights;

	bool ObstacleDetectedWarning;
	bool ErrorWarning;
	bool SystemOn;
	bool SystemActive;  
	bool Scheinwerfer_An;
	
	float Acceleration;
	float Steering;
	float SetSpeed;
	float SetDistance;
};
} // namespace IO
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_IO_H_