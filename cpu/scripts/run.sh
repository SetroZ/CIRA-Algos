#!/bin/bash
# valgrind  --leak-check=full --show-leak-kinds=all 
cd scripts
./build.sh

../src/main  $1 $2

