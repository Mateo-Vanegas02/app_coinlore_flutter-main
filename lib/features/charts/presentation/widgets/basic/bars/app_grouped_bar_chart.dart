import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 9. Gráfico de Barras Agrupadas
class AppGroupedBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppGroupedBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final groups = data.map((d) => d['group'] as String).toSet().toList();
    final colors = [tokens.primaryColor, tokens.secondaryColor, tokens.accentColor];

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
      ),
      series: groups.asMap().entries.map((entry) {
        final idx = entry.key;
        final group = entry.value;
        final groupData = data.where((d) => d['group'] == group).toList();
        return ColumnSeries<Map<String, dynamic>, String>(
          name: group,
          dataSource: groupData,
          xValueMapper: (d, _) => d['category'] as String,
          yValueMapper: (d, _) => (d['value'] as num).toDouble(),
          color: colors[idx % colors.length],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
        );
      }).toList(),
    );
  }
}
