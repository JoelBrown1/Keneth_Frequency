import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/application/providers/database_providers.dart';
import 'package:keneth_frequency/application/settings/settings_notifier.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/domain/entities/pickup_measurement.dart';
import 'package:keneth_frequency/domain/entities/pickup_type.dart';
import 'package:keneth_frequency/infrastructure/storage/app_database.dart';
import 'package:keneth_frequency/ui/screens/reference_screen.dart';
import 'package:keneth_frequency/ui/screens/home_screen.dart';
import 'package:keneth_frequency/application/providers/measurement_providers.dart';
import 'package:keneth_frequency/ui/widgets/frequency_response_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

FrequencyResponse _syntheticResponse({double peakHz = 4780.0, int n = 100}) {
  final points = <FrequencyPoint>[];
  for (var i = 0; i <= n; i++) {
    final hz = 20.0 * math.pow(1000.0, i / n);
    final ratio = hz / peakHz;
    final denom = (1 - ratio * ratio) * (1 - ratio * ratio) +
        (ratio / 4.0) * (ratio / 4.0);
    final db = -10 * math.log(denom) / math.ln10;
    points.add(
        FrequencyPoint(frequency: hz, magnitude: db.clamp(-40.0, 20.0)));
  }
  return FrequencyResponse(points);
}

PickupMeasurement _fakeMeasurement({
  String id = 'id1',
  String name = 'Test Pickup',
  double resonantHz = 4780.0,
  PickupType type = PickupType.humbuckerMediumOutput,
}) =>
    PickupMeasurement(
      id: id,
      timestamp: DateTime.utc(2025, 1, 1),
      type: type,
      pickupName: name,
      dcr: 15000,
      ambientTempC: 20,
      resonantFrequency: resonantHz,
      qFactor: 4.0,
      peakAmplitudeDb: 10.0,
      response: _syntheticResponse(peakHz: resonantHz),
      calibrationApplied: true,
    );

// ── S8-13: ReferenceScreen renders all 10 pickup type rows ────────────────────

void main() {
  group('ReferenceScreen — S8-13 renders all 10 rows', () {
    setUp(() {});

    // Use a tall viewport so all ListView items are built simultaneously.
    Future<void> _pumpRef(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(const MaterialApp(home: ReferenceScreen()));
      await tester.pump();
    }

    testWidgets('all 10 pickup type rows are present', (tester) async {
      await _pumpRef(tester);

      final types = [
        'singleCoilStrat',
        'singleCoilTeleBridge',
        'singleCoilTeleNeck',
        'p90',
        'humbuckerLowOutput',
        'humbuckerMediumOutput',
        'humbuckerHighOutput',
        'bassSingleCoil',
        'bassSplitHumbucker',
        'unknown',
      ];
      for (final t in types) {
        expect(
          find.byKey(Key('ref_row_$t')),
          findsOneWidget,
          reason: 'Expected ref row for type $t',
        );
      }
    });

    testWidgets('SH-4 row has "Verification ref" badge', (tester) async {
      await _pumpRef(tester);
      expect(find.text('Verification ref'), findsOneWidget);
    });

    testWidgets('sort by DCR changes order without crashing', (tester) async {
      await _pumpRef(tester);

      await tester.tap(find.text('DCR Range'));
      await tester.pump();

      // All rows still present after sort.
      expect(find.byKey(const Key('ref_row_humbuckerMediumOutput')),
          findsOneWidget);
    });
  });

  // ── S8-14: Right-click context menu on HomeScreen row ─────────────────────

  group('HomeScreen — S8-14 right-click context menu', () {
    Future<void> _pumpHome(
        WidgetTester tester, List<PickupMeasurement> measurements) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final db = AppDatabase.forTesting();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            appDatabaseProvider.overrideWithValue(db),
            // Override history with our fake measurements.
            measurementHistoryProvider.overrideWith(
              (ref) async => measurements,
            ),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('right-click on tile shows context menu with Compare option',
        (tester) async {
      final m1 = _fakeMeasurement(id: 'id1', name: 'PAF Bridge');
      final m2 = _fakeMeasurement(id: 'id2', name: 'SH-4 Bridge');

      await _pumpHome(tester, [m1, m2]);

      // Right-click on the first tile.
      final tile = find.byKey(Key('measurement_tile_${m1.id}'));
      expect(tile, findsOneWidget);

      await tester.sendEventToBinding(
        PointerDownEvent(
          position: tester.getCenter(tile),
          buttons: kSecondaryMouseButton,
          kind: PointerDeviceKind.mouse,
          pointer: 1,
        ),
      );
      await tester.sendEventToBinding(
        PointerUpEvent(
          position: tester.getCenter(tile),
          buttons: 0,
          kind: PointerDeviceKind.mouse,
          pointer: 1,
        ),
      );
      await tester.pumpAndSettle();

      // Context menu items should be visible.
      expect(find.byKey(const Key('context_compare')), findsOneWidget);
      expect(find.byKey(const Key('context_view')), findsOneWidget);
      expect(find.byKey(const Key('context_delete')), findsOneWidget);
    });
  });

  // ── S8-15: Comparison chart two peak markers ──────────────────────────────

  group('FrequencyResponseChart — S8-15 comparison mode two markers', () {
    testWidgets('dual-line chart renders both series without crashing',
        (tester) async {
      final r1 = _syntheticResponse(peakHz: 4780.0);
      final r2 = _syntheticResponse(peakHz: 6200.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1280,
              height: 400,
              child: FrequencyResponseChart(
                key: const Key('compare_chart'),
                response: r1,
                resonantFrequency: 4780.0,
                secondaryResponse: r2,
                secondaryResonantFrequency: 6200.0,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('compare_chart')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    test('formatHzLabel for both frequencies returns correct labels', () {
      expect(formatHzLabel(4780.0), '4.78 kHz');
      expect(formatHzLabel(6200.0), '6.20 kHz');
    });
  });
}
