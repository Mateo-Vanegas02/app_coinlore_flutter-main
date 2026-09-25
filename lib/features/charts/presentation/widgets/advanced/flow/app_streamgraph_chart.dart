import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 32. Streamgraph (Río de Datos / Área de Flujo Apilada)
class AppStreamgraphChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppStreamgraphChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final item in data) {
      final type = item['type'] as String;
      grouped.putIfAbsent(type, () => []).add(item);
    }

    final colors = [
      tokens.primaryColor,
      tokens.secondaryColor,
      tokens.accentColor,
      tokens.bullishColor,
    ];

    int idx = 0;
    final seriesList = grouped.entries.map((entry) {
      final color = colors[idx % colors.length];
      idx++;

      return StackedAreaSeries<Map<String, dynamic>, String>(
        name: entry.key,
        dataSource: entry.value,
        xValueMapper: (d, _) => d['date'] as String,
        yValueMapper: (d, _) => (d['value'] as num).toDouble(),
        color: color.withValues(alpha: 0.65),
        borderColor: color,
        borderWidth: 2,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.75),
            color.withValues(alpha: 0.25),
          ],
        ),
      );
    }).toList();

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: 'Volumen (\$B)',
          textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        ),
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      series: seriesList,
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
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
