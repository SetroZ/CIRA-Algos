#!/bin/bash
module load gcc/14.2.0
module load cfitsio/3.470

cd ..
cd src
g++  -g -Ofast  -o main main.cpp io.cpp brute.cpp  -I./ -I/d/sw/cfitsio/3.470/include/ -L/home/curtin_youssefe/lib/CCfits-2.6/.libs -lCCfits -L/d/sw/cfitsio/3.470/lib/ -lcfitsio
export LD_LIBRARY_PATH=/home/curtin_youssefe/cira/brute/lib/CCfits/.libs:$LD_LIBRARY_PATH


