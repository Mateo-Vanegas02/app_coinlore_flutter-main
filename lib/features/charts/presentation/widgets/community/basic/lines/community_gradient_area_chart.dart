import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../../domain/models/chart_point.dart';
import '../../../../theme/chart_theme_tokens.dart';

/// 4. Gradient Area Chart con community_charts_flutter.
/// Usa área semitransparente como aproximación al gradiente.
/// El gradiente real requeriría un renderer custom no soportado por la librería.
class CommunityGradientAreaChart extends StatelessWidget {
  final List<ChartPoint> data;

  const CommunityGradientAreaChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final color = tokens.primaryColor;
    final labels = data.map((p) => p.x.toString()).toList();

    return charts.LineChart(
      [
        charts.Series<ChartPoint, num>(
          id: 'gradient',
          data: data,
          domainFn: (p, i) => (i ?? 0).toDouble(),
          measureFn: (p, _) => p.y,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
          areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(
            color.withValues(alpha: 0.3),
          ),
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
