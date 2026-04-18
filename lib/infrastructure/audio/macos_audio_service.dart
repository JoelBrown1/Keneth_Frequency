import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'audio_device_info.dart';
import 'audio_service_interface.dart';

/// Dart-side implementation of [AudioServiceInterface].
///
/// Communicates with the Swift [AudioChannel] over a [MethodChannel] using
/// the default [StandardMethodCodec]. Native Maps and primitives pass through
/// with no manual encoding for Sprint 3a methods.
///
/// Sprint 3b (sweep + record): [Float32List] is transferred as
/// [FlutterStandardTypedData(float32:)] — raw bytes, no Base64 (issue C-02).
class MacosAudioService implements AudioServiceInterface {
  static const _channelName = 'keneth_frequency/audio';
  static const _levelChannelName = 'keneth_frequency/level';

  final MethodChannel _channel;
  final EventChannel _levelChannel;

  MacosAudioService()
      : _channel = const MethodChannel(_channelName),
        _levelChannel = const EventChannel(_levelChannelName);

  // ── getDevices ──────────────────────────────────────────────────────────────

  @override
  Future<List<AudioDeviceInfo>> getDevices() async {
    final result = await _channel.invokeListMethod<Map<Object?, Object?>>('getDevices');
    return (result ?? [])
        .map((m) => AudioDeviceInfo.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  // ── openSession ─────────────────────────────────────────────────────────────

  @override
  Future<dynamic> openSession(String deviceId, double sampleRate) {
    return _channel.invokeMethod<dynamic>('openSession', {
      'deviceId': deviceId,
      'sampleRate': sampleRate,
    });
    // Swift returns: true (Bool) | false (Bool) | String (error message).
    // StandardMethodCodec preserves the runtime type.
  }

  // ── closeSession ─────────────────────────────────────────────────────────────

  @override
  Future<void> closeSession() => _channel.invokeMethod<void>('closeSession');

  // ── playSweepAndRecord ───────────────────────────────────────────────────────

  @override
  Future<Float32List> playSweepAndRecord(
    Float32List sweepSamples,
    int outputChannel,
    int inputChannel,
  ) async {
    // Float32List is encoded by StandardMethodCodec as FlutterStandardTypedData
    // (float32) — raw bytes, no Base64 (issue C-02).
    final result = await _channel.invokeMethod<dynamic>('playSweepAndRecord', {
      'sweep': sweepSamples,
      'outputChannel': outputChannel,
      'inputChannel': inputChannel,
    });
    // Swift returns FlutterStandardTypedData(float32:) → Dart receives Float32List.
    return result as Float32List;
  }

  // ── levelStream ──────────────────────────────────────────────────────────────

  @override
  Stream<double> get levelStream {
    return _levelChannel
        .receiveBroadcastStream()
        .map((event) => (event as num).toDouble());
  }
}
