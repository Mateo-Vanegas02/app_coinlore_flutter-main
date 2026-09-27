import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 24. Violin Plot con community_charts_flutter.
/// NO SOPORTADO: la librería no tiene un renderer de densidad simétrica.
class CommunityViolinPlotChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityViolinPlotChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.graphic_eq,
              size: 28,
              color: tokens.axisLabelColor,
            ),
            const SizedBox(height: 6),
            Text(
              'Violin Plot no soportado\npor community_charts_flutter',
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
}
