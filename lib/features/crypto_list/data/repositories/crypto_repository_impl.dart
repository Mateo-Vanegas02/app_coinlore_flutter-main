import '../../domain/entities/crypto_entity.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../datasources/crypto_remote_datasource.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDatasource _remoteDatasource;

  CryptoRepositoryImpl({required CryptoRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<List<CryptoEntity>> getCryptos({int start = 0, int limit = 20}) async {
    final list = await _remoteDatasource.getCryptos(start: start, limit: limit);
    return List<CryptoEntity>.from(list);
  }

  @override
  Future<List<CryptoEntity>> getAllCryptos() async {
    final list = await _remoteDatasource.getAllCryptos();
    return List<CryptoEntity>.from(list);
  }
}
