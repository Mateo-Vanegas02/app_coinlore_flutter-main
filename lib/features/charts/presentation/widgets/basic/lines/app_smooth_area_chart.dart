import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;
import '../../../../domain/models/chart_point.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 2. Gráfico de Área Suave (Smooth Area)
class AppSmoothAreaChart extends StatelessWidget {
  final List<ChartPoint> data;
  final bool isBullish;

  const AppSmoothAreaChart({
    super.key,
    required this.data,
    this.isBullish = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final lineColor = isBullish ? tokens.bullishColor : tokens.bearishColor;
    final fillColor = lineColor.withValues(alpha: 0.2);

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
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      series: <CartesianSeries<ChartPoint, String>>[
        SplineAreaSeries<ChartPoint, String>(
          dataSource: data,
          xValueMapper: (p, _) => p.x.toString(),
          yValueMapper: (p, _) => p.y.toDouble(),
          color: fillColor,
          borderColor: lineColor,
          borderWidth: 2.5,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor.withValues(alpha: 0.3),
              lineColor.withValues(alpha: 0.0),
            ],
          ),
        ),
      ],
    );
  }
}
