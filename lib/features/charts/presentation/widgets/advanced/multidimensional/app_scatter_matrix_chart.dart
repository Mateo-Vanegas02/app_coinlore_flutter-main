import 'package:flutter/material.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 29. Scatter Plot Matrix (Matriz de Dispersión / Correlaciones)
class AppScatterMatrixChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppScatterMatrixChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final tokensList = data.map((d) => d['token'] as String).toSet().toList();
    final pairsList = data.map((d) => d['pair'] as String).toSet().toList();

    // Mapa de acceso rápido O(1) evitando problemas de tipado con orElse
    final lookup = <String, double>{
      for (final d in data)
        '${d['token']}_${d['pair']}': (d['correlation'] as num).toDouble(),
    };

    Color getBubbleColor(double corr) {
      if (corr >= 0.7) {
        return tokens.bullishColor.withValues(alpha: 0.85);
      } else if (corr >= 0.5) {
        return tokens.primaryColor.withValues(alpha: 0.75);
      } else {
        return tokens.secondaryColor.withValues(alpha: 0.6);
      }
    }

    return Column(
      children: [
        // Cabecera de Pares
        Row(
          children: [
            const SizedBox(width: 56),
            ...pairsList.map((pair) => Expanded(
                  child: Center(
                    child: Text(
                      pair,
                      style: TextStyle(
                        color: tokens.axisLabelColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )),
          ],
        ),
        const SizedBox(height: 6),
        // Matriz de Tokens x Pares
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: tokensList.map((tok) {
              return Expanded(
                child: Row(
                  children: [
                    // Etiqueta del Token
                    SizedBox(
                      width: 56,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: tokens.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          tok,
                          style: TextStyle(
                            color: tokens.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Celdas con burbuja proporcional a la correlación
                    ...pairsList.map((pair) {
                      final corr = lookup['${tok}_$pair'] ?? 0.0;
                      final bubbleSize = 22.0 + (corr * 26.0); // Tamaño dinámico entre 22 y 48

                      return Expanded(
                        child: Center(
                          child: Container(
                            width: bubbleSize,
                            height: bubbleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: getBubbleColor(corr),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: getBubbleColor(corr).withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                corr.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 6),
        // Leyenda
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem(tokens.secondaryColor, 'Baja (<0.5)', tokens),
            const SizedBox(width: 16),
            _legendItem(tokens.primaryColor, 'Media (0.5-0.7)', tokens),
            const SizedBox(width: 16),
            _legendItem(tokens.bullishColor, 'Alta (>0.7)', tokens),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String text, ChartThemeTokens tokens) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: tokens.axisLabelColor, fontSize: 10),
        ),
      ],
    );
  }
}
