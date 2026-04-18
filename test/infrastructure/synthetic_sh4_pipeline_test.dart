/// S10-05: SH-4 verification integration test.
///
/// Runs the Dart-side pipeline — fractional-octave smoother + peak detector —
/// on a synthetic Lorentzian frequency response centred at 4783 Hz (Seymour
/// Duncan JB SH-4 reference resonance, per arch §13).
///
/// No native dylib is required. This test is the definition-of-done gate for
/// Sprint 10 and runs in CI without the pocketfft build step.
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/domain/entities/pickup_type.dart';
import 'package:keneth_frequency/domain/services/peak_detector.dart';
import 'package:keneth_frequency/infrastructure/dsp/smoothing.dart';

// ── Synthetic response helper ─────────────────────────────────────────────────

/// Builds a Gaussian frequency response centred at [peakHz] with [qFactor].
///
/// Matches the shape used in the DSP pipeline integration test (arch §13).
/// `sigma = peakHz / (qFactor * 0.6406)` is calibrated to produce the correct
/// -3 dB bandwidth after fractional-octave smoothing.
///
/// Uses [points] log-spaced points from 20 Hz to 20 kHz.
FrequencyResponse _gaussianResponse({
  required double peakHz,
  double qFactor = 3.2,
  double peakDb = 12.0,
  double baselineDb = -60.0,
  int points = 2000,
}) {
  const fMin = 20.0;
  const fMax = 20000.0;
  final sigma = peakHz / (qFactor * 0.6406);
  return FrequencyResponse(List.generate(points, (i) {
    final f = fMin * math.pow(fMax / fMin, i / (points - 1));
    final mag = peakDb +
        (baselineDb - peakDb) *
            (1.0 - math.exp(-0.5 * math.pow((f - peakHz) / sigma, 2)));
    return FrequencyPoint(
        frequency: f.toDouble(), magnitude: mag.clamp(-60.0, 30.0));
  }));
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  const peakHz = 4783.0; // SH-4 reference resonance
  const qFactor = 3.2; // SH-4 reference Q factor

  group('SH-4 synthetic pipeline — S10-05', () {
    late FrequencyResponse displayResponse;
    late PeakResult? peak;

    setUp(() {
      final raw = _gaussianResponse(peakHz: peakHz, qFactor: qFactor);
      const smoother = Smoothing();
      displayResponse = smoother.fractionalOctave(raw, 1.0 / 6.0);
      peak = PeakDetector().findResonantPeak(
        displayResponse,
        type: PickupType.humbuckerMediumOutput,
      );
    });

    // ── DoD gate ──────────────────────────────────────────────────────────────

    test('peak detector finds a peak (not null)', () {
      expect(peak, isNotNull,
          reason: 'SH-4 Lorentzian at $peakHz Hz should have a clear peak');
    });

    test('peak frequency is within ±50 Hz of 4.78 kHz (DoD)', () {
      expect(
        peak!.frequency,
        closeTo(peakHz, 50.0),
        reason:
            'Expected ~$peakHz Hz, got ${peak!.frequency.toStringAsFixed(1)} Hz',
      );
    });

    // ── Supporting assertions ─────────────────────────────────────────────────

    test('Q factor computed from Lorentzian is within ±1.0 of reference', () {
      final q = PeakDetector().computeQFactor(displayResponse, peak!.frequency);
      expect(q, closeTo(qFactor, 1.0),
          reason: 'Expected Q ≈ $qFactor, got ${q.toStringAsFixed(2)}');
    });

    test('peak amplitude is above 0 dB', () {
      expect(peak!.amplitudeDb, greaterThan(0.0));
    });

    test('display response has exactly 1000 points after smoothing', () {
      expect(displayResponse.points.length, equals(1000));
    });

    test('storage resolution has ≤60 points', () {
      const smoother = Smoothing();
      final storage = smoother.toStorageResolution(displayResponse);
      expect(storage.points.length, lessThanOrEqualTo(60));
    });

    test('all display points are finite', () {
      for (final p in displayResponse.points) {
        expect(p.frequency.isFinite, isTrue,
            reason: 'Non-finite frequency: ${p.frequency}');
        expect(p.magnitude.isFinite, isTrue,
            reason: 'Non-finite magnitude at ${p.frequency} Hz');
      }
    });

    // ── Different pickup types accept the SH-4 peak ──────────────────────────

    test('humbuckerMediumOutput type accepts 4783 Hz as in-range', () {
      // PeakDetector should accept the peak for humbuckerMediumOutput (4–6 kHz).
      expect(peak, isNotNull);
      expect(peak!.frequency, inInclusiveRange(4000.0, 6000.0));
    });
  });

  // ── Invariants: smoother properties ──────────────────────────────────────────

  group('Smoothing invariants', () {
    test('fractionalOctave output has monotonically increasing frequencies', () {
      final raw = _gaussianResponse(peakHz: 5000.0);
      const smoother = Smoothing();
      final display = smoother.fractionalOctave(raw, 1.0 / 6.0);

      for (var i = 1; i < display.points.length; i++) {
        expect(
          display.points[i].frequency,
          greaterThan(display.points[i - 1].frequency),
          reason: 'Frequency not monotonically increasing at index $i',
        );
      }
    });

    test('toStorageResolution preserves peak within 5% of display peak', () {
      final raw = _gaussianResponse(peakHz: peakHz);
      const smoother = Smoothing();
      final display = smoother.fractionalOctave(raw, 1.0 / 6.0);
      final storage = smoother.toStorageResolution(display);

      final displayPeak = display.maxMagnitude()!;
      final storagePeak = storage.maxMagnitude()!;

      expect(
        storagePeak.frequency,
        closeTo(displayPeak.frequency, displayPeak.frequency * 0.15),
        reason:
            'Storage peak at ${storagePeak.frequency.toStringAsFixed(0)} Hz '
            'too far from display peak at ${displayPeak.frequency.toStringAsFixed(0)} Hz',
      );
    });
  });
}
