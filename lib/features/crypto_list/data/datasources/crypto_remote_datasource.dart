import '../models/crypto_model.dart';

abstract class CryptoRemoteDatasource {
  Future<List<CryptoModel>> getCryptos({int start = 0, int limit = 20});
  Future<List<CryptoModel>> getAllCryptos();
}
