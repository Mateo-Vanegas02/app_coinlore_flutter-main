import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/crypto_detail_entity.dart';
import '../../data/datasources/crypto_detail_remote_datasource.dart';
import '../../../crypto_list/presentation/providers/crypto_list_provider.dart';

final cryptoDetailDatasourceProvider =
    Provider<CryptoDetailRemoteDatasource>((ref) {
  final client = ref.watch(apiClientProvider);
  return CryptoDetailRemoteDatasourceImpl(apiClient: client);
});

// Provider para cargar el detalle de una cripto por ID
final loadDetailProvider =
    FutureProvider.family<CryptoDetailEntity, String>((ref, id) async {
  final datasource = ref.watch(cryptoDetailDatasourceProvider);
  return datasource.getCryptoDetail(id);
});

// Provider de estado que guarda el último detalle cargado
final detailProvider = FutureProvider<CryptoDetailEntity>((ref) async {
  // Este provider devuelve un estado vacío hasta que se llame loadDetailProvider
  throw UnimplementedError('Usa loadDetailProvider(id) para cargar el detalle');
});
