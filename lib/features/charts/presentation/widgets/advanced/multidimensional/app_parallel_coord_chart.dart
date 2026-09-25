import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Coordenadas Paralelas (Parallel Coordinates).
/// Compara múltiples activos financieros a través de 4 o más dimensiones continuas
/// normalizadas (Volumen, Market Cap, ATH, Impulso 24h) en una sola vista.
class AppParallelCoordChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Color>? palette;

  const AppParallelCoordChart({
    super.key,
    required this.data,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final colors = palette ??
        [
          tokens.primaryColor,
          tokens.bullishColor,
          tokens.secondaryColor,
          tokens.accentColor,
        ];

    return Chart<Map<String, dynamic>>(
      data: data,
      variables: {
        'metric': Variable(accessor: (Map m) => m['metric'] as String),
        'score': Variable(
          accessor: (Map m) => m['score'] as num,
          scale: LinearScale(min: 0, max: 100),
        ),
        'crypto': Variable(accessor: (Map m) => m['crypto'] as String),
      },
      marks: [
        LineMark(
          position: Varset('metric') * Varset('score') / Varset('crypto'),
          shape: ShapeEncode(value: BasicLineShape(smooth: false)),
          color: ColorEncode(variable: 'crypto', values: colors),
          size: SizeEncode(value: 2.5),
        ),
        PointMark(
          position: Varset('metric') * Varset('score') / Varset('crypto'),
          color: ColorEncode(variable: 'crypto', values: colors),
          size: SizeEncode(value: 6.0),
          shape: ShapeEncode(value: CircleShape()),
        ),
      ],
      axes: [
        AxisGuide(
          dim: Dim.x,
          line: PaintStyle(strokeColor: tokens.axisLineColor, strokeWidth: 1),
          label: LabelStyle(
            textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
            offset: const Offset(0, 6),
          ),
          grid: PaintStyle(strokeColor: tokens.gridLineColor, strokeWidth: 1),
        ),
        AxisGuide(
          dim: Dim.y,
          line: PaintStyle(strokeColor: tokens.axisLineColor, strokeWidth: 1),
          label: LabelStyle(
            textStyle: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
            offset: const Offset(-5, 0),
          ),
          grid: PaintStyle(strokeColor: tokens.gridLineColor, strokeWidth: 1),
        ),
      ],
      selections: {
        'tap': PointSelection(dim: Dim.x, nearest: true),
      },
      tooltip: TooltipGuide(
        selections: {'tap'},
        backgroundColor: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
        radius: const Radius.circular(8),
        elevation: 4,
        variables: ['crypto', 'metric', 'score'],
      ),
    );
  }
}
