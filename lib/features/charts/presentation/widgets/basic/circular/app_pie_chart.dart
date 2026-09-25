import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;
import '../../../../domain/models/chart_point.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 13. Gráfico de Torta (Pie Chart)
class AppPieChart extends StatelessWidget {
  final List<ChartPoint> data;

  const AppPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final palette = [
      tokens.primaryColor,
      tokens.bullishColor,
      tokens.accentColor,
      tokens.secondaryColor,
      tokens.bearishColor,
    ];

    return SfCircularChart(
      backgroundColor: Colors.transparent,
      series: <CircularSeries<ChartPoint, String>>[
        PieSeries<ChartPoint, String>(
          dataSource: data,
          xValueMapper: (p, _) => p.x.toString(),
          yValueMapper: (p, _) => p.y.toDouble(),
          pointColorMapper: (p, i) => palette[i % palette.length],
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      legend: Legend(
        isVisible: true,
        textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
