import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../application/providers/database_providers.dart';
import '../../application/providers/measurement_providers.dart';
import '../../application/session/session_notifier.dart';
import '../../domain/entities/pickup_measurement.dart';
import '../theme/app_theme.dart';
import '../widgets/pickup_type_selector.dart';

final _dateFormat = DateFormat('yyyy-MM-dd HH:mm');
final _freqFormat = NumberFormat('#,##0.0', 'en_US');

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(measurementHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keneth Frequency'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_outlined),
            tooltip: 'Reference',
            onPressed: () => context.go('/reference'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.go('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // New measurement button.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: const Key('new_measurement_button'),
                icon: const Icon(Icons.add),
                label: const Text('New Measurement'),
                onPressed: () =>
                    ref.read(sessionNotifierProvider.notifier).startSession(),
              ),
            ),
          ),

          const Divider(height: 1),

          // History list.
          Expanded(
            child: history.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Error loading history: $e',
                    style: AppTheme.warningText),
              ),
              data: (items) => items.isEmpty
                  ? _EmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: items.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (context, i) => _MeasurementTile(
                        measurement: items[i],
                        allMeasurements: items,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.graphic_eq, size: 64, color: AppTheme.onSurfaceDim),
          const SizedBox(height: 16),
          Text(
            'No measurements yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap "New Measurement" to get started.',
            style: TextStyle(color: AppTheme.onSurfaceDim, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ── Measurement tile ──────────────────────────────────────────────────────────

class _MeasurementTile extends ConsumerWidget {
  const _MeasurementTile({
    required this.measurement,
    required this.allMeasurements,
  });

  final PickupMeasurement measurement;
  final List<PickupMeasurement> allMeasurements;

  Future<void> _showContextMenu(
      BuildContext context, WidgetRef ref, Offset globalPosition) async {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final choice = await showMenu<_ContextAction>(
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        globalPosition.dx + 1,
        globalPosition.dy + 1,
      ),
      items: [
        const PopupMenuItem(
          key: Key('context_view'),
          value: _ContextAction.view,
          child: ListTile(
            leading: Icon(Icons.open_in_new, size: 18),
            title: Text('View'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        const PopupMenuItem(
          key: Key('context_compare'),
          value: _ContextAction.compare,
          child: ListTile(
            leading: Icon(Icons.compare_arrows, size: 18),
            title: Text('Compare with…'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          key: Key('context_delete'),
          value: _ContextAction.delete,
          child: ListTile(
            leading:
                Icon(Icons.delete_outline, size: 18, color: AppTheme.error),
            title: Text('Delete', style: TextStyle(color: AppTheme.error)),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
      ],
    );

    if (!context.mounted) return;

    switch (choice) {
      case _ContextAction.view:
        context.go('/results/${measurement.id}');
      case _ContextAction.compare:
        await _showComparePicker(context, ref);
      case _ContextAction.delete:
        await _delete(context, ref);
      case null:
        break;
    }
  }

  Future<void> _showComparePicker(BuildContext context, WidgetRef ref) async {
    final others = allMeasurements
        .where((m) => m.id != measurement.id)
        .toList();

    if (others.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No other measurements to compare with.')),
      );
      return;
    }

    final selected = await showDialog<PickupMeasurement>(
      context: context,
      builder: (ctx) => _ComparePickerDialog(
        measurements: others,
        primaryLabel: measurement.pickupName.isNotEmpty
            ? measurement.pickupName
            : measurement.type.shortName,
      ),
    );

    if (selected != null && context.mounted) {
      context.go('/compare/${measurement.id}/${selected.id}');
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete measurement?'),
        content: Text(
          'Delete "${measurement.pickupName.isNotEmpty ? measurement.pickupName : measurement.type.shortName}"? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(measurementRepositoryProvider).delete(measurement.id);
      ref.invalidate(measurementHistoryProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      // Right-click context menu (M-06 fix — macOS desktop convention).
      onSecondaryTapUp: (details) =>
          _showContextMenu(context, ref, details.globalPosition),
      child: ListTile(
        key: Key('measurement_tile_${measurement.id}'),
        title: Row(
          children: [
            Expanded(
              child: Text(
                measurement.pickupName.isNotEmpty
                    ? measurement.pickupName
                    : measurement.type.shortName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              '${_freqFormat.format(measurement.resonantFrequency)} Hz',
              style:
                  AppTheme.measurementSmall.copyWith(color: AppTheme.primary),
            ),
          ],
        ),
        subtitle: Text(
          '${measurement.type.shortName} · ${_dateFormat.format(measurement.timestamp.toLocal())}',
          style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceDim),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceDim),
        onTap: () => context.go('/results/${measurement.id}'),
      ),
    );
  }
}

enum _ContextAction { view, compare, delete }

// ── Compare picker dialog ─────────────────────────────────────────────────────

class _ComparePickerDialog extends StatelessWidget {
  const _ComparePickerDialog({
    required this.measurements,
    required this.primaryLabel,
  });

  final List<PickupMeasurement> measurements;
  final String primaryLabel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Compare "$primaryLabel" with…'),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: SizedBox(
        width: 400,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: measurements.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (ctx, i) {
            final m = measurements[i];
            final label = m.pickupName.isNotEmpty
                ? m.pickupName
                : m.type.shortName;
            return ListTile(
              key: Key('compare_picker_${m.id}'),
              title: Text(label),
              subtitle: Text(
                '${_freqFormat.format(m.resonantFrequency)} Hz · '
                '${_dateFormat.format(m.timestamp.toLocal())}',
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.onSurfaceDim),
              ),
              onTap: () => Navigator.of(ctx).pop(m),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
