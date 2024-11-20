#!/bin/bash
# valgrind  --leak-check=full --show-leak-kinds=all 
./build.sh
cd src/code

./main  $1 $2
# gdb -ex run --args ./main "$@" && echo

