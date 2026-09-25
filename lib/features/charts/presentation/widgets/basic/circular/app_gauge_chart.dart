import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Semicírculo / Velocímetro (Gauge Chart).
/// Representa índices de sentimiento (Miedo / Codicia o RSI) en un arco de 180°
/// usando [PolarCoord] con rango angular de `[-pi, 0]`.
class AppGaugeChart extends StatelessWidget {
  final double score; // 0 a 100
  final String label;

  const AppGaugeChart({
    super.key,
    required this.score,
    this.label = 'Sentimiento de Mercado',
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final clampedScore = score.clamp(0.0, 100.0);
    final isGreed = clampedScore >= 50;
    final accentColor = isGreed ? tokens.bullishColor : tokens.bearishColor;

    final data = [
      {'segment': 'Valor', 'value': clampedScore},
      {'segment': 'Restante', 'value': 100.0 - clampedScore},
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Chart<Map<String, dynamic>>(
                data: data,
                variables: {
                  'segment': Variable(accessor: (Map m) => m['segment'] as String),
                  'value': Variable(accessor: (Map m) => m['value'] as num),
                },
                transforms: [
                  Proportion(variable: 'value', as: 'percent'),
                ],
                coord: PolarCoord(
                  transposed: true,
                  dimCount: 1,
                  startRadius: 0.65,
                  endRadius: 0.98,
                  startAngle: -math.pi,
                  endAngle: 0,
                ),
                marks: [
                  IntervalMark(
                    position: Varset('percent') / Varset('segment'),
                    color: ColorEncode(
                      variable: 'segment',
                      values: [
                        accentColor,
                        tokens.isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                      ],
                    ),
                    modifiers: [StackModifier()],
                  ),
                ],
              ),
              Positioned(
                bottom: 8,
                child: Column(
                  children: [
                    Text(
                      '${clampedScore.toInt()}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    Text(
                      isGreed ? 'Codicia (Bullish)' : 'Miedo (Bearish)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: tokens.axisLabelColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
