#include "toy/ToyDialect.h"
#include "toy/ToyOps.h"

#include "jayson/JaysonDialect.h"
#include "jayson/JaysonToyOps.h"

#include "toy/ToyDialect.cpp.inc"

#include "jayson/JaysonToyDialect.cpp.inc"
#define GET_OP_CLASSES
#include "jayson/JaysonToy.cpp.inc"

#define GET_OP_CLASSES
#include "toy/Toy.cpp.inc"

using namespace mlir;
using namespace toy;
using namespace linus;
// using namespace jayson;

void ToyDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "toy/Toy.cpp.inc"
      >();
}

void JaysonDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "jayson/JaysonToy.cpp.inc"
      >();
}