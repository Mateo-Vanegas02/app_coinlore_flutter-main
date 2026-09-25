import 'dart:math';
import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/domain/models/chart_point.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico Rosa de Nightingale (Nightingale Rose Chart / Polar Area Chart).
/// Cada sector angular tiene el mismo ángulo y el radio exterior es proporcional al valor.
/// Diseñado con [CustomPainter] delimitado estrictamente al área de colisión del widget.
class AppRoseChart extends StatelessWidget {
  final List<ChartPoint> data;
  final List<Color>? palette;

  const AppRoseChart({
    super.key,
    required this.data,
    this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final colors = palette ??
        [
          tokens.primaryColor,
          tokens.bullishColor,
          tokens.secondaryColor,
          tokens.accentColor,
          const Color(0xFFF59E0B),
          const Color(0xFF06B6D4),
        ];

    if (data.isEmpty) {
      return Center(
        child: Text(
          'Sin datos polares',
          style: TextStyle(color: tokens.axisLabelColor, fontSize: 12),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight > 0 ? constraints.maxHeight : 220.0;
        final width = constraints.maxWidth;
        // Diámetro contenido estrictamente
        final chartSize = min(height, width);

        return Center(
          child: SizedBox(
            width: chartSize,
            height: chartSize,
            child: CustomPaint(
              size: Size(chartSize, chartSize),
              painter: _RoseChartPainter(
                data: data,
                colors: colors,
                tokens: tokens,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RoseChartPainter extends CustomPainter {
  final List<ChartPoint> data;
  final List<Color> colors;
  final ChartThemeTokens tokens;

  _RoseChartPainter({
    required this.data,
    required this.colors,
    required this.tokens,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    // Radio máximo reservando espacio para etiquetas exteriores (24px)
    final maxRadius = (min(size.width, size.height) / 2 - 26).clamp(30.0, 95.0);
    const innerRadius = 14.0;

    final n = data.length;
    final angleStep = (2 * pi) / n;
    const gapAngle = 0.05; // radianes de separación entre pétalos

    // ─── 1. Anillos Concéntricos de Fondo (25%, 50%, 75%, 100%) ──
    final ringPaint = Paint()
      ..color = tokens.isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var r = 1; r <= 4; r++) {
      final ringR = innerRadius + (maxRadius - innerRadius) * (r / 4.0);
      canvas.drawCircle(center, ringR, ringPaint);
    }

    // ─── 2. Rayos Radiales ───────────────────────────────────────
    final rayPaint = Paint()
      ..color = tokens.isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06)
      ..strokeWidth = 1.0;

    for (var i = 0; i < n; i++) {
      final angle = -pi / 2 + i * angleStep;
      final x2 = center.dx + maxRadius * cos(angle);
      final y2 = center.dy + maxRadius * sin(angle);
      canvas.drawLine(center, Offset(x2, y2), rayPaint);
    }

    // Valor máximo para normalizar
    num maxVal = 100;
    for (final p in data) {
      if (p.y > maxVal) maxVal = p.y;
    }

    // ─── 3. Pétalos Proporcionales de la Rosa ────────────────────
    for (var i = 0; i < n; i++) {
      final p = data[i];
      final val = p.y.toDouble();
      final color = colors[i % colors.length];

      // Radio de este pétalo
      final fraction = (val / maxVal).clamp(0.1, 1.0);
      final petalRadius = innerRadius + (maxRadius - innerRadius) * fraction;

      final startAngle = -pi / 2 + i * angleStep + gapAngle / 2;
      final sweepAngle = angleStep - gapAngle;

      final path = Path();
      path.moveTo(
        center.dx + innerRadius * cos(startAngle),
        center.dy + innerRadius * sin(startAngle),
      );

      // Arco exterior del pétalo
      path.arcTo(
        Rect.fromCircle(center: center, radius: petalRadius),
        startAngle,
        sweepAngle,
        false,
      );

      // Regreso al arco interior
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle + sweepAngle,
        -sweepAngle,
        false,
      );
      path.close();

      // Relleno del pétalo con gradiente radial suave
      final fillPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.82),
            color.withValues(alpha: 0.40),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: petalRadius))
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      // Borde del pétalo
      final strokePaint = Paint()
        ..color = color.withValues(alpha: 0.95)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6;
      canvas.drawPath(path, strokePaint);

      // ─── Etiqueta Exterior (Categoría y Valor) ───────────────
      final midAngle = startAngle + sweepAngle / 2;
      final labelDist = maxRadius + 15.0;
      final labelX = center.dx + labelDist * cos(midAngle);
      final labelY = center.dy + labelDist * sin(midAngle);

      final labelName = p.x.toString();
      final shortName = labelName.length > 8 ? '${labelName.substring(0, 7)}…' : labelName;

      _drawText(
        canvas,
        '$shortName\n${val.toInt()}',
        Offset(labelX, labelY),
        tokens.isDark ? Colors.white70 : Colors.black87,
        fontSize: 8.5,
        fontWeight: FontWeight.w600,
        align: TextAlign.center,
      );
    }

    // ─── 4. Hub Central ──────────────────────────────────────────
    final hubBgPaint = Paint()
      ..color = tokens.cardBackgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, hubBgPaint);

    final hubBorderPaint = Paint()
      ..color = tokens.primaryColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, innerRadius, hubBorderPaint);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset pos,
    Color color, {
    double fontSize = 9,
    FontWeight fontWeight = FontWeight.normal,
    TextAlign align = TextAlign.center,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: 1.1,
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
  bool shouldRepaint(covariant _RoseChartPainter oldDelegate) => true;
}
