import 'frequency_point.dart';

class FrequencyResponse {
  const FrequencyResponse(this.points);

  final List<FrequencyPoint> points;

  /// Returns the point nearest to [hz], or null if empty.
  FrequencyPoint? atFrequency(double hz) {
    if (points.isEmpty) return null;
    return points.reduce((a, b) =>
        (a.frequency - hz).abs() < (b.frequency - hz).abs() ? a : b);
  }

  /// Returns the point with the highest magnitude, or null if empty.
  FrequencyPoint? maxMagnitude() {
    if (points.isEmpty) return null;
    return points.reduce((a, b) => a.magnitude >= b.magnitude ? a : b);
  }

  /// Returns a new [FrequencyResponse] containing only points in [f1]–[f2] Hz.
  FrequencyResponse slice(double f1, double f2) {
    return FrequencyResponse(
      points.where((p) => p.frequency >= f1 && p.frequency <= f2).toList(),
    );
  }
}
