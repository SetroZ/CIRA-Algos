#ifndef BRUTEIO_H
#define BRUTEIO_H

#include <vector>
#include <string>
#include <valarray>
using namespace std;
struct FRBFileData
{
    std::string name;
    valarray<double> flat_data;
    double d_f;
    double f_max;
    double f_min;
    double d_t;
    long x_time_size;
    double t_max;
};
#include "brute.h"
void read_FITS(FRBFileData *frbFile);

void write_Results(std::vector<FRB> &candidates, const char *file_path, double execTime, const char *benchmark_path);
#endif // BRUTEIO_H