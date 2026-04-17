// pocketfft_wrapper.cpp
// C-linkage wrapper around the pocketfft C++ header-only library.
// Exposes a simple real-FFT function callable via dart:ffi.

#include "pocketfft.h"
#include <complex>
#include <cstdint>
#include <cstdlib>
#include <cmath>
#include <vector>

extern "C" {

// Compute real-to-complex FFT magnitude spectrum (in dB FS).
//
// Parameters:
//   samples     - input float32 PCM samples
//   n           - number of samples (must be > 0)
//   magnitudes  - caller-allocated output buffer of size (n/2 + 1) doubles
//
// Returns 0 on success, non-zero on failure.
int pocketfft_real_magnitudes_db(
    const float* samples,
    int64_t n,
    double* magnitudes
) {
    if (!samples || !magnitudes || n <= 0) return -1;

    size_t sz = static_cast<size_t>(n);
    pocketfft::shape_t shape = {sz};
    pocketfft::stride_t stride_in  = {sizeof(double)};
    pocketfft::stride_t stride_out = {sizeof(std::complex<double>)};
    pocketfft::shape_t axes = {0};

    std::vector<double> in(sz);
    for (size_t i = 0; i < sz; i++) {
        in[i] = static_cast<double>(samples[i]);
    }

    size_t n_out = sz / 2 + 1;
    std::vector<std::complex<double>> out(n_out);

    pocketfft::r2c(shape, stride_in, stride_out, axes, true, in.data(), out.data(), 1.0);

    double norm = 2.0 / static_cast<double>(n);
    for (size_t i = 0; i < n_out; i++) {
        double mag = std::abs(out[i]) * norm;
        magnitudes[i] = (mag > 1e-12) ? 20.0 * std::log10(mag) : -240.0;
    }

    return 0;
}

// Returns the size of the output magnitude buffer for a given input length.
int64_t pocketfft_output_size(int64_t n) {
    return n / 2 + 1;
}

} // extern "C"
