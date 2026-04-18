import 'dart:convert';

import '../../domain/entities/pickup_measurement.dart';

/// Exports a single [PickupMeasurement] to CSV or JSON per §22.
class ExportService {
  const ExportService();

  /// Returns a CSV string per the §22 schema.
  ///
  /// Starts with a comment header block containing pickup metadata, followed by
  /// a `frequency_hz,magnitude_db` data table for every point in the response.
  String toCsv(PickupMeasurement m) {
    final buf = StringBuffer();
    final generated = DateTime.now().toUtc().toIso8601String().substring(0, 19);
    buf.writeln('# Keneth Frequency Export');
    buf.writeln('# Generated: $generated');
    buf.writeln('# Pickup: ${m.pickupName}');
    buf.writeln('# Type: ${m.type.name}');
    buf.writeln('# DCR: ${m.dcr.round()} ohms');
    buf.writeln('# Ambient temperature: ${m.ambientTempC.toStringAsFixed(1)} C');
    buf.writeln('# Resonant frequency: ${m.resonantFrequency.round()} Hz');
    buf.writeln('# Q factor: ${m.qFactor.toStringAsFixed(1)}');
    buf.writeln('# Peak amplitude: ${m.peakAmplitudeDb.toStringAsFixed(1)} dB');
    buf.writeln('# Calibration applied: ${m.calibrationApplied}');
    buf.writeln('#');
    buf.writeln('frequency_hz,magnitude_db');
    for (final p in m.response.points) {
      buf.writeln('${p.frequency},${p.magnitude.toStringAsFixed(4)}');
    }
    return buf.toString();
  }

  /// Returns a JSON string per the §22 schema.
  String toJson(PickupMeasurement m) {
    final generated =
        '${DateTime.now().toUtc().toIso8601String().substring(0, 19)}Z';
    final bandwidthHz =
        m.qFactor > 0 ? (m.resonantFrequency / m.qFactor).round() : null;
    final obj = {
      'export_version': 1,
      'generated': generated,
      'pickup': {
        'name': m.pickupName,
        'type': m.type.name,
        'dcr_ohms': m.dcr.round(),
        'ambient_temp_c': m.ambientTempC,
      },
      'result': {
        'resonant_frequency_hz': m.resonantFrequency.round(),
        'q_factor': m.qFactor,
        'peak_amplitude_db': m.peakAmplitudeDb,
        'bandwidth_3db_hz': bandwidthHz,
        'inductance_h_estimated': m.inductance,
        'capacitance_f_estimated': m.capacitance,
        'calibration_applied': m.calibrationApplied,
      },
      'frequency_response': m.response.points
          .map((p) => {
                'frequency_hz': p.frequency,
                'magnitude_db': p.magnitude,
              })
          .toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(obj);
  }

  /// Returns the export filename for [m] in the given format extension.
  ///
  /// Format: `keneth_[pickup_name]_[timestamp].[ext]`
  String fileName(PickupMeasurement m, String ext) {
    final name = m.pickupName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
    final ts = m.timestamp
        .toUtc()
        .toIso8601String()
        .substring(0, 19)
        .replaceAll(':', '')
        .replaceAll('-', '')
        .replaceAll('T', '_');
    return 'keneth_${name}_$ts.$ext';
  }
}
