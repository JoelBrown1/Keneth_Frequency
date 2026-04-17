import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/services/sweep_generator.dart';

void main() {
  const generator = SweepGenerator();

  group('generateLogChirp — defaults', () {
    late final buffer = generator.generateLogChirp();

    test('output length equals durationSec × sampleRate', () {
      // Default: 20 s × 48000 Hz = 960 000 samples
      expect(buffer.length, 960000);
    });

    test('peak amplitude is −12 dBFS (≈ 0.2512)', () {
      double peak = 0.0;
      for (final s in buffer) {
        if (s.abs() > peak) peak = s.abs();
      }
      // -12 dBFS linear = 10^(-12/20) ≈ 0.25119; allow ±1%
      expect(peak, closeTo(0.25119, 0.003));
    });

    test('no sample exceeds −12 dBFS', () {
      const limit = 0.25119 * 1.01; // 1% tolerance for float rounding
      for (final s in buffer) {
        expect(s.abs(), lessThanOrEqualTo(limit));
      }
    });
  });

  group('generateLogChirp — custom parameters', () {
    test('correct sample count for 5 s at 44100 Hz', () {
      final buf = generator.generateLogChirp(
        durationSec: 5.0,
        sampleRate: 44100,
      );
      expect(buf.length, 220500);
    });

    test('frequency bounds: starts near f1, ends near f2', () {
      // Short sweep so we can verify the instantaneous frequency at the
      // start and end.  For a log chirp at t≈0 the instantaneous freq ≈ f1.
      const f1 = 100.0;
      const f2 = 10000.0;
      const dur = 1.0;
      const sr = 48000;
      final buf = generator.generateLogChirp(
        f1: f1,
        f2: f2,
        durationSec: dur,
        sampleRate: sr,
      );

      // Instantaneous frequency near t=0: estimate via zero-crossing period.
      // Find first two positive zero-crossings and compute period.
      int? zc1, zc2;
      for (int i = 1; i < buf.length && zc2 == null; i++) {
        if (buf[i - 1] <= 0 && buf[i] > 0) {
          if (zc1 == null) {
            zc1 = i;
          } else {
            zc2 = i;
          }
        }
      }
      expect(zc1, isNotNull);
      expect(zc2, isNotNull);
      final periodSamples = zc2! - zc1!;
      final measuredF1 = sr / periodSamples;
      // Allow ±20% — zero-crossing interpolation is coarse
      expect(measuredF1, closeTo(f1, f1 * 0.20));

      // Verify the chirp has progressed to a higher frequency at the end by
      // checking that the period near the end is much shorter than at start.
      int? zcLast1, zcLast2;
      for (int i = buf.length - 1; i > 0 && zcLast2 == null; i--) {
        if (buf[i - 1] <= 0 && buf[i] > 0) {
          if (zcLast1 == null) {
            zcLast1 = i;
          } else {
            zcLast2 = i;
          }
        }
      }
      if (zcLast1 != null && zcLast2 != null) {
        final endPeriod = (zcLast1! - zcLast2!).abs();
        expect(endPeriod, lessThan(periodSamples ~/ 5));
      }
    });

    test('all samples are finite', () {
      final buf = generator.generateLogChirp(
        f1: 20.0,
        f2: 20000.0,
        durationSec: 1.0,
        sampleRate: 48000,
      );
      for (final s in buf) {
        expect(s.isFinite, isTrue);
      }
    });
  });
}
