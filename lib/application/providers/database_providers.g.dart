// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'2b7ec1a992b5d29e6af3ea88f2fe179dcb7b3e20';

/// Provides the [AppDatabase] instance.
///
/// Override in `main.dart` (after `await AppDatabase.open()`) and
/// in integration tests via `AppDatabase.forTesting()`.
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$measurementRepositoryHash() =>
    r'2a6837cdacbc5daf955a7ea05c31fbfe35ee4c86';

/// See also [measurementRepository].
@ProviderFor(measurementRepository)
final measurementRepositoryProvider = Provider<MeasurementRepository>.internal(
  measurementRepository,
  name: r'measurementRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$measurementRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MeasurementRepositoryRef = ProviderRef<MeasurementRepository>;
String _$calibrationRepositoryHash() =>
    r'c3bd7b2e9d0046a0059a5354fee3a6fe6d68b9f3';

/// See also [calibrationRepository].
@ProviderFor(calibrationRepository)
final calibrationRepositoryProvider = Provider<CalibrationRepository>.internal(
  calibrationRepository,
  name: r'calibrationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calibrationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CalibrationRepositoryRef = ProviderRef<CalibrationRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
