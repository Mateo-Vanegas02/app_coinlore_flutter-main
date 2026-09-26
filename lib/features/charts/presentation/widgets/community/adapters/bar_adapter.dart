import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../domain/models/chart_point.dart';

class BarAdapter {
  BarAdapter._();

  /// Barras simples (verticales u horizontales).
  static List<charts.Series<ChartPoint, String>> simple({
    required List<ChartPoint> data,
    required Color color,
    String id = 'barras',
  }) {
    return [
      charts.Series<ChartPoint, String>(
        id: id,
        data: data,
        domainFn: (p, _) => p.x.toString(),
        measureFn: (p, _) => p.y,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
        labelAccessorFn: (p, _) => p.y.toStringAsFixed(1),
      ),
    ];
  }

  /// Barras agrupadas (una serie por cada valor de `p.series`).
  static List<charts.Series<ChartPoint, String>> grouped({
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
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
      );
    }).toList();
  }

  /// Barras apiladas: misma forma que grouped, el `BarGroupingType` lo decide.
  static List<charts.Series<ChartPoint, String>> stacked({
    required List<ChartPoint> data,
    required Map<String, Color> seriesColors,
  }) {
    return grouped(data: data, seriesColors: seriesColors);
  }

  static charts.OrdinalAxisSpec xAxisSpec({required Color labelColor}) {
    return charts.OrdinalAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(
          fontSize: 11,
          color: charts.ColorUtil.fromDartColor(labelColor),
        ),
        lineStyle: charts.LineStyleSpec(
          color: charts.ColorUtil.fromDartColor(
            labelColor.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }

  static charts.NumericAxisSpec yAxisSpec({
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
