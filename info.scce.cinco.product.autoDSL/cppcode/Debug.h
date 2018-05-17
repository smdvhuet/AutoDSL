#ifndef ACCPLUSPLUS_DEBUG_H_
#define ACCPLUSPLUS_DEBUG_H_

#define DEBUG_MEMORY_HISTORY_LENGTH 256
#define DEBUG_MEMORY_ENTRIES_COUNT 65536

#ifdef _WIN32
#include <intrin.h>
uint64_t rdtsc() {
  return __rdtsc();
}
#else
uint64_t rdtsc() {
  unsigned int lo, hi;
  __asm__ __volatile__("rdtsc" : "=a" (lo), "=d" (hi));
  return ((uint64_t)hi << 32) | lo;
}
#endif 

#define CPU_CYCLE rdtsc()

struct debug_location_info {
  char* file;
  int line;
  char* function;
};

struct debug_event {
  uint64_t time;
  const char* event_name;
  debug_location_info location;
  double value;
};

struct debug_frame {
  debug_event events[DEBUG_MEMORY_ENTRIES_COUNT];
};

struct debug_table {
  debug_frame frames[DEBUG_MEMORY_HISTORY_LENGTH];
};


extern size_t gDebug_table_pos;
extern size_t gDebug_frame_pos;
extern debug_table gDebug_table;

#define NEXT_DEBUG_FRAME gDebug_table_pos++; gDebug_frame_pos = 0;
#define CURRENT_DEBUG_FRAME gDebug_table.frames[gDebug_table_pos & (DEBUG_MEMORY_HISTORY_LENGTH - 1)]
#define CURRENT_DEBUG_FRAME_ENTRY CURRENT_DEBUG_FRAME.events[(gDebug_frame_pos - 1) & (DEBUG_MEMORY_ENTRIES_COUNT - 1)]
#define GET_DEBUG_FRAME_ENTRY gDebug_frame_pos++; CURRENT_DEBUG_FRAME_ENTRY
#define __FILENAME__ (strrchr(__FILE__, '\\') ? strrchr(__FILE__, '\\') + 1 : __FILE__)
#define STORE_EVENT(EventName, Value)  GET_DEBUG_FRAME_ENTRY = {CPU_CYCLE, #EventName, {__FILENAME__, __LINE__, __FUNCTION__}, (double)Value};

#define ACC_LOG(EventName, Value) STORE_EVENT(EventName, Value)


#include <intrin.h>
#include <iomanip>
#include "Logger.h"

extern Logger gLogger;

#define ACC_LOG2(msg)                                                \
  gLogger() << std::left << "[" << CPU_CYCLE << "] "                 \
            << std::setfill(' ') << std::setw(20) << __FILENAME__        \
            << std::setfill(' ') << std::setw(20) << __FUNCTION__        \
            << std::setfill(' ') << std::setw(7)  << __LINE__            \
            << std::setfill(' ') << std::setw(10) <<  msg

#endif // ACCPLUSPLUS_DEBUG_H_