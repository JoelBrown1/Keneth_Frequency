import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/settings/app_settings.dart';
import '../../application/settings/settings_notifier.dart';
import '../../domain/entities/pickup_type.dart';
import '../theme/app_theme.dart';
import '../widgets/pickup_type_selector.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Sweep ─────────────────────────────────────────────────────────
          _SectionHeader(label: 'Sweep'),

          _SliderTile(
            key: const Key('sweep_duration_slider'),
            label: 'Sweep duration',
            value: settings.sweepDurationSeconds.toDouble(),
            min: 10,
            max: 30,
            divisions: 20,
            displayValue: '${settings.sweepDurationSeconds} s',
            onChanged: (v) => notifier.setSweepDuration(v.round()),
          ),

          _SliderTile(
            key: const Key('output_level_slider'),
            label: 'Output level',
            value: settings.outputLevelDbfs,
            min: -18,
            max: -6,
            divisions: 12,
            displayValue: '${settings.outputLevelDbfs.toStringAsFixed(0)} dBFS',
            onChanged: (v) => notifier.setOutputLevel(v),
          ),

          const SizedBox(height: 8),

          // ── Analysis ──────────────────────────────────────────────────────
          _SectionHeader(label: 'Analysis'),

          _DropdownTile<SmoothingResolution>(
            key: const Key('smoothing_dropdown'),
            label: 'Smoothing',
            value: settings.smoothingResolution,
            items: const [
              DropdownMenuItem(
                  value: SmoothingResolution.third,
                  child: Text('1/3 octave')),
              DropdownMenuItem(
                  value: SmoothingResolution.sixth,
                  child: Text('1/6 octave')),
              DropdownMenuItem(
                  value: SmoothingResolution.twelfth,
                  child: Text('1/12 octave')),
              DropdownMenuItem(
                  value: SmoothingResolution.none,
                  child: Text('None')),
            ],
            onChanged: (v) {
              if (v != null) notifier.setSmoothing(v);
            },
          ),

          const SizedBox(height: 8),

          // ── Calibration ───────────────────────────────────────────────────
          _SectionHeader(label: 'Calibration'),

          _DropdownTile<int>(
            key: const Key('calibration_warning_dropdown'),
            label: 'Calibration warning threshold',
            value: settings.calibrationWarningThresholdHours,
            items: const [
              DropdownMenuItem(value: 12, child: Text('12 hours')),
              DropdownMenuItem(value: 24, child: Text('24 hours')),
              DropdownMenuItem(value: 48, child: Text('48 hours')),
              DropdownMenuItem(value: 72, child: Text('72 hours')),
            ],
            onChanged: (v) {
              if (v != null) notifier.setCalibrationWarningThreshold(v);
            },
          ),

          const SizedBox(height: 8),

          // ── Display ───────────────────────────────────────────────────────
          _SectionHeader(label: 'Display'),

          _SegmentedTile<TemperatureUnit>(
            key: const Key('temperature_unit_segment'),
            label: 'Temperature unit',
            value: settings.temperatureUnit,
            segments: const [
              ButtonSegment(
                  value: TemperatureUnit.celsius, label: Text('°C')),
              ButtonSegment(
                  value: TemperatureUnit.fahrenheit, label: Text('°F')),
            ],
            onChanged: (v) => notifier.setTemperatureUnit(v),
          ),

          const SizedBox(height: 8),

          // ── Defaults ──────────────────────────────────────────────────────
          _SectionHeader(label: 'Defaults'),

          _DropdownTile<PickupType>(
            key: const Key('default_pickup_type_dropdown'),
            label: 'Default pickup type',
            value: settings.defaultPickupType,
            items: PickupType.values
                .map((t) => DropdownMenuItem(
                    value: t, child: Text(t.shortName)))
                .toList(),
            onChanged: (v) {
              if (v != null) notifier.setDefaultPickupType(v);
            },
          ),

          const SizedBox(height: 8),

          // ── Export ────────────────────────────────────────────────────────
          _SectionHeader(label: 'Export'),

          _SegmentedTile<ExportFormat>(
            key: const Key('export_format_segment'),
            label: 'Default export format',
            value: settings.exportFormat,
            segments: const [
              ButtonSegment(value: ExportFormat.csv, label: Text('CSV')),
              ButtonSegment(value: ExportFormat.json, label: Text('JSON')),
            ],
            onChanged: (v) => notifier.setExportFormat(v),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── Slider tile ───────────────────────────────────────────────────────────────

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.displayValue,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String displayValue;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(label,
                      style: const TextStyle(fontSize: 14)),
                ),
                Text(
                  displayValue,
                  style: AppTheme.measurementSmall
                      .copyWith(color: AppTheme.primary),
                ),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dropdown tile ─────────────────────────────────────────────────────────────

class _DropdownTile<T> extends StatelessWidget {
  const _DropdownTile({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14)),
            ),
            DropdownButton<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              underline: const SizedBox.shrink(),
              style: const TextStyle(
                  fontSize: 14, color: AppTheme.onSurface),
              dropdownColor: AppTheme.surface,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Segmented tile ────────────────────────────────────────────────────────────

class _SegmentedTile<T> extends StatelessWidget {
  const _SegmentedTile({
    super.key,
    required this.label,
    required this.value,
    required this.segments,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<ButtonSegment<T>> segments;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14)),
            ),
            SegmentedButton<T>(
              segments: segments,
              selected: {value},
              onSelectionChanged: (s) => onChanged(s.first),
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: AppTheme.primary.withAlpha(40),
                selectedForegroundColor: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
