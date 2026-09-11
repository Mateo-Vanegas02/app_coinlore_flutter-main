import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/responsive.dart';
import '../../../crypto_list/domain/entities/crypto_entity.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/search_provider.dart';
import 'search_result_tile.dart';

class SearchModal extends ConsumerStatefulWidget {
  const SearchModal({super.key});

  @override
  ConsumerState<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends ConsumerState<SearchModal> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _closeModal() {
    Navigator.pop(context);
  }

  void _onSearchChanged(String value) {
    ref.read(searchQueryProvider.notifier).state = value;
  }

  void _onSelectCrypto(CryptoEntity crypto) {
    ref.read(addToHistoryProvider(crypto.name).future);
    _closeModal();
  }

  void _clearSearch() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).state = '';
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);
    final historyAsync = ref.watch(searchHistoryProvider);
    final allCryptosAsync = ref.watch(allCryptosProvider);

    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);
    final maxWidth = isDesktop ? 700.0 : (isTablet ? 600.0 : double.infinity);
    final padding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black87 : Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SafeArea(
            child: Column(
              children: [
                _buildSearchBar(isDark, padding),
                Expanded(
                  child: _buildContent(
                    isDark,
                    query,
                    results,
                    historyAsync,
                    allCryptosAsync,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, double padding) {
    final query = ref.watch(searchQueryProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _closeModal,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onSearchChanged,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar criptomonedas en CoinLore...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    bool isDark,
    String query,
    List<CryptoEntity> results,
    AsyncValue<List<String>> historyAsync,
    AsyncValue<List<CryptoEntity>> allCryptosAsync,
  ) {
    if (query.trim().isNotEmpty) {
      return _buildResults(isDark, results, allCryptosAsync);
    }
    return _buildHistory(isDark, historyAsync);
  }

  Widget _buildResults(
    bool isDark,
    List<CryptoEntity> results,
    AsyncValue<List<CryptoEntity>> allCryptosAsync,
  ) {
    return allCryptosAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error al buscar en CoinLore',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        ),
      ),
      data: (allCryptos) {
        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                const SizedBox(height: 16),
                Text(
                  'No se encontraron resultados',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final crypto = results[index];
            return SearchResultTile(
              crypto: crypto,
              onTap: () => _onSelectCrypto(crypto),
              isDark: isDark,
            );
          },
        );
      },
    );
  }

  Widget _buildHistory(bool isDark, AsyncValue<List<String>> historyAsync) {
    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error al cargar historial',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        ),
      ),
      data: (history) {
        if (history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay búsquedas recientes',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Empieza a escribir para buscar...',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Búsquedas recientes',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await ref.read(clearHistoryProvider.future);
                      ref.invalidate(searchHistoryProvider);
                    },
                    child: Text(
                      'Limpiar',
                      style: TextStyle(color: Colors.red[400], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final query = history[index];
                  return ListTile(
                    leading: Icon(
                      Icons.history,
                      color: isDark ? Colors.white38 : Colors.black38,
                      size: 20,
                    ),
                    title: Text(
                      query,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    onTap: () {
                      _controller.text = query;
                      ref.read(searchQueryProvider.notifier).state = query;
                      _focusNode.requestFocus();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
