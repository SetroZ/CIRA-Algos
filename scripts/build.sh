#!/bin/bash
g++ -g -Ofast  -o main main.cpp writer.cpp brute.cpp -I/usr/local/include -L/usr/local/lib -lCCfits -lcfitsio 