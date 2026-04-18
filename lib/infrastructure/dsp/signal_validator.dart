import 'dart:math' as math;
import 'dart:typed_data';

import '../../domain/entities/frequency_response.dart';
import '../../domain/services/peak_detector.dart';

class SignalValidator {
  const SignalValidator();

  /// Returns `true` if any sample has absolute value ≥ 0.98 (clipping).
  bool checkClip(Float32List samples) {
    for (final s in samples) {
      if (s.abs() >= 0.98) return true;
    }
    return false;
  }

  /// Returns `true` if the RMS level is below −60 dBFS (silence).
  bool checkSilence(Float32List samples) {
    if (samples.isEmpty) return true;
    double sumSq = 0.0;
    for (final s in samples) sumSq += s * s;
    final rmsLinear = math.sqrt(sumSq / samples.length);
    if (rmsLinear < 1e-12) return true; // treat as −240 dBFS
    final rmsDb = 20.0 * math.log(rmsLinear) / math.ln10;
    return rmsDb < -60.0;
  }

  /// Returns the SNR in dB: peak amplitude minus the median of all point
  /// magnitudes in [response]. Values below 10.0 dB indicate a poor result.
  ///
  /// Returns 0.0 if [response] is empty.
  double checkSnr(FrequencyResponse response, PeakResult peak) {
    if (response.points.isEmpty) return 0.0;
    final mags = response.points.map((p) => p.magnitude).toList()..sort();
    final mid = mags.length ~/ 2;
    final median = mags.length.isOdd
        ? mags[mid]
        : (mags[mid - 1] + mags[mid]) / 2.0;
    return peak.amplitudeDb - median;
  }
}
