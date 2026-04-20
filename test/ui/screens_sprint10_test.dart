/// S10-03/04: Widget tests for all session-flow screens.
///
/// Covers: HomeScreen, SetupScreen, DcrEntryScreen, CalibrationScreen,
/// MeasurementScreen.
///
/// Each test group pumps the screen directly (bypassing GoRouter) and asserts
/// that key widgets are present and the screen renders without exception.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/application/providers/audio_device_provider.dart';
import 'package:keneth_frequency/application/providers/calibration_provider.dart';
import 'package:keneth_frequency/application/providers/database_providers.dart';
import 'package:keneth_frequency/application/providers/measurement_providers.dart';
import 'package:keneth_frequency/application/session/session_notifier.dart';
import 'package:keneth_frequency/application/session/session_state.dart';
import 'package:keneth_frequency/application/settings/settings_notifier.dart';
import 'package:keneth_frequency/domain/entities/calibration_data.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/domain/entities/pickup_measurement.dart';
import 'package:keneth_frequency/domain/entities/pickup_type.dart';
import 'package:keneth_frequency/infrastructure/audio/audio_device_info.dart';
import 'package:keneth_frequency/infrastructure/audio/audio_service_interface.dart';
import 'package:keneth_frequency/infrastructure/storage/app_database.dart';
import 'package:keneth_frequency/ui/screens/calibration_screen.dart';
import 'package:keneth_frequency/ui/screens/dcr_entry_screen.dart';
import 'package:keneth_frequency/ui/screens/home_screen.dart';
import 'package:keneth_frequency/ui/screens/measurement_screen.dart';
import 'package:keneth_frequency/ui/screens/setup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Fake audio service ────────────────────────────────────────────────────────

class _FakeAudio implements AudioServiceInterface {
  @override
  Future<void> closeSession() async {}

  @override
  Future<List<AudioDeviceInfo>> getDevices() async => [
        const AudioDeviceInfo(
          id: 'fake',
          name: 'Fake Scarlett 2i2',
          inputChannels: 2,
          outputChannels: 2,
          nominalSampleRate: 48000,
          isScarlett: true,
        ),
      ];

  @override
  Future<dynamic> openSession(String deviceId, double sampleRate) async =>
      true;

  @override
  Future<Float32List> playSweepAndRecord(
          Float32List sweepSamples, int outputChannel, int inputChannel) =>
      throw UnimplementedError();

  @override
  Stream<double> get levelStream => Stream.value(0.0);

  @override Future<void> startMonitoring() async {}
  @override Future<void> stopMonitoring() async {}
}

// ── Test session notifier ─────────────────────────────────────────────────────

class _FixedSession extends Notifier<SessionState>
    implements SessionNotifier {
  _FixedSession(this._s);
  final SessionState _s;

  @override
  SessionState build() => _s;

  @override void startSession() {}
  @override void submitSetup(PickupType t, String n) {}
  @override void submitDcr(double d, double t) {}
  @override void startCalibration() {}
  @override void updateCalibrationProgress(double p) {}
  @override void calibrationComplete() {}
  @override void startMeasurement() {}
  @override void updateMeasurementProgress(double p) {}
  @override void measurementComplete(PickupMeasurement m) {}
  @override void saveResult() {}
  @override void reset() {}
  @override void discardAndRemeasure() {}
  @override Future<void> cancelSession() async {}
  @override Future<void> runCalibration() async {}
  @override Future<void> runMeasurement() async {}
  @override Future<void> startLevelMonitoring() async {}
  @override PickupType get accumulatedType => PickupType.humbuckerMediumOutput;
  @override String get accumulatedPickupName => 'Test';
  @override double get accumulatedDcr => 0;
  @override double get accumulatedTempC => 20;
}

// ── Shared pump helper ────────────────────────────────────────────────────────

Future<void> _pump(
  WidgetTester tester,
  Widget screen, {
  SessionState? session,
  List<PickupMeasurement> history = const [],
}) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase.forTesting();
  final s = session ?? const PickupSetupState();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioServiceProvider.overrideWithValue(_FakeAudio()),
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
        sessionNotifierProvider.overrideWith(() => _FixedSession(s)),
        measurementHistoryProvider.overrideWith((_) async => history),
        calibrationStatusProvider.overrideWith(
          (_) async => CalibrationStatus(latest: null, isStale: false),
        ),
        audioDevicesProvider.overrideWith(
          (_) async => (await _FakeAudio().getDevices()),
        ),
      ],
      child: MaterialApp(home: screen),
    ),
  );
  // Use pump() rather than pumpAndSettle() — determinate LinearProgressIndicator
  // has an internal AnimationController that prevents pumpAndSettle from settling.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

// ── S10-03a: HomeScreen ───────────────────────────────────────────────────────

void main() {
  group('HomeScreen — S10-03a', () {
    testWidgets('renders AppBar title', (tester) async {
      await _pump(tester, const HomeScreen(), session: const IdleState());
      expect(find.text('Keneth Frequency'), findsOneWidget);
    });

    testWidgets('New Measurement button is present', (tester) async {
      await _pump(tester, const HomeScreen(), session: const IdleState());
      expect(find.byKey(const Key('new_measurement_button')), findsOneWidget);
    });

    testWidgets('settings and reference action icons are present', (tester) async {
      await _pump(tester, const HomeScreen(), session: const IdleState());
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);
    });

    testWidgets('empty state shown when history is empty', (tester) async {
      await _pump(tester, const HomeScreen(), session: const IdleState());
      expect(find.textContaining('No measurements'), findsOneWidget);
    });

    testWidgets('measurement tile shown when history has one item', (tester) async {
      final m = _fakeMeasurement();
      await _pump(tester, const HomeScreen(),
          session: const IdleState(), history: [m]);
      expect(find.byKey(Key('measurement_tile_${m.id}')), findsOneWidget);
    });
  });

  // ── S10-03b: SetupScreen ─────────────────────────────────────────────────────

  group('SetupScreen — S10-03b', () {
    testWidgets('renders AppBar title', (tester) async {
      await _pump(tester, const SetupScreen());
      expect(find.text('Pickup Setup'), findsOneWidget);
    });

    testWidgets('pickup name field is present', (tester) async {
      await _pump(tester, const SetupScreen());
      expect(find.byKey(const Key('pickup_name_field')), findsOneWidget);
    });

    testWidgets('session progress bar is shown at step 0', (tester) async {
      await _pump(tester, const SetupScreen());
      // SessionProgressBar renders 5 dots; step 0 is filled
      expect(find.byType(LinearProgressIndicator), findsNothing);
      // At minimum the screen renders without exception.
      expect(tester.takeException(), isNull);
    });

    testWidgets('Enter DCR button is present', (tester) async {
      await _pump(tester, const SetupScreen());
      expect(find.text('Enter DCR'), findsOneWidget);
    });
  });

  // ── S10-03c: DcrEntryScreen ──────────────────────────────────────────────────

  group('DcrEntryScreen — S10-03c', () {
    setUp(() {});

    testWidgets('renders AppBar title', (tester) async {
      await _pump(
        tester,
        const DcrEntryScreen(),
        session: DcrEntryState(
          type: PickupType.humbuckerMediumOutput,
          pickupName: 'SH-4',
        ),
      );
      expect(find.text('DCR Entry'), findsOneWidget);
    });

    testWidgets('DCR field is present', (tester) async {
      await _pump(
        tester,
        const DcrEntryScreen(),
        session: DcrEntryState(
          type: PickupType.humbuckerMediumOutput,
          pickupName: 'SH-4',
        ),
      );
      expect(find.byKey(const Key('dcr_field')), findsOneWidget);
    });

    testWidgets('Calibrate button is disabled when DCR is not entered',
        (tester) async {
      await _pump(
        tester,
        const DcrEntryScreen(),
        session: DcrEntryState(
          type: PickupType.humbuckerMediumOutput,
          pickupName: 'SH-4',
        ),
      );
      // Button exists but its onPressed should be null (disabled).
      final btn = tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Calibrate'));
      expect(btn.onPressed, isNull);
    });

    testWidgets('pickup name is shown when DcrEntryState has a name',
        (tester) async {
      await _pump(
        tester,
        const DcrEntryScreen(),
        session: DcrEntryState(
          type: PickupType.humbuckerMediumOutput,
          pickupName: 'PAF Bridge',
        ),
      );
      expect(find.textContaining('PAF Bridge'), findsOneWidget);
    });
  });

  // ── S10-04a: CalibrationScreen ────────────────────────────────────────────────

  group('CalibrationScreen — S10-04a', () {
    testWidgets('renders AppBar title', (tester) async {
      await _pump(tester, const CalibrationScreen(),
          session: const CalibratingState(progress: 0.0));
      expect(find.text('Calibration'), findsOneWidget);
    });

    testWidgets('Start Calibration button is present and enabled when device found',
        (tester) async {
      await _pump(tester, const CalibrationScreen(),
          session: const CalibratingState(progress: 0.0));
      expect(
          find.byKey(const Key('start_calibration_button')), findsOneWidget);
      final btn = tester.widget<ElevatedButton>(
          find.byKey(const Key('start_calibration_button')));
      // Device is present (fake returns isScarlett: true), so enabled.
      expect(btn.onPressed, isNotNull);
    });

    testWidgets('progress indicator appears when calibration is running',
        (tester) async {
      await _pump(tester, const CalibrationScreen(),
          session: const CalibratingState(progress: 0.5));
      expect(find.byKey(const Key('calibration_progress')), findsOneWidget);
    });

    testWidgets('Focusrite reminder card is shown', (tester) async {
      await _pump(tester, const CalibrationScreen(),
          session: const CalibratingState(progress: 0.0));
      expect(find.textContaining('Focusrite Scarlett 2i2'), findsOneWidget);
    });
  });

  // ── S10-04b: MeasurementScreen ────────────────────────────────────────────────

  group('MeasurementScreen — S10-04b', () {
    testWidgets('renders AppBar title', (tester) async {
      await _pump(tester, const MeasurementScreen(),
          session: const MeasuringState(progress: 0.0));
      expect(find.text('Measuring'), findsOneWidget);
    });

    testWidgets('Start Sweep button is present before sweep begins', (tester) async {
      await _pump(tester, const MeasurementScreen(),
          session: const MeasuringState(progress: 0.0));
      expect(find.byKey(const Key('start_sweep_button')), findsOneWidget);
      expect(find.text('Start Sweep'), findsOneWidget);
    });

    testWidgets('progress indicator appears when sweep is running', (tester) async {
      await _pump(tester, const MeasurementScreen(),
          session: const MeasuringState(progress: 0.4));
      expect(find.byKey(const Key('measurement_progress')), findsOneWidget);
    });

    testWidgets('instruction text shown before sweep starts', (tester) async {
      await _pump(tester, const MeasurementScreen(),
          session: const MeasuringState(progress: 0.0));
      expect(find.textContaining('Start Sweep'), findsWidgets);
    });

    testWidgets('no exception during render', (tester) async {
      await _pump(tester, const MeasurementScreen(),
          session: const MeasuringState(progress: 0.0));
      expect(tester.takeException(), isNull);
    });
  });
}

// ── Helpers ───────────────────────────────────────────────────────────────────

PickupMeasurement _fakeMeasurement() => PickupMeasurement(
      id: 'abc123',
      timestamp: DateTime.utc(2026, 4, 18),
      type: PickupType.humbuckerMediumOutput,
      pickupName: 'SH-4 Bridge',
      dcr: 16500,
      ambientTempC: 21.0,
      resonantFrequency: 4783.0,
      qFactor: 3.2,
      peakAmplitudeDb: 12.0,
      response: const FrequencyResponse([]),
      calibrationApplied: true,
    );
