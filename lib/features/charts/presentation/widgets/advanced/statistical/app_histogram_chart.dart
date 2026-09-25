import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 23. Histograma de Frecuencia
class AppHistogramChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppHistogramChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: 'Frecuencia',
          textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        ),
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: <CartesianSeries<Map<String, dynamic>, String>>[
        ColumnSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (d, _) => d['bin'] as String,
          yValueMapper: (d, _) => (d['frequency'] as num).toDouble(),
          color: tokens.accentColor,
          spacing: 0,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 9),
          ),
        ),
      ],
    );
  }
}
