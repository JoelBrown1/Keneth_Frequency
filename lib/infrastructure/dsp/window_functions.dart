import 'dart:math' as math;
import 'dart:typed_data';

enum WindowFunction { hann, blackmanHarris, none }

class WindowFunctions {
  const WindowFunctions._();

  /// Symmetric Hann window of [size] coefficients.
  ///
  /// w[i] = 0.5 × (1 − cos(2π·i / (N−1)))
  ///
  /// Tapers to 0.0 at both ends (i = 0 and i = N-1).
  static Float64List hann(int size) {
    if (size <= 0) throw ArgumentError.value(size, 'size', 'must be > 0');
    if (size == 1) return Float64List.fromList([1.0]);
    final w = Float64List(size);
    final n1 = size - 1;
    for (int i = 0; i < size; i++) {
      w[i] = 0.5 * (1.0 - math.cos(2.0 * math.pi * i / n1));
    }
    return w;
  }

  /// 4-term minimum-sidelobe Blackman-Harris window of [size] coefficients.
  ///
  /// Coefficients (Nuttall 1981 / Harris 1978):
  ///   a0 = 0.35875, a1 = 0.48829, a2 = 0.14128, a3 = 0.01168
  static Float64List blackmanHarris(int size) {
    if (size <= 0) throw ArgumentError.value(size, 'size', 'must be > 0');
    if (size == 1) return Float64List.fromList([1.0]);
    const a0 = 0.35875;
    const a1 = 0.48829;
    const a2 = 0.14128;
    const a3 = 0.01168;
    final w = Float64List(size);
    final n1 = size - 1;
    for (int i = 0; i < size; i++) {
      final t = 2.0 * math.pi * i / n1;
      w[i] = a0 - a1 * math.cos(t) + a2 * math.cos(2 * t) - a3 * math.cos(3 * t);
    }
    return w;
  }
}
