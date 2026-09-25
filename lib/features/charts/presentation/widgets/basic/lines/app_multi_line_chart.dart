import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;
import '../../../../domain/models/chart_point.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 5. Gráfico Multi-Línea (Comparativa de series)
class AppMultiLineChart extends StatelessWidget {
  final List<ChartPoint> data;

  const AppMultiLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final seriesNames = data.map((p) => p.series).whereType<String>().toSet().toList();
    final palette = [tokens.primaryColor, tokens.bullishColor, tokens.secondaryColor, tokens.accentColor];

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
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      series: seriesNames.asMap().entries.map((entry) {
        final idx = entry.key;
        final name = entry.value;
        final seriesData = data.where((p) => p.series == name).toList();
        return SplineSeries<ChartPoint, String>(
          name: name,
          dataSource: seriesData,
          xValueMapper: (p, _) => p.x.toString(),
          yValueMapper: (p, _) => p.y.toDouble(),
          color: palette[idx % palette.length],
          width: 2,
        );
      }).toList(),
    );
  }
}
