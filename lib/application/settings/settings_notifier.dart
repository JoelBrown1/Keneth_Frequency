import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/pickup_type.dart';
import 'app_settings.dart';

part 'settings_notifier.g.dart';

// Shared-preferences key constants.
const _kSweepDuration = 'sweep_duration_seconds';
const _kSweepLow = 'sweep_low_hz';
const _kSweepHigh = 'sweep_high_hz';
const _kOutputLevel = 'output_level_dbfs';
const _kSmoothing = 'smoothing_resolution';
const _kCalWarning = 'calibration_warning_hours';
const _kTempUnit = 'temperature_unit';
const _kDefaultType = 'default_pickup_type';
const _kExportFormat = 'export_format';

/// Provides the [SharedPreferences] instance.
///
/// Override in `main.dart` (after `await SharedPreferences.getInstance()`)
/// and in tests via `SharedPreferences.setMockInitialValues({})`.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) =>
    throw UnimplementedError(
        'sharedPreferencesProvider must be overridden before use');

/// Persists and exposes [AppSettings].
///
/// Reads all values from [SharedPreferences] on construction; each setter
/// writes the updated field immediately.
@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  AppSettings build() {
    final prefs = _prefs;
    return AppSettings(
      sweepDurationSeconds: prefs.getInt(_kSweepDuration) ?? 20,
      sweepLowFrequencyHz: prefs.getDouble(_kSweepLow) ?? 20.0,
      sweepHighFrequencyHz: prefs.getDouble(_kSweepHigh) ?? 20000.0,
      outputLevelDbfs: prefs.getDouble(_kOutputLevel) ?? -12.0,
      smoothingResolution: SmoothingResolution.values[
          prefs.getInt(_kSmoothing) ??
              SmoothingResolution.sixth.index],
      calibrationWarningThresholdHours: prefs.getInt(_kCalWarning) ?? 24,
      temperatureUnit: TemperatureUnit.values[
          prefs.getInt(_kTempUnit) ?? TemperatureUnit.celsius.index],
      defaultPickupType: PickupType.values[
          prefs.getInt(_kDefaultType) ?? PickupType.unknown.index],
      exportFormat: ExportFormat.values[
          prefs.getInt(_kExportFormat) ?? ExportFormat.csv.index],
    );
  }

  Future<void> setSweepDuration(int seconds) async {
    await _prefs.setInt(_kSweepDuration, seconds);
    state = state.copyWith(sweepDurationSeconds: seconds);
  }

  Future<void> setSweepLowFrequency(double hz) async {
    await _prefs.setDouble(_kSweepLow, hz);
    state = state.copyWith(sweepLowFrequencyHz: hz);
  }

  Future<void> setSweepHighFrequency(double hz) async {
    await _prefs.setDouble(_kSweepHigh, hz);
    state = state.copyWith(sweepHighFrequencyHz: hz);
  }

  Future<void> setOutputLevel(double dbfs) async {
    await _prefs.setDouble(_kOutputLevel, dbfs);
    state = state.copyWith(outputLevelDbfs: dbfs);
  }

  Future<void> setSmoothing(SmoothingResolution r) async {
    await _prefs.setInt(_kSmoothing, r.index);
    state = state.copyWith(smoothingResolution: r);
  }

  Future<void> setCalibrationWarningThreshold(int hours) async {
    await _prefs.setInt(_kCalWarning, hours);
    state = state.copyWith(calibrationWarningThresholdHours: hours);
  }

  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    await _prefs.setInt(_kTempUnit, unit.index);
    state = state.copyWith(temperatureUnit: unit);
  }

  Future<void> setDefaultPickupType(PickupType type) async {
    await _prefs.setInt(_kDefaultType, type.index);
    state = state.copyWith(defaultPickupType: type);
  }

  Future<void> setExportFormat(ExportFormat format) async {
    await _prefs.setInt(_kExportFormat, format.index);
    state = state.copyWith(exportFormat: format);
  }
}
