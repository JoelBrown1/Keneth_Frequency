import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    // Set up the audio MethodChannel (Sprint 3a).
    // AppDelegate holds a strong reference to prevent ARC from releasing the channel.
    (NSApp.delegate as? AppDelegate)?.setupAudioChannel(
      messenger: flutterViewController.engine.binaryMessenger
    )

    super.awakeFromNib()
  }
}
