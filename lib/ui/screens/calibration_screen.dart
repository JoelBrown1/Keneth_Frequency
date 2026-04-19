import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/audio_device_provider.dart';
import '../../application/providers/calibration_provider.dart';
import '../../application/session/session_notifier.dart';
import '../../application/session/session_state.dart';
import '../theme/app_theme.dart';
import '../widgets/session_progress_bar.dart';

class CalibrationScreen extends ConsumerWidget {
  const CalibrationScreen({super.key});

  Future<void> _startCalibration(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(sessionNotifierProvider.notifier).runCalibration();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Calibration failed: $e'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionNotifierProvider);
    final progress = session is CalibratingState ? session.progress : 0.0;
    final isRunning = progress > 0;

    // Check for Scarlett device (UX-02): disable start button when none found.
    final devicesAsync = ref.watch(audioDevicesProvider);
    final hasDevice = devicesAsync.whenOrNull(
          data: (list) => list.any((d) => d.isScarlett),
        ) ??
        true; // assume present while loading to avoid premature disable

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
                  // Device-not-found warning (UX-02 / S9-05).
                  if (!hasDevice)
                    _DeviceNotFoundBanner(),

                  const SizedBox(height: 8),

                  // Stale or missing calibration warning (S9-07).
                  _StaleCalibrationBanner(),

                  const SizedBox(height: 8),

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
            deviceReady: hasDevice,
            onStart: (isRunning || !hasDevice)
                ? null
                : () => _startCalibration(context, ref),
          ),
        ],
      ),
    );
  }
}

/// Shows a red banner when no Scarlett device is detected (UX-02 / S9-05).
class _DeviceNotFoundBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.error.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.error.withAlpha(80)),
      ),
      child: Row(
        children: [
          const Icon(Icons.usb_off, color: AppTheme.error, size: 18),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Scarlett 2i2 not detected. Check USB connection and power.',
              style: TextStyle(color: AppTheme.error, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows an amber banner if calibration is stale or missing (S9-07).
class _StaleCalibrationBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(calibrationStatusProvider);
    return status.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        if (!s.isStale) return const SizedBox.shrink();
        final msg = s.latest == null
            ? 'No calibration found. Run calibration before measuring for accurate results.'
            : 'Calibration is older than the configured threshold. Consider re-calibrating.';
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.secondary.withAlpha(30),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppTheme.secondary.withAlpha(80)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: AppTheme.secondary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(msg,
                    style: const TextStyle(
                        color: AppTheme.secondary, fontSize: 13)),
              ),
            ],
          ),
        );
      },
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
  const _BottomBar({
    required this.isRunning,
    required this.deviceReady,
    required this.onStart,
  });

  final bool isRunning;
  final bool deviceReady;
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
