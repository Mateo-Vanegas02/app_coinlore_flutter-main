import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/domain/models/chart_point.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Línea Escalonada (Step Line Chart).
/// Utiliza [LineMark] con [BasicLineShape(stepped: true)] para representar
/// cambios discretos de tasa o niveles de soporte/resistencia.
class GraphicStepLineChart extends StatelessWidget {
  final List<ChartPoint> data;
  final Color? color;
  final bool showAxes;

  const GraphicStepLineChart({
    super.key,
    required this.data,
    this.color,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final lineColor = color ?? tokens.primaryColor;
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
      marks: [
        AreaMark(
          shape: ShapeEncode(value: BasicAreaShape(stepped: true)),
          color: ColorEncode(value: lineColor.withValues(alpha: 0.12)),
        ),
        LineMark(
          shape: ShapeEncode(value: BasicLineShape(stepped: true)),
          color: ColorEncode(value: lineColor),
          size: SizeEncode(value: 2.2),
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
        backgroundColor: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
        radius: const Radius.circular(8),
        elevation: 4,
        variables: ['x', 'y'],
      ),
    );
  }
}
