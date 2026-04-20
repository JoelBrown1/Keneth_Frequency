import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/application/providers/database_providers.dart';
import 'package:keneth_frequency/application/session/session_notifier.dart';
import 'package:keneth_frequency/application/session/session_state.dart';
import 'package:keneth_frequency/application/settings/settings_notifier.dart';
import 'package:keneth_frequency/domain/entities/frequency_point.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/domain/entities/pickup_measurement.dart';
import 'package:keneth_frequency/domain/entities/pickup_type.dart';
import 'package:keneth_frequency/infrastructure/audio/audio_device_info.dart';
import 'package:keneth_frequency/infrastructure/audio/audio_service_interface.dart';
import 'package:keneth_frequency/infrastructure/storage/app_database.dart';
import 'package:keneth_frequency/ui/screens/results_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Fake audio service ────────────────────────────────────────────────────────

class _FakeAudioService implements AudioServiceInterface {
  @override
  Future<void> closeSession() async {}

  @override
  Future<List<AudioDeviceInfo>> getDevices() async => [];

  @override
  Future<dynamic> openSession(String deviceId, double sampleRate) async =>
      false;

  @override
  Future<Float32List> playSweepAndRecord(
          Float32List sweepSamples, int outputChannel, int inputChannel) =>
      throw UnimplementedError();

  @override
  Stream<double> get levelStream => const Stream.empty();

  @override Future<void> startMonitoring() async {}
  @override Future<void> stopMonitoring() async {}
}

// ── Test session notifier ─────────────────────────────────────────────────────

/// A [SessionNotifier] subclass that starts in a fixed [_initialState].
class _TestSessionNotifier extends Notifier<SessionState>
    implements SessionNotifier {
  _TestSessionNotifier(this._initialState);

  final SessionState _initialState;

  @override
  SessionState build() => _initialState;

  // Stubbed methods — not invoked by the widget tests below.
  @override
  void startSession() {}
  @override
  void submitSetup(PickupType type, String pickupName) {}
  @override
  void submitDcr(double dcr, double tempC) {}
  @override
  void startCalibration() {}
  @override
  void updateCalibrationProgress(double progress) {}
  @override
  void calibrationComplete() {}
  @override
  void startMeasurement() {}
  @override
  void updateMeasurementProgress(double progress) {}
  @override
  void measurementComplete(PickupMeasurement measurement) {}
  @override
  void saveResult() {}
  @override
  void reset() {}
  @override void discardAndRemeasure() {}
  @override
  Future<void> cancelSession() async {}
  @override
  Future<void> runCalibration() async {}
  @override
  Future<void> runMeasurement() async {}
  @override
  Future<void> startLevelMonitoring() async {}

  @override
  PickupType get accumulatedType => PickupType.unknown;
  @override
  String get accumulatedPickupName => '';
  @override
  double get accumulatedDcr => 0;
  @override
  double get accumulatedTempC => 20;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

FrequencyResponse _syntheticResponse({double peakHz = 4780.0, int n = 60}) {
  final points = <FrequencyPoint>[];
  for (var i = 0; i <= n; i++) {
    final hz = 20.0 * math.pow(1000.0, i / n);
    final ratio = hz / peakHz;
    final denom = (1 - ratio * ratio) * (1 - ratio * ratio) +
        (ratio / 4.0) * (ratio / 4.0);
    final db = -10 * math.log(denom) / math.ln10;
    points
        .add(FrequencyPoint(frequency: hz, magnitude: db.clamp(-40.0, 20.0)));
  }
  return FrequencyResponse(points);
}

PickupMeasurement _fakeMeasurement() => PickupMeasurement(
      id: 'id1',
      timestamp: DateTime.utc(2026, 4, 16),
      type: PickupType.humbuckerMediumOutput,
      pickupName: 'SH-4',
      dcr: 16000,
      ambientTempC: 21.0,
      resonantFrequency: 4780.0,
      qFactor: 3.2,
      peakAmplitudeDb: 12.0,
      response: _syntheticResponse(),
      calibrationApplied: true,
    );

/// Pumps [ResultsScreen] with [sessionState] injected via an override.
Future<void> _pumpResults(
  WidgetTester tester,
  SessionState sessionState,
) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase.forTesting();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        audioServiceProvider.overrideWithValue(_FakeAudioService()),
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
        sessionNotifierProvider.overrideWith(
          () => _TestSessionNotifier(sessionState),
        ),
      ],
      child: const MaterialApp(home: ResultsScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

// ── S9-13: SNR warning banner ─────────────────────────────────────────────────

void main() {
  group('ResultsScreen — S9-13 SNR warning banner', () {
    testWidgets('banner visible when snrDb < 10', (tester) async {
      await _pumpResults(
        tester,
        ResultsState(
          measurement: _fakeMeasurement(),
          snrDb: 5.0,
        ),
      );

      expect(find.byKey(const Key('snr_warning_banner')), findsOneWidget);
      expect(find.textContaining('Low signal-to-noise'), findsOneWidget);
    });

    testWidgets('banner not shown when snrDb >= 10', (tester) async {
      await _pumpResults(
        tester,
        ResultsState(
          measurement: _fakeMeasurement(),
          snrDb: 15.0,
        ),
      );

      expect(find.byKey(const Key('snr_warning_banner')), findsNothing);
    });

    testWidgets('banner not shown when snrDb is null', (tester) async {
      await _pumpResults(
        tester,
        ResultsState(measurement: _fakeMeasurement()),
      );

      expect(find.byKey(const Key('snr_warning_banner')), findsNothing);
    });
  });

  // ── S9-14: Clip warning banner ───────────────────────────────────────────

  group('ResultsScreen — S9-14 clip warning banner', () {
    testWidgets('banner visible when clipWarning is true', (tester) async {
      await _pumpResults(
        tester,
        ResultsState(
          measurement: _fakeMeasurement(),
          clipWarning: true,
        ),
      );

      expect(find.byKey(const Key('clip_warning_banner')), findsOneWidget);
      expect(find.textContaining('clipped'), findsOneWidget);
    });

    testWidgets('banner not shown when clipWarning is false', (tester) async {
      await _pumpResults(
        tester,
        ResultsState(measurement: _fakeMeasurement()),
      );

      expect(find.byKey(const Key('clip_warning_banner')), findsNothing);
    });
  });

  // ── S9-15 (derived): No-peak-detected state ──────────────────────────────

  group('ResultsScreen — no-peak-detected state', () {
    testWidgets('shows no_peak_label when noPeakDetected is true',
        (tester) async {
      await _pumpResults(
        tester,
        ResultsState(
          measurement: _fakeMeasurement(),
          noPeakDetected: true,
        ),
      );

      expect(find.byKey(const Key('no_peak_label')), findsOneWidget);
      expect(find.textContaining('No Resonant Peak'), findsOneWidget);
    });

    testWidgets('normal results shown when noPeakDetected is false',
        (tester) async {
      await _pumpResults(
        tester,
        ResultsState(measurement: _fakeMeasurement()),
      );

      expect(find.byKey(const Key('resonant_frequency_display')), findsOneWidget);
      expect(find.byKey(const Key('no_peak_label')), findsNothing);
    });
  });

  // ── Uncalibrated banner ──────────────────────────────────────────────────

  group('ResultsScreen — uncalibrated banner', () {
    testWidgets('banner visible when calibrationApplied is false',
        (tester) async {
      final m = PickupMeasurement(
        id: 'id2',
        timestamp: DateTime.utc(2026, 4, 16),
        type: PickupType.singleCoilStrat,
        pickupName: 'Strat',
        dcr: 6200,
        ambientTempC: 21.0,
        resonantFrequency: 5500.0,
        qFactor: 3.5,
        peakAmplitudeDb: 10.0,
        response: _syntheticResponse(peakHz: 5500.0),
        calibrationApplied: false,
      );

      await _pumpResults(tester, ResultsState(measurement: m));

      expect(find.byKey(const Key('uncalibrated_banner')), findsOneWidget);
      expect(find.textContaining('uncalibrated'), findsOneWidget);
    });
  });

  // ── Export button present ────────────────────────────────────────────────

  group('ResultsScreen — export button', () {
    testWidgets('export button is present in AppBar', (tester) async {
      await _pumpResults(
        tester,
        ResultsState(measurement: _fakeMeasurement()),
      );

      expect(find.byKey(const Key('export_button')), findsOneWidget);
    });
  });
}
