// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'1f7532a7537e7bcf0cbb5c638f9996f63d66057e';

/// Provides the [SharedPreferences] instance.
///
/// Override in `main.dart` (after `await SharedPreferences.getInstance()`)
/// and in tests via `SharedPreferences.setMockInitialValues({})`.
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = Provider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPreferencesRef = ProviderRef<SharedPreferences>;
String _$settingsNotifierHash() => r'579c7df432152972a86994ccae51e0674abd4f64';

/// Persists and exposes [AppSettings].
///
/// Reads all values from [SharedPreferences] on construction; each setter
/// writes the updated field immediately.
///
/// Copied from [SettingsNotifier].
@ProviderFor(SettingsNotifier)
final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, AppSettings>.internal(
  SettingsNotifier.new,
  name: r'settingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsNotifier = Notifier<AppSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
