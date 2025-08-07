#pragma once

#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"

#include "mlir/IR/RegionKindInterface.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "mlir/Interfaces/InferTypeOpInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "toy/ToyDialect.h"

#define GET_OP_CLASSES
#include "toy/Toy.h.inc"