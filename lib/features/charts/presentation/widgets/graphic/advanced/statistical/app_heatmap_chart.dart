import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Mapa de Calor / Matriz de Retornos (Heatmap Chart).
/// Representa rendimientos o volatilidad mediante una cuadrícula de celdas
/// coloreadas con gradiente semántico según su valor positivo o negativo.
class GraphicHeatmapChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final bool showAxes;

  const GraphicHeatmapChart({
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
          'Sin datos para el mapa de calor',
          style: TextStyle(color: tokens.axisLabelColor, fontSize: 12),
        ),
      );
    }

    // Extraer columnas únicas (X: Días) y filas únicas (Y: Horarios)
    final xLabels = <String>[];
    final yLabels = <String>[];
    final Map<String, double> matrix = {};

    for (final item in data) {
      final x = (item['x'] ?? '').toString();
      final y = (item['y'] ?? '').toString();
      final val = (item['value'] as num).toDouble();

      if (!xLabels.contains(x)) xLabels.add(x);
      if (!yLabels.contains(y)) yLabels.add(y);
      matrix['${x}_$y'] = val;
    }

    // Encontrar valor absoluto máximo para normalizar la escala de color
    double maxAbsVal = 0.1;
    for (final val in matrix.values) {
      if (val.abs() > maxAbsVal) maxAbsVal = val.abs();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // Header con etiquetas de columnas (X)
            Row(
              children: [
                const SizedBox(width: 80), // espacio para etiquetas de fila
                ...xLabels.map(
                  (x) => Expanded(
                    child: Center(
                      child: Text(
                        x,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: tokens.isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Filas de la cuadrícula
            Expanded(
              child: Column(
                children: yLabels.map((y) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          // Etiqueta de la fila (Y)
                          SizedBox(
                            width: 80,
                            child: Text(
                              y,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: tokens.axisLabelColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Celdas de calor para esta fila
                          ...xLabels.map((x) {
                            final val = matrix['${x}_$y'] ?? 0.0;
                            final isPositive = val >= 0;
                            final intensity = (val.abs() / maxAbsVal).clamp(0.15, 1.0);

                            final baseColor = isPositive ? tokens.bullishColor : tokens.bearishColor;
                            final cellColor = baseColor.withValues(alpha: 0.18 + intensity * 0.72);

                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: cellColor,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: baseColor.withValues(alpha: 0.4 + intensity * 0.4),
                                    width: 1.0,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${val >= 0 ? '+' : ''}${val.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: intensity > 0.45
                                        ? Colors.white
                                        : (tokens.isDark ? Colors.white70 : Colors.black87),
                                    shadows: intensity > 0.45
                                        ? [
                                            const Shadow(
                                              color: Colors.black45,
                                              blurRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 6),

            // Barra de escala de color inferior
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '-${maxAbsVal.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 9, color: tokens.bearishColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 120,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(
                        colors: [
                          tokens.bearishColor,
                          tokens.cardBackgroundColor,
                          tokens.bullishColor,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+${maxAbsVal.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 9, color: tokens.bullishColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
