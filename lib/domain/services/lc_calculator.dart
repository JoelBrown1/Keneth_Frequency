import 'dart:math' as math;

class LcCalculator {
  const LcCalculator();

  /// f = 1 / (2π√LC)  →  Hz
  double resonantFrequency(double L, double C) {
    return 1.0 / (2.0 * math.pi * math.sqrt(L * C));
  }

  /// Solve for L given f (Hz) and C (F)  →  H
  double solveInductance(double f, double C) {
    return 1.0 / (4.0 * math.pi * math.pi * f * f * C);
  }

  /// Solve for C given f (Hz) and L (H)  →  F
  double solveCapacitance(double f, double L) {
    return 1.0 / (4.0 * math.pi * math.pi * f * f * L);
  }

  /// Resonant frequency with external load capacitance (cable + pot).
  /// f = 1 / (2π√(L × (cPickup + cCable + cLoad)))  →  Hz
  double loadedFrequency(
    double L,
    double cPickup,
    double cCable,
    double cLoad,
  ) {
    return resonantFrequency(L, cPickup + cCable + cLoad);
  }

  /// Correct DCR to 20°C reference temperature.
  ///
  /// Formula:  DCR_20C = DCR / (1 + 0.00393 × (T − 20))
  ///
  /// Copper temperature coefficient α = 0.00393 /°C.
  double correctDcrForTemperature(double dcr, double tempC) {
    return dcr / (1.0 + 0.00393 * (tempC - 20.0));
  }
}
