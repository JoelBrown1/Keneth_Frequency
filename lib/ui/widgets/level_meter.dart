import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Vertical RMS level bar with clip warning and optional SNR indicator.
///
/// [rms] is linear amplitude (0.0–1.0). Internally converted to dBFS.
/// [snrDb] — when non-null and below 10 dB, a "Low SNR" warning is shown.
///
/// Colour zones:
///   −60 to −12 dBFS → green
///   −12 to  −3 dBFS → yellow
///    −3 to   0 dBFS → red
class LevelMeter extends StatelessWidget {
  const LevelMeter({
    super.key,
    required this.rms,
    this.snrDb,
    this.height = 160,
  });

  final double rms;
  final double? snrDb;
  final double height;

  static const _minDb = -60.0;
  static const _maxDb = 0.0;
  static const _clipThreshold = 0.98; // matches SignalValidator
  static const _lowSnrThreshold = 10.0;

  double get _dbfs {
    if (rms <= 0) return _minDb;
    final db = 20 * math.log(rms) / math.ln10;
    return db.clamp(_minDb, _maxDb);
  }

  double get _fraction => (_dbfs - _minDb) / (_maxDb - _minDb);

  bool get _isClipping => rms >= _clipThreshold;
  bool get _isLowSnr => snrDb != null && snrDb! < _lowSnrThreshold;

  Color get _barColor {
    if (_dbfs >= -3) return AppTheme.levelRed;
    if (_dbfs >= -12) return AppTheme.levelYellow;
    return AppTheme.levelGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Level bar.
        SizedBox(
          height: height,
          width: 28,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Track.
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Fill.
              FractionallySizedBox(
                heightFactor: _fraction.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _barColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Clip marker at −3 dBFS.
              Positioned(
                bottom: height * ((-3 - _minDb) / (_maxDb - _minDb)),
                left: 0,
                right: 0,
                child: Container(height: 1, color: AppTheme.levelRed),
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // dBFS readout.
        Text(
          '${_dbfs.toStringAsFixed(1)} dBFS',
          style: AppTheme.measurementSmall,
        ),

        // Clip warning.
        if (_isClipping) ...[
          const SizedBox(height: 4),
          const Text(
            'CLIP',
            key: Key('clip_warning'),
            style: AppTheme.errorText,
          ),
        ],

        // Low SNR warning.
        if (_isLowSnr) ...[
          const SizedBox(height: 4),
          Text(
            'Low SNR (${snrDb!.toStringAsFixed(1)} dB)',
            key: const Key('low_snr_warning'),
            style: AppTheme.warningText,
          ),
        ],
      ],
    );
  }
}
