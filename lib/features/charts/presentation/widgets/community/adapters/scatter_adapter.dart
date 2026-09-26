import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../domain/models/chart_point.dart';

class ScatterAdapter {
  ScatterAdapter._();

  /// Scatter simple (x/y numéricos).
  static List<charts.Series<ChartPoint, num>> build({
    required List<ChartPoint> data,
    required Color color,
  }) {
    return [
      charts.Series<ChartPoint, num>(
        id: 'scatter',
        data: data,
        domainFn: (p, _) => p.x is num ? p.x as num : 0,
        measureFn: (p, _) => p.y,
        radiusPxFn: (_, __) => 6,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
      ),
    ];
  }

  /// Burbujas: `size` viene en `p.extra['size']`.
  static List<charts.Series<ChartPoint, num>> bubble({
    required List<ChartPoint> data,
    required Color color,
  }) {
    return [
      charts.Series<ChartPoint, num>(
        id: 'bubble',
        data: data,
        domainFn: (p, _) => p.x is num ? p.x as num : 0,
        measureFn: (p, _) => p.y,
        radiusPxFn: (p, _) {
          final raw = p.extra?['size'];
          final size = raw is num ? raw.toDouble() : 8.0;
          return size.clamp(4, 40).toDouble();
        },
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
          color.withValues(alpha: 0.7),
        ),
      ),
    ];
  }

  static charts.NumericAxisSpec numericAxis({
    required Color labelColor,
    required Color gridColor,
  }) {
    return charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(
          fontSize: 11,
          color: charts.ColorUtil.fromDartColor(labelColor),
        ),
        lineStyle: charts.LineStyleSpec(
          color: charts.ColorUtil.fromDartColor(gridColor),
        ),
      ),
    );
  }
}
