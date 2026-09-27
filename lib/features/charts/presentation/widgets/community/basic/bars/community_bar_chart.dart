import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../../domain/models/chart_point.dart';
import '../../../../theme/chart_theme_tokens.dart';

/// 7 & 8. Bar Chart (vertical u horizontal) con community_charts_flutter.
/// Réplica de `AppBarChart` (Syncfusion) y `GraphicBarChart`.
class CommunityBarChart extends StatelessWidget {
  final List<ChartPoint> data;
  final bool isHorizontal;
  final Color? barColor;

  const CommunityBarChart({
    super.key,
    required this.data,
    this.isHorizontal = false,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final color = barColor ?? tokens.accentColor;

    return charts.BarChart(
      [
        charts.Series<ChartPoint, String>(
          id: 'bars',
          data: data,
          domainFn: (p, _) => p.x.toString(),
          measureFn: (p, _) => p.y,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
        ),
      ],
      animate: true,
      vertical: !isHorizontal,
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
