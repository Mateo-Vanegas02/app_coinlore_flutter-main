import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 31. Candlestick / OHLC Chart (Velas Japonesas Financieras)
class AppCandlestickChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppCandlestickChart({super.key, required this.data});

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
        CandleSeries<Map<String, dynamic>, String>(
          name: 'Trading OHLC',
          dataSource: data,
          xValueMapper: (d, _) => d['date'] as String,
          lowValueMapper: (d, _) => (d['low'] as num).toDouble(),
          highValueMapper: (d, _) => (d['high'] as num).toDouble(),
          openValueMapper: (d, _) => (d['open'] as num).toDouble(),
          closeValueMapper: (d, _) => (d['close'] as num).toDouble(),
          bullColor: tokens.bullishColor,
          bearColor: tokens.bearishColor,
          enableSolidCandles: true,
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor),
      ),
    );
  }
}
