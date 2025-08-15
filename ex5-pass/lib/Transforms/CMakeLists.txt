add_mlir_library(
  ToyTransforms
  ConvertToyToArith.cpp
  DCE.cpp
  DEPENDS
  # 依赖TableGen生成的文件
  MLIRToyTransformsIncGen
)

target_link_libraries(ToyTransforms
PRIVATE
    MLIRAnalysis
    MLIRBuiltinToLLVMIRTranslation
    MLIRCallInterfaces
    MLIRCastInterfaces
    MLIRExecutionEngine
    MLIRFunctionInterfaces
    MLIRIR
    MLIRLLVMCommonConversion
    MLIRLLVMToLLVMIRTranslation
    MLIRMemRefDialect
    MLIRParser
    MLIRPass
    MLIRSideEffectInterfaces
    MLIRTargetLLVMIRExport
    MLIRTransforms
    )