// S0-15 spike: fl_chart log-scale X axis feasibility.
// Verifies that tick labels render correctly at 20, 100, 1k, 10k, 20k Hz.
// This screen is for spike verification only — remove before Sprint 7.

import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Frequency ticks and their display labels for a log X axis.
const _tickFrequencies = [20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000];
const _tickLabels = ['20', '50', '100', '200', '500', '1k', '2k', '5k', '10k', '20k'];

double _logX(double hz) => math.log(hz) / math.ln10;

/// Synthesises a simple resonance peak curve for the spike visual.
List<FlSpot> _syntheticPeakCurve() {
  final spots = <FlSpot>[];
  for (var i = 0; i <= 200; i++) {
    final hz = 20.0 * math.pow(1000.0, i / 200.0); // 20 Hz → 20 kHz log-spaced
    final peak = 4780.0;
    final q = 4.0;
    final ratio = hz / peak;
    final denom = (1 - ratio * ratio) * (1 - ratio * ratio) +
        (ratio / q) * (ratio / q);
    final db = -10 * math.log(denom) / math.ln10;
    spots.add(FlSpot(_logX(hz), db.clamp(-30.0, 10.0)));
  }
  return spots;
}

class LogAxisSpikeScreen extends StatelessWidget {
  const LogAxisSpikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spots = _syntheticPeakCurve();
    const minX = 1.301; // log10(20)
    const maxX = 4.301; // log10(20000)

    return Scaffold(
      appBar: AppBar(title: const Text('S0-15: fl_chart Log Axis Spike')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
            minY: -30,
            maxY: 10,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                axisNameWidget: const Text('Frequency (Hz)'),
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 0.1,
                  getTitlesWidget: (value, meta) {
                    // Only show labels at our pre-defined tick frequencies
                    for (var i = 0; i < _tickFrequencies.length; i++) {
                      final expected = _logX(_tickFrequencies[i].toDouble());
                      if ((value - expected).abs() < 0.01) {
                        return Text(_tickLabels[i],
                            style: const TextStyle(fontSize: 10));
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                axisNameWidget: const Text('dB'),
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            extraLinesData: ExtraLinesData(
              verticalLines: _tickFrequencies.map((hz) {
                return VerticalLine(
                  x: _logX(hz.toDouble()),
                  color: Colors.white12,
                  strokeWidth: 0.5,
                );
              }).toList(),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.cyanAccent,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            gridData: const FlGridData(show: false),
          ),
        ),
      ),
    );
  }
}
