import 'package:flutter/material.dart';

import '../../domain/entities/crypto_detail_entity.dart';

class DetailInfoCard extends StatelessWidget {
  final CryptoDetailEntity detail;

  const DetailInfoCard({super.key, required this.detail});

  String _formatNumber(double value) {
    if (value >= 1e12) return '\$${(value / 1e12).toStringAsFixed(1)}T';
    if (value >= 1e9) return '\$${(value / 1e9).toStringAsFixed(1)}B';
    if (value >= 1e6) return '\$${(value / 1e6).toStringAsFixed(1)}M';
    return '\$${value.toStringAsFixed(0)}';
  }

  String _formatSupply(String supply) {
    if (supply.isEmpty) return 'N/A';
    final value = double.tryParse(supply) ?? 0;
    if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(2)}B';
    if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(2)}M';
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? Colors.grey[850] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Market Cap', _formatNumber(detail.marketCap)),
            _buildDivider(isDark),
            _buildInfoRow('24h Volume', _formatNumber(detail.volume)),
            _buildDivider(isDark),
            _buildInfoRow(
              'Circulating Supply',
              _formatSupply(detail.circulatingSupply),
            ),
            _buildDivider(isDark),
            _buildInfoRow('Total Supply', _formatSupply(detail.totalSupply)),
            _buildDivider(isDark),
            _buildInfoRow('Max Supply', _formatSupply(detail.maxSupply)),
            if (detail.ath > 0) ...[
              _buildDivider(isDark),
              _buildInfoRow(
                'All-Time High',
                '\$${detail.ath.toStringAsFixed(2)}',
              ),
            ],
            if (detail.athDate.isNotEmpty) ...[
              _buildDivider(isDark),
              _buildInfoRow('ATH Date', detail.athDate),
            ],
            if (detail.startDate.isNotEmpty) ...[
              _buildDivider(isDark),
              _buildInfoRow('Launch Date', detail.startDate),
            ],
            if (detail.platform.isNotEmpty) ...[
              _buildDivider(isDark),
              _buildInfoRow('Platform', detail.platform),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      color: isDark ? Colors.grey[700] : Colors.grey[200],
      height: 1,
    );
  }
}
