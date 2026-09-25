import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 22. BoxPlot (Caja y Bigotes)
class AppBoxPlotChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppBoxPlotChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 11),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: 'Variación %',
          textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        ),
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: <CartesianSeries<Map<String, dynamic>, String>>[
        BoxAndWhiskerSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (d, _) => d['asset'] as String,
          yValueMapper: (d, _) => <num>[
            d['min'] as num,
            d['q1'] as num,
            d['median'] as num,
            d['q3'] as num,
            d['max'] as num,
          ],
          color: tokens.primaryColor.withValues(alpha: 0.3),
          borderColor: tokens.primaryColor,
          borderWidth: 2,
          boxPlotMode: BoxPlotMode.exclusive,
        ),
      ],
    );
  }
}
