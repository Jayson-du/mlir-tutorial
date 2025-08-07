/*
 * @Author: jayson 315843093@qq.com
 * @Date: 2025-07-04 15:46:44
 * @LastEditors: jayson 315843093@qq.com
 * @LastEditTime: 2025-08-06 16:12:01
 * @FilePath: /mlir-tutorial/ex1-io/ex1-io.cpp
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置
 * 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
#include "mlir/IR/AsmState.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/Parser/Parser.h"
#include "mlir/Support/FileUtilities.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "llvm/Support/raw_ostream.h"

using namespace mlir;

int main(int argc, char **argv) {
  MLIRContext ctx;
  // 首先，注册需要的 dialect
  ctx.loadDialect<func::FuncDialect, arith::ArithDialect>();
  // 读入dialect
  auto src = parseSourceFile<ModuleOp>(argv[1], &ctx);
  // 输出dialect
  // src->print(llvm::outs());
  // 简单的输出，在 debug 的时候常用
  src->dump();
  return 0;
}