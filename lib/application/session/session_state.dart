import '../../domain/entities/pickup_measurement.dart';
import '../../domain/entities/pickup_type.dart';

/// Sealed hierarchy representing every state in the measurement session FSM.
///
/// Transitions:
///   Idle → PickupSetup → DcrEntry → Calibrating → Measuring → Processing → Results
///
/// From any non-idle state, `cancelSession()` returns directly to `IdleState`.
sealed class SessionState {
  const SessionState();
}

/// No session in progress. Initial state and reset target.
class IdleState extends SessionState {
  const IdleState();
}

/// User is selecting pickup type and entering a name.
class PickupSetupState extends SessionState {
  const PickupSetupState();
}

/// User is entering DCR (Ω) and ambient temperature (°C).
///
/// [dcr] and [tempC] are populated after `submitDcr()` is called,
/// allowing the UI to display corrected DCR while the user adjusts values.
class DcrEntryState extends SessionState {
  const DcrEntryState({
    required this.type,
    required this.pickupName,
    this.dcr,
    this.tempC,
  });

  final PickupType type;
  final String pickupName;
  final double? dcr;
  final double? tempC;
}

/// Calibration sweep is running.
class CalibratingState extends SessionState {
  const CalibratingState({required this.progress});

  /// 0.0–1.0 sweep completion.
  final double progress;
}

/// Pickup measurement sweep is running.
class MeasuringState extends SessionState {
  const MeasuringState({required this.progress});

  /// 0.0–1.0 sweep completion.
  final double progress;
}

/// DSP pipeline is running on the recorded buffer (typically < 1 s).
class ProcessingState extends SessionState {
  const ProcessingState();
}

/// Processing complete; results are available for display and saving.
class ResultsState extends SessionState {
  const ResultsState({required this.measurement});

  final PickupMeasurement measurement;
}
