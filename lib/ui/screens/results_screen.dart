import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/providers/measurement_providers.dart';
import '../../application/session/session_notifier.dart';
import '../../application/session/session_state.dart';
import '../../domain/entities/pickup_measurement.dart';
import '../theme/app_theme.dart';
import '../widgets/frequency_response_chart.dart';
import '../widgets/pickup_type_selector.dart'; // provides PickupTypeDisplay extension
import '../widgets/session_progress_bar.dart';

final _freqFormat = NumberFormat('#,##0.0', 'en_US');
final _ohmsFormat = NumberFormat('#,###', 'en_US');
final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key, this.measurementId});

  final String? measurementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // When shown from history, load by ID; when shown from session, use result provider.
    final id = measurementId;
    if (id != null) {
      return _HistoryResultsView(measurementId: id);
    }

    final session = ref.watch(sessionNotifierProvider);
    final measurement = session is ResultsState ? session.measurement : null;

    if (measurement == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _ResultsView(
      measurement: measurement,
      isSession: true,
      onSave: () {
        ref.read(sessionNotifierProvider.notifier).saveResult();
      },
      onDiscard: () {
        ref.read(sessionNotifierProvider.notifier).reset();
      },
    );
  }
}

// ── History results view ──────────────────────────────────────────────────────

class _HistoryResultsView extends ConsumerWidget {
  const _HistoryResultsView({required this.measurementId});

  final String measurementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load from history list and find the matching ID.
    final history = ref.watch(measurementHistoryProvider);

    return history.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: Center(
            child: Text('Error: $e', style: AppTheme.warningText)),
      ),
      data: (items) {
        final m = items.where((m) => m.id == measurementId).firstOrNull;
        if (m == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Results')),
            body: const Center(child: Text('Measurement not found.')),
          );
        }
        return _ResultsView(measurement: m, isSession: false);
      },
    );
  }
}

// ── Shared results view ───────────────────────────────────────────────────────

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.measurement,
    required this.isSession,
    this.onSave,
    this.onDiscard,
  });

  final PickupMeasurement measurement;
  final bool isSession;
  final VoidCallback? onSave;
  final VoidCallback? onDiscard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(measurement.pickupName.isNotEmpty
            ? measurement.pickupName
            : 'Results'),
        automaticallyImplyLeading: !isSession,
      ),
      body: Column(
        children: [
          if (isSession) const SessionProgressBar(currentStep: 4),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resonant frequency hero display.
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '${_freqFormat.format(measurement.resonantFrequency)} Hz',
                          key: const Key('resonant_frequency_display'),
                          style: AppTheme.measurementLarge,
                        ),
                        const SizedBox(height: 4),
                        const Text('Resonant Frequency',
                            style: TextStyle(
                                color: AppTheme.onSurfaceDim, fontSize: 13)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 9-row derived values table.
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          _ResultRow(
                            key: const Key('result_row_resonant_frequency'),
                            label: 'Resonant Frequency',
                            value: '${_freqFormat.format(measurement.resonantFrequency)} Hz',
                            isHighlight: true,
                          ),
                          _ResultRow(
                            key: const Key('result_row_q_factor'),
                            label: 'Q Factor',
                            value: measurement.qFactor.toStringAsFixed(2),
                          ),
                          _ResultRow(
                            key: const Key('result_row_peak_amplitude'),
                            label: 'Peak Amplitude',
                            value: '${measurement.peakAmplitudeDb.toStringAsFixed(1)} dB',
                          ),
                          _ResultRow(
                            key: const Key('result_row_inductance'),
                            label: 'Inductance',
                            value: measurement.inductance != null
                                ? '${(measurement.inductance! * 1000).toStringAsFixed(1)} mH'
                                : '—',
                          ),
                          _ResultRow(
                            key: const Key('result_row_capacitance'),
                            label: 'Capacitance',
                            value: measurement.capacitance != null
                                ? '${(measurement.capacitance! * 1e12).toStringAsFixed(0)} pF'
                                : '—',
                          ),
                          _ResultRow(
                            key: const Key('result_row_dcr'),
                            label: 'DCR',
                            value: '${_ohmsFormat.format(measurement.dcr.round())} Ω',
                          ),
                          _ResultRow(
                            key: const Key('result_row_dcr_corrected'),
                            label: 'DCR @ 20 °C',
                            value: measurement.dcrCorrected != null
                                ? '${_ohmsFormat.format(measurement.dcrCorrected!.round())} Ω'
                                : '—',
                          ),
                          _ResultRow(
                            key: const Key('result_row_ambient_temp'),
                            label: 'Ambient Temp',
                            value: '${measurement.ambientTempC.toStringAsFixed(1)} °C',
                          ),
                          _ResultRow(
                            key: const Key('result_row_calibration'),
                            label: 'Calibration Applied',
                            value: measurement.calibrationApplied ? 'Yes' : 'No',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Frequency response chart.
                  SizedBox(
                    height: 260,
                    child: FrequencyResponseChart(
                      key: const Key('frequency_response_chart'),
                      response: measurement.response,
                      resonantFrequency: measurement.resonantFrequency,
                      qFactor: measurement.qFactor,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Metadata footer.
                  Text(
                    '${measurement.type.shortName} · ${_dateFormat.format(measurement.timestamp.toLocal())}',
                    style: const TextStyle(
                        color: AppTheme.onSurfaceDim, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          if (isSession) _SessionBottomBar(onSave: onSave, onDiscard: onDiscard),
        ],
      ),
    );
  }
}

// ── Result row ────────────────────────────────────────────────────────────────

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    super.key,
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  final String label;
  final String value;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppTheme.onSurfaceDim),
            ),
          ),
          Text(
            value,
            style: isHighlight
                ? AppTheme.measurementSmall.copyWith(color: AppTheme.primary)
                : AppTheme.measurementSmall,
          ),
        ],
      ),
    );
  }
}

// ── Session bottom bar ────────────────────────────────────────────────────────

class _SessionBottomBar extends StatelessWidget {
  const _SessionBottomBar({required this.onSave, required this.onDiscard});

  final VoidCallback? onSave;
  final VoidCallback? onDiscard;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.surfaceVariant)),
      ),
      child: Row(
        children: [
          OutlinedButton(
            key: const Key('discard_button'),
            onPressed: onDiscard,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.error,
              side: const BorderSide(color: AppTheme.error),
            ),
            child: const Text('Discard'),
          ),
          const Spacer(),
          ElevatedButton(
            key: const Key('save_button'),
            onPressed: onSave,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
