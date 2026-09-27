import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 30. Band Area / Bollinger con community_charts_flutter.
/// Se implementa como un LineChart con 2 series de área:
/// banda superior (upper) y banda inferior (lower), más una línea media.
class CommunityBandAreaChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityBandAreaChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    final labels = data.map((row) => (row['time'] ?? '').toString()).toList();

    return charts.LineChart(
      [
        // Banda superior
        charts.Series<Map<String, dynamic>, num>(
          id: 'upper',
          data: data,
          domainFn: (row, i) => (i ?? 0).toDouble(),
          measureFn: (row, _) => (row['upper'] ?? 0) as num,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.primaryColor.withValues(alpha: 0.15),
          ),
          areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.primaryColor.withValues(alpha: 0.15),
          ),
        ),
        // Banda inferior
        charts.Series<Map<String, dynamic>, num>(
          id: 'lower',
          data: data,
          domainFn: (row, i) => (i ?? 0).toDouble(),
          measureFn: (row, _) => (row['lower'] ?? 0) as num,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.secondaryColor.withValues(alpha: 0.15),
          ),
          areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.secondaryColor.withValues(alpha: 0.15),
          ),
        ),
        // Línea media
        charts.Series<Map<String, dynamic>, num>(
          id: 'price',
          data: data,
          domainFn: (row, i) => (i ?? 0).toDouble(),
          measureFn: (row, _) => (row['price'] ?? 0) as num,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.bullishColor,
          ),
          radiusPxFn: (_, __) => 3,
        ),
      ],
      animate: true,
      defaultRenderer: charts.LineRendererConfig(
        includeArea: true,
        includeLine: true,
        includePoints: false,
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 11,
            color: charts.ColorUtil.fromDartColor(tokens.axisLabelColor),
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.ColorUtil.fromDartColor(tokens.gridLineColor),
          ),
        ),
      ),
      domainAxis: charts.NumericAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 10,
            color: charts.ColorUtil.fromDartColor(tokens.axisLabelColor),
          ),
        ),
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          List.generate(
            labels.length,
            (i) => charts.TickSpec<double>(
              i.toDouble(),
              label: labels[i],
            ),
          ),
        ),
      ),
    );
  }
}
