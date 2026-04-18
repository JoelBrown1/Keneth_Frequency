import FlutterMacOS
import Foundation

/// Bridges the Dart audio service to [CoreAudioSession] via a MethodChannel.
///
/// Uses [FlutterStandardMethodCodec] (the default) so that:
/// - Sprint 3a: Maps and primitive types pass through with no manual encoding.
/// - Sprint 3b: Raw PCM is transferred as [FlutterStandardTypedData(float32:)]
///   without Base64 overhead (issue C-02).
///
/// Method names and payload shapes
/// ─────────────────────────────────────────────────────────────────────────
/// getDevices   → no args  → [[String: Any]]  (array of device dicts)
/// openSession  → ["deviceId": String, "sampleRate": Double]
///              → true | false | String (error message)
/// closeSession → no args  → nil
/// ─────────────────────────────────────────────────────────────────────────
class AudioChannel {
  static let channelName = "keneth_frequency/audio"
  static let levelChannelName = "keneth_frequency/level"

  private let methodChannel: FlutterMethodChannel
  private let session = CoreAudioSession()

  init(messenger: FlutterBinaryMessenger) {
    // Default codec = FlutterStandardMethodCodec — no explicit argument needed.
    methodChannel = FlutterMethodChannel(
      name: AudioChannel.channelName,
      binaryMessenger: messenger
    )
    methodChannel.setMethodCallHandler(handle)

    // EventChannel for live RMS (Sprint 3b) — registered now, handler set in 3b.
    _ = FlutterEventChannel(
      name: AudioChannel.levelChannelName,
      binaryMessenger: messenger
    )
  }

  // MARK: - Method handler

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getDevices":
      result(session.listDevices())
    case "openSession":
      handleOpenSession(call: call, result: result)
    case "closeSession":
      session.close()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Handler implementations

  private func handleOpenSession(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let deviceId = args["deviceId"] as? String,
          let sampleRate = args["sampleRate"] as? Double else {
      result(FlutterError(code: "INVALID_ARGS",
                          message: "openSession requires deviceId (String) and sampleRate (Double)",
                          details: nil))
      return
    }

    let openResult = session.open(deviceId: deviceId, sampleRate: sampleRate)
    // CoreAudioSession.open() returns: true | false | String
    result(openResult)
  }
}
