import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Barras de Rango / Flotantes (Range / Floating Bar Chart).
/// Renderiza barras suspendidas delimitadas por un valor inferior y uno superior
/// ($Y_{min}, Y_{max}$), ideal para rangos de precio 24h (mínimo a máximo).
class AppRangeBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool showAxes;

  const AppRangeBarChart({
    super.key,
    required this.data,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    num minVal = double.infinity;
    num maxVal = double.negativeInfinity;
    for (final item in data) {
      final min = item['min'] as num;
      final max = item['max'] as num;
      if (min < minVal) minVal = min;
      if (max > maxVal) maxVal = max;
    }
    if (minVal == double.infinity) minVal = -5;
    if (maxVal == double.negativeInfinity) maxVal = 10;
    final diff = (maxVal - minVal) > 0 ? (maxVal - minVal) : 5;
    final sharedScale = LinearScale(
      min: minVal - (diff * 0.1),
      max: maxVal + (diff * 0.1),
    );

    return Chart<Map<String, dynamic>>(
      data: data,
      variables: {
        'crypto': Variable(accessor: (Map m) => m['crypto'] as String),
        'min': Variable(accessor: (Map m) => m['min'] as num, scale: sharedScale),
        'max': Variable(accessor: (Map m) => m['max'] as num, scale: sharedScale),
      },
      coord: RectCoord(transposed: true),
      marks: [
        IntervalMark(
          position: Varset('crypto') * (Varset('min') + Varset('max')),
          color: ColorEncode(value: tokens.primaryColor),
          shape: ShapeEncode(value: RectShape(borderRadius: BorderRadius.circular(4))),
          size: SizeEncode(value: 14.0),
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
        variables: ['crypto', 'min', 'max'],
      ),
    );
  }
}
