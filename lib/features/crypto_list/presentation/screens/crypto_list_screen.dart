import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/crypto_list_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../search/presentation/widgets/search_modal.dart';
import '../../domain/entities/crypto_entity.dart';
import '../widgets/crypto_mobile_tile.dart';
import '../widgets/market_summary_banner.dart';
import '../widgets/top_gainers_carousel.dart';

/// Pantalla móvil principal de Mercados de Criptomonedas.
/// Diseñada con estética nativa móvil: tarjetas táctiles, carrusel de destacadas
/// y filtros rápidos sin tablas rígidas de escritorio.
class CryptoListScreen extends ConsumerStatefulWidget {
  const CryptoListScreen({super.key});

  @override
  ConsumerState<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends ConsumerState<CryptoListScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Todas', '🔥 Top 10', '🟢 Ganadoras', '🔴 Perdedoras'];

  void _openSearch(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => const SearchModal(),
      barrierDismissible: true,
      barrierLabel: 'Cerrar búsqueda',
    );
  }

  @override
  Widget build(BuildContext context) {
    final cryptosAsync = ref.watch(allCryptosProvider);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2563EB), Color(0xFF38BDF8)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.currency_bitcoin_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'CoinLore',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => _openSearch(context),
            tooltip: 'Buscar Criptomoneda',
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () {
              ref.read(settingsProvider.notifier).update(
                    (s) => s.copyWith(
                      themeMode: isDark ? ThemeMode.light : ThemeMode.dark,
                    ),
                  );
            },
            tooltip: 'Cambiar tema',
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      ),
      body: cryptosAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando mercados...'),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Error al cargar criptomonedas',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(allCryptosProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (cryptos) {
          final filteredList = _applyFilter(cryptos);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(allCryptosProvider);
            },
            child: CustomScrollView(
              slivers: [
                // 1. Banner de Resumen de Mercado Global
                SliverToBoxAdapter(
                  child: MarketSummaryBanner(cryptos: cryptos, isDark: isDark),
                ),

                // 2. Carrusel de Ganadoras 24h
                SliverToBoxAdapter(
                  child: TopGainersCarousel(cryptos: cryptos, isDark: isDark),
                ),

                // 3. Chips de Filtrado Rápido
                SliverToBoxAdapter(
                  child: Container(
                    height: 48,
                    margin: const EdgeInsets.only(top: 8, bottom: 4),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final isSelected = _selectedFilterIndex == i;
                        return ChoiceChip(
                          label: Text(_filters[i]),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedFilterIndex = i);
                          },
                          selectedColor: isDark ? const Color(0xFF2563EB) : const Color(0xFF1D4ED8),
                          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.grey[300] : const Color(0xFF334155)),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.transparent
                                  : (isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.black.withValues(alpha: 0.08)),
                            ),
                          ),
                          showCheckmark: false,
                        );
                      },
                    ),
                  ),
                ),

                // 4. Lista Móvil de Criptomonedas o Estado Vacío
                if (filteredList.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: isDark ? Colors.white38 : Colors.black38,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No se encontraron criptomonedas para este filtro',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.white60 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final crypto = filteredList[index];
                          return Column(
                            children: [
                              CryptoMobileTile(
                                crypto: crypto,
                                isDark: isDark,
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                indent: 72,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.black.withValues(alpha: 0.04),
                              ),
                            ],
                          );
                        },
                        childCount: filteredList.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<CryptoEntity> _applyFilter(List<CryptoEntity> cryptos) {
    switch (_selectedFilterIndex) {
      case 1: // Top 10
        return cryptos.take(10).toList();
      case 2: // Ganadoras
        final gainers = cryptos.where((c) => c.percentChange24h > 0).toList();
        gainers.sort((a, b) => b.percentChange24h.compareTo(a.percentChange24h));
        return gainers;
      case 3: // Perdedoras
        final losers = cryptos.where((c) => c.percentChange24h < 0).toList();
        losers.sort((a, b) => a.percentChange24h.compareTo(b.percentChange24h));
        return losers;
      default:
        return cryptos;
    }
  }
}
