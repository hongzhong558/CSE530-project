#!/usr/bin/env bash

# run kernel application, this will generate a power log
nvcc matmul.cu -lcudart
ldd a.out
./a.out