import 'dart:math';
import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Barras Circulares (Radial Bar Chart).
/// Dibuja arcos proporcionales concéntricos con [CustomPainter], donde cada
/// activo ocupa un anillo y la longitud del arco es proporcional a su score.
class GraphicRadialBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Color>? palette;

  const GraphicRadialBarChart({
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
        ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight > 0 ? constraints.maxHeight : 210.0;
        final width = constraints.maxWidth;
        // Limit chart diameter to available height so it never overflows vertically
        final chartSize = min(height, width * 0.52).clamp(100.0, 200.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // El gráfico radial contenido estrictamente dentro de chartSize
            SizedBox(
              width: chartSize,
              height: chartSize,
              child: CustomPaint(
                size: Size(chartSize, chartSize),
                painter: _RadialBarPainter(
                  data: data,
                  colors: colors,
                  tokens: tokens,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Leyenda
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(data.length, (i) {
                  final item = data[i];
                  final name = item['name'] as String;
                  final value = (item['value'] as num).toDouble();
                  final color = colors[i % colors.length];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: tokens.isDark ? Colors.white70 : Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${value.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RadialBarPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final List<Color> colors;
  final ChartThemeTokens tokens;

  _RadialBarPainter({
    required this.data,
    required this.colors,
    required this.tokens,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final n = data.length;

    // Espacio total para los anillos: delimitado por min(width, height)
    final availableRadius = min(size.width, size.height) / 2;
    final maxRadius = availableRadius * 0.88;
    final minRadius = availableRadius * 0.25;
    final ringThickness = ((maxRadius - minRadius) / n * 0.65).clamp(4.0, 16.0);
    final ringGap = (maxRadius - minRadius) / n;

    for (var i = 0; i < n; i++) {
      final item = data[i];
      final value = (item['value'] as num).toDouble();
      final color = colors[i % colors.length];

      // El radio decrece hacia el centro (i=0 es el más externo)
      final radius = maxRadius - i * ringGap;

      // ─── Track (círculo de fondo) ───────────────────────────────
      final trackPaint = Paint()
        ..color = tokens.isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.06)
        ..strokeWidth = ringThickness
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, radius, trackPaint);

      // ─── Arco de progreso ─────────────────────────────────────────
      final sweepAngle = (value / 100).clamp(0.0, 1.0) * 2 * pi;
      const startAngle = -pi / 2; // empezar desde las 12 en punto

      final arcPaint = Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepAngle,
          colors: [
            color.withValues(alpha: 0.75),
            color,
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius),
        )
        ..strokeWidth = ringThickness
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        arcPaint,
      );

      // ─── Punto luminoso al final del arco ─────────────────────────
      if (sweepAngle > 0.1) {
        final endAngle = startAngle + sweepAngle;
        final dotX = center.dx + radius * cos(endAngle);
        final dotY = center.dy + radius * sin(endAngle);
        final dotPaint = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(dotX, dotY), ringThickness / 2 * 0.55, dotPaint);
      }
    }

    // ─── Centro con score promedio ─────────────────────────────────
    final avgScore = data.fold<double>(
          0.0,
          (sum, d) => sum + (d['value'] as num).toDouble(),
        ) /
        data.length;

    final tp = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        children: [
          TextSpan(
            text: avgScore.toStringAsFixed(0),
            style: TextStyle(
              color: tokens.isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '\navg',
            style: TextStyle(
              color: tokens.axisLabelColor,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    )..layout(maxWidth: 60);

    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _RadialBarPainter oldDelegate) => false;
}
