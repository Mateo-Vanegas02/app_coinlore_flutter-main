import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Histograma de Frecuencia (Histogram Chart).
/// Representa la distribución estadística continua de retornos o transacciones
/// en intervalos contiguos (bins) sin espacios entre barras.
class AppHistogramChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final Color? color;
  final bool showAxes;

  const AppHistogramChart({
    super.key,
    required this.data,
    this.color,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final barColor = color ?? tokens.primaryColor;

    if (data.isEmpty) {
      return Center(
        child: Text(
          'Sin datos de histograma',
          style: TextStyle(color: tokens.axisLabelColor, fontSize: 12),
        ),
      );
    }

    num maxFreq = 1;
    for (final item in data) {
      final f = item['frequency'] as num;
      if (f > maxFreq) maxFreq = f;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalH = constraints.maxHeight > 0 ? constraints.maxHeight : 200.0;
        final barAreaHeight = (totalH - 46.0).clamp(30.0, 300.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            children: [
              // Área de barras del histograma
              SizedBox(
                height: barAreaHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: data.map((item) {
                    final freq = (item['frequency'] as num).toDouble();
                    final heightFactor = (freq / maxFreq).clamp(0.06, 1.0);
                    final barHeight = (barAreaHeight - 22.0) * heightFactor;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Etiqueta de frecuencia sobre la barra
                            Text(
                              freq.toInt().toString(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: tokens.isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Barra con altura calculada directamente
                            Container(
                              height: barHeight,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    barColor,
                                    barColor.withValues(alpha: 0.65),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(5),
                                ),
                                border: Border.all(
                                  color: barColor.withValues(alpha: 0.9),
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Línea de eje X continua
              Container(
                height: 1.5,
                color: tokens.axisLineColor,
              ),
              const SizedBox(height: 6),

              // Etiquetas de los bins en el eje X
              Row(
                children: data.map((item) {
                  final bin = (item['bin'] ?? '') as String;
                  return Expanded(
                    child: Text(
                      bin,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: tokens.axisLabelColor,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
