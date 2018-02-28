#ifndef ACCPLUSPLUS_IO_H_
#define ACCPLUSPLUS_IO_H_

namespace ACCPlusPlus {
namespace Globals {
namespace IO {
namespace Outputs {
static float gAccelerationOutput;
static float gSteeringOutput;
static bool gScheinwerferAnOutput;

static float gGamePadFeedbackXOutput;
static float gGamePadFeedbackYOutput;
} // namespace Outputs

namespace Inputs {
static const float gDistanceFontInput;
static const float gDistanceRearInput;
static const float gTimeDistanceFrontInput;
static const float gCurrentSpeedInput;
static const float gGamepadSteeringInput;
static const float gGamepadThrottleInput;
static const float gSetSpeedInput;
static const float gLeadingCarRelativeSpeedInput;

static const bool gGamePadA;
static const bool gGamePadB;
static const bool gGamePadX;
static const bool gGamePadY;
static const bool gGamePadLB;
static const bool gGamePadRB;
static const bool gGamePadBack;
static const bool gGamePadStart;
static const bool gGamepadXbox;
static const bool gGamepadLStickPressed;
static const bool gGamepadRStickPressed;
static const bool gGamepadDpadLeft;
static const bool gGamepadDpadRight;
static const bool gGamepadDpadUp;
static const bool gGamepadDpadDown;
} // namespace Inputs
} // namespace IO
} // namespace Globals
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_IO_H_