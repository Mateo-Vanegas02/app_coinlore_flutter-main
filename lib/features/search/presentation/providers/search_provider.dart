import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../crypto_list/domain/entities/crypto_entity.dart';
import '../../../crypto_list/presentation/providers/crypto_list_provider.dart';
import '../../data/datasources/search_local_datasource.dart';

final searchLocalDatasourceProvider = Provider<SearchLocalDatasource>((ref) {
  return SearchLocalDatasource();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<CryptoEntity>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final allCryptosAsync = ref.watch(allCryptosProvider);

  if (query.trim().isEmpty) {
    return [];
  }

  final lowerQuery = query.toLowerCase().trim();

  return allCryptosAsync.when(
    data: (allCryptos) {
      return allCryptos
          .where(
            (crypto) =>
                crypto.name.toLowerCase().contains(lowerQuery) ||
                crypto.symbol.toLowerCase().contains(lowerQuery),
          )
          .toList();
    },
    loading: () => [],
    error: (error, stack) => [],
  );
});

final allCryptosProvider = FutureProvider<List<CryptoEntity>>((ref) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  return await repository.getAllCryptos();
});

final searchHistoryProvider = FutureProvider<List<String>>((ref) async {
  final datasource = ref.watch(searchLocalDatasourceProvider);
  return await datasource.getHistory();
});

final addToHistoryProvider = FutureProvider.family<void, String>((
  ref,
  query,
) async {
  final datasource = ref.watch(searchLocalDatasourceProvider);
  await datasource.addToHistory(query);
});

final clearHistoryProvider = FutureProvider<void>((ref) async {
  final datasource = ref.watch(searchLocalDatasourceProvider);
  await datasource.clearHistory();
});
