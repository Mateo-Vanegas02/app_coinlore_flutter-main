import 'package:flutter/material.dart';

/// Tokens de diseño y estilos visuales para los gráficos de la aplicación.
/// Garantiza la coherencia visual con el modo claro y oscuro de CoinLore.
class ChartThemeTokens {
  final bool isDark;

  // Colores semánticos de rendimiento
  final Color bullishColor;
  final Color bearishColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  // Grillas y Ejes
  final Color gridLineColor;
  final Color axisLineColor;
  final Color axisLabelColor;

  // Contenedores y Fondos
  final Color cardBackgroundColor;
  final Color cardBorderColor;
  final Color tooltipBackgroundColor;
  final Color tooltipTextColor;

  // Gradientes
  final Gradient bullishGradient;
  final Gradient bearishGradient;
  final Gradient primaryGradient;

  const ChartThemeTokens._({
    required this.isDark,
    required this.bullishColor,
    required this.bearishColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.gridLineColor,
    required this.axisLineColor,
    required this.axisLabelColor,
    required this.cardBackgroundColor,
    required this.cardBorderColor,
    required this.tooltipBackgroundColor,
    required this.tooltipTextColor,
    required this.bullishGradient,
    required this.bearishGradient,
    required this.primaryGradient,
  });

  factory ChartThemeTokens.fromBrightness({required bool isDark}) {
    final bullish = isDark ? const Color(0xFF00E676) : const Color(0xFF059669);
    final bearish = isDark ? const Color(0xFFFF5252) : const Color(0xFFDC2626);
    final primary = isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    final secondary = isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED);
    final accent = isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7);

    return ChartThemeTokens._(
      isDark: isDark,
      bullishColor: bullish,
      bearishColor: bearish,
      primaryColor: primary,
      secondaryColor: secondary,
      accentColor: accent,
      gridLineColor: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06),
      axisLineColor: isDark
          ? Colors.white.withValues(alpha: 0.15)
          : Colors.black.withValues(alpha: 0.12),
      axisLabelColor: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF6B7280),
      cardBackgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      cardBorderColor: isDark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.black.withValues(alpha: 0.08),
      tooltipBackgroundColor: isDark
          ? const Color(0xFF2A2A2A).withValues(alpha: 0.95)
          : const Color(0xFF1F2937).withValues(alpha: 0.95),
      tooltipTextColor: Colors.white,
      bullishGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          bullish.withValues(alpha: 0.35),
          bullish.withValues(alpha: 0.0),
        ],
      ),
      bearishGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          bearish.withValues(alpha: 0.35),
          bearish.withValues(alpha: 0.0),
        ],
      ),
      primaryGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primary.withValues(alpha: 0.35),
          primary.withValues(alpha: 0.0),
        ],
      ),
    );
  }

  factory ChartThemeTokens.of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ChartThemeTokens.fromBrightness(isDark: isDark);
  }
}
