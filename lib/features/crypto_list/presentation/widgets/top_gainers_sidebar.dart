import 'package:flutter/material.dart';
import '../../domain/entities/crypto_entity.dart';
import '../../../crypto_detail/presentation/screens/crypto_detail_screen.dart';

class TopGainersSidebar extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;
  final bool isMobile;

  const TopGainersSidebar({
    super.key,
    required this.cryptos,
    required this.isDark,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    // Ordenar para obtener los Top Gainers en 24h
    final sortedCryptos = List<CryptoEntity>.from(cryptos)
      ..sort((a, b) => b.percentChange24h.compareTo(a.percentChange24h));

    final topGainers = sortedCryptos.take(12).toList();

    // ----------- VERSIÓN MÓVIL: strip horizontal compacto -----------
    if (isMobile) {
      return Container(
        color: isDark ? const Color(0xFF161616) : Colors.grey[50],
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Ganadores 24h',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[300] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.red],
                        stops: [0.6, 0.6],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: topGainers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final crypto = topGainers[index];
                  return _GainerChip(
                    crypto: crypto,
                    isDark: isDark,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // ----------- VERSIÓN DESKTOP: columna lateral -----------
    return Container(
      width: 300,
      color: isDark ? const Color(0xFF161616) : Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ganadores VS Perdedores:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.red],
                      stops: [0.6, 0.6],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Ganadores\n(De Las 100 Monedas Principales)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.grey[300] : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 8,
                    children: topGainers.map((crypto) => SizedBox(
                      width: 60,
                      child: _GainerChip(crypto: crypto, isDark: isDark),
                    )).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip individual de una criptomoneda ganadora
class _GainerChip extends StatelessWidget {
  final CryptoEntity crypto;
  final bool isDark;

  const _GainerChip({required this.crypto, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CryptoDetailScreen(crypto: crypto),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.transparent,
              backgroundImage: crypto.logoUrl != null ? NetworkImage(crypto.logoUrl!) : null,
              child: crypto.logoUrl == null
                  ? Text(
                      crypto.symbol.isNotEmpty ? crypto.symbol[0] : '?',
                      style: const TextStyle(fontSize: 12),
                    )
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              crypto.symbol,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[300] : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '+${crypto.percentChange24h.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
