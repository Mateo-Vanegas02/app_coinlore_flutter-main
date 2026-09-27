import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 9. Stacked Bar Chart con community_charts_flutter.
/// Recibe datos con `category`, `group` y `value`.
class CommunityStackedBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityStackedBarChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    // Agrupamos por `group` (cada grupo es una serie).
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final row in data) {
      final group = (row['group'] ?? row['type'] ?? 'default').toString();
      grouped.putIfAbsent(group, () => []).add(row);
    }

    final palette = [
      tokens.primaryColor,
      tokens.secondaryColor,
      tokens.accentColor,
      tokens.bullishColor,
      tokens.bearishColor,
    ];

    int colorIndex = 0;
    final series = grouped.entries.map((entry) {
      final color = palette[colorIndex % palette.length];
      colorIndex++;
      return charts.Series<Map<String, dynamic>, String>(
        id: entry.key,
        data: entry.value,
        domainFn: (row, _) => (row['category'] ?? '').toString(),
        measureFn: (row, _) => (row['value'] ?? row['percent'] ?? 0) as num,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
      );
    }).toList();

    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
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
