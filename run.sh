#!/bin/bash
# valgrind  --leak-check=full --show-leak-kinds=all 
cd src
g++ -g  -o main main.cpp brute.cpp -I/usr/local/include -L/usr/local/lib -lCCfits -lcfitsio
gdb -ex run --args ./main "$@" && echo

