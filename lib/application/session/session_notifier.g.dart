// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioServiceHash() => r'185035d5e6aebdfbfae6028642b70c0b0c540ad9';

/// Provides the singleton [AudioServiceInterface] used by [SessionNotifier].
///
/// Override in tests to inject a fake audio service.
///
/// Copied from [audioService].
@ProviderFor(audioService)
final audioServiceProvider = Provider<AudioServiceInterface>.internal(
  audioService,
  name: r'audioServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$audioServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AudioServiceRef = ProviderRef<AudioServiceInterface>;
String _$sessionNotifierHash() => r'0a6b005caacfa3ab16d1e80927e4ff426efb107e';

/// Manages the measurement session FSM.
///
/// Internal accumulators carry data across states so that state classes
/// remain minimal (matching the arch doc sealed hierarchy).
///
/// Copied from [SessionNotifier].
@ProviderFor(SessionNotifier)
final sessionNotifierProvider =
    NotifierProvider<SessionNotifier, SessionState>.internal(
  SessionNotifier.new,
  name: r'sessionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SessionNotifier = Notifier<SessionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
