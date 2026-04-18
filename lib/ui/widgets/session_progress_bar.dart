import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Step labels that map 1-to-1 to the session FSM states.
const _steps = ['Setup', 'DCR', 'Calibrate', 'Measure', 'Results'];

/// Horizontal 5-step progress indicator shown at the top of each session screen.
///
/// [currentStep] is zero-indexed (0 = Setup … 4 = Results).
class SessionProgressBar extends StatelessWidget {
  const SessionProgressBar({super.key, required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            // Connector line between steps.
            final stepIndex = i ~/ 2;
            final passed = stepIndex < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color: passed ? AppTheme.primary : AppTheme.surfaceVariant,
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isDone = stepIndex < currentStep;
          final isActive = stepIndex == currentStep;
          return _StepDot(
            label: _steps[stepIndex],
            isDone: isDone,
            isActive: isActive,
          );
        }),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.isDone,
    required this.isActive,
  });

  final String label;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isDone || isActive ? AppTheme.primary : AppTheme.surfaceVariant;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.primary : Colors.transparent,
            border: Border.all(color: color, width: 2),
          ),
          child: isDone
              ? const Icon(Icons.check, size: 14, color: AppTheme.primary)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? AppTheme.primary : AppTheme.onSurfaceDim,
          ),
        ),
      ],
    );
  }
}
