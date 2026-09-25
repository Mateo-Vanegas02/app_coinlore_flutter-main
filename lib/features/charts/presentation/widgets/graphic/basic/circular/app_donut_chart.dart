import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import 'package:app_coinlore_flutter/features/charts/domain/models/chart_point.dart';
import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico Circular / Donut (Donut Chart).
/// Construido con [IntervalMark] sobre [PolarCoord(transposed: true, dimCount: 1)]
/// usando [StackModifier] y [Proportion].
class GraphicDonutChart extends StatelessWidget {
  final List<ChartPoint> data;
  final List<Color>? customColors;
  final bool showLegend;

  const GraphicDonutChart({
    super.key,
    required this.data,
    this.customColors,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);
    final palette = customColors ??
        [
          tokens.primaryColor,
          tokens.secondaryColor,
          tokens.bullishColor,
          tokens.accentColor,
          tokens.bearishColor,
        ];

    final chartData = data.map((p) => p.toMap()).toList();

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Chart<Map<String, dynamic>>(
            data: chartData,
            variables: {
              'x': Variable(
                accessor: (Map map) => map['x'].toString(),
              ),
              'y': Variable(
                accessor: (Map map) => map['y'] as num,
              ),
            },
            transforms: [
              Proportion(variable: 'y', as: 'percent'),
            ],
            coord: PolarCoord(
              transposed: true,
              dimCount: 1,
              startRadius: 0.45,
              endRadius: 0.95,
            ),
            marks: [
              IntervalMark(
                position: Varset('percent') / Varset('x'),
                color: ColorEncode(
                  variable: 'x',
                  values: palette,
                ),
                modifiers: [StackModifier()],
              ),
            ],
            selections: {
              'tap': PointSelection(
                nearest: true,
              ),
            },
            tooltip: TooltipGuide(
              selections: {'tap'},
              backgroundColor: tokens.tooltipBackgroundColor,
              textStyle: TextStyle(color: tokens.tooltipTextColor, fontSize: 11),
              radius: const Radius.circular(8),
              elevation: 4,
              variables: ['x', 'percent'],
            ),
          ),
        ),
        if (showLegend) ...[
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(data.length, (index) {
                final item = data[index];
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
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.x.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: tokens.isDark ? Colors.white70 : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.label != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          item.label!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: tokens.axisLabelColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ],
    );
  }
}
