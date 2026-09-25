import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 28. Parallel Coordinates (Coordenadas Paralelas Multidimensionales)
class AppParallelCoordChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppParallelCoordChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    // Agrupar puntos por criptomoneda / activo
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final item in data) {
      final crypto = item['crypto'] as String;
      grouped.putIfAbsent(crypto, () => []).add(item);
    }

    final palette = [
      tokens.primaryColor,
      tokens.secondaryColor,
      tokens.bullishColor,
      tokens.accentColor,
    ];

    int colorIdx = 0;
    final seriesList = grouped.entries.map((entry) {
      final color = palette[colorIdx % palette.length];
      colorIdx++;

      return SplineSeries<Map<String, dynamic>, String>(
        name: entry.key,
        dataSource: entry.value,
        xValueMapper: (d, _) => d['metric'] as String,
        yValueMapper: (d, _) => (d['score'] as num).toDouble(),
        color: color,
        width: 2.5,
        markerSettings: MarkerSettings(
          isVisible: true,
          shape: DataMarkerType.circle,
          width: 7,
          height: 7,
          color: color,
          borderColor: tokens.cardBackgroundColor,
          borderWidth: 1.5,
        ),
      );
    }).toList();

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(
          color: tokens.axisLabelColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(
          color: tokens.gridLineColor,
          dashArray: const <double>[4, 4],
        ),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 105,
        interval: 25,
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
