#include "Debug.h"

#ifdef _WIN32
#include <intrin.h>
unsigned long long rdtsc() {
  return __rdtsc();
}
#else
#include <inttypes.h>
#include <cstdio>
unsigned long long rdtsc() {
  unsigned int lo, hi;
  __asm__ __volatile__("rdtsc" : "=a" (lo), "=d" (hi));
  return ((uint64_t)hi << 32) | lo;
}
#endif 


size_t gDebug_table_pos;
size_t gDebug_frame_pos;
debug_table gDebug_table;

ACCPlusPlus::Logger gLogger;