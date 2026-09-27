import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../../domain/models/chart_point.dart';
import '../../../../theme/chart_theme_tokens.dart';

/// 6. Baseline Area Chart con community_charts_flutter.
/// Puntos por encima del umbral se dibujan con `bullishColor`,
/// puntos por debajo con `bearishColor`. La media de ambos define la línea.
class CommunityBaselineAreaChart extends StatelessWidget {
  final List<ChartPoint> data;
  final double baseline;

  const CommunityBaselineAreaChart({
    super.key,
    required this.data,
    required this.baseline,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final labels = data.map((p) => p.x.toString()).toList();

    return charts.LineChart(
      [
        charts.Series<ChartPoint, num>(
          id: 'baseline',
          data: data,
          domainFn: (p, i) => (i ?? 0).toDouble(),
          measureFn: (p, _) => p.y,
          // El color se decide por punto según si supera el umbral.
          colorFn: (p, _) => charts.ColorUtil.fromDartColor(
            p.y >= baseline ? tokens.bullishColor : tokens.bearishColor,
          ),
          radiusPxFn: (_, __) => 5,
          areaColorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.primaryColor.withValues(alpha: 0.15),
          ),
        ),
      ],
      animate: true,
      defaultRenderer: charts.LineRendererConfig(
        includeArea: true,
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
