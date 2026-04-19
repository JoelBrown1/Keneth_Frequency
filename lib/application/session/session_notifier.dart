import 'package:flutter/foundation.dart' show compute;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/calibration_data.dart';
import '../../domain/entities/frequency_response.dart';
import '../../domain/entities/pickup_measurement.dart';
import '../../domain/entities/pickup_type.dart';
import '../../domain/services/lc_calculator.dart';
import '../../domain/services/peak_detector.dart';
import '../../domain/services/pickup_reference_data.dart';
import '../../domain/services/sweep_generator.dart';
import '../../infrastructure/audio/audio_service_interface.dart';
import '../../infrastructure/audio/macos_audio_service.dart';
import '../../infrastructure/dsp/dsp_pipeline.dart';
import '../providers/calibration_provider.dart';
import '../providers/database_providers.dart';
import '../settings/settings_notifier.dart';
import 'session_state.dart';

part 'session_notifier.g.dart';

/// Provides the singleton [AudioServiceInterface] used by [SessionNotifier].
///
/// Override in tests to inject a fake audio service.
@Riverpod(keepAlive: true)
AudioServiceInterface audioService(AudioServiceRef ref) => MacosAudioService();

/// Manages the measurement session FSM.
///
/// Internal accumulators carry data across states so that state classes
/// remain minimal (matching the arch doc sealed hierarchy).
@Riverpod(keepAlive: true)
class SessionNotifier extends _$SessionNotifier {
  // Accumulated across forward transitions; cleared on cancel/reset.
  PickupType _type = PickupType.unknown;
  String _pickupName = '';
  double _dcr = 0;
  double _tempC = 20;

  @override
  SessionState build() => const IdleState();

  // ── Forward transitions ──────────────────────────────────────────────────

  /// Idle → PickupSetup.
  void startSession() => state = const PickupSetupState();

  /// PickupSetup → DcrEntry.
  void submitSetup(PickupType type, String pickupName) {
    _type = type;
    _pickupName = pickupName;
    state = DcrEntryState(type: type, pickupName: pickupName);
  }

  /// Updates the stored DCR and temperature values and refreshes [DcrEntryState]
  /// so the UI can display a live corrected-DCR value. Does not advance the FSM.
  void submitDcr(double dcr, double tempC) {
    final s = state;
    if (s is! DcrEntryState) return;
    _dcr = dcr;
    _tempC = tempC;
    state = DcrEntryState(
      type: s.type,
      pickupName: s.pickupName,
      dcr: dcr,
      tempC: tempC,
    );
  }

  /// DcrEntry → Calibrating (progress = 0). FSM-only; use [runCalibration] for
  /// the full audio sweep.
  void startCalibration() => state = const CalibratingState(progress: 0);

  /// Updates calibration progress (0.0–1.0) without advancing the FSM.
  void updateCalibrationProgress(double progress) =>
      state = CalibratingState(progress: progress.clamp(0.0, 1.0));

  /// Calibrating → Measuring (progress = 0).
  void calibrationComplete() => state = const MeasuringState(progress: 0);

  /// Measuring (alias; starts the sweep at progress = 0).
  void startMeasurement() => state = const MeasuringState(progress: 0);

  /// Updates measurement progress (0.0–1.0) without advancing the FSM.
  void updateMeasurementProgress(double progress) =>
      state = MeasuringState(progress: progress.clamp(0.0, 1.0));

  /// Measuring → Processing → Results.
  ///
  /// Transitions through [ProcessingState] synchronously before settling on
  /// [ResultsState] so the UI can show a brief "processing" indicator.
  void measurementComplete(PickupMeasurement measurement) {
    state = const ProcessingState();
    state = ResultsState(measurement: measurement);
  }

  /// Results → Idle (after saving).
  void saveResult() => _resetAccumulator();

  /// Results → Idle (without saving).
  void reset() => _resetAccumulator();

  // ── Cancel (H-03) ────────────────────────────────────────────────────────

  /// Closes the audio session and resets the FSM to [IdleState] from any state.
  ///
  /// Safe to call even when idle (no-op on the audio layer).
  Future<void> cancelSession() async {
    await ref.read(audioServiceProvider).closeSession();
    _resetAccumulator();
  }

  // ── Orchestration ────────────────────────────────────────────────────────

  /// Runs the full calibration sweep (DcrEntry → Calibrating → Measuring).
  ///
  /// 1. Opens audio session on the first Scarlett device found.
  /// 2. Generates a log-chirp sweep per current [AppSettings].
  /// 3. Plays sweep and records with the 1 MΩ reference load in place.
  /// 4. Runs FFT in an Isolate (no native pointers cross the boundary).
  /// 5. Saves [CalibrationData] to [CalibrationRepository].
  /// 6. Transitions to [MeasuringState].
  ///
  /// On error, resets progress to 0 so the user can retry.
  Future<void> runCalibration() async {
    final audio = ref.read(audioServiceProvider);
    final settings = ref.read(settingsNotifierProvider);
    final calRepo = ref.read(calibrationRepositoryProvider);
    const sampleRate = 48000;

    state = const CalibratingState(progress: 0.0);
    try {
      // 1. Open audio session.
      final devices = await audio.getDevices();
      final device = devices.firstWhere(
        (d) => d.isScarlett,
        orElse: () => throw Exception('No Scarlett device found'),
      );
      await audio.openSession(device.id, sampleRate.toDouble());
      state = const CalibratingState(progress: 0.15);

      // 2. Generate sweep.
      final sweep = const SweepGenerator().generateLogChirp(
        f1: settings.sweepLowFrequencyHz,
        f2: settings.sweepHighFrequencyHz,
        durationSec: settings.sweepDurationSeconds.toDouble(),
        sampleRate: sampleRate,
      );
      state = const CalibratingState(progress: 0.2);

      // 3. Play sweep and record reference (1 MΩ load in place — user's responsibility).
      final recording = await audio.playSweepAndRecord(sweep, 0, 0);
      state = const CalibratingState(progress: 0.85);

      // 4. Run FFT in isolate — no native pointers cross the boundary (C-03).
      final dspOutput = await compute(
        runDspPipeline,
        DspPipelineInput(recordingPcm: recording, sampleRate: sampleRate),
      );
      state = const CalibratingState(progress: 0.95);

      // 5. Save calibration spectrum.
      final calId = DateTime.now().millisecondsSinceEpoch.toString();
      await calRepo.save(
        CalibrationData(
          id: calId,
          timestamp: DateTime.now().toUtc(),
          spectrum: dspOutput.displayResponse.points,
        ),
        label: 'Reference sweep ${DateTime.now().toIso8601String().substring(0, 10)}',
      );
      ref.invalidate(calibrationStatusProvider);

      calibrationComplete(); // → MeasuringState(progress: 0)
    } catch (_) {
      state = const CalibratingState(progress: 0.0);
      rethrow;
    }
  }

  /// Runs the full measurement sweep (Measuring → Processing → Results).
  ///
  /// 1. Generates a log-chirp sweep per current [AppSettings].
  /// 2. Plays sweep and records the pickup response.
  /// 3. Runs DSP in an Isolate, applying the latest calibration.
  /// 4. Builds a [PickupMeasurement] with all derived values.
  /// 5. Saves the measurement to [MeasurementRepository].
  /// 6. Transitions to [ResultsState] with DSP warning flags.
  ///
  /// On error, resets progress to 0 so the user can retry.
  Future<void> runMeasurement() async {
    final audio = ref.read(audioServiceProvider);
    final settings = ref.read(settingsNotifierProvider);
    final measureRepo = ref.read(measurementRepositoryProvider);
    final calStatus = await ref.read(calibrationStatusProvider.future);
    const sampleRate = 48000;

    state = const MeasuringState(progress: 0.0);
    try {
      // 1. Generate sweep.
      final sweep = const SweepGenerator().generateLogChirp(
        f1: settings.sweepLowFrequencyHz,
        f2: settings.sweepHighFrequencyHz,
        durationSec: settings.sweepDurationSeconds.toDouble(),
        sampleRate: sampleRate,
      );
      state = const MeasuringState(progress: 0.15);

      // 2. Play sweep and record pickup response.
      final recording = await audio.playSweepAndRecord(sweep, 0, 0);
      state = const MeasuringState(progress: 0.7);

      // Build CalibrationData from stored spectrum for the DSP pipeline.
      final calData = calStatus.latest != null
          ? CalibrationData(
              id: calStatus.latest!.id,
              timestamp: calStatus.latest!.timestamp,
              spectrum: calStatus.latest!.spectrum,
            )
          : null;

      // 3. Run DSP in isolate.
      final dspOutput = await compute(
        runDspPipeline,
        DspPipelineInput(
          recordingPcm: recording,
          sampleRate: sampleRate,
          calibration: calData,
        ),
      );
      state = const MeasuringState(progress: 0.9);

      // 4. Find resonant peak with pickup-type search range.
      final peak = PeakDetector().findResonantPeak(
        dspOutput.displayResponse,
        type: _type,
      );
      final noPeak = peak == null;
      final fRes = peak?.frequency ?? 0.0;

      // 5. Derive LC values using midpoint inductance from reference data.
      final profile = PickupReferenceData.forType(_type);
      double? inductance, capacitance;
      if (peak != null && profile != null && profile.inductanceRangeH.min > 0) {
        inductance =
            (profile.inductanceRangeH.min + profile.inductanceRangeH.max) / 2.0;
        capacitance = const LcCalculator().solveCapacitance(fRes, inductance);
      }

      // 6. Temperature-corrected DCR.
      final dcrCorrected = const LcCalculator()
          .correctDcrForTemperature(_dcr, _tempC);

      // 7. Build measurement entity.
      final measurement = PickupMeasurement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now().toUtc(),
        type: _type,
        pickupName: _pickupName,
        dcr: _dcr,
        ambientTempC: _tempC,
        resonantFrequency: fRes,
        qFactor: peak?.qFactor ?? 0.0,
        peakAmplitudeDb: peak?.amplitudeDb ?? 0.0,
        response: dspOutput.displayResponse,
        calibrationApplied: calData != null,
        dcrCorrected: dcrCorrected,
        inductance: inductance,
        capacitance: capacitance,
      );

      // 8. Persist to storage.
      await measureRepo.save(
        measurement,
        storageResponse: dspOutput.storageResponse,
      );

      // 9. Transition to Results.
      state = const ProcessingState();
      state = ResultsState(
        measurement: measurement,
        snrDb: dspOutput.snrDb,
        clipWarning: dspOutput.clipWarning,
        noPeakDetected: noPeak,
      );
    } catch (_) {
      state = const MeasuringState(progress: 0.0);
      rethrow;
    }
  }

  // ── Private ──────────────────────────────────────────────────────────────

  void _resetAccumulator() {
    _type = PickupType.unknown;
    _pickupName = '';
    _dcr = 0;
    _tempC = 20;
    state = const IdleState();
  }

  // ── Accumulated values (readable by the UI layer) ────────────────────────

  PickupType get accumulatedType => _type;
  String get accumulatedPickupName => _pickupName;
  double get accumulatedDcr => _dcr;
  double get accumulatedTempC => _tempC;
}
