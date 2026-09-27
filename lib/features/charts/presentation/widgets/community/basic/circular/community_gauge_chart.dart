import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 15. Gauge Chart con community_charts_flutter.
/// community_charts_flutter no tiene gauge nativo, lo aproximamos con
/// un PieChart semicircular (score vs resto).
/// En Web muestra aviso por el bug de ArcRendererElement.
class CommunityGaugeChart extends StatelessWidget {
  final double score; // 0..100

  const CommunityGaugeChart({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    if (kIsWeb) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.speed_outlined,
                size: 28,
                color: tokens.axisLabelColor,
              ),
              const SizedBox(height: 6),
              Text(
                'Gauge no disponible en Web\n(bug de community_charts_flutter)',
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

    final data = [
      _GaugeDatum('Score', score),
      _GaugeDatum('Resto', 100 - score),
    ];

    return charts.PieChart(
      [
        charts.Series<_GaugeDatum, String>(
          id: 'gauge',
          data: data,
          domainFn: (d, _) => d.label,
          measureFn: (d, _) => d.value,
          labelAccessorFn: (d, _) =>
              d.label == 'Score' ? '${d.value.toStringAsFixed(1)}' : '',
          colorFn: (d, _) => charts.ColorUtil.fromDartColor(
            d.label == 'Score' ? tokens.bullishColor : tokens.gridLineColor,
          ),
        ),
      ],
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 25,
      ),
    );
  }
}

class _GaugeDatum {
  final String label;
  final double value;
  _GaugeDatum(this.label, this.value);
}
