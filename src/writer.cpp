

// writer.cpp
#include <stdio.h>
#include <vector>
#include "writer.h"

void write_cand_file(std::vector<FRB> &candidates, int num_candidates, const char *filename, double sample_duration)
{
    FILE *file = fopen(filename, "w");
    if (file == NULL)
    {
        perror("Error opening file");
        return;
    }

    // Write header
    fprintf(file, "# S/N, sampno, secs from file start, boxcar, idt, dm, beamno, mjd, MEDIAN_TOTAL_POWER, RMSIQR_TOTAL_POWER, MAX_TOTAL_POWER\n");

    // Iterate over each candidate and write in the specified format
    for (int i = 0; i < num_candidates; i++)
    {
        FRB cand = candidates[i];

        int sampno = (int)(cand.time / sample_duration); // Time index (sampno)
        int idt = sampno;                                // Dispersion delay in samples
        int boxcar = 0;                                  // Placeholder for boxcar
        int beamno = 0;                                  // Beam number, set to 0
        double mjd = 0.00;                               // Modified Julian Date, set to 0.00
        double median_total_power = 0.0;                 // Placeholder
        double rmsiqr_total_power = 0.0;                 // Placeholder
        double max_total_power = 0.0;                    // Placeholder

        // Write candidate data to file
        fprintf(file, "%.2f %d %.4f %d %d %.2f %d %.2f %.2f %.2f %.2f\n",
                cand.snr, sampno, cand.time, boxcar, idt, cand.dm, beamno, mjd,
                median_total_power, rmsiqr_total_power, max_total_power);
    }

    fclose(file);
}
