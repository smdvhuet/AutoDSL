#ifndef ACCPLUSPLUS_DEBUG_H_
#define ACCPLUSPLUS_DEBUG_H_

#ifdef _WIN32
#define __FILENAME__ (strrchr(__FILE__, '\\') ? strrchr(__FILE__, '\\') + 1 : __FILE__)
#else
#include <cstring>
#define __FILENAME__ (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
#endif 

#define DEBUG_MEMORY_HISTORY_LENGTH 256
#define DEBUG_MEMORY_ENTRIES_COUNT 65536

unsigned long long rdtsc();
#define CPU_CYCLE rdtsc()

struct debug_location_info {
  char* file;
  int line;
  char* function;
};

struct debug_event {
  unsigned long long time;
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
#define STORE_EVENT(EventName, Value)  GET_DEBUG_FRAME_ENTRY = {CPU_CYCLE, #EventName, {__FILENAME__, __LINE__, __FUNCTION__}, (double)Value};

#define ACC_LOG(EventName, Value) STORE_EVENT(EventName, Value)

#include <iomanip>
#include "Logger.h"

extern ACCPlusPlus::Logger gLogger;
#define ADD_LOGOUTPUT(sink) gLogger.sinks_.push_back(new sink);

#define ACC_LOG2(msg)                                                \
  gLogger() << std::left << "[" << CPU_CYCLE << "] "                 \
            << std::setfill(' ') << std::setw(50) << __FILENAME__        \
            << std::setfill(' ') << std::setw(60) << __FUNCTION__        \
            << std::setfill(' ') << std::setw(7)  << __LINE__            \
            << std::setfill(' ') << std::setw(10) <<  msg;
#endif // ACCPLUSPLUS_DEBUG_H_