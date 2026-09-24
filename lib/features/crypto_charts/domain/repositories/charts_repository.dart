import '../entities/global_stats_entity.dart';
import '../entities/market_pair_entity.dart';

abstract class ChartsRepository {
  Future<GlobalStatsEntity> getGlobalStats();
  Future<List<MarketPairEntity>> getCoinMarkets(String coinId);
}
