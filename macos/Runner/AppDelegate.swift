import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  /// Strong reference — prevents ARC from releasing the AudioChannel and its handler.
  var audioChannel: AudioChannel?

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  /// Called from MainFlutterWindow.awakeFromNib() once the FlutterViewController
  /// and its binary messenger are ready.
  func setupAudioChannel(messenger: FlutterBinaryMessenger) {
    audioChannel = AudioChannel(messenger: messenger)
  }
}
