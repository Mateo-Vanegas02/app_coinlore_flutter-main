import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 30. Range Area / Band Chart (Bandas Bollinger / Límites de Volatilidad)
class AppBandAreaChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppBandAreaChart({super.key, required this.data});

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
      series: <CartesianSeries<Map<String, dynamic>, String>>[
        // Banda de Bollinger (Rango Upper / Lower)
        RangeAreaSeries<Map<String, dynamic>, String>(
          name: 'Banda Volatilidad',
          dataSource: data,
          xValueMapper: (d, _) => d['time'] as String,
          highValueMapper: (d, _) => (d['upper'] as num).toDouble(),
          lowValueMapper: (d, _) => (d['lower'] as num).toDouble(),
          color: tokens.primaryColor.withValues(alpha: 0.18),
          borderColor: tokens.primaryColor.withValues(alpha: 0.5),
          borderWidth: 1.5,
          borderDrawMode: RangeAreaBorderMode.all,
        ),
        // Línea central de precio
        SplineSeries<Map<String, dynamic>, String>(
          name: 'Precio Central',
          dataSource: data,
          xValueMapper: (d, _) => d['time'] as String,
          yValueMapper: (d, _) => (d['price'] as num).toDouble(),
          color: tokens.accentColor,
          width: 2.5,
          markerSettings: MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
            width: 5,
            height: 5,
            color: tokens.accentColor,
          ),
        ),
      ],
      legend: Legend(
        isVisible: true,
        position: LegendPosition.top,
        textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        backgroundColor: Colors.transparent,
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor),
      ),
    );
  }
}
