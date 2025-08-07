add_mlir_library(Toy toy.cpp DEPENDS MLIRToyIncGen)
add_subdirectory(Transforms)

target_link_libraries(Toy
PRIVATE
    MLIRAnalysis
    MLIRFunctionInterfaces
    MLIRIR
    MLIRParser
    MLIRSideEffectInterfaces
    MLIRTransforms
    MLIRSupport)