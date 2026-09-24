import 'package:flutter/material.dart';

import '../../../crypto_detail/presentation/screens/crypto_detail_screen.dart';
import '../../../crypto_list/domain/entities/crypto_entity.dart';

class SearchResultTile extends StatelessWidget {
  final CryptoEntity crypto;
  final VoidCallback onTap;
  final bool isDark;

  const SearchResultTile({
    super.key,
    required this.crypto,
    required this.onTap,
    required this.isDark,
  });

  String _formatPrice(double price) {
    if (price >= 1000) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price >= 1) {
      return '\$${price.toStringAsFixed(2)}';
    } else if (price >= 0.01) {
      return '\$${price.toStringAsFixed(4)}';
    } else {
      return '\$${price.toStringAsFixed(8)}';
    }
  }

  Color _getChangeColor(double change) {
    if (change > 0) return Colors.green;
    if (change < 0) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CryptoDetailScreen(crypto: crypto),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            ),
          ),
        ),
        child: Row(
          children: [
            // Logo CDN o inicial
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: crypto.logoUrl != null
                  ? Image.network(
                      crypto.logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          crypto.symbol.isNotEmpty ? crypto.symbol.substring(0, 1) : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        crypto.symbol.isNotEmpty ? crypto.symbol.substring(0, 1) : '?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            // Nombre y símbolo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crypto.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    crypto.symbol,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // Precio y cambio
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(crypto.priceUsd),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  '${crypto.percentChange24h > 0 ? '+' : ''}${crypto.percentChange24h.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _getChangeColor(crypto.percentChange24h),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
