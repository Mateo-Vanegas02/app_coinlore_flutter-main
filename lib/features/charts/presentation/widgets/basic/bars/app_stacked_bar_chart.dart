import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 10. Gráfico de Barras Apiladas
class AppStackedBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppStackedBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final types = data.map((d) => d['type'] as String).toSet().toList();
    final colors = [tokens.primaryColor, tokens.accentColor, tokens.secondaryColor];

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
      series: types.asMap().entries.map((entry) {
        final idx = entry.key;
        final type = entry.value;
        final typeData = data.where((d) => d['type'] == type).toList();
        return StackedColumnSeries<Map<String, dynamic>, String>(
          name: type,
          dataSource: typeData,
          xValueMapper: (d, _) => d['category'] as String,
          yValueMapper: (d, _) => (d['value'] as num).toDouble(),
          color: colors[idx % colors.length],
        );
      }).toList(),
    );
  }
}
