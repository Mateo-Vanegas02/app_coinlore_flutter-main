import 'package:flutter/material.dart';

import '../../../../charts/domain/models/chart_point.dart';
import '../../theme/chart_theme_tokens.dart';
import 'community_chart_renderer.dart';

/// Gráfico que cambia de datos al pulsar un filtro y anima la transición.
class CommunityAnimatedTransitions extends StatefulWidget {
  final ChartThemeTokens tokens;
  final double height;

  const CommunityAnimatedTransitions({
    super.key,
    required this.tokens,
    this.height = 220,
  });

  @override
  State<CommunityAnimatedTransitions> createState() =>
      _CommunityAnimatedTransitionsState();
}

class _CommunityAnimatedTransitionsState
    extends State<CommunityAnimatedTransitions> {
  int _filterIndex = 0;

  final List<String> _filterLabels = const ['7 días', '30 días', '90 días'];

  /// Tres datasets distintos, cada uno con su propia serie de puntos.
  final List<List<ChartPoint>> _datasets = const [
    // 7 días
    [
      ChartPoint(x: 'Lun', y: 82000),
      ChartPoint(x: 'Mar', y: 83500),
      ChartPoint(x: 'Mié', y: 82800),
      ChartPoint(x: 'Jue', y: 84200),
      ChartPoint(x: 'Vie', y: 83900),
      ChartPoint(x: 'Sáb', y: 84800),
      ChartPoint(x: 'Dom', y: 85100),
    ],
    // 30 días
    [
      ChartPoint(x: 'Sem 1', y: 78500),
      ChartPoint(x: 'Sem 2', y: 81200),
      ChartPoint(x: 'Sem 3', y: 79800),
      ChartPoint(x: 'Sem 4', y: 85100),
    ],
    // 90 días
    [
      ChartPoint(x: 'Ene', y: 62000),
      ChartPoint(x: 'Feb', y: 69000),
      ChartPoint(x: 'Mar', y: 74000),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final currentData = _datasets[_filterIndex];

    return Column(
      children: [
        // Botones de filtro
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_filterLabels.length, (i) {
              final isSelected = _filterIndex == i;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(
                    _filterLabels[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : widget.tokens.axisLabelColor,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _filterIndex = i);
                    }
                  },
                  selectedColor: widget.tokens.primaryColor,
                  backgroundColor: widget.tokens.cardBackgroundColor,
                  showCheckmark: false,
                ),
              );
            }),
          ),
        ),
        // Gráfico animado
        Expanded(
          child: CommunityChartRenderer.build(
            type: CommunityChartType.lineSimple,
            data: currentData,
            tokens: widget.tokens,
            animate: true, // <- Esto activa la transición animada
          ),
        ),
      ],
    );
  }
}
