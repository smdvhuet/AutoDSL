#ifndef ACCPLUSPLUS_UTILITY_UTILITY_H_
#define ACCPLUSPLUS_UTILITY_UTILITY_H_

#include <algorithm>
#include <cassert>

namespace ACCPlusPlus {
namespace Utility {
template <typename T> static inline T max(T *values, unsigned int num_values) {
  assert(num_values > 1);

  T max_value = values[0];
  for (unsigned int i = 1; i < num_values; ++i) {
    if (max_value < values[i])
      max_value = values[i];
  }

  return max_value;
}

template <typename T> static inline T min(T *values, unsigned int num_values) {
  assert(num_values > 1);

  T min_value = values[0];
  for (unsigned int i = 1; i < num_values; ++i) {
    if (min_value > values[i])
      min_value = values[i];
  }

  return min_value;
}
} // namespace Utility
} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_UTILITY_UTILITY_H_
