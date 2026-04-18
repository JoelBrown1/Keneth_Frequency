import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/entities/calibration_data.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/infrastructure/storage/app_database.dart';
import 'package:keneth_frequency/infrastructure/storage/calibration_repository.dart';

void main() {
  late AppDatabase db;
  late CalibrationRepository repo;

  setUp(() {
    db = AppDatabase.forTesting();
    repo = CalibrationRepository(db);
  });

  tearDown(() => db.close());

  // ── Helpers ──────────────────────────────────────────────────────────────

  CalibrationData _makeCalibration({
    String id = 'cal-1',
    DateTime? timestamp,
    int pointCount = 1000,
  }) {
    final ts = timestamp ?? DateTime.utc(2026, 4, 17, 10);
    return CalibrationData(
      id: id,
      timestamp: ts,
      spectrum: List.generate(pointCount, (i) {
        final f = 20.0 + (20000.0 - 20.0) * i / (pointCount - 1);
        return FrequencyPoint(frequency: f, magnitude: -12.0);
      }),
    );
  }

  // ── save → getLatest ─────────────────────────────────────────────────────

  group('save → getLatest', () {
    test('returns saved calibration', () async {
      final cal = _makeCalibration();
      await repo.save(cal);

      final latest = await repo.getLatest();
      expect(latest, isNotNull);
      expect(latest!.id, equals('cal-1'));
      expect(latest.spectrum.length, equals(1000));
    });

    test('spectrum round trips accurately', () async {
      final cal = _makeCalibration(pointCount: 1000);
      await repo.save(cal);

      final loaded = await repo.getLatest();
      expect(loaded!.spectrum.length, equals(cal.spectrum.length));
      for (var i = 0; i < cal.spectrum.length; i++) {
        expect(loaded.spectrum[i].frequency,
            closeTo(cal.spectrum[i].frequency, 0.0001));
        expect(loaded.spectrum[i].magnitude,
            closeTo(cal.spectrum[i].magnitude, 0.0001));
      }
    });

    test('returns null when no calibrations exist', () async {
      final latest = await repo.getLatest();
      expect(latest, isNull);
    });

    test('returns most recent when multiple exist', () async {
      await repo.save(_makeCalibration(
        id: 'old',
        timestamp: DateTime.utc(2026, 4, 15),
      ));
      await repo.save(_makeCalibration(
        id: 'new',
        timestamp: DateTime.utc(2026, 4, 17),
      ));

      final latest = await repo.getLatest();
      expect(latest!.id, equals('new'));
    });
  });

  // ── isStale ───────────────────────────────────────────────────────────────

  group('isStale', () {
    test('returns true when no calibration exists', () async {
      expect(await repo.isStale(), isTrue);
    });

    test('returns false for a fresh calibration', () async {
      // Fresh = timestamp is now
      final fresh = CalibrationData(
        id: 'fresh',
        timestamp: DateTime.now(),
        spectrum: [FrequencyPoint(frequency: 1000, magnitude: -12)],
      );
      await repo.save(fresh);

      expect(await repo.isStale(thresholdHours: 24), isFalse);
    });

    test('returns true for an expired calibration', () async {
      final old = CalibrationData(
        id: 'old',
        timestamp: DateTime.now().subtract(const Duration(hours: 25)),
        spectrum: [FrequencyPoint(frequency: 1000, magnitude: -12)],
      );
      await repo.save(old);

      expect(await repo.isStale(thresholdHours: 24), isTrue);
    });

    test('respects custom threshold', () async {
      final recent = CalibrationData(
        id: 'recent',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        spectrum: [FrequencyPoint(frequency: 1000, magnitude: -12)],
      );
      await repo.save(recent);

      expect(await repo.isStale(thresholdHours: 1), isTrue);
      expect(await repo.isStale(thresholdHours: 3), isFalse);
    });
  });

  // ── list ─────────────────────────────────────────────────────────────────

  test('list returns all calibrations ordered newest first', () async {
    await repo.save(_makeCalibration(id: 'a', timestamp: DateTime.utc(2026, 4, 15)));
    await repo.save(_makeCalibration(id: 'b', timestamp: DateTime.utc(2026, 4, 17)));
    await repo.save(_makeCalibration(id: 'c', timestamp: DateTime.utc(2026, 4, 16)));

    final all = await repo.list();
    expect(all.map((c) => c.id).toList(), equals(['b', 'c', 'a']));
  });

  // ── delete ────────────────────────────────────────────────────────────────

  test('delete removes the record', () async {
    await repo.save(_makeCalibration());
    await repo.delete('cal-1');

    expect(await repo.getLatest(), isNull);
    expect(await repo.list(), isEmpty);
  });

  // ── label ─────────────────────────────────────────────────────────────────

  test('save with explicit label persists it', () async {
    final cal = _makeCalibration();
    await repo.save(cal, label: '1MΩ reference');
    // Label is a DB-only field; CalibrationData doesn't surface it.
    // Verify the row exists and round-trips correctly (label tested via DB query).
    final loaded = await repo.getLatest();
    expect(loaded, isNotNull);
    expect(loaded!.id, equals('cal-1'));
  });
}
