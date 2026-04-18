import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/entities/calibration_data.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/infrastructure/dsp/frequency_response_builder.dart';

void main() {
  const builder = FrequencyResponseBuilder();
  const sampleRate = 48000;
  const fftSize = 4096;

  List<double> _flatMagnitudes(int outSize, double db) =>
      List.filled(outSize, db);

  group('build — no calibration', () {
    test('all returned points are in 20–20,000 Hz', () {
      final mags = _flatMagnitudes(fftSize ~/ 2 + 1, -20.0);
      final response = builder.build(mags, fftSize, sampleRate);

      for (final p in response.points) {
        expect(p.frequency, greaterThanOrEqualTo(20.0));
        expect(p.frequency, lessThanOrEqualTo(20000.0));
      }
    });

    test('DC bin (0 Hz) and Nyquist (24 kHz) are excluded', () {
      final mags = _flatMagnitudes(fftSize ~/ 2 + 1, -20.0);
      final response = builder.build(mags, fftSize, sampleRate);

      final freqs = response.points.map((p) => p.frequency).toList();
      expect(freqs, isNot(contains(0.0)));
      // Nyquist bin = fftSize/2 → 24 000 Hz
      expect(freqs.where((f) => f > 20000.0), isEmpty);
    });

    test('all magnitudes equal the flat input value', () {
      const db = -35.0;
      final mags = _flatMagnitudes(fftSize ~/ 2 + 1, db);
      final response = builder.build(mags, fftSize, sampleRate);

      expect(response.points, isNotEmpty);
      for (final p in response.points) {
        expect(p.magnitude, closeTo(db, 1e-9));
      }
    });

    test('returns empty response when no bins are in 20–20k range', () {
      // Use a tiny fftSize/sampleRate so all bins are outside 20–20k Hz.
      // fftSize=4, sampleRate=1: bins at 0, 0.25, 0.5 Hz — all below 20 Hz.
      final mags = _flatMagnitudes(4 ~/ 2 + 1, -10.0);
      final response = builder.build(mags, 4, 1);
      expect(response.points, isEmpty);
    });
  });

  group('build — with calibration', () {
    test('flat calibration shifts all magnitudes', () {
      const rawDb = -10.0;
      const calDb = -5.0;
      final mags = _flatMagnitudes(fftSize ~/ 2 + 1, rawDb);
      final cal = CalibrationData(
        id: 'test',
        timestamp: DateTime.now(),
        spectrum: [
          FrequencyPoint(frequency: 20.0, magnitude: calDb),
          FrequencyPoint(frequency: 20000.0, magnitude: calDb),
        ],
      );
      final response = builder.build(mags, fftSize, sampleRate, calibration: cal);

      // calibrated = raw − cal = −10 − (−5) = −5
      for (final p in response.points) {
        expect(p.magnitude, closeTo(rawDb - calDb, 1e-6));
      }
    });

    test('calibration clamped at edges (below first calibration point)', () {
      // Calibration starts at 1000 Hz — bins below that should use the
      // first calibration value (clamping, not extrapolation).
      const calEdgeMag = -3.0;
      final cal = CalibrationData(
        id: 'test',
        timestamp: DateTime.now(),
        spectrum: [
          FrequencyPoint(frequency: 1000.0, magnitude: calEdgeMag),
          FrequencyPoint(frequency: 20000.0, magnitude: calEdgeMag),
        ],
      );
      const rawDb = -10.0;
      final mags = _flatMagnitudes(fftSize ~/ 2 + 1, rawDb);
      final response = builder.build(mags, fftSize, sampleRate, calibration: cal);

      // Bins below 1000 Hz use the edge value − same calibration.
      final below1k = response.points.where((p) => p.frequency < 1000.0);
      for (final p in below1k) {
        expect(p.magnitude, closeTo(rawDb - calEdgeMag, 1e-6));
      }
    });

    test('calibration interpolation — linearly varying cal spectrum', () {
      // Cal: -3 dB at 100 Hz, -9 dB at 10000 Hz.
      // At 1000 Hz: t = (1000-100)/(10000-100) = 900/9900 ≈ 0.09091
      // calDb = -3 + 0.09091×(-9 - -3) = -3 - 0.545 = -3.545
      final cal = CalibrationData(
        id: 'test',
        timestamp: DateTime.now(),
        spectrum: [
          FrequencyPoint(frequency: 100.0, magnitude: -3.0),
          FrequencyPoint(frequency: 10000.0, magnitude: -9.0),
        ],
      );
      const rawDb = 0.0;
      final mags = _flatMagnitudes(fftSize ~/ 2 + 1, rawDb);
      final response = builder.build(mags, fftSize, sampleRate, calibration: cal);

      // Find the point nearest to 1000 Hz.
      final near1k = response.points
          .reduce((a, b) => (a.frequency - 1000).abs() < (b.frequency - 1000).abs() ? a : b);

      const expectedCalDb = -3.0 + (900.0 / 9900.0) * (-9.0 - -3.0);
      expect(near1k.magnitude, closeTo(rawDb - expectedCalDb, 0.05));
    });
  });
}
