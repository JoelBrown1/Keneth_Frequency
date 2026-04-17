import '../entities/pickup_profile.dart';
import '../entities/pickup_type.dart';

class PickupReferenceData {
  const PickupReferenceData._();

  static const List<PickupProfile> profiles = [
    PickupProfile(
      type: PickupType.singleCoilStrat,
      label: 'Single coil — Strat',
      dcrRangeKohm: DcrRange(min: 5, max: 7),
      inductanceRangeH: InductanceRange(min: 2, max: 3),
      searchRangeHz: FrequencyRange(min: 7000, max: 12000),
      multimeterRangeKohm: 20,
    ),
    PickupProfile(
      type: PickupType.singleCoilTeleBridge,
      label: 'Single coil — Tele bridge',
      dcrRangeKohm: DcrRange(min: 6, max: 8),
      inductanceRangeH: InductanceRange(min: 2.5, max: 3.5),
      searchRangeHz: FrequencyRange(min: 8000, max: 11000),
      multimeterRangeKohm: 20,
    ),
    PickupProfile(
      type: PickupType.singleCoilTeleNeck,
      label: 'Single coil — Tele neck',
      dcrRangeKohm: DcrRange(min: 6, max: 8),
      inductanceRangeH: InductanceRange(min: 3, max: 4),
      searchRangeHz: FrequencyRange(min: 7000, max: 10000),
      multimeterRangeKohm: 20,
    ),
    PickupProfile(
      type: PickupType.p90,
      label: 'P-90',
      dcrRangeKohm: DcrRange(min: 7, max: 10),
      inductanceRangeH: InductanceRange(min: 4, max: 6),
      searchRangeHz: FrequencyRange(min: 5000, max: 8000),
      multimeterRangeKohm: 20,
    ),
    PickupProfile(
      type: PickupType.humbuckerLowOutput,
      label: 'Humbucker — PAF-style (low output)',
      dcrRangeKohm: DcrRange(min: 7, max: 9),
      inductanceRangeH: InductanceRange(min: 4, max: 6),
      searchRangeHz: FrequencyRange(min: 5000, max: 7000),
      multimeterRangeKohm: 20,
    ),
    PickupProfile(
      type: PickupType.humbuckerMediumOutput,
      label: 'Humbucker — medium output (e.g. SH-4 JB)',
      dcrRangeKohm: DcrRange(min: 14, max: 17),
      inductanceRangeH: InductanceRange(min: 7, max: 10),
      searchRangeHz: FrequencyRange(min: 4000, max: 6000),
      multimeterRangeKohm: 20,
      verificationPickup: 'Seymour Duncan JB SH-4 (~4.78 kHz unloaded)',
    ),
    PickupProfile(
      type: PickupType.humbuckerHighOutput,
      label: 'Humbucker — high output',
      dcrRangeKohm: DcrRange(min: 16, max: 20),
      inductanceRangeH: InductanceRange(min: 10, max: 15),
      searchRangeHz: FrequencyRange(min: 2000, max: 4000),
      multimeterRangeKohm: 20,
    ),
    PickupProfile(
      type: PickupType.bassSingleCoil,
      label: 'Bass — single coil (J-style)',
      dcrRangeKohm: DcrRange(min: 6, max: 10),
      inductanceRangeH: InductanceRange(min: 3, max: 6),
      searchRangeHz: FrequencyRange(min: 4000, max: 8000),
      multimeterRangeKohm: 20,
    ),
    PickupProfile(
      type: PickupType.bassSplitHumbucker,
      label: 'Bass — split humbucker (P-style)',
      dcrRangeKohm: DcrRange(min: 8, max: 12),
      inductanceRangeH: InductanceRange(min: 6, max: 10),
      searchRangeHz: FrequencyRange(min: 2000, max: 5000),
      multimeterRangeKohm: 20,
    ),
    PickupProfile(
      type: PickupType.unknown,
      label: 'Unknown',
      dcrRangeKohm: DcrRange(min: 0, max: 100),
      inductanceRangeH: InductanceRange(min: 0, max: 20),
      searchRangeHz: FrequencyRange(min: 500, max: 20000),
      multimeterRangeKohm: 20,
    ),
  ];

  /// Returns the [PickupProfile] for [type], or null if not found.
  static PickupProfile? forType(PickupType type) {
    try {
      return profiles.firstWhere((p) => p.type == type);
    } catch (_) {
      return null;
    }
  }
}
