import 'package:app_coinlore_flutter/core/constants/api_constants.dart';
import 'package:app_coinlore_flutter/core/network/api_client.dart';
import 'package:app_coinlore_flutter/core/network/exceptions.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/data/models/global_stats_model.dart';
import 'package:app_coinlore_flutter/features/crypto_charts/data/models/market_pair_model.dart';

abstract class ChartsRemoteDatasource {
  Future<GlobalStatsModel> getGlobalStats();
  Future<List<MarketPairModel>> getCoinMarkets(String coinId);
}

class ChartsRemoteDatasourceImpl implements ChartsRemoteDatasource {
  final ApiClient _apiClient;

  ChartsRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<GlobalStatsModel> getGlobalStats() async {
    final response = await _apiClient.get(ApiConstants.globalStats);
    final dynamic raw = response['data'];

    if (raw is List && raw.isNotEmpty) {
      return GlobalStatsModel.fromJson(raw.first as Map<String, dynamic>);
    } else if (response.containsKey('coins_count')) {
      return GlobalStatsModel.fromJson(response);
    }

    throw ParseException('No se encontraron estadísticas globales en la respuesta');
  }

  @override
  Future<List<MarketPairModel>> getCoinMarkets(String coinId) async {
    final url = '${ApiConstants.baseUrl}/coin/markets/?id=$coinId';
    final response = await _apiClient.get(url);
    final dynamic raw = response['data'] ?? response;

    if (raw is List) {
      return raw
          .map((item) => MarketPairModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}
