import 'dart:math';
import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Radar / Telaraña (Radar / Spider Chart).
/// Dibuja un polígono de rendimiento multicriterio sobre ejes radiales equiangulares,
/// contenido estrictamente dentro de su caja de límites.
class AppRadarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Color? color;

  const AppRadarChart({
    super.key,
    required this.data,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final radarColor = color ?? tokens.primaryColor;

    if (data.isEmpty) {
      return Center(
        child: Text(
          'Sin datos de radar',
          style: TextStyle(color: tokens.axisLabelColor, fontSize: 12),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight > 0 ? constraints.maxHeight : 220.0;
        final width = constraints.maxWidth;
        final chartSize = min(height, width);

        return Center(
          child: SizedBox(
            width: chartSize,
            height: chartSize,
            child: CustomPaint(
              size: Size(chartSize, chartSize),
              painter: _RadarChartPainter(
                data: data,
                color: radarColor,
                tokens: tokens,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final Color color;
  final ChartThemeTokens tokens;

  _RadarChartPainter({
    required this.data,
    required this.color,
    required this.tokens,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    // Espacio reservado para etiquetas exteriores
    final maxRadius = (min(size.width, size.height) / 2 - 28).clamp(30.0, 90.0);
    final n = data.length;
    final angleStep = (2 * pi) / n;

    // ─── 1. Polígonos Concéntricos de Fondo (25%, 50%, 75%, 100%)
    final gridPaint = Paint()
      ..color = tokens.isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var r = 1; r <= 4; r++) {
      final ringRadius = maxRadius * (r / 4.0);
      final ringPath = Path();
      for (var i = 0; i < n; i++) {
        final angle = -pi / 2 + i * angleStep;
        final x = center.dx + ringRadius * cos(angle);
        final y = center.dy + ringRadius * sin(angle);
        if (i == 0) {
          ringPath.moveTo(x, y);
        } else {
          ringPath.lineTo(x, y);
        }
      }
      ringPath.close();
      canvas.drawPath(ringPath, gridPaint);
    }

    // ─── 2. Rayos Radiales desde el Centro ───────────────────────
    final rayPaint = Paint()
      ..color = tokens.isDark
          ? Colors.white.withValues(alpha: 0.09)
          : Colors.black.withValues(alpha: 0.07)
      ..strokeWidth = 1.0;

    for (var i = 0; i < n; i++) {
      final angle = -pi / 2 + i * angleStep;
      final x = center.dx + maxRadius * cos(angle);
      final y = center.dy + maxRadius * sin(angle);
      canvas.drawLine(center, Offset(x, y), rayPaint);
    }

    // ─── 3. Polígono de Datos del Radar ──────────────────────────
    final dataPath = Path();
    final List<Offset> points = [];

    for (var i = 0; i < n; i++) {
      final item = data[i];
      final val = (item['value'] as num).toDouble().clamp(0.0, 100.0);
      final frac = val / 100.0;
      final radius = maxRadius * frac;
      final angle = -pi / 2 + i * angleStep;

      final p = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      points.add(p);

      if (i == 0) {
        dataPath.moveTo(p.dx, p.dy);
      } else {
        dataPath.lineTo(p.dx, p.dy);
      }
    }
    dataPath.close();

    // Relleno sombreado con gradiente radial
    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.40),
          color.withValues(alpha: 0.15),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;
    canvas.drawPath(dataPath, fillPaint);

    // Contorno del polígono
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(dataPath, strokePaint);

    // Puntos (vértices) del polígono
    for (final p in points) {
      final dotBg = Paint()..color = Colors.white;
      final dotRing = Paint()..color = color;
      canvas.drawCircle(p, 4.0, dotRing);
      canvas.drawCircle(p, 2.2, dotBg);
    }

    // ─── 4. Etiquetas Exteriores de los Ejes ─────────────────────
    for (var i = 0; i < n; i++) {
      final item = data[i];
      final metric = (item['metric'] ?? '').toString();
      final val = (item['value'] as num).toInt();
      final angle = -pi / 2 + i * angleStep;

      final labelDist = maxRadius + 14.0;
      final lx = center.dx + labelDist * cos(angle);
      final ly = center.dy + labelDist * sin(angle);

      _drawText(
        canvas,
        '$metric\n$val',
        Offset(lx, ly),
        tokens.isDark ? Colors.white70 : Colors.black87,
        fontSize: 9,
        fontWeight: FontWeight.w600,
        align: TextAlign.center,
      );
    }
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
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) => true;
}
