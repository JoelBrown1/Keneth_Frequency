import 'package:flutter/material.dart';

import '../../domain/entities/pickup_type.dart';
import '../theme/app_theme.dart';

// ── Display name extension ────────────────────────────────────────────────────

extension PickupTypeDisplay on PickupType {
  String get displayName => switch (this) {
        PickupType.singleCoilStrat => 'Single Coil\nStrat',
        PickupType.singleCoilTeleBridge => 'Single Coil\nTele Bridge',
        PickupType.singleCoilTeleNeck => 'Single Coil\nTele Neck',
        PickupType.p90 => 'P-90',
        PickupType.humbuckerLowOutput => 'Humbucker\nLow Output',
        PickupType.humbuckerMediumOutput => 'Humbucker\nMedium Output',
        PickupType.humbuckerHighOutput => 'Humbucker\nHigh Output',
        PickupType.bassSingleCoil => 'Bass\nSingle Coil',
        PickupType.bassSplitHumbucker => 'Bass\nSplit Humbucker',
        PickupType.unknown => 'Unknown',
      };

  String get shortName => switch (this) {
        PickupType.singleCoilStrat => 'SC Strat',
        PickupType.singleCoilTeleBridge => 'SC Tele Br.',
        PickupType.singleCoilTeleNeck => 'SC Tele Nk.',
        PickupType.p90 => 'P-90',
        PickupType.humbuckerLowOutput => 'HB Low',
        PickupType.humbuckerMediumOutput => 'HB Medium',
        PickupType.humbuckerHighOutput => 'HB High',
        PickupType.bassSingleCoil => 'Bass SC',
        PickupType.bassSplitHumbucker => 'Bass SH',
        PickupType.unknown => 'Unknown',
      };
}

// ── Widget ────────────────────────────────────────────────────────────────────

/// Card grid displaying all 10 [PickupType] values.
///
/// Tapping a card selects it and invokes [onSelected].
/// The [unknown] type is shown last and visually de-emphasised.
class PickupTypeSelector extends StatelessWidget {
  const PickupTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PickupType selected;
  final ValueChanged<PickupType> onSelected;

  static const _orderedTypes = [
    PickupType.humbuckerMediumOutput,
    PickupType.humbuckerLowOutput,
    PickupType.humbuckerHighOutput,
    PickupType.singleCoilStrat,
    PickupType.singleCoilTeleBridge,
    PickupType.singleCoilTeleNeck,
    PickupType.p90,
    PickupType.bassSingleCoil,
    PickupType.bassSplitHumbucker,
    PickupType.unknown,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.5,
      ),
      itemCount: _orderedTypes.length,
      itemBuilder: (context, i) {
        final type = _orderedTypes[i];
        final isSelected = type == selected;
        return _TypeCard(
          type: type,
          isSelected: isSelected,
          onTap: () => onSelected(type),
        );
      },
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final PickupType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnknown = type == PickupType.unknown;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppTheme.primary.withAlpha(30) : AppTheme.surface,
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : isUnknown
                    ? AppTheme.surfaceVariant
                    : AppTheme.surfaceVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              type.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppTheme.primary
                    : isUnknown
                        ? AppTheme.onSurfaceDim
                        : AppTheme.onSurface,
                height: 1.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
