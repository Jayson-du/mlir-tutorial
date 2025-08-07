#!/usr/bin/bash

path="$(cd $(dirname $0) && pwd)"

if [ ! -d "build" ]; then
    mkdir build
fi


cd build


if [ -f "CMakeCache.txt" ]; then
    rm CMakeCache.txt
fi


cmake -DCMAKE_BUILD_TYPE=Debug \
      -DBUILD_SHARED_LIBS=ON \
      -DLLVM_BUILD_TOOLS=ON \
      -DCMAKE_PREFIX_PATH=/home/jayson/github/llvm-project/build/lib/cmake/mlir \
      -GNinja ../

ninja -j16