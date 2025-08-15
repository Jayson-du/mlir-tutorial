add_mlir_dialect(Toy toy)


set(LLVM_TARGET_DEFINITIONS ToyPasses.td)
mlir_tablegen(ToyPasses.h.inc -gen-pass-decls)

# add_public_tablegen_target 的主要作用包括：
# 生成 TableGen 输出：调用 TableGen 工具处理 .td 文件，生成 C++ 头文件(.h)、实现文件(.cpp)或其他资源(如操作定义、模式匹配规则)。
# 暴露生成的文件：将生成的头文件或代码标记为公共，允许其他 CMake 目标(例如其他库或测试目标)包含这些文件。
# 支持模块化开发：在大型项目中(如 MLIR 或 LLVM)，add_public_tablegen_target 确保 TableGen 生成的代码可以被多个子项目共享，例如在不同 Dialect 或工具之间重用操作定义。
# 集成到构建系统：将 TableGen 的生成过程嵌入到 CMake 构建系统中，确保生成的文件在编译时可用。
add_public_tablegen_target(MLIRToyTransformsIncGen)

add_custom_target(header DEPENDS MLIRToyIncGen MLIRToyTransformsIncGen MLIRAnalysis
    MLIRFunctionInterfaces
    MLIRIR
    MLIRParser
    MLIRSideEffectInterfaces
    MLIRTransforms
    MLIRSupport
    MLIRPass)