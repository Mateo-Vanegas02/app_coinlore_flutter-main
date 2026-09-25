import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/domain/models/chart_point.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Área Suavizada con Línea (Smooth Area Chart).
/// Representa la evolución temporal o de precios combinando
/// [AreaMark] y [LineMark] suavizados con [BasicAreaShape(smooth: true)]
/// y [BasicLineShape(smooth: true)].
class AppSmoothAreaChart extends StatelessWidget {
  final List<ChartPoint> data;
  final bool isBullish;
  final bool showAxes;

  const AppSmoothAreaChart({
    super.key,
    required this.data,
    this.isBullish = true,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final chartColor = isBullish ? tokens.bullishColor : tokens.bearishColor;
    final chartData = data.map((p) => p.toMap()).toList();

    return Chart<Map<String, dynamic>>(
      data: chartData,
      variables: {
        'x': Variable(
          accessor: (Map map) => map['x'].toString(),
        ),
        'y': Variable(
          accessor: (Map map) => map['y'] as num,
          scale: LinearScale(
            min: _calculateMin(data),
            max: _calculateMax(data),
          ),
        ),
      },
      marks: [
        AreaMark(
          shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
          color: ColorEncode(value: chartColor.withValues(alpha: 0.18)),
        ),
        LineMark(
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          color: ColorEncode(value: chartColor),
          size: SizeEncode(value: 2.5),
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
                  offset: const Offset(0, 7),
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
        align: Alignment.topLeft,
        offset: const Offset(-20, -20),
        backgroundColor: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
        radius: const Radius.circular(8),
        elevation: 4,
        variables: ['x', 'y'],
      ),
      crosshair: CrosshairGuide(
        styles: [
          PaintStyle(
            strokeColor: chartColor.withValues(alpha: 0.5),
            strokeWidth: 1,
            dash: [4, 4],
          ),
        ],
      ),
    );
  }

  num _calculateMin(List<ChartPoint> points) {
    if (points.isEmpty) return 0;
    final minVal = points.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    return minVal * 0.99;
  }

  num _calculateMax(List<ChartPoint> points) {
    if (points.isEmpty) return 100;
    final maxVal = points.map((p) => p.y).reduce((a, b) => a > b ? a : b);
    return maxVal * 1.01;
  }
}
