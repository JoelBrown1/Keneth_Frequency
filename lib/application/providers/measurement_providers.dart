import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/pickup_measurement.dart';
import '../providers/database_providers.dart';
import '../session/session_notifier.dart';
import '../session/session_state.dart';

part 'measurement_providers.g.dart';

/// All saved measurements ordered newest-first (storage-resolution response).
///
/// Invalidate with `ref.invalidate(measurementHistoryProvider)` after a save
/// to trigger an automatic refresh.
@riverpod
Future<List<PickupMeasurement>> measurementHistory(
    MeasurementHistoryRef ref) =>
    ref.read(measurementRepositoryProvider).getAll();

/// The measurement from the current session's [ResultsState], or `null`.
///
/// Automatically clears when the FSM leaves [ResultsState] (via cancel/reset).
@riverpod
PickupMeasurement? measurementResult(MeasurementResultRef ref) {
  final session = ref.watch(sessionNotifierProvider);
  return switch (session) {
    ResultsState(:final measurement) => measurement,
    _ => null,
  };
}
