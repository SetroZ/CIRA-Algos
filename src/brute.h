#ifndef DEDISPERSION_BRUTE_H
#define DEDISPERSION_BRUTE_H

#include <iostream>
#include <vector>
#include <cmath>
#include <map>
#include <algorithm>
#include <tuple>

using namespace std; // Add this line to use the std namespace

// Constants
const double K = (1.0 / (2.41 * pow(10, -4)));

// Function prototypes
pair<vector<tuple<int, double, double>>, map<int, map<double, double>>> find_frb(const map<int, map<double, double>> &results, double threshold);
map<int, map<double, double>> dedisperse(const vector<vector<double>> &data, const map<int, map<double, vector<pair<int, int>>>> &path_dict);
void calc_paths(double min_t, double max_t, double d_t, double min_f, double max_f, double d_f, int min_DM, int max_DM, int d_DM, map<int, map<double, vector<pair<int, int>>>> &path_dict);

#endif // DEDISPERSION_BRUTE_H
