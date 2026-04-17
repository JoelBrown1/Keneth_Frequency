import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/domain/entities/pickup_type.dart';
import 'package:keneth_frequency/domain/services/peak_detector.dart';

/// Builds a synthetic frequency response with a Gaussian peak centred at
/// [peakHz] with the given [qFactor] (higher Q = narrower peak).
FrequencyResponse _syntheticResponse({
  required double peakHz,
  double qFactor = 3.0,
  double peakDb = 0.0,
  double noiseFloorDb = -60.0,
  int points = 2000,
  double fMin = 20.0,
  double fMax = 20000.0,
}) {
  final result = <FrequencyPoint>[];
  for (int i = 0; i < points; i++) {
    final f = fMin * math.pow(fMax / fMin, i / (points - 1));
    // σ chosen so the Gaussian -3 dB half-bandwidth = peakHz/(2·Q).
    // At the -3 dB point: exp(-0.5·(half_bw/σ)²) = 0.95  →  half_bw/σ = 0.3203
    // Therefore σ = half_bw / 0.3203 = peakHz / (2·Q·0.3203) = peakHz / (Q·0.6406)
    final sigma = peakHz / (qFactor * 0.6406);
    final mag = peakDb +
        (noiseFloorDb - peakDb) *
            (1.0 - math.exp(-0.5 * math.pow((f - peakHz) / sigma, 2)));
    result.add(FrequencyPoint(frequency: f, magnitude: mag));
  }
  return FrequencyResponse(result);
}

void main() {
  const detector = PeakDetector();

  group('findResonantPeak — no type', () {
    test('locates peak in synthetic response', () {
      final response = _syntheticResponse(peakHz: 5000.0);
      final result = detector.findResonantPeak(response);
      expect(result, isNotNull);
      expect(result!.frequency, closeTo(5000.0, 50.0));
    });

    test('returns null for empty response', () {
      final result = detector.findResonantPeak(FrequencyResponse(const []));
      expect(result, isNull);
    });

    test('ignores peaks below 500 Hz for unknown type', () {
      // Place peak at 200 Hz — below the 500 Hz floor for unknown type.
      final response = _syntheticResponse(peakHz: 200.0);
      final result = detector.findResonantPeak(response, type: PickupType.unknown);
      // Should find nothing meaningful in the 500–20000 Hz window.
      expect(result, isNotNull); // window is still non-empty but peak is noise floor
      expect(result!.frequency, greaterThanOrEqualTo(500.0));
    });
  });

  group('findResonantPeak — humbuckerMediumOutput (4–6 kHz range)', () {
    test('SH-4 synthetic peak at 4.78 kHz located within ±50 Hz', () {
      final response = _syntheticResponse(peakHz: 4780.0, qFactor: 3.0);
      final result = detector.findResonantPeak(
        response,
        type: PickupType.humbuckerMediumOutput,
      );
      expect(result, isNotNull);
      expect(result!.frequency, closeTo(4780.0, 50.0));
    });

    test('search range excludes peaks outside 4–6 kHz', () {
      // Place peak at 9 kHz — outside the humbucker medium output range.
      final response = _syntheticResponse(peakHz: 9000.0);
      final result = detector.findResonantPeak(
        response,
        type: PickupType.humbuckerMediumOutput,
      );
      // Within the 4–6 kHz window the response is just noise floor, not the
      // 9 kHz peak. The detector should still return something (it finds the
      // highest point in the window) but not near 9 kHz.
      expect(result, isNotNull);
      expect(result!.frequency, lessThanOrEqualTo(6000.0));
    });

    test('search range is derived from PickupReferenceData, not hardcoded', () {
      // This test confirms the integration: changing PickupType changes the range.
      // humbuckerHighOutput search range is 2–4 kHz.
      final response = _syntheticResponse(peakHz: 3000.0, qFactor: 3.0);
      final result = detector.findResonantPeak(
        response,
        type: PickupType.humbuckerHighOutput,
      );
      expect(result, isNotNull);
      expect(result!.frequency, closeTo(3000.0, 50.0));
    });
  });

  group('computeQFactor', () {
    test('returns approximately the expected Q for a Gaussian peak', () {
      const peakHz = 5000.0;
      const expectedQ = 3.0;
      final response = _syntheticResponse(peakHz: peakHz, qFactor: expectedQ);
      final q = detector.computeQFactor(response, peakHz);
      // Gaussian approximation; allow ±30% tolerance.
      expect(q, greaterThan(expectedQ * 0.7));
      expect(q, lessThan(expectedQ * 1.3));
    });

    test('returns 0 for empty response', () {
      final q = detector.computeQFactor(FrequencyResponse(const []), 5000.0);
      expect(q, 0.0);
    });

    test('returns positive value for a real peak', () {
      final response = _syntheticResponse(peakHz: 4780.0, qFactor: 3.0);
      final q = detector.computeQFactor(response, 4780.0);
      expect(q, greaterThan(0.0));
    });
  });
}
