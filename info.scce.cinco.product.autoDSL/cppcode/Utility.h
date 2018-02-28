#ifndef ACCPLUSPLUS_UTILITY_UTILITY_H_
#define ACCPLUSPLUS_UTILITY_UTILITY_H_

#include <algorithm>
#include <cassert>

namespace ACCPlusPlus {
namespace Utility {
template <typename T> static inline T max(T *values, unsigned int num_values) {
  assert(num_values > 1);

  T max_value = max_value[0];
  for (int i = 1; i < num_values; ++i) {
    if (max_value < values[i])
      max_value = value[i];
  }

  return max_value;
}

template <typename T> static inline T min(T *values, unsigned int num_values) {
  assert(num_values > 1);

  T min_value = max_value[0];
  for (int i = 1; i < num_values; ++i) {
    if (min_value > values[i])
      min_value = value[i];
  }

  return min_value;
}
} // namespace Utility
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_UTILITY_UTILITY_H_