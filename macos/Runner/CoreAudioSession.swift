import AVFoundation
import CoreAudio
import Foundation

enum AudioError: Error {
  case noSession
  case bufferAllocationFailed
  case engineStart(Error)
}

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
        try? eng.inputNode.removeTap(onBus: 0)
        eng.stop()
      }
    }
    engine = nil
  }

  // MARK: - Sweep and record

  /// Plays [sweepSamples] on outputNode bus 0 while simultaneously recording
  /// inputNode bus 0. Returns all captured input samples as a `[Float]` array.
  ///
  /// - Parameters:
  ///   - sweepSamples: The log-chirp PCM to play (Float32, mono, at the session sample rate).
  ///   - outputChannel: Reserved for future multi-channel routing (currently ignored; always bus 0).
  ///   - inputChannel:  Reserved for future multi-channel routing (currently ignored; always bus 0).
  ///   - onRms: Called once per 4096-sample tap buffer with the linear RMS value.
  ///            Used by [AudioChannel] to stream live level meter values.
  func playSweepAndRecord(
    sweepSamples: [Float],
    outputChannel: Int,
    inputChannel: Int,
    onRms: ((Double) -> Void)? = nil
  ) async throws -> [Float] {
    guard let eng = engine else { throw AudioError.noSession }

    let sampleRate = eng.outputNode.outputFormat(forBus: 0).sampleRate
    guard sampleRate > 0 else { throw AudioError.noSession }

    // Mono float32 format at the hardware sample rate.
    guard let monoFormat = AVAudioFormat(
      commonFormat: .pcmFormatFloat32,
      sampleRate: sampleRate,
      channels: 1,
      interleaved: false
    ) else { throw AudioError.bufferAllocationFailed }

    // Build sweep PCM buffer.
    let frameCount = AVAudioFrameCount(sweepSamples.count)
    guard let sweepBuffer = AVAudioPCMBuffer(pcmFormat: monoFormat, frameCapacity: frameCount) else {
      throw AudioError.bufferAllocationFailed
    }
    sweepBuffer.frameLength = frameCount
    sweepSamples.withUnsafeBufferPointer { ptr in
      sweepBuffer.floatChannelData![0].update(from: ptr.baseAddress!, count: sweepSamples.count)
    }

    // Attach a player node for this sweep.
    let playerNode = AVAudioPlayerNode()
    eng.attach(playerNode)
    eng.connect(playerNode, to: eng.outputNode, format: monoFormat)

    // Collect input samples via tap.  Serial queue prevents data races.
    var recordedSamples: [Float] = []
    recordedSamples.reserveCapacity(sweepSamples.count + 96_000)
    let tapQueue = DispatchQueue(label: "keneth.audio.tap")

    let tapFormat = eng.inputNode.outputFormat(forBus: 0)
    eng.inputNode.installTap(onBus: 0, bufferSize: 4096, format: tapFormat) { buffer, _ in
      guard let channelData = buffer.floatChannelData?[0] else { return }
      let count = Int(buffer.frameLength)

      if let onRms = onRms, count > 0 {
        var sumSq: Float = 0
        for i in 0..<count { sumSq += channelData[i] * channelData[i] }
        onRms(Double(sqrt(sumSq / Float(count))))
      }

      let samples = Array(UnsafeBufferPointer(start: channelData, count: count))
      tapQueue.sync { recordedSamples.append(contentsOf: samples) }
    }

    // Start engine if it hasn't been started yet.
    if !eng.isRunning {
      do {
        try eng.start()
      } catch {
        eng.inputNode.removeTap(onBus: 0)
        eng.detach(playerNode)
        throw AudioError.engineStart(error)
      }
    }

    // Schedule buffer and await playback completion.
    try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
      playerNode.scheduleBuffer(sweepBuffer, completionCallbackType: .dataPlayedBack) { _ in
        cont.resume()
      }
      playerNode.play()
    }

    // Allow the final tap buffers to drain before removing the tap.
    let drainNs = UInt64((4096.0 / sampleRate) * 4 * 1_000_000_000)
    try await Task.sleep(nanoseconds: drainNs)

    eng.inputNode.removeTap(onBus: 0)
    playerNode.stop()
    eng.detach(playerNode)

    return tapQueue.sync { recordedSamples }
  }

  // MARK: - Private helpers

  private func findDevice(uid: String) -> AudioDeviceID? {
    for deviceID in ScarlettDeviceDetector.allDeviceIDs() {
      if ScarlettDeviceDetector.uid(for: deviceID) == uid { return deviceID }
    }
    return nil
  }
}
