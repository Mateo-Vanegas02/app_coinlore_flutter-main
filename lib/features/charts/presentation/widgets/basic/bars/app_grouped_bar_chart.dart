import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Barras Agrupadas (Grouped Bar Chart).
/// Utiliza [IntervalMark] con [DodgeModifier] para comparar métricas lado a lado
/// (por ejemplo: Volumen vs Capitalización en diferentes activos).
class AppGroupedBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Color>? palette;
  final bool showAxes;

  const AppGroupedBarChart({
    super.key,
    required this.data,
    this.palette,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final colors = palette ?? [tokens.primaryColor, tokens.bullishColor];

    return Chart<Map<String, dynamic>>(
      data: data,
      variables: {
        'category': Variable(
          accessor: (Map m) => m['category'] as String,
        ),
        'value': Variable(
          accessor: (Map m) => m['value'] as num,
        ),
        'group': Variable(
          accessor: (Map m) => m['group'] as String,
        ),
      },
      marks: [
        IntervalMark(
          position: Varset('category') * Varset('value') / Varset('group'),
          color: ColorEncode(variable: 'group', values: colors),
          modifiers: [DodgeModifier(ratio: 0.85)],
          shape: ShapeEncode(
            value: RectShape(borderRadius: BorderRadius.circular(4)),
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
        'tap': PointSelection(
          nearest: true,
        ),
      },
      tooltip: TooltipGuide(
        selections: {'tap'},
        backgroundColor: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
        radius: const Radius.circular(8),
        elevation: 4,
        variables: ['group', 'category', 'value'],
      ),
    );
  }
}
