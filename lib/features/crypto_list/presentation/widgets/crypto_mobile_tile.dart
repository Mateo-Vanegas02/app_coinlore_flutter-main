import 'package:flutter/material.dart';

import '../../domain/entities/crypto_entity.dart';
import '../../../crypto_detail/presentation/screens/crypto_detail_screen.dart';

/// Item de lista móvil nativo para criptomonedas.
/// Sustituye la tabla rígida de escritorio por un componente táctil, legible y fluido.
class CryptoMobileTile extends StatelessWidget {
  final CryptoEntity crypto;
  final bool isDark;

  const CryptoMobileTile({
    super.key,
    required this.crypto,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isBullish = crypto.percentChange24h >= 0;
    final changeColor = isBullish
        ? (isDark ? const Color(0xFF00E676) : const Color(0xFF059669))
        : (isDark ? const Color(0xFFFF5252) : const Color(0xFFDC2626));

    final logoUrl = crypto.logoUrl ?? '';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CryptoDetailScreen(crypto: crypto),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Ranking
            SizedBox(
              width: 24,
              child: Text(
                '${crypto.rank}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Logo Cripto
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEF2F6),
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: logoUrl.isNotEmpty
                  ? Image.network(
                      logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildFallbackAvatar(isDark),
                    )
                  : _buildFallbackAvatar(isDark),
            ),
            const SizedBox(width: 12),

            // Nombre y Símbolo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crypto.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          crypto.symbol,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Cap: \$${_formatCompact(crypto.marketCapUsd)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Precio y Variación 24h
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${_formatPrice(crypto.priceUsd)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: changeColor.withValues(alpha: isDark ? 0.15 : 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isBullish ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                        size: 14,
                        color: changeColor,
                      ),
                      Text(
                        '${crypto.percentChange24h.abs().toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: changeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(bool isDark) {
    return Center(
      child: Text(
        crypto.symbol.isNotEmpty ? crypto.symbol[0] : '?',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1) {
      return price.toStringAsFixed(2);
    } else if (price >= 0.001) {
      return price.toStringAsFixed(4);
    } else {
      return price.toStringAsFixed(6);
    }
  }

  String _formatCompact(double number) {
    if (number >= 1e12) return '${(number / 1e12).toStringAsFixed(2)}T';
    if (number >= 1e9) return '${(number / 1e9).toStringAsFixed(2)}B';
    if (number >= 1e6) return '${(number / 1e6).toStringAsFixed(2)}M';
    if (number >= 1e3) return '${(number / 1e3).toStringAsFixed(1)}K';
    return number.toStringAsFixed(0);
  }
}
