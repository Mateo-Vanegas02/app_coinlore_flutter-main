import 'dart:math';
import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Burbujas Financiero Multidimensional (Bubble Chart).
/// Representa criptomonedas cruzando 3 dimensiones clave:
/// - Eje X: Market Cap ($B)
/// - Eje Y: Variación 24h (%)
/// - Radio de la Burbuja: Volumen 24h
class AppBubbleChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool showAxes;

  const AppBubbleChart({
    super.key,
    required this.data,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    if (data.isEmpty) {
      return Center(
        child: Text(
          'Sin datos de burbujas',
          style: TextStyle(color: tokens.axisLabelColor, fontSize: 12),
        ),
      );
    }

    // Paleta semántica por activo
    final Map<String, Color> assetColors = {
      'BTC': const Color(0xFFF59E0B),
      'ETH': const Color(0xFF627EEA),
      'SOL': const Color(0xFF14F195),
      'XRP': const Color(0xFF23292F),
      'BNB': const Color(0xFFF3BA2F),
      'ADA': const Color(0xFF0033AD),
      'DOGE': const Color(0xFFC2A633),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Canvas del gráfico
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: CustomPaint(
                painter: _BubbleChartPainter(
                  data: data,
                  assetColors: assetColors,
                  tokens: tokens,
                  showAxes: showAxes,
                ),
              ),
            ),
            // Indicador de leyenda flotante superior
            Positioned(
              top: 4,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tokens.isDark
                      ? Colors.black.withValues(alpha: 0.45)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: tokens.isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: tokens.bullishColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Radio ∝ Vol 24h',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: tokens.axisLabelColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BubbleChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final Map<String, Color> assetColors;
  final ChartThemeTokens tokens;
  final bool showAxes;

  _BubbleChartPainter({
    required this.data,
    required this.assetColors,
    required this.tokens,
    required this.showAxes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Márgenes para ejes y etiquetas
    final leftPadding = showAxes ? 42.0 : 16.0;
    const rightPadding = 24.0;
    const topPadding = 24.0;
    final bottomPadding = showAxes ? 26.0 : 16.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    if (chartWidth <= 0 || chartHeight <= 0) return;

    // Calcular límites de X (Market Cap) e Y (Change %)
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    double minSize = double.infinity;
    double maxSize = double.negativeInfinity;

    for (final item in data) {
      final x = (item['x'] as num).toDouble();
      final y = (item['y'] as num).toDouble();
      final s = (item['size'] as num).toDouble();

      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;
      if (s < minSize) minSize = s;
      if (s > maxSize) maxSize = s;
    }

    // Agregar padding en los rangos para que las burbujas no toquen los bordes
    final xSpan = max(1.0, maxX - minX);
    final ySpan = max(1.0, maxY - minY);
    final xMinPadded = max(0.0, minX - xSpan * 0.15);
    final xMaxPadded = maxX + xSpan * 0.15;
    final yMinPadded = minY - ySpan * 0.25;
    final yMaxPadded = maxY + ySpan * 0.25;

    final actualXSpan = xMaxPadded - xMinPadded;
    final actualYSpan = yMaxPadded - yMinPadded;

    // ─── 1. Dibujar Cuadrícula y Ejes ───────────────────────────
    final gridPaint = Paint()
      ..color = tokens.gridLineColor
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = tokens.axisLineColor
      ..strokeWidth = 1.2;

    // Línea base neutral Y = 0 si está dentro del rango
    if (yMinPadded <= 0 && yMaxPadded >= 0) {
      final zeroNorm = (0.0 - yMinPadded) / actualYSpan;
      final zeroY = topPadding + chartHeight * (1.0 - zeroNorm);
      final zeroPaint = Paint()
        ..color = tokens.axisLabelColor.withValues(alpha: 0.3)
        ..strokeWidth = 1.0;
      canvas.drawLine(
        Offset(leftPadding, zeroY),
        Offset(size.width - rightPadding, zeroY),
        zeroPaint,
      );
    }

    if (showAxes) {
      // 3 líneas de grid horizontales
      for (var i = 0; i <= 3; i++) {
        final frac = i / 3.0;
        final yVal = yMinPadded + actualYSpan * (1.0 - frac);
        final yPos = topPadding + chartHeight * frac;

        canvas.drawLine(
          Offset(leftPadding, yPos),
          Offset(size.width - rightPadding, yPos),
          gridPaint,
        );

        // Etiqueta eje Y
        final yLabel = '${yVal >= 0 ? '+' : ''}${yVal.toStringAsFixed(1)}%';
        _drawText(
          canvas,
          yLabel,
          Offset(leftPadding - 6, yPos),
          tokens.axisLabelColor,
          fontSize: 9,
          align: TextAlign.right,
        );
      }

      // 3 líneas de grid verticales
      for (var i = 0; i <= 3; i++) {
        final frac = i / 3.0;
        final xVal = xMinPadded + actualXSpan * frac;
        final xPos = leftPadding + chartWidth * frac;

        canvas.drawLine(
          Offset(xPos, topPadding),
          Offset(xPos, size.height - bottomPadding),
          gridPaint,
        );

        // Etiqueta eje X (Market Cap en $B)
        final xLabel = '\$${xVal.toStringAsFixed(0)}B';
        _drawText(
          canvas,
          xLabel,
          Offset(xPos, size.height - bottomPadding + 6),
          tokens.axisLabelColor,
          fontSize: 9,
          align: TextAlign.center,
        );
      }

      // Eje X e Y principales
      canvas.drawLine(
        Offset(leftPadding, topPadding),
        Offset(leftPadding, size.height - bottomPadding),
        axisPaint,
      );
      canvas.drawLine(
        Offset(leftPadding, size.height - bottomPadding),
        Offset(size.width - rightPadding, size.height - bottomPadding),
        axisPaint,
      );
    }

    // ─── 2. Dibujar Burbujas ─────────────────────────────────────
    const minRadius = 16.0;
    const maxRadius = 38.0;

    for (final item in data) {
      final label = item['label'] as String;
      final x = (item['x'] as num).toDouble();
      final y = (item['y'] as num).toDouble();
      final s = (item['size'] as num).toDouble();

      final normX = (x - xMinPadded) / actualXSpan;
      final normY = (y - yMinPadded) / actualYSpan;

      final posX = leftPadding + chartWidth * normX;
      final posY = topPadding + chartHeight * (1.0 - normY);

      final sizeNorm = (maxSize > minSize) ? (s - minSize) / (maxSize - minSize) : 0.5;
      final radius = minRadius + sizeNorm * (maxRadius - minRadius);

      final baseColor = assetColors[label] ?? (y >= 0 ? tokens.bullishColor : tokens.bearishColor);

      // Resplandor exterior (Glow)
      final glowPaint = Paint()
        ..color = baseColor.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(posX, posY), radius + 3, glowPaint);

      // Cuerpo de la burbuja con degradado radial 3D
      final bubblePaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: [
            baseColor.withValues(alpha: 0.85),
            baseColor.withValues(alpha: 0.45),
          ],
        ).createShader(Rect.fromCircle(center: Offset(posX, posY), radius: radius));
      canvas.drawCircle(Offset(posX, posY), radius, bubblePaint);

      // Borde estilizado
      final borderPaint = Paint()
        ..color = baseColor.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;
      canvas.drawCircle(Offset(posX, posY), radius, borderPaint);

      // Brillo specular blanco superior
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(posX - radius * 0.3, posY - radius * 0.3),
        radius * 0.25,
        highlightPaint,
      );

      // Texto dentro de la burbuja (Símbolo + Variación %)
      _drawText(
        canvas,
        label,
        Offset(posX, posY - 7),
        Colors.white,
        fontSize: radius > 26 ? 12 : 10,
        fontWeight: FontWeight.w800,
        align: TextAlign.center,
        shadows: const [Shadow(color: Colors.black54, blurRadius: 3)],
      );

      final changeText = '${y >= 0 ? '+' : ''}${y.toStringAsFixed(1)}%';
      _drawText(
        canvas,
        changeText,
        Offset(posX, posY + 6),
        Colors.white.withValues(alpha: 0.9),
        fontSize: radius > 26 ? 9 : 8,
        fontWeight: FontWeight.w600,
        align: TextAlign.center,
        shadows: const [Shadow(color: Colors.black54, blurRadius: 2)],
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset pos,
    Color color, {
    double fontSize = 10,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign align = TextAlign.left,
    List<Shadow>? shadows,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          shadows: shadows,
        ),
      ),
      textAlign: align,
      textDirection: TextDirection.ltr,
    )..layout();

    double dx = pos.dx;
    if (align == TextAlign.center) {
      dx -= tp.width / 2;
    } else if (align == TextAlign.right) {
      dx -= tp.width;
    }
    final dy = pos.dy - tp.height / 2;

    tp.paint(canvas, Offset(dx, dy));
  }

  @override
  bool shouldRepaint(covariant _BubbleChartPainter oldDelegate) => true;
}
