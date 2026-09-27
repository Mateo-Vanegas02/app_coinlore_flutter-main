import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../../../domain/models/chart_point.dart';
import '../../../../theme/chart_theme_tokens.dart';

/// 11 & 12. Pie Chart y Donut Chart con community_charts_flutter.
/// Réplica de `AppPieChart` y `AppDonutChart` (Syncfusion).
class CommunityPieChart extends StatelessWidget {
  final List<ChartPoint> data;
  final bool isDonut;

  const CommunityPieChart({
    super.key,
    required this.data,
    this.isDonut = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    // Workaround: community_charts_flutter 1.0.4 tiene un bug de tipos
    // con ArcRendererElement en Flutter Web. Mostramos aviso.
    if (kIsWeb) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDonut ? Icons.donut_large : Icons.pie_chart_outline,
                size: 28,
                color: tokens.axisLabelColor,
              ),
              const SizedBox(height: 6),
              Text(
                'Gráfico circular no disponible en Web\n(bug de community_charts_flutter)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: tokens.axisLabelColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final palette = [
      tokens.primaryColor,
      tokens.secondaryColor,
      tokens.accentColor,
      tokens.bullishColor,
      tokens.bearishColor,
    ];

    return charts.PieChart(
      [
        charts.Series<ChartPoint, String>(
          id: 'pie',
          data: data,
          domainFn: (p, _) => p.x.toString(),
          measureFn: (p, _) => p.y,
          labelAccessorFn: (p, _) => '${p.x}: ${p.y.toStringAsFixed(1)}%',
          colorFn: (_, i) => charts.ColorUtil.fromDartColor(
            palette[(i ?? 0) % palette.length],
          ),
        ),
      ],
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: isDonut ? 30 : 60,
      ),
    );
  }
}
