import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../application/providers/measurement_providers.dart';
import '../../domain/entities/pickup_measurement.dart';
import '../theme/app_theme.dart';
import '../widgets/frequency_response_chart.dart';
import '../widgets/pickup_type_selector.dart';

final _freqFormat = NumberFormat('#,##0.0', 'en_US');
final _ohmsFormat = NumberFormat('#,###', 'en_US');

class CompareScreen extends ConsumerWidget {
  const CompareScreen({
    super.key,
    required this.id1,
    required this.id2,
  });

  final String id1;
  final String id2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async1 = ref.watch(measurementByIdProvider(id1));
    final async2 = ref.watch(measurementByIdProvider(id2));

    // Wait for both to load.
    if (async1.isLoading || async2.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final m1 = async1.asData?.value;
    final m2 = async2.asData?.value;

    if (m1 == null || m2 == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Comparison')),
        body: const Center(
            child: Text('One or both measurements could not be loaded.')),
      );
    }

    final label1 = m1.pickupName.isNotEmpty ? m1.pickupName : m1.type.shortName;
    final label2 = m2.pickupName.isNotEmpty ? m2.pickupName : m2.type.shortName;
    final deltaHz = (m1.resonantFrequency - m2.resonantFrequency).abs();

    return Scaffold(
      appBar: AppBar(
        title: Text('$label1 vs $label2'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Δf callout.
            _DeltaCallout(
              label1: label1,
              label2: label2,
              f1: m1.resonantFrequency,
              f2: m2.resonantFrequency,
              deltaHz: deltaHz,
            ),

            const SizedBox(height: 16),

            // Dual-line chart.
            SizedBox(
              height: 300,
              child: FrequencyResponseChart(
                key: const Key('compare_chart'),
                response: m1.response,
                resonantFrequency: m1.resonantFrequency,
                qFactor: m1.qFactor,
                secondaryResponse: m2.response,
                secondaryResonantFrequency: m2.resonantFrequency,
              ),
            ),

            const SizedBox(height: 8),

            // Legend.
            Row(
              children: [
                _LegendDot(color: AppTheme.primary),
                const SizedBox(width: 6),
                Text(label1,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.onSurfaceDim)),
                const SizedBox(width: 20),
                _LegendDot(color: AppTheme.secondary),
                const SizedBox(width: 6),
                Text(label2,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.onSurfaceDim)),
              ],
            ),

            const SizedBox(height: 24),

            // Two-column data panel.
            _ComparisonPanel(primary: m1, secondary: m2),
          ],
        ),
      ),
    );
  }
}

// ── Δf callout ────────────────────────────────────────────────────────────────

class _DeltaCallout extends StatelessWidget {
  const _DeltaCallout({
    required this.label1,
    required this.label2,
    required this.f1,
    required this.f2,
    required this.deltaHz,
  });

  final String label1;
  final String label2;
  final double f1;
  final double f2;
  final double deltaHz;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label1,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.onSurfaceDim)),
                Text(
                  '${_freqFormat.format(f1)} Hz',
                  style:
                      AppTheme.measurementMedium.copyWith(color: AppTheme.primary),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.compare_arrows,
                  size: 20, color: AppTheme.onSurfaceDim),
              Text(
                'Δ ${_freqFormat.format(deltaHz)} Hz',
                key: const Key('delta_f_label'),
                style: const TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 13,
                  color: AppTheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label2,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.onSurfaceDim)),
                Text(
                  '${_freqFormat.format(f2)} Hz',
                  style: AppTheme.measurementMedium
                      .copyWith(color: AppTheme.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Comparison two-column data panel ──────────────────────────────────────────

class _ComparisonPanel extends StatelessWidget {
  const _ComparisonPanel({
    required this.primary,
    required this.secondary,
  });

  final PickupMeasurement primary;
  final PickupMeasurement secondary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            _CompareHeaderRow(
              label1: primary.pickupName.isNotEmpty
                  ? primary.pickupName
                  : primary.type.shortName,
              label2: secondary.pickupName.isNotEmpty
                  ? secondary.pickupName
                  : secondary.type.shortName,
            ),
            const Divider(height: 1),
            _CompareRow(
              key: const Key('compare_row_resonant_frequency'),
              label: 'Resonant Frequency',
              value1: '${_freqFormat.format(primary.resonantFrequency)} Hz',
              value2: '${_freqFormat.format(secondary.resonantFrequency)} Hz',
            ),
            _CompareRow(
              key: const Key('compare_row_q_factor'),
              label: 'Q Factor',
              value1: primary.qFactor.toStringAsFixed(2),
              value2: secondary.qFactor.toStringAsFixed(2),
            ),
            _CompareRow(
              key: const Key('compare_row_peak_amplitude'),
              label: 'Peak Amplitude',
              value1: '${primary.peakAmplitudeDb.toStringAsFixed(1)} dB',
              value2: '${secondary.peakAmplitudeDb.toStringAsFixed(1)} dB',
            ),
            _CompareRow(
              key: const Key('compare_row_inductance'),
              label: 'Inductance',
              value1: primary.inductance != null
                  ? '${(primary.inductance! * 1000).toStringAsFixed(1)} mH'
                  : '—',
              value2: secondary.inductance != null
                  ? '${(secondary.inductance! * 1000).toStringAsFixed(1)} mH'
                  : '—',
            ),
            _CompareRow(
              key: const Key('compare_row_dcr'),
              label: 'DCR',
              value1: '${_ohmsFormat.format(primary.dcr.round())} Ω',
              value2: '${_ohmsFormat.format(secondary.dcr.round())} Ω',
            ),
            _CompareRow(
              key: const Key('compare_row_type'),
              label: 'Type',
              value1: primary.type.shortName,
              value2: secondary.type.shortName,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompareHeaderRow extends StatelessWidget {
  const _CompareHeaderRow({required this.label1, required this.label2});

  final String label1;
  final String label2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 120),
          Expanded(
            child: Text(
              label1,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary),
            ),
          ),
          Expanded(
            child: Text(
              label2,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({
    super.key,
    required this.label,
    required this.value1,
    required this.value2,
  });

  final String label;
  final String value1;
  final String value2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceDim),
            ),
          ),
          Expanded(
            child: Text(value1, style: AppTheme.measurementSmall),
          ),
          Expanded(
            child: Text(
              value2,
              style: AppTheme.measurementSmall
                  .copyWith(color: AppTheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
