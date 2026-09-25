import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 18. Scatter Plot
class AppScatterChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppScatterChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
        title: AxisTitle(
          text: 'Cap. Mercado (\$B)',
          textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        ),
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: 'Retorno 24h (%)',
          textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        ),
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: <CartesianSeries<Map<String, dynamic>, double>>[
        ScatterSeries<Map<String, dynamic>, double>(
          dataSource: data,
          xValueMapper: (d, _) => (d['x'] as num).toDouble(),
          yValueMapper: (d, _) => (d['y'] as num).toDouble(),
          color: tokens.primaryColor,
          markerSettings: MarkerSettings(
            height: (data.isNotEmpty && data.first.containsKey('size'))
                ? (data.first['size'] as num).toDouble()
                : 12,
            width: (data.isNotEmpty && data.first.containsKey('size'))
                ? (data.first['size'] as num).toDouble()
                : 12,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 9),
            labelAlignment: ChartDataLabelAlignment.top,
          ),
          dataLabelMapper: (d, _) => d['label'] as String? ?? '',
        ),
      ],
    );
  }
}
