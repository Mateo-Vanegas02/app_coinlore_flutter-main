class OhlcCandleData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  const OhlcCandleData({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  bool get isBullish => close >= open;
}
