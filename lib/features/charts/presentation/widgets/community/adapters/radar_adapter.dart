import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../domain/models/chart_point.dart';

class RadarAdapter {
  RadarAdapter._();

  /// Radar simple.
  static List<charts.Series<ChartPoint, String>> single({
    required List<ChartPoint> data,
    required Color color,
  }) {
    return [
      charts.Series<ChartPoint, String>(
        id: 'radar',
        data: data,
        domainFn: (p, _) => p.x.toString(),
        measureFn: (p, _) => p.y,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
          color.withValues(alpha: 0.3),
        ),
        fillColorFn: (_, __) => charts.ColorUtil.fromDartColor(
          color.withValues(alpha: 0.15),
        ),
      ),
    ];
  }

  /// Radar multi-serie.
  static List<charts.Series<ChartPoint, String>> multi({
    required List<ChartPoint> data,
    required Map<String, Color> seriesColors,
  }) {
    final grouped = <String, List<ChartPoint>>{};
    for (final p in data) {
      final key = p.series ?? 'default';
      grouped.putIfAbsent(key, () => []).add(p);
    }

    return grouped.entries.map((entry) {
      final color = seriesColors[entry.key] ?? Colors.blue;
      return charts.Series<ChartPoint, String>(
        id: entry.key,
        data: entry.value,
        domainFn: (p, _) => p.x.toString(),
        measureFn: (p, _) => p.y,
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
