import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Río de Datos / Área de Flujo (Streamgraph).
/// Utiliza [AreaMark] combinando [StackModifier] y [SymmetricModifier]
/// para centrar el flujo orgánico alrededor de un eje central neutral.
class GraphicStreamgraphChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Color>? palette;

  const GraphicStreamgraphChart({
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
          tokens.secondaryColor,
          tokens.bullishColor,
          tokens.accentColor,
        ];

    return Chart<Map<String, dynamic>>(
      data: data,
      variables: {
        'date': Variable(accessor: (Map m) => m['date'] as String),
        'value': Variable(accessor: (Map m) => m['value'] as num),
        'type': Variable(accessor: (Map m) => m['type'] as String),
      },
      marks: [
        AreaMark(
          position: Varset('date') * Varset('value') / Varset('type'),
          shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
          color: ColorEncode(variable: 'type', values: colors),
          modifiers: [StackModifier(), SymmetricModifier()],
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
        ),
      ],
      selections: {
        'tap': PointSelection(nearest: true),
      },
      tooltip: TooltipGuide(
        selections: {'tap'},
        backgroundColor: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
        radius: const Radius.circular(8),
        elevation: 4,
        variables: ['date', 'type', 'value'],
      ),
    );
  }
}
