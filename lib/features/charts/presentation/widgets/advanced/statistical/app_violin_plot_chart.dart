import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 24. Violin Plot (Densidad Simétrica)
class AppViolinPlotChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppViolinPlotChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    // Creamos dos series simétricas para simular el violin
    final positiveData = data.map((d) => _ViolinPoint(
          d['level'] as String,
          (d['density'] as num).toDouble(),
        )).toList();
    final negativeData = data.map((d) => _ViolinPoint(
          d['level'] as String,
          -(d['density'] as num).toDouble(),
        )).toList();

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
          text: 'Densidad',
          textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        ),
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: <CartesianSeries<_ViolinPoint, String>>[
        SplineAreaSeries<_ViolinPoint, String>(
          dataSource: positiveData,
          xValueMapper: (p, _) => p.level,
          yValueMapper: (p, _) => p.density,
          color: tokens.primaryColor.withValues(alpha: 0.3),
          borderColor: tokens.primaryColor,
          borderWidth: 2,
        ),
        SplineAreaSeries<_ViolinPoint, String>(
          dataSource: negativeData,
          xValueMapper: (p, _) => p.level,
          yValueMapper: (p, _) => p.density,
          color: tokens.primaryColor.withValues(alpha: 0.3),
          borderColor: tokens.primaryColor,
          borderWidth: 2,
        ),
      ],
    );
  }
}

class _ViolinPoint {
  final String level;
  final double density;
  const _ViolinPoint(this.level, this.density);
}
