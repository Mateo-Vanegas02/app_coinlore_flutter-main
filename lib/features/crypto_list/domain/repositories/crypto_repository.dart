import '../entities/crypto_entity.dart';

abstract class CryptoRepository {
  Future<List<CryptoEntity>> getCryptos({int start = 0, int limit = 20});
  Future<List<CryptoEntity>> getAllCryptos();
}
