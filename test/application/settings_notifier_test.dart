import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keneth_frequency/application/settings/app_settings.dart';
import 'package:keneth_frequency/application/settings/settings_notifier.dart';
import 'package:keneth_frequency/domain/entities/pickup_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Test helpers ──────────────────────────────────────────────────────────────

/// Creates a [ProviderContainer] with mock SharedPreferences.
///
/// Must be called after `SharedPreferences.setMockInitialValues({})`.
Future<ProviderContainer> _makeContainer() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  return ProviderContainer(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
  ]);
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  // ── Default values (S5-14) ────────────────────────────────────────────────

  group('default values', () {
    late ProviderContainer container;

    setUp(() async => container = await _makeContainer());
    tearDown(() => container.dispose());

    test('sweepDurationSeconds defaults to 20', () {
      expect(
          container.read(settingsNotifierProvider).sweepDurationSeconds, 20);
    });

    test('sweepLowFrequencyHz defaults to 20.0', () {
      expect(container.read(settingsNotifierProvider).sweepLowFrequencyHz,
          closeTo(20.0, 0.001));
    });

    test('sweepHighFrequencyHz defaults to 20000.0', () {
      expect(container.read(settingsNotifierProvider).sweepHighFrequencyHz,
          closeTo(20000.0, 0.001));
    });

    test('outputLevelDbfs defaults to -12.0', () {
      expect(container.read(settingsNotifierProvider).outputLevelDbfs,
          closeTo(-12.0, 0.001));
    });

    test('smoothingResolution defaults to sixth', () {
      expect(container.read(settingsNotifierProvider).smoothingResolution,
          SmoothingResolution.sixth);
    });

    test('calibrationWarningThresholdHours defaults to 24', () {
      expect(
          container
              .read(settingsNotifierProvider)
              .calibrationWarningThresholdHours,
          24);
    });

    test('temperatureUnit defaults to celsius', () {
      expect(container.read(settingsNotifierProvider).temperatureUnit,
          TemperatureUnit.celsius);
    });

    test('defaultPickupType defaults to unknown', () {
      expect(container.read(settingsNotifierProvider).defaultPickupType,
          PickupType.unknown);
    });

    test('exportFormat defaults to csv', () {
      expect(container.read(settingsNotifierProvider).exportFormat,
          ExportFormat.csv);
    });
  });

  // ── Persistence round trip (S5-14) ────────────────────────────────────────

  group('persistence round trip', () {
    test('setSweepDuration updates state and SharedPreferences', () async {
      final container = await _makeContainer();
      await container
          .read(settingsNotifierProvider.notifier)
          .setSweepDuration(30);
      expect(
          container.read(settingsNotifierProvider).sweepDurationSeconds, 30);

      // Verify SharedPreferences was written — a new container over the same
      // prefs instance reads the updated value.
      final prefs = container.read(sharedPreferencesProvider);
      final container2 = ProviderContainer(overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ]);
      expect(
          container2.read(settingsNotifierProvider).sweepDurationSeconds, 30);
      container2.dispose();
      container.dispose();
    });

    test('setSmoothing updates state', () async {
      final container = await _makeContainer();
      await container
          .read(settingsNotifierProvider.notifier)
          .setSmoothing(SmoothingResolution.third);
      expect(container.read(settingsNotifierProvider).smoothingResolution,
          SmoothingResolution.third);
      container.dispose();
    });

    test('setOutputLevel updates state', () async {
      final container = await _makeContainer();
      await container
          .read(settingsNotifierProvider.notifier)
          .setOutputLevel(-18.0);
      expect(container.read(settingsNotifierProvider).outputLevelDbfs,
          closeTo(-18.0, 0.001));
      container.dispose();
    });

    test('setTemperatureUnit updates state', () async {
      final container = await _makeContainer();
      await container
          .read(settingsNotifierProvider.notifier)
          .setTemperatureUnit(TemperatureUnit.fahrenheit);
      expect(container.read(settingsNotifierProvider).temperatureUnit,
          TemperatureUnit.fahrenheit);
      container.dispose();
    });

    test('setDefaultPickupType updates state', () async {
      final container = await _makeContainer();
      await container
          .read(settingsNotifierProvider.notifier)
          .setDefaultPickupType(PickupType.humbuckerHighOutput);
      expect(container.read(settingsNotifierProvider).defaultPickupType,
          PickupType.humbuckerHighOutput);
      container.dispose();
    });

    test('setExportFormat updates state', () async {
      final container = await _makeContainer();
      await container
          .read(settingsNotifierProvider.notifier)
          .setExportFormat(ExportFormat.json);
      expect(container.read(settingsNotifierProvider).exportFormat,
          ExportFormat.json);
      container.dispose();
    });

    test('setCalibrationWarningThreshold updates state', () async {
      final container = await _makeContainer();
      await container
          .read(settingsNotifierProvider.notifier)
          .setCalibrationWarningThreshold(48);
      expect(
          container
              .read(settingsNotifierProvider)
              .calibrationWarningThresholdHours,
          48);
      container.dispose();
    });

    test('multiple settings persist independently', () async {
      final container = await _makeContainer();
      final notifier = container.read(settingsNotifierProvider.notifier);
      await notifier.setSweepDuration(10);
      await notifier.setOutputLevel(-6.0);
      await notifier.setExportFormat(ExportFormat.json);

      final s = container.read(settingsNotifierProvider);
      expect(s.sweepDurationSeconds, 10);
      expect(s.outputLevelDbfs, closeTo(-6.0, 0.001));
      expect(s.exportFormat, ExportFormat.json);
      // Unmodified fields still at defaults.
      expect(s.smoothingResolution, SmoothingResolution.sixth);
      container.dispose();
    });
  });

  // ── AppSettings equality / copyWith ───────────────────────────────────────

  group('AppSettings', () {
    test('default instances are equal', () {
      expect(const AppSettings(), equals(const AppSettings()));
    });

    test('copyWith changes only the specified field', () {
      const original = AppSettings();
      final modified = original.copyWith(sweepDurationSeconds: 10);
      expect(modified.sweepDurationSeconds, 10);
      expect(modified.outputLevelDbfs, original.outputLevelDbfs);
      expect(modified.smoothingResolution, original.smoothingResolution);
    });

    test('copyWith with no args returns equal object', () {
      expect(const AppSettings().copyWith(), equals(const AppSettings()));
    });

    test('instances differing in one field are not equal', () {
      const a = AppSettings();
      final b = a.copyWith(sweepDurationSeconds: 10);
      expect(a, isNot(equals(b)));
    });
  });
}
