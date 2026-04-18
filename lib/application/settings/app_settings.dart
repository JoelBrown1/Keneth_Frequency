import '../../domain/entities/pickup_type.dart';

enum SmoothingResolution { third, sixth, twelfth, none }

enum TemperatureUnit { celsius, fahrenheit }

enum ExportFormat { csv, json }

/// Immutable snapshot of all user-configurable preferences.
///
/// All fields have sensible defaults for first-run; [SettingsNotifier] persists
/// changes to `shared_preferences` and exposes this model to the UI.
class AppSettings {
  const AppSettings({
    this.sweepDurationSeconds = 20,
    this.sweepLowFrequencyHz = 20.0,
    this.sweepHighFrequencyHz = 20000.0,
    this.outputLevelDbfs = -12.0,
    this.smoothingResolution = SmoothingResolution.sixth,
    this.calibrationWarningThresholdHours = 24,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.defaultPickupType = PickupType.unknown,
    this.exportFormat = ExportFormat.csv,
  });

  /// Duration of the log-chirp sweep (10–30 s). Longer → better SNR.
  final int sweepDurationSeconds;

  /// Lower bound of the log-chirp sweep (Hz).
  final double sweepLowFrequencyHz;

  /// Upper bound of the log-chirp sweep (Hz).
  final double sweepHighFrequencyHz;

  /// Drive level sent to the exciter coil (dBFS, −18 to −6).
  final double outputLevelDbfs;

  /// Fractional-octave smoothing applied to the display response.
  final SmoothingResolution smoothingResolution;

  /// Hours after which a calibration is considered stale and a warning shown.
  final int calibrationWarningThresholdHours;

  final TemperatureUnit temperatureUnit;

  /// Pre-selects pickup type on the setup screen.
  final PickupType defaultPickupType;

  final ExportFormat exportFormat;

  AppSettings copyWith({
    int? sweepDurationSeconds,
    double? sweepLowFrequencyHz,
    double? sweepHighFrequencyHz,
    double? outputLevelDbfs,
    SmoothingResolution? smoothingResolution,
    int? calibrationWarningThresholdHours,
    TemperatureUnit? temperatureUnit,
    PickupType? defaultPickupType,
    ExportFormat? exportFormat,
  }) {
    return AppSettings(
      sweepDurationSeconds:
          sweepDurationSeconds ?? this.sweepDurationSeconds,
      sweepLowFrequencyHz: sweepLowFrequencyHz ?? this.sweepLowFrequencyHz,
      sweepHighFrequencyHz:
          sweepHighFrequencyHz ?? this.sweepHighFrequencyHz,
      outputLevelDbfs: outputLevelDbfs ?? this.outputLevelDbfs,
      smoothingResolution: smoothingResolution ?? this.smoothingResolution,
      calibrationWarningThresholdHours: calibrationWarningThresholdHours ??
          this.calibrationWarningThresholdHours,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      defaultPickupType: defaultPickupType ?? this.defaultPickupType,
      exportFormat: exportFormat ?? this.exportFormat,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.sweepDurationSeconds == sweepDurationSeconds &&
      other.sweepLowFrequencyHz == sweepLowFrequencyHz &&
      other.sweepHighFrequencyHz == sweepHighFrequencyHz &&
      other.outputLevelDbfs == outputLevelDbfs &&
      other.smoothingResolution == smoothingResolution &&
      other.calibrationWarningThresholdHours ==
          calibrationWarningThresholdHours &&
      other.temperatureUnit == temperatureUnit &&
      other.defaultPickupType == defaultPickupType &&
      other.exportFormat == exportFormat;

  @override
  int get hashCode => Object.hash(
        sweepDurationSeconds,
        sweepLowFrequencyHz,
        sweepHighFrequencyHz,
        outputLevelDbfs,
        smoothingResolution,
        calibrationWarningThresholdHours,
        temperatureUnit,
        defaultPickupType,
        exportFormat,
      );
}
