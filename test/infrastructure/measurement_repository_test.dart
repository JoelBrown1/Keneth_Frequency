import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/domain/entities/pickup_measurement.dart';
import 'package:keneth_frequency/domain/entities/pickup_type.dart';
import 'package:keneth_frequency/infrastructure/storage/app_database.dart';
import 'package:keneth_frequency/infrastructure/storage/measurement_repository.dart';

void main() {
  late AppDatabase db;
  late MeasurementRepository repo;

  setUp(() {
    db = AppDatabase.forTesting();
    repo = MeasurementRepository(db);
  });

  tearDown(() => db.close());

  // ── Helpers ──────────────────────────────────────────────────────────────

  FrequencyResponse _makeResponse(int count) {
    return FrequencyResponse(List.generate(count, (i) {
      final f = 20.0 * (20000.0 / 20.0) * (i / (count - 1));
      return FrequencyPoint(frequency: f.clamp(20, 20000), magnitude: -20.0 + i * 0.01);
    }));
  }

  PickupMeasurement _makeMeasurement({
    String id = 'test-id-1',
    FrequencyResponse? displayResponse,
  }) {
    return PickupMeasurement(
      id: id,
      timestamp: DateTime.utc(2026, 4, 17, 12),
      type: PickupType.humbuckerMediumOutput,
      pickupName: 'PAF Clone',
      dcr: 8200,
      ambientTempC: 22.0,
      resonantFrequency: 4780.0,
      qFactor: 3.2,
      peakAmplitudeDb: -18.5,
      dcrCorrected: 8050.0,
      inductance: 4.2e-3,
      capacitance: 280e-12,
      calibrationApplied: true,
      response: displayResponse ?? _makeResponse(1000),
    );
  }

  // ── save → getById (display-resolution round trip) ───────────────────────

  group('save → getById', () {
    test('returns all scalar fields unchanged', () async {
      final m = _makeMeasurement();
      final storage = _makeResponse(60);
      await repo.save(m, storageResponse: storage);

      final loaded = await repo.getById('test-id-1');
      expect(loaded, isNotNull);
      expect(loaded!.id, equals(m.id));
      expect(loaded.pickupName, equals('PAF Clone'));
      expect(loaded.type, equals(PickupType.humbuckerMediumOutput));
      expect(loaded.dcr, closeTo(8200, 0.001));
      expect(loaded.ambientTempC, closeTo(22.0, 0.001));
      expect(loaded.resonantFrequency, closeTo(4780.0, 0.001));
      expect(loaded.qFactor, closeTo(3.2, 0.001));
      expect(loaded.peakAmplitudeDb, closeTo(-18.5, 0.001));
      expect(loaded.dcrCorrected, closeTo(8050.0, 0.1));
      expect(loaded.inductance, closeTo(4.2e-3, 1e-6));
      expect(loaded.capacitance, closeTo(280e-12, 1e-15));
      expect(loaded.calibrationApplied, isTrue);
      expect(loaded.timestamp, equals(m.timestamp));
    });

    test('returns display-resolution response (~1000 points)', () async {
      final display = _makeResponse(1000);
      final m = _makeMeasurement(displayResponse: display);
      await repo.save(m, storageResponse: _makeResponse(60));

      final loaded = await repo.getById('test-id-1');
      // H-02: display response preserves all points
      expect(loaded!.response.points.length, equals(1000));
    });

    test('nullable fields survive null round trip', () async {
      final m = PickupMeasurement(
        id: 'null-fields',
        timestamp: DateTime.utc(2026, 4, 17),
        type: PickupType.unknown,
        pickupName: 'Test',
        dcr: 5000,
        ambientTempC: 20,
        resonantFrequency: 3000,
        qFactor: 2,
        peakAmplitudeDb: -30,
        calibrationApplied: false,
        response: _makeResponse(10),
      );
      await repo.save(m, storageResponse: _makeResponse(10));

      final loaded = await repo.getById('null-fields');
      expect(loaded!.dcrCorrected, isNull);
      expect(loaded.inductance, isNull);
      expect(loaded.capacitance, isNull);
    });

    test('returns null for unknown id', () async {
      final result = await repo.getById('does-not-exist');
      expect(result, isNull);
    });
  });

  // ── save → getAll (storage-resolution) ──────────────────────────────────

  group('save → getAll', () {
    test('returns storage-resolution response (≤60 points)', () async {
      final m = _makeMeasurement(displayResponse: _makeResponse(1000));
      await repo.save(m, storageResponse: _makeResponse(60));

      final all = await repo.getAll();
      expect(all.length, equals(1));
      // H-02: list views get the compact response
      expect(all.first.response.points.length, lessThanOrEqualTo(60));
    });

    test('orders newest first', () async {
      await repo.save(
        _makeMeasurement(id: 'old'),
        storageResponse: _makeResponse(60),
      );
      final newer = _makeMeasurement(id: 'new');
      // Give it a later timestamp by overwriting via upsert with same id approach
      // (simplest: just save two different ids with different timestamps)
      final m2 = PickupMeasurement(
        id: 'new',
        timestamp: DateTime.utc(2026, 4, 18), // one day later
        type: PickupType.singleCoilStrat,
        pickupName: 'Strat',
        dcr: 6000,
        ambientTempC: 20,
        resonantFrequency: 6000,
        qFactor: 2.5,
        peakAmplitudeDb: -20,
        calibrationApplied: false,
        response: _makeResponse(1000),
      );
      await repo.save(m2, storageResponse: _makeResponse(60));
      // Overwrite old with older timestamp
      await repo.save(
        _makeMeasurement(id: 'old'),
        storageResponse: _makeResponse(60),
      );

      final all = await repo.getAll();
      expect(all.first.id, equals('new'));
    });
  });

  // ── delete ───────────────────────────────────────────────────────────────

  test('delete removes the record', () async {
    await repo.save(_makeMeasurement(), storageResponse: _makeResponse(60));
    await repo.delete('test-id-1');

    final all = await repo.getAll();
    expect(all, isEmpty);
    expect(await repo.getById('test-id-1'), isNull);
  });

  // ── upsert ───────────────────────────────────────────────────────────────

  test('save twice with same id overwrites', () async {
    await repo.save(_makeMeasurement(), storageResponse: _makeResponse(60));
    final updated = PickupMeasurement(
      id: 'test-id-1',
      timestamp: DateTime.utc(2026, 4, 17),
      type: PickupType.p90,
      pickupName: 'P90 Bridge',
      dcr: 9000,
      ambientTempC: 20,
      resonantFrequency: 5200,
      qFactor: 2.8,
      peakAmplitudeDb: -16,
      calibrationApplied: false,
      response: _makeResponse(1000),
    );
    await repo.save(updated, storageResponse: _makeResponse(60));

    final all = await repo.getAll();
    expect(all.length, equals(1));
    expect(all.first.pickupName, equals('P90 Bridge'));
  });
}
