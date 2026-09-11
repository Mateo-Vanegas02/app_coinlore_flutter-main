import 'package:flutter/material.dart';
import '../../domain/entities/crypto_entity.dart';
import '../../../crypto_detail/presentation/screens/crypto_detail_screen.dart';

// Anchos fijos para que header y filas estén siempre alineados
const double _colRank = 44;
const double _colName = 200;
const double _colPrice = 130;
const double _col24h = 78;
const double _col1h = 78;
const double _col7d = 78;
const double _colMarket = 130;
const double _colVolume = 120;
const double _totalWidth =
    _colRank + _colName + _colPrice + _col24h + _col1h + _col7d + _colMarket + _colVolume;

class CryptoTable extends StatelessWidget {
  final List<CryptoEntity> cryptos;
  final bool isDark;

  const CryptoTable({
    super.key,
    required this.cryptos,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder para saber la altura disponible y dársela explícitamente al ListView
    return LayoutBuilder(
      builder: (context, constraints) {
        const headerHeight = 44.0;
        final listHeight = constraints.maxHeight - headerHeight - 1; // -1 = divider
        // Ancho mínimo: el disponible o el total de columnas, el mayor gana
        final tableWidth = constraints.maxWidth > _totalWidth
            ? constraints.maxWidth
            : _totalWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: Column(
              children: [
                // ---- HEADER ----
                SizedBox(
                  height: headerHeight,
                  child: _buildHeader(isDark),
                ),
                const Divider(height: 1, thickness: 1),
                // ---- FILAS ----
                SizedBox(
                  height: listHeight,
                  child: ListView.separated(
                    itemCount: cryptos.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                    ),
                    itemBuilder: (context, i) =>
                        _CryptoRow(crypto: cryptos[i], isDark: isDark),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    final style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: isDark ? Colors.grey[400] : Colors.grey[600],
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: isDark ? const Color(0xFF1A1A1A) : Colors.grey[100],
      child: Row(
        children: [
          SizedBox(width: _colRank, child: Text('#', style: style)),
          SizedBox(width: _colName, child: Text('Moneda', style: style)),
          SizedBox(width: _colPrice, child: Text('Precio', style: style, textAlign: TextAlign.right)),
          SizedBox(width: _col24h, child: Text('24h', style: style, textAlign: TextAlign.right)),
          SizedBox(width: _col1h, child: Text('1h', style: style, textAlign: TextAlign.right)),
          SizedBox(width: _col7d, child: Text('7d', style: style, textAlign: TextAlign.right)),
          SizedBox(width: _colMarket, child: Text('Cap. de Mercado', style: style, textAlign: TextAlign.right)),
          SizedBox(width: _colVolume, child: Text('Volumen (24h)', style: style, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _CryptoRow extends StatefulWidget {
  final CryptoEntity crypto;
  final bool isDark;

  const _CryptoRow({required this.crypto, required this.isDark});

  @override
  State<_CryptoRow> createState() => _CryptoRowState();
}

class _CryptoRowState extends State<_CryptoRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final rowColor = widget.isDark ? const Color(0xFF121212) : Colors.white;
    final hoverColor = widget.isDark ? const Color(0xFF2A2A2A) : Colors.grey[100];
    final c = widget.crypto;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CryptoDetailScreen(crypto: c)),
        ),
        child: Container(
          height: 60,
          color: _hovered ? hoverColor : rowColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: _colRank,
                child: Text(
                  '${c.rank}',
                  style: TextStyle(
                    fontSize: 13,
                    color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(
                width: _colName,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          c.logoUrl != null ? NetworkImage(c.logoUrl!) : null,
                      child: c.logoUrl == null
                          ? Text(c.symbol.isNotEmpty ? c.symbol[0] : '?',
                              style: const TextStyle(fontSize: 12))
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            c.symbol,
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: _colPrice,
                child: Text(
                  '\$${_fmt(c.priceUsd)}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
              SizedBox(width: _col24h, child: _pct(c.percentChange24h)),
              SizedBox(width: _col1h, child: _pct(c.percentChange1h)),
              SizedBox(width: _col7d, child: _pct(c.percentChange7d)),
              SizedBox(
                width: _colMarket,
                child: Text('\$${_large(c.marketCapUsd)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 13)),
              ),
              SizedBox(
                width: _colVolume,
                child: Text('\$${_large(c.volume24)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pct(double v) {
    final color = v > 0
        ? Colors.green
        : v < 0
            ? Colors.red
            : Colors.grey;
    return Text(
      '${v > 0 ? '+' : ''}${v.toStringAsFixed(2)}%',
      textAlign: TextAlign.right,
      style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 13),
    );
  }

  String _fmt(double v) {
    if (v >= 1000) return v.toStringAsFixed(2);
    if (v >= 1) return v.toStringAsFixed(2);
    if (v >= 0.01) return v.toStringAsFixed(4);
    return v.toStringAsFixed(6);
  }

  String _large(double v) {
    if (v >= 1e12) return '${(v / 1e12).toStringAsFixed(2)} T';
    if (v >= 1e9) return '${(v / 1e9).toStringAsFixed(2)} B';
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(2)} M';
    return v.toStringAsFixed(0);
  }
}
