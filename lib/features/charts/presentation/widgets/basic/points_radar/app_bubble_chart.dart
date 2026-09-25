import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 19. Bubble Chart
class AppBubbleChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppBubbleChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBorderWidth: 0,
      primaryXAxis: NumericAxis(
        title: AxisTitle(
          text: 'Cap. Mercado (\$B)',
          textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        ),
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: 'Retorno 24h (%)',
          textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        ),
        labelStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        axisLine: AxisLine(color: tokens.axisLineColor),
        majorGridLines: MajorGridLines(color: tokens.gridLineColor),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      series: <CartesianSeries<Map<String, dynamic>, double>>[
        BubbleSeries<Map<String, dynamic>, double>(
          dataSource: data,
          xValueMapper: (d, _) => (d['x'] as num).toDouble(),
          yValueMapper: (d, _) => (d['y'] as num).toDouble(),
          sizeValueMapper: (d, _) => (d['size'] as num).toDouble(),
          color: tokens.primaryColor.withValues(alpha: 0.6),
          borderColor: tokens.primaryColor,
          borderWidth: 1.5,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(
              color: tokens.isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          dataLabelMapper: (d, _) => d['label'] as String? ?? '',
        ),
      ],
    );
  }
}
