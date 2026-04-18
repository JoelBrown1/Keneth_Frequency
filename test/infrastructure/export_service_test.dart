import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/domain/entities/pickup_measurement.dart';
import 'package:keneth_frequency/domain/entities/pickup_type.dart';
import 'package:keneth_frequency/infrastructure/storage/export_service.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

PickupMeasurement _fakeMeasurement() => PickupMeasurement(
      id: 'test-id',
      timestamp: DateTime.utc(2026, 4, 16, 14, 32, 0),
      type: PickupType.humbuckerMediumOutput,
      pickupName: 'Seymour Duncan JB SH-4',
      dcr: 16540,
      ambientTempC: 21.0,
      resonantFrequency: 4783.0,
      qFactor: 3.2,
      peakAmplitudeDb: 12.4,
      response: FrequencyResponse([
        FrequencyPoint(frequency: 20.0, magnitude: -0.3),
        FrequencyPoint(frequency: 1000.0, magnitude: 2.1),
        FrequencyPoint(frequency: 4783.0, magnitude: 12.4),
        FrequencyPoint(frequency: 20000.0, magnitude: -18.6),
      ]),
      calibrationApplied: true,
      dcrCorrected: 16100,
      inductance: 0.0081,
      capacitance: 1.36e-10,
    );

void main() {
  const service = ExportService();

  // ── S9-11: toCsv ─────────────────────────────────────────────────────────

  group('ExportService.toCsv — S9-11', () {
    late String csv;

    setUp(() {
      csv = service.toCsv(_fakeMeasurement());
    });

    test('starts with Keneth Frequency Export header', () {
      expect(csv, startsWith('# Keneth Frequency Export\n'));
    });

    test('contains pickup name header line', () {
      expect(csv, contains('# Pickup: Seymour Duncan JB SH-4\n'));
    });

    test('contains type header line', () {
      expect(csv, contains('# Type: humbuckerMediumOutput\n'));
    });

    test('contains DCR header line', () {
      expect(csv, contains('# DCR: 16540 ohms\n'));
    });

    test('contains resonant frequency header line', () {
      expect(csv, contains('# Resonant frequency: 4783 Hz\n'));
    });

    test('contains calibration header line', () {
      expect(csv, contains('# Calibration applied: true\n'));
    });

    test('column header row is present', () {
      expect(csv, contains('frequency_hz,magnitude_db\n'));
    });

    test('correct number of data rows matches response point count', () {
      final lines = csv.split('\n').where((l) => l.isNotEmpty).toList();
      // Remove all comment lines and the column header.
      final dataLines = lines
          .where((l) => !l.startsWith('#') && l != 'frequency_hz,magnitude_db')
          .toList();
      expect(dataLines.length, equals(4)); // 4 response points
    });

    test('first data row matches first frequency point', () {
      expect(csv, contains('20.0,-0.3000\n'));
    });

    test('fileName returns correct format', () {
      final m = _fakeMeasurement();
      final name = service.fileName(m, 'csv');
      expect(name, startsWith('keneth_seymour_duncan_jb_sh_4_'));
      expect(name, endsWith('.csv'));
    });
  });

  // ── S9-12: toJson ─────────────────────────────────────────────────────────

  group('ExportService.toJson — S9-12', () {
    late Map<String, dynamic> obj;

    setUp(() {
      final raw = service.toJson(_fakeMeasurement());
      obj = jsonDecode(raw) as Map<String, dynamic>;
    });

    test('export_version is 1', () {
      expect(obj['export_version'], equals(1));
    });

    test('generated field is present', () {
      expect(obj['generated'], isA<String>());
    });

    test('pickup.name matches measurement name', () {
      expect(obj['pickup']['name'], equals('Seymour Duncan JB SH-4'));
    });

    test('pickup.type matches enum name', () {
      expect(obj['pickup']['type'], equals('humbuckerMediumOutput'));
    });

    test('pickup.dcr_ohms is rounded integer', () {
      expect(obj['pickup']['dcr_ohms'], equals(16540));
    });

    test('result.resonant_frequency_hz is correct', () {
      expect(obj['result']['resonant_frequency_hz'], equals(4783));
    });

    test('result.q_factor is correct', () {
      expect(obj['result']['q_factor'], closeTo(3.2, 0.001));
    });

    test('result.peak_amplitude_db is correct', () {
      expect(obj['result']['peak_amplitude_db'], closeTo(12.4, 0.001));
    });

    test('result.bandwidth_3db_hz is computed from q and f_res', () {
      // bandwidth = 4783 / 3.2 ≈ 1494.7 → rounded to 1495
      final bw = obj['result']['bandwidth_3db_hz'] as int;
      expect(bw, closeTo(1495, 2));
    });

    test('result.inductance_h_estimated is present', () {
      expect(obj['result']['inductance_h_estimated'], closeTo(0.0081, 0.0001));
    });

    test('result.capacitance_f_estimated is present', () {
      expect(obj['result']['capacitance_f_estimated'],
          closeTo(1.36e-10, 1e-12));
    });

    test('result.calibration_applied is true', () {
      expect(obj['result']['calibration_applied'], isTrue);
    });

    test('frequency_response array has correct length', () {
      final fr = obj['frequency_response'] as List<dynamic>;
      expect(fr.length, equals(4));
    });

    test('frequency_response entries have frequency_hz and magnitude_db', () {
      final fr = obj['frequency_response'] as List<dynamic>;
      final first = fr.first as Map<String, dynamic>;
      expect(first['frequency_hz'], closeTo(20.0, 0.001));
      expect(first['magnitude_db'], closeTo(-0.3, 0.001));
    });

    test('fileName returns correct .json extension', () {
      final m = _fakeMeasurement();
      final name = service.fileName(m, 'json');
      expect(name, endsWith('.json'));
    });
  });
}
