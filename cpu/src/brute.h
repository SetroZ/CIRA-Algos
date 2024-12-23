#ifndef DEDISPERSION_BRUTE_H
#define DEDISPERSION_BRUTE_H

#include <iostream>
#include <vector>
#include <cmath>
#include <map>
#include <algorithm>
#include <tuple>

using namespace std; // Add this line to use the std namespace

using Path = vector<pair<int, int>>;               // [(t,freq_value),.....]
using PathMap = map<int, map<double, Path>>;       // PathMap[DM][t_val] = Path
using DispResults = map<int, map<double, double>>; // [DM][t_start] = mean_flux;
// Constants
const double K = (1.0 / (2.41 * pow(10, -4)));

struct FRB
{
    double snr;  // Signal-to-noise ratio
    double time; // Time of the event
    double dm;   // Dispersion measure
    double idt;
    double sampno;
};

// Function prototypes
vector<FRB> find_frb(const DispResults &results, const PathMap &path_dict, double threshold, double delta_time);
DispResults dedisperse(valarray<double> &data, const PathMap &path_dict, int x_size);
#include "io.h"
void calc_paths(FRBFileData *frbData, int min_DM, int max_DM, int d_DM, PathMap &path_dict);

#endif // DEDISPERSION_BRUTE_H
