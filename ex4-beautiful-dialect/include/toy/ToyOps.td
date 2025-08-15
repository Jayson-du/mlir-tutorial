#ifndef TOY_OPS_TD
#define TOY_OPS_TD

include "mlir/IR/OpBase.td"
include "toy/ToyDialect.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/Interfaces/FunctionInterfaces.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/IR/RegionKindInterface.td"
// include "mlir/IR/OpAsmInterface.td"

// Op: 定义所有Operations的基类
//
// mnemonic ： 标识Op Name, 当前Dialect下, Op独属的名字
// traits ： Op的特性, 例如 Pure, SameOperandsAndResultType 等
class ToyOp<string mnemonic, list<Trait> traits = []> :
  Op<ToyDialect, mnemonic, traits>;

// Pure 是 Trait，表示没有 SideEffect 的纯函数
// ins:  tablegen内置标识, 专门用于定义入参
// outs: tablegen内置标识, 专门用于定义出参
def AddOp : ToyOp<"add", [Pure, SameOperandsAndResultType]> {
  let summary = "add operation";
  // 操作数, Attr, Property在dag类型中指定, 以'ins'开头
  // let arguments = (ins
  // <type-constraint>:$<operand-name>,
  //
  // <attr-constraint>:$<attr-name>,
  //
  // <property>:$<property-name>,
  // );
  // Variadic: 表示可变参数
  let arguments = (ins Variadic<AnyInteger>:$inputs);
  let results = (outs AnyInteger:$result);

  // 主要用来自定义Operation语法格式, 比如
  // 1> mlir的语法规则为:
  // "%c = toy.add %a, %b : i32", input和type之间是 ':'分隔
  let assemblyFormat = "$inputs attr-dict `:` type($result)";

  // 2> mlir的语法规则为:
  // "%c = toy.add %a, %b : i32", input和type之间是 '?:>'分隔
  // let assemblyFormat = "$inputs attr-dict `?``:``>` type($result)";

  // let extraClassDeclaration = [{
  //   /// Allow the dialect prefix to be omitted.
  //   static StringRef getDefaultDialect() { return "func"; }
  // }];

  // mark: 如果定义 "assemblyFormat" 字段, 则TabelGen会在h.inc文件中
  // 自动生成AddOp::print()和AddOp::parse()方法, 在cpp.inc文件中自
  // 动生成AddOp::print()和AddOp::parse()的实现

  // 否则如果没有定义 "assemblyFormat" 字段, 定义了 "hasCustomAssemblyFormat"
  // 字段, 则TabelGen会在h.inc文件中自动生成AddOp::print()和AddOp::parse()方法定义,
  // 不会在cpp.inc文件中自动生成AddOp::print()和AddOp::parse()的实现
  // 需要自己手动实现
  // let hasCustomAssemblyFormat = true;
}

def SubOp : ToyOp<"sub", [Pure, SameOperandsAndResultType]> {
  let summary = "sub operation";
  let arguments = (ins AnyInteger:$lhs, AnyInteger:$rhs);
  let results = (outs AnyInteger:$result);
  let assemblyFormat = "$lhs `,` $rhs attr-dict `:` type($result)";
}

// mark: 新增 "InferTypeOpAdaptor" 属性
// 需要添加
// mlir::LogicalResult ConstantOp::inferReturnTypes(
//     mlir::MLIRContext *context, std::optional<mlir::Location> location,
//     Adaptor adaptor, llvm::SmallVectorImpl<mlir::Type> &inferedReturnType);
// 函数的声明和定义
def ConstantOp : ToyOp<"const", [Pure, InferTypeOpAdaptor]> {
  let summary = "const operation";
  let arguments = (ins APIntAttr:$value);
  let results = (outs AnyInteger:$result);
  let assemblyFormat = "$value attr-dict";

  // 额外声明一些函数
  let extraClassDeclaration = [{
    int64_t getBitWidth() {
      return getResult().getType().getWidth();
    }
  }];
}

// 另一种实现
//
// def ConstantOp : ToyOp<"const", [Pure, InferTypeOpInterface]> {
//   let summary = "const operation";
//   let arguments = (ins APIntAttr:$value);
//   let results = (outs AnyInteger:$result);
//   let assemblyFormat = "$value attr-dict";
//   let extraClassDeclaration = [{
//     static mlir::LogicalResult inferReturnTypes(
//       mlir::MLIRContext * context,
//       std::optional<::mlir::Location> location,
//       mlir::ValueRange operands,
//       mlir::DictionaryAttr attributes,
//       mlir::OpaqueProperties properties,
//       mlir::RegionRange regions,
//       llvm::SmallVectorImpl<::mlir::Type>& inferredReturnTypes
//     );
//   }];
// }

def ReturnOp : ToyOp<"ret", [Terminator, ReturnLike]> {
  let summary = "return operation";
  let arguments = (ins AnyType:$data);
  let assemblyFormat = "$data attr-dict `:` type($data)";
}

def FuncOp : ToyOp<"func", [
  // mark: FunctionOpInterface是一个属性, Op定义该属性, 需要
  // 提供 "getCallableRegion"函数定义与实现
  FunctionOpInterface,
  /* Symbol, */ /* Symbol 会自动被 FunctionOpInterface 加上 */
  /* CallableOpInterface, */ /* CallOpInterface 会自动被 FunctionOpInterface 加上 */

  // mark: 添加 "CallableOpInterface" 属性需要提供下面两种方法:
  // 1> llvm::ArrayRef<mlir::Type> getArgumentTypes() {return getFunctionType().getInputs();}
  // 2> 2> llvm::ArrayRef<mlir::Type> getResultTypes() {return getFunctionType().getResults();}
  CallableOpInterface,

  // mark: 添加 "RegionKindInterface" 属性需要提供下面一种方法:
  // 1> static mlir::RegionKind getRegionKind(unsigned idx) { return mlir::RegionKind::SSACFG; }
  RegionKindInterface
  ]> {
  let summary = "function";
  let arguments = (ins
    SymbolNameAttr:$sym_name,
    TypeAttrOf<FunctionType>:$function_type,
    // FunctionOpInterface 需要两个 Attr 来记录 arg 和 res 的名字
    OptionalAttr<DictArrayAttr>:$arg_attrs,
    OptionalAttr<DictArrayAttr>:$res_attrs
  );

  // op的region列表, 默认是region 0,
  // arg1: region是默认参数
  // arg2: AnyRegion 是一个Region的实例, 表示任意Region,
  // 生成函数::mlir::Region &getBody() { return &getRegion(0); }
  // 还有 SizedRegion<int numBlocks>, MinSizedRegion<int numBlocks> ...
  dag regions = (region AnyRegion:$body);
  // mark:设置这个字段需要新增FuncOp::print()
  // 同时FuncOp::parse()会在inc文件中被定义, 但是需要自己实现
  let hasCustomAssemblyFormat = true;
  let extraClassDeclaration = [{
    // Method of FunctionOpInterface
    mlir::Region * getCallableRegion() {return &getBody();}
    // getFunctionType 函数会自动生成
    // mlir::FunctionType getFunctionType();

    // Method of CallableOpInterface
    llvm::ArrayRef<mlir::Type> getArgumentTypes() {return getFunctionType().getInputs();}
    llvm::ArrayRef<mlir::Type> getResultTypes() {return getFunctionType().getResults();}

    // Method of RegionKindInterface
    static mlir::RegionKind getRegionKind(unsigned idx) { return mlir::RegionKind::SSACFG; }
  }];
}

def CallOp : ToyOp<"call", [CallOpInterface]> {
  let summary = "call operation";
  let arguments = (ins SymbolRefAttr:$callee, Variadic<AnyType>:$arg_operands);
  let results = (outs AnyType:$result);
  let assemblyFormat = "$callee `(` $arg_operands `)` attr-dict `:` functional-type($arg_operands, results)";
  let extraClassDeclaration = [{
    mlir::CallInterfaceCallable getCallableForCallee() { return getCalleeAttr(); }
    void setCalleeFromCallable(mlir::CallInterfaceCallable callee) { setCalleeAttr(callee.get<mlir::SymbolRefAttr>()); }
  }];
}

#endif
