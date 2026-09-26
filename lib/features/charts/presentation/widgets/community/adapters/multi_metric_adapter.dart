import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../domain/models/chart_point.dart';

class MultiMetricAdapter {
  MultiMetricAdapter._();

  static List<charts.Series<MultiMetricPoint, String>> build({
    required List<MultiMetricPoint> data,
    required Map<String, Color> seriesColors,
  }) {
    final grouped = <String, List<MultiMetricPoint>>{};
    for (final p in data) {
      grouped.putIfAbsent(p.category, () => []).add(p);
    }

    return grouped.entries.map((entry) {
      final color = seriesColors[entry.key] ?? Colors.blue;
      return charts.Series<MultiMetricPoint, String>(
        id: entry.key,
        data: entry.value,
        domainFn: (p, _) => p.metric,
        measureFn: (p, _) => p.value,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
          color.withValues(alpha: 0.3),
        ),
        fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(
          color.withValues(alpha: 0.15),
        ),
      );
    }).toList();
  }
}
