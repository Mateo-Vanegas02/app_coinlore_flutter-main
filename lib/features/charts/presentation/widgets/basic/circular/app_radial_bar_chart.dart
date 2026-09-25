import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 17. Radial Bar Chart
class AppRadialBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppRadialBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final palette = [tokens.primaryColor, tokens.bullishColor, tokens.accentColor, tokens.secondaryColor];

    return SfCircularChart(
      backgroundColor: Colors.transparent,
      series: <CircularSeries<Map<String, dynamic>, String>>[
        RadialBarSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (d, _) => d['name'] as String,
          yValueMapper: (d, _) => (d['value'] as num).toDouble(),
          pointColorMapper: (d, i) => palette[i % palette.length],
          maximumValue: 100,
          innerRadius: '30%',
          cornerStyle: CornerStyle.bothCurve,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 9),
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
