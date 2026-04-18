import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/ui/widgets/frequency_response_chart.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Generates a synthetic Lorentzian resonance peak centred at [peakHz] with
/// quality factor [q], sampled at [n] log-spaced points from 20–20000 Hz.
FrequencyResponse _syntheticResponse({
  double peakHz = 4780.0,
  double q = 4.0,
  int n = 200,
}) {
  final points = <FrequencyPoint>[];
  for (var i = 0; i <= n; i++) {
    final hz = 20.0 * math.pow(1000.0, i / n);
    final ratio = hz / peakHz;
    final denom = (1 - ratio * ratio) * (1 - ratio * ratio) +
        (ratio / q) * (ratio / q);
    final db = -10 * math.log(denom) / math.ln10;
    points.add(FrequencyPoint(frequency: hz, magnitude: db.clamp(-40.0, 20.0)));
  }
  return FrequencyResponse(points);
}

Widget _wrap(Widget child, {Size size = const Size(1280, 800)}) => MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: child,
        ),
      ),
    );

void main() {
  // ── S7-09: formatHzLabel — peak marker label format ─────────────────────────

  group('formatHzLabel — S7-09 peak marker label', () {
    test('4780 Hz → "4.78 kHz"', () {
      expect(formatHzLabel(4780.0), '4.78 kHz');
    });

    test('850 Hz → "850.0 Hz"', () {
      expect(formatHzLabel(850.0), '850.0 Hz');
    });

    test('1000 Hz → "1.00 kHz"', () {
      expect(formatHzLabel(1000.0), '1.00 kHz');
    });

    test('10000 Hz → "10.00 kHz"', () {
      expect(formatHzLabel(10000.0), '10.00 kHz');
    });

    test('20 Hz → "20.0 Hz"', () {
      expect(formatHzLabel(20.0), '20.0 Hz');
    });

    test('999.9 Hz stays in Hz format', () {
      expect(formatHzLabel(999.9), '999.9 Hz');
    });
  });

  // ── FrequencyResponseChart widget rendering ───────────────────────────────

  group('FrequencyResponseChart — chart key', () {
    testWidgets('chart widget key is findable', (tester) async {
      final response = _syntheticResponse();

      await tester.pumpWidget(
        _wrap(FrequencyResponseChart(
          key: const Key('frequency_response_chart'),
          response: response,
          resonantFrequency: 4780.0,
        )),
      );
      await tester.pump();

      expect(
          find.byKey(const Key('frequency_response_chart')), findsOneWidget);
    });

    testWidgets('renders with calibration response without crashing',
        (tester) async {
      final response = _syntheticResponse();
      final calResponse = _syntheticResponse(peakHz: 5000.0, q: 2.0);

      await tester.pumpWidget(
        _wrap(FrequencyResponseChart(
          response: response,
          resonantFrequency: 4780.0,
          calibrationResponse: calResponse,
          qFactor: 4.0,
        )),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  // ── S7-10: No layout overflow at standard resolutions ─────────────────────

  group('FrequencyResponseChart — S7-10 no overflow', () {
    Future<void> _pumpAtSize(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final response = _syntheticResponse();
      await tester.pumpWidget(
        _wrap(
          FrequencyResponseChart(
            response: response,
            resonantFrequency: 4780.0,
            qFactor: 4.0,
          ),
          size: size,
        ),
      );
      await tester.pump();
    }

    testWidgets('no overflow at 1280×800', (tester) async {
      await _pumpAtSize(tester, const Size(1280, 800));
      expect(tester.takeException(), isNull);
    });

    testWidgets('no overflow at 1440×900', (tester) async {
      await _pumpAtSize(tester, const Size(1440, 900));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders with empty response without crashing', (tester) async {
      await tester.pumpWidget(
        _wrap(FrequencyResponseChart(
          response: const FrequencyResponse([]),
          resonantFrequency: 4780.0,
        )),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders with single-point response without crashing',
        (tester) async {
      const response = FrequencyResponse([
        FrequencyPoint(frequency: 4780.0, magnitude: 10.0),
      ]);
      await tester.pumpWidget(
        _wrap(FrequencyResponseChart(
          response: response,
          resonantFrequency: 4780.0,
        )),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
