import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'audio_device_info.dart';
import 'audio_service_interface.dart';

/// Dart-side implementation of [AudioServiceInterface].
///
/// Communicates with the Swift [AudioChannel] over a [MethodChannel] using
/// the default [StandardMethodCodec]. Native Maps and primitives pass through
/// with no manual encoding for Sprint 3a. Sprint 3b will pass raw PCM as
/// [Uint8List] / [Float32List] — transferred as [FlutterStandardTypedData]
/// without Base64 overhead (issue C-02).
class MacosAudioService implements AudioServiceInterface {
  static const _channelName = 'keneth_frequency/audio';

  // StandardMethodCodec is the default — no explicit codec argument needed.
  final MethodChannel _channel;

  MacosAudioService() : _channel = const MethodChannel(_channelName);

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
  Future<dynamic> openSession(String deviceId, double sampleRate) async {
    return _channel.invokeMethod<dynamic>('openSession', {
      'deviceId': deviceId,
      'sampleRate': sampleRate,
    });
    // Swift returns: true (Bool) | false (Bool) | String (error message).
    // StandardMethodCodec preserves the type; callers check `result is bool`
    // vs `result is String`.
  }

  // ── closeSession ─────────────────────────────────────────────────────────────

  @override
  Future<void> closeSession() => _channel.invokeMethod<void>('closeSession');

  // ── playSweepAndRecord (Sprint 3b stub) ──────────────────────────────────────

  @override
  Future<Float32List> playSweepAndRecord(
    Float32List sweepSamples,
    int outputChannel,
    int inputChannel,
  ) {
    throw UnimplementedError('playSweepAndRecord is implemented in Sprint 3b');
  }
}
