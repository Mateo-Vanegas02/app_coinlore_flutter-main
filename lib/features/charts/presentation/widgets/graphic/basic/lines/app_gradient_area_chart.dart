import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/domain/models/chart_point.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Área con Gradiente (Gradient Area Chart).
/// Utiliza [AreaMark] y [LineMark] con degradado vertical en la propiedad de color
/// para transmitir volumen y profundidad estética.
class GraphicGradientAreaChart extends StatelessWidget {
  final List<ChartPoint> data;
  final bool isBullish;
  final bool showAxes;

  const GraphicGradientAreaChart({
    super.key,
    required this.data,
    this.isBullish = true,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final baseColor = isBullish ? tokens.bullishColor : tokens.bearishColor;
    final chartData = data.map((p) => p.toMap()).toList();

    return Chart<Map<String, dynamic>>(
      data: chartData,
      variables: {
        'x': Variable(accessor: (Map m) => m['x'].toString()),
        'y': Variable(accessor: (Map m) => m['y'] as num),
      },
      marks: [
        AreaMark(
          shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
          gradient: GradientEncode(
            value: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                baseColor.withValues(alpha: 0.45),
                baseColor.withValues(alpha: 0.02),
              ],
            ),
          ),
        ),
        LineMark(
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          color: ColorEncode(value: baseColor),
          size: SizeEncode(value: 2.4),
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
        'tap': PointSelection(dim: Dim.x, nearest: true),
      },
      tooltip: TooltipGuide(
        selections: {'tap'},
        backgroundColor: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
        radius: const Radius.circular(8),
        elevation: 4,
        variables: ['x', 'y'],
      ),
    );
  }
}
