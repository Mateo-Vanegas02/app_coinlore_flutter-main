import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;
import '../../../../domain/models/chart_point.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 6. Gráfico de Área con Umbral (Baseline Area)
class AppBaselineAreaChart extends StatelessWidget {
  final List<ChartPoint> data;
  final double baseline;

  const AppBaselineAreaChart({
    super.key,
    required this.data,
    required this.baseline,
  });

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
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      annotations: <CartesianChartAnnotation>[
        CartesianChartAnnotation(
          widget: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: tokens.axisLabelColor.withValues(alpha: 0.5),
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          coordinateUnit: CoordinateUnit.point,
          x: data.isNotEmpty ? data[data.length ~/ 2].x.toString() : '0',
          y: baseline,
          verticalAlignment: ChartAlignment.center,
          horizontalAlignment: ChartAlignment.center,
        ),
      ],
      series: <CartesianSeries<ChartPoint, String>>[
        // Área por encima del umbral (bullish)
        SplineAreaSeries<ChartPoint, String>(
          dataSource: data.map((p) => ChartPoint(
            x: p.x,
            y: p.y >= baseline ? p.y : baseline,
          )).toList(),
          xValueMapper: (p, _) => p.x.toString(),
          yValueMapper: (p, _) => p.y.toDouble(),
          borderColor: tokens.bullishColor,
          borderWidth: 2,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              tokens.bullishColor.withValues(alpha: 0.35),
              tokens.bullishColor.withValues(alpha: 0.0),
            ],
          ),
        ),
        // Área por debajo del umbral (bearish)
        SplineAreaSeries<ChartPoint, String>(
          dataSource: data.map((p) => ChartPoint(
            x: p.x,
            y: p.y < baseline ? p.y : baseline,
          )).toList(),
          xValueMapper: (p, _) => p.x.toString(),
          yValueMapper: (p, _) => p.y.toDouble(),
          borderColor: tokens.bearishColor,
          borderWidth: 2,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              tokens.bearishColor.withValues(alpha: 0.0),
              tokens.bearishColor.withValues(alpha: 0.35),
            ],
          ),
        ),
      ],
    );
  }
}
