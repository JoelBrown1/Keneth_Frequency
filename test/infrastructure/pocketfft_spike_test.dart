// S0-14 spike: verify pocketfft .dylib loads and computes FFT correctly.
// Run with: flutter test test/infrastructure/pocketfft_spike_test.dart

import 'dart:ffi';
import 'dart:io';
import 'dart:math' as math;
import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';

// FFI typedefs
typedef PocketFftMagnitudesDb = Int32 Function(
  Pointer<Float>, Int64, Pointer<Double>
);
typedef PocketFftMagnitudesDbDart = int Function(
  Pointer<Float>, int, Pointer<Double>
);
typedef PocketFftOutputSize = Int64 Function(Int64);
typedef PocketFftOutputSizeDart = int Function(int);

void main() {
  test('pocketfft dylib loads and finds 1kHz peak in 48kHz sine', () {
    // Load the .dylib compiled from macos/Runner/
    // Path is relative to project root when running flutter test
    final libPath = 'macos/Runner/libpocketfft.dylib';
    expect(File(libPath).existsSync(), isTrue,
        reason: 'libpocketfft.dylib must exist — run S0-14 Xcode build phase first');

    final lib = DynamicLibrary.open(libPath);

    final magnitudesDb = lib.lookupFunction<
        PocketFftMagnitudesDb,
        PocketFftMagnitudesDbDart>('pocketfft_real_magnitudes_db');

    final outputSize = lib.lookupFunction<
        PocketFftOutputSize,
        PocketFftOutputSizeDart>('pocketfft_output_size');

    // Generate a 1 kHz sine wave at 48 kHz sample rate, 4096 samples
    const sampleRate = 48000;
    const frequency = 1000.0;
    const n = 4096;

    final samples = calloc<Float>(n);
    for (var i = 0; i < n; i++) {
      samples[i] = math.sin(2 * math.pi * frequency * i / sampleRate);
    }

    final nOut = outputSize(n);
    final magnitudes = calloc<Double>(nOut);

    final result = magnitudesDb(samples, n, magnitudes);
    expect(result, equals(0), reason: 'FFT should return 0 (success)');

    // Find the peak bin
    var peakBin = 0;
    var peakDb = -300.0;
    for (var i = 0; i < nOut; i++) {
      if (magnitudes[i] > peakDb) {
        peakDb = magnitudes[i];
        peakBin = i;
      }
    }

    // Convert peak bin to frequency
    final peakFreq = peakBin * sampleRate / n;
    expect(peakFreq, closeTo(frequency, sampleRate / n),
        reason: 'Peak should be within ±1 bin of 1000 Hz');

    calloc.free(samples);
    calloc.free(magnitudes);
  });
}
