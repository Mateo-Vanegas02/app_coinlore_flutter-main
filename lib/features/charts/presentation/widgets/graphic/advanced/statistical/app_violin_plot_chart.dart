import 'dart:math';
import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Violín (Violin Plot) con CustomPainter.
/// Dibuja la forma simétrica de violín representando la función de densidad de
/// probabilidad de los retornos cripto: más ancho donde hay más concentración.
class GraphicViolinPlotChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Color? color;

  const GraphicViolinPlotChart({
    super.key,
    required this.data,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final plotColor = color ?? tokens.secondaryColor;

    if (data.isEmpty) return const SizedBox.shrink();

    final maxDensity = data.map((d) => (d['density'] as num).toDouble()).reduce(max);

    return Row(
      children: [
        // Eje Y con etiquetas de nivel
        SizedBox(
          width: 36,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final h = constraints.maxHeight;
              return Stack(
                children: List.generate(data.length, (i) {
                  final yFrac = i / (data.length - 1);
                  final yPos = h - yFrac * h;
                  final level = data[i]['level'] as String;
                  return Positioned(
                    top: yPos - 7,
                    right: 4,
                    child: Text(
                      level,
                      style: TextStyle(
                        fontSize: 9,
                        color: tokens.axisLabelColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
        // Cuerpo del violín
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _ViolinPainter(
                  data: data,
                  maxDensity: maxDensity,
                  color: plotColor,
                  tokens: tokens,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ViolinPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double maxDensity;
  final Color color;
  final ChartThemeTokens tokens;

  _ViolinPainter({
    required this.data,
    required this.maxDensity,
    required this.color,
    required this.tokens,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || maxDensity <= 0) return;

    final n = data.length;
    final centerX = size.width / 2;
    // Usamos el 42% del ancho como radio máximo del violín
    final maxHalfWidth = size.width * 0.42;

    // Puntos del contorno derecho (top → bottom)
    final List<Offset> rightPoints = [];
    final List<Offset> leftPoints = [];

    for (var i = 0; i < n; i++) {
      final d = data[i];
      final density = (d['density'] as num).toDouble();
      // Y va de 0 (arriba) a size.height (abajo)
      final y = size.height - (i / (n - 1)) * size.height;
      final halfW = (density / maxDensity) * maxHalfWidth;

      rightPoints.add(Offset(centerX + halfW, y));
      leftPoints.add(Offset(centerX - halfW, y));
    }

    // Construir path: derecha de arriba→abajo luego izquierda de abajo→arriba
    final path = Path();
    path.moveTo(rightPoints.first.dx, rightPoints.first.dy);

    // Curva derecha (Catmull-Rom → aproximada con cubicTo)
    for (var i = 1; i < rightPoints.length; i++) {
      final prev = rightPoints[i - 1];
      final curr = rightPoints[i];
      final cp1 = Offset(prev.dx, prev.dy + (curr.dy - prev.dy) * 0.5);
      final cp2 = Offset(curr.dx, curr.dy - (curr.dy - prev.dy) * 0.5);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
    }

    // Curva izquierda (reverso, de abajo → arriba)
    path.lineTo(leftPoints.last.dx, leftPoints.last.dy);
    for (var i = leftPoints.length - 2; i >= 0; i--) {
      final prev = leftPoints[i + 1];
      final curr = leftPoints[i];
      final cp1 = Offset(prev.dx, prev.dy + (curr.dy - prev.dy) * 0.5);
      final cp2 = Offset(curr.dx, curr.dy - (curr.dy - prev.dy) * 0.5);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
    }
    path.close();

    // Relleno con gradiente radial
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          color.withValues(alpha: 0.15),
          color.withValues(alpha: 0.45),
          color.withValues(alpha: 0.15),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // Contorno
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, strokePaint);

    // Eje central (columna vertebral del violín)
    final axisPaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      axisPaint,
    );

    // Punto de máxima densidad (moda) destacado
    double maxD = 0;
    Offset modePos = Offset.zero;
    for (var i = 0; i < n; i++) {
      final d = (data[i]['density'] as num).toDouble();
      if (d > maxD) {
        maxD = d;
        final y = size.height - (i / (n - 1)) * size.height;
        modePos = Offset(centerX, y);
      }
    }

    final dotPaint = Paint()..color = color;
    canvas.drawCircle(modePos, 4, dotPaint);

    final dotRingPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(modePos, 4, dotRingPaint);

    // Línea de media (mediana aproximada)
    final midY = size.height / 2;
    final medianPaint = Paint()
      ..color = tokens.bullishColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Calculamos el ancho en midY para dibujar la línea solo dentro del violín
    final midIdx = (n - 1) / 2;
    final midIdxInt = midIdx.floor();
    final frac = midIdx - midIdxInt;
    final midDensity = data[midIdxInt]['density'] as num;
    final midHalfW = (midDensity / maxDensity) * maxHalfWidth * (1 - frac) +
        (midIdxInt + 1 < n
            ? (data[midIdxInt + 1]['density'] as num) / maxDensity * maxHalfWidth * frac
            : 0);

    canvas.drawLine(
      Offset(centerX - midHalfW, midY),
      Offset(centerX + midHalfW, midY),
      medianPaint,
    );

    // Etiqueta "Media" en la línea mediana
    final tp = TextPainter(
      text: TextSpan(
        text: 'Mediana',
        style: TextStyle(
          color: tokens.bullishColor,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(centerX - tp.width / 2, midY - tp.height - 2));
  }

  @override
  bool shouldRepaint(covariant _ViolinPainter oldDelegate) => false;
}
