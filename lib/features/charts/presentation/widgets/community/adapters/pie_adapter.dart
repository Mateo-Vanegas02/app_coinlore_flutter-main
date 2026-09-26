import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../domain/models/chart_point.dart';

class PieAdapter {
  PieAdapter._();

  static List<charts.Series<ChartPoint, String>> build({
    required List<ChartPoint> data,
    required List<Color> palette,
  }) {
    return [
      charts.Series<ChartPoint, String>(
        id: 'pie',
        data: data,
        domainFn: (p, _) => p.x.toString(),
        measureFn: (p, _) => p.y,
        labelAccessorFn: (p, _) => '${p.x}: ${p.y.toStringAsFixed(1)}%',
        colorFn: (p, i) => charts.ColorUtil.fromDartColor(
          palette[(i ?? 0) % palette.length],
        ),
      ),
    ];
  }

  static charts.ArcRendererConfig arcConfig({
    bool isDonut = false,
    bool isHalf = false,
  }) {
    return charts.ArcRendererConfig(
      arcWidth: isDonut ? 30 : 60,
      startAngle: isHalf ? 3.14159 : 0,
      arcLength: isHalf ? 3.14159 : 2 * 3.14159,
    );
  }
}
