# add_mlir_library(Toy toy.cpp DEPENDS MLIRToyIncGen)
# add_mlir_library(Toy toy.cpp DEPENDS MLIRJaysonToyIncGen)
add_mlir_library(Toy toy.cpp DEPENDS MLIRToyIncGen MLIRJaysonToyIncGen)

target_link_libraries(Toy
PRIVATE
    MLIRAnalysis
    MLIRFunctionInterfaces
    MLIRIR
    MLIRParser
    MLIRSideEffectInterfaces
    MLIRTransforms)