#ifndef JAYSON_DIALECT_TD
#define JAYSON_DIALECT_TD

include "mlir/IR/OpBase.td"

def JaysonDialect : Dialect {
  let name = "jayson";
  let cppNamespace = "::linus";
  let summary = "Jayson Toy Dialect";
}

#endif
