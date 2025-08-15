#ifndef TOY_DIALECT_TD
#define TOY_DIALECT_TD

include "mlir/IR/OpBase.td"

// include Dialect节码序列化文件
// include "mlir/IR/BytecodeBase.td"

// 生成 "ToyDialect.h.inc" 和 "ToyDialect.cpp.inc" 文件

def ToyDialect : Dialect {
  let name = "toy";
  let cppNamespace = "::toy";
  let summary = "Toy Dialect";

  // Dialect依赖

  // 注册"ToyDialect"所依赖的"Arithmetic"和"FuncDialect"
  // let dependentDialects = [
  //   "arith::ArithDialect"
  //   "func::FuncDialect"
  // ]

  let extraClassDeclaration = [{
  void ToyDialectDebug(::mlir::Operation *op) {
    op->emitOpError() << "#额外附加函数";
  }
  }];

  // 用于常量折叠相关的
  let hasConstantMaterializer = 1;

  // 提供自定义析构函数,
  // todo: 需要在toy.cpp中提供自定义析构函数
  let hasNonDefaultDestructor = 1;

  // Mark: 有些Dialect的Operations并未完全注册, 在种情况下,
  // 当某个操作未注册未提供实现接口查询时, 查询将会回退到该Dialect
  // 本身
  // 需要在 'toy.cpp' 中定义 'getRegisteredInterfaceForOp' 函数
  let hasOperationInterfaceFallback = 1;

  // mark: 当方言注册属性或者类型时, 必须重写
  // ToyDialect::parseAttribute
  // ToyDialect::printAttribute
  // ToyDialect::parseType
  // ToyDialect::printType
  // 方法
  // 设置 "useDefaultAttributePrinterParser" 和
  // "useDefaultTypePrintParser" 可以自动生成四种方法
  let useDefaultAttributePrinterParser = 1;

  let useDefaultTypePrinterParser = 1;

  // 用于规范化
  // mark: 需要自定义
  // "ToyDialect::getCanonicalizationPatterns(RewritePatternSet &result) const"
  // let hasCanonicalizer = 1;

  // 定义可拓展的方言
  // let isExtensible = 1;

}

// let cType = "MemRefType" in {
//   def MemRefType : DialectType<(type
//   Array<SignedVarInt>:$shape,
//   Type:$elementType,
//   MemRefLayout:$layout
// )> {
//   let printerPredicate = "!$_val.getMemorySpace()";
// }
// }

#endif
