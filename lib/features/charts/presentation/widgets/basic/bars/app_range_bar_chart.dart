import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 12. Gráfico de Barras de Rango (Range/Floating Bar)
class AppRangeBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppRangeBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}%',
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      series: <CartesianSeries<Map<String, dynamic>, String>>[
        RangeColumnSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (d, _) => (d['crypto'] ?? d['asset'] ?? d['x'] ?? '') as String,
          lowValueMapper: (d, _) => ((d['min'] ?? d['low'] ?? 0) as num).toDouble(),
          highValueMapper: (d, _) => ((d['max'] ?? d['high'] ?? 0) as num).toDouble(),
          color: tokens.primaryColor.withValues(alpha: 0.7),
          borderColor: tokens.primaryColor,
          borderWidth: 1.5,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
      ],
    );
  }
}
