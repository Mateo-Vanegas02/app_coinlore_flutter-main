import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/crypto_detail_entity.dart';

class DetailSocialLinks extends StatelessWidget {
  final CryptoDetailEntity detail;

  const DetailSocialLinks({super.key, required this.detail});

  void _launchUrl(String url) async {
    if (url.isEmpty) return;

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasLinks =
        detail.website.isNotEmpty ||
        detail.twitter.isNotEmpty ||
        detail.explorer.isNotEmpty;

    if (!hasLinks) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDark ? Colors.grey[850] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (detail.website.isNotEmpty)
                _buildSocialButton(
                  icon: Icons.language,
                  label: 'Website',
                  onTap: () => _launchUrl(detail.website),
                  isDark: isDark,
                ),
              if (detail.twitter.isNotEmpty)
                _buildSocialButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'Twitter',
                  onTap: () => _launchUrl(detail.twitter),
                  isDark: isDark,
                ),
              if (detail.explorer.isNotEmpty)
                _buildSocialButton(
                  icon: Icons.explore,
                  label: 'Explorer',
                  onTap: () => _launchUrl(detail.explorer),
                  isDark: isDark,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Icon(
              icon,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
