import 'package:drift/drift.dart';

import '../../domain/entities/calibration_data.dart';
import '../../domain/entities/frequency_response.dart';
import 'app_database.dart';
import 'measurement_repository.dart' show encodeFrequencyPoints, decodeFrequencyPoints;

/// Persists and retrieves [CalibrationData] records.
///
/// The spectrum is stored at display resolution (~1000 log-spaced points) so
/// it can be used directly for calibration subtraction without re-interpolating.
class CalibrationRepository {
  CalibrationRepository(this._db);

  final AppDatabase _db;

  // ── Write ──────────────────────────────────────────────────────────────────

  /// Saves [data] to the database.
  ///
  /// [label] is an optional human-readable description displayed in the UI
  /// (e.g. "1MΩ reference, 2026-04-17"). Defaults to the ISO timestamp.
  Future<void> save(CalibrationData data, {String? label}) async {
    final effectiveLabel = label ?? data.timestamp.toIso8601String();
    await _db.into(_db.calibrations).insertOnConflictUpdate(
          CalibrationsCompanion(
            id: Value(data.id),
            timestampMs: Value(data.timestamp.millisecondsSinceEpoch),
            label: Value(effectiveLabel),
            spectrumJson: Value(encodeFrequencyPoints(data.spectrum)),
          ),
        );
  }

  // ── Read ───────────────────────────────────────────────────────────────────

  /// Returns the most recently saved [CalibrationData], or `null` if none exist.
  Future<CalibrationData?> getLatest() async {
    final row = await (_db.select(_db.calibrations)
          ..orderBy([(t) => OrderingTerm.desc(t.timestampMs)])
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  /// Returns `true` if no calibration exists or the latest is older than
  /// [thresholdHours] (default 24 hours).
  Future<bool> isStale({int thresholdHours = 24}) async {
    final latest = await getLatest();
    if (latest == null) return true;
    final age = DateTime.now().difference(latest.timestamp);
    return age.inHours >= thresholdHours;
  }

  /// Returns all calibrations ordered newest-first.
  Future<List<CalibrationData>> list() async {
    final rows = await (_db.select(_db.calibrations)
          ..orderBy([(t) => OrderingTerm.desc(t.timestampMs)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<void> delete(String id) async {
    await (_db.delete(_db.calibrations)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  // ── Mapping helpers ────────────────────────────────────────────────────────

  CalibrationData _fromRow(Calibration row) {
    return CalibrationData(
      id: row.id,
      timestamp: DateTime.fromMillisecondsSinceEpoch(row.timestampMs, isUtc: true),
      spectrum: decodeFrequencyPoints(row.spectrumJson),
    );
  }

  /// Convenience: returns the latest calibration as a [FrequencyResponse],
  /// suitable for passing to [DspPipelineInput.calibration].
  Future<CalibrationData?> getLatestForDsp() => getLatest();
}
