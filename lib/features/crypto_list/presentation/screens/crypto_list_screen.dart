import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_list_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../search/presentation/widgets/search_modal.dart';
import '../widgets/crypto_table.dart';
import '../widgets/top_gainers_sidebar.dart';
import '../../../charts/presentation/screens/charts_menu_screen.dart';

class CryptoListScreen extends ConsumerStatefulWidget {
  const CryptoListScreen({super.key});

  @override
  ConsumerState<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends ConsumerState<CryptoListScreen> {
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
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'CoinLore',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(width: 24),
            // Mock de los tabs de CoinLore para que se vea similar
            if (MediaQuery.of(context).size.width > 600) ...[
              _buildNavTab('Inicio', isDark),
              _buildNavTab('Noticias', isDark),
              _buildNavTab('Rango', isDark),
              _buildNavTab('Mercados', isDark),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChartsMenuScreen()),
              );
            },
            child: const Text('MPAndroidChart'),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _openSearch(context),
            tooltip: 'Buscar',
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
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
      ),
      body: cryptosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Error al cargar criptomonedas',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(allCryptosProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (cryptos) {
          final isLargeScreen = MediaQuery.of(context).size.width > 900;

          if (isLargeScreen) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CryptoTable(
                    cryptos: cryptos,
                    isDark: isDark,
                  ),
                ),
                TopGainersSidebar(
                  cryptos: cryptos,
                  isDark: isDark,
                ),
              ],
            );
          } else {
            return Column(
              children: [
                TopGainersSidebar(
                  cryptos: cryptos,
                  isDark: isDark,
                  isMobile: true,
                ),
                Expanded(
                  child: CryptoTable(
                    cryptos: cryptos,
                    isDark: isDark,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildNavTab(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.grey[400] : Colors.grey[800],
        ),
      ),
    );
  }
}
