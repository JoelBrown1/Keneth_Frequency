import 'dart:ffi';
import 'dart:io';

// Mirror the typedef names from the Sprint 0 spike test for consistency.
typedef PocketFftMagnitudesDb = Int32 Function(
  Pointer<Float>, Int64, Pointer<Double>
);
typedef PocketFftMagnitudesDbDart = int Function(
  Pointer<Float>, int, Pointer<Double>
);
typedef PocketFftOutputSize = Int64 Function(Int64);
typedef PocketFftOutputSizeDart = int Function(int);

/// Loads the compiled pocketfft dylib and exposes the two C functions.
///
/// The dylib is opened once per isolate (static field). Each Dart isolate
/// (including those spawned by [compute]) opens its own handle — this is
/// correct and expected.
class FftBindings {
  FftBindings._();

  static final DynamicLibrary _lib = DynamicLibrary.open(_dyLibPath());

  static String _dyLibPath() {
    // During flutter test the CWD is the project root.
    const devPath = 'macos/Runner/libpocketfft.dylib';
    if (File(devPath).existsSync()) return devPath;
    // In the production macOS bundle the dylib lives next to the executable.
    final execDir = File(Platform.resolvedExecutable).parent.path;
    return '$execDir/libpocketfft.dylib';
  }

  /// Computes the real-to-complex FFT and writes magnitudes in dB FS.
  static final PocketFftMagnitudesDbDart magnitudesDb = _lib.lookupFunction<
      PocketFftMagnitudesDb,
      PocketFftMagnitudesDbDart>('pocketfft_real_magnitudes_db');

  /// Returns the required output buffer size for an input of length [n].
  /// Equal to n ~/ 2 + 1.
  static final PocketFftOutputSizeDart outputSize = _lib.lookupFunction<
      PocketFftOutputSize,
      PocketFftOutputSizeDart>('pocketfft_output_size');
}
