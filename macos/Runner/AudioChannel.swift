import FlutterMacOS
import Foundation

class AudioChannel {
  static func register(with registrar: FlutterPluginRegistrar) {
    // MethodChannel for device enumeration, session open/close, sweep+record
    // Configured with BinaryCodec for audio buffer transfer (Sprint 3a)
    let _ = FlutterMethodChannel(
      name: "keneth_frequency/audio",
      binaryMessenger: registrar.messenger,
      codec: FlutterBinaryCodec()
    )
    // EventChannel for live RMS level during recording (Sprint 3b)
    let _ = FlutterEventChannel(
      name: "keneth_frequency/level",
      binaryMessenger: registrar.messenger
    )
  }
}
