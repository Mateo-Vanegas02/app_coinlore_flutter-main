import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 28. Parallel Coordinates con community_charts_flutter.
/// NO SOPORTADO: la librería no tiene un widget de ejes paralelos.
class CommunityParallelCoordChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityParallelCoordChart({
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
              Icons.linear_scale_outlined,
              size: 28,
              color: tokens.axisLabelColor,
            ),
            const SizedBox(height: 6),
            Text(
              'Parallel Coordinates no soportado\npor community_charts_flutter',
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
