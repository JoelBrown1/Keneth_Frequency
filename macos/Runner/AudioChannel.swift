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
/// getDevices        → no args
///                  → [[String: Any]]
/// openSession       → ["deviceId": String, "sampleRate": Double]
///                  → true | false | String (error message)
/// closeSession      → no args → nil
/// playSweepAndRecord → ["sweep": Float32TypedData, "outputChannel": Int,
///                       "inputChannel": Int]
///                  → Float32TypedData (recorded samples)
///
/// EventChannel "keneth_frequency/level" streams Double RMS values
/// once per 4096-sample tap buffer during an active playSweepAndRecord call.
/// ─────────────────────────────────────────────────────────────────────────
class AudioChannel {
  static let channelName = "keneth_frequency/audio"
  static let levelChannelName = "keneth_frequency/level"

  private let methodChannel: FlutterMethodChannel
  private let levelEventChannel: FlutterEventChannel
  private let levelHandler = LevelStreamHandler()
  private let session = CoreAudioSession()

  init(messenger: FlutterBinaryMessenger) {
    methodChannel = FlutterMethodChannel(
      name: AudioChannel.channelName,
      binaryMessenger: messenger
    )

    levelEventChannel = FlutterEventChannel(
      name: AudioChannel.levelChannelName,
      binaryMessenger: messenger
    )
    levelEventChannel.setStreamHandler(levelHandler)

    methodChannel.setMethodCallHandler(handle)
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
    case "playSweepAndRecord":
      handlePlaySweepAndRecord(call: call, result: result)
    case "startMonitoring":
      handleStartMonitoring(result: result)
    case "stopMonitoring":
      session.stopMonitoring()
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
    result(session.open(deviceId: deviceId, sampleRate: sampleRate))
  }

  private func handleStartMonitoring(result: @escaping FlutterResult) {
    print("[KF] handleStartMonitoring: engine=\(session.engine != nil), isMonitoring=\(session.isMonitoring), sink=\(levelHandler.sink != nil)")
    do {
      try session.startMonitoring(onRms: { [weak self] rms in
        DispatchQueue.main.async {
          guard let self = self else { return }
          if self.levelHandler.sink == nil {
            print("[KF] tap fired but sink is nil — EventChannel not subscribed yet")
          }
          self.levelHandler.sink?(rms)
        }
      })
      print("[KF] handleStartMonitoring: succeeded")
      result(nil)
    } catch {
      print("[KF] handleStartMonitoring: FAILED — \(error)")
      result(FlutterError(code: "AUDIO_ERROR",
                          message: error.localizedDescription,
                          details: nil))
    }
  }

  private func handlePlaySweepAndRecord(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let sweepData = args["sweep"] as? FlutterStandardTypedData,
          let outCh = args["outputChannel"] as? Int,
          let inCh  = args["inputChannel"]  as? Int else {
      result(FlutterError(code: "INVALID_ARGS",
                          message: "playSweepAndRecord requires sweep (Float32 typed data), outputChannel and inputChannel",
                          details: nil))
      return
    }

    // Reinterpret the raw bytes as Float32.
    let sweepFloats: [Float] = sweepData.data.withUnsafeBytes { ptr in
      Array(ptr.bindMemory(to: Float.self))
    }

    Task { [weak self] in
      do {
        let recording = try await session.playSweepAndRecord(
          sweepSamples: sweepFloats,
          outputChannel: outCh,
          inputChannel: inCh,
          onRms: { rms in DispatchQueue.main.async { self?.levelHandler.sink?(rms) } }
        )
        // Encode [Float] → Data → FlutterStandardTypedData(float32:)
        let data = recording.withUnsafeBufferPointer { ptr in
          Data(buffer: ptr)
        }
        result(FlutterStandardTypedData(float32: data))
      } catch {
        result(FlutterError(code: "AUDIO_ERROR",
                            message: error.localizedDescription,
                            details: nil))
      }
    }
  }
}

// MARK: - Level stream handler

/// Receives listen/cancel events from the Dart EventChannel and
/// exposes the current [FlutterEventSink] for the tap callback.
private class LevelStreamHandler: NSObject, FlutterStreamHandler {
  var sink: FlutterEventSink?

  func onListen(withArguments arguments: Any?,
                eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    print("[KF] LevelStreamHandler: onListen — sink is now set")
    sink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    print("[KF] LevelStreamHandler: onCancel — sink cleared")
    sink = nil
    return nil
  }
}
