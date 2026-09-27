import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../../domain/models/chart_point.dart';
import '../../../../theme/chart_theme_tokens.dart';

/// 3. Step Line Chart con community_charts_flutter.
class CommunityStepLineChart extends StatelessWidget {
  final List<ChartPoint> data;
  final Color? color;

  const CommunityStepLineChart({
    super.key,
    required this.data,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final lineColor = color ?? tokens.secondaryColor;
    final labels = data.map((p) => p.x.toString()).toList();

    return charts.LineChart(
      [
        charts.Series<ChartPoint, num>(
          id: 'step',
          data: data,
          domainFn: (p, i) => (i ?? 0).toDouble(),
          measureFn: (p, _) => p.y,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(lineColor),
          radiusPxFn: (_, __) => 4,
        ),
      ],
      animate: true,
      defaultRenderer: charts.LineRendererConfig(
        includeArea: false,
        includeLine: true,
        includePoints: true,
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
