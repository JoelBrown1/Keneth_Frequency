import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/measurement_providers.dart';
import '../../application/session/session_notifier.dart';
import '../../application/session/session_state.dart';
import '../theme/app_theme.dart';
import '../widgets/level_meter.dart';
import '../widgets/session_progress_bar.dart';

class MeasurementScreen extends ConsumerWidget {
  const MeasurementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionNotifierProvider);
    final progress = session is MeasuringState ? session.progress : 0.0;
    final isRunning = progress > 0;

    final levelAsync = ref.watch(levelStreamProvider);
    final level = levelAsync.asData?.value ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Measuring'),
        leading: BackButton(
          onPressed: () =>
              ref.read(sessionNotifierProvider.notifier).cancelSession(),
        ),
      ),
      body: Column(
        children: [
          const SessionProgressBar(currentStep: 3),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Level meter + labels row.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LevelMeter(rms: level, height: 180),
                      const SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text('Input level',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            const Text(
                              'Real-time RMS from the Scarlett input. '
                              'Aim for the green zone (−60 to −12 dBFS).',
                              style: TextStyle(
                                  fontSize: 12, color: AppTheme.onSurfaceDim),
                            ),
                            const SizedBox(height: 24),
                            if (isRunning) ...[
                              Text('Sweep progress',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                key: const Key('measurement_progress'),
                                value: progress,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(progress * 100).round()}%',
                                style: AppTheme.measurementSmall
                                    .copyWith(color: AppTheme.primary),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  if (!isRunning)
                    const Text(
                      'Connect the pickup and tap "Start Sweep" to begin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.onSurfaceDim, fontSize: 13),
                    ),
                ],
              ),
            ),
          ),
          _BottomBar(
            isRunning: isRunning,
            onStart: isRunning
                ? null
                : () => ref
                    .read(sessionNotifierProvider.notifier)
                    .startMeasurement(),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.isRunning, required this.onStart});

  final bool isRunning;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.surfaceVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            key: const Key('start_sweep_button'),
            onPressed: onStart,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isRunning) ...[
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppTheme.onPrimary),
                  ),
                  const SizedBox(width: 8),
                  const Text('Measuring…'),
                ] else
                  const Text('Start Sweep'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
