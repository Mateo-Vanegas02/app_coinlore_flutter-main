import 'dart:math';
import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/domain/models/chart_point.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Área con Línea Base / Umbral (Baseline / Difference Area Chart).
/// Sombreado en verde (bullish) cuando el precio o rendimiento supera el umbral base,
/// y en rojo (bearish) cuando cae por debajo de la referencia.
class GraphicBaselineAreaChart extends StatelessWidget {
  final List<ChartPoint> data;
  final double baseline;

  const GraphicBaselineAreaChart({
    super.key,
    required this.data,
    this.baseline = 84000.0,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    if (data.isEmpty) {
      return Center(
        child: Text(
          'Sin datos disponibles',
          style: TextStyle(color: tokens.axisLabelColor, fontSize: 12),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _BaselinePainter(
            data: data,
            baseline: baseline,
            tokens: tokens,
          ),
        );
      },
    );
  }
}

class _BaselinePainter extends CustomPainter {
  final List<ChartPoint> data;
  final double baseline;
  final ChartThemeTokens tokens;

  _BaselinePainter({
    required this.data,
    required this.baseline,
    required this.tokens,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const leftPadding = 42.0;
    const rightPadding = 16.0;
    const topPadding = 16.0;
    const bottomPadding = 24.0;

    final chartW = size.width - leftPadding - rightPadding;
    final chartH = size.height - topPadding - bottomPadding;
    if (chartW <= 0 || chartH <= 0) return;

    // Calcular min y max de Y
    double minY = baseline;
    double maxY = baseline;
    for (final p in data) {
      if (p.y < minY) minY = p.y.toDouble();
      if (p.y > maxY) maxY = p.y.toDouble();
    }
    final span = max(100.0, maxY - minY);
    final yMinPadded = minY - span * 0.15;
    final yMaxPadded = maxY + span * 0.15;
    final actualSpan = yMaxPadded - yMinPadded;

    double toX(int index) => leftPadding + (index / (data.length - 1)) * chartW;
    double toY(double val) => topPadding + chartH * (1.0 - (val - yMinPadded) / actualSpan);

    final baseY = toY(baseline);

    // ─── 1. Línea Base de Referencia ──────────────────────────────
    final baselinePaint = Paint()
      ..color = tokens.axisLabelColor.withValues(alpha: 0.4)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(leftPadding, baseY), Offset(size.width - rightPadding, baseY), baselinePaint);

    // Etiqueta de la línea base
    final baseLabel = '\$${(baseline / 1000).toStringAsFixed(1)}k Base';
    final tp = TextPainter(
      text: TextSpan(
        text: baseLabel,
        style: TextStyle(
          color: tokens.axisLabelColor,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(leftPadding + 4, baseY - tp.height - 2));

    // ─── 2. Áreas por encima (verde) y por debajo (rojo) ──────────
    final List<Offset> points = [];
    for (var i = 0; i < data.length; i++) {
      points.add(Offset(toX(i), toY(data[i].y.toDouble())));
    }

    // Clip por encima de baseY para área verde
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(leftPadding, topPadding, size.width - rightPadding, baseY));

    final greenPath = Path()..moveTo(points.first.dx, baseY);
    for (final p in points) {
      greenPath.lineTo(p.dx, p.dy);
    }
    greenPath.lineTo(points.last.dx, baseY);
    greenPath.close();

    final greenPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          tokens.bullishColor.withValues(alpha: 0.35),
          tokens.bullishColor.withValues(alpha: 0.05),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(leftPadding, topPadding, size.width - rightPadding, baseY))
      ..style = PaintingStyle.fill;
    canvas.drawPath(greenPath, greenPaint);
    canvas.restore();

    // Clip por debajo de baseY para área roja
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(leftPadding, baseY, size.width - rightPadding, size.height - bottomPadding));

    final redPath = Path()..moveTo(points.first.dx, baseY);
    for (final p in points) {
      redPath.lineTo(p.dx, p.dy);
    }
    redPath.lineTo(points.last.dx, baseY);
    redPath.close();

    final redPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          tokens.bearishColor.withValues(alpha: 0.05),
          tokens.bearishColor.withValues(alpha: 0.35),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(leftPadding, baseY, size.width - rightPadding, size.height - bottomPadding))
      ..style = PaintingStyle.fill;
    canvas.drawPath(redPath, redPaint);
    canvas.restore();

    // ─── 3. Línea del Precio ─────────────────────────────────────
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final linePaint = Paint()
      ..color = tokens.primaryColor
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;
    canvas.drawPath(linePath, linePaint);

    // Puntos sobre la línea
    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      final val = data[i].y;
      final isBull = val >= baseline;
      final ptColor = isBull ? tokens.bullishColor : tokens.bearishColor;

      canvas.drawCircle(p, 4.0, (Paint()..color = ptColor));
      canvas.drawCircle(p, 2.0, (Paint()..color = Colors.white));
    }

    // ─── 4. Eje X y Etiquetas de Tiempo ───────────────────────────
    for (var i = 0; i < data.length; i++) {
      final label = data[i].x.toString();
      final xtp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: tokens.axisLabelColor, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      xtp.paint(canvas, Offset(toX(i) - xtp.width / 2, size.height - bottomPadding + 6));
    }
  }

  @override
  bool shouldRepaint(covariant _BaselinePainter oldDelegate) => true;
}
