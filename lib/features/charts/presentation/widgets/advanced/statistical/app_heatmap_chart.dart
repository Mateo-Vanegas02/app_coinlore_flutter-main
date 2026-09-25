import 'package:flutter/material.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 21. Heatmap / Matriz de Calor (Custom widget - Syncfusion no tiene heatmap nativo)
class AppHeatmapChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppHeatmapChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final xs = data.map((d) => d['x'] as String).toSet().toList();
    final ys = data.map((d) => d['y'] as String).toSet().toList();
    final values = data.map((d) => (d['value'] as num).toDouble()).toList();
    final maxVal = values.map((v) => v.abs()).fold(0.0, (a, b) => a > b ? a : b);

    // Mapa de acceso rápido O(1) evitando problemas de tipado con orElse
    final lookup = <String, double>{
      for (final d in data)
        '${d['x']}_${d['y']}': (d['value'] as num).toDouble(),
    };

    Color getCellColor(double val) {
      if (val > 0) return tokens.bullishColor.withValues(alpha: (val / maxVal).clamp(0.1, 0.9));
      if (val < 0) return tokens.bearishColor.withValues(alpha: (val.abs() / maxVal).clamp(0.1, 0.9));
      return tokens.gridLineColor;
    }

    return Column(
      children: [
        // Header row
        Row(
          children: [
            const SizedBox(width: 72),
            ...xs.map((x) => Expanded(
                  child: Center(
                    child: Text(
                      x,
                      style: TextStyle(
                        color: tokens.axisLabelColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
          ],
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ys.map((y) {
              return Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 72,
                      child: Text(
                        y,
                        style: TextStyle(color: tokens.axisLabelColor, fontSize: 9),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...xs.map((x) {
                      final val = lookup['${x}_$y'] ?? 0.0;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: getCellColor(val),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                '${val > 0 ? '+' : ''}${val.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
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
      ],
    );
  }
}
