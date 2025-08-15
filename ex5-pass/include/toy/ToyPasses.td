#ifndef TOY_PASSES_TD
#define TOY_PASSES_TD

include "mlir/Pass/PassBase.td"

def ConvertToyToArith : Pass<"convert-toy-to-arith"> {
  let summary = "Convert Toy To Arith";
  let constructor = "toy::createConvertToyToArithPass()";
  let options = [
    Option<"name", "name", "std::string", "", "help">
  ];
}

// mark: toy-dce是Pass的名字, 运行opt时可以指定 "-toy-dce"运行Pass
// toy::FuncOp是它运行的对象类型
// 这里的toy::FuncOp是一个Interface，表示这个Pass可以在所有实现
// toy::FuncOp接口的Operation上运行。
def DCE : Pass<"toy-dce", "toy::FuncOp"> {
  let summary = "dce";
  let constructor = "toy::createDCEPass()";
  let options = [
    Option<"name1", "name2", "std::string", "", "help3">,
    Option<"jayson1", "jayson2", "std::string", "", "jayson3">
  ];
}
#endif
