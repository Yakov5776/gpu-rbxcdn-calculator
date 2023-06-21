
#include "cuda_runtime.h"
#include <iostream>
#include <string>

__device__ __host__ int compute_rbxcdn(int i, const char* hash);
__global__ void rbxcdn_kernel(const char* hash, int* output);

int main() {
    std::string hash_input;
    while (true) {
        std::cout << "Enter hash: ";
        std::getline(std::cin, hash_input);
        int* output;
        char* hash;
        cudaMallocManaged(&hash, 33);
        cudaMallocManaged(&output, sizeof(int));
        strncpy(hash, hash_input.c_str(), 32);
        hash[32] = '\0';

        rbxcdn_kernel <<<1, 1 >>> (hash, output);
        cudaDeviceSynchronize();

        std::cout << "The designated rbxcdn bucket ID is: " << *output << std::endl;

        cudaFree(hash);
        cudaFree(output);
    }
}

__device__ __host__ int compute_rbxcdn(int i, const char* hash) {
    for (int t = 0; t < 32; t++)
        i = i ^ hash[t];
    return i % 8;
}

__global__ void rbxcdn_kernel(const char* hash, int* output) {
    *output = compute_rbxcdn(31, hash);
}