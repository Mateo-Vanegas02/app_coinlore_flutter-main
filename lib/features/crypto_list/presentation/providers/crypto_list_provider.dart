import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/crypto_entity.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../../data/datasources/crypto_remote_datasource.dart';
import '../../data/datasources/crypto_remote_datasource_impl.dart';
import '../../data/repositories/crypto_repository_impl.dart';
import '../../../../core/network/api_client.dart';

// API client singleton
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// Remote datasource (siempre usa la API real)
final cryptoRemoteDatasourceProvider = Provider<CryptoRemoteDatasource>((ref) {
  final client = ref.watch(apiClientProvider);
  return CryptoRemoteDatasourceImpl(apiClient: client);
});

// Repositorio que delega al datasource remoto
final cryptoRepositoryProvider = Provider<CryptoRepository>((ref) {
  final remote = ref.watch(cryptoRemoteDatasourceProvider);
  return CryptoRepositoryImpl(remoteDatasource: remote);
});

// Provider de lista paginada
final cryptoListProvider = FutureProvider.family<List<CryptoEntity>, int>(
  (ref, start) async {
    final repo = ref.watch(cryptoRepositoryProvider);
    return repo.getCryptos(start: start, limit: 20);
  },
);

// Provider que devuelve TODOS los cryptos (con refresco cada 5 segundos)
final allCryptosProvider = FutureProvider.autoDispose<List<CryptoEntity>>((ref) async {
  // Mantener el estado vivo incluso si nadie lo escucha momentáneamente
  ref.keepAlive();
  
  // Configurar un temporizador para refrescar los datos automáticamente
  final timer = Timer(const Duration(seconds: 5), () {
    ref.invalidateSelf();
  });
  
  // Limpiar el temporizador si el provider es destruido
  ref.onDispose(timer.cancel);

  final repo = ref.watch(cryptoRepositoryProvider);
  return repo.getAllCryptos();
});
