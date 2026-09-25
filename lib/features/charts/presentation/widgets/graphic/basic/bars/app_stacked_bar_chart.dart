import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Barras Apiladas (Stacked Bar Chart).
/// Utiliza [IntervalMark] con [StackModifier] para acumular valores por categoría.
class GraphicStackedBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Color>? palette;
  final bool showAxes;

  const GraphicStackedBarChart({
    super.key,
    required this.data,
    this.palette,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final colors = palette ?? [tokens.primaryColor, tokens.secondaryColor, tokens.bullishColor];

    return Chart<Map<String, dynamic>>(
      data: data,
      variables: {
        'category': Variable(accessor: (Map m) => m['category'] as String),
        'value': Variable(accessor: (Map m) => m['value'] as num),
        'type': Variable(accessor: (Map m) => m['type'] as String),
      },
      marks: [
        IntervalMark(
          position: Varset('category') * Varset('value') / Varset('type'),
          color: ColorEncode(variable: 'type', values: colors),
          modifiers: [StackModifier()],
          shape: ShapeEncode(value: RectShape(borderRadius: BorderRadius.circular(4))),
        ),
      ],
      axes: showAxes
          ? [
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
            ]
          : null,
      selections: {
        'tap': PointSelection(nearest: true),
      },
      tooltip: TooltipGuide(
        selections: {'tap'},
        backgroundColor: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
        radius: const Radius.circular(8),
        elevation: 4,
        variables: ['category', 'type', 'value'],
      ),
    );
  }
}
