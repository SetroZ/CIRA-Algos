#!/bin/bash

#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --tasks-per-node=1
#SBATCH --mem=32gb
#SBATCH --output=./out/bruteforce.o%j
#SBATCH --error=./out/bruteforce.e%j
#SBATCH --export=NONE
#SBATCH --constraint=knl
cd ..
module load gcc/14.2.0
module load cfitsio/3.470



export LD_LIBRARY_PATH=/home/curtin_marcins/software/code/lib/CCfits-2.6/.libs:$LD_LIBRARY_PATH
./main  /data/curtin_mwafrb/sw/template/code/dedispersion/real_data/mwa_samples  /data/curtin_mwafrb/marcins/bruteforce/results/cad

