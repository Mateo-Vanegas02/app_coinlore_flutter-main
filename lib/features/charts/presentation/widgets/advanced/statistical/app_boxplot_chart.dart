import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico Estadístico de Caja y Bigotes (BoxPlot Chart).
/// Renderiza con precisión quirúrgica los 5 números estadísticos de resumen:
/// Mínimo, Primer Cuartil (Q1), Mediana, Tercer Cuartil (Q3) y Máximo para cada criptoactivo.
class AppBoxPlotChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppBoxPlotChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    if (data.isEmpty) return const SizedBox.shrink();

    // Calculamos el rango global para normalizar las alturas de las cajas
    num globalMin = double.infinity;
    num globalMax = double.negativeInfinity;
    for (final item in data) {
      final minVal = item['min'] as num;
      final maxVal = item['max'] as num;
      if (minVal < globalMin) globalMin = minVal;
      if (maxVal > globalMax) globalMax = maxVal;
    }
    if (globalMin == double.infinity) globalMin = 0;
    if (globalMax == double.negativeInfinity) globalMax = 100;
    final totalRange = (globalMax - globalMin) > 0 ? (globalMax - globalMin) : 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: data.map((item) {
        final asset = item['asset'] as String;
        final minVal = item['min'] as num;
        final q1 = item['q1'] as num;
        final median = item['median'] as num;
        final q3 = item['q3'] as num;
        final maxVal = item['max'] as num;

        return Expanded(
          child: Column(
            children: [
              // Leyenda de valores flotante
              Text(
                'Max: \$${_formatCompact(maxVal)}',
                style: TextStyle(fontSize: 10, color: tokens.axisLabelColor),
              ),
              const SizedBox(height: 6),

              // Canvas del BoxPlot para este activo
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final height = constraints.maxHeight;
                    final width = constraints.maxWidth;
                    final boxWidth = (width * 0.45).clamp(24.0, 52.0);

                    // Función para convertir valor numérico a posición Y en píxeles (invertido: 0 arriba)
                    double toY(num val) {
                      final norm = (val - globalMin) / totalRange;
                      return height - (norm * height);
                    }

                    final yMax = toY(maxVal);
                    final yQ3 = toY(q3);
                    final yMedian = toY(median);
                    final yQ1 = toY(q1);
                    final yMin = toY(minVal);

                    return CustomPaint(
                      size: Size(width, height),
                      painter: _BoxPlotPainter(
                        yMax: yMax,
                        yQ3: yQ3,
                        yMedian: yMedian,
                        yQ1: yQ1,
                        yMin: yMin,
                        boxWidth: boxWidth,
                        tokens: tokens,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Etiqueta del activo
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: tokens.isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  asset,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: tokens.isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatCompact(num number) {
    if (number >= 1e6) return '${(number / 1e6).toStringAsFixed(1)}M';
    if (number >= 1e3) return '${(number / 1e3).toStringAsFixed(1)}K';
    return number.toStringAsFixed(0);
  }
}

class _BoxPlotPainter extends CustomPainter {
  final double yMax;
  final double yQ3;
  final double yMedian;
  final double yQ1;
  final double yMin;
  final double boxWidth;
  final ChartThemeTokens tokens;

  _BoxPlotPainter({
    required this.yMax,
    required this.yQ3,
    required this.yMedian,
    required this.yQ1,
    required this.yMin,
    required this.boxWidth,
    required this.tokens,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // 1. Pintar Bigotes (Líneas verticales)
    final whiskerPaint = Paint()
      ..color = tokens.axisLineColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Bigote superior (de Q3 a Max)
    canvas.drawLine(Offset(centerX, yQ3), Offset(centerX, yMax), whiskerPaint);
    // Tapa del bigote superior
    canvas.drawLine(
      Offset(centerX - boxWidth * 0.35, yMax),
      Offset(centerX + boxWidth * 0.35, yMax),
      whiskerPaint,
    );

    // Bigote inferior (de Q1 a Min)
    canvas.drawLine(Offset(centerX, yQ1), Offset(centerX, yMin), whiskerPaint);
    // Tapa del bigote inferior
    canvas.drawLine(
      Offset(centerX - boxWidth * 0.35, yMin),
      Offset(centerX + boxWidth * 0.35, yMin),
      whiskerPaint,
    );

    // 2. Pintar Caja Intercuartílica (Q1 a Q3)
    final boxRect = Rect.fromLTRB(
      centerX - boxWidth / 2,
      yQ3,
      centerX + boxWidth / 2,
      yQ1,
    );

    final boxFillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          tokens.primaryColor.withValues(alpha: 0.65),
          tokens.primaryColor.withValues(alpha: 0.35),
        ],
      ).createShader(boxRect)
      ..style = PaintingStyle.fill;

    final boxBorderPaint = Paint()
      ..color = tokens.primaryColor
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(boxRect, const Radius.circular(6));
    canvas.drawRRect(rrect, boxFillPaint);
    canvas.drawRRect(rrect, boxBorderPaint);

    // 3. Pintar Línea de Mediana (Destacada en verde alcista o acento)
    final medianPaint = Paint()
      ..color = tokens.bullishColor
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(centerX - boxWidth / 2 + 2, yMedian),
      Offset(centerX + boxWidth / 2 - 2, yMedian),
      medianPaint,
    );

    // Punto central de la mediana
    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(centerX, yMedian), 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _BoxPlotPainter oldDelegate) => true;
}
