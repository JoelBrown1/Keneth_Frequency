import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
                      itemBuilder: (context, i) =>
                          _MeasurementTile(measurement: items[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

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

class _MeasurementTile extends StatelessWidget {
  const _MeasurementTile({required this.measurement});

  final PickupMeasurement measurement;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
            style: AppTheme.measurementSmall.copyWith(color: AppTheme.primary),
          ),
        ],
      ),
      subtitle: Text(
        '${measurement.type.shortName} · ${_dateFormat.format(measurement.timestamp.toLocal())}',
        style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceDim),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.onSurfaceDim),
      onTap: () => context.go('/results/${measurement.id}'),
    );
  }
}
