import 'package:flutter/material.dart';
import '../../../theme/chart_theme_tokens.dart';

/// 25. Treemap / Mosaic Chart (Custom widget)
class AppTreemapChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const AppTreemapChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    final sorted = List<Map<String, dynamic>>.from(data)
      ..sort((a, b) => (b['value'] as num).compareTo(a['value'] as num));
    final totalValue = sorted.fold<double>(0, (sum, d) => sum + (d['value'] as num).toDouble());

    Color getTileColor(Map<String, dynamic> d) {
      final change = (d['change'] as num).toDouble();
      if (change > 0) return tokens.bullishColor.withValues(alpha: (change / 5).clamp(0.2, 0.7));
      if (change < 0) return tokens.bearishColor.withValues(alpha: (change.abs() / 5).clamp(0.2, 0.7));
      return tokens.gridLineColor;
    }

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      final totalArea = width * height;
      final tiles = _buildTiles(sorted, totalValue, totalArea, width, height);

      return Stack(
        children: tiles.map((tile) {
          final d = tile['data'] as Map<String, dynamic>;
          return Positioned(
            left: tile['x'] as double,
            top: tile['y'] as double,
            width: tile['w'] as double,
            height: tile['h'] as double,
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: Container(
                decoration: BoxDecoration(
                  color: getTileColor(d),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        d['symbol'] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        '${(d['change'] as num) > 0 ? '+' : ''}${(d['change'] as num).toStringAsFixed(1)}%',
                        style: const TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  List<Map<String, dynamic>> _buildTiles(
    List<Map<String, dynamic>> items,
    double totalValue,
    double totalArea,
    double width,
    double height,
  ) {
    final tiles = <Map<String, dynamic>>[];
    double offsetX = 0, offsetY = 0, remainWidth = width, remainHeight = height;

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final ratio = (item['value'] as num).toDouble() / totalValue;
      final area = ratio * totalArea;

      double tileW, tileH;
      if (remainWidth >= remainHeight) {
        tileH = remainHeight;
        tileW = area / tileH;
      } else {
        tileW = remainWidth;
        tileH = area / tileW;
      }

      tiles.add({'data': item, 'x': offsetX, 'y': offsetY, 'w': tileW, 'h': tileH});

      if (remainWidth >= remainHeight) {
        offsetX += tileW;
        remainWidth -= tileW;
      } else {
        offsetY += tileH;
        remainHeight -= tileH;
      }
    }
    return tiles;
  }
}
