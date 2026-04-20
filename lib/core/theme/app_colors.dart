import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — Teal/Emerald fintech palette
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryDark = Color(0xFF0F766E);
  static const Color primaryLight = Color(0xFF14B8A6);
  static const Color primarySurface = Color(0xFFF0FDFA);
  static const Color accent = Color(0xFFF59E0B);

  // Background
  static const Color backgroundLight = Color(0xFFFAFAF9);
  static const Color backgroundDark = Color(0xFF0C0A09);

  // Surface
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1C1917);

  // Surface Variant
  static const Color surfaceVariantLight = Color(0xFFF5F5F4);
  static const Color surfaceVariantDark = Color(0xFF292524);

  // Card
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1C1917);

  // Text
  static const Color textPrimaryLight = Color(0xFF1C1917);
  static const Color textPrimaryDark = Color(0xFFFAFAF9);
  static const Color textSecondaryLight = Color(0xFF78716C);
  static const Color textSecondaryDark = Color(0xFFC8C4BF);
  static const Color textTertiaryLight = Color(0xFFA8A29E);
  static const Color textTertiaryDark = Color(0xFF8A857F);

  // Divider & Border
  static const Color dividerLight = Color(0xFFE7E5E4);
  static const Color dividerDark = Color(0xFF3A3530);
  static const Color borderLight = Color(0xFFD6D3D1);
  static const Color borderDark = Color(0xFF44403C);

  // Status
  static const Color positive = Color(0xFF10B981);
  static const Color positiveLight = Color(0xFFD1FAE5);
  static const Color negative = Color(0xFFEF4444);
  static const Color negativeLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF0D9488);

  // Dark mode primary (brighter for contrast)
  static const Color primaryLightDark = Color(0xFF2DD4BF);
  static const Color primarySurfaceDark = Color(0xFF042F2E);

  // Disabled
  static const Color disabledLight = Color(0xFFD6D3D1);
  static const Color disabledDark = Color(0xFF44403C);

  // On-primary (dark mode)
  static const Color onPrimaryDark = Color(0xFF042F2E); // teal-950

  // Shadows (light mode only)
  static List<BoxShadow> get shadowSm => [
        const BoxShadow(
          color: Color(0x08000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        const BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        const BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ];

  // Dark shadows (subtle, for dark mode)
  static List<BoxShadow> get shadowSmDark => [
        const BoxShadow(
          color: Color(0x14000000),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowMdDark => [
        const BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowLgDark => [
        const BoxShadow(
          color: Color(0x21000000),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ];

  // Dark mode negative light background
  static const Color negativeLightDark = Color(0xFF3B1111);

  // Favorite star icon
  static const Color favoriteColor = Color(0xFFFFC107);
  static const Color favoriteColorDark = Color(0xFFFFCA28);
}
