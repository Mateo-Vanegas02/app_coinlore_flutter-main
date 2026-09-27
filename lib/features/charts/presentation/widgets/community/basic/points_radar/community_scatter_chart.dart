import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 18. Scatter Plot con community_charts_flutter.
/// Recibe `x` (num), `y` (num), `label` (opcional).
class CommunityScatterChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityScatterChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return charts.ScatterPlotChart(
      [
        charts.Series<Map<String, dynamic>, num>(
          id: 'scatter',
          data: data,
          domainFn: (row, _) => (row['x'] ?? 0) as num,
          measureFn: (row, _) => (row['y'] ?? 0) as num,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.primaryColor,
          ),
          radiusPxFn: (_, __) => 6,
        ),
      ],
      animate: true,
      domainAxis: charts.NumericAxisSpec(
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
    );
  }
}
