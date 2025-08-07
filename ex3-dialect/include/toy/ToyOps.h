#pragma once

#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"

#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "toy/ToyDialect.h"

#define GET_OP_CLASSES
#include "toy/Toy.h.inc"