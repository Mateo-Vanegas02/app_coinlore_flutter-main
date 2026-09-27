import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 19. Bubble Chart con community_charts_flutter.
/// Recibe `x` (num), `y` (num) y `size` (num) para el radio.
class CommunityBubbleChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityBubbleChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return charts.ScatterPlotChart(
      [
        charts.Series<Map<String, dynamic>, num>(
          id: 'bubble',
          data: data,
          domainFn: (row, _) => (row['x'] ?? 0) as num,
          measureFn: (row, _) => (row['y'] ?? 0) as num,
          radiusPxFn: (row, _) {
            final raw = row['size'];
            final size = raw is num ? raw.toDouble() : 10.0;
            return size.clamp(4, 40).toDouble();
          },
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.accentColor.withValues(alpha: 0.7),
          ),
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
