#!/bin/bash
# valgrind  --leak-check=full --show-leak-kinds=all 
cd ../src
./build.sh
./main  $1 $2

