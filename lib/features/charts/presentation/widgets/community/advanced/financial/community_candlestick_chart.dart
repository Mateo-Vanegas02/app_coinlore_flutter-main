import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 31. Candlestick con community_charts_flutter.
/// NO SOPORTADO: la librería no expone OHLC a los symbol renderers.
/// Se aproximaría con ScatterPlotChart pero queda como puntos sueltos,
/// no como velas reales. Lo mostramos como fallback.
class CommunityCandlestickChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityCandlestickChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.candlestick_chart_outlined,
              size: 28,
              color: tokens.axisLabelColor,
            ),
            const SizedBox(height: 6),
            Text(
              'Candlestick no soportado\npor community_charts_flutter\n\nDisponible en Syncfusion y Graphic',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: tokens.axisLabelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
