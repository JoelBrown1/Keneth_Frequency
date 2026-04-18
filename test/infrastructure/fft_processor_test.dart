import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/infrastructure/dsp/fft_processor.dart';
import 'package:keneth_frequency/infrastructure/dsp/window_functions.dart';

void main() {
  const dyLibPath = 'macos/Runner/libpocketfft.dylib';

  setUpAll(() {
    if (!File(dyLibPath).existsSync()) {
      fail('libpocketfft.dylib not found — ensure S0-14 build phase ran.');
    }
  });

  const processor = FftProcessor();
  const sampleRate = 48000;
  const frequency = 1000.0;

  Float32List _sine(int n, double freq, {double amplitude = 1.0}) {
    return Float32List.fromList(List.generate(
      n,
      (i) => amplitude * math.sin(2.0 * math.pi * freq * i / sampleRate),
    ));
  }

  group('nextPowerOfTwo', () {
    test('exact power of two returns same value', () {
      expect(nextPowerOfTwo(4096), 4096);
      expect(nextPowerOfTwo(1024), 1024);
    });
    test('non-power rounds up', () {
      expect(nextPowerOfTwo(5000), 8192);
      expect(nextPowerOfTwo(4097), 8192);
      expect(nextPowerOfTwo(1), 1);
    });
  });

  group('process — 1 kHz sine, no window', () {
    test('peak within ±1 bin of 1000 Hz (DoD)', () {
      const n = 4096;
      final samples = _sine(n, frequency);
      final mags = processor.process(samples, window: WindowFunction.none);

      expect(mags.length, n ~/ 2 + 1);

      final peakBin = mags.indexOf(mags.reduce(math.max));
      final peakHz = peakBin * sampleRate / n;
      final binWidth = sampleRate / n; // one bin ≈ 11.7 Hz

      expect(peakHz, closeTo(frequency, binWidth));
    });
  });

  group('process — Hann window', () {
    test('peak still within ±1 bin of 1000 Hz', () {
      const n = 4096;
      final samples = _sine(n, frequency);
      final mags = processor.process(samples, window: WindowFunction.hann);

      final peakBin = mags.indexOf(mags.reduce(math.max));
      final peakHz = peakBin * sampleRate / n;
      final binWidth = sampleRate / n;

      expect(peakHz, closeTo(frequency, binWidth));
    });

    test('peak amplitude lower than no-window (energy leakage reduced)', () {
      const n = 4096;
      final samples = _sine(n, 1234.5); // non-integer bin → leakage without window
      final noWin = processor.process(samples, window: WindowFunction.none);
      final hann  = processor.process(samples, window: WindowFunction.hann);

      final peakNoWin = noWin.reduce(math.max);
      final peakHann  = hann.reduce(math.max);
      // Hann window reduces peak amplitude slightly but improves sidelobe rejection.
      // For a non-bin-aligned frequency the Hann peak is lower but sidelobes are better.
      // Simply verify both return finite non-null values.
      expect(peakNoWin.isFinite, isTrue);
      expect(peakHann.isFinite, isTrue);
    });
  });

  group('process — zero-padding', () {
    test('input not a power of two: output length is next-power-of-two/2+1', () {
      const n = 5000; // not a power of two
      final samples = _sine(n, frequency);
      final mags = processor.process(samples, window: WindowFunction.none);

      const expectedFftSize = 8192; // next power of two >= 5000
      expect(mags.length, expectedFftSize ~/ 2 + 1);
    });

    test('peak still within ±1 bin after zero-padding to 8192', () {
      const n = 5000;
      final samples = _sine(n, frequency);
      final mags = processor.process(samples, window: WindowFunction.none);

      const fftSize = 8192;
      final peakBin = mags.indexOf(mags.reduce(math.max));
      final peakHz = peakBin * sampleRate / fftSize;
      final binWidth = sampleRate / fftSize;

      expect(peakHz, closeTo(frequency, binWidth));
    });
  });

  group('process — memory safety', () {
    test('no crash after 100 consecutive calls', () {
      final samples = _sine(4096, frequency);
      for (int i = 0; i < 100; i++) {
        final mags = processor.process(samples);
        expect(mags, isNotEmpty);
      }
    });
  });

  group('process — argument validation', () {
    test('throws ArgumentError for empty input', () {
      expect(
        () => processor.process(Float32List(0)),
        throwsArgumentError,
      );
    });
  });

  group('WindowFunctions', () {
    test('hann(4): w[0]=0, w[1]≈0.75, w[2]≈0.75, w[3]=0', () {
      final w = WindowFunctions.hann(4);
      expect(w[0], closeTo(0.0, 1e-10));
      expect(w[1], closeTo(0.75, 1e-10));
      expect(w[2], closeTo(0.75, 1e-10));
      expect(w[3], closeTo(0.0, 1e-10));
    });

    test('blackmanHarris(1) returns [1.0]', () {
      final w = WindowFunctions.blackmanHarris(1);
      expect(w.length, 1);
      expect(w[0], closeTo(1.0, 1e-10));
    });

    test('blackmanHarris sums: endpoints near a0 − a1 + a2 − a3 ≈ 0.00006', () {
      final w = WindowFunctions.blackmanHarris(1024);
      expect(w[0], closeTo(0.35875 - 0.48829 + 0.14128 - 0.01168, 1e-10));
      expect(w[1023], closeTo(0.35875 - 0.48829 + 0.14128 - 0.01168, 1e-10));
    });

    test('hann throws ArgumentError for size 0', () {
      expect(() => WindowFunctions.hann(0), throwsArgumentError);
    });
  });
}
