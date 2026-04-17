import '../entities/frequency_response.dart';
import '../entities/pickup_type.dart';
import 'pickup_reference_data.dart';

class PeakResult {
  const PeakResult({
    required this.frequency,
    required this.amplitudeDb,
    required this.qFactor,
    required this.bandwidthHz,
  });

  final double frequency;   // Hz
  final double amplitudeDb; // dB
  final double qFactor;     // dimensionless
  final double bandwidthHz; // Hz (-3 dB bandwidth)
}

class PeakDetector {
  const PeakDetector();

  /// Finds the resonant peak in [response].
  ///
  /// When [type] is provided the search range is taken from
  /// [PickupReferenceData]. For [PickupType.unknown] the lower bound is
  /// 500 Hz and the upper bound is 20 kHz.
  PeakResult? findResonantPeak(
    FrequencyResponse response, {
    PickupType? type,
  }) {
    final range = _searchRange(type);
    final window = response.slice(range.$1, range.$2);
    if (window.points.isEmpty) return null;

    final peak = window.maxMagnitude()!;
    final q = computeQFactor(response, peak.frequency);

    return PeakResult(
      frequency: peak.frequency,
      amplitudeDb: peak.magnitude,
      qFactor: q,
      bandwidthHz: q > 0 ? peak.frequency / q : 0.0,
    );
  }

  /// Computes Q factor by walking the -3 dB points on both sides of [peakFreq].
  ///
  /// Returns 0 if the -3 dB points cannot be found or the response is empty.
  double computeQFactor(FrequencyResponse response, double peakFreq) {
    if (response.points.isEmpty) return 0.0;

    final peakPoint = response.atFrequency(peakFreq);
    if (peakPoint == null) return 0.0;

    final threshold = peakPoint.magnitude - 3.0;
    final sorted = List.of(response.points)
      ..sort((a, b) => a.frequency.compareTo(b.frequency));

    final peakIndex =
        sorted.indexWhere((p) => p.frequency >= peakPoint.frequency);
    if (peakIndex < 0) return 0.0;

    // Walk left to find lower -3 dB crossing.
    double? lowerFreq;
    for (int i = peakIndex - 1; i >= 0; i--) {
      if (sorted[i].magnitude <= threshold) {
        // Interpolate between i and i+1.
        final p0 = sorted[i];
        final p1 = sorted[i + 1];
        final t = (threshold - p0.magnitude) / (p1.magnitude - p0.magnitude);
        lowerFreq = p0.frequency + t * (p1.frequency - p0.frequency);
        break;
      }
    }

    // Walk right to find upper -3 dB crossing.
    double? upperFreq;
    for (int i = peakIndex + 1; i < sorted.length; i++) {
      if (sorted[i].magnitude <= threshold) {
        final p0 = sorted[i - 1];
        final p1 = sorted[i];
        final t = (threshold - p0.magnitude) / (p1.magnitude - p0.magnitude);
        upperFreq = p0.frequency + t * (p1.frequency - p0.frequency);
        break;
      }
    }

    if (lowerFreq == null || upperFreq == null) return 0.0;

    final bandwidth = upperFreq - lowerFreq;
    if (bandwidth <= 0) return 0.0;
    return peakFreq / bandwidth;
  }

  /// Returns (minHz, maxHz) for the peak search given [type].
  (double, double) _searchRange(PickupType? type) {
    if (type == null || type == PickupType.unknown) {
      return (500.0, 20000.0);
    }
    final profile = PickupReferenceData.forType(type);
    if (profile == null) return (500.0, 20000.0);
    return (profile.searchRangeHz.min, profile.searchRangeHz.max);
  }
}
