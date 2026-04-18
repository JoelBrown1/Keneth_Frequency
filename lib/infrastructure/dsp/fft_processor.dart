import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'fft_bindings.dart';
import 'window_functions.dart';

class FftProcessor {
  const FftProcessor();

  /// Applies [window] to [samples], zero-pads to the next power of two,
  /// computes the real FFT via pocketfft, and returns magnitudes in dB FS.
  ///
  /// The returned list has length [nextPowerOfTwo](samples.length) ~/ 2 + 1.
  ///
  /// All native memory is allocated and freed within this call.
  /// No [Pointer] escapes — safe to call from a Dart [Isolate].
  List<double> process(
    Float32List samples, {
    WindowFunction window = WindowFunction.hann,
  }) {
    if (samples.isEmpty) {
      throw ArgumentError.value(samples, 'samples', 'must not be empty');
    }

    final n = nextPowerOfTwo(samples.length);
    final outSize = n ~/ 2 + 1;

    // Apply window to the original (non-padded) portion.
    final windowed = _applyWindow(samples, window);

    final nativeSamples = calloc<Float>(n);
    final nativeOut = calloc<Double>(outSize);
    try {
      // Copy windowed samples; remaining indices stay zero (zero-padding).
      for (int i = 0; i < windowed.length; i++) {
        nativeSamples[i] = windowed[i];
      }

      final code = FftBindings.magnitudesDb(nativeSamples, n, nativeOut);
      if (code != 0) {
        throw StateError('pocketfft returned error code $code');
      }

      return List<double>.generate(outSize, (i) => nativeOut[i]);
    } finally {
      calloc.free(nativeSamples);
      calloc.free(nativeOut);
    }
  }

  Float32List _applyWindow(Float32List samples, WindowFunction window) {
    if (window == WindowFunction.none) return samples;
    final coeffs = window == WindowFunction.hann
        ? WindowFunctions.hann(samples.length)
        : WindowFunctions.blackmanHarris(samples.length);
    final out = Float32List(samples.length);
    for (int i = 0; i < samples.length; i++) {
      out[i] = samples[i] * coeffs[i];
    }
    return out;
  }
}

/// Returns the smallest power of two >= [n].
int nextPowerOfTwo(int n) {
  if (n <= 0) throw ArgumentError.value(n, 'n', 'must be > 0');
  return 1 << (n - 1).bitLength;
}
