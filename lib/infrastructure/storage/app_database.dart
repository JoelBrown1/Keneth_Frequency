import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

// ── Table definitions ────────────────────────────────────────────────────────

/// Stores completed pickup measurements.
///
/// Two JSON response columns implement the H-02 fix — never store raw FFT:
/// - [frequencyResponseDisplayJson]: ~1000 log-spaced points — loaded for chart
/// - [frequencyResponseStorageJson]: ~60 log-spaced points — loaded for list views
class Measurements extends Table {
  TextColumn get id => text()();
  IntColumn get timestampMs => integer()();
  TextColumn get pickupName => text()();
  TextColumn get pickupType => text()();
  RealColumn get dcr => real()();
  RealColumn get ambientTempC => real()();
  RealColumn get resonantFrequencyHz => real()();
  RealColumn get qFactor => real()();
  RealColumn get peakAmplitudeDb => real()();
  RealColumn get dcrCorrected => real().nullable()();
  RealColumn get inductance => real().nullable()();
  RealColumn get capacitance => real().nullable()();
  BoolColumn get calibrationApplied => boolean()();
  TextColumn get frequencyResponseDisplayJson => text()();
  TextColumn get frequencyResponseStorageJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Stores reference calibration sweeps used to flatten the measurement chain.
class Calibrations extends Table {
  TextColumn get id => text()();
  IntColumn get timestampMs => integer()();
  TextColumn get label => text()();
  TextColumn get spectrumJson => text()(); // display-resolution (~1000 pts)

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ─────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [Measurements, Calibrations])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;

  /// Production database backed by SQLite on disk.
  static Future<AppDatabase> open() async {
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/keneth_frequency.db');
    return AppDatabase(NativeDatabase(file));
  }

  /// In-memory database for unit tests — no file I/O.
  factory AppDatabase.forTesting() => AppDatabase(NativeDatabase.memory());
}
