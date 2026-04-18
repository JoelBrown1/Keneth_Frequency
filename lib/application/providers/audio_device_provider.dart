import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructure/audio/audio_device_info.dart';
import '../session/session_notifier.dart';

part 'audio_device_provider.g.dart';

/// Fetches the list of CoreAudio devices visible to the OS.
///
/// Re-fetched on every call to `ref.invalidate(audioDevicesProvider)`,
/// e.g. when the user opens the device picker or reconnects hardware.
@riverpod
Future<List<AudioDeviceInfo>> audioDevices(AudioDevicesRef ref) =>
    ref.read(audioServiceProvider).getDevices();
