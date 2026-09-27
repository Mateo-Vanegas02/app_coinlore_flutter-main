import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../../domain/models/chart_point.dart';
import '../../../../theme/chart_theme_tokens.dart';

/// 5. Multi-Line Chart con community_charts_flutter.
/// Cada `p.series` se convierte en una serie distinta.
class CommunityMultiLineChart extends StatelessWidget {
  final List<ChartPoint> data;

  const CommunityMultiLineChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    // Agrupamos por `series`.
    final grouped = <String, List<ChartPoint>>{};
    for (final p in data) {
      final key = p.series ?? 'default';
      grouped.putIfAbsent(key, () => []).add(p);
    }

    final palette = <String, Color>{
      'BTC': tokens.primaryColor,
      'ETH': tokens.secondaryColor,
      'SOL': tokens.accentColor,
    };

    // Etiquetas del primer grupo (todos tienen los mismos ejes X).
    final firstKey = grouped.keys.first;
    final labels = grouped[firstKey]!.map((p) => p.x.toString()).toList();

    final series = grouped.entries.map((entry) {
      final color = palette[entry.key] ?? tokens.primaryColor;
      return charts.Series<ChartPoint, num>(
        id: entry.key,
        data: entry.value,
        domainFn: (p, i) => (i ?? 0).toDouble(),
        measureFn: (p, _) => p.y,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
        radiusPxFn: (_, __) => 3,
      );
    }).toList();

    return charts.LineChart(
      series,
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
