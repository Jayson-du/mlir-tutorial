#pragma once

#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"

#include "jayson/JaysonDialect.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

#define GET_OP_CLASSES
#include "jayson/JaysonToy.h.inc"