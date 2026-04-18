import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/session/session_notifier.dart';
import '../../application/session/session_state.dart';
import '../theme/app_theme.dart';
import '../widgets/dcr_input_form.dart';
import '../widgets/pickup_type_selector.dart';
import '../widgets/session_progress_bar.dart';

class DcrEntryScreen extends ConsumerStatefulWidget {
  const DcrEntryScreen({super.key});

  @override
  ConsumerState<DcrEntryScreen> createState() => _DcrEntryScreenState();
}

class _DcrEntryScreenState extends ConsumerState<DcrEntryScreen> {
  double? _dcr;
  double _tempC = 20.0;

  void _onFormChanged(double? dcr, double tempC) {
    setState(() {
      _dcr = dcr;
      _tempC = tempC;
    });
    if (dcr != null) {
      ref.read(sessionNotifierProvider.notifier).submitDcr(dcr, tempC);
    }
  }

  void _next() {
    final d = _dcr;
    if (d == null) return;
    ref.read(sessionNotifierProvider.notifier)
      ..submitDcr(d, _tempC)
      ..startCalibration();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionNotifierProvider);
    final dcrState = session is DcrEntryState ? session : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DCR Entry'),
        leading: BackButton(
          onPressed: () =>
              ref.read(sessionNotifierProvider.notifier).cancelSession(),
        ),
      ),
      body: Column(
        children: [
          const SessionProgressBar(currentStep: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructions.
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,
                            size: 18, color: AppTheme.onSurfaceDim),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Measure DCR with your multimeter set to Ω (resistance). '
                            'Disconnect pickup from wiring before measuring.',
                            style: TextStyle(
                                fontSize: 13, color: AppTheme.onSurfaceDim),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (dcrState != null) ...[
                    Text(
                      'Pickup: ${dcrState.pickupName.isNotEmpty ? dcrState.pickupName : dcrState.type.shortName}',
                      style: const TextStyle(
                          color: AppTheme.onSurfaceDim, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                  ],

                  DcrInputForm(
                    pickupType: ref.read(sessionNotifierProvider.notifier).accumulatedType,
                    initialDcr: dcrState?.dcr,
                    initialTempC: dcrState?.tempC ?? 20.0,
                    onChanged: _onFormChanged,
                  ),
                ],
              ),
            ),
          ),
          _BottomBar(
            onNext: _dcr != null ? _next : null,
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onNext});

  final VoidCallback? onNext;

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
            onPressed: onNext,
            child: const Text('Calibrate'),
          ),
        ],
      ),
    );
  }
}
