/// S10-07: Export round-trip integration test.
///
/// Saves a [PickupMeasurement] to [MeasurementRepository], retrieves it, then
/// exports it via [ExportService] and verifies the exported content parses back
/// to the original field values.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/domain/entities/pickup_measurement.dart';
import 'package:keneth_frequency/domain/entities/pickup_type.dart';
import 'package:keneth_frequency/infrastructure/storage/app_database.dart';
import 'package:keneth_frequency/infrastructure/storage/export_service.dart';
import 'package:keneth_frequency/infrastructure/storage/measurement_repository.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

FrequencyResponse _storageResponse() => FrequencyResponse(
      List.generate(
          20, (i) => FrequencyPoint(frequency: 20.0 + i * 1000, magnitude: -10.0)),
    );

PickupMeasurement _fakeMeasurement() => PickupMeasurement(
      id: 'round-trip-id',
      timestamp: DateTime.utc(2026, 4, 18, 10, 30, 0),
      type: PickupType.humbuckerMediumOutput,
      pickupName: 'SH-4 Round Trip',
      dcr: 16540.0,
      ambientTempC: 21.5,
      resonantFrequency: 4783.0,
      qFactor: 3.2,
      peakAmplitudeDb: 12.4,
      response: FrequencyResponse(List.generate(80, (i) {
        final f = 20.0 * (1000.0 / 20.0) * (i / 79.0);
        return FrequencyPoint(
            frequency: 20.0 + f, magnitude: -10.0 + (i % 5) * 2.0);
      })),
      calibrationApplied: true,
      dcrCorrected: 16200.0,
      inductance: 0.0081,
      capacitance: 1.36e-10,
    );

void main() {
  late AppDatabase db;
  late MeasurementRepository repo;

  setUp(() {
    db = AppDatabase.forTesting();
    repo = MeasurementRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  // ── S10-07a: CSV round trip ─────────────────────────────────────────────────

  group('ExportService CSV round trip — S10-07a', () {
    late PickupMeasurement m;
    late String csv;

    setUp(() async {
      m = _fakeMeasurement();
      await repo.save(m, storageResponse: _storageResponse());
      // Retrieve at display resolution to simulate ResultsScreen export.
      final retrieved = await repo.getById(m.id);
      const service = ExportService();
      csv = service.toCsv(retrieved ?? m);
    });

    test('CSV starts with correct header', () {
      expect(csv, startsWith('# Keneth Frequency Export'));
    });

    test('pickup name round trips through CSV header', () {
      expect(csv, contains('# Pickup: ${m.pickupName}'));
    });

    test('pickup type round trips through CSV header', () {
      expect(csv, contains('# Type: ${m.type.name}'));
    });

    test('DCR round trips through CSV header', () {
      expect(csv, contains('# DCR: ${m.dcr.round()} ohms'));
    });

    test('resonant frequency round trips through CSV header', () {
      expect(csv, contains('# Resonant frequency: ${m.resonantFrequency.round()} Hz'));
    });

    test('calibration applied round trips through CSV header', () {
      expect(csv, contains('# Calibration applied: true'));
    });

    test('column header row is present', () {
      expect(csv, contains('frequency_hz,magnitude_db'));
    });

    test('data rows are parseable as (double, double) pairs', () {
      final dataLines = csv
          .split('\n')
          .where((l) =>
              l.isNotEmpty &&
              !l.startsWith('#') &&
              l != 'frequency_hz,magnitude_db')
          .toList();

      expect(dataLines, isNotEmpty);

      for (final line in dataLines) {
        final parts = line.split(',');
        expect(parts.length, equals(2),
            reason: 'Expected 2 fields, got ${parts.length} in "$line"');
        expect(double.tryParse(parts[0]), isNotNull,
            reason: 'frequency_hz not parseable: ${parts[0]}');
        expect(double.tryParse(parts[1]), isNotNull,
            reason: 'magnitude_db not parseable: ${parts[1]}');
      }
    });
  });

  // ── S10-07b: JSON round trip ────────────────────────────────────────────────

  group('ExportService JSON round trip — S10-07b', () {
    late PickupMeasurement m;
    late Map<String, dynamic> obj;

    setUp(() async {
      m = _fakeMeasurement();
      await repo.save(m, storageResponse: _storageResponse());
      final retrieved = await repo.getById(m.id);
      const service = ExportService();
      final json = service.toJson(retrieved ?? m);
      obj = jsonDecode(json) as Map<String, dynamic>;
    });

    test('export_version is 1', () {
      expect(obj['export_version'], equals(1));
    });

    test('pickup name round trips through JSON', () {
      expect(obj['pickup']['name'], equals(m.pickupName));
    });

    test('pickup type round trips through JSON', () {
      expect(obj['pickup']['type'], equals(m.type.name));
    });

    test('DCR round trips through JSON', () {
      expect(obj['pickup']['dcr_ohms'], equals(m.dcr.round()));
    });

    test('resonant frequency round trips through JSON', () {
      expect(
          obj['result']['resonant_frequency_hz'], equals(m.resonantFrequency.round()));
    });

    test('Q factor round trips through JSON', () {
      expect(obj['result']['q_factor'], closeTo(m.qFactor, 0.001));
    });

    test('peak amplitude round trips through JSON', () {
      expect(
          obj['result']['peak_amplitude_db'], closeTo(m.peakAmplitudeDb, 0.001));
    });

    test('calibration_applied round trips through JSON', () {
      expect(obj['result']['calibration_applied'], isTrue);
    });

    test('bandwidth_3db_hz is derived correctly (f_res / Q)', () {
      final expected = (m.resonantFrequency / m.qFactor).round();
      expect(obj['result']['bandwidth_3db_hz'], closeTo(expected, 2));
    });

    test('frequency_response array is non-empty', () {
      final fr = obj['frequency_response'] as List<dynamic>;
      expect(fr, isNotEmpty);
    });

    test('frequency_response entries have correct field names', () {
      final fr = obj['frequency_response'] as List<dynamic>;
      final first = fr.first as Map<String, dynamic>;
      expect(first.containsKey('frequency_hz'), isTrue);
      expect(first.containsKey('magnitude_db'), isTrue);
    });

    test('filename is correctly formatted', () {
      const service = ExportService();
      final csvName = service.fileName(m, 'csv');
      expect(csvName, startsWith('keneth_sh_4_round_trip_'));
      expect(csvName, endsWith('.csv'));

      final jsonName = service.fileName(m, 'json');
      expect(jsonName, endsWith('.json'));
    });
  });
}
