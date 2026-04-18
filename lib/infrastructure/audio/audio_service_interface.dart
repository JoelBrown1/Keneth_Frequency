import 'dart:typed_data';

import 'audio_device_info.dart';

/// Contract for the macOS audio service.
///
/// All methods are asynchronous — the MethodChannel round-trip is non-blocking.
abstract class AudioServiceInterface {
  /// Returns all CoreAudio devices currently visible to the OS.
  Future<List<AudioDeviceInfo>> getDevices();

  /// Opens an [AVAudioEngine] session on [deviceId] at [sampleRate] Hz.
  ///
  /// Returns:
  /// - `true`   — session opened successfully.
  /// - `false`  — device not found (disconnected between discovery and open).
  /// - `String` — device is at the wrong sample rate; display this string
  ///              to the user (e.g. "Set it to 48000 Hz in Focusrite Control").
  Future<dynamic> openSession(String deviceId, double sampleRate);

  /// Stops the engine and releases all audio resources.
  Future<void> closeSession();

  /// Plays the log-chirp sweep on output channel 0 and simultaneously records
  /// from input channel 0. Returns the captured PCM as a [Float32List].
  ///
  /// Declared here for completeness; implemented in Sprint 3b.
  Future<Float32List> playSweepAndRecord(
    Float32List sweepSamples,
    int outputChannel,
    int inputChannel,
  );
}
