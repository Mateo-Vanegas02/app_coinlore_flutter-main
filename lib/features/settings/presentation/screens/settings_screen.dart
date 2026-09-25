import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

/// Pantalla móvil de Ajustes y Configuración.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Ajustes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de Apariencia
          _buildSectionHeader('Apariencia', isDark),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              SwitchListTile(
                title: const Text('Modo Oscuro'),
                subtitle: Text(
                  isDark ? 'Tema oscuro activado' : 'Tema claro activado',
                  style: const TextStyle(fontSize: 12),
                ),
                secondary: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                ),
                value: isDark,
                onChanged: (val) {
                  ref.read(settingsProvider.notifier).update(
                        (s) => s.copyWith(
                          themeMode: val ? ThemeMode.dark : ThemeMode.light,
                        ),
                      );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Sección de Preferencias
          _buildSectionHeader('Preferencias Financieras', isDark),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              ListTile(
                leading: const Icon(Icons.attach_money_rounded, color: Colors.green),
                title: const Text('Moneda Base'),
                subtitle: const Text('Dólar Estadounidense (USD)'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.language_rounded, color: Colors.blue),
                title: const Text('Idioma'),
                subtitle: const Text('Español'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Sección de Datos y API
          _buildSectionHeader('Información de la App', isDark),
          _buildSettingsCard(
            isDark: isDark,
            children: [
              const ListTile(
                leading: Icon(Icons.analytics_rounded, color: Colors.purple),
                title: Text('Librería de Gráficos'),
                subtitle: Text('Syncfusion Flutter Charts 34.2.9'),
              ),
              const Divider(height: 1, indent: 56),
              const ListTile(
                leading: Icon(Icons.cloud_sync_rounded, color: Colors.teal),
                title: Text('Proveedor de Datos'),
                subtitle: Text('CoinLore API v1'),
              ),
              const Divider(height: 1, indent: 56),
              const ListTile(
                leading: Icon(Icons.info_outline_rounded, color: Colors.orange),
                title: Text('Versión'),
                subtitle: Text('1.0.0+1 (Mobile-First Release)'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required bool isDark, required List<Widget> children}) {
    return Material(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }
}
