import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../charts/domain/models/chart_point.dart';
import '../../theme/chart_theme_tokens.dart';
import 'adapters/line_adapter.dart';

/// Dos gráficos de línea apilados que comparten el rango visible del eje X.
/// El rango se controla desde un RangeSlider y ambos se actualizan al unísono.
class CommunitySyncedCharts extends StatefulWidget {
  final ChartThemeTokens tokens;
  final int totalPoints;

  const CommunitySyncedCharts({
    super.key,
    required this.tokens,
    this.totalPoints = 100,
  });

  @override
  State<CommunitySyncedCharts> createState() => _CommunitySyncedChartsState();
}

class _CommunitySyncedChartsState extends State<CommunitySyncedCharts> {
  late final List<ChartPoint> _seriesA;
  late final List<ChartPoint> _seriesB;
  RangeValues _range = const RangeValues(0, 50);

  @override
  void initState() {
    super.initState();
    _seriesA = _generateSeries(
      seed: 42,
      basePrice: 84000,
      count: widget.totalPoints,
    );
    _seriesB = _generateSeries(
      seed: 1337,
      basePrice: 2600,
      count: widget.totalPoints,
    );
    _range = RangeValues(0, widget.totalPoints.toDouble());
  }

  /// Caminata aleatoria determinista para que la sincronización sea estable.
  List<ChartPoint> _generateSeries({
    required int seed,
    required double basePrice,
    required int count,
  }) {
    final points = <ChartPoint>[];
    double price = basePrice;
    int s = seed;
    for (int i = 0; i < count; i++) {
      s ^= s << 13;
      s ^= s >> 7;
      s ^= s << 17;
      final r = (s & 0x7FFFFFFF) / 0x7FFFFFFF;
      final shock = (r - 0.5) * 2 * 0.005;
      price = price * (1 + shock);
      points.add(ChartPoint(x: i.toString(), y: price));
    }
    return points;
  }

  List<ChartPoint> _visibleSlice(List<ChartPoint> source) {
    final start = _range.start.round().clamp(0, source.length - 1);
    final end = _range.end.round().clamp(start + 1, source.length);
    return source.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = widget.tokens;
    final visibleA = _visibleSlice(_seriesA);
    final visibleB = _visibleSlice(_seriesB);

    return Column(
      children: [
        // Indicador del rango
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.sync,
                    size: 14,
                    color: tokens.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Vista sincronizada',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: tokens.primaryColor,
                    ),
                  ),
                ],
              ),
              Text(
                'Puntos ${_range.start.round()} – ${_range.end.round()}',
                style: TextStyle(
                  fontSize: 11,
                  color: tokens.axisLabelColor,
                ),
              ),
            ],
          ),
        ),
        // Gráfico A
        Expanded(
          child: _buildChart(
            data: visibleA,
            color: tokens.primaryColor,
            tokens: tokens,
          ),
        ),
        const SizedBox(height: 8),
        // Gráfico B
        Expanded(
          child: _buildChart(
            data: visibleB,
            color: tokens.secondaryColor,
            tokens: tokens,
          ),
        ),
        // Control de rango compartido
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: RangeSlider(
            values: _range,
            min: 0,
            max: widget.totalPoints.toDouble(),
            divisions: widget.totalPoints - 1,
            activeColor: tokens.primaryColor,
            inactiveColor: tokens.axisLabelColor.withValues(alpha: 0.2),
            labels: RangeLabels(
              _range.start.round().toString(),
              _range.end.round().toString(),
            ),
            onChanged: (values) {
              // Forzamos un mínimo de 5 puntos visibles.
              if (values.end - values.start < 5) return;
              setState(() => _range = values);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChart({
    required List<ChartPoint> data,
    required Color color,
    required ChartThemeTokens tokens,
  }) {
    final labels = data.map((p) => p.x.toString()).toList();
    return charts.LineChart(
      LineAdapter.singleNumeric(
        data: data,
        color: color,
        includeArea: true,
      ),
      animate: false,
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
        labels: labels,
      ),
    );
  }
}
