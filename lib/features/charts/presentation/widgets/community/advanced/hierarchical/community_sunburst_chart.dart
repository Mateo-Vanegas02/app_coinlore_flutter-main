import 'package:flutter/material.dart';

import '../../../../theme/chart_theme_tokens.dart';

/// 26. Sunburst con community_charts_flutter.
/// NO SOPORTADO: la librería no tiene anillos jerárquicos concéntricos.
class CommunitySunburstChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CommunitySunburstChart({
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
              Icons.donut_large_outlined,
              size: 28,
              color: tokens.axisLabelColor,
            ),
            const SizedBox(height: 6),
            Text(
              'Sunburst no soportado\npor community_charts_flutter',
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
