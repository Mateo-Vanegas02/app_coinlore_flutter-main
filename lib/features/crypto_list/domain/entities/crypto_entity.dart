class CryptoEntity {
  final String id;
  final int rank;
  final String symbol;
  final String name;
  final String nameid;
  final double priceUsd;
  final double percentChange24h;
  final double percentChange1h;
  final double percentChange7d;
  final double marketCapUsd;
  final double volume24;
  final String? logoUrl;

  CryptoEntity({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.nameid,
    required this.priceUsd,
    required this.percentChange24h,
    required this.percentChange1h,
    required this.percentChange7d,
    required this.marketCapUsd,
    required this.volume24,
    this.logoUrl,
  });
}
