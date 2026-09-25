import 'package:flutter/material.dart';

import 'package:app_coinlore_flutter/features/charts/presentation/theme/chart_theme_tokens.dart';

/// Gráfico de Mapa de Árbol / Mosaico (Treemap / Mosaic Chart).
/// Representa el tamaño de mercado de cada activo proporcional a su capitalización
/// con bloques rectangulares coloreados semánticamente según su rendimiento (+/-).
class GraphicTreemapChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const GraphicTreemapChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    if (data.isEmpty) return const SizedBox.shrink();

    // Estructura visual de mosaico financiero (estilo Coin360 / Finviz)
    return Column(
      children: [
        // Fila 1: Activos Principales (BTC y ETH dominan el 75% del área)
        Expanded(
          flex: 6,
          child: Row(
            children: [
              // BTC: El bloque más grande
              Expanded(
                flex: 6,
                child: _buildTile(
                  data[0],
                  tokens,
                  isLarge: true,
                ),
              ),
              const SizedBox(width: 6),
              // ETH: Segundo bloque
              Expanded(
                flex: 4,
                child: _buildTile(
                  data.length > 1 ? data[1] : data[0],
                  tokens,
                  isLarge: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Fila 2: Activos Medios y Secundarios (SOL, USDT, BNB, XRP)
        Expanded(
          flex: 4,
          child: Row(
            children: [
              if (data.length > 2)
                Expanded(
                  flex: 3,
                  child: _buildTile(data[2], tokens),
                ),
              if (data.length > 3) ...[
                const SizedBox(width: 6),
                Expanded(
                  flex: 3,
                  child: _buildTile(data[3], tokens),
                ),
              ],
              if (data.length > 4) ...[
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: _buildTile(data[4], tokens),
                ),
              ],
              if (data.length > 5) ...[
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: _buildTile(data[5], tokens),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTile(
    Map<String, dynamic> item,
    ChartThemeTokens tokens, {
    bool isLarge = false,
  }) {
    final symbol = item['symbol'] as String? ?? item['name'] as String;
    final change = (item['change'] as num?)?.toDouble() ?? 0.0;
    final price = (item['price'] as num?)?.toDouble();
    final isBull = change >= 0;
    final baseColor = isBull ? tokens.bullishColor : tokens.bearishColor;

    return Container(
      padding: EdgeInsets.all(isLarge ? 12 : 8),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: tokens.isDark ? 0.22 : 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: baseColor.withValues(alpha: tokens.isDark ? 0.6 : 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                symbol,
                style: TextStyle(
                  fontSize: isLarge ? 16 : 12,
                  fontWeight: FontWeight.w900,
                  color: tokens.isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: baseColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${isBull ? '+' : ''}${change.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: isLarge ? 11 : 9,
                    fontWeight: FontWeight.bold,
                    color: baseColor,
                  ),
                ),
              ),
            ],
          ),
          if (price != null)
            Text(
              '\$${_formatPrice(price)}',
              style: TextStyle(
                fontSize: isLarge ? 13 : 11,
                fontWeight: FontWeight.w600,
                color: tokens.isDark ? Colors.grey[300] : const Color(0xFF334155),
              ),
            ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1) return price.toStringAsFixed(2);
    return price.toStringAsFixed(4);
  }
}
