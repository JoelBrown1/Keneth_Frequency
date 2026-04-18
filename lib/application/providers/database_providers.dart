import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructure/storage/app_database.dart';
import '../../infrastructure/storage/calibration_repository.dart';
import '../../infrastructure/storage/measurement_repository.dart';

part 'database_providers.g.dart';

/// Provides the [AppDatabase] instance.
///
/// Override in `main.dart` (after `await AppDatabase.open()`) and
/// in integration tests via `AppDatabase.forTesting()`.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) =>
    throw UnimplementedError('appDatabaseProvider must be overridden before use');

@Riverpod(keepAlive: true)
MeasurementRepository measurementRepository(MeasurementRepositoryRef ref) =>
    MeasurementRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
CalibrationRepository calibrationRepository(CalibrationRepositoryRef ref) =>
    CalibrationRepository(ref.watch(appDatabaseProvider));
