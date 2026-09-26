import 'package:community_charts_flutter/community_charts_flutter.dart'
    as charts;
import 'package:flutter/material.dart';

import '../../../../domain/models/chart_point.dart';

/// Adapta `CandlestickPoint` a una serie de scatter.
/// El renderer personalizado (Bloque 3) dibuja la vela.
class CandlestickAdapter {
  CandlestickAdapter._();

  static List<charts.Series<CandlestickPoint, DateTime>> build({
    required List<CandlestickPoint> data,
    required Color bullishColor,
    required Color bearishColor,
  }) {
    return [
      charts.Series<CandlestickPoint, DateTime>(
        id: 'candlestick',
        data: data,
        domainFn: (c, _) => c.time,
        measureFn: (c, _) => c.close,
        colorFn: (c, _) => charts.ColorUtil.fromDartColor(
          c.isBullish ? bullishColor : bearishColor,
        ),
        fillColorFn: (c, _) => charts.ColorUtil.fromDartColor(
          c.isBullish ? bullishColor : bearishColor,
        ),
      ),
    ];
  }
}
