import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 20. Radar Chart con community_charts_flutter.
/// NO SOPORTADO: la librería no incluye un widget de radar.
class CommunityRadarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityRadarChart({
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
              Icons.radar,
              size: 28,
              color: tokens.axisLabelColor,
            ),
            const SizedBox(height: 6),
            Text(
              'Radar Chart no soportado\npor community_charts_flutter',
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
