import 'pickup_type.dart';

class FrequencyRange {
  const FrequencyRange({required this.min, required this.max});

  final double min; // Hz
  final double max; // Hz
}

class DcrRange {
  const DcrRange({required this.min, required this.max});

  final double min; // kΩ
  final double max; // kΩ
}

class InductanceRange {
  const InductanceRange({required this.min, required this.max});

  final double min; // H
  final double max; // H
}

class PickupProfile {
  const PickupProfile({
    required this.type,
    required this.label,
    required this.dcrRangeKohm,
    required this.inductanceRangeH,
    required this.searchRangeHz,
    required this.multimeterRangeKohm,
    this.verificationPickup,
    this.notMeasurable = false,
  });

  final PickupType type;
  final String label;
  final DcrRange dcrRangeKohm;
  final InductanceRange inductanceRangeH;

  /// Valid frequency range for resonant peak search (Hz).
  final FrequencyRange searchRangeHz;

  /// Recommended multimeter range in kΩ.
  final double multimeterRangeKohm;

  /// Optional name of a well-known verification pickup for this type.
  final String? verificationPickup;

  /// True for active pickups where measurement is not meaningful.
  final bool notMeasurable;
}
