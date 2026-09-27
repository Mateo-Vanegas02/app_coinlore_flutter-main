import 'package:flutter/material.dart';

import '../../../../../domain/models/chart_point.dart';
import '../../../../theme/chart_theme_tokens.dart';

/// 16. Rose Chart (Nightingale) con community_charts_flutter.
/// NO SOPORTADO: la librería no tiene un widget de rose polar.
/// Mostramos un fallback visual.
class CommunityRoseChart extends StatelessWidget {
  final List<ChartPoint> data;

  const CommunityRoseChart({
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
              Icons.brightness_7_outlined,
              size: 28,
              color: tokens.axisLabelColor,
            ),
            const SizedBox(height: 6),
            Text(
              'Rose Chart no soportado\npor community_charts_flutter',
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
