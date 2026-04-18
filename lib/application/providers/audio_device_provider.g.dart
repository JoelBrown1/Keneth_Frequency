// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_device_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioDevicesHash() => r'af9e210cf2ae44beef820ace32931d68fa15e57d';

/// Fetches the list of CoreAudio devices visible to the OS.
///
/// Re-fetched on every call to `ref.invalidate(audioDevicesProvider)`,
/// e.g. when the user opens the device picker or reconnects hardware.
///
/// Copied from [audioDevices].
@ProviderFor(audioDevices)
final audioDevicesProvider =
    AutoDisposeFutureProvider<List<AudioDeviceInfo>>.internal(
  audioDevices,
  name: r'audioDevicesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$audioDevicesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AudioDevicesRef = AutoDisposeFutureProviderRef<List<AudioDeviceInfo>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
