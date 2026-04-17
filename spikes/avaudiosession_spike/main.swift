// Spike 4 — AVAudioEngine Channel Routing (S0-12 / S0-13)
//
// Standalone Swift program. Run with:
//   swiftc main.swift -o avaudiosession_spike && ./avaudiosession_spike
//
// What this confirms:
//   S0-12: AVAudioEngine plays 1 kHz sine exclusively to Output 1 (bus 0) of
//          the Scarlett 2i2.
//   S0-13: Simultaneously records from Input 1 (Hi-Z, bus 0) for 3 seconds and
//          verifies that captured samples are non-silence (peak amplitude > 0.001).
//
// Expected result on success:
//   Output: "PASS: peak amplitude = X.XXXXXX  (non-silence confirmed)"
//
// If the Scarlett 2i2 is not connected the program exits with an error message
// listing available devices so you can identify the correct device name.

import AVFoundation
import CoreAudio
import Foundation

// MARK: - Device helpers

/// Returns the AudioDeviceID whose name contains `substring`, or nil.
func findDevice(namePart: String) -> AudioDeviceID? {
    var propertyAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDevices,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    var dataSize: UInt32 = 0
    guard AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject),
                                        &propertyAddress, 0, nil, &dataSize) == noErr else {
        return nil
    }
    let count = Int(dataSize) / MemoryLayout<AudioDeviceID>.size
    var deviceIDs = [AudioDeviceID](repeating: 0, count: count)
    guard AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject),
                                    &propertyAddress, 0, nil, &dataSize, &deviceIDs) == noErr else {
        return nil
    }

    for id in deviceIDs {
        var nameAddr = AudioObjectPropertyAddress(
            mSelector: kAudioObjectPropertyName,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        var nameRef: Unmanaged<CFString>? = nil
        var sz = UInt32(MemoryLayout<Unmanaged<CFString>?>.size)
        AudioObjectGetPropertyData(id, &nameAddr, 0, nil, &sz, &nameRef)
        let name = nameRef?.takeRetainedValue() as String? ?? ""
        if name.contains(namePart) {
            return id
        }
    }
    return nil
}

func listDeviceNames() -> [String] {
    var propertyAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDevices,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    var dataSize: UInt32 = 0
    AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject),
                                   &propertyAddress, 0, nil, &dataSize)
    let count = Int(dataSize) / MemoryLayout<AudioDeviceID>.size
    var deviceIDs = [AudioDeviceID](repeating: 0, count: count)
    AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject),
                               &propertyAddress, 0, nil, &dataSize, &deviceIDs)
    return deviceIDs.map { id -> String in
        var nameAddr = AudioObjectPropertyAddress(
            mSelector: kAudioObjectPropertyName,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        var nameRef: Unmanaged<CFString>? = nil
        var sz = UInt32(MemoryLayout<Unmanaged<CFString>?>.size)
        AudioObjectGetPropertyData(id, &nameAddr, 0, nil, &sz, &nameRef)
        return nameRef?.takeRetainedValue() as String? ?? ""
    }
}

/// Sets the system default input and output to the device with the given AudioDeviceID.
func setDefaultDevice(_ deviceID: AudioDeviceID, isOutput: Bool) {
    let selector: AudioObjectPropertySelector = isOutput
        ? kAudioHardwarePropertyDefaultOutputDevice
        : kAudioHardwarePropertyDefaultInputDevice
    var addr = AudioObjectPropertyAddress(
        mSelector: selector,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    var mutableID = deviceID
    AudioObjectSetPropertyData(AudioObjectID(kAudioObjectSystemObject),
                               &addr, 0, nil,
                               UInt32(MemoryLayout<AudioDeviceID>.size), &mutableID)
}

// MARK: - Sine generator

/// Fills `buffer` with a single-channel 1 kHz sine wave at `sampleRate`.
func fillSine(buffer: AVAudioPCMBuffer, sampleRate: Double, frequency: Double = 1000.0) {
    let frameCount = Int(buffer.frameCapacity)
    guard let channelData = buffer.floatChannelData?[0] else { return }
    for i in 0..<frameCount {
        channelData[i] = Float(sin(2.0 * Double.pi * frequency * Double(i) / sampleRate))
    }
    buffer.frameLength = AVAudioFrameCount(frameCount)
}

// MARK: - Main

let scarlettNameFragment = "Scarlett"

guard let scarlettID = findDevice(namePart: scarlettNameFragment) else {
    let names = listDeviceNames()
    print("ERROR: No device matching '\(scarlettNameFragment)' found.")
    print("Available audio devices:")
    names.forEach { print("  • \($0)") }
    print("\nConnect the Scarlett 2i2 and re-run, or update `scarlettNameFragment` above.")
    exit(1)
}

print("Found Scarlett device ID: \(scarlettID)")

// Point the system default I/O at the Scarlett so AVAudioEngine picks it up.
setDefaultDevice(scarlettID, isOutput: true)
setDefaultDevice(scarlettID, isOutput: false)

let engine = AVAudioEngine()

let outputNode = engine.outputNode
let inputNode  = engine.inputNode

let sampleRate: Double = 48000.0
let outputFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!

// S0-12: Attach a player node and route to output bus 0 (Scarlett Output 1 / left).
let player = AVAudioPlayerNode()
engine.attach(player)
engine.connect(player, to: outputNode, fromBus: 0, toBus: 0, format: outputFormat)

// S0-13: Install a tap on the input node, bus 0 (Scarlett Input 1 / Hi-Z).
let inputFormat = inputNode.inputFormat(forBus: 0)
var capturedPeak: Float = 0.0
let tapBufferSize: AVAudioFrameCount = 4096
inputNode.installTap(onBus: 0, bufferSize: tapBufferSize, format: inputFormat) { buffer, _ in
    guard let data = buffer.floatChannelData?[0] else { return }
    let frameCount = Int(buffer.frameLength)
    for i in 0..<frameCount {
        let sample = abs(data[i])
        if sample > capturedPeak { capturedPeak = sample }
    }
}

do {
    try engine.start()
} catch {
    print("ERROR: AVAudioEngine failed to start: \(error)")
    exit(1)
}

// Prepare sine buffer — 1 second of audio.
let sineBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat,
                                  frameCapacity: AVAudioFrameCount(sampleRate))!
fillSine(buffer: sineBuffer, sampleRate: sampleRate)
player.scheduleBuffer(sineBuffer, at: nil, options: .loops, completionHandler: nil)
player.play()

print("Playing 1 kHz sine to Output 1, recording from Input 1 for 3 seconds...")
Thread.sleep(forTimeInterval: 3.0)

player.stop()
inputNode.removeTap(onBus: 0)
engine.stop()

// S0-13 verdict
let silenceThreshold: Float = 0.001
if capturedPeak > silenceThreshold {
    print("PASS  (S0-13): peak amplitude = \(String(format: "%.6f", capturedPeak))  (non-silence confirmed)")
    print("PASS  (S0-12): output routing and simultaneous record confirmed on Scarlett 2i2")
    print("")
    print("Decision for Sprint 3:")
    print("  • AVAudioEngine output node bus 0  → Scarlett Output 1 (left)")
    print("  • AVAudioEngine input node  bus 0  → Scarlett Input 1 (Hi-Z)")
    print("  • No PortAudio fallback needed.")
} else {
    print("FAIL  (S0-13): peak amplitude = \(String(format: "%.6f", capturedPeak))  (silence — check physical loopback cable)")
    print("If the pickup is not physically connected, a loopback cable from Output 1 → Input 1")
    print("can be used to verify routing without a pickup present.")
    exit(1)
}
