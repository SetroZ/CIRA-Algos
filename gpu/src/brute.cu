#include <cuda_runtime.h>
#include <iostream>
#include <vector>
#include <cmath>
#include <map>
#include <unordered_set>
#include "/media/vetro/apps/code-projects/CIRA/code/bruteforce/cpu/src/brute.h"
using namespace std;

// CUDA constants
__constant__ double K;
__constant__ double TIME_DELAY = 1;

// GPU error check macro
#define CUDA_CHECK(call)
{
    cudaError_t err = call;
    if (err != cudaSuccess)
    {
        std::cerr << "CUDA Error: " << cudaGetErrorString(err) << " at " << __FILE__
                  << ":" << __LINE__ << std::endl;
        exit(EXIT_FAILURE);
    }
}
__device__ double calc_time_delay_idx(double k, double DM, double d_t, double f_0, double f_1)
{
    return ((k * DM) / d_t) * (1.0 / pow(f_1, 2) - 1.0 / pow(f_0, 2));
}
__global__ void calc_paths(int min_DM, int max_DM, int d_DM, double d_t, double f_min, double f_max, double d_f,
                           int max_t_idx, int max_f_idx, PathMap *path_dict)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int DM = min_DM + idx * d_DM;
    if (DM > max_DM)
        return;

    for (double t = d_t; t <= max_t_idx * d_t; t += d_t)
    {
        double t_idx = (t - d_t) / d_t;

        for (double f_val = f_max; f_val > f_min; f_val -= d_f)
        {
            double f_low = f_val - d_f;
            double f_idx = (f_val - f_min) / d_f;

            double t_path_idx = t_idx + calc_time_delay_idx(K, DM, d_t, f_max, f_val);
            double t_path_idx_low = t_idx + calc_time_delay_idx(K, DM, d_t, f_max, f_low);

            int int_t_path_idx = round(t_path_idx);
            int int_t_path_idx_low = round(t_path_idx_low);
            int freq_value = round(f_idx);

            if (int_t_path_idx >= 0 && int_t_path_idx < max_t_idx && freq_value >= 0 && freq_value < max_f_idx)
            {
                // Store path in path_dict
                path_dict[DM][t].push_back({int_t_path_idx, freq_value});
            }
        }
    }
}
__global__ void dedisperse_kernel(const double *data, int x_size, const PathMap *path_dict, DispResults *dedispersed_results)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    // TO DO
}

void dedisperse(const valarray<double> &data, const PathMap &path_dict, int x_size, DispResults &dedispersed_results)
{
    // Allocate GPU memory for data and path_dict
    double *d_data;
    CUDA_CHECK(cudaMalloc(&d_data, data.size() * sizeof(double)));
    CUDA_CHECK(cudaMemcpy(d_data, &data[0], data.size() * sizeof(double), cudaMemcpyHostToDevice));

    PathMap *d_path_dict;
    CUDA_CHECK(cudaMalloc(&d_path_dict, sizeof(PathMap)));
    CUDA_CHECK(cudaMemcpy(d_path_dict, &path_dict, sizeof(PathMap), cudaMemcpyHostToDevice));

    DispResults *d_dedispersed_results;
    CUDA_CHECK(cudaMalloc(&d_dedispersed_results, sizeof(DispResults)));

    // Launch kernel
    int threads_per_block = 256;
    int blocks = (path_dict.size() + threads_per_block - 1) / threads_per_block;
    dedisperse_kernel<<<blocks, threads_per_block>>>(d_data, x_size, d_path_dict, d_dedispersed_results);

    // Copy results back to host
    CUDA_CHECK(cudaMemcpy(&dedispersed_results, d_dedispersed_results, sizeof(DispResults), cudaMemcpyDeviceToHost));

    // Free GPU memory
    CUDA_CHECK(cudaFree(d_data));
    CUDA_CHECK(cudaFree(d_path_dict));
    CUDA_CHECK(cudaFree(d_dedispersed_results));
}