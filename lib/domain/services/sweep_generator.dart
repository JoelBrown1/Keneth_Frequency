import 'dart:math' as math;
import 'dart:typed_data';

class SweepGenerator {
  const SweepGenerator();

  /// Generates a log chirp (exponential sine sweep) from [f1] to [f2] Hz.
  ///
  /// The buffer is normalised so that the peak amplitude equals -12 dBFS
  /// (linear peak ≈ 0.2512).
  ///
  /// Formula:
  ///   φ(t) = 2π f1 T / ln(f2/f1) × (exp(t/T × ln(f2/f1)) − 1)
  /// where T = [durationSec].
  Float32List generateLogChirp({
    double f1 = 20.0,
    double f2 = 20000.0,
    double durationSec = 20.0,
    int sampleRate = 48000,
  }) {
    final frameCount = (durationSec * sampleRate).round();
    final buffer = Float32List(frameCount);

    final lnRatio = math.log(f2 / f1);
    final k = durationSec / lnRatio; // = T / ln(f2/f1)

    for (int i = 0; i < frameCount; i++) {
      final t = i / sampleRate;
      final phase = 2.0 * math.pi * f1 * k * (math.exp(t / durationSec * lnRatio) - 1.0);
      buffer[i] = math.sin(phase);
    }

    // Normalise to -12 dBFS peak (linear ≈ 0.25119).
    const targetPeak = 0.25119; // 10^(-12/20)
    double peak = 0.0;
    for (int i = 0; i < frameCount; i++) {
      final abs = buffer[i].abs();
      if (abs > peak) peak = abs;
    }
    if (peak > 0.0) {
      final scale = targetPeak / peak;
      for (int i = 0; i < frameCount; i++) {
        buffer[i] *= scale;
      }
    }

    return buffer;
  }
}
