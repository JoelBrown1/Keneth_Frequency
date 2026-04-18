import AVFoundation
import CoreAudio
import Foundation

class CoreAudioSession {
  private(set) var engine: AVAudioEngine?

  // MARK: - Device enumeration

  /// Returns metadata for every CoreAudio device currently present.
  ///
  /// Each dictionary has keys: id, name, inputChannels, outputChannels,
  /// nominalSampleRate, isScarlett.
  func listDevices() -> [[String: Any]] {
    return ScarlettDeviceDetector.allDeviceIDs().compactMap { deviceID in
      guard let uid  = ScarlettDeviceDetector.uid(for: deviceID),
            let name = ScarlettDeviceDetector.name(for: deviceID) else { return nil }

      let rate = ScarlettDeviceDetector.nominalSampleRate(for: deviceID) ?? 0
      let inCh = ScarlettDeviceDetector.channelCount(
        for: deviceID, scope: kAudioObjectPropertyScopeInput)
      let outCh = ScarlettDeviceDetector.channelCount(
        for: deviceID, scope: kAudioObjectPropertyScopeOutput)
      let isScarlett = ScarlettDeviceDetector.isScarlettUID(uid)
                    || ScarlettDeviceDetector.isScarlettName(name)

      return [
        "id": uid,
        "name": name,
        "inputChannels": inCh,
        "outputChannels": outCh,
        "nominalSampleRate": rate,
        "isScarlett": isScarlett,
      ]
    }
  }

  // MARK: - Session open / close

  /// Opens an AVAudioEngine session on the device identified by [deviceId].
  ///
  /// Returns:
  /// - `true`   — session opened successfully.
  /// - `false`  — device UID not found (device disconnected between discovery and open).
  /// - `String` — descriptive error when the device's sample rate does not match
  ///              [sampleRate]. Display this string directly to the user.
  ///
  /// Channel mapping (verified in S0-12/S0-13 spike, 2026-04-16):
  ///   outputNode bus 0 → Scarlett Output 1 (left)
  ///   inputNode  bus 0 → Scarlett Input 1 (Hi-Z)
  func open(deviceId: String, sampleRate: Double) -> Any {
    // 1. Find the device by UID.
    guard let deviceID = findDevice(uid: deviceId) else { return false }

    // 2. Check the device's current sample rate.
    guard let nominalRate = ScarlettDeviceDetector.nominalSampleRate(for: deviceID) else {
      return false
    }
    if abs(nominalRate - sampleRate) > 1.0 {
      let devHz = Int(nominalRate.rounded())
      let reqHz = Int(sampleRate.rounded())
      return "Scarlett 2i2 is set to \(devHz) Hz. Set it to \(reqHz) Hz in Focusrite Control and retry."
    }

    // 3. Set the Scarlett as the system default I/O device so AVAudioEngine picks it up.
    ScarlettDeviceDetector.setDefault(deviceID, isOutput: true)
    ScarlettDeviceDetector.setDefault(deviceID, isOutput: false)

    // 4. Create the engine — it adopts the default device at init time.
    let newEngine = AVAudioEngine()
    engine = newEngine

    // 5. Verify the engine adopted the correct sample rate.
    let engineRate = newEngine.outputNode.outputFormat(forBus: 0).sampleRate
    if engineRate > 0 && abs(engineRate - sampleRate) > 1.0 {
      let devHz = Int(engineRate.rounded())
      let reqHz = Int(sampleRate.rounded())
      engine = nil
      return "Scarlett 2i2 is set to \(devHz) Hz. Set it to \(reqHz) Hz in Focusrite Control and retry."
    }

    return true
  }

  func close() {
    if let eng = engine {
      if eng.isRunning {
        // Safely remove any outstanding taps before stopping.
        try? eng.inputNode.removeTap(onBus: 0)
        eng.stop()
      }
    }
    engine = nil
  }

  // MARK: - Private helpers

  private func findDevice(uid: String) -> AudioDeviceID? {
    for deviceID in ScarlettDeviceDetector.allDeviceIDs() {
      if ScarlettDeviceDetector.uid(for: deviceID) == uid { return deviceID }
    }
    return nil
  }
}
