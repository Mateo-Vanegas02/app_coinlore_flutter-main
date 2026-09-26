import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../../charts/domain/models/chart_point.dart';
import '../../theme/chart_theme_tokens.dart';
import 'adapters/bar_adapter.dart';
import 'adapters/line_adapter.dart';
import 'adapters/pie_adapter.dart';
import 'adapters/scatter_adapter.dart';

enum CommunityChartType {
  // Básicos
  lineSimple,
  lineMulti,
  lineArea,
  lineStepped,
  barVertical,
  barHorizontal,
  barGrouped,
  barStacked,
  barNegative,
  pieSimple,
  pieDonut,
  pieHalf,
  scatter,
  bubble,
  lineThresholds,
  barWithLabels,
  pieWithPercentages,
  gradientArea,
  // Avanzados (Bloque 3)
  combinedChart,
  dualAxis,
  streamingLine,
  largeDataset,
  markerView,
  pyramid,
  radarMulti,
  candlestickWithVolume,
  interactiveDetail,
  animatedTransitions,
  syncedCharts,
}

class CommunityChartRenderer {
  CommunityChartRenderer._();

  static Widget build({
    required CommunityChartType type,
    required List<ChartPoint> data,
    required ChartThemeTokens tokens,
    bool animate = true,
  }) {
    switch (type) {
      // -------- LÍNEAS --------
      case CommunityChartType.lineSimple:
        return _line(data, tokens, animate: animate);

      case CommunityChartType.lineMulti:
        return _lineMulti(data, tokens, animate: animate);

      case CommunityChartType.lineArea:
        return _lineArea(data, tokens, animate: animate);

      case CommunityChartType.lineStepped:
        return _lineStepped(data, tokens, animate: animate);

      // -------- BARRAS --------
      case CommunityChartType.barVertical:
        return _bar(data, tokens, animate: animate);

      case CommunityChartType.barHorizontal:
        return _bar(data, tokens, animate: animate, vertical: false);

      case CommunityChartType.barGrouped:
        return _barGrouped(data, tokens, animate: animate);

      case CommunityChartType.barStacked:
        return _barStacked(data, tokens, animate: animate);

      case CommunityChartType.barNegative:
        return _bar(data, tokens, animate: animate);

      case CommunityChartType.barWithLabels:
        return _barWithLabels(data, tokens, animate: animate);

      // -------- CIRCULARES --------
      case CommunityChartType.pieSimple:
        return _pie(data, tokens, animate: animate);

      case CommunityChartType.pieDonut:
        return _pie(data, tokens, animate: animate, donut: true);

      case CommunityChartType.pieHalf:
        return _pie(data, tokens, animate: animate, half: true);

      case CommunityChartType.pieWithPercentages:
        return _pie(data, tokens, animate: animate);

      // -------- PUNTOS --------
      case CommunityChartType.scatter:
        return _scatter(data, tokens, animate: animate);

      case CommunityChartType.bubble:
        return _bubble(data, tokens, animate: animate);

      // -------- Avanzados que caen en básicos --------
      case CommunityChartType.largeDataset:
        return _line(data, tokens, animate: false);

      case CommunityChartType.markerView:
        return _line(data, tokens, animate: animate);

      case CommunityChartType.animatedTransitions:
        return _line(data, tokens, animate: true);

      case CommunityChartType.combinedChart:
        return _combined(data, tokens, animate: animate);

      case CommunityChartType.dualAxis:
        return _dualAxis(data, tokens, animate: animate);

      case CommunityChartType.pyramid:
        return _pyramid(data, tokens, animate: animate);

      case CommunityChartType.radarMulti:
        return _radarMulti(data, tokens, animate: animate);

      case CommunityChartType.interactiveDetail:
        // Este tipo no se renderiza directamente: lo maneja el StatefulWidget
        // CommunityInteractiveDetail. Devolvemos un placeholder por seguridad.
        return const Center(child: Text('Usar CommunityInteractiveDetail'));

      case CommunityChartType.streamingLine:
        // Este tipo lo maneja el StatefulWidget CommunityStreamingLine,
        // no se renderiza directamente desde aquí.
        return const Center(child: Text('Usar CommunityStreamingLine'));

      case CommunityChartType.syncedCharts:
        // Este tipo lo maneja el StatefulWidget CommunitySyncedCharts.
        return const Center(child: Text('Usar CommunitySyncedCharts'));

      case CommunityChartType.gradientArea:
        return _gradientAreaFallback(data, tokens, animate: animate);

      case CommunityChartType.candlestickWithVolume:
        return _candlestickWithVolume(data, tokens, animate: animate);
      // -------- Pendientes (Bloque 3) --------
      default:
        return const Center(child: Text('Pendiente (Bloque 3)'));
    }
  }

  // ---------------------------------------------------------------------
  // LÍNEAS
  // ---------------------------------------------------------------------

  static Widget _line(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    return charts.LineChart(
      LineAdapter.singleNumeric(data: data, color: tokens.primaryColor),
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(
        includeArea: false,
        includePoints: true,
        includeLine: true,
      ),
      primaryMeasureAxis: LineAdapter.yAxisSpec(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
      domainAxis: LineAdapter.xAxisNumeric(
        labelColor: tokens.axisLabelColor,
        labels: data.map((p) => p.x.toString()).toList(),
      ),
    );
  }

  static Widget _lineMulti(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    // En multi-serie las etiquetas del eje X son las del primer grupo.
    final firstSeries = data.isNotEmpty ? (data.first.series ?? '') : '';
    final labels = data
        .where((p) => (p.series ?? '') == firstSeries)
        .map((p) => p.x.toString())
        .toList();

    return charts.LineChart(
      LineAdapter.multiNumeric(
        data: data,
        seriesColors: {
          'BTC': tokens.primaryColor,
          'ETH': tokens.secondaryColor,
          'SOL': tokens.accentColor,
        },
      ),
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
      primaryMeasureAxis: LineAdapter.yAxisSpec(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
      domainAxis: LineAdapter.xAxisNumeric(
        labelColor: tokens.axisLabelColor,
        labels: labels,
      ),
    );
  }

  static Widget _lineArea(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    return charts.LineChart(
      LineAdapter.singleNumeric(
        data: data,
        color: tokens.bullishColor,
        includeArea: true,
      ),
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(
        includeArea: true,
        includeLine: true,
        includePoints: false,
      ),
      domainAxis: LineAdapter.xAxisNumeric(
        labelColor: tokens.axisLabelColor,
        labels: data.map((p) => p.x.toString()).toList(),
      ),
    );
  }

  static Widget _lineStepped(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    return charts.LineChart(
      LineAdapter.singleNumeric(data: data, color: tokens.secondaryColor),
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
      domainAxis: LineAdapter.xAxisNumeric(
        labelColor: tokens.axisLabelColor,
        labels: data.map((p) => p.x.toString()).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // BARRAS
  // ---------------------------------------------------------------------

  static Widget _bar(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
    bool vertical = true,
  }) {
    return charts.BarChart(
      BarAdapter.simple(data: data, color: tokens.accentColor),
      animate: animate,
      vertical: vertical,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      primaryMeasureAxis: BarAdapter.yAxisSpec(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
    );
  }

  static Widget _barGrouped(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    return charts.BarChart(
      BarAdapter.grouped(
        data: data,
        seriesColors: {
          'Spot': tokens.primaryColor,
          'Derivados': tokens.secondaryColor,
          'DeFi': tokens.bullishColor,
          'CeFi': tokens.accentColor,
        },
      ),
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      primaryMeasureAxis: BarAdapter.yAxisSpec(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
    );
  }

  static Widget _barStacked(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    return charts.BarChart(
      BarAdapter.stacked(
        data: data,
        seriesColors: {
          'DeFi': tokens.bullishColor,
          'CeFi': tokens.primaryColor,
        },
      ),
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,
      primaryMeasureAxis: BarAdapter.yAxisSpec(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
    );
  }

  static Widget _barWithLabels(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    return charts.BarChart(
      BarAdapter.simple(data: data, color: tokens.primaryColor),
      animate: animate,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelPosition: charts.BarLabelPosition.inside,
        insideLabelStyleSpec: charts.TextStyleSpec(
          color: charts.ColorUtil.fromDartColor(Colors.white),
          fontSize: 10,
        ),
      ),
      primaryMeasureAxis: BarAdapter.yAxisSpec(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // CIRCULARES
  // ---------------------------------------------------------------------

  static Widget _pie(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
    bool donut = false,
    bool half = false,
  }) {
    // Workaround: community_charts_flutter 1.0.4 tiene un bug de tipos
    // con ArcRendererElement en Flutter Web. En Web mostramos un aviso.
    if (kIsWeb) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 32,
                color: tokens.axisLabelColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Gráfico circular no disponible en Web\n(bug de community_charts_flutter)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: tokens.axisLabelColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return charts.PieChart(
      PieAdapter.build(
        data: data,
        palette: [
          tokens.primaryColor,
          tokens.secondaryColor,
          tokens.accentColor,
          tokens.bullishColor,
          tokens.bearishColor,
        ],
      ),
      animate: animate,
      defaultRenderer: PieAdapter.arcConfig(
        isDonut: donut,
        isHalf: half,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // PUNTOS
  // ---------------------------------------------------------------------

  static Widget _scatter(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    return charts.ScatterPlotChart(
      ScatterAdapter.build(data: data, color: tokens.primaryColor),
      animate: animate,
      domainAxis: ScatterAdapter.numericAxis(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
      primaryMeasureAxis: ScatterAdapter.numericAxis(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
    );
  }

  static Widget _bubble(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    return charts.ScatterPlotChart(
      ScatterAdapter.bubble(data: data, color: tokens.accentColor),
      animate: animate,
      domainAxis: ScatterAdapter.numericAxis(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
      primaryMeasureAxis: ScatterAdapter.numericAxis(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
    );
  }

  // ---------------------------------------------------------------------
  // AVANZADOS — Bloque 3.1a
  // ---------------------------------------------------------------------

  /// CombinedChart: barras + línea en un mismo lienzo.
  static Widget _combined(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    final bars = <ChartPoint>[];
    final lines = <ChartPoint>[];
    for (final p in data) {
      if (p.series == 'line') {
        lines.add(p);
      } else {
        bars.add(p);
      }
    }

    return charts.OrdinalComboChart(
      [
        // Barras — usan el renderer por defecto
        charts.Series<ChartPoint, String>(
          id: 'barras',
          data: bars,
          domainFn: (p, _) => p.x.toString(),
          measureFn: (p, _) => p.y,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.primaryColor.withValues(alpha: 0.75),
          ),
        ),
        // Línea — marcada para usar el renderer custom
        charts.Series<ChartPoint, String>(
          id: 'línea',
          data: lines,
          domainFn: (p, _) => p.x.toString(),
          measureFn: (p, _) => p.y,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.bearishColor,
          ),
        )..setAttribute(charts.rendererIdKey, 'customLine'),
      ],
      animate: animate,
      // Renderer por defecto: barras
      defaultRenderer: charts.BarRendererConfig<String>(),
      // Renderer custom para la serie marcada: línea
      customSeriesRenderers: [
        charts.LineRendererConfig(
          customRendererId: 'customLine',
          includePoints: true,
        ),
      ],
    );
  }

  /// Doble eje Y: una serie en el eje izquierdo, otra en el derecho.
  static Widget _dualAxis(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    final left = <ChartPoint>[];
    final right = <ChartPoint>[];
    for (final p in data) {
      if (p.series == 'right') {
        right.add(p);
      } else {
        left.add(p);
      }
    }

    return charts.OrdinalComboChart(
      [
        charts.Series<ChartPoint, String>(
          id: 'Eje izquierdo',
          data: left,
          domainFn: (p, _) => p.x.toString(),
          measureFn: (p, _) => p.y,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.primaryColor,
          ),
        ),
        charts.Series<ChartPoint, String>(
          id: 'Eje derecho',
          data: right,
          domainFn: (p, _) => p.x.toString(),
          measureFn: (p, _) => p.y,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.bullishColor,
          ),
        ),
      ],
      animate: animate,
      defaultRenderer: charts.BarRendererConfig<String>(),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 11,
            color: charts.ColorUtil.fromDartColor(tokens.primaryColor),
          ),
        ),
      ),
      secondaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 11,
            color: charts.ColorUtil.fromDartColor(tokens.bullishColor),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // AVANZADOS — Bloque 3.1b
  // ---------------------------------------------------------------------

  /// Pirámide: barras horizontales apiladas con valores positivos y negativos.
  /// Convención: `series: 'left'` = lado izquierdo, `series: 'right'` = lado derecho.
  /// El lado izquierdo se invierte a negativos para que se dibuje hacia el otro lado.
  static Widget _pyramid(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    final left = <ChartPoint>[];
    final right = <ChartPoint>[];

    for (final p in data) {
      if (p.series == 'left') {
        // Forzamos el valor a negativo para que se dibuje hacia la izquierda.
        left.add(ChartPoint(
          x: p.x,
          y: -p.y,
          series: 'Compras',
          label: p.label,
          extra: p.extra,
        ));
      } else {
        right.add(ChartPoint(
          x: p.x,
          y: p.y,
          series: 'Ventas',
          label: p.label,
          extra: p.extra,
        ));
      }
    }

    return charts.BarChart(
      [
        charts.Series<ChartPoint, String>(
          id: 'Compras',
          data: left,
          domainFn: (p, _) => p.x.toString(),
          measureFn: (p, _) => p.y,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.bearishColor,
          ),
        ),
        charts.Series<ChartPoint, String>(
          id: 'Ventas',
          data: right,
          domainFn: (p, _) => p.x.toString(),
          measureFn: (p, _) => p.y,
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            tokens.bullishColor,
          ),
        ),
      ],
      animate: animate,
      vertical: false,
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

  /// Radar multi-dataset (barras agrupadas).
  /// community_charts_flutter no tiene radar nativo, así que representamos
  /// el mismo concepto con barras agrupadas: cada serie es una "entidad"
  /// y el eje X son las métricas compartidas.
  static Widget _radarMulti(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    final grouped = <String, List<ChartPoint>>{};
    for (final p in data) {
      final key = p.series ?? 'default';
      grouped.putIfAbsent(key, () => []).add(p);
    }

    final palette = <String, Color>{
      'BTC': tokens.primaryColor,
      'ETH': tokens.secondaryColor,
      'SOL': tokens.accentColor,
      'BNB': tokens.bullishColor,
      'XRP': tokens.bearishColor,
    };

    final series = grouped.entries.map((entry) {
      final color = palette[entry.key] ?? tokens.primaryColor;
      return charts.Series<ChartPoint, String>(
        id: entry.key,
        data: entry.value,
        domainFn: (p, _) => p.x.toString(),
        measureFn: (p, _) => p.y,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(color),
      );
    }).toList();

    return charts.BarChart(
      series,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
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

  static Widget _gradientAreaFallback(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    return charts.LineChart(
      LineAdapter.singleNumeric(
        data: data,
        color: tokens.primaryColor,
        includeArea: true,
      ),
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(
        includeArea: true,
        includeLine: true,
        includePoints: false,
      ),
      primaryMeasureAxis: LineAdapter.yAxisSpec(
        labelColor: tokens.axisLabelColor,
        gridColor: tokens.gridLineColor,
      ),
      domainAxis: LineAdapter.xAxisNumeric(
        labelColor: tokens.axisLabelColor,
        labels: data.map((p) => p.x.toString()).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // AVANZADO — Candlestick + Volumen (Bloque 3.2.6)
  // ---------------------------------------------------------------------

  /// Candlestick con banda de volumen.
  /// En Web muestra aviso por el bug de renderers custom en 1.0.4.
  static Widget _candlestickWithVolume(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    if (kIsWeb) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.candlestick_chart_outlined,
                size: 32,
                color: tokens.axisLabelColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Candlestick no disponible en Web\n(bug de renderers custom en community_charts_flutter)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: tokens.axisLabelColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Android / Desktop: renderizamos el candlestick real.
    return _buildCandlestickChart(data, tokens, animate: animate);
  }

  static Widget _buildCandlestickChart(
    List<ChartPoint> data,
    ChartThemeTokens tokens, {
    bool animate = true,
  }) {
    // Convertimos a índice numérico para que el ScatterPlotChart acepte la serie.
    final indexedData = <MapEntry<int, ChartPoint>>[
      for (int i = 0; i < data.length; i++) MapEntry(i, data[i]),
    ];

    return charts.ScatterPlotChart(
      [
        charts.Series<MapEntry<int, ChartPoint>, num>(
          id: 'candlestick',
          data: indexedData,
          domainFn: (entry, _) => entry.key.toDouble(),
          measureFn: (entry, _) => entry.value.y,
          colorFn: (entry, _) {
            final open = (entry.value.extra?['open'] as num?)?.toDouble() ??
                entry.value.y;
            final close = (entry.value.extra?['close'] as num?)?.toDouble() ??
                entry.value.y;
            return charts.ColorUtil.fromDartColor(
              close >= open ? tokens.bullishColor : tokens.bearishColor,
            );
          },
          radiusPxFn: (_, __) => 8,
        ),
      ],
      animate: animate,
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
      ),
    );
  }
}
