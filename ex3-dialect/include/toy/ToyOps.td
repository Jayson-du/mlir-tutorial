#ifndef TOY_OPS_TD
#define TOY_OPS_TD

include "mlir/IR/OpBase.td"
include "toy/ToyDialect.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

// mnemonic 指名字
class ToyOp<string mnemonic, list<Trait> traits = []> :
  Op<ToyDialect, mnemonic, traits>;

// Pure 是 Trait，表示没有 SideEffect 的纯函数
def AddOpF16 : ToyOp<"addf16", [Pure]> {
  let summary = "add operation";
  let arguments = (ins F16:$inputs0, F16:$inputs1);
  let results = (outs AnyInteger:$result);
}

// mnemonic名字必须与mlir一致, 否则会报错:
// "./ex3-dialect/ex3.mlir:2:8: error: unregistered operation 'toy.add' found in dialect ('toy') that does not allow unknown operations
// %c = "toy.add"(%a, %b): (i32, i32) -> i32"
//      "^"
// SameVariadicOperandSize表示: 强制要求多个变长操作数具有相同的数量, (Variadic)
def AddOpI32 : ToyOp<"add", [Pure, SameVariadicOperandSize]> {
  let summary = "add operation";
  let arguments = (ins Variadic<AnyInteger>:$inputs0, Variadic<AnyInteger>:$inputs1);
  let results = (outs AnyInteger:$result);
}

def SubOp : ToyOp<"sub", [Pure]> {
  let summary = "sub operation";
  let arguments = (ins AnyInteger:$lhs, AnyInteger:$rhs);
  let results = (outs AnyInteger:$result);
}

def ConstantOp : ToyOp<"const", [Pure]> {
  let summary = "const operation";
  let arguments = (ins APIntAttr:$value);
  let results = (outs AnyInteger:$result);
}

def DivOp : ToyOp<"div", []> {
  let summary = "add operation";
  let arguments = (ins F32:$inputs);
  let results = (outs F32:$result);
}

#endif
