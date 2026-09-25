import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 15. Velocímetro / Gauge Chart
class AppGaugeChart extends StatelessWidget {
  final double score;

  const AppGaugeChart({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final color = score >= 70
        ? tokens.bullishColor
        : score >= 40
            ? tokens.accentColor
            : tokens.bearishColor;

    return SfCircularChart(
      backgroundColor: Colors.transparent,
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                'Índice',
                style: TextStyle(fontSize: 11, color: tokens.axisLabelColor),
              ),
            ],
          ),
        ),
      ],
      series: <CircularSeries<_GaugeData, String>>[
        RadialBarSeries<_GaugeData, String>(
          dataSource: [
            _GaugeData('Score', score, color),
            _GaugeData('Remaining', 100 - score, tokens.gridLineColor),
          ],
          xValueMapper: (d, _) => d.label,
          yValueMapper: (d, _) => d.value,
          pointColorMapper: (d, _) => d.color,
          innerRadius: '60%',
          maximumValue: 100,
          cornerStyle: CornerStyle.bothCurve,
        ),
      ],
    );
  }
}

class _GaugeData {
  final String label;
  final double value;
  final Color color;
  const _GaugeData(this.label, this.value, this.color);
}
