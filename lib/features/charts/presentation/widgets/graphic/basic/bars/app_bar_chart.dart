import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/domain/models/chart_point.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Barras y Columnas (Vertical Bar / Horizontal Bar).
/// Utiliza [IntervalMark] con [RectCoord]. Permite transposición
/// para rankings horizontales o columnas verticales.
class GraphicBarChart extends StatelessWidget {
  final List<ChartPoint> data;
  final bool isHorizontal;
  final Color? barColor;
  final bool showAxes;

  const GraphicBarChart({
    super.key,
    required this.data,
    this.isHorizontal = false,
    this.barColor,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final effectiveColor = barColor ?? tokens.primaryColor;
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
      },
      coord: RectCoord(
        transposed: isHorizontal,
      ),
      marks: [
        IntervalMark(
          shape: ShapeEncode(
            value: RectShape(
              borderRadius: BorderRadius.circular(isHorizontal ? 4 : 6),
            ),
          ),
          color: ColorEncode(value: effectiveColor),
          size: SizeEncode(value: isHorizontal ? 14.0 : 20.0),
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
        followPointer: [true, true],
        align: Alignment.topCenter,
        offset: const Offset(0, -15),
        backgroundColor: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
        radius: const Radius.circular(8),
        elevation: 4,
        variables: ['x', 'y'],
      ),
    );
  }
}
