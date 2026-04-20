import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/application/session/session_notifier.dart';
import 'package:keneth_frequency/application/session/session_state.dart';
import 'package:keneth_frequency/domain/entities/frequency_response.dart';
import 'package:keneth_frequency/domain/entities/pickup_measurement.dart';
import 'package:keneth_frequency/domain/entities/pickup_type.dart';
import 'package:keneth_frequency/infrastructure/audio/audio_device_info.dart';
import 'package:keneth_frequency/infrastructure/audio/audio_service_interface.dart';

// ── Fake audio service ────────────────────────────────────────────────────────

class _FakeAudioService implements AudioServiceInterface {
  bool closeSessionCalled = false;

  @override
  Future<void> closeSession() async => closeSessionCalled = true;

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

// ── Helpers ───────────────────────────────────────────────────────────────────

ProviderContainer _makeContainer(_FakeAudioService fake) {
  return ProviderContainer(overrides: [
    audioServiceProvider.overrideWithValue(fake),
  ]);
}

PickupMeasurement _fakeMeasurement() => PickupMeasurement(
      id: 'test',
      timestamp: DateTime.utc(2026, 4, 17),
      type: PickupType.humbuckerMediumOutput,
      pickupName: 'Test',
      dcr: 8000,
      ambientTempC: 22,
      resonantFrequency: 4780,
      qFactor: 3.2,
      peakAmplitudeDb: -18,
      calibrationApplied: false,
      response: const FrequencyResponse([]),
    );

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late _FakeAudioService fake;
  late ProviderContainer container;
  late SessionNotifier notifier;

  setUp(() {
    fake = _FakeAudioService();
    container = _makeContainer(fake);
    notifier = container.read(sessionNotifierProvider.notifier);
  });

  tearDown(() => container.dispose());

  // ── Initial state ─────────────────────────────────────────────────────────

  test('initial state is IdleState', () {
    expect(container.read(sessionNotifierProvider), isA<IdleState>());
  });

  // ── Forward transitions (S5-12) ───────────────────────────────────────────

  group('forward transitions', () {
    test('startSession → PickupSetupState', () {
      notifier.startSession();
      expect(container.read(sessionNotifierProvider), isA<PickupSetupState>());
    });

    test('submitSetup → DcrEntryState with correct type and name', () {
      notifier.startSession();
      notifier.submitSetup(PickupType.singleCoilStrat, 'My Strat');
      final s = container.read(sessionNotifierProvider);
      expect(s, isA<DcrEntryState>());
      final d = s as DcrEntryState;
      expect(d.type, PickupType.singleCoilStrat);
      expect(d.pickupName, 'My Strat');
    });

    test('submitDcr updates DcrEntryState without advancing FSM', () {
      notifier.startSession();
      notifier.submitSetup(PickupType.p90, 'P90');
      notifier.submitDcr(9000, 25.0);
      final s = container.read(sessionNotifierProvider);
      expect(s, isA<DcrEntryState>());
      final d = s as DcrEntryState;
      expect(d.dcr, closeTo(9000, 0.01));
      expect(d.tempC, closeTo(25.0, 0.01));
    });

    test('startCalibration → CalibratingState at progress 0', () {
      notifier.startSession();
      notifier.submitSetup(PickupType.p90, 'P90');
      notifier.startCalibration();
      final s = container.read(sessionNotifierProvider);
      expect(s, isA<CalibratingState>());
      expect((s as CalibratingState).progress, closeTo(0, 0.001));
    });

    test('updateCalibrationProgress clamps to 0–1', () {
      notifier.startSession();
      notifier.submitSetup(PickupType.p90, 'P90');
      notifier.startCalibration();
      notifier.updateCalibrationProgress(0.5);
      expect(
          (container.read(sessionNotifierProvider) as CalibratingState).progress,
          closeTo(0.5, 0.001));
      notifier.updateCalibrationProgress(2.0); // clamps to 1.0
      expect(
          (container.read(sessionNotifierProvider) as CalibratingState).progress,
          closeTo(1.0, 0.001));
    });

    test('calibrationComplete → MeasuringState at progress 0', () {
      notifier.startSession();
      notifier.submitSetup(PickupType.p90, 'P90');
      notifier.startCalibration();
      notifier.calibrationComplete();
      expect(container.read(sessionNotifierProvider), isA<MeasuringState>());
    });

    test('measurementComplete → ProcessingState then ResultsState', () {
      notifier.startSession();
      notifier.submitSetup(PickupType.humbuckerMediumOutput, 'HB');
      notifier.startCalibration();
      notifier.calibrationComplete();
      notifier.measurementComplete(_fakeMeasurement());
      final s = container.read(sessionNotifierProvider);
      expect(s, isA<ResultsState>());
      expect((s as ResultsState).measurement.pickupName, 'Test');
    });

    test('saveResult → IdleState', () {
      notifier.startSession();
      notifier.submitSetup(PickupType.humbuckerMediumOutput, 'HB');
      notifier.startCalibration();
      notifier.calibrationComplete();
      notifier.measurementComplete(_fakeMeasurement());
      notifier.saveResult();
      expect(container.read(sessionNotifierProvider), isA<IdleState>());
    });

    test('reset → IdleState', () {
      notifier.startSession();
      notifier.submitSetup(PickupType.humbuckerMediumOutput, 'HB');
      notifier.startCalibration();
      notifier.calibrationComplete();
      notifier.measurementComplete(_fakeMeasurement());
      notifier.reset();
      expect(container.read(sessionNotifierProvider), isA<IdleState>());
    });
  });

  // ── cancelSession from every state (S5-13, H-03) ─────────────────────────

  group('cancelSession', () {
    Future<void> expectCancelsToIdle(void Function() setupState) async {
      setupState();
      await notifier.cancelSession();
      expect(container.read(sessionNotifierProvider), isA<IdleState>());
      expect(fake.closeSessionCalled, isTrue);
    }

    test('from IdleState → IdleState, closeSession called', () async {
      // Already idle.
      await notifier.cancelSession();
      expect(container.read(sessionNotifierProvider), isA<IdleState>());
      expect(fake.closeSessionCalled, isTrue);
    });

    test('from PickupSetupState → IdleState', () async {
      await expectCancelsToIdle(notifier.startSession);
    });

    test('from DcrEntryState → IdleState', () async {
      await expectCancelsToIdle(() {
        notifier.startSession();
        notifier.submitSetup(PickupType.p90, 'P90');
      });
    });

    test('from CalibratingState → IdleState', () async {
      await expectCancelsToIdle(() {
        notifier.startSession();
        notifier.submitSetup(PickupType.p90, 'P90');
        notifier.startCalibration();
      });
    });

    test('from MeasuringState → IdleState', () async {
      await expectCancelsToIdle(() {
        notifier.startSession();
        notifier.submitSetup(PickupType.p90, 'P90');
        notifier.startCalibration();
        notifier.calibrationComplete();
      });
    });

    test('from ResultsState → IdleState', () async {
      await expectCancelsToIdle(() {
        notifier.startSession();
        notifier.submitSetup(PickupType.humbuckerMediumOutput, 'HB');
        notifier.startCalibration();
        notifier.calibrationComplete();
        notifier.measurementComplete(_fakeMeasurement());
      });
    });

    test('accumulator is cleared after cancel', () async {
      notifier.startSession();
      notifier.submitSetup(PickupType.singleCoilStrat, 'Strat');
      notifier.submitDcr(6000, 22.0);
      await notifier.cancelSession();
      expect(notifier.accumulatedType, PickupType.unknown);
      expect(notifier.accumulatedPickupName, isEmpty);
      expect(notifier.accumulatedDcr, closeTo(0, 0.001));
    });
  });
}
