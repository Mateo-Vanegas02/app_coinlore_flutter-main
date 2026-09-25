import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/domain/models/chart_point.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Línea Clásica (Standard Line Chart).
/// Utiliza [LineMark] puro en [RectCoord] para visualización directa de tendencias.
class AppStandardLineChart extends StatelessWidget {
  final List<ChartPoint> data;
  final Color? color;
  final bool showAxes;

  const AppStandardLineChart({
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
        'x': Variable(accessor: (Map m) => m['x'].toString()),
        'y': Variable(accessor: (Map m) => m['y'] as num),
      },
      marks: [
        LineMark(
          size: SizeEncode(value: 2.0),
          color: ColorEncode(value: lineColor),
        ),
        PointMark(
          size: SizeEncode(value: 5.0),
          color: ColorEncode(value: lineColor),
          shape: ShapeEncode(value: CircleShape()),
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
        variables: ['x', 'y'],
      ),
    );
  }
}
