import AVFoundation
import CoreAudio
import Foundation

// Scarlett 2i2 4th Gen USB identifiers — PID to be verified in S0-11 spike
// VID: 0x1235 (Focusrite), PID: 0x8215 (unverified — update after system_profiler check)
private let kFocusriteVendorID: Int = 0x1235
private let kScarlett2i2PID: Int = 0x8215  // TODO: verify in S0-11

class CoreAudioSession {
  private var engine: AVAudioEngine?

  func listDevices() -> [[String: Any]] {
    // Sprint 3a: enumerate AudioObjectIDs, match Scarlett 2i2 by VID/PID
    return []
  }

  func open(deviceId: String, sampleRate: Double) -> Bool {
    // Sprint 3a: set up AVAudioEngine with explicit channel routing
    // per channel mapping confirmed in S0-12/S0-13 audio spike
    return false
  }

  func close() {
    engine?.stop()
    engine = nil
  }
}
