import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../domain/models/chart_point.dart';

/// Convierte `List<ChartPoint>` en series de line/area para community_charts.
class LineAdapter {
  LineAdapter._();

  /// Una sola serie.
  static List<charts.Series<ChartPoint, String>> single({
    required List<ChartPoint> data,
    required Color color,
    String id = 'serie',
    bool includeArea = false,
  }) {
    return [
      charts.Series<ChartPoint, String>(
        id: id,
        data: data,
        domainFn: (p, _) => p.x.toString(),
        measureFn: (p, _) => p.y,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
        areaColorFn: includeArea
            ? (_, __) => charts.ColorUtil.fromDartColor(
                  color.withValues(alpha: 0.25),
                )
            : null,
      ),
    ];
  }

  /// Múltiples series agrupadas por `p.series`.
  static List<charts.Series<ChartPoint, String>> multi({
    required List<ChartPoint> data,
    required Map<String, Color> seriesColors,
    bool includeArea = false,
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
        areaColorFn: includeArea
            ? (_, __) => charts.ColorUtil.fromDartColor(
                  color.withValues(alpha: 0.25),
                )
            : null,
      );
    }).toList();
  }

  /// Eje Y numérico reutilizable.
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
          thickness: 1,
        ),
      ),
      tickProviderSpec: const charts.BasicNumericTickProviderSpec(
        desiredTickCount: 5,
      ),
    );
  }

  /// Eje X ordinal (categorías).
  static charts.OrdinalAxisSpec xAxisSpec({
    required Color labelColor,
  }) {
    return charts.OrdinalAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(
          fontSize: 10,
          color: charts.ColorUtil.fromDartColor(labelColor),
        ),
        lineStyle: charts.LineStyleSpec(
          color: charts.ColorUtil.fromDartColor(
            labelColor.withValues(alpha: 0.2),
          ),
          thickness: 1,
        ),
      ),
    );
  }

  /// Versión numérica: dominio = índice (0, 1, 2...) y etiqueta original en `label`.
  /// LineChart de community_charts_flutter exige dominio numérico.
  static List<charts.Series<ChartPoint, num>> singleNumeric({
    required List<ChartPoint> data,
    required Color color,
    String id = 'serie',
    bool includeArea = false,
  }) {
    return [
      charts.Series<ChartPoint, num>(
        id: id,
        data: data,
        domainFn: (p, i) => i!.toDouble(),
        measureFn: (p, _) => p.y,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
        areaColorFn: includeArea
            ? (_, __) => charts.ColorUtil.fromDartColor(
                  color.withValues(alpha: 0.25),
                )
            : null,
      ),
    ];
  }

  /// Versión numérica multi-serie.
  static List<charts.Series<ChartPoint, num>> multiNumeric({
    required List<ChartPoint> data,
    required Map<String, Color> seriesColors,
    bool includeArea = false,
  }) {
    final grouped = <String, List<ChartPoint>>{};
    for (final p in data) {
      final key = p.series ?? 'default';
      grouped.putIfAbsent(key, () => []).add(p);
    }

    return grouped.entries.map((entry) {
      final color = seriesColors[entry.key] ?? Colors.blue;
      return charts.Series<ChartPoint, num>(
        id: entry.key,
        data: entry.value,
        domainFn: (p, i) => i!.toDouble(),
        measureFn: (p, _) => p.y,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
        areaColorFn: includeArea
            ? (_, __) => charts.ColorUtil.fromDartColor(
                  color.withValues(alpha: 0.25),
                )
            : null,
      );
    }).toList();
  }

  /// Eje X numérico con etiquetas custom (índice → string).
  /// Se usa en las series numéricas para mostrar los labels originales.
  static charts.NumericAxisSpec xAxisNumeric({
    required Color labelColor,
    required List<String> labels,
  }) {
    return charts.NumericAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(
          fontSize: 10,
          color: charts.ColorUtil.fromDartColor(labelColor),
        ),
        lineStyle: charts.LineStyleSpec(
          color: charts.ColorUtil.fromDartColor(
            labelColor.withValues(alpha: 0.2),
          ),
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
    );
  }
}
