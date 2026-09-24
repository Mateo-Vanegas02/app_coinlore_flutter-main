class MarketPairEntity {
  final String exchangeName;
  final String base;
  final String quote;
  final double price;
  final double priceUsd;
  final double volume;
  final double volumeUsd;
  final int time;

  const MarketPairEntity({
    required this.exchangeName,
    required this.base,
    required this.quote,
    required this.price,
    required this.priceUsd,
    required this.volume,
    required this.volumeUsd,
    required this.time,
  });

  String get pairLabel => '$base/$quote';
}
