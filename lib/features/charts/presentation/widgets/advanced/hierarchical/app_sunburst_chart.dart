import 'dart:math';
import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Explosión Solar / Anillos Jerárquicos (Sunburst Chart).
/// Dibuja anillos concéntricos con [CustomPainter] representando jerarquía
/// de sectores cripto: ring externo = categorías, centro = proporción total.
class AppSunburstChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppSunburstChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    final palette = [
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF06B6D4),
    ];

    final total = data.fold<num>(0, (sum, d) => sum + (d['value'] as num));

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight > 0 ? constraints.maxHeight : 210.0;
        final width = constraints.maxWidth;
        final chartSize = min(height, width * 0.52).clamp(100.0, 200.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Visualización del Sunburst dentro de chartSize
            SizedBox(
              width: chartSize,
              height: chartSize,
              child: CustomPaint(
                size: Size(chartSize, chartSize),
                painter: _SunburstPainter(
                  data: data,
                  palette: palette,
                  total: total,
                  tokens: tokens,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Leyenda lateral
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distribución',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: tokens.axisLabelColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(data.length, (index) {
                    final item = data[index];
                    final name = item['name'] as String;
                    final val = item['value'] as num;
                    final pct = total > 0 ? (val / total * 100).toStringAsFixed(0) : '0';
                    final color = palette[index % palette.length];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: tokens.isDark ? Colors.white70 : Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '$pct%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SunburstPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final List<Color> palette;
  final num total;
  final ChartThemeTokens tokens;

  _SunburstPainter({
    required this.data,
    required this.palette,
    required this.total,
    required this.tokens,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (total <= 0 || data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;
    final outerRadius = maxRadius * 0.90;
    final innerRadius = maxRadius * 0.54;
    final coreRadius = maxRadius * 0.32;
    const gapAngle = 0.025; // espacio en radianes entre segmentos

    double startAngle = -pi / 2;

    // ─── Anillo exterior (sectores) ───────────────────────────────
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final val = (item['value'] as num).toDouble();
      final sweep = (val / total.toDouble()) * 2 * pi - gapAngle;
      if (sweep <= 0) {
        startAngle += sweep + gapAngle;
        continue;
      }
      final color = palette[i % palette.length];

      // Sector fill con gradiente radial
      final paint = Paint()
        ..shader = RadialGradient(
          center: Alignment.center,
          colors: [
            color.withValues(alpha: 0.6),
            color,
          ],
          stops: const [0.0, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(
          center.dx + innerRadius * cos(startAngle + gapAngle / 2),
          center.dy + innerRadius * sin(startAngle + gapAngle / 2),
        );

      // Arco exterior
      path.arcTo(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle + gapAngle / 2,
        sweep,
        false,
      );
      // Arco interior (reverso)
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle + gapAngle / 2 + sweep,
        -sweep,
        false,
      );
      path.close();
      canvas.drawPath(path, paint);

      // Borde sutil del segmento
      final borderPaint = Paint()
        ..color = color.withValues(alpha: 0.9)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, borderPaint);

      // Etiqueta en el segmento (sólo si el sector es suficientemente grande)
      if (sweep > 0.35) {
        final labelAngle = startAngle + gapAngle / 2 + sweep / 2;
        final labelRadius = (innerRadius + outerRadius) / 2;
        final labelOffset = Offset(
          center.dx + labelRadius * cos(labelAngle),
          center.dy + labelRadius * sin(labelAngle),
        );
        final name = (item['name'] as String).split(' ').first;
        final pct = '${(val / total * 100).toStringAsFixed(0)}%';

        _drawLabel(canvas, name, labelOffset, Colors.white, 10, FontWeight.bold);
        _drawLabel(
          canvas,
          pct,
          Offset(labelOffset.dx, labelOffset.dy + 13),
          Colors.white.withValues(alpha: 0.85),
          9,
          FontWeight.w500,
        );
      }

      startAngle += sweep + gapAngle;
    }

    // ─── Anillo interior (core de proporción) ─────────────────────
    final coreFill = Paint()
      ..shader = RadialGradient(
        colors: [
          tokens.primaryColor.withValues(alpha: 0.25),
          tokens.primaryColor.withValues(alpha: 0.08),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: coreRadius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, coreRadius, coreFill);

    final coreBorder = Paint()
      ..color = tokens.primaryColor.withValues(alpha: 0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, coreRadius, coreBorder);

    // ─── Texto central ─────────────────────────────────────────────
    _drawLabel(
      canvas,
      'CRIPTO',
      Offset(center.dx, center.dy - 8),
      tokens.primaryColor,
      9,
      FontWeight.w600,
    );
    _drawLabel(
      canvas,
      '100%',
      Offset(center.dx, center.dy + 7),
      tokens.isDark ? Colors.white : Colors.black87,
      12,
      FontWeight.bold,
    );
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset position,
    Color color,
    double fontSize,
    FontWeight weight,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: weight,
          shadows: const [
            Shadow(color: Colors.black54, blurRadius: 4),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(position.dx - tp.width / 2, position.dy - tp.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _SunburstPainter oldDelegate) => false;
}
