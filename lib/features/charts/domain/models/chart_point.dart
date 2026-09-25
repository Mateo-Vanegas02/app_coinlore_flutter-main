/// Modelos agnósticos de datos para la capa de gráficos.
/// Totalmente desacoplados de las entidades de la API.
class ChartPoint {
  final dynamic x;
  final num y;
  final String? series;
  final String? label;
  final Map<String, dynamic>? extra;

  const ChartPoint({
    required this.x,
    required this.y,
    this.series,
    this.label,
    this.extra,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      if (series != null) 'series': series,
      if (label != null) 'label': label,
      if (extra != null) ...extra!,
    };
  }
}

/// Modelo para gráficos financieros de velas japonesas (OHLC)
class CandlestickPoint {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  const CandlestickPoint({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  bool get isBullish => close >= open;

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'timeLabel': '${time.day}/${time.month}',
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'volume': volume,
      'direction': isBullish ? 'up' : 'down',
    };
  }
}

/// Modelo para gráficos multidimensionales (Radar, Spider, Parallel Coordinates)
class MultiMetricPoint {
  final String category;
  final String metric;
  final num value;

  const MultiMetricPoint({
    required this.category,
    required this.metric,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'metric': metric,
      'value': value,
    };
  }
}
