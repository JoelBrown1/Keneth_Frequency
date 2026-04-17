import AVFoundation
import CoreAudio
import Foundation

// Scarlett 2i2 4th Gen USB identifiers — verified via ioreg (S0-11 spike, 2026-04-16)
// VID: 0x1235 (Focusrite), PID: 0x8219 (confirmed on hardware; arch doc had 0x8215 — incorrect)
private let kFocusriteVendorID: Int = 0x1235
private let kScarlett2i2PID: Int = 0x8219

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
