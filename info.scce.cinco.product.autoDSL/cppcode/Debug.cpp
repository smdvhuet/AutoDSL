#include "Debug.h"

#ifdef _WIN32
#include <intrin.h>
unsigned long long rdtsc() { return __rdtsc(); }
#else
#include <cstdio>
#include <inttypes.h>
unsigned long long rdtsc() {
  unsigned int lo, hi;
  __asm__ __volatile__("rdtsc" : "=a"(lo), "=d"(hi));
  return ((uint64_t)hi << 32) | lo;
}
#endif

size_t gDebug_frame_pos;
CSVTable gDebug_table;

ACCPlusPlus::Logger gLogger;

void WriteCSVToFile(const char *filename, CSVTable table) {
  std::ofstream file(filename, std::ios::out);
  if (!file.good()) {
    return;
  }

  // Write header
  CSVTable::CSVTableType::iterator it;
  file << "Frameindex;";
  for (it = table.columns.begin(); it != table.columns.end(); it++) {
    file << it->first + ";";
  }

  file << "\n";

  // Write body
  for (size_t i = 0; i < table.current_line; i++) {
    file << table.frames_captured - table.current_line + i << ";";
    for (it = table.columns.begin(); it != table.columns.end(); it++) {
      file << it->second.values[i] << ";";
    }

    file << "\n";
  }

  file.flush();
}