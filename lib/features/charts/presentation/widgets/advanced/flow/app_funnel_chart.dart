import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 27. Funnel / Pyramid Chart (Embudo de Conversión)
class AppFunnelChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppFunnelChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final colors = [
      tokens.primaryColor,
      tokens.accentColor,
      tokens.secondaryColor,
      tokens.bullishColor,
    ];

    return SfFunnelChart(
      backgroundColor: Colors.transparent,
      series: FunnelSeries<Map<String, dynamic>, String>(
        dataSource: data,
        xValueMapper: (d, _) => d['stage'] as String,
        yValueMapper: (d, _) => (d['value'] as num).toDouble(),
        pointColorMapper: (d, i) => colors[i % colors.length],
        neckWidth: '35%',
        neckHeight: '20%',
        gapRatio: 0.05,
        dataLabelSettings: const DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.inside,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor),
      ),
      legend: Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
