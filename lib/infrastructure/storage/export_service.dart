import '../../domain/entities/pickup_measurement.dart';

/// Exports measurement data to various formats.
///
/// Format implementations are added in Sprint 9.
class ExportService {
  const ExportService();

  /// Exports [measurements] as a CSV string.
  ///
  /// Columns: id, timestamp, pickupName, pickupType, dcr, ambientTempC,
  /// resonantFrequencyHz, qFactor, peakAmplitudeDb, dcrCorrected,
  /// inductance, capacitance, calibrationApplied.
  String exportToCsv(List<PickupMeasurement> measurements) {
    throw UnimplementedError('CSV export is implemented in Sprint 9');
  }

  /// Exports [measurements] as a JSON string.
  String exportToJson(List<PickupMeasurement> measurements) {
    throw UnimplementedError('JSON export is implemented in Sprint 9');
  }
}
