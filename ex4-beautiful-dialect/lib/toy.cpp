#include "mlir/IR/AttrTypeSubElements.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/FunctionImplementation.h"
#include "mlir/Support/LogicalResult.h"
#include "toy/ToyDialect.h"
#include "toy/ToyOps.h"

#include "toy/ToyDialect.cpp.inc"
#define GET_OP_CLASSES
#include "toy/Toy.cpp.inc"

using namespace mlir;
using namespace toy;

void ToyDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "toy/Toy.cpp.inc"
      >();
}

// hook
// 在ToyDialect定义中, 使用了"let hasNonDefaultDestructor = 1;"
// 需要在源文件中添加 "ToyDialect::~ToyDialect"自定义析构函数的定义
ToyDialect::~ToyDialect() {}

// [hook]
// 在ToyDialect定义中, 使用了"let hasConstantMaterializer = 1;"
// 需要在源文件中添加 "ToyDialect::materializeConstant"函数的定义
Operation *ToyDialect::materializeConstant(::mlir::OpBuilder &builder,
                                           ::mlir::Attribute value,
                                           ::mlir::Type type,
                                           ::mlir::Location loc) {
  return nullptr;
}

// hook
void *ToyDialect::getRegisteredInterfaceForOp(mlir::TypeID interfaceID,
                                              mlir::OperationName opName) {
  return nullptr;
}

/// Parse an attribute registered to this dialect.
::mlir::Attribute ToyDialect::parseAttribute(::mlir::DialectAsmParser &parser,
                                             ::mlir::Type type) const {

  return ::mlir::Attribute();
}

/// Print an attribute registered to this dialect.
void ToyDialect::printAttribute(::mlir::Attribute attr,
                                ::mlir::DialectAsmPrinter &os) const {}

/// Parse a type registered to this dialect.
::mlir::Type ToyDialect::parseType(::mlir::DialectAsmParser &parser) const {
  return Type();
}

/// Print a type registered to this dialect.
void ToyDialect::printType(::mlir::Type type,
                           ::mlir::DialectAsmPrinter &os) const {}

// mlir::LogicalResult ConstantOp::inferReturnTypes(
//   mlir::MLIRContext * context,
//   std::optional<::mlir::Location> location,
//   mlir::ValueRange operands,
//   mlir::DictionaryAttr attributes,
//   mlir::OpaqueProperties properties,
//   mlir::RegionRange regions,
//   llvm::SmallVectorImpl<::mlir::Type>& inferredReturnTypes
// ) {
//   ConstantOp::Adaptor adaptor(operands, attributes, properties, regions);
//   inferredReturnTypes.push_back(adaptor.getValueAttr().getType());
//   return success();
// }

mlir::LogicalResult ConstantOp::inferReturnTypes(
    mlir::MLIRContext *context, std::optional<mlir::Location> location,
    Adaptor adaptor, llvm::SmallVectorImpl<mlir::Type> &inferedReturnType) {
  inferedReturnType.push_back(adaptor.getValueAttr().getType());
  return mlir::success();
}

mlir::ParseResult FuncOp::parse(::mlir::OpAsmParser &parser,
                                ::mlir::OperationState &result) {
  auto buildFuncType = [](auto &builder, auto argTypes, auto results, auto,
                          auto) {
    return builder.getFunctionType(argTypes, results);
  };
  return function_interface_impl::parseFunctionOp(
      parser, result, false, getFunctionTypeAttrName(result.name),
      buildFuncType, getArgAttrsAttrName(result.name),
      getResAttrsAttrName(result.name));
}

void FuncOp::print(mlir::OpAsmPrinter &p) {
  // Dispatch to the FunctionOpInterface provided utility method that prints the
  // function operation.
  mlir::function_interface_impl::printFunctionOp(
      p, *this, /*isVariadic=*/false, getFunctionTypeAttrName(),
      getArgAttrsAttrName(), getResAttrsAttrName());
}
