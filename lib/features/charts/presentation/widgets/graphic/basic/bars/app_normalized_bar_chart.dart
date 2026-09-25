import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Barras 100% Apiladas (Normalized Stacked Bar Chart).
/// Representa composiciones proporcionales al 100% para cada categoría analizada
/// (por ejemplo, Circulante vs Por Emitir en Minería, o Bloqueado vs Libre en Staking).
class GraphicNormalizedBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final List<Color>? palette;
  final bool showAxes;

  const GraphicNormalizedBarChart({
    super.key,
    required this.data,
    this.palette,
    this.showAxes = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    // Paleta de colores atractiva y contrastante
    final colors = palette ??
        [
          tokens.primaryColor,
          tokens.bullishColor,
          tokens.accentColor,
          tokens.secondaryColor,
          const Color(0xFFF59E0B),
          const Color(0xFFEC4899),
        ];

    // Agrupar datos por 'category'
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final item in data) {
      final cat = (item['category'] ?? 'General') as String;
      grouped.putIfAbsent(cat, () => []).add(item);
    }

    if (grouped.isEmpty) {
      return Center(
        child: Text(
          'Sin datos disponibles',
          style: TextStyle(color: tokens.axisLabelColor, fontSize: 12),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...grouped.entries.map((entry) {
                final categoryName = entry.key;
                final segments = entry.value;

                // Color index determinista por segmento
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header de la barra con nombre de categoría y chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: tokens.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              categoryName,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: tokens.isDark ? Colors.white : Colors.black87,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                        // Mini resumen de porcentajes (Wrap dentro de Flexible para evitar desbordamiento)
                        Flexible(
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 2,
                            children: segments.asMap().entries.map((segEntry) {
                              final idx = segEntry.key;
                              final seg = segEntry.value;
                              final segName = (seg['segment'] ?? seg['group'] ?? seg['type'] ?? '') as String;
                              final pct = ((seg['percent'] ?? seg['value'] ?? seg['y'] ?? 0) as num).toDouble();
                              final segColor = colors[(idx + grouped.keys.toList().indexOf(categoryName) * 2) % colors.length];

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      color: segColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$segName: ${pct.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: tokens.axisLabelColor,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Barra apilada al 100%
                    Container(
                      height: 28,
                      decoration: BoxDecoration(
                        color: tokens.isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: tokens.isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.06),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        children: segments.asMap().entries.map((segEntry) {
                          final idx = segEntry.key;
                          final seg = segEntry.value;
                          final segName = (seg['segment'] ?? seg['group'] ?? seg['type'] ?? '') as String;
                          final pct = ((seg['percent'] ?? seg['value'] ?? seg['y'] ?? 0) as num).toDouble();
                          final segColor = colors[(idx + grouped.keys.toList().indexOf(categoryName) * 2) % colors.length];

                          return Expanded(
                            flex: (pct * 10).round().clamp(1, 1000),
                            child: Tooltip(
                              message: '$segName: ${pct.toStringAsFixed(1)}%',
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      segColor.withValues(alpha: 0.85),
                                      segColor,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  border: Border(
                                    right: BorderSide(
                                      color: tokens.cardBackgroundColor,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: pct >= 12
                                    ? Text(
                                        '${pct.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black45,
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }),

              // Guía visual de escala 0% - 100%
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0%', style: TextStyle(fontSize: 9, color: tokens.axisLabelColor)),
                    Text('25%', style: TextStyle(fontSize: 9, color: tokens.axisLabelColor)),
                    Text('50%', style: TextStyle(fontSize: 9, color: tokens.axisLabelColor)),
                    Text('75%', style: TextStyle(fontSize: 9, color: tokens.axisLabelColor)),
                    Text('100%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: tokens.axisLabelColor)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
