import '../../domain/entities/crypto_entity.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../datasources/crypto_remote_datasource.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDatasource _remoteDatasource;

  CryptoRepositoryImpl({required CryptoRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<List<CryptoEntity>> getCryptos({int start = 0, int limit = 20}) =>
      _remoteDatasource.getCryptos(start: start, limit: limit);

  @override
  Future<List<CryptoEntity>> getAllCryptos() =>
      _remoteDatasource.getAllCryptos();
}
