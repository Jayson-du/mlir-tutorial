#include "mlir/IR/DialectRegistry.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"
// 导入 Func Dialect
#include "mlir/Dialect/Func/IR/FuncOps.h"
// 导入 MLIR 自带 Pass
#include "mlir/Transforms/Passes.h"
// 导入我们新建的 Dialect
#include "toy/ToyDialect.h"
using namespace mlir;
using namespace llvm;

int main(int argc, char **argv) {
  /// Dialect注册器
  DialectRegistry registry;

  /// 注册 Dialect(ToyDialect 和 FuncDialect)
  registry.insert<toy::ToyDialect, func::FuncDialect>();

  /// 注册两个 Pass
  registerCSEPass();
  registerCanonicalizerPass();

  /// MlirOptMain
  return asMainReturnCode(MlirOptMain(argc, argv, "toy-opt", registry));
}