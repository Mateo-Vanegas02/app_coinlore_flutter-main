import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/global_stats_entity.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/entities/market_pair_entity.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/domain/repositories/charts_repository.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/data/datasources/charts_remote_datasource.dart';

class ChartsRepositoryImpl implements ChartsRepository {
  final ChartsRemoteDatasource _remoteDatasource;

  ChartsRepositoryImpl({required ChartsRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<GlobalStatsEntity> getGlobalStats() =>
      _remoteDatasource.getGlobalStats();

  @override
  Future<List<MarketPairEntity>> getCoinMarkets(String coinId) =>
      _remoteDatasource.getCoinMarkets(coinId);
}
