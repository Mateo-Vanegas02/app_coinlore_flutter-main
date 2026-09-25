import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../crypto_list/presentation/screens/crypto_list_screen.dart';
import '../../../charts/presentation/screens/charts_gallery_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../settings/presentation/providers/settings_provider.dart';

/// Contenedor de Navegación Móvil Principal (Mobile Navigation Shell).
/// Controla la barra de navegación inferior (Bottom Navigation)
/// para una experiencia 100% nativa en smartphones y tablets.
class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CryptoListScreen(),
    ChartsGalleryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        indicatorColor: isDark
            ? const Color(0xFF2563EB).withValues(alpha: 0.25)
            : const Color(0xFFDBEAFE),
        elevation: 8,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.candlestick_chart_outlined,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            selectedIcon: const Icon(
              Icons.candlestick_chart_rounded,
              color: Color(0xFF2563EB),
            ),
            label: 'Mercados',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.auto_graph_outlined,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            selectedIcon: const Icon(
              Icons.auto_graph_rounded,
              color: Color(0xFF2563EB),
            ),
            label: 'Gráficos',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.tune_outlined,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            selectedIcon: const Icon(
              Icons.tune_rounded,
              color: Color(0xFF2563EB),
            ),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
