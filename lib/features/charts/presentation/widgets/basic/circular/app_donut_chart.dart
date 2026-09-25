import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide ChartPoint;
import '../../../../domain/models/chart_point.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 14. Gráfico de Dona (Donut Chart)
class AppDonutChart extends StatelessWidget {
  final List<ChartPoint> data;

  const AppDonutChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final palette = [
      tokens.primaryColor,
      tokens.bullishColor,
      tokens.accentColor,
      tokens.secondaryColor,
    ];

    return SfCircularChart(
      backgroundColor: Colors.transparent,
      series: <CircularSeries<ChartPoint, String>>[
        DoughnutSeries<ChartPoint, String>(
          dataSource: data,
          xValueMapper: (p, _) => p.x.toString(),
          yValueMapper: (p, _) => p.y.toDouble(),
          pointColorMapper: (p, i) => palette[i % palette.length],
          innerRadius: '50%',
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 9, fontWeight: FontWeight.bold),
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
