#!/usr/bin/bash

path="$(cd $(dirname $0) && pwd)"

cd ${path}/build

ninja -j16

cd ${path}