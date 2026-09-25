import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;
import '../../../../domain/models/chart_point.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 16. Nightingale Rose Chart
class AppRoseChart extends StatelessWidget {
  final List<ChartPoint> data;

  const AppRoseChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final palette = [
      tokens.primaryColor,
      tokens.bullishColor,
      tokens.accentColor,
      tokens.secondaryColor,
      tokens.bearishColor,
    ];

    return SfCircularChart(
      backgroundColor: Colors.transparent,
      series: <CircularSeries<ChartPoint, String>>[
        RadialBarSeries<ChartPoint, String>(
          dataSource: data,
          xValueMapper: (p, _) => p.x.toString(),
          yValueMapper: (p, _) => p.y.toDouble(),
          pointColorMapper: (p, i) => palette[i % palette.length],
          maximumValue: 100,
          innerRadius: '20%',
          cornerStyle: CornerStyle.bothCurve,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 9),
          ),
        ),
      ],
      legend: Legend(
        isVisible: true,
        textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
