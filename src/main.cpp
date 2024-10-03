#include <iostream>
#include <chrono>
#include <valarray>
#include <CCfits/CCfits>
#include "brute.h"
#include <iostream>
#include <unistd.h>
#include <limits.h>

using namespace CCfits;
using namespace std;

// Function to read a key from the FITS header and convert it to double
double readKey(PHDU &primaryHDU, const string &key)
{
    string key_str;
    primaryHDU.readKey(key, key_str); // Read key as a string
    return std::stod(key_str);        // Convert to double and return
}

int main()
{

    // Paths and file
    // string frb_dir = "../../dedispersion_implementations/data/simul/test_files/";
    string file_frb = "dm_50_fluence_500.fits";
    std::cout << file_frb;
    // Open the FITS file
    FITS::setVerboseMode(true);

    FITS fitsFile(file_frb, Read, true);
    PHDU &primaryHDU = fitsFile.pHDU();

    // Extract necessary metadata from the FITS file header
    long x_time_size = primaryHDU.axis(0); // NAXIS1
    long y_freq_size = primaryHDU.axis(1); // NAXIS2

    // Use the readKey function to get the header values as doubles
    double start_freq = readKey(primaryHDU, "CRVAL2");
    double delta_freq = readKey(primaryHDU, "CDELT2");
    double delta_time = readKey(primaryHDU, "CDELT1");

    double d_f = delta_freq;
    double f_min = start_freq;
    double f_max = start_freq + d_f * y_freq_size;
    double d_t = delta_time;
    double t_min = delta_time;
    double t_max = t_min + d_t * x_time_size;

    // FITS data extraction
    // 1. Use valarray instead of vector for flat_data
    std::valarray<double> flat_data(y_freq_size * x_time_size);

    // 2. Read the data into the flat valarray
    primaryHDU.read(flat_data); // Directly pass the valarray

    // 3. Reshape the flat valarray back into a 2D vector
    vector<vector<double>> data(y_freq_size, vector<double>(x_time_size));
    for (long i = 0; i < y_freq_size; ++i)
    {
        for (long j = 0; j < x_time_size; ++j)
        {
            data[i][j] = flat_data[i * x_time_size + j];
        }
    }

    // Set dispersion measure parameters
    int DM_min = 0;
    int DM_max = 150;
    int d_DM = static_cast<int>(d_t / (K * (1 / pow(f_min, 2) - 1 / pow(f_max, 2))));
    if (d_DM < 1)
        d_DM = 1;

    // Calculate paths
    PathMap path_dict;
    calc_paths(t_min, t_max, d_t, f_min, f_max, d_f, DM_min, DM_max, d_DM, path_dict);

    // Perform dedispersion
    auto start = chrono::high_resolution_clock::now();
    auto results = dedisperse(data, path_dict);
    auto end = chrono::high_resolution_clock::now();
    chrono::duration<double> dedispersion_time = end - start;
    cout << "Dedispersion completed in " << dedispersion_time.count() << " seconds.\n";

    // Define the signal-to-noise ratio
    double signal_to_noise_ratio = 5.0; // Adjust as needed

    // Find FRBs
    start = chrono::high_resolution_clock::now();
    auto [all_frbs, snr_results] = find_frb(results, signal_to_noise_ratio);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double> frb_find_time = end - start;
    cout << "FRB search completed in " << frb_find_time.count() << " seconds.\n";

    // Output FRB results
    cout << "Found FRBs at: \n";
    for (const auto &[dm, t_start, snr] : all_frbs)
    {
        cout << "DM: " << dm << ", Time: " << t_start << ", SNR: " << snr << "\n";
    }

    return 0;
}
