import 'dart:math' as math;

import '../../domain/entities/frequency_point.dart';
import '../../domain/entities/frequency_response.dart';

class Smoothing {
  const Smoothing();

  static const int _displayPoints = 1000;
  static const int _storagePoints = 60;
  static const double _fMin = 20.0;
  static const double _fMax = 20000.0;

  /// Applies fractional-octave smoothing and resamples to [_displayPoints]
  /// log-spaced centre frequencies from 20 Hz to 20 kHz.
  ///
  /// [fraction] — the octave fraction (e.g. 1/6 octave → pass `1.0 / 6.0`).
  ///
  /// For each centre frequency the smoothing band is
  ///   [fc × 2^(−fraction/2), fc × 2^(+fraction/2)].
  /// Magnitudes of all input points within the band are averaged (arithmetic
  /// mean in dB). If no input points fall inside the band, the nearest input
  /// point is used instead.
  FrequencyResponse fractionalOctave(
    FrequencyResponse response,
    double fraction,
  ) {
    if (response.points.isEmpty) return const FrequencyResponse([]);

    // Sort input by frequency (defensive — should already be sorted).
    final sorted = List.of(response.points)
      ..sort((a, b) => a.frequency.compareTo(b.frequency));

    final result = <FrequencyPoint>[];
    final logRatio = math.log(_fMax / _fMin);

    // Two-pointer sweep for O(n + m) performance.
    int lo = 0;
    int hi = 0;

    for (int k = 0; k < _displayPoints; k++) {
      final fc = _fMin * math.exp(logRatio * k / (_displayPoints - 1));
      final fLo = fc * math.pow(2.0, -fraction / 2.0);
      final fHi = fc * math.pow(2.0, fraction / 2.0);

      // Advance lo past points below the band.
      while (lo < sorted.length && sorted[lo].frequency < fLo) lo++;
      // Advance hi to include all points up to the band's upper edge.
      if (hi < lo) hi = lo;
      while (hi < sorted.length && sorted[hi].frequency <= fHi) hi++;

      double mag;
      if (lo >= hi) {
        // No points in band — use nearest input point.
        mag = _nearestMagnitude(sorted, fc);
      } else {
        double sum = 0.0;
        for (int j = lo; j < hi; j++) sum += sorted[j].magnitude;
        mag = sum / (hi - lo);
      }

      result.add(FrequencyPoint(frequency: fc, magnitude: mag));
    }

    return FrequencyResponse(result);
  }

  /// Downsamples an already-smoothed [response] to [_storagePoints] (~60)
  /// log-spaced points. Finds the nearest input point for each target frequency.
  ///
  /// Returns at most [_storagePoints] points (fewer if input has fewer points).
  FrequencyResponse toStorageResolution(FrequencyResponse response) {
    if (response.points.isEmpty) return const FrequencyResponse([]);

    final count = math.min(_storagePoints, response.points.length);
    if (count == response.points.length) return response;

    final sorted = List.of(response.points)
      ..sort((a, b) => a.frequency.compareTo(b.frequency));

    final logRatio = math.log(_fMax / _fMin);
    final result = <FrequencyPoint>[];

    for (int k = 0; k < count; k++) {
      final fc = _fMin * math.exp(logRatio * k / (count - 1));
      result.add(FrequencyPoint(
        frequency: fc,
        magnitude: _nearestMagnitude(sorted, fc),
      ));
    }

    return FrequencyResponse(result);
  }

  double _nearestMagnitude(List<FrequencyPoint> sorted, double hz) {
    if (sorted.isEmpty) return 0.0;
    var best = sorted[0];
    var bestDist = (sorted[0].frequency - hz).abs();
    for (int i = 1; i < sorted.length; i++) {
      final d = (sorted[i].frequency - hz).abs();
      if (d < bestDist) {
        bestDist = d;
        best = sorted[i];
      }
      if (sorted[i].frequency > hz && d > bestDist) break; // sorted, can stop
    }
    return best.magnitude;
  }
}
