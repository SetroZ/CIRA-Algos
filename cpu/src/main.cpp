#include <iostream>
#include <chrono>
#include <valarray>
#include <CCfits/CCfits>
#include "brute.h"
#include "io.h"
#include <iostream>
#include <unistd.h>
#include <limits.h>

#include <filesystem>

using namespace CCfits;
using namespace std;
namespace fs = filesystem;
double signal_to_noise_ratio = 7;

// Function to read a key from the FITS header and convert it to double

bool isFitsFile(filesystem::__cxx11::directory_entry entry)
{
    return entry.is_regular_file() && entry.path().extension() == ".fits";
}

void extractFRB(string frb_file, const char *output_path, const char *benchmark_path)
{

    FRBFileData frbData;
    frbData.name = frb_file;
    std::chrono::_V2::system_clock::time_point start;
    std::chrono::_V2::system_clock::time_point end;
    read_FITS(&frbData);

    // Set dispersion measure parameters
    int DM_min = 0;
    int DM_max = 150;

    int d_DM = static_cast<int>(frbData.d_t / (K * (1 / pow(frbData.f_min, 2) - 1 / pow(frbData.f_max, 2))));
    if (d_DM < 0)
    {
        d_DM = 1;
    }

    // PARALIZABLE STEP

    // Calculate paths
    PathMap path_dict;
    calc_paths(&frbData, DM_min, DM_max, d_DM, path_dict);

    // Perform dedispersion
    start = chrono::high_resolution_clock::now();
    auto results = dedisperse(frbData.flat_data, path_dict, frbData.x_time_size);
    end = chrono::high_resolution_clock::now();
    chrono::milliseconds dedispersion_time = chrono::duration_cast<std::chrono::milliseconds>(end - start);
    cout << "Dedispersion completed in " << dedispersion_time.count() << " ms.\n";

    // Find FRBs
    start = chrono::high_resolution_clock::now();
    auto all_frbs = find_frb(results, path_dict, signal_to_noise_ratio, frbData.d_t);
    end = chrono::high_resolution_clock::now();
    chrono::milliseconds frb_find_time = chrono::duration_cast<std::chrono::milliseconds>(end - start);
    cout << "FRB search completed in " << frb_find_time.count() << " ms.\n";

    // COPY BACK TO CPU
    //  Output FRB results

    if (all_frbs.size() > 0)
    {
        cout << "Found FRBs at: \n";
        for (const auto frb : all_frbs)
        {
            cout << "DM: " << frb.dm << ", Time: " << frb.time << ", SNR: " << frb.snr << "\n";
        }

        write_Results(all_frbs, output_path, frb_find_time.count() + dedispersion_time.count(), benchmark_path);
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
            fs::path benchmark_path = output_dir / (fs::path) "benchmark.csv";
            // Ensure the output subdirectory existsre
            fs::create_directories(output_path.parent_path());

            // Run FRB Extraction and write .cand files
            try
            {
                extractFRB(entry.path().string(), output_path.string().c_str(), benchmark_path.string().c_str());
            }
            catch (const std::exception &e)
            {
                // Print the exception message using what()
                std::cout << "Exception caught: " << e.what() << std::endl;
            }
        }
    }
    return 0;
}
