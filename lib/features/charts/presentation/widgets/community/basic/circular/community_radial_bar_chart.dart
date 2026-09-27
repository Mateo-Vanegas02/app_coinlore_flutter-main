import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 17. Radial Bar Chart con community_charts_flutter.
/// NO SOPORTADO: la librería no tiene barras radiales concéntricas.
class CommunityRadialBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityRadialBarChart({
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
              Icons.radio_button_checked,
              size: 28,
              color: tokens.axisLabelColor,
            ),
            const SizedBox(height: 6),
            Text(
              'Radial Bar Chart no soportado\npor community_charts_flutter',
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
