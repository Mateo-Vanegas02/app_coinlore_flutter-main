import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/crypto_detail_entity.dart';

abstract class CryptoDetailRemoteDatasource {
  Future<CryptoDetailEntity> getCryptoDetail(String id);
}

class CryptoDetailRemoteDatasourceImpl implements CryptoDetailRemoteDatasource {
  final ApiClient _apiClient;

  CryptoDetailRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<CryptoDetailEntity> getCryptoDetail(String id) async {
    final response = await _apiClient.get('${ApiConstants.ticker}?id=$id');

    // El endpoint /ticker/ devuelve una lista con un elemento
    final List<dynamic> list = response['data'] as List<dynamic>;
    final Map<String, dynamic> json = list.first as Map<String, dynamic>;

    return CryptoDetailEntity(
      id: json['id']?.toString() ?? id,
      symbol: json['symbol']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nameid: json['nameid']?.toString() ?? '',
      price: double.tryParse(json['price_usd']?.toString() ?? '0') ?? 0.0,
      change24h:
          double.tryParse(json['percent_change_24h']?.toString() ?? '0') ?? 0.0,
      change1h:
          double.tryParse(json['percent_change_1h']?.toString() ?? '0') ?? 0.0,
      change7d:
          double.tryParse(json['percent_change_7d']?.toString() ?? '0') ?? 0.0,
      marketCap:
          double.tryParse(json['market_cap_usd']?.toString() ?? '0') ?? 0.0,
      volume: double.tryParse(json['volume24']?.toString() ?? '0') ?? 0.0,
      circulatingSupply: json['csupply']?.toString() ?? '',
      totalSupply: json['tsupply']?.toString() ?? '',
      maxSupply: json['msupply']?.toString() ?? '',
      ath: double.tryParse(json['price_usd']?.toString() ?? '0') ?? 0.0,
      athDate: '',
      startDate: '',
      platform: '',
      website: json['url']?.toString() ?? '',
      twitter: json['twitter']?.toString() ?? '',
      explorer: json['explorer']?.toString() ?? '',
      logo: ApiConstants.logoUrl(json['nameid']?.toString() ?? ''),
    );
  }
}
