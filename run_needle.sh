#!/usr/bin/env bash

# run kernel application, this will generate a power log
nvcc nw/needle.cu -lcudart
ldd a.out
./a.out