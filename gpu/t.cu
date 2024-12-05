#include <iostream>
#include <vector>
#include <cuda_runtime.h>
#include  <chrono>
// CUDA kernel for vector addition
__global__ void vectorAdd(const float* A, const float* B, float* C, int N) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < N) {
        C[i] = A[i] + B[i];
    }
}

void vectorAddCPU(const std::vector<float>& A, const std::vector<float>& B, std::vector<float>& C, int N) {
    for (int i = 0; i < N; ++i) {
        C[i] = A[i] + B[i];
    }
}

int main() {
    int N = 1 << 20;  // Size of the vectors (1 million elements)
    size_t size = N * sizeof(float);

    // Host vectors
    std::vector<float> h_A(N, 1.0f);  // Initialize A with 1.0f
    std::vector<float> h_B(N, 2.0f);  // Initialize B with 2.0f
    std::vector<float> h_C(N, 0.0f);  // Vector to store the result

    // Device vectors
    float* d_A = nullptr;
    float* d_B = nullptr;
    float* d_C = nullptr;

    // Allocate memory on the device
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_C, size);

    // Copy vectors from host to device
    cudaMemcpy(d_A, h_A.data(), size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B.data(), size, cudaMemcpyHostToDevice);

    // Timing variables
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Record the start time
    cudaEventRecord(start);

    // Launch kernel with one block per 256 threads
    int threadsPerBlock = 1024;
    int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;
    vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, N);

    // Wait for the GPU to finish
    cudaDeviceSynchronize();

    // Record the stop time
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    // Calculate elapsed time in milliseconds
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    std::cout << "Kernel execution time: " << milliseconds << " ms" << std::endl;

    // Copy the result back to the host
    cudaMemcpy(h_C.data(), d_C, size, cudaMemcpyDeviceToHost);

    // Optional: Print the first few elements of the result vector
    std::cout << "First 10 elements of the result: ";
    for (int i = 0; i < 10; i++) {
        std::cout << h_C[i] << " ";
    }
    std::cout << std::endl;

    // Clean up device memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    // Clean up events
    cudaEventDestroy(start);
    cudaEventDestroy(stop);

      auto start_cpu = std::chrono::high_resolution_clock::now();

    // Perform vector addition on CPU
    vectorAddCPU(h_A, h_B, h_C, N);

    auto stop_cpu = std::chrono::high_resolution_clock::now();
    std::chrono::duration<float> duration_cpu = stop_cpu - start_cpu;

    std::cout << "CPU execution time: " << duration_cpu.count() * 1000.0f << " ms";


    return 0;
}
