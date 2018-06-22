#ifndef ACCPLUSPLUS_DEBUG_H_
#define ACCPLUSPLUS_DEBUG_H_

#ifdef _WIN32
#define __FILENAME__                                                           \
  (strrchr(__FILE__, '\\') ? strrchr(__FILE__, '\\') + 1 : __FILE__)
#else
#include <cstring>
#define __FILENAME__                                                           \
  (strrchr(__FILE__, '/') ? strrchr(__FILE__, '/') + 1 : __FILE__)
#endif
unsigned long long rdtsc();
#define CPU_CYCLE rdtsc()

#include "Logger.h"
#include <iomanip>

extern ACCPlusPlus::Logger gLogger;
#define ADD_LOGOUTPUT(sink) gLogger.sinks_.push_back(new sink);

#define ACC_LOG2(msg)                                                          \
  gLogger() << std::left << "[" << CPU_CYCLE << "] " << std::setfill(' ')      \
            << std::setw(50) << __FILENAME__ << std::setfill(' ')              \
            << std::setw(60) << __FUNCTION__ << std::setfill(' ')              \
            << std::setw(7) << __LINE__ << std::setfill(' ') << std::setw(10)  \
            << msg;

#include <cstdio>
#include <limits>
#include <map>

#define LOG_HISTORY_LENGTH 4096
struct CSVTable;
extern void WriteCSVToFile(const char *filename, CSVTable table);

struct CSVColumn {
  double values[LOG_HISTORY_LENGTH];
};

struct CSVTable {
  typedef std::map<std::string, CSVColumn> CSVTableType;
  CSVTableType columns;
  size_t frames_captured = 0;
  size_t current_line = 0;

  CSVColumn *getColumn(const char *name) {
    CSVColumn *column = NULL;
    CSVTableType::iterator lb = columns.lower_bound(name);

    if (lb != columns.end() && !(columns.key_comp()(name, lb->first))) {
      column = &lb->second;
    }
    else {
      column = new CSVColumn();
      columns.insert(lb, CSVTableType::value_type(name, *column));
    }

    return column;
  }

  void NextFrame() {
    current_line = frames_captured++;
    current_line = current_line & (LOG_HISTORY_LENGTH - 1);

    ClearRow(current_line);
  }

  void ClearRow(int index) {
    CSVTable::CSVTableType::iterator it;
    for (it = columns.begin(); it != columns.end(); it++) {
      it->second.values[index] = 0;
    }
  }
};

extern CSVTable gDebug_table;
#define ACC_LOG(Name, Value)                                                   \
  gDebug_table.getColumn(Name)->values[gDebug_table.current_line] = Value;
#define NEXT_FRAME gDebug_table.NextFrame();
#define WriteCSV(FILENAME) WriteCSVToFile(FILENAME, gDebug_table);
#endif // ACCPLUSPLUS_DEBUG_H_