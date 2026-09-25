import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;
import '../../../../domain/models/chart_point.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 7 & 8. Gráfico de Barras (Vertical u Horizontal)
class AppBarChart extends StatelessWidget {
  final List<ChartPoint> data;
  final bool isHorizontal;
  final Color? barColor;

  const AppBarChart({
    super.key,
    required this.data,
    this.isHorizontal = false,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final color = barColor ?? tokens.accentColor;

    if (isHorizontal) {
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
          labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
          axisLine: AxisLine(color: tokens.axisLineColor),
          majorTickLines: const MajorTickLines(size: 0),
          majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        ),
        series: <CartesianSeries<ChartPoint, String>>[
          BarSeries<ChartPoint, String>(
            dataSource: data,
            xValueMapper: (p, _) => p.x.toString(),
            yValueMapper: (p, _) => p.y.toDouble(),
            color: color,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(4)),
          ),
        ],
      );
    }

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
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
      ),
      series: <CartesianSeries<ChartPoint, String>>[
        ColumnSeries<ChartPoint, String>(
          dataSource: data,
          xValueMapper: (p, _) => p.x.toString(),
          yValueMapper: (p, _) => p.y.toDouble(),
          color: color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}
