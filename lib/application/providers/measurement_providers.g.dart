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
String _$measurementByIdHash() => r'86b6d44e167af64d83082621eb133b63460394c6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// A single measurement loaded by ID with **display-resolution** response
/// (~1000 pts), suitable for chart rendering.
///
/// Returns `null` when the ID is not found.
///
/// Copied from [measurementById].
@ProviderFor(measurementById)
const measurementByIdProvider = MeasurementByIdFamily();

/// A single measurement loaded by ID with **display-resolution** response
/// (~1000 pts), suitable for chart rendering.
///
/// Returns `null` when the ID is not found.
///
/// Copied from [measurementById].
class MeasurementByIdFamily extends Family<AsyncValue<PickupMeasurement?>> {
  /// A single measurement loaded by ID with **display-resolution** response
  /// (~1000 pts), suitable for chart rendering.
  ///
  /// Returns `null` when the ID is not found.
  ///
  /// Copied from [measurementById].
  const MeasurementByIdFamily();

  /// A single measurement loaded by ID with **display-resolution** response
  /// (~1000 pts), suitable for chart rendering.
  ///
  /// Returns `null` when the ID is not found.
  ///
  /// Copied from [measurementById].
  MeasurementByIdProvider call(
    String id,
  ) {
    return MeasurementByIdProvider(
      id,
    );
  }

  @override
  MeasurementByIdProvider getProviderOverride(
    covariant MeasurementByIdProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'measurementByIdProvider';
}

/// A single measurement loaded by ID with **display-resolution** response
/// (~1000 pts), suitable for chart rendering.
///
/// Returns `null` when the ID is not found.
///
/// Copied from [measurementById].
class MeasurementByIdProvider
    extends AutoDisposeFutureProvider<PickupMeasurement?> {
  /// A single measurement loaded by ID with **display-resolution** response
  /// (~1000 pts), suitable for chart rendering.
  ///
  /// Returns `null` when the ID is not found.
  ///
  /// Copied from [measurementById].
  MeasurementByIdProvider(
    String id,
  ) : this._internal(
          (ref) => measurementById(
            ref as MeasurementByIdRef,
            id,
          ),
          from: measurementByIdProvider,
          name: r'measurementByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$measurementByIdHash,
          dependencies: MeasurementByIdFamily._dependencies,
          allTransitiveDependencies:
              MeasurementByIdFamily._allTransitiveDependencies,
          id: id,
        );

  MeasurementByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<PickupMeasurement?> Function(MeasurementByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MeasurementByIdProvider._internal(
        (ref) => create(ref as MeasurementByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PickupMeasurement?> createElement() {
    return _MeasurementByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MeasurementByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MeasurementByIdRef on AutoDisposeFutureProviderRef<PickupMeasurement?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _MeasurementByIdProviderElement
    extends AutoDisposeFutureProviderElement<PickupMeasurement?>
    with MeasurementByIdRef {
  _MeasurementByIdProviderElement(super.provider);

  @override
  String get id => (origin as MeasurementByIdProvider).id;
}

String _$levelStreamHash() => r'a6f9b1f26152234708a0255b88f5c616eb17738b';

/// Streams live RMS amplitude values from the Swift input tap during a sweep.
///
/// Wraps [AudioServiceInterface.levelStream] as a Riverpod [StreamProvider].
/// Consumers receive [AsyncValue<double>] — data = current linear RMS (0–1).
///
/// Copied from [levelStream].
@ProviderFor(levelStream)
final levelStreamProvider = AutoDisposeStreamProvider<double>.internal(
  levelStream,
  name: r'levelStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$levelStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LevelStreamRef = AutoDisposeStreamProviderRef<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
