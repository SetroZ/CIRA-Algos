#!/bin/bash
# valgrind  --leak-check=full --show-leak-kinds=all 

./build.sh

../src/main  $1 $2

