#ifndef ACCPLUSPLUS_IDGENERATOR_H_
#define ACCPLUSPLUS_IDGENERATOR_H_

#include <cstddef>

namespace ACCPlusPlus {
namespace Utility {

typedef size_t IDType;

class IDGenerator {
public:
  IDGenerator() { id_ = 0; }
  IDType createID() { return id_++; }

private:
  IDType id_;
};
} // namespace Utility

namespace Globals {
  static Utility::IDGenerator gIDGenerator;
}

} // namespace ACCPlusPlus
#endif // ACCPLUSPLUS_IDGENERATOR_H_