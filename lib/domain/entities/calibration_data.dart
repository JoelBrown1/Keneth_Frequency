import 'frequency_point.dart';

class CalibrationData {
  const CalibrationData({
    required this.id,
    required this.timestamp,
    required this.spectrum,
  });

  final String id;
  final DateTime timestamp;
  final List<FrequencyPoint> spectrum;
}
