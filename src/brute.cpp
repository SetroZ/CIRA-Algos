#include <iostream>
#include <vector>
#include <cmath>
#include <map>
#include <algorithm>

using namespace std;

// Constants
const double K = (1.0 / (2.41 * pow(10, -4)));

// Function to calculate time delay
double calc_time_delay_idx(double k, double DM, double d_t, double f_0, double f_1)
{
    return ((k * DM) / d_t) * (1.0 / pow(f_1, 2) - 1.0 / pow(f_0, 2));
}

// Generate dedispersion paths
vector<pair<int, int>> dedispersion_path(int DM, double t_0, double min_t, double max_t, double d_t, double min_f, double max_f, double d_f)
{
    vector<pair<int, int>> path;
    double t_idx = (t_0 - min_t) / d_t;

    for (double f_val = max_f; f_val > min_f; f_val -= d_f)
    {
        double f_low = f_val - d_f;
        double f_idx = (f_val - min_f) / d_f;

        double t_path_idx = t_idx + calc_time_delay_idx(K, DM, d_t, max_f, f_val);
        double t_path_idx_low = t_idx + calc_time_delay_idx(K, DM, d_t, max_f, f_low);

        int int_t_path_idx = round(t_path_idx);
        int int_t_path_idx_low = round(t_path_idx_low);
        int freq_value = round(f_idx);

        for (int t = int_t_path_idx; t <= int_t_path_idx_low; t++)
        {
            path.push_back({t, freq_value});
        }
    }
    return path;
}

// Calculate all paths for given parameters
void calc_paths(double min_t, double max_t, double d_t, double min_f, double max_f, double d_f, int min_DM, int max_DM, int d_DM, map<int, map<double, vector<pair<int, int>>>> &path_dict)
{
    for (int DM = min_DM; DM <= max_DM; DM += d_DM)
    {
        path_dict[DM] = map<double, vector<pair<int, int>>>();

        for (double t = min_t; t <= max_t; t += d_t)
        {
            double t_val = round(t * 1000) / 1000.0; // round to 3 dp
            path_dict[DM][t_val] = dedispersion_path(DM, t_val, min_t, max_t, d_t, min_f, max_f, d_f);
        }
    }
}

// Dedisperse data and compute results
map<int, map<double, double>> dedisperse(const vector<vector<double>> &data, const map<int, map<double, vector<pair<int, int>>>> &path_dict)
{
    map<int, map<double, double>> dedispersed_results;
    double sum = 0;

    for (const auto &[dm_key, times_map] : path_dict)
    {
        dedispersed_results[dm_key] = map<double, double>();

        for (const auto &[t_start_key, path] : times_map)
        {
            int num_pixels = path.size();

            if (num_pixels > 12)
            { // Assuming 12 is the MIN_PATH_LENGTH
                for (const auto &[time, freq] : path)
                {
                    sum += data[freq][time]; // Access the data matrix at the given time, frequency
                }

                double mean_flux = sum / num_pixels;
                dedispersed_results[dm_key][t_start_key] = mean_flux;
                sum = 0;
            }
            else
            {
                dedispersed_results[dm_key][t_start_key] = 0;
            }
        }
    }
    return dedispersed_results;
}

// Find FRBs based on SNR threshold
pair<vector<tuple<int, double, double>>, map<int, map<double, double>>> find_frb(const map<int, map<double, double>> &results, double threshold)
{
    vector<tuple<int, double, double>> candidates;
    map<int, map<double, double>> results_2;

    for (const auto &[dm_key, time_series] : results)
    {
        results_2[dm_key] = map<double, double>();
        vector<double> fluxes;

        for (const auto &[t_start_key, flux] : time_series)
        {
            fluxes.push_back(flux);
        }

        sort(fluxes.begin(), fluxes.end());

        double median = fluxes[fluxes.size() / 2];
        double q75 = fluxes[static_cast<int>(0.75 * fluxes.size())];
        double q25 = fluxes[static_cast<int>(0.25 * fluxes.size())];
        double iqr = q75 - q25;
        double rms = iqr / 1.35;

        for (const auto &[t_start_key, flux] : time_series)
        {
            double signal_to_noise = (flux - median) / rms;
            results_2[dm_key][t_start_key] = signal_to_noise;

            if (signal_to_noise >= threshold)
            {
                candidates.emplace_back(dm_key, t_start_key, signal_to_noise);
            }
        }
    }

    return {candidates, results_2};
}
