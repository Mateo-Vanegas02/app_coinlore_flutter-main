import 'package:flutter/material.dart';
import '../../theme/chart_theme_tokens.dart';

/// Contenedor base visual para todos los gráficos del sistema.
/// Aísla el diseño del marco (título, tarjeta, badge de cambio) y provee
/// el canvas con las dimensiones adecuadas para `graphic`.
class AppChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? badgeText;
  final bool? isPositiveBadge;
  final Widget chart;
  final double height;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const AppChartCard({
    super.key,
    required this.title,
    required this.chart,
    this.subtitle,
    this.badgeText,
    this.isPositiveBadge,
    this.height = 240,
    this.trailing,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ChartThemeTokens.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tokens.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.cardBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: tokens.isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cabecera del gráfico
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: tokens.isDark ? Colors.white : const Color(0xFF1E293B),
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: tokens.axisLabelColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (badgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isPositiveBadge == true
                            ? tokens.bullishColor
                            : isPositiveBadge == false
                                ? tokens.bearishColor
                                : tokens.primaryColor)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (isPositiveBadge == true
                              ? tokens.bullishColor
                              : isPositiveBadge == false
                                  ? tokens.bearishColor
                                  : tokens.primaryColor)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    badgeText!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPositiveBadge == true
                          ? tokens.bullishColor
                          : isPositiveBadge == false
                              ? tokens.bearishColor
                              : tokens.primaryColor,
                    ),
                  ),
                ),
              ],
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),

          // Canvas del Gráfico — ClipRect evita que cualquier hijo se desborde
          ClipRect(
            child: SizedBox(
              height: height,
              width: double.infinity,
              child: chart,
            ),
          ),
        ],
      ),
    );
  }
}
