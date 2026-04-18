import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/calibration_data.dart';
import '../providers/database_providers.dart';
import '../settings/settings_notifier.dart';

part 'calibration_provider.g.dart';

/// The result of a calibration freshness check.
class CalibrationStatus {
  const CalibrationStatus({required this.latest, required this.isStale});

  /// The most recent calibration, or `null` if none has been saved.
  final CalibrationData? latest;

  /// `true` when [latest] is older than the configured threshold or absent.
  final bool isStale;
}

/// Fetches the latest calibration and its staleness status.
///
/// Invalidate with `ref.invalidate(calibrationStatusProvider)` after saving
/// a new calibration.
@riverpod
Future<CalibrationStatus> calibrationStatus(CalibrationStatusRef ref) async {
  final repo = ref.read(calibrationRepositoryProvider);
  final settings = ref.read(settingsNotifierProvider);
  final latest = await repo.getLatest();
  final stale = await repo.isStale(
      thresholdHours: settings.calibrationWarningThresholdHours);
  return CalibrationStatus(latest: latest, isStale: stale);
}
