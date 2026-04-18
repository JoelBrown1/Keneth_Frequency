import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/session/session_notifier.dart';
import '../../application/session/session_state.dart';
import '../theme/app_theme.dart';
import '../widgets/session_progress_bar.dart';

class CalibrationScreen extends ConsumerWidget {
  const CalibrationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionNotifierProvider);
    final progress = session is CalibratingState ? session.progress : 0.0;
    final isRunning = progress > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calibration'),
        leading: BackButton(
          onPressed: () =>
              ref.read(sessionNotifierProvider.notifier).cancelSession(),
        ),
      ),
      body: Column(
        children: [
          const SessionProgressBar(currentStep: 2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Focusrite reminder.
                  _InfoCard(
                    icon: Icons.usb,
                    color: AppTheme.primary,
                    text:
                        'Ensure your Focusrite Scarlett 2i2 is connected via USB '
                        'and powered on before starting calibration.',
                  ),

                  const SizedBox(height: 16),

                  // 1 MΩ termination instruction.
                  _InfoCard(
                    icon: Icons.electrical_services,
                    color: AppTheme.secondary,
                    text:
                        'Connect a 1 MΩ resistor across the input terminals. '
                        'This captures the baseline room noise floor for SNR estimation.',
                  ),

                  const SizedBox(height: 24),

                  Text('Calibration sweep',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text(
                    'A short log-sweep signal will be played and recorded. '
                    'This takes approximately 5 seconds.',
                    style: TextStyle(
                        fontSize: 13, color: AppTheme.onSurfaceDim),
                  ),

                  const SizedBox(height: 20),

                  // Progress indicator.
                  if (isRunning) ...[
                    Row(
                      children: [
                        const Text('Running…',
                            style: TextStyle(color: AppTheme.onSurfaceDim)),
                        const SizedBox(width: 8),
                        Text(
                          '${(progress * 100).round()}%',
                          style: AppTheme.measurementSmall
                              .copyWith(color: AppTheme.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      key: const Key('calibration_progress'),
                      value: progress,
                    ),
                  ],
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
                    .startCalibration(),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: AppTheme.onSurface),
            ),
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
            key: const Key('start_calibration_button'),
            onPressed: onStart,
            child: const Text('Start Calibration'),
          ),
        ],
      ),
    );
  }
}
