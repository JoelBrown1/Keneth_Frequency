import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/entities/frequency_point.dart';
import '../../domain/entities/frequency_response.dart';
import '../../domain/entities/pickup_measurement.dart';
import '../../domain/entities/pickup_type.dart';
import 'app_database.dart';

/// Persists and retrieves [PickupMeasurement] records.
///
/// Two [FrequencyResponse] resolutions are stored per measurement (H-02 fix):
/// - Display (~1000 pts) — returned by [getById], used for chart rendering.
/// - Storage (~60 pts)   — returned by [getAll], used for list views.
///
/// Raw FFT output is never written to SQLite.
class MeasurementRepository {
  MeasurementRepository(this._db);

  final AppDatabase _db;

  // ── Write ──────────────────────────────────────────────────────────────────

  /// Saves [measurement] to the database.
  ///
  /// [measurement.response] must be the display-resolution response (~1000 pts).
  /// [storageResponse] must be the storage-resolution response (~60 pts).
  Future<void> save(
    PickupMeasurement measurement, {
    required FrequencyResponse storageResponse,
  }) async {
    await _db.into(_db.measurements).insertOnConflictUpdate(
          MeasurementsCompanion(
            id: Value(measurement.id),
            timestampMs: Value(measurement.timestamp.millisecondsSinceEpoch),
            pickupName: Value(measurement.pickupName),
            pickupType: Value(measurement.type.name),
            dcr: Value(measurement.dcr),
            ambientTempC: Value(measurement.ambientTempC),
            resonantFrequencyHz: Value(measurement.resonantFrequency),
            qFactor: Value(measurement.qFactor),
            peakAmplitudeDb: Value(measurement.peakAmplitudeDb),
            dcrCorrected: Value(measurement.dcrCorrected),
            inductance: Value(measurement.inductance),
            capacitance: Value(measurement.capacitance),
            calibrationApplied: Value(measurement.calibrationApplied),
            frequencyResponseDisplayJson:
                Value(_encodePoints(measurement.response.points)),
            frequencyResponseStorageJson:
                Value(_encodePoints(storageResponse.points)),
          ),
        );
  }

  // ── Read ───────────────────────────────────────────────────────────────────

  /// Returns all measurements ordered newest-first, each with the
  /// storage-resolution [FrequencyResponse] (~60 pts).
  Future<List<PickupMeasurement>> getAll() async {
    final rows = await (_db.select(_db.measurements)
          ..orderBy([(t) => OrderingTerm.desc(t.timestampMs)]))
        .get();
    return rows.map((r) => _fromRow(r, useDisplayResponse: false)).toList();
  }

  /// Returns the measurement for [id] with the display-resolution
  /// [FrequencyResponse] (~1000 pts), or `null` if not found.
  Future<PickupMeasurement?> getById(String id) async {
    final row = await (_db.select(_db.measurements)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row, useDisplayResponse: true);
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<void> delete(String id) async {
    await (_db.delete(_db.measurements)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  // ── Mapping helpers ────────────────────────────────────────────────────────

  PickupMeasurement _fromRow(Measurement row, {required bool useDisplayResponse}) {
    final json = useDisplayResponse
        ? row.frequencyResponseDisplayJson
        : row.frequencyResponseStorageJson;
    return PickupMeasurement(
      id: row.id,
      timestamp: DateTime.fromMillisecondsSinceEpoch(row.timestampMs, isUtc: true),
      type: _parsePickupType(row.pickupType),
      pickupName: row.pickupName,
      dcr: row.dcr,
      ambientTempC: row.ambientTempC,
      resonantFrequency: row.resonantFrequencyHz,
      qFactor: row.qFactor,
      peakAmplitudeDb: row.peakAmplitudeDb,
      dcrCorrected: row.dcrCorrected,
      inductance: row.inductance,
      capacitance: row.capacitance,
      calibrationApplied: row.calibrationApplied,
      response: FrequencyResponse(_decodePoints(json)),
    );
  }

  PickupType _parsePickupType(String name) {
    return PickupType.values.firstWhere(
      (t) => t.name == name,
      orElse: () => PickupType.unknown,
    );
  }
}

// ── JSON helpers (shared with CalibrationRepository) ────────────────────────

/// Encodes [points] as a compact JSON array of [frequency, magnitude] pairs.
String encodeFrequencyPoints(List<FrequencyPoint> points) =>
    jsonEncode(points.map((p) => [p.frequency, p.magnitude]).toList());

/// Decodes a JSON array of [frequency, magnitude] pairs into [FrequencyPoint]s.
List<FrequencyPoint> decodeFrequencyPoints(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list.map((item) {
    final pair = item as List<dynamic>;
    return FrequencyPoint(
      frequency: (pair[0] as num).toDouble(),
      magnitude: (pair[1] as num).toDouble(),
    );
  }).toList();
}

// Private aliases for use within this file.
String _encodePoints(List<FrequencyPoint> points) =>
    encodeFrequencyPoints(points);
List<FrequencyPoint> _decodePoints(String json) =>
    decodeFrequencyPoints(json);
