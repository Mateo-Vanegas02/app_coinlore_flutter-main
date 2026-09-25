import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico Financiero de Velas Japonesas (Candlestick / OHLC Chart).
/// Utiliza [CustomMark] con [CandlestickShape], unificando la escala continua de precios
/// en todas las variables para garantizar el renderizado del cuerpo y mechas de las velas.
class GraphicCandlestickChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool showAxes;

  const GraphicCandlestickChart({
    super.key,
    required this.data,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    // 1. Extraemos mínimo y máximo para una escala compartida unificada
    num minPrice = double.infinity;
    num maxPrice = double.negativeInfinity;
    for (final item in data) {
      final low = item['low'] as num;
      final high = item['high'] as num;
      if (low < minPrice) minPrice = low;
      if (high > maxPrice) maxPrice = high;
    }
    if (minPrice == double.infinity) minPrice = 83500;
    if (maxPrice == double.negativeInfinity) maxPrice = 85000;

    final diff = max(1.0, maxPrice - minPrice);
    final priceScale = LinearScale(
      min: minPrice - (diff * 0.15),
      max: maxPrice + (diff * 0.15),
    );

    return Column(
      children: [
        // Resumen OHLC de la última vela
        if (data.isNotEmpty) ...[
          _buildOhlcHeader(data.last, tokens),
          const SizedBox(height: 8),
        ],
        Expanded(
          child: Chart<Map<String, dynamic>>(
            data: data,
            variables: {
              'date': Variable(accessor: (m) => m['date'] as String),
              'start': Variable(
                accessor: (m) => m['open'] as num,
                scale: priceScale,
              ),
              'end': Variable(
                accessor: (m) => m['close'] as num,
                scale: priceScale,
              ),
              'max': Variable(
                accessor: (m) => m['high'] as num,
                scale: priceScale,
              ),
              'min': Variable(
                accessor: (m) => m['low'] as num,
                scale: priceScale,
              ),
            },
            marks: [
              CustomMark(
                position: Varset('date') *
                    (Varset('start') + Varset('end') + Varset('max') + Varset('min')),
                shape: ShapeEncode(
                  value: CandlestickShape(
                    hollow: false,
                    strokeWidth: 2.0,
                  ),
                ),
                color: ColorEncode(
                  encoder: (tuple) {
                    final close = tuple['end'] as num;
                    final open = tuple['start'] as num;
                    return close >= open ? tokens.bullishColor : tokens.bearishColor;
                  },
                ),
                size: SizeEncode(value: 24.0),
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
                          fontSize: 9,
                        ),
                        offset: const Offset(0, 6),
                      ),
                    ),
                    AxisGuide(
                      dim: Dim.y,
                      line: PaintStyle(strokeColor: tokens.axisLineColor, strokeWidth: 1),
                      label: LabelStyle(
                        textStyle: TextStyle(
                          color: tokens.axisLabelColor,
                          fontSize: 9,
                        ),
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
              variables: ['date', 'start', 'end', 'max', 'min'],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOhlcHeader(Map<String, dynamic> item, ChartThemeTokens tokens) {
    final open = (item['open'] as num).toStringAsFixed(0);
    final high = (item['high'] as num).toStringAsFixed(0);
    final low = (item['low'] as num).toStringAsFixed(0);
    final close = (item['close'] as num).toStringAsFixed(0);
    final isBull = (item['close'] as num) >= (item['open'] as num);
    final color = isBull ? tokens.bullishColor : tokens.bearishColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMetric('O', '\$$open', tokens.axisLabelColor),
        _buildMetric('H', '\$$high', tokens.axisLabelColor),
        _buildMetric('L', '\$$low', tokens.axisLabelColor),
        _buildMetric('C', '\$$close', color),
      ],
    );
  }

  Widget _buildMetric(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
