import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/session/session_notifier.dart';
import '../../application/session/session_state.dart';
import '../../domain/entities/pickup_type.dart';
import '../theme/app_theme.dart';
import '../widgets/pickup_type_selector.dart';
import '../widgets/session_progress_bar.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  PickupType _selectedType = PickupType.humbuckerMediumOutput;
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _next() {
    ref
        .read(sessionNotifierProvider.notifier)
        .submitSetup(_selectedType, _nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Setup'),
        leading: BackButton(
          onPressed: () =>
              ref.read(sessionNotifierProvider.notifier).cancelSession(),
        ),
      ),
      body: Column(
        children: [
          const SessionProgressBar(currentStep: 0),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pickup type',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  PickupTypeSelector(
                    selected: _selectedType,
                    onSelected: (t) => setState(() => _selectedType = t),
                  ),
                  const SizedBox(height: 24),
                  Text('Pickup name (optional)',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('pickup_name_field'),
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. PAF Bridge',
                      labelText: 'Name',
                    ),
                  ),
                ],
              ),
            ),
          ),
          _BottomBar(onNext: _next, nextLabel: 'Enter DCR'),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onNext, required this.nextLabel});

  final VoidCallback onNext;
  final String nextLabel;

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
            child: Text(nextLabel),
          ),
        ],
      ),
    );
  }
}
