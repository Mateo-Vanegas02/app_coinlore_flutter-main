import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Dispersión y Burbujas (Scatter Plot & Bubble Chart).
/// Utiliza [PointMark] con [CircleShape]. Asigna variables a coordenadas X, Y,
/// tamaño (SizeEncode para el radio de la burbuja) y color categórico.
class AppScatterChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool showAxes;

  const AppScatterChart({
    super.key,
    required this.data,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return Chart<Map<String, dynamic>>(
      data: data,
      variables: {
        'x': Variable(
          accessor: (Map m) => m['x'] as num,
        ),
        'y': Variable(
          accessor: (Map m) => m['y'] as num,
        ),
        'size': Variable(
          accessor: (Map m) => m['size'] as num,
        ),
        'label': Variable(
          accessor: (Map m) => m['label'] as String,
        ),
        'group': Variable(
          accessor: (Map m) => (m['group'] ?? 'Normal') as String,
        ),
      },
      marks: [
        PointMark(
          position: Varset('x') * Varset('y'),
          size: SizeEncode(variable: 'size', values: [8, 20]),
          color: ColorEncode(
            variable: 'group',
            values: [
              tokens.primaryColor,
              tokens.bullishColor,
              tokens.accentColor,
              tokens.secondaryColor,
              tokens.bearishColor,
            ],
          ),
          shape: ShapeEncode(value: CircleShape()),
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
        variables: ['label', 'x', 'y'],
      ),
    );
  }
}
