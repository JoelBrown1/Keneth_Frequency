// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calibration_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$calibrationStatusHash() => r'b25432baaa4c1a4c69613d0491896e342474806d';

/// Fetches the latest calibration and its staleness status.
///
/// Invalidate with `ref.invalidate(calibrationStatusProvider)` after saving
/// a new calibration.
///
/// Copied from [calibrationStatus].
@ProviderFor(calibrationStatus)
final calibrationStatusProvider =
    AutoDisposeFutureProvider<CalibrationStatus>.internal(
  calibrationStatus,
  name: r'calibrationStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calibrationStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CalibrationStatusRef = AutoDisposeFutureProviderRef<CalibrationStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
