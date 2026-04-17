import 'frequency_response.dart';
import 'pickup_type.dart';

class PickupMeasurement {
  const PickupMeasurement({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.pickupName,
    required this.dcr,
    required this.ambientTempC,
    required this.resonantFrequency,
    required this.qFactor,
    required this.peakAmplitudeDb,
    required this.response,
    required this.calibrationApplied,
    this.dcrCorrected,
    this.inductance,
    this.capacitance,
  });

  final String id;
  final DateTime timestamp;
  final PickupType type;
  final String pickupName;
  final double dcr;             // Ω — entered manually
  final double ambientTempC;    // °C — entered manually
  final double resonantFrequency; // Hz — computed
  final double qFactor;           // dimensionless — computed
  final double peakAmplitudeDb;   // dB above baseline — computed
  final double? dcrCorrected;     // Ω — DCR normalised to 20°C
  final double? inductance;       // H — derived from f_res + C_typical
  final double? capacitance;      // F — derived from f_res + L_typical
  final FrequencyResponse response;
  final bool calibrationApplied;
}
