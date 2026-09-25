import 'dart:math';
import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Embudo Financiero / Conversión (Funnel Chart).
/// Dibuja trapezoides decrecientes con [CustomPainter] centrados en el canvas,
/// acompañados de porcentajes de retención y etiquetas de etapa.
class GraphicFunnelChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool isPyramid;

  const GraphicFunnelChart({
    super.key,
    required this.data,
    this.isPyramid = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    if (data.isEmpty) return const SizedBox.shrink();

    // Paleta de gradientes para cada nivel del embudo
    final stageGradients = [
      [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
      [const Color(0xFF06B6D4), const Color(0xFF0E7490)],
      [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)],
      [const Color(0xFF10B981), const Color(0xFF047857)],
    ];

    final maxVal = (data.first['value'] as num).toDouble();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: CustomPaint(
            painter: _FunnelPainter(
              data: data,
              stageGradients: stageGradients,
              maxVal: maxVal,
              isPyramid: isPyramid,
              tokens: tokens,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _FunnelPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final List<List<Color>> stageGradients;
  final double maxVal;
  final bool isPyramid;
  final ChartThemeTokens tokens;

  _FunnelPainter({
    required this.data,
    required this.stageGradients,
    required this.maxVal,
    required this.isPyramid,
    required this.tokens,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || maxVal <= 0) return;

    final n = data.length;
    const gapY = 6.0;
    const sidePadding = 16.0;
    final totalHeight = size.height - (n - 1) * gapY;
    final segmentH = totalHeight / n;
    final centerX = size.width / 2;

    // Anchura máxima y mínima del embudo
    final maxWidth = size.width - sidePadding * 2;
    const minWidthFraction = 0.28;

    for (var i = 0; i < n; i++) {
      final item = data[i];
      final val = (item['value'] as num).toDouble();
      final stage = item['stage'] as String;
      final colors = stageGradients[i % stageGradients.length];

      // Calculo de ancho superior e inferior del trapezoide
      final fraction = val / maxVal;
      final nextVal = (i + 1 < n) ? (data[i + 1]['value'] as num).toDouble() : val * minWidthFraction;
      final nextFraction = nextVal / maxVal;

      final topW = isPyramid
          ? max(maxWidth * minWidthFraction, maxWidth * (1 - fraction))
          : max(maxWidth * minWidthFraction, maxWidth * fraction);
      final bottomW = isPyramid
          ? max(maxWidth * minWidthFraction, maxWidth * (1 - nextFraction))
          : max(maxWidth * minWidthFraction, maxWidth * nextFraction);

      final topY = i * (segmentH + gapY);
      final bottomY = topY + segmentH;

      // Puntos del trapezoide
      final topLeft = Offset(centerX - topW / 2, topY);
      final topRight = Offset(centerX + topW / 2, topY);
      final bottomRight = Offset(centerX + bottomW / 2, bottomY);
      final bottomLeft = Offset(centerX - bottomW / 2, bottomY);

      final path = Path()
        ..moveTo(topLeft.dx, topLeft.dy)
        ..lineTo(topRight.dx, topRight.dy)
        ..lineTo(bottomRight.dx, bottomRight.dy)
        ..lineTo(bottomLeft.dx, bottomLeft.dy)
        ..close();

      // Gradiente lineal (top → bottom)
      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ).createShader(Rect.fromLTRB(topLeft.dx, topY, topRight.dx, bottomY))
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, fillPaint);

      // Borde sutil
      final borderPaint = Paint()
        ..color = colors.first.withValues(alpha: 0.6)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, borderPaint);

      // ─── Texto central (valor) ───────────────────────────────────
      final formattedVal = _formatNumber(val);
      final valPct = '${(val / maxVal * 100).toStringAsFixed(0)}%';
      final centerY = (topY + bottomY) / 2;

      _drawText(canvas, formattedVal, Offset(centerX, centerY - 7), Colors.white, 13, FontWeight.bold);
      _drawText(canvas, valPct, Offset(centerX, centerY + 9), Colors.white.withValues(alpha: 0.8), 10, FontWeight.w500);

      // ─── Etiqueta de etapa a la derecha ──────────────────────────
      // Sólo si la anchura es suficiente para que no se superponga
      final labelX = centerX + max(topW, bottomW) / 2 + 8;
      if (labelX + 60 <= size.width) {
        _drawText(
          canvas,
          stage.replaceAll(RegExp(r'^\d+\. '), ''),
          Offset(labelX, centerY),
          tokens.isDark ? Colors.white60 : const Color(0xFF475569),
          9,
          FontWeight.w500,
          align: TextAlign.left,
        );
      }
    }
  }

  String _formatNumber(double number) {
    if (number >= 1e6) return '${(number / 1e6).toStringAsFixed(1)}M';
    if (number >= 1e3) return '${(number / 1e3).toStringAsFixed(1)}K';
    return number.toStringAsFixed(0);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset center,
    Color color,
    double fontSize,
    FontWeight weight, {
    TextAlign align = TextAlign.center,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: weight,
          shadows: const [Shadow(color: Colors.black45, blurRadius: 3)],
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout(maxWidth: 90);

    final dx = align == TextAlign.left ? center.dx : center.dx - tp.width / 2;
    tp.paint(canvas, Offset(dx, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant _FunnelPainter oldDelegate) => false;
}
