import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/services/lc_calculator.dart';

void main() {
  const calc = LcCalculator();

  group('resonantFrequency', () {
    test('SH-4 values: L=8.06H C=128pF → ~4951 Hz', () {
      const L = 8.06;
      const C = 128e-12;
      final f = calc.resonantFrequency(L, C);
      expect(f, closeTo(4951.0, 10.0));
    });

    test('round-trip with solveInductance', () {
      const f = 5000.0;
      const C = 100e-12;
      final L = calc.solveInductance(f, C);
      final fBack = calc.resonantFrequency(L, C);
      expect(fBack, closeTo(f, 0.01));
    });

    test('round-trip with solveCapacitance', () {
      const f = 7500.0;
      const L = 3.0;
      final C = calc.solveCapacitance(f, L);
      final fBack = calc.resonantFrequency(L, C);
      expect(fBack, closeTo(f, 0.01));
    });
  });

  group('solveInductance', () {
    test('known values', () {
      // f = 1/(2π√(LC)) → L = 1/(4π²f²C)
      const f = 4780.0;
      const C = 120e-12;
      final L = calc.solveInductance(f, C);
      final expected = 1.0 / (4.0 * math.pi * math.pi * f * f * C);
      expect(L, closeTo(expected, 0.001));
    });
  });

  group('solveCapacitance', () {
    test('known values', () {
      const f = 4780.0;
      const L = 8.5;
      final C = calc.solveCapacitance(f, L);
      final expected = 1.0 / (4.0 * math.pi * math.pi * f * f * L);
      expect(C, closeTo(expected, 1e-15));
    });
  });

  group('loadedFrequency', () {
    test('adding cable capacitance lowers frequency', () {
      const L = 8.06;
      const cPickup = 128e-12;
      const cCable = 1000e-12; // 1 nF cable
      const cLoad = 470e-12;   // 470 pF pot
      final unloaded = calc.resonantFrequency(L, cPickup);
      final loaded = calc.loadedFrequency(L, cPickup, cCable, cLoad);
      expect(loaded, lessThan(unloaded));
    });

    test('zero external capacitance equals unloaded frequency', () {
      const L = 5.0;
      const cPickup = 100e-12;
      final unloaded = calc.resonantFrequency(L, cPickup);
      final loaded = calc.loadedFrequency(L, cPickup, 0.0, 0.0);
      expect(loaded, closeTo(unloaded, 0.001));
    });
  });

  group('correctDcrForTemperature', () {
    test('at 20°C returns input unchanged', () {
      const dcr = 16000.0;
      final corrected = calc.correctDcrForTemperature(dcr, 20.0);
      expect(corrected, closeTo(dcr, 0.001));
    });

    test('at 0°C returns higher resistance', () {
      // At 0°C the copper is colder → measured DCR is lower than at 20°C,
      // so correcting to 20°C should increase the value.
      const dcr = 15000.0;
      final corrected = calc.correctDcrForTemperature(dcr, 0.0);
      // DCR_20C = 15000 / (1 + 0.00393 × (0 − 20)) = 15000 / 0.9214 ≈ 16279
      expect(corrected, greaterThan(dcr));
      expect(corrected, closeTo(15000.0 / (1.0 + 0.00393 * (0.0 - 20.0)), 1.0));
    });

    test('at 40°C returns lower resistance', () {
      const dcr = 16500.0;
      final corrected = calc.correctDcrForTemperature(dcr, 40.0);
      // DCR_20C = 16500 / (1 + 0.00393 × 20) = 16500 / 1.0786 ≈ 15297
      expect(corrected, lessThan(dcr));
      expect(corrected, closeTo(16500.0 / (1.0 + 0.00393 * 20.0), 1.0));
    });
  });
}
