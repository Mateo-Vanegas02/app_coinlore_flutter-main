import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/domain/models/chart_point.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico Multi-Línea (Multi-Line Chart).
/// Compara múltiples activos cripto a lo largo del tiempo usando
/// [LineMark] con posición `Varset('x') * Varset('y') / Varset('series')`
/// y codificación de color por serie.
class AppMultiLineChart extends StatelessWidget {
  final List<ChartPoint> data;
  final List<Color>? palette;
  final bool showAxes;

  const AppMultiLineChart({
    super.key,
    required this.data,
    this.palette,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final effectivePalette = palette ??
        [
          tokens.primaryColor,
          tokens.bullishColor,
          tokens.secondaryColor,
          tokens.accentColor,
        ];

    final chartData = data.map((p) => p.toMap()).toList();

    return Chart<Map<String, dynamic>>(
      data: chartData,
      variables: {
        'x': Variable(
          accessor: (Map map) => map['x'].toString(),
        ),
        'y': Variable(
          accessor: (Map map) => map['y'] as num,
        ),
        'series': Variable(
          accessor: (Map map) => (map['series'] ?? 'Default') as String,
        ),
      },
      marks: [
        LineMark(
          position: Varset('x') * Varset('y') / Varset('series'),
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          size: SizeEncode(value: 2.2),
          color: ColorEncode(
            variable: 'series',
            values: effectivePalette,
          ),
        ),
      ],
      axes: showAxes
          ? [
              AxisGuide(
                dim: Dim.x,
                line: PaintStyle(strokeColor: tokens.axisLineColor, strokeWidth: 1),
                label: LabelStyle(
                  textStyle: TextStyle(
                    color: tokens.axisLabelColor,
                    fontSize: 10,
                  ),
                  offset: const Offset(0, 6),
                ),
                grid: PaintStyle(strokeColor: tokens.gridLineColor, strokeWidth: 1),
              ),
              AxisGuide(
                dim: Dim.y,
                line: PaintStyle(strokeColor: tokens.axisLineColor, strokeWidth: 1),
                label: LabelStyle(
                  textStyle: TextStyle(
                    color: tokens.axisLabelColor,
                    fontSize: 10,
                  ),
                  offset: const Offset(-5, 0),
                ),
                grid: PaintStyle(strokeColor: tokens.gridLineColor, strokeWidth: 1),
              ),
            ]
          : null,
      selections: {
        'touch': PointSelection(
          dim: Dim.x,
          nearest: true,
        ),
      },
      tooltip: TooltipGuide(
        selections: {'touch'},
        followPointer: [true, true],
        backgroundColor: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
        radius: const Radius.circular(8),
        elevation: 4,
        variables: ['series', 'x', 'y'],
      ),
    );
  }
}
