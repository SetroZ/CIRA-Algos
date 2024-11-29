#include <iostream>
#include <chrono>
#include <valarray>
#include <CCfits/CCfits>
#include "brute.h"
#include <iostream>
#include <unistd.h>
#include <limits.h>
#include "writer.h"
#include <filesystem>

using namespace CCfits;
using namespace std;
namespace fs = filesystem;
double signal_to_noise_ratio = 7;
// Function to read a key from the FITS header and convert it to double

double readKey(PHDU &primaryHDU, const string &key)
{
    string key_str;
    primaryHDU.readKey(key, key_str); // Read key as a string
    return std::stod(key_str);        // Convert to double and return
}
bool isFitsFile(filesystem::__cxx11::directory_entry entry)
{
    return entry.is_regular_file() && entry.path().extension() == ".fits";
}

void extractFRB(string frb_file, const char *output_path)
{

    FITS::setVerboseMode(true);

    FITS fitsFile(frb_file, Read, true);
    cout << fitsFile.name();

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
    std::chrono::_V2::system_clock::time_point start;
    std::chrono::_V2::system_clock::time_point end;
    valarray<double> flat_data(y_freq_size * x_time_size);
    primaryHDU.read(flat_data);

    // Set dispersion measure parameters
    int DM_min = 0;
    int DM_max = 150;
    int d_DM = static_cast<int>(d_t / (K * (1 / pow(f_min, 2) - 1 / pow(f_max, 2))));
    if (d_DM < 0)
        d_DM = 1;

    // Calculate paths
    PathMap path_dict;
    calc_paths(t_min, t_max, d_t, f_min, f_max, d_f, DM_min, DM_max, d_DM, path_dict);

    // Perform dedispersion
    start = chrono::high_resolution_clock::now();
    auto results = dedisperse(flat_data, path_dict, x_time_size);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double> dedispersion_time = end - start;
    cout << "Dedispersion completed in " << dedispersion_time.count() << " seconds.\n";

    // Find FRBs
    start = chrono::high_resolution_clock::now();
    auto all_frbs = find_frb(results, path_dict, signal_to_noise_ratio, delta_time);
    end = chrono::high_resolution_clock::now();
    chrono::duration<double> frb_find_time = end - start;
    cout << "FRB search completed in " << frb_find_time.count() << " seconds.\n";

    // Output FRB results

    if (all_frbs.size() > 0)
    {
        cout << "Found FRBs at: \n";
        for (const auto frb : all_frbs)
        {
            cout << "DM: " << frb.dm << ", Time: " << frb.time << ", SNR: " << frb.snr << "\n";
        }

        write_cand_file(all_frbs, output_path);
    }
}
int main(int argc, char *argv[])
{
    // Paths and file
    string frb_dir = argv[1];
    string output_dir = argv[2];

    for (const auto &entry : fs::recursive_directory_iterator(frb_dir))
    {

        if (isFitsFile(entry))
        {
            // Calculate relative path from input directory to the file
            fs::path relative_path = fs::relative(entry.path(), frb_dir);

            // Construct the new path in the output directory
            fs::path output_path = output_dir / relative_path.replace_extension(".cad");

            // Ensure the output subdirectory existsre
            fs::create_directories(output_path.parent_path());
            //Run FRB Extraction and write .cand files
            extractFRB(entry.path().string(), output_path.string().c_str());
        }
    }
    return 0;
}
