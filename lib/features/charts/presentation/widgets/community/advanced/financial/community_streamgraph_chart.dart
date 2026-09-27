import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 32. Streamgraph con community_charts_flutter.
/// NO SOPORTADO: la librería no tiene un renderer de flujo simétrico.
class CommunityStreamgraphChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunityStreamgraphChart({
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
              Icons.waves_outlined,
              size: 28,
              color: tokens.axisLabelColor,
            ),
            const SizedBox(height: 6),
            Text(
              'Streamgraph no soportado\npor community_charts_flutter\n\nDisponible en Syncfusion y Graphic',
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
