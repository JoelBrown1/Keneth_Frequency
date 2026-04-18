import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/pickup_measurement.dart';
import '../../domain/entities/pickup_type.dart';
import '../../infrastructure/audio/audio_service_interface.dart';
import '../../infrastructure/audio/macos_audio_service.dart';
import 'session_state.dart';

part 'session_notifier.g.dart';

/// Provides the singleton [AudioServiceInterface] used by [SessionNotifier].
///
/// Override this in tests to inject a fake audio service.
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

  /// DcrEntry → Calibrating (progress = 0).
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
