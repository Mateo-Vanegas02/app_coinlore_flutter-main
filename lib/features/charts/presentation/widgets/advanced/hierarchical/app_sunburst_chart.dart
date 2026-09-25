import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 26. Sunburst Chart (Anillos Concéntricos Jerárquicos)
class AppSunburstChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppSunburstChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final palette = [
      tokens.primaryColor,
      tokens.bullishColor,
      tokens.accentColor,
      tokens.secondaryColor,
    ];

    return SfCircularChart(
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.all(4),
      series: <CircularSeries<Map<String, dynamic>, String>>[
        RadialBarSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (d, _) => d['name'] as String,
          yValueMapper: (d, _) => (d['value'] as num).toDouble(),
          pointColorMapper: (d, i) => palette[i % palette.length],
          maximumValue: 100,
          innerRadius: '30%',
          radius: '95%',
          gap: '8%',
          cornerStyle: CornerStyle.bothCurve,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          enableTooltip: true,
        ),
      ],
      legend: Legend(
        isVisible: true,
        position: LegendPosition.right,
        textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 11),
        backgroundColor: Colors.transparent,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor),
      ),
    );
  }
}
