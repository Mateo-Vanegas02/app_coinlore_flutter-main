import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/responsive.dart';
import '../../../crypto_list/domain/entities/crypto_entity.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/crypto_detail_entity.dart';
import '../providers/crypto_detail_provider.dart' show loadDetailProvider;
import '../widgets/detail_info_card.dart';
import '../widgets/detail_social_links.dart';

class CryptoDetailScreen extends ConsumerStatefulWidget {
  final CryptoEntity crypto;

  const CryptoDetailScreen({super.key, required this.crypto});

  @override
  ConsumerState<CryptoDetailScreen> createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends ConsumerState<CryptoDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(loadDetailProvider(widget.crypto.id));
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final isTabletOrDesktop =
        Responsive.isTablet(context) || Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.crypto.symbol),
            const SizedBox(width: 8),
            Text(
              widget.crypto.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: detailAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando detalles de CoinLore...'),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Error al cargar detalles',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(loadDetailProvider(widget.crypto.id));
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (detail) {
          if (isTabletOrDesktop) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildHeader(detail, isDark),
                        const SizedBox(height: 16),
                        DetailSocialLinks(detail: detail),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(flex: 3, child: DetailInfoCard(detail: detail)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(detail, isDark),
                DetailInfoCard(detail: detail),
                DetailSocialLinks(detail: detail),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(CryptoDetailEntity detail, bool isDark) {
    final logoUrl = widget.crypto.logoUrl ?? detail.logo;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[200],
              borderRadius: BorderRadius.circular(40),
            ),
            clipBehavior: Clip.antiAlias,
            child: logoUrl.isNotEmpty
                ? Image.network(
                    logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Text(
                        detail.symbol.isNotEmpty ? detail.symbol.substring(0, 1) : '?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      detail.symbol.isNotEmpty ? detail.symbol.substring(0, 1) : '?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),

          // Precio
          Text(
            '\$${detail.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // Cambios
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChangeChip(
                '24h: ${detail.change24h > 0 ? '+' : ''}${detail.change24h.toStringAsFixed(2)}%',
                detail.change24h,
                isDark,
              ),
              const SizedBox(width: 12),
              _buildChangeChip(
                '7d: ${detail.change7d > 0 ? '+' : ''}${detail.change7d.toStringAsFixed(2)}%',
                detail.change7d,
                isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChangeChip(String label, double change, bool isDark) {
    final color = change > 0
        ? Colors.green[400]
        : change < 0
        ? Colors.red[400]
        : Colors.grey[400];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color?.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color ?? Colors.grey, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
