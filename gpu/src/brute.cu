Path dedispersion_path(int DM, double t_0, FRBFileData *frbData, int min_t_idx, int max_t_idx, int min_f_idx, int max_f_idx)
{
    Path path;
    double t_idx = (t_0 - frbData->d_t) / frbData->d_t;
    // iterate through each frequency range from max -> min
    for (double f_val = frbData->f_max; f_val > frbData->f_min; f_val -= frbData->d_f)
    {
        double f_low = f_val - frbData->d_f;
        double f_idx = (f_val - frbData->f_min) / frbData->d_f;

        double t_path_idx = t_idx + calc_time_delay_idx(K, DM, frbData->d_t, frbData->f_max, f_val);
        double t_path_idx_low = t_idx + calc_time_delay_idx(K, DM, frbData->d_t, frbData->f_max, f_low);

        int int_t_path_idx = round(t_path_idx);
        int int_t_path_idx_low = round(t_path_idx_low);
        int freq_value = round(f_idx);
        if ((min_t_idx <= int_t_path_idx && int_t_path_idx < max_t_idx) && (min_f_idx <= freq_value && freq_value < max_f_idx))
        {
            for (int t = int_t_path_idx; t <= int_t_path_idx_low; t++)
            {
                if (min_t_idx <= t < max_t_idx)
                {
                    path.push_back({t, freq_value});
                }
            }
        }
    }
    return path;
}
