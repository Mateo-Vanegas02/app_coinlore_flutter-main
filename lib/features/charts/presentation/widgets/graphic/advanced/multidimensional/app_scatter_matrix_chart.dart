import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Matriz de Correlación / Scatter Plot Matrix.
/// Muestra correlaciones cruzadas entre pares de variables financieras
/// mediante una cuadrícula con burbujas codificadas por tamaño y color.
class GraphicScatterMatrixChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const GraphicScatterMatrixChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    // Organizar datos: tokens únicos y pares únicos
    final tokens_ = data.map((d) => d['token'] as String).toSet().toList();
    final pairs = data.map((d) => d['pair'] as String).toSet().toList();

    // Build correlation map
    final Map<String, double> corrMap = {};
    for (final d in data) {
      final key = '${d['token']}_${d['pair']}';
      corrMap[key] = (d['correlation'] as num).toDouble();
    }

    final tokenColors = [
      tokens.primaryColor,
      tokens.bullishColor,
      tokens.secondaryColor,
      tokens.accentColor,
    ];

    return Column(
      children: [
        // Header con nombre de los pares (columnas)
        Row(
          children: [
            const SizedBox(width: 52),
            ...pairs.map(
              (pair) => Expanded(
                child: Text(
                  pair,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: tokens.axisLabelColor,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Filas: tokens (activos)
        Expanded(
          child: Column(
            children: List.generate(tokens_.length, (ri) {
              final token = tokens_[ri];
              final tokenColor = tokenColors[ri % tokenColors.length];
              return Expanded(
                child: Row(
                  children: [
                    // Etiqueta de la fila
                    SizedBox(
                      width: 48,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: tokenColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              token,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: tokenColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Celdas de correlación
                    ...pairs.map((pair) {
                      final corr = corrMap['${token}_$pair'];
                      return Expanded(
                        child: _CorrelationCell(
                          correlation: corr,
                          tokenColor: tokenColor,
                          tokens: tokens,
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        // Leyenda de correlación
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendDot(tokens.bearishColor, 'Baja'),
            const SizedBox(width: 16),
            _legendDot(tokens.accentColor, 'Media'),
            const SizedBox(width: 16),
            _legendDot(tokens.bullishColor, 'Alta'),
          ],
        ),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}

class _CorrelationCell extends StatelessWidget {
  final double? correlation;
  final Color tokenColor;
  final ChartThemeTokens tokens;

  const _CorrelationCell({
    required this.correlation,
    required this.tokenColor,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    if (correlation == null) {
      return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: tokens.isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    final c = correlation!;
    // Color: verde=alta correlación, naranja=media, rojo=baja
    final Color cellColor;
    if (c >= 0.7) {
      cellColor = tokens.bullishColor;
    } else if (c >= 0.5) {
      cellColor = tokens.accentColor;
    } else {
      cellColor = tokens.bearishColor;
    }

    // Tamaño de la burbuja proporcional a la correlación
    final bubbleSize = 8.0 + c * 18.0;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: tokens.isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: bubbleSize,
              height: bubbleSize,
              decoration: BoxDecoration(
                color: cellColor.withValues(alpha: 0.85),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: cellColor.withValues(alpha: 0.3),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              c.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: cellColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
