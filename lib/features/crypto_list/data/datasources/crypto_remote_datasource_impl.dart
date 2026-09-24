import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/exceptions.dart';
import '../models/crypto_model.dart';
import 'crypto_remote_datasource.dart';

class CryptoRemoteDatasourceImpl implements CryptoRemoteDatasource {
  final ApiClient _apiClient;

  CryptoRemoteDatasourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<CryptoModel>> getCryptos({int start = 0, int limit = 20}) async {
    final response = await _apiClient
        .get('${ApiConstants.tickers}?start=$start&limit=$limit');

    final dynamic raw = response['data'];
    if (raw == null) {
      throw ParseException('Campo "data" no encontrado en la respuesta');
    }

    final List<dynamic> list = raw as List<dynamic>;
    return list
        .map((e) => CryptoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CryptoModel>> getAllCryptos() async =>
      getCryptos(start: 0, limit: 100);
}
