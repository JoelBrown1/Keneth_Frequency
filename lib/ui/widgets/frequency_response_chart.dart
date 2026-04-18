import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/frequency_response.dart';
import '../theme/app_theme.dart';

// ── Constants ──────────────────────────────────────────────────────────────────

const _minHz = 20.0;
const _maxHz = 20000.0;
const _minLogX = 1.30103;  // log10(20)
const _maxLogX = 4.30103;  // log10(20000)

// Chart area padding — must match SideTitles.reservedSize values below.
const _leftReserved = 44.0;
const _bottomReserved = 36.0;
const _topPad = 12.0;
const _rightPad = 16.0;

const _tickFrequencies = [
  20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000,
];
const _tickLabels = [
  '20', '50', '100', '200', '500', '1k', '2k', '5k', '10k', '20k',
];

double _logX(double hz) => math.log(hz) / math.ln10;

// ── Bandwidth helper ──────────────────────────────────────────────────────────

/// Finds the low and high -3 dB cutoff frequencies by scanning the response.
/// Returns null if the response is too sparse or the peak cannot be bracketed.
({double fLow, double fHigh})? _findBandwidth(
    FrequencyResponse response, double resonantHz) {
  if (response.points.length < 3) return null;
  final peak = response.atFrequency(resonantHz);
  if (peak == null) return null;
  final threshold = peak.magnitude - 3.0;

  // Scan left of peak for the lower -3 dB crossing.
  final leftPoints = response.points
      .where((p) => p.frequency < resonantHz)
      .toList()
    ..sort((a, b) => b.frequency.compareTo(a.frequency)); // nearest first

  double? fLow;
  for (final p in leftPoints) {
    if (p.magnitude < threshold) {
      fLow = p.frequency;
      break;
    }
  }

  // Scan right of peak.
  final rightPoints = response.points
      .where((p) => p.frequency > resonantHz)
      .toList()
    ..sort((a, b) => a.frequency.compareTo(b.frequency)); // nearest first

  double? fHigh;
  for (final p in rightPoints) {
    if (p.magnitude < threshold) {
      fHigh = p.frequency;
      break;
    }
  }

  if (fLow == null || fHigh == null) return null;
  return (fLow: fLow, fHigh: fHigh);
}

// ── FrequencyResponseChart ────────────────────────────────────────────────────

/// Log-scale frequency response chart with peak annotation, -3 dB bandwidth
/// shading, optional calibration reference curve, and pan/zoom.
///
/// [response] — primary measurement curve (display resolution ~1000 pts).
/// [resonantFrequency] — Hz; drives the peak marker vertical line.
/// [calibrationResponse] — optional reference curve rendered in grey.
/// [qFactor] — used to draw the -3 dB bandwidth band when [response] is
///   too coarse to find the crossing automatically.
/// [secondaryResponse] — optional second measurement for comparison mode.
/// [secondaryResonantFrequency] — Hz; drives a second (amber) peak marker.
class FrequencyResponseChart extends StatefulWidget {
  const FrequencyResponseChart({
    super.key,
    required this.response,
    required this.resonantFrequency,
    this.calibrationResponse,
    this.qFactor,
    this.secondaryResponse,
    this.secondaryResonantFrequency,
  });

  final FrequencyResponse response;
  final double resonantFrequency;
  final FrequencyResponse? calibrationResponse;
  final double? qFactor;
  final FrequencyResponse? secondaryResponse;
  final double? secondaryResonantFrequency;

  @override
  State<FrequencyResponseChart> createState() => _FrequencyResponseChartState();
}

class _FrequencyResponseChartState extends State<FrequencyResponseChart> {
  double _viewMinHz = _minHz;
  double _viewMaxHz = _maxHz;

  // Gesture tracking.
  double _scaleStart = 1.0;
  double _centerLogXAtScaleStart = 0.0;
  double _viewSpanAtScaleStart = 0.0;

  // ── Gesture handlers ────────────────────────────────────────────────────────

  void _onScaleStart(ScaleStartDetails d) {
    _scaleStart = 1.0;
    _viewSpanAtScaleStart = _viewMaxHz - _viewMinHz;
    _centerLogXAtScaleStart = (_viewMinHz + _viewMaxHz) / 2.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    if (d.scale == 1.0) {
      // Pan only.
      final logSpan = _logX(_viewMaxHz) - _logX(_viewMinHz);
      final dx = -d.focalPointDelta.dx;
      final context = this.context;
      final width = context.size?.width ?? 400;
      final plotWidth = width - _leftReserved - _rightPad;
      final logDelta = dx / plotWidth * logSpan;

      setState(() {
        var newMinLog = _logX(_viewMinHz) + logDelta;
        var newMaxLog = _logX(_viewMaxHz) + logDelta;
        // Clamp to global bounds.
        if (newMinLog < _minLogX) {
          newMaxLog += _minLogX - newMinLog;
          newMinLog = _minLogX;
        }
        if (newMaxLog > _maxLogX) {
          newMinLog -= newMaxLog - _maxLogX;
          newMaxLog = _maxLogX;
        }
        _viewMinHz = math.pow(10, newMinLog.clamp(_minLogX, _maxLogX)).toDouble();
        _viewMaxHz = math.pow(10, newMaxLog.clamp(_minLogX, _maxLogX)).toDouble();
      });
    } else {
      // Pinch zoom around center.
      final newSpan =
          (_viewSpanAtScaleStart / d.scale).clamp(100.0, _maxHz - _minHz);
      final center = _centerLogXAtScaleStart;
      setState(() {
        final newMinHz =
            (center - newSpan / 2).clamp(_minHz, _maxHz - 100.0);
        final newMaxHz =
            (center + newSpan / 2).clamp(_minHz + 100.0, _maxHz);
        _viewMinHz = newMinHz;
        _viewMaxHz = newMaxHz;
      });
    }
  }

  /// Scroll-wheel zoom (macOS trackpad or mouse wheel).
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final dy = event.scrollDelta.dy;
    final factor = dy > 0 ? 1.1 : 0.9;
    final span = _viewMaxHz - _viewMinHz;
    final center = (_viewMinHz + _viewMaxHz) / 2.0;
    setState(() {
      final newSpan = (span * factor).clamp(100.0, _maxHz - _minHz);
      _viewMinHz = (center - newSpan / 2).clamp(_minHz, _maxHz - 100.0);
      _viewMaxHz = (center + newSpan / 2).clamp(_minHz + 100.0, _maxHz);
    });
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final logMin = _logX(_viewMinHz);
    final logMax = _logX(_viewMaxHz);

    // Build primary spots.
    final spots = widget.response.points
        .where((p) => p.frequency >= _minHz && p.frequency <= _maxHz)
        .map((p) => FlSpot(_logX(p.frequency), p.magnitude))
        .toList();

    // Y-axis range: ±5 dB around peak, with a minimum span of 20 dB.
    final peakPoint = widget.response.maxMagnitude();
    final peakMag = peakPoint?.magnitude ?? 0.0;
    final minMag = spots.isEmpty
        ? -30.0
        : spots.map((s) => s.y).reduce(math.min);
    final yMin = (math.min(minMag, peakMag - 10.0) - 5.0);
    final yMax = peakMag + 5.0;

    // Calibration spots.
    final calSpots = widget.calibrationResponse?.points
        .where((p) => p.frequency >= _minHz && p.frequency <= _maxHz)
        .map((p) => FlSpot(_logX(p.frequency), p.magnitude))
        .toList();

    // Secondary (comparison) spots.
    final secSpots = widget.secondaryResponse?.points
        .where((p) => p.frequency >= _minHz && p.frequency <= _maxHz)
        .map((p) => FlSpot(_logX(p.frequency), p.magnitude))
        .toList();

    // -3 dB bandwidth.
    final band =
        _findBandwidth(widget.response, widget.resonantFrequency);

    // Peak marker X value (clamped to view).
    final peakLogX = _logX(widget.resonantFrequency)
        .clamp(logMin, logMax);

    // Secondary peak marker X value.
    final secPeakLogX = widget.secondaryResonantFrequency != null
        ? _logX(widget.secondaryResonantFrequency!).clamp(logMin, logMax)
        : null;

    // Y-tick interval (auto ~5 or 10 dB steps).
    final ySpan = yMax - yMin;
    final yInterval = ySpan > 40 ? 10.0 : 5.0;

    return Listener(
      onPointerSignal: _onPointerSignal,
      child: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // ── Main chart ─────────────────────────────────────────────
                LineChart(
                  LineChartData(
                    minX: logMin,
                    maxX: logMax,
                    minY: yMin,
                    maxY: yMax,
                    clipData: const FlClipData.all(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text('Frequency (Hz)',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.onSurfaceDim)),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: _bottomReserved,
                          interval: 0.1,
                          getTitlesWidget: (value, meta) {
                            for (var i = 0;
                                i < _tickFrequencies.length;
                                i++) {
                              final expected =
                                  _logX(_tickFrequencies[i].toDouble());
                              if ((value - expected).abs() < 0.015) {
                                // Only show ticks in view.
                                if (expected < logMin - 0.05 ||
                                    expected > logMax + 0.05) {
                                  return const SizedBox.shrink();
                                }
                                return Text(
                                  _tickLabels[i],
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: AppTheme.onSurfaceDim),
                                );
                              }
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Text('dB',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.onSurfaceDim)),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: _leftReserved,
                          interval: yInterval,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.onSurfaceDim),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (_) => const FlLine(
                        color: Color(0xFF2A2A2A),
                        strokeWidth: 0.5,
                      ),
                      getDrawingVerticalLine: (_) => const FlLine(
                        color: Color(0xFF2A2A2A),
                        strokeWidth: 0.5,
                      ),
                      verticalInterval: 0.1,
                      horizontalInterval: yInterval,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: AppTheme.surfaceVariant),
                    ),
                    extraLinesData: ExtraLinesData(
                      verticalLines: [
                        // Grid lines at tick frequencies.
                        ..._tickFrequencies.map((hz) => VerticalLine(
                              x: _logX(hz.toDouble()),
                              color: const Color(0xFF222222),
                              strokeWidth: 0.5,
                            )),

                        // Peak marker — cyan dashed line.
                        VerticalLine(
                          x: peakLogX,
                          color: AppTheme.primary.withAlpha(200),
                          strokeWidth: 1.5,
                          dashArray: [6, 4],
                          label: VerticalLineLabel(
                            show: true,
                            alignment: Alignment.topRight,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.primary,
                              fontFamily: 'RobotoMono',
                            ),
                            labelResolver: (_) =>
                                formatHzLabel(widget.resonantFrequency),
                          ),
                        ),

                        // -3 dB boundary lines (only when no comparison mode).
                        if (band != null &&
                            band.fLow >= _minHz &&
                            secSpots == null) ...[
                          VerticalLine(
                            x: _logX(band.fLow).clamp(logMin, logMax),
                            color: AppTheme.secondary.withAlpha(160),
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                          VerticalLine(
                            x: _logX(band.fHigh).clamp(logMin, logMax),
                            color: AppTheme.secondary.withAlpha(160),
                            strokeWidth: 1,
                            dashArray: [4, 4],
                          ),
                        ],

                        // Secondary peak marker — amber dashed line.
                        if (secPeakLogX != null)
                          VerticalLine(
                            x: secPeakLogX,
                            color: AppTheme.secondary.withAlpha(200),
                            strokeWidth: 1.5,
                            dashArray: [6, 4],
                            label: VerticalLineLabel(
                              show: true,
                              alignment: Alignment.topLeft,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.secondary,
                                fontFamily: 'RobotoMono',
                              ),
                              labelResolver: (_) => formatHzLabel(
                                  widget.secondaryResonantFrequency!),
                            ),
                          ),
                      ],
                    ),
                    lineBarsData: [
                      // Primary response curve.
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.15,
                        color: AppTheme.primary,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppTheme.primary.withAlpha(20),
                        ),
                      ),

                      // Secondary (comparison) response curve — amber.
                      if (secSpots != null && secSpots.isNotEmpty)
                        LineChartBarData(
                          spots: secSpots,
                          isCurved: true,
                          curveSmoothness: 0.15,
                          color: AppTheme.secondary,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.secondary.withAlpha(20),
                          ),
                        ),

                      // Calibration reference curve (grey, dashed).
                      if (calSpots != null && calSpots.isNotEmpty)
                        LineChartBarData(
                          spots: calSpots,
                          isCurved: true,
                          curveSmoothness: 0.15,
                          color: AppTheme.onSurfaceDim.withAlpha(140),
                          barWidth: 1,
                          dashArray: [6, 4],
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => AppTheme.surfaceVariant,
                        getTooltipItems: (spots) => spots
                            .map((s) => LineTooltipItem(
                                  '${formatHzLabel(math.pow(10, s.x).toDouble())}  '
                                  '${s.y.toStringAsFixed(1)} dB',
                                  const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primary,
                                    fontFamily: 'RobotoMono',
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  duration: const Duration(milliseconds: 0),
                ),

                // ── -3 dB bandwidth shading overlay ───────────────────────
                if (band != null)
                  _BandShadeOverlay(
                    fLow: band.fLow,
                    fHigh: band.fHigh,
                    viewMinLogX: logMin,
                    viewMaxLogX: logMax,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Band shading overlay ──────────────────────────────────────────────────────

class _BandShadeOverlay extends StatelessWidget {
  const _BandShadeOverlay({
    required this.fLow,
    required this.fHigh,
    required this.viewMinLogX,
    required this.viewMaxLogX,
  });

  final double fLow;
  final double fHigh;
  final double viewMinLogX;
  final double viewMaxLogX;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _BandShadePainter(
          logFLow: _logX(fLow),
          logFHigh: _logX(fHigh),
          viewMinLogX: viewMinLogX,
          viewMaxLogX: viewMaxLogX,
        ),
      ),
    );
  }
}

class _BandShadePainter extends CustomPainter {
  const _BandShadePainter({
    required this.logFLow,
    required this.logFHigh,
    required this.viewMinLogX,
    required this.viewMaxLogX,
  });

  final double logFLow;
  final double logFHigh;
  final double viewMinLogX;
  final double viewMaxLogX;

  @override
  void paint(Canvas canvas, Size size) {
    final plotLeft = _leftReserved;
    final plotRight = size.width - _rightPad;
    final plotTop = _topPad;
    final plotBottom = size.height - _bottomReserved;
    final plotWidth = plotRight - plotLeft;

    final logSpan = viewMaxLogX - viewMinLogX;
    if (logSpan <= 0) return;

    double logToPixel(double logX) =>
        plotLeft + (logX - viewMinLogX) / logSpan * plotWidth;

    final xLeft =
        logToPixel(logFLow).clamp(plotLeft, plotRight);
    final xRight =
        logToPixel(logFHigh).clamp(plotLeft, plotRight);

    final paint = Paint()
      ..color = AppTheme.secondary.withAlpha(30)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTRB(xLeft, plotTop, xRight, plotBottom),
      paint,
    );
  }

  @override
  bool shouldRepaint(_BandShadePainter old) =>
      old.logFLow != logFLow ||
      old.logFHigh != logFHigh ||
      old.viewMinLogX != viewMinLogX ||
      old.viewMaxLogX != viewMaxLogX;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Formats a frequency value as a human-readable label.
///
/// ≥ 1 kHz → "X.XX kHz"; < 1 kHz → "X.X Hz".
/// Used by [FrequencyResponseChart] peak marker and exposed for unit tests.
String formatHzLabel(double hz) {
  if (hz >= 1000) {
    return '${(hz / 1000).toStringAsFixed(2)} kHz';
  }
  return '${hz.toStringAsFixed(1)} Hz';
}
