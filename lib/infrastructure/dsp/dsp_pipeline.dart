import 'dart:typed_data';

import '../../domain/entities/calibration_data.dart';
import '../../domain/entities/frequency_response.dart';
import '../../domain/services/peak_detector.dart';
import 'fft_processor.dart';
import 'frequency_response_builder.dart';
import 'signal_validator.dart';
import 'smoothing.dart';
import 'window_functions.dart';

/// Input for the DSP pipeline. All fields are plain Dart types — safe to pass
/// to [compute] without crossing any native-pointer Isolate boundaries.
class DspPipelineInput {
  const DspPipelineInput({
    required this.recordingPcm,
    required this.sampleRate,
    this.calibration,
  });

  final Float32List recordingPcm;
  final int sampleRate;
  final CalibrationData? calibration; // pure Dart — safe across Isolate boundary
}

/// Output from the DSP pipeline. All fields are plain Dart types.
class DspPipelineOutput {
  const DspPipelineOutput({
    required this.displayResponse,
    required this.storageResponse,
    required this.clipWarning,
    required this.silenceWarning,
    required this.snrDb,
  });

  final FrequencyResponse displayResponse; // ~1000 log-spaced points
  final FrequencyResponse storageResponse; // ≤60 log-spaced points
  final bool clipWarning;
  final bool silenceWarning;
  final double snrDb; // < 10 dB = poor SNR; 0.0 if no peak found
}

/// Top-level entry point for the DSP pipeline.
///
/// Designed to be called via [compute]:
/// ```dart
/// final output = await compute(runDspPipeline, input);
/// ```
///
/// No [Pointer<T>] is created in [DspPipelineInput] or [DspPipelineOutput].
/// All FFI pointers inside [FftProcessor.process] are allocated and freed
/// within that single method call, never escaping to the Isolate boundary.
DspPipelineOutput runDspPipeline(DspPipelineInput input) {
  const validator = SignalValidator();
  const processor = FftProcessor();
  const builder = FrequencyResponseBuilder();
  const smoother = Smoothing();
  const peakDetector = PeakDetector();

  // 1. Signal quality checks (pure Dart, no FFI).
  final clipped = validator.checkClip(input.recordingPcm);
  final silent = validator.checkSilence(input.recordingPcm);

  // 2. FFT — all native memory lives and dies inside process().
  final magnitudesDb = processor.process(
    input.recordingPcm,
    window: WindowFunction.hann,
  );
  final fftSize = nextPowerOfTwo(input.recordingPcm.length);

  // 3. Build frequency response (calibration subtraction + trim to 20–20k Hz).
  final rawResponse = builder.build(
    magnitudesDb,
    fftSize,
    input.sampleRate,
    calibration: input.calibration,
  );

  // 4. Smooth to ~1000 display points.
  final displayResponse = smoother.fractionalOctave(rawResponse, 1.0 / 6.0);

  // 5. Downsample to ≤60 storage points.
  final storageResponse = smoother.toStorageResolution(displayResponse);

  // 6. SNR (peak detector operates on plain FrequencyResponse — no FFI).
  final peakResult = peakDetector.findResonantPeak(displayResponse);
  final snrDb = peakResult != null
      ? validator.checkSnr(displayResponse, peakResult)
      : 0.0;

  return DspPipelineOutput(
    displayResponse: displayResponse,
    storageResponse: storageResponse,
    clipWarning: clipped,
    silenceWarning: silent,
    snrDb: snrDb,
  );
}
