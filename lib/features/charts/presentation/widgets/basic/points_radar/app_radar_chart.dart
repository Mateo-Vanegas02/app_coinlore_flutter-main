import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 20. Radar / Spider Chart
class AppRadarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppRadarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 100,
        interval: 25,
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: <CartesianSeries<Map<String, dynamic>, String>>[
        SplineAreaSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (d, _) => d['metric'] as String,
          yValueMapper: (d, _) => (d['value'] as num).toDouble(),
          color: tokens.primaryColor.withValues(alpha: 0.25),
          borderColor: tokens.primaryColor,
          borderWidth: 2.5,
          markerSettings: MarkerSettings(
            isVisible: true,
            color: tokens.primaryColor,
            shape: DataMarkerType.circle,
            height: 7,
            width: 7,
          ),
        ),
      ],
    );
  }
}
