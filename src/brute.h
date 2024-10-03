#ifndef DEDISPERSION_BRUTE_H
#define DEDISPERSION_BRUTE_H

#include <iostream>
#include <vector>
#include <cmath>
#include <map>
#include <algorithm>
#include <tuple>

using namespace std;                               // Add this line to use the std namespace
using Path = vector<pair<int, int>>;               // [(t,freq_value),.....]
using PathMap = map<int, map<double, Path>>;       // PathMap[DM][t_val] = Path
using DispResults = map<int, map<double, double>>; // [DM][t_start] = mean_flux;
// Constants
const double K = (1.0 / (2.41 * pow(10, -4)));

// Function prototypes
pair<vector<tuple<int, double, double>>, DispResults> find_frb(const DispResults &results, double threshold);
DispResults dedisperse(const vector<vector<double>> &data, const PathMap &path_dict);
void calc_paths(double min_t, double max_t, double d_t, double min_f, double max_f, double d_f, int min_DM, int max_DM, int d_DM, PathMap &path_dict);

#endif // DEDISPERSION_BRUTE_H
