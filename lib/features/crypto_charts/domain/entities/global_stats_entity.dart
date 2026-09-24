class GlobalStatsEntity {
  final int coinsCount;
  final int activeMarkets;
  final double totalMcap;
  final double totalVolume;
  final double btcDominance;
  final double ethDominance;
  final double mcapChange24h;
  final double volumeChange24h;
  final double avgChangePercent;
  final double volumeAth;
  final double mcapAth;

  const GlobalStatsEntity({
    required this.coinsCount,
    required this.activeMarkets,
    required this.totalMcap,
    required this.totalVolume,
    required this.btcDominance,
    required this.ethDominance,
    required this.mcapChange24h,
    required this.volumeChange24h,
    required this.avgChangePercent,
    required this.volumeAth,
    required this.mcapAth,
  });

  double get altcoinsDominance =>
      (100.0 - btcDominance - ethDominance).clamp(0.0, 100.0);
}
