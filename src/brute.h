#ifndef DEDISPERSION_BRUTE_H
#define DEDISPERSION_BRUTE_H

#include <iostream>
#include <vector>
#include <cmath>
#include <map>
#include <CCfits/CCfits>
#include <algorithm>
#include <tuple>

using namespace std; // Add this line to use the std namespace

// Constants
const double K = (1.0 / (2.41 * pow(10, -4)));

// Function prototypes
double calc_time_delay_idx(double k, double DM, double d_t, double f_0, double f_1);
vector<pair<int, int>> dedispersion_path(int DM, double t_0, double min_t, double max_t, double d_t, double min_f, double max_f, double d_f);
void calc_paths(double min_t, double max_t, double d_t, double min_f, double max_f, double d_f, int min_DM, int max_DM, int d_DM, map<int, map<double, vector<pair<int, int>>>> &path_dict);
map<int, map<double, double>> dedisperse(const vector<vector<double>> &data, const map<int, map<double, vector<pair<int, int>>>> &path_dict);
pair<vector<tuple<int, double, double>>, map<int, map<double, double>>> find_frb(const map<int, map<double, double>> &results, double threshold);

#endif // DEDISPERSION_BRUTE_H
