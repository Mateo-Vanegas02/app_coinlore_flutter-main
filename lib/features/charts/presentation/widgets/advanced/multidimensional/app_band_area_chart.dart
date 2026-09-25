import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Bandas de Rango / Confianza (Range Area / Band Chart).
/// Representa bandas de volatilidad (como Bandas de Bollinger) mediante una combinación
/// de área sombreada entre límites superior/inferior y una línea central de media móvil.
class AppBandAreaChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool showAxes;

  const AppBandAreaChart({
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
      final l = item['lower'] as num;
      final u = item['upper'] as num;
      if (l < minVal) minVal = l;
      if (u > maxVal) maxVal = u;
    }
    if (minVal == double.infinity) minVal = 83000;
    if (maxVal == double.negativeInfinity) maxVal = 86000;
    final diff = (maxVal - minVal) > 0 ? (maxVal - minVal) : 100;
    final sharedScale = LinearScale(
      min: minVal - (diff * 0.1),
      max: maxVal + (diff * 0.1),
    );

    return Chart<Map<String, dynamic>>(
      data: data,
      variables: {
        'time': Variable(accessor: (Map m) => m['time'] as String),
        'upper': Variable(accessor: (Map m) => m['upper'] as num, scale: sharedScale),
        'lower': Variable(accessor: (Map m) => m['lower'] as num, scale: sharedScale),
        'price': Variable(accessor: (Map m) => m['price'] as num, scale: sharedScale),
      },
      marks: [
        // Banda Superior
        LineMark(
          position: Varset('time') * Varset('upper'),
          shape: ShapeEncode(value: BasicLineShape(smooth: true, dash: [4, 4])),
          color: ColorEncode(value: tokens.primaryColor.withValues(alpha: 0.5)),
          size: SizeEncode(value: 1.5),
        ),
        // Sombra de Banda
        AreaMark(
          position: Varset('time') * Varset('upper'),
          shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
          color: ColorEncode(value: tokens.primaryColor.withValues(alpha: 0.12)),
        ),
        // Precio / Media Central
        LineMark(
          position: Varset('time') * Varset('price'),
          shape: ShapeEncode(value: BasicLineShape(smooth: true)),
          color: ColorEncode(value: tokens.bullishColor),
          size: SizeEncode(value: 2.5),
        ),
        // Banda Inferior
        LineMark(
          position: Varset('time') * Varset('lower'),
          shape: ShapeEncode(value: BasicLineShape(smooth: true, dash: [4, 4])),
          color: ColorEncode(value: tokens.primaryColor.withValues(alpha: 0.5)),
          size: SizeEncode(value: 1.5),
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
        'tap': PointSelection(dim: Dim.x, nearest: true),
      },
      tooltip: TooltipGuide(
        selections: {'tap'},
        backgroundColor: tokens.tooltipBackgroundColor,
        textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
        radius: const Radius.circular(8),
        elevation: 4,
        variables: ['time', 'price', 'upper', 'lower'],
      ),
    );
  }
}
