import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/domain/services/peak_detector.dart';
import 'package:keneth_frequency/infrastructure/dsp/signal_validator.dart';

void main() {
  const validator = SignalValidator();

  // ---------------------------------------------------------------------------
  // checkClip
  // ---------------------------------------------------------------------------
  group('checkClip', () {
    test('returns true when a sample equals 0.98', () {
      final samples = Float32List.fromList([0.0, 0.5, 0.98, 0.1]);
      expect(validator.checkClip(samples), isTrue);
    });

    test('returns true when a sample exceeds 0.98', () {
      final samples = Float32List.fromList([0.0, 0.99, 0.0]);
      expect(validator.checkClip(samples), isTrue);
    });

    test('returns true for negative clipping', () {
      final samples = Float32List.fromList([-0.99, 0.0]);
      expect(validator.checkClip(samples), isTrue);
    });

    test('returns false when all samples are below 0.98', () {
      final samples = Float32List.fromList([0.0, 0.5, 0.97]);
      expect(validator.checkClip(samples), isFalse);
    });

    test('returns false for empty buffer', () {
      expect(validator.checkClip(Float32List(0)), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // checkSilence
  // ---------------------------------------------------------------------------
  group('checkSilence', () {
    test('returns true for all-zero buffer', () {
      expect(validator.checkSilence(Float32List(1024)), isTrue);
    });

    test('returns true for sub-threshold signal (~−140 dBFS)', () {
      final samples = Float32List.fromList(List.filled(1024, 1e-7));
      expect(validator.checkSilence(samples), isTrue);
    });

    test('returns false for audible signal (−20 dBFS)', () {
      final samples = Float32List.fromList(List.filled(1024, 0.1));
      expect(validator.checkSilence(samples), isFalse);
    });

    test('returns true for empty buffer', () {
      expect(validator.checkSilence(Float32List(0)), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // checkSnr
  // ---------------------------------------------------------------------------
  group('checkSnr', () {
    FrequencyResponse _flatResponse(double mag, int count) {
      final pts = List.generate(
        count,
        (i) => FrequencyPoint(
          frequency: 100.0 + i * 100.0,
          magnitude: mag,
        ),
      );
      return FrequencyResponse(pts);
    }

    PeakResult _fakePeak(double amplitudeDb) => PeakResult(
          frequency: 4780.0,
          amplitudeDb: amplitudeDb,
          qFactor: 3.0,
          bandwidthHz: 1593.0,
        );

    test('SNR < 10 dB for low-signal response (DoD)', () {
      // Noise floor at −30 dB, peak at −25 dB → SNR = 5 dB.
      final response = _flatResponse(-30.0, 100);
      final peak = _fakePeak(-25.0);
      expect(validator.checkSnr(response, peak), lessThan(10.0));
    });

    test('SNR > 10 dB for strong signal', () {
      // Noise floor at −40 dB, peak at −15 dB → SNR = 25 dB.
      final response = _flatResponse(-40.0, 100);
      final peak = _fakePeak(-15.0);
      expect(validator.checkSnr(response, peak), greaterThan(10.0));
    });

    test('returns 0.0 for empty response', () {
      final peak = _fakePeak(-10.0);
      expect(validator.checkSnr(const FrequencyResponse([]), peak), 0.0);
    });

    test('median is used, not mean (odd-length list)', () {
      // 3 points: -50, -30, -10. Median = -30.
      final response = FrequencyResponse([
        FrequencyPoint(frequency: 500.0, magnitude: -50.0),
        FrequencyPoint(frequency: 1000.0, magnitude: -30.0),
        FrequencyPoint(frequency: 2000.0, magnitude: -10.0),
      ]);
      final peak = _fakePeak(-5.0);
      // SNR = -5 - (-30) = 25 dB
      expect(validator.checkSnr(response, peak), closeTo(25.0, 0.001));
    });
  });
}
