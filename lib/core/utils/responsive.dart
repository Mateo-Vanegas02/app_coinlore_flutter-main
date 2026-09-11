import 'package:flutter/material.dart';

class Responsive {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // ¿Es móvil? (< 600px)
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  // ¿Es tablet? (600px - 900px)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  // ¿Es desktop? (>= 900px)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  // ¿Es móvil o tablet?
  static bool isMobileOrTablet(BuildContext context) => !isDesktop(context);

  // Escalar valores de padding/margin según el dispositivo
  static double scale(BuildContext context, double base) {
    if (isMobile(context)) return base;
    if (isTablet(context)) return base * 1.25;
    return base * 1.5;
  }

  // Padding horizontal según dispositivo
  static double horizontalPadding(BuildContext context) {
    if (isMobile(context)) return 12;
    if (isTablet(context)) return 16;
    return 24;
  }

  // Ancho máximo para contenido (útil en desktop)
  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    if (isTablet(context)) return 800;
    return double.infinity;
  }

  // Tamaño de fuente escalado
  static double fontSize(BuildContext context, double base) {
    if (isMobile(context)) return base;
    if (isTablet(context)) return base * 1.1;
    return base * 1.2;
  }
}
