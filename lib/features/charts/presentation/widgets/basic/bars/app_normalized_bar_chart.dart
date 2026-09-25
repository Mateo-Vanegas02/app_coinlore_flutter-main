import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 11. Barras 100% Apiladas (Normalized)
class AppNormalizedBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppNormalizedBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final segments = data.map((d) => d['segment'] as String).toSet().toList();
    final colors = [tokens.bullishColor, tokens.bearishColor, tokens.primaryColor, tokens.accentColor];

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      legend: Legend(
        isVisible: true,
        textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        backgroundColor: Colors.transparent,
      ),
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        minimum: 0,
        maximum: 100,
      ),
      series: segments.asMap().entries.map((entry) {
        final idx = entry.key;
        final segment = entry.value;
        final segData = data.where((d) => d['segment'] == segment).toList();
        return StackedColumn100Series<Map<String, dynamic>, String>(
          name: segment,
          dataSource: segData,
          xValueMapper: (d, _) => d['category'] as String,
          yValueMapper: (d, _) => (d['percent'] as num).toDouble(),
          color: colors[idx % colors.length],
        );
      }).toList(),
    );
  }
}
