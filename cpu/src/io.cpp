#include <stdio.h>
#include <vector>
#include "io.h"
#include "brute.h"
#include <CCfits/CCfits>
#include <valarray>
using namespace std;
using namespace CCfits;
double readKey(PHDU &primaryHDU, const string &key)
{
    string key_str;
    primaryHDU.readKey(key, key_str); // Read key as a string
    return std::stod(key_str);        // Convert to double and return
}

void read_FITS(FRBFileData *frbData)
{
    FITS::setVerboseMode(true);

    FITS fitsFile(frbData->name, Read, true);
    cout << fitsFile.name();

    PHDU &primaryHDU = fitsFile.pHDU();

    // Extract necessary metadata from the FITS file header
    frbData->x_time_size = primaryHDU.axis(0); // NAXIS1
    long y_freq_size = primaryHDU.axis(1);     // NAXIS2

    // Use the readKey function to get the header values as doubles
    frbData->f_min = readKey(primaryHDU, "CRVAL2");
    frbData->d_f = readKey(primaryHDU, "CDELT2");
    frbData->d_t = readKey(primaryHDU, "CDELT1");
    frbData->f_max = frbData->f_min + frbData->d_f * y_freq_size;
    frbData->t_max = frbData->d_t * 2 * frbData->x_time_size;

    // Initialize flat_data as a valarray with the required size (y_freq_size * x_time_size)
    frbData->flat_data = valarray<double>(y_freq_size * frbData->x_time_size);

    // Read the data into flat_data
    primaryHDU.read(frbData->flat_data);
}

void write_cand_file(std::vector<FRB> &candidates, const char *filename)
{
    FILE *file = fopen(filename, "w");
    if (file == NULL)
    {
        perror("Error opening file");
        return;
    }

    // Write header
    fprintf(file, "# S/N, sampno, secs from file start, boxcar, idt, dm, beamno, mjd, MEDIAN_TOTAL_POWER, RMSIQR_TOTAL_POWER, MAX_TOTAL_POWER\n");
    // DONT WORRY ABOUT CAPITAL LETTERS
    //
    // IDT = Delta T but in Pixels not seconds!!!!
    //  Iterate over each candidate and write in the specified format
    for (int i = 0; i < candidates.size(); i++)
    {
        FRB cand = candidates[i];
        double S_N = cand.snr;
        int sampno = cand.sampno; // Time index (sampno)
        double secs_file_start = cand.time;
        int idt = cand.idt;              // Dispersion delay in samples
        int boxcar = 0;                  // Placeholder for boxcar
        int beamno = 0;                  // Beam number, set to 0
        double mjd = 0.00;               // Modified Julian Date, set to 0.00
        double median_total_power = 0.0; // Placeholder
        double rmsiqr_total_power = 0.0; // Placeholder
        double max_total_power = 0.0;    // Placeholder

        // Write candidate data to file
        fprintf(file, "%.2f %d %.4f %d %d %.2f %d %.2f %.2f %.2f %.2f\n",
                S_N, sampno, cand.time, boxcar, idt, cand.dm, beamno, mjd,
                median_total_power, rmsiqr_total_power, max_total_power);
    }

    fclose(file);
}
