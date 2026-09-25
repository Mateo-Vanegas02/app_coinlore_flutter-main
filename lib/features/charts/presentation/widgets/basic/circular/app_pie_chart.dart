import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/domain/models/chart_point.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Torta Completa (Pie Chart).
/// Utiliza [IntervalMark] con [StackModifier] y [Proportion] sobre [PolarCoord]
/// con radio interior en cero (`startRadius: 0`).
class AppPieChart extends StatelessWidget {
  final List<ChartPoint> data;
  final List<Color>? palette;

  const AppPieChart({
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
          tokens.bearishColor,
        ];

    final chartData = data.map((p) => p.toMap()).toList();

    return Chart<Map<String, dynamic>>(
      data: chartData,
      variables: {
        'x': Variable(accessor: (Map m) => m['x'].toString()),
        'y': Variable(accessor: (Map m) => m['y'] as num),
      },
      transforms: [
        Proportion(variable: 'y', as: 'percent'),
      ],
      coord: PolarCoord(
        transposed: true,
        dimCount: 1,
        startRadius: 0.0,
        endRadius: 0.95,
      ),
      marks: [
        IntervalMark(
          position: Varset('percent') / Varset('x'),
          color: ColorEncode(variable: 'x', values: colors),
          modifiers: [StackModifier()],
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
        variables: ['x', 'percent'],
      ),
    );
  }
}
