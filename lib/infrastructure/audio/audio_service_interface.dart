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

  /// Plays the log-chirp sweep on [outputChannel] and simultaneously records
  /// from [inputChannel]. Returns the captured PCM as a [Float32List].
  ///
  /// The sweep is transferred as raw Float32 bytes — no Base64 encoding (C-02).
  Future<Float32List> playSweepAndRecord(
    Float32List sweepSamples,
    int outputChannel,
    int inputChannel,
  );

  /// Installs a continuous input tap on the open session and starts streaming
  /// RMS values via [levelStream]. Call after [openSession] succeeds.
  ///
  /// No-op if monitoring is already active. Throws if no session is open.
  Future<void> startMonitoring();

  /// Removes the continuous input tap installed by [startMonitoring].
  ///
  /// Must be called before [playSweepAndRecord] (which installs its own tap).
  Future<void> stopMonitoring();

  /// Broadcasts the linear RMS amplitude (0–1) once per 4096-sample tap buffer.
  /// Active during [startMonitoring] and during [playSweepAndRecord].
  ///
  /// Wraps the `keneth_frequency/level` EventChannel.
  Stream<double> get levelStream;
}
