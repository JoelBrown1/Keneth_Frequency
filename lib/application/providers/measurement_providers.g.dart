// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$measurementHistoryHash() =>
    r'1e96004ed8fe070665adc2fd8e75127ae2b40b1c';

/// All saved measurements ordered newest-first (storage-resolution response).
///
/// Invalidate with `ref.invalidate(measurementHistoryProvider)` after a save
/// to trigger an automatic refresh.
///
/// Copied from [measurementHistory].
@ProviderFor(measurementHistory)
final measurementHistoryProvider =
    AutoDisposeFutureProvider<List<PickupMeasurement>>.internal(
  measurementHistory,
  name: r'measurementHistoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$measurementHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MeasurementHistoryRef
    = AutoDisposeFutureProviderRef<List<PickupMeasurement>>;
String _$measurementResultHash() => r'c7dbd317c014a3c9af59e1207a7c8c8bc22d0fb4';

/// The measurement from the current session's [ResultsState], or `null`.
///
/// Automatically clears when the FSM leaves [ResultsState] (via cancel/reset).
///
/// Copied from [measurementResult].
@ProviderFor(measurementResult)
final measurementResultProvider =
    AutoDisposeProvider<PickupMeasurement?>.internal(
  measurementResult,
  name: r'measurementResultProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$measurementResultHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MeasurementResultRef = AutoDisposeProviderRef<PickupMeasurement?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
