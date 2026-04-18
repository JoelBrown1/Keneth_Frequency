import '../../domain/entities/calibration_data.dart';
import '../../domain/entities/frequency_point.dart';
import '../../domain/entities/frequency_response.dart';

class FrequencyResponseBuilder {
  const FrequencyResponseBuilder();

  /// Converts raw FFT magnitude output into a [FrequencyResponse].
  ///
  /// [magnitudesDb] — output of [FftProcessor.process], length = fftSize ~/ 2 + 1.
  /// [fftSize]      — the padded FFT size used to produce [magnitudesDb].
  /// [sampleRate]   — in Hz (e.g. 48000).
  /// [calibration]  — if provided, its spectrum is subtracted (dB − dB).
  ///
  /// Only bins in the 20 Hz – 20 kHz range are retained.
  FrequencyResponse build(
    List<double> magnitudesDb,
    int fftSize,
    int sampleRate, {
    CalibrationData? calibration,
  }) {
    final calPoints = calibration?.spectrum ?? const [];

    final points = <FrequencyPoint>[];
    for (int i = 0; i < magnitudesDb.length; i++) {
      final hz = i * sampleRate / fftSize;
      if (hz < 20.0 || hz > 20000.0) continue;

      double mag = magnitudesDb[i];
      if (calPoints.isNotEmpty) {
        mag -= _interpolate(calPoints, hz);
      }
      points.add(FrequencyPoint(frequency: hz, magnitude: mag));
    }

    return FrequencyResponse(points);
  }

  /// Linear interpolation of [pts] (sorted by frequency) at [hz].
  /// Clamps to the nearest edge value if [hz] is out of range.
  double _interpolate(List<FrequencyPoint> pts, double hz) {
    if (pts.length == 1) return pts[0].magnitude;
    if (hz <= pts.first.frequency) return pts.first.magnitude;
    if (hz >= pts.last.frequency) return pts.last.magnitude;

    // Binary search for the bracketing pair.
    int lo = 0, hi = pts.length - 1;
    while (hi - lo > 1) {
      final mid = (lo + hi) ~/ 2;
      if (pts[mid].frequency <= hz) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    final p0 = pts[lo];
    final p1 = pts[hi];
    final t = (hz - p0.frequency) / (p1.frequency - p0.frequency);
    return p0.magnitude + t * (p1.magnitude - p0.magnitude);
  }
}
