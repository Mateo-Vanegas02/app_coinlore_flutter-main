import 'package:flutter/material.dart';

import '../../domain/entities/crypto_entity.dart';

/// Banner móvil con métricas globales del mercado cripto.
class MarketSummaryBanner extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const MarketSummaryBanner({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (cryptos.isEmpty) return const SizedBox.shrink();

    // Cálculo dinámico de totales aproximados a partir del top 100
    final totalMarketCap = cryptos.fold<double>(0, (sum, c) => sum + c.marketCapUsd);
    final totalVolume = cryptos.fold<double>(0, (sum, c) => sum + c.volume24);
    
    CryptoEntity? btc;
    for (final c in cryptos) {
      if (c.symbol.toUpperCase() == 'BTC') {
        btc = c;
        break;
      }
    }
    final btcEntity = btc ?? cryptos.first;
    final btcDominance = totalMarketCap > 0
        ? (btcEntity.marketCapUsd / totalMarketCap * 100).clamp(40.0, 70.0)
        : 58.2;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetric('Cap. Global', '\$${_formatCompact(totalMarketCap)}', isDark),
          _buildDivider(isDark),
          _buildMetric('Volumen 24h', '\$${_formatCompact(totalVolume)}', isDark),
          _buildDivider(isDark),
          _buildMetric('Dominancia BTC', '${btcDominance.toStringAsFixed(1)}%', isDark),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 28,
      color: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.black.withValues(alpha: 0.08),
    );
  }

  String _formatCompact(double number) {
    if (number >= 1e12) return '${(number / 1e12).toStringAsFixed(2)}T';
    if (number >= 1e9) return '${(number / 1e9).toStringAsFixed(2)}B';
    if (number >= 1e6) return '${(number / 1e6).toStringAsFixed(1)}M';
    return number.toStringAsFixed(0);
  }
}
