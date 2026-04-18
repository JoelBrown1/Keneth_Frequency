import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/pickup_type.dart';
import '../../domain/services/lc_calculator.dart';
import '../theme/app_theme.dart';

// ── DCR range validation ──────────────────────────────────────────────────────

/// Returns the valid DCR range (Ω) for [type], or null if no validation applies.
///
/// Ranges are taken from §9 of the architecture document.
({double min, double max})? dcrRangeFor(PickupType type) => switch (type) {
      PickupType.singleCoilStrat ||
      PickupType.singleCoilTeleBridge ||
      PickupType.singleCoilTeleNeck =>
        (min: 4000, max: 10000),
      PickupType.p90 => (min: 6000, max: 12000),
      PickupType.humbuckerLowOutput => (min: 6000, max: 10000),
      PickupType.humbuckerMediumOutput => (min: 12000, max: 18000),
      PickupType.humbuckerHighOutput => (min: 14000, max: 22000),
      PickupType.bassSingleCoil => (min: 4000, max: 12000),
      PickupType.bassSplitHumbucker => (min: 6000, max: 14000),
      PickupType.unknown => null,
    };

// ── Formatters ────────────────────────────────────────────────────────────────

final _ohmsFormat = NumberFormat('#,###', 'en_US');

String _formatOhms(double ohms) => '${_ohmsFormat.format(ohms.round())} Ω';

// ── Widget ────────────────────────────────────────────────────────────────────

/// Combined DCR + ambient temperature form.
///
/// Shows:
/// - DCR input field with type-aware out-of-range warning (§9).
/// - Temperature field (defaults to 20 °C).
/// - Live corrected-DCR display at 20 °C (M-02).
///
/// Calls [onChanged] whenever either field changes with parsed values.
/// Passes null if the DCR field is empty or non-numeric.
class DcrInputForm extends StatefulWidget {
  const DcrInputForm({
    super.key,
    required this.pickupType,
    this.initialDcr,
    this.initialTempC = 20.0,
    required this.onChanged,
  });

  final PickupType pickupType;
  final double? initialDcr;
  final double initialTempC;

  /// Called whenever DCR or temperature changes.
  final void Function(double? dcr, double tempC) onChanged;

  @override
  State<DcrInputForm> createState() => DcrInputFormState();
}

class DcrInputFormState extends State<DcrInputForm> {
  late final TextEditingController _dcrController;
  late final TextEditingController _tempController;
  late final FocusNode _dcrFocus;

  double? _dcr;
  double _tempC = 20.0;
  String? _rangeWarning;

  @override
  void initState() {
    super.initState();
    _dcr = widget.initialDcr;
    _tempC = widget.initialTempC;
    _dcrController = TextEditingController(
        text: widget.initialDcr != null
            ? widget.initialDcr!.round().toString()
            : '');
    _tempController =
        TextEditingController(text: widget.initialTempC.toStringAsFixed(1));
    _dcrFocus = FocusNode();
    _validate(_dcr);
  }

  @override
  void dispose() {
    _dcrController.dispose();
    _tempController.dispose();
    _dcrFocus.dispose();
    super.dispose();
  }

  void _onDcrChanged(String text) {
    final parsed = double.tryParse(text.replaceAll(',', ''));
    setState(() {
      _dcr = parsed;
      _validate(parsed);
    });
    widget.onChanged(_dcr, _tempC);
  }

  void _onTempChanged(String text) {
    final parsed = double.tryParse(text) ?? 20.0;
    setState(() => _tempC = parsed);
    widget.onChanged(_dcr, _tempC);
  }

  void _validate(double? dcr) {
    if (dcr == null) {
      _rangeWarning = null;
      return;
    }
    final range = dcrRangeFor(widget.pickupType);
    if (range != null && (dcr < range.min || dcr > range.max)) {
      _rangeWarning =
          'DCR of ${_ohmsFormat.format(dcr.round())} Ω is outside the typical '
          'range for this pickup type (${_ohmsFormat.format(range.min.round())}–'
          '${_ohmsFormat.format(range.max.round())} Ω). '
          'Check multimeter range setting.';
    } else {
      _rangeWarning = null;
    }
  }

  double? get _correctedDcr {
    final d = _dcr;
    if (d == null) return null;
    return const LcCalculator().correctDcrForTemperature(d, _tempC);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DCR field.
        TextFormField(
          key: const Key('dcr_field'),
          controller: _dcrController,
          focusNode: _dcrFocus,
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d,]'))],
          decoration: InputDecoration(
            labelText: 'DCR (Ω)',
            hintText: 'e.g. 8200',
            suffixText: 'Ω',
            errorText: _rangeWarning != null ? '' : null,
          ),
          onChanged: _onDcrChanged,
        ),

        // Out-of-range warning.
        if (_rangeWarning != null) ...[
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 16, color: AppTheme.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _rangeWarning!,
                  key: const Key('dcr_range_warning'),
                  style: AppTheme.warningText,
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 16),

        // Temperature field.
        TextFormField(
          key: const Key('temp_field'),
          controller: _tempController,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true, signed: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.\-]'))
          ],
          decoration: const InputDecoration(
            labelText: 'Ambient temperature',
            suffixText: '°C',
            hintText: '20.0',
          ),
          onChanged: _onTempChanged,
        ),

        const SizedBox(height: 16),

        // Live corrected DCR display (M-02).
        _CorrectedDcrRow(correctedDcr: _correctedDcr),
      ],
    );
  }
}

// ── Corrected DCR display ────────────────────────────────────────────────────

class _CorrectedDcrRow extends StatelessWidget {
  const _CorrectedDcrRow({required this.correctedDcr});

  final double? correctedDcr;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.surface),
      ),
      child: Row(
        children: [
          const Icon(Icons.thermostat, size: 16, color: AppTheme.onSurfaceDim),
          const SizedBox(width: 8),
          Text(
            'Corrected to 20°C: ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            correctedDcr != null
                ? _formatOhms(correctedDcr!)
                : '— Ω',
            key: const Key('corrected_dcr_value'),
            style: AppTheme.measurementSmall.copyWith(
              color: correctedDcr != null
                  ? AppTheme.primary
                  : AppTheme.onSurfaceDim,
            ),
          ),
        ],
      ),
    );
  }
}
