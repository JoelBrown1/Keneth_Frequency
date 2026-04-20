import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../application/providers/measurement_providers.dart';
import '../../application/session/session_notifier.dart';
import '../../application/session/session_state.dart';
import '../../application/settings/app_settings.dart';
import '../../application/settings/settings_notifier.dart';
import '../../domain/entities/pickup_measurement.dart';
import '../../infrastructure/storage/export_service.dart';
import '../theme/app_theme.dart';
import '../widgets/frequency_response_chart.dart';
import '../widgets/pickup_type_selector.dart'; // provides PickupTypeDisplay extension
import '../widgets/session_progress_bar.dart';

final _freqFormat = NumberFormat('#,##0.0', 'en_US');
final _ohmsFormat = NumberFormat('#,###', 'en_US');
final _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

/// UX-05: Format resonant frequency as kHz when ≥ 1000 Hz.
/// e.g. 4783 Hz → "4.78 kHz", 850 Hz → "850 Hz"
String _heroFreqLabel(double hz) {
  if (hz >= 1000) {
    return '${(hz / 1000).toStringAsFixed(2)} kHz';
  }
  return '${hz.toStringAsFixed(0)} Hz';
}

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
    final ResultsState? state =
        session is ResultsState ? session : null;

    if (state == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return _ResultsView(
      measurement: state.measurement,
      isSession: true,
      snrDb: state.snrDb,
      clipWarning: state.clipWarning,
      noPeakDetected: state.noPeakDetected,
      onSave: () {
        ref.read(sessionNotifierProvider.notifier).saveResult();
      },
      onDiscard: () {
        ref.read(sessionNotifierProvider.notifier).discardAndRemeasure();
      },
      onBack: () {
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
    this.snrDb,
    this.clipWarning = false,
    this.noPeakDetected = false,
    this.onSave,
    this.onDiscard,
    this.onBack,
  });

  final PickupMeasurement measurement;
  final bool isSession;
  final double? snrDb;
  final bool clipWarning;
  final bool noPeakDetected;
  final VoidCallback? onSave;
  final VoidCallback? onDiscard;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(measurement.pickupName.isNotEmpty
            ? measurement.pickupName
            : 'Results'),
        automaticallyImplyLeading: !isSession,
        leading: isSession
            ? _BackButton(onBack: onBack)
            : null,
        actions: [
          _ExportButton(measurement: measurement),
        ],
      ),
      body: Column(
        children: [
          if (isSession) const SessionProgressBar(currentStep: 4),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: noPeakDetected
                  ? _NoPeakBody(measurement: measurement)
                  : _ResultsBody(
                      measurement: measurement,
                      snrDb: snrDb,
                      clipWarning: clipWarning,
                    ),
            ),
          ),
          if (isSession) _SessionBottomBar(onSave: onSave, onDiscard: onDiscard),
        ],
      ),
    );
  }
}

// ── No peak detected body ─────────────────────────────────────────────────────

class _NoPeakBody extends StatelessWidget {
  const _NoPeakBody({required this.measurement});

  final PickupMeasurement measurement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        const Icon(Icons.signal_cellular_nodata,
            size: 64, color: AppTheme.onSurfaceDim),
        const SizedBox(height: 20),
        Text(
          'No Resonant Peak Detected',
          key: const Key('no_peak_label'),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppTheme.error),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Text(
          'The DSP pipeline could not locate a resonant peak in the recorded response.\n'
          'Try the following:',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.onSurfaceDim, fontSize: 13),
        ),
        const SizedBox(height: 16),
        _PitfallItem('Position the exciter coil directly above the pickup poles.'),
        _PitfallItem('Ensure the exciter coil is connected to Output 1 (L).'),
        _PitfallItem('Increase the output level in Settings (less negative dBFS).'),
        _PitfallItem('Check that the pickup lead is connected to Input 1 (Hi-Z).'),
        _PitfallItem('Re-run calibration with a 1 MΩ termination resistor.'),
        const SizedBox(height: 24),
        Text(
          '${measurement.type.shortName} · ${_dateFormat.format(measurement.timestamp.toLocal())}',
          style: const TextStyle(color: AppTheme.onSurfaceDim, fontSize: 12),
        ),
      ],
    );
  }
}

class _PitfallItem extends StatelessWidget {
  const _PitfallItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(color: AppTheme.primary, fontSize: 14)),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: AppTheme.onSurface, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ── Normal results body ───────────────────────────────────────────────────────

class _ResultsBody extends StatelessWidget {
  const _ResultsBody({
    required this.measurement,
    required this.snrDb,
    required this.clipWarning,
  });

  final PickupMeasurement measurement;
  final double? snrDb;
  final bool clipWarning;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SNR warning banner (M-04 / S9-04).
        if (snrDb != null && snrDb! < 10.0)
          _WarningBanner(
            key: const Key('snr_warning_banner'),
            message:
                'Low signal-to-noise ratio (${snrDb!.toStringAsFixed(1)} dB). '
                'Reduce exciter gap or increase output level.',
          ),

        // Clip warning banner (S9-14).
        if (clipWarning)
          _WarningBanner(
            key: const Key('clip_warning_banner'),
            message:
                'Input clipped during recording. Reduce gain on the Scarlett 2i2 and re-measure.',
            color: AppTheme.error,
          ),

        // Uncalibrated label (S9-08).
        if (!measurement.calibrationApplied)
          _WarningBanner(
            key: const Key('uncalibrated_banner'),
            message:
                'Measurement is uncalibrated. Results may be less accurate.',
          ),

        const SizedBox(height: 16),

        // Resonant frequency hero display.
        Center(
          child: Column(
            children: [
              Text(
                _heroFreqLabel(measurement.resonantFrequency),
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
                  value: _heroFreqLabel(measurement.resonantFrequency),
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
                  value:
                      '${measurement.peakAmplitudeDb.toStringAsFixed(1)} dB',
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
                  value:
                      '${_ohmsFormat.format(measurement.dcr.round())} Ω',
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
                  value:
                      '${measurement.ambientTempC.toStringAsFixed(1)} °C',
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
        // UX-09: interaction affordance hint below chart.
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            'Pinch to zoom · scroll to pan',
            key: Key('chart_zoom_hint'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppTheme.onSurfaceDim),
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
    );
  }
}

// ── Export button ─────────────────────────────────────────────────────────────

class _ExportButton extends ConsumerWidget {
  const _ExportButton({required this.measurement});

  final PickupMeasurement measurement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      key: const Key('export_button'),
      icon: const Icon(Icons.upload_file),
      tooltip: 'Export',
      onPressed: () => _showExportDialog(context, ref),
    );
  }

  Future<void> _showExportDialog(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsNotifierProvider);
    final defaultFormat = settings.exportFormat;

    ExportFormat? chosen = await showDialog<ExportFormat>(
      context: context,
      builder: (ctx) => _ExportFormatDialog(initial: defaultFormat),
    );
    if (chosen == null || !context.mounted) return;

    await _export(context, chosen);
  }

  Future<void> _export(BuildContext context, ExportFormat format) async {
    try {
      const service = ExportService();
      final isCsv = format == ExportFormat.csv;
      final ext = isCsv ? 'csv' : 'json';
      final content = isCsv ? service.toCsv(measurement) : service.toJson(measurement);
      final filename = service.fileName(measurement, ext);

      final tmpDir = await getTemporaryDirectory();
      final file = File('${tmpDir.path}/$filename');
      await file.writeAsString(content);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }
}

class _ExportFormatDialog extends StatefulWidget {
  const _ExportFormatDialog({required this.initial});

  final ExportFormat initial;

  @override
  State<_ExportFormatDialog> createState() => _ExportFormatDialogState();
}

class _ExportFormatDialogState extends State<_ExportFormatDialog> {
  late ExportFormat _format;

  @override
  void initState() {
    super.initState();
    _format = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export Format'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<ExportFormat>(
            key: const Key('export_format_csv'),
            title: const Text('CSV'),
            subtitle: const Text('Spreadsheet-compatible'),
            value: ExportFormat.csv,
            groupValue: _format,
            onChanged: (v) => setState(() => _format = v!),
          ),
          RadioListTile<ExportFormat>(
            key: const Key('export_format_json'),
            title: const Text('JSON'),
            subtitle: const Text('Machine-readable'),
            value: ExportFormat.json,
            groupValue: _format,
            onChanged: (v) => setState(() => _format = v!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          key: const Key('export_confirm'),
          onPressed: () => Navigator.of(context).pop(_format),
          child: const Text('Export'),
        ),
      ],
    );
  }
}

// ── Warning banner ────────────────────────────────────────────────────────────

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({
    super.key,
    required this.message,
    this.color = AppTheme.secondary,
  });

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: TextStyle(color: color, fontSize: 13)),
          ),
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

// ── Back button (session mode) ────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: 'Back to Home',
      onPressed: () => _confirmBack(context),
    );
  }

  Future<void> _confirmBack(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave without saving?'),
        content: const Text(
            'The measurement result will be discarded. Save it first if you want to keep it.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (confirmed == true) onBack?.call();
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
