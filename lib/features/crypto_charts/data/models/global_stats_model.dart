import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/global_stats_entity.dart';

class GlobalStatsModel extends GlobalStatsEntity {
  const GlobalStatsModel({
    required super.coinsCount,
    required super.activeMarkets,
    required super.totalMcap,
    required super.totalVolume,
    required super.btcDominance,
    required super.ethDominance,
    required super.mcapChange24h,
    required super.volumeChange24h,
    required super.avgChangePercent,
    required super.volumeAth,
    required super.mcapAth,
  });

  factory GlobalStatsModel.fromJson(Map<String, dynamic> json) {
    return GlobalStatsModel(
      coinsCount: int.tryParse(json['coins_count']?.toString() ?? '0') ?? 0,
      activeMarkets:
          int.tryParse(json['active_markets']?.toString() ?? '0') ?? 0,
      totalMcap:
          double.tryParse(json['total_mcap']?.toString() ?? '0') ?? 0.0,
      totalVolume:
          double.tryParse(json['total_volume']?.toString() ?? '0') ?? 0.0,
      btcDominance: double.tryParse(json['btc_d']?.toString() ?? '0') ?? 0.0,
      ethDominance: double.tryParse(json['eth_d']?.toString() ?? '0') ?? 0.0,
      mcapChange24h:
          double.tryParse(json['mcap_change']?.toString() ?? '0') ?? 0.0,
      volumeChange24h:
          double.tryParse(json['volume_change']?.toString() ?? '0') ?? 0.0,
      avgChangePercent:
          double.tryParse(json['avg_change_percent']?.toString() ?? '0') ?? 0.0,
      volumeAth:
          double.tryParse(json['volume_ath']?.toString() ?? '0') ?? 0.0,
      mcapAth: double.tryParse(json['mcap_ath']?.toString() ?? '0') ?? 0.0,
    );
  }
}
