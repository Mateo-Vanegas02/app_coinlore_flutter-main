import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 29. Scatter Matrix con community_charts_flutter.
/// NO SOPORTADO: la librería no tiene una cuadrícula de scatter cruzados.
class CommunityScatterMatrixChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityScatterMatrixChart({
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
              Icons.grid_4x4,
              size: 28,
              color: tokens.axisLabelColor,
            ),
            const SizedBox(height: 6),
            Text(
              'Scatter Matrix no soportado\npor community_charts_flutter',
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
