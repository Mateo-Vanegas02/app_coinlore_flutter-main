import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;
import '../../../../domain/models/chart_point.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 1. Gráfico de Línea Estándar
class AppStandardLineChart extends StatelessWidget {
  final List<ChartPoint> data;
  final Color? color;

  const AppStandardLineChart({super.key, required this.data, this.color});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final lineColor = color ?? tokens.primaryColor;

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 11),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 11),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      series: <CartesianSeries<ChartPoint, String>>[
        SplineSeries<ChartPoint, String>(
          dataSource: data,
          xValueMapper: (p, _) => p.x.toString(),
          yValueMapper: (p, _) => p.y.toDouble(),
          color: lineColor,
          width: 2.5,
          markerSettings: MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
            color: lineColor,
            borderColor: lineColor,
            height: 6,
            width: 6,
          ),
        ),
      ],
    );
  }
}
