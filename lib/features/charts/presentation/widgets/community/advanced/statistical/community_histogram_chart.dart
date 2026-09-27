import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 23. Histogram con community_charts_flutter.
/// Se implementa como un BarChart con barras contiguas.
class CommunityHistogramChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityHistogramChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return charts.BarChart(
      [
        charts.Series<Map<String, dynamic>, String>(
          id: 'histogram',
          data: data,
          domainFn: (row, _) => (row['bin'] ?? '').toString(),
          measureFn: (row, _) => (row['frequency'] ?? 0) as num,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.secondaryColor,
          ),
          labelAccessorFn: (row, _) => (row['frequency'] ?? 0).toString(),
        ),
      ],
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelPosition: charts.BarLabelPosition.inside,
        insideLabelStyleSpec: charts.TextStyleSpec(
          color: charts.ColorUtil.fromDartColor(Colors.white),
          fontSize: 10,
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
