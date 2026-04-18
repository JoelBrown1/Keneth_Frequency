import CoreAudio
import Foundation

/// Detects the Focusrite Scarlett 2i2 4th Gen among CoreAudio devices.
///
/// USB identifiers verified via S0-11 spike (2026-04-16):
///   VID 0x1235 (Focusrite), PID 0x8219 (Scarlett 2i2 4th Gen)
///
/// On macOS the CoreAudio UID for USB audio class devices has the form:
///   "AppleUSBAudioEngine:MANUFACTURER:PRODUCT:SERIAL:INTERFACE"
/// The product name "Scarlett" appears verbatim in the UID, making substring
/// matching on the UID sufficient for sandboxed apps (no IOKit entitlement needed).
struct ScarlettDeviceDetector {
  private static let kFocusriteVendorHex = "1235"  // 0x1235 decimal 4661
  private static let kScarlettPIDHex = "8219"       // 0x8219 decimal 33305

  /// Returns `true` when [uid] is the CoreAudio UID of a Scarlett device.
  static func isScarlettUID(_ uid: String) -> Bool {
    uid.contains("Scarlett")
  }

  /// Returns `true` when [name] is the display name of a Scarlett device.
  static func isScarlettName(_ name: String) -> Bool {
    name.lowercased().contains("scarlett")
  }

  /// Returns the `AudioDeviceID` of the first Scarlett found, or `nil`.
  static func find() -> AudioDeviceID? {
    for id in allDeviceIDs() {
      if let uid = uid(for: id), isScarlettUID(uid) { return id }
      if let name = name(for: id), isScarlettName(name) { return id }
    }
    return nil
  }

  // MARK: - Package-internal helpers (used by CoreAudioSession)

  static func allDeviceIDs() -> [AudioDeviceID] {
    var addr = AudioObjectPropertyAddress(
      mSelector: kAudioHardwarePropertyDevices,
      mScope: kAudioObjectPropertyScopeGlobal,
      mElement: kAudioObjectPropertyElementMain
    )
    var dataSize: UInt32 = 0
    guard AudioObjectGetPropertyDataSize(
      AudioObjectID(kAudioObjectSystemObject), &addr, 0, nil, &dataSize
    ) == noErr else { return [] }

    let count = Int(dataSize) / MemoryLayout<AudioDeviceID>.size
    var ids = [AudioDeviceID](repeating: 0, count: count)
    guard AudioObjectGetPropertyData(
      AudioObjectID(kAudioObjectSystemObject), &addr, 0, nil, &dataSize, &ids
    ) == noErr else { return [] }
    return ids
  }

  static func uid(for deviceID: AudioDeviceID) -> String? {
    var addr = AudioObjectPropertyAddress(
      mSelector: kAudioDevicePropertyDeviceUID,
      mScope: kAudioObjectPropertyScopeGlobal,
      mElement: kAudioObjectPropertyElementMain
    )
    var ref: Unmanaged<CFString>? = nil
    var sz = UInt32(MemoryLayout<Unmanaged<CFString>?>.size)
    guard AudioObjectGetPropertyData(deviceID, &addr, 0, nil, &sz, &ref) == noErr else {
      return nil
    }
    return ref?.takeRetainedValue() as String?
  }

  static func name(for deviceID: AudioDeviceID) -> String? {
    var addr = AudioObjectPropertyAddress(
      mSelector: kAudioObjectPropertyName,
      mScope: kAudioObjectPropertyScopeGlobal,
      mElement: kAudioObjectPropertyElementMain
    )
    var ref: Unmanaged<CFString>? = nil
    var sz = UInt32(MemoryLayout<Unmanaged<CFString>?>.size)
    guard AudioObjectGetPropertyData(deviceID, &addr, 0, nil, &sz, &ref) == noErr else {
      return nil
    }
    return ref?.takeRetainedValue() as String?
  }

  static func nominalSampleRate(for deviceID: AudioDeviceID) -> Double? {
    var addr = AudioObjectPropertyAddress(
      mSelector: kAudioDevicePropertyNominalSampleRate,
      mScope: kAudioObjectPropertyScopeGlobal,
      mElement: kAudioObjectPropertyElementMain
    )
    var rate: Float64 = 0
    var sz = UInt32(MemoryLayout<Float64>.size)
    guard AudioObjectGetPropertyData(deviceID, &addr, 0, nil, &sz, &rate) == noErr else {
      return nil
    }
    return Double(rate)
  }

  static func channelCount(for deviceID: AudioDeviceID, scope: AudioObjectPropertyScope) -> Int {
    var addr = AudioObjectPropertyAddress(
      mSelector: kAudioDevicePropertyStreamConfiguration,
      mScope: scope,
      mElement: kAudioObjectPropertyElementMain
    )
    var dataSize: UInt32 = 0
    guard AudioObjectGetPropertyDataSize(deviceID, &addr, 0, nil, &dataSize) == noErr,
          dataSize > 0 else { return 0 }

    let rawPtr = UnsafeMutableRawPointer.allocate(
      byteCount: Int(dataSize),
      alignment: MemoryLayout<AudioBufferList>.alignment
    )
    defer { rawPtr.deallocate() }

    guard AudioObjectGetPropertyData(deviceID, &addr, 0, nil, &dataSize, rawPtr) == noErr else {
      return 0
    }
    let list = UnsafeMutableAudioBufferListPointer(
      rawPtr.assumingMemoryBound(to: AudioBufferList.self)
    )
    return list.reduce(0) { $0 + Int($1.mNumberChannels) }
  }

  @discardableResult
  static func setDefault(_ deviceID: AudioDeviceID, isOutput: Bool) -> Bool {
    let selector: AudioObjectPropertySelector = isOutput
      ? kAudioHardwarePropertyDefaultOutputDevice
      : kAudioHardwarePropertyDefaultInputDevice
    var addr = AudioObjectPropertyAddress(
      mSelector: selector,
      mScope: kAudioObjectPropertyScopeGlobal,
      mElement: kAudioObjectPropertyElementMain
    )
    var mutableID = deviceID
    return AudioObjectSetPropertyData(
      AudioObjectID(kAudioObjectSystemObject), &addr, 0, nil,
      UInt32(MemoryLayout<AudioDeviceID>.size), &mutableID
    ) == noErr
  }
}
